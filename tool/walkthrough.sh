#!/bin/zsh
# Runs integration_test/walkthrough_test.dart on a booted simulator or
# emulator against live data. It takes a screenshot at each SHOT: marker,
# writes SEM:<name>: lines to sem_<name>.txt, grants location on
# GRANT_LOCATION, and applies SET: requests (dark mode, text size).
#
# usage: tool/walkthrough.sh <ios|android> <device-id> <output-dir> [flutter args...]
#
# Set the device location to downtown Seattle first, for example:
#   xcrun simctl location <udid> set 47.6097,-122.3331
#   adb -s <serial> emu geo fix -122.3331 47.6097
setopt pipefail
if (( $# < 3 )); then
  print -u2 "usage: $0 <ios|android> <device-id> <output-dir> [flutter args...]"
  exit 64
fi
PLATFORM=$1; DEV=$2; OUT=${3:a}; shift 3
mkdir -p $OUT
ADB=${ADB:-${ANDROID_HOME:-$HOME/Library/Android/sdk}/platform-tools/adb}
cd ${0:a:h}/..
mise exec -- flutter test integration_test/walkthrough_test.dart -d $DEV "$@" 2>&1 | while IFS= read -r line; do
  print -r -- "$line" >> $OUT/log.txt
  case "$line" in
    *SHOT:*)
      name=${line##*SHOT:}; name=${name%%[[:space:]]*}
      if [[ $PLATFORM == ios ]]; then
        xcrun simctl io $DEV screenshot $OUT/$name.png >/dev/null 2>&1
      else
        $ADB -s $DEV exec-out screencap -p > $OUT/$name.png
      fi
      sips -Z 900 $OUT/$name.png >/dev/null 2>&1 ;;
    *SEM:*)
      rest=${line#*SEM:}; name=${rest%%:*}; print -r -- "${rest#*:}" >> $OUT/sem_$name.txt ;;
    *GRANT_LOCATION*)
      if [[ $PLATFORM == android ]]; then
        $ADB -s $DEV shell pm grant org.onebusaway.oba_dart android.permission.ACCESS_FINE_LOCATION
        $ADB -s $DEV shell pm grant org.onebusaway.oba_dart android.permission.ACCESS_COARSE_LOCATION
      else
        xcrun simctl privacy $DEV grant location org.onebusaway.obaDart
      fi ;;
    *SET:*)
      setting=${line##*SET:}; setting=${setting%%[[:space:]]*}
      if [[ $PLATFORM == ios ]]; then
        case $setting in
          dark) xcrun simctl ui $DEV appearance dark ;;
          light) xcrun simctl ui $DEV appearance light ;;
          bigtext) xcrun simctl ui $DEV content_size accessibility-extra-large ;;
          normaltext) xcrun simctl ui $DEV content_size large ;;
        esac
      else
        case $setting in
          dark) $ADB -s $DEV shell cmd uimode night yes ;;
          light) $ADB -s $DEV shell cmd uimode night no ;;
          bigtext) $ADB -s $DEV shell settings put system font_scale 2.0 ;;
          normaltext) $ADB -s $DEV shell settings put system font_scale 1.0 ;;
        esac
      fi ;;
  esac
done
rc=$?
print -r -- "exit: $rc" >> $OUT/log.txt
exit $rc
