#!/bin/zsh
# Runs the app in its own iOS simulator, separate from any simulator used
# for the walkthrough or other work. The simulator is created on first use
# and reused afterwards.
#
# usage: tool/run_ios_sim.sh [--reset] [--no-run] [--force] [--location lat,lon] [flutter run args...]
#
#   --reset           erase the simulator first (fresh install, onboarding again)
#   --no-run          create, boot and set up the simulator, then stop
#   --location a,b    simulated location (default: downtown Seattle)
#   --force           run even if another Flutter build or test is in progress
#
# Environment:
#   OBA_SIM_NAME      simulator name (default: "OBA Flutter Dev")
#   OBA_SIM_DEVICE    device type to create, e.g. "iPhone 17" (default: newest iPhone Pro)
#
# Examples:
#   tool/run_ios_sim.sh
#   tool/run_ios_sim.sh --reset --location 32.8801,-117.2340
#   tool/run_ios_sim.sh --dart-define=OBA_API_KEY=mykey
set -e

NAME=${OBA_SIM_NAME:-OBA Flutter Dev}
LOCATION=47.6097,-122.3331
RESET=0
RUN=1
FORCE=0
while (( $# )); do
  case $1 in
    --reset) RESET=1; shift ;;
    --no-run) RUN=0; shift ;;
    --force) FORCE=1; shift ;;
    --location) LOCATION=$2; shift 2 ;;
    -h|--help) sed -n '2,20p' $0 | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) break ;;
  esac
done

cd ${0:a:h}/..

# Another Flutter iOS build from this checkout shares build/ios with this
# one, and the two would break each other.
if (( RUN && ! FORCE )); then
  # Android runs (-d emulator-NNNN, or a build of an apk or appbundle) use
  # build/app, so they are left alone.
  other=$(pgrep -fl "flutter_tools.*(test|run|build)" | grep -v "pgrep" |
    grep -Ev -- "-d emulator-|build (apk|appbundle|aar)" || true)
  if [[ -n $other ]]; then
    print -u2 "Another Flutter build or test that may use build/ios is running:"
    print -u2 "$other" | cut -c1-160
    print -u2 "Wait for it to finish, then run this again (or pass --force if it is unrelated)."
    exit 1
  fi
fi

# Find the simulator by name, or create it on the newest installed iOS.
udid=$(xcrun simctl list devices -j | python3 -c '
import json, sys
name = sys.argv[1]
for devices in json.load(sys.stdin)["devices"].values():
    for d in devices:
        if d["name"] == name and d.get("isAvailable"):
            print(d["udid"]); sys.exit()
' "$NAME")

if [[ -z $udid ]]; then
  # Newest installed iOS runtime, and a device type that runtime supports.
  pair=$(xcrun simctl list runtimes -j | python3 -c '
import json, os, re, sys
ios = [r for r in json.load(sys.stdin)["runtimes"]
       if r.get("isAvailable") and r.get("platform") == "iOS"]
if not ios:
    sys.exit("No iOS simulator runtime is installed. Install one in Xcode > Settings > Components.")
want = os.environ.get("OBA_SIM_DEVICE")
def number(t):
    m = re.fullmatch(r"iPhone (\d+) Pro", t["name"])
    return int(m.group(1)) if m else -1
# Several runtimes can share a version and support different devices, so
# choose the runtime and device together: newest iOS, then newest iPhone Pro.
candidates = []
for r in ios:
    version = [int(p) for p in r["version"].split(".")]
    for t in r.get("supportedDeviceTypes", []):
        if want:
            if t["name"] == want:
                candidates.append((version, 0, r, t))
        elif number(t) >= 0:
            candidates.append((version, number(t), r, t))
if not candidates:
    sys.exit("No installed iOS runtime supports %s. See: xcrun simctl list devicetypes"
             % (repr(want) if want else "an iPhone Pro; set OBA_SIM_DEVICE"))
_, _, runtime, best = max(candidates, key=lambda c: (c[0], c[1]))
print(runtime["identifier"], best["identifier"])
')
  runtime=${pair%% *}
  device=${pair##* }
  udid=$(xcrun simctl create "$NAME" "$device" "$runtime")
  print "Created simulator \"$NAME\" ($udid)"
fi

if (( RESET )); then
  xcrun simctl shutdown $udid 2>/dev/null || true
  xcrun simctl erase $udid
  print "Erased \"$NAME\""
fi

xcrun simctl bootstatus $udid -b >/dev/null
# Show the window. Older Xcodes ship Simulator.app; newer ones show
# simulators in Device Hub, inside the selected Xcode.
xcode_apps=${$(xcode-select -p):h}/Applications
open -a Simulator --args -CurrentDeviceUDID $udid 2>/dev/null ||
  open "$xcode_apps/DeviceHub.app" 2>/dev/null ||
  print -u2 "Could not open a simulator window; the device is booted anyway."
xcrun simctl location $udid set $LOCATION
print "Simulator \"$NAME\" is booted at $LOCATION ($udid)"

if (( RUN )); then
  mise exec -- flutter pub get
  exec mise exec -- flutter run -d $udid "$@"
fi
