// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class ObaLocalizationsKo extends ObaLocalizations {
  ObaLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get commonBack => '뒤로';

  @override
  String get commonClose => '닫기';

  @override
  String get commonDone => '완료';

  @override
  String get commonCancel => '취소';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonContinue => '계속';

  @override
  String get commonNotNow => '나중에';

  @override
  String get commonSeeAll => '모두 보기';

  @override
  String get commonLoading => '불러오는 중';

  @override
  String get commonErrorTitle => '문제가 발생했습니다';

  @override
  String get commonEmptyTitle => '아직 아무것도 없습니다';

  @override
  String get commonComingSoon => '곧 제공 예정';

  @override
  String get commonComingSoonBody => '이 화면은 아직 사용할 수 없습니다.';

  @override
  String get commonOffline => '오프라인 상태인 것 같습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String get commonServerError => '서버가 예상대로 응답하지 않았습니다. 잠시 후 다시 시도하세요.';

  @override
  String get sheetLabel => '패널';

  @override
  String get sheetExpand => '패널 펼치기';

  @override
  String get sheetCollapse => '패널 접기';

  @override
  String get sheetHandleHint => '드래그하거나 두 번 탭하여 패널 크기를 조절합니다';

  @override
  String get homeTabHome => '홈';

  @override
  String get homeTabRecent => '최근';

  @override
  String get homeTabBookmarks => '즐겨찾기';

  @override
  String get homeSearchPlaceholder => '정류장, 노선, 장소 검색';

  @override
  String get homeSearchLabel => '검색';

  @override
  String get homeSectionNearby => '주변';

  @override
  String get homeSectionRecent => '최근 정류장';

  @override
  String get homeSectionBookmarks => '즐겨찾기';

  @override
  String get homeSectionAlerts => '알림';

  @override
  String get homeSectionExplore => '둘러보기';

  @override
  String get homeSectionMore => '설정 및 더보기';

  @override
  String get mapLabel => '지도';

  @override
  String get mapZoomInForStops => '정류장을 보려면 확대하세요';

  @override
  String get mapLocationDenied => '위치 접근이 꺼져 있습니다. 탭하여 허용하세요.';

  @override
  String get mapLocationServicesOff => '위치 서비스가 꺼져 있습니다';

  @override
  String get mapRecenter => '내 위치 보기';

  @override
  String get mapSettingsButton => '지도 설정';

  @override
  String get mapStopsListButton => '지도의 정류장';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '지도에 정류장 $count개',
      one: '지도에 정류장 $count개',
      zero: '지도에 정류장 없음',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => '내 위치';

  @override
  String get mapDroppedPin => '고정한 핀';

  @override
  String get mapVehicle => '차량';

  @override
  String get mapSelectedStop => '선택됨';

  @override
  String get mapBookmarkedStop => '즐겨찾기에 추가됨';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, $routeType 정류장';
  }

  @override
  String get mapStopMarkerHint => '정류장의 출발 정보를 엽니다';

  @override
  String mapAttribution(String attribution) {
    return '지도 데이터: $attribution';
  }

  @override
  String get mapTypeTitle => '지도 유형';

  @override
  String get mapTypeStandard => '일반';

  @override
  String get mapTypeSatellite => '위성';

  @override
  String get mapTypeHybrid => '하이브리드';

  @override
  String get mapShowScale => '축척 표시';

  @override
  String get mapShowHeading => '방향 표시';

  @override
  String get mapShowStopLabels => '정류장 이름 표시';

  @override
  String mapPlaceAt(String lat, String lon) {
    return '위치: $lat, $lon';
  }

  @override
  String get directionN => '북쪽 방면';

  @override
  String get directionNE => '북동쪽 방면';

  @override
  String get directionE => '동쪽 방면';

  @override
  String get directionSE => '남동쪽 방면';

  @override
  String get directionS => '남쪽 방면';

  @override
  String get directionSW => '남서쪽 방면';

  @override
  String get directionW => '서쪽 방면';

  @override
  String get directionNW => '북서쪽 방면';

  @override
  String get routeTypeBus => '버스';

  @override
  String get routeTypeLightRail => '경전철';

  @override
  String get routeTypeSubway => '지하철';

  @override
  String get routeTypeRail => '열차';

  @override
  String get routeTypeFerry => '여객선';

  @override
  String get routeTypeCableCar => '케이블카';

  @override
  String get routeTypeGondola => '곤돌라';

  @override
  String get routeTypeFunicular => '푸니쿨라';

  @override
  String get routeTypeUnknown => '대중교통';

  @override
  String stopCode(String code) {
    return '정류장 $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return '노선 $routes';
  }

  @override
  String get stopPageRefresh => '새로고침';

  @override
  String get stopPageRefreshed => '출발 정보가 업데이트되었습니다';

  @override
  String get stopPageBookmark => '정류장 즐겨찾기';

  @override
  String get stopPageBookmarked => '즐겨찾기에 추가됨. 즐겨찾기 편집';

  @override
  String get stopPageMoreActions => '정류장 추가 작업';

  @override
  String get stopPageSchedules => '시간표';

  @override
  String get stopPageServiceAlerts => '운행 알림';

  @override
  String get stopPageNearbyStops => '주변 정류장';

  @override
  String get stopPageWalkingDirections => '도보 길찾기';

  @override
  String get stopPageBikeDirections => '자전거 길찾기';

  @override
  String get stopPagePlanTripFrom => '여기서 출발하는 경로 계획';

  @override
  String get stopPagePlanTripTo => '여기로 가는 경로 계획';

  @override
  String get stopPageShareStop => '정류장 공유';

  @override
  String get stopPageReportProblem => '문제 신고';

  @override
  String get stopPageFilterRoutes => '노선 필터';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '노선 $count개 숨김',
      one: '노선 $count개 숨김',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => '시간순';

  @override
  String get stopPageModeRoute => '노선별';

  @override
  String get stopPageDepartureTypes => '출발 유형';

  @override
  String get stopPageFilterAll => '모든 출발';

  @override
  String get stopPageFilterRealtime => '실시간만';

  @override
  String get stopPageFilterScheduled => '시간표만';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '지난 출발 $count개 보기',
      one: '지난 출발 $count개 보기',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => '지난 출발 숨기기';

  @override
  String get stopPageLoadMore => '출발 더 불러오기';

  @override
  String stopPageWindow(int minutes) {
    return '다음 $minutes분 표시 중';
  }

  @override
  String stopPageUpdated(String ago) {
    return '$ago 업데이트됨';
  }

  @override
  String get stopPageStaleTitle => '출발 정보를 새로고침할 수 없습니다';

  @override
  String get stopPageStaleBody => '이 시간은 최신 정보가 아닐 수 있습니다.';

  @override
  String get stopPageEmptyTitle => '예정된 출발이 없습니다';

  @override
  String stopPageEmptyBody(int minutes) {
    return '다음 $minutes분 동안 출발하는 차량이 없습니다.';
  }

  @override
  String get stopPageEmptyHiddenRoutes => '이곳에 출발이 있는 모든 노선이 숨겨져 있습니다.';

  @override
  String get stopPageShowAllRoutes => '모든 노선 표시';

  @override
  String get stopPageEmptyFilter => '출발 유형 필터와 일치하는 출발이 없습니다.';

  @override
  String get stopPageShowAllTypes => '모든 출발 표시';

  @override
  String get stopPageMissingTitle => '정류장을 찾을 수 없습니다';

  @override
  String get stopPageMissingBody => '이 정류장이 삭제되었거나 번호가 변경되었을 수 있습니다.';

  @override
  String stopPageWalkTime(int minutes) {
    return '도보 $minutes분';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '자전거 $minutes분';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '도보 $minutes분',
      one: '도보 $minutes분',
    );
    return '$_temp0, $distance. 길찾기를 엽니다.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '자전거 $minutes분',
      one: '자전거 $minutes분',
    );
    return '$_temp0, $distance. 길찾기를 엽니다.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '이 정류장까지 도보 $minutes분. 위의 출발 차량이 더 일찍 떠납니다.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '이 정류장까지 자전거 $minutes분. 위의 출발 차량이 더 일찍 떠납니다.';
  }

  @override
  String stopPageAgencies(String names) {
    return '운영: $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '운행 알림 $count개',
      one: '운행 알림 $count개',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '읽지 않음 $count개',
      one: '읽지 않음 $count개',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => '읽지 않음';

  @override
  String get stopPageAlertImportant => '중요';

  @override
  String get stopPageDirectionsChooser => '길찾기 열기';

  @override
  String get stopPageAppleMaps => 'Apple 지도';

  @override
  String get stopPageGoogleMaps => 'Google 지도';

  @override
  String get stopPageCannotOpen => '링크를 열 수 없습니다.';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return '$route $headsign에서 환승, $time 도착';
  }

  @override
  String get stopPageDeparturesHeader => '출발';

  @override
  String get stopRowNow => '지금';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String get stopRowOnTime => '정시';

  @override
  String stopRowLate(int minutes) {
    return '$minutes분 지연';
  }

  @override
  String stopRowEarly(int minutes) {
    return '$minutes분 일찍';
  }

  @override
  String get stopRowScheduled => '예정';

  @override
  String get stopRowCanceled => '취소됨';

  @override
  String get stopRowOccupancyEmpty => '비어 있음';

  @override
  String get stopRowOccupancyManySeats => '좌석 여유 많음';

  @override
  String get stopRowOccupancyFewSeats => '좌석 여유 적음';

  @override
  String get stopRowOccupancyStanding => '입석만 가능';

  @override
  String get stopRowOccupancyCrushed => '매우 혼잡';

  @override
  String get stopRowOccupancyFull => '만석';

  @override
  String get stopRowOccupancyNotAccepting => '승객 탑승 불가';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 후 도착',
      one: '$minutes분 후 도착',
      zero: '지금 도착',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 후 출발',
      one: '$minutes분 후 출발',
      zero: '지금 출발',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 전에 도착함',
      one: '$minutes분 전에 도착함',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 전에 출발함',
      one: '$minutes분 전에 출발함',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yLabel(
    String route,
    String headsign,
    String eta,
    String time,
    String status,
  ) {
    return '$headsign 방면 $route 노선, $eta, $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return '실시간 추적, $status';
  }

  @override
  String get stopRowA11yScheduledOnly => '예정 시각만 제공, 실시간 정보 없음';

  @override
  String get stopRowA11yTransfer => '환승할 운행';

  @override
  String get stopRowA11yMissed => '도보로 도착하기 전에 출발하므로 놓칠 가능성이 높습니다';

  @override
  String get stopRowA11yAlarm => '미리 알림 설정됨';

  @override
  String stopRowActions(String route) {
    return '$route 노선 추가 작업';
  }

  @override
  String get stopRowShowTrip => '운행 상세 정보 보기';

  @override
  String get stopRowAddAlarm => '미리 알림 추가';

  @override
  String get stopRowRemoveAlarm => '미리 알림 삭제';

  @override
  String get stopRowBookmarkTrip => '이 운행 즐겨찾기';

  @override
  String get stopRowShareTrip => '운행 공유';

  @override
  String get stopRowRouteSchedule => '노선 시간표';

  @override
  String get stopRowRouteStops => '이 노선의 정류장';

  @override
  String stopRouteGroupNext(String times) {
    return '다음: $times';
  }

  @override
  String stopRouteGroupLabel(
    String route,
    String headsigns,
    int count,
    String eta,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '출발 $count회',
      one: '출발 $count회',
    );
    return '$headsigns 방면 $route 노선, $_temp0, 다음 $eta';
  }

  @override
  String get stopAlarmPickerTitle => '출발 전에 알려 주세요';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 전',
      one: '$minutes분 전',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 전 미리 알림 설정됨',
      one: '$minutes분 전 미리 알림 설정됨',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => '미리 알림이 삭제되었습니다';

  @override
  String get stopAlarmFailed => '미리 알림을 업데이트할 수 없습니다.';

  @override
  String get stopAlarmPermissionDenied => '이 앱의 알림이 꺼져 있습니다.';

  @override
  String get stopFilterTitle => '노선 필터';

  @override
  String get stopFilterSort => '출발 정렬';

  @override
  String get stopFilterRoutesHeader => '이 정류장에 표시할 노선';

  @override
  String get stopFilterShowAll => '모든 노선 표시';

  @override
  String get stopTripArrivingAtYourStop => '내 정류장에 도착 중';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count정류장 전',
      one: '$count정류장 전',
      zero: '내 정류장',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return '$distance 떨어짐';
  }

  @override
  String stopTripAtStop(String stop) {
    return '$stop에 위치';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return '위치 업데이트: $ago';
  }

  @override
  String get stopTripNoPosition => '이 차량의 실시간 위치 정보가 없습니다';

  @override
  String stopTripStartsAs(String trip) {
    return '$trip(으)로 시작';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return '$trip(으)로 계속 운행';
  }

  @override
  String get stopTripStopsHeader => '정류장';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '지나간 정류장 $count개',
      one: '지나간 정류장 $count개',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '내 정류장 전 $count정류장',
      one: '내 정류장 전 $count정류장',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => '내 정류장';

  @override
  String get stopTripBoarding => '탑승 중';

  @override
  String get stopTripVehicleHere => '차량이 도착했습니다';

  @override
  String get stopTripTerminal => '종점';

  @override
  String get stopTripPassed => '지나감';

  @override
  String get stopTripRouteStops => '이 노선의 모든 정류장';

  @override
  String get stopTripReport => '이 운행의 문제 신고';

  @override
  String get stopTripGhostBus => '유령 버스 신고';

  @override
  String get stopTripCanceled => '이 운행은 취소되었습니다';

  @override
  String stopTripVehicleLabel(String route) {
    return '$route 노선 차량';
  }

  @override
  String stopTripFrequency(int minutes) {
    return '$minutes분 간격';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return '$route 노선';
  }

  @override
  String get stopRouteStopsDirection => '방향';

  @override
  String stopRouteStopsToward(String name) {
    return '$name 방면';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '정류장 $count개',
      one: '정류장 $count개',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => '이 노선의 정류장을 찾을 수 없습니다.';

  @override
  String get stopSchedPrevDay => '이전 날';

  @override
  String get stopSchedNextDay => '다음 날';

  @override
  String stopSchedPickDate(String date) {
    return '날짜 선택, $date';
  }

  @override
  String get stopSchedRoute => '노선';

  @override
  String get stopSchedDirection => '방향';

  @override
  String get stopSchedStop => '정류장';

  @override
  String get stopSchedEmpty => '이 날은 운행 예정이 없습니다.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return '$start부터 $end까지 $minutes분 간격';
  }

  @override
  String stopSchedTo(String headsign) {
    return '$headsign 방면';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '출발 $count회',
      one: '출발 $count회',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported => '이 지역에서는 시간표를 제공하지 않습니다.';

  @override
  String get stopSchedViewList => '목록';

  @override
  String get stopSchedViewGrid => '표';

  @override
  String get stopSchedNoDeparture => '출발 없음';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop(내 정류장)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, 운행 $trip: $time';
  }

  @override
  String get stopReportProblemHeader => '어떤 문제가 있나요?';

  @override
  String get stopReportStopNameWrong => '정류장 이름이 잘못되었습니다';

  @override
  String get stopReportStopNumberWrong => '정류장 번호가 잘못되었습니다';

  @override
  String get stopReportStopLocationWrong => '정류장 위치가 잘못되었습니다';

  @override
  String get stopReportRouteMissing => '노선 또는 운행이 누락되었습니다';

  @override
  String get stopReportOther => '기타';

  @override
  String get stopReportNeverCame => '차량이 오지 않았습니다';

  @override
  String get stopReportCameEarly => '일찍 왔습니다';

  @override
  String get stopReportCameLate => '늦게 왔습니다';

  @override
  String get stopReportWrongHeadsign => '행선지 표시가 잘못되었습니다';

  @override
  String get stopReportNotStopHere => '여기에 정차하지 않았습니다';

  @override
  String get stopReportComment => '추가 의견(선택사항)';

  @override
  String get stopReportShareLocation => '내 위치 공유';

  @override
  String get stopReportShareLocationHelp =>
      '위치를 공유하면 운영 기관이 문제를 해결하는 데 도움이 됩니다.';

  @override
  String get stopReportOnVehicle => '이 차량에 탑승 중입니다';

  @override
  String get stopReportVehicleId => '차량 번호(선택사항)';

  @override
  String get stopReportSend => '신고 보내기';

  @override
  String get stopReportSending => '신고를 보내는 중';

  @override
  String get stopReportSent => '감사합니다! 신고가 전송되었습니다.';

  @override
  String get stopReportFailed => '신고를 보낼 수 없습니다. 다시 시도하세요.';

  @override
  String get stopReportChooseProblem => '먼저 문제를 선택하세요.';

  @override
  String stopReportAbout(String name) {
    return '신고 대상: $name';
  }

  @override
  String get stopGhostTitle => '유령 버스 신고';

  @override
  String get stopGhostExplain => '유령 버스란 앱에 표시되었지만 실제로는 오지 않은 버스를 말합니다.';

  @override
  String get stopGhostWait => '예정 시각 이후 얼마나 기다렸나요?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30분 이상';

  @override
  String get stopCardEmpty => '곧 출발하는 차량 없음';

  @override
  String get titleSearch => '검색';

  @override
  String get titleSearchResults => '검색 결과';

  @override
  String get titleNearbyStops => '주변 정류장';

  @override
  String get titleRecentStops => '최근 정류장';

  @override
  String get titleBookmarks => '즐겨찾기';

  @override
  String get titleStop => '정류장';

  @override
  String get titleTrip => '운행';

  @override
  String get titleRouteStops => '노선';

  @override
  String get titleStopSchedule => '시간표';

  @override
  String get titleRouteSchedule => '노선 시간표';

  @override
  String get titleAlerts => '알림';

  @override
  String get titleAlertDetail => '알림';

  @override
  String get titleAgencies => '운영 기관';

  @override
  String get titleRegionPicker => '지역';

  @override
  String get titleCustomRegion => '사용자 지정 지역';

  @override
  String get titleSettings => '설정';

  @override
  String get titleMapSettings => '지도 설정';

  @override
  String get titleMore => '더보기';

  @override
  String get titleTripPlanner => '경로 계획';

  @override
  String get titlePlace => '장소';

  @override
  String get titleReportStopProblem => '문제 신고';

  @override
  String get titleReportTripProblem => '문제 신고';

  @override
  String get titleBookmarkEditor => '즐겨찾기';

  @override
  String get titleManageBookmarks => '즐겨찾기 편집';

  @override
  String get titleCredits => '크레딧';

  @override
  String get titleWeather => '날씨';

  @override
  String get titleStopsOnMap => '지도의 정류장';

  @override
  String onboardingWelcomeTitle(String appName) {
    return '$appName에 오신 것을 환영합니다';
  }

  @override
  String get onboardingWelcomeBody => '주변 버스, 열차, 여객선의 실시간 도착 정보를 확인하세요.';

  @override
  String get onboardingLocationTitle => '주변 정류장 찾기';

  @override
  String get onboardingLocationBody =>
      '위치 접근을 허용하면 주변 정류장을 보고 지역을 자동으로 선택할 수 있습니다.';

  @override
  String get onboardingAllowLocation => '위치 접근 허용';

  @override
  String get onboardingRegionTitle => '지역 선택';

  @override
  String get onboardingRegionBody => '대중교통 정보를 보려는 지역을 선택하세요.';

  @override
  String get settingsSectionMap => '지도';

  @override
  String get settingsMapTypeRow => '지도 유형 및 레이어';

  @override
  String get settingsMapTypeHelp => '지도 모양을 선택하세요.';

  @override
  String get settingsHeadingHelp => '지도에 내가 향하고 있는 방향을 표시합니다.';

  @override
  String get settingsStopLabelsHelp => '지도에서 정류장 옆에 노선 이름을 표시합니다.';

  @override
  String get settingsWalkingDirections => '도보 길찾기';

  @override
  String get settingsWalkingDirectionsHelp => '정류장까지 도보 길찾기를 요청할 때 열리는 앱입니다.';

  @override
  String get settingsDirectionsAsk => '매번 묻기';

  @override
  String get settingsDirectionsAppleMaps => 'Apple 지도';

  @override
  String get settingsDirectionsGoogleMaps => 'Google 지도';

  @override
  String get settingsSectionDepartures => '출발';

  @override
  String get settingsDepartureFilter => '출발 표시';

  @override
  String get settingsDepartureFilterHelp =>
      '정류장 페이지에 모든 출발을 표시할지, 실시간 또는 시간표 데이터가 있는 출발만 표시할지 선택하세요.';

  @override
  String get settingsFilterAll => '모든 출발';

  @override
  String get settingsFilterRealtime => '실시간만';

  @override
  String get settingsFilterScheduled => '시간표만';

  @override
  String get settingsRegionTimeZone => '지역 시간대로 시간 표시';

  @override
  String get settingsRegionTimeZoneHelp =>
      '시각은 교통 지역의 시간대를 사용하며, 기기와 다를 경우 안내가 표시됩니다.';

  @override
  String get settingsSectionAccessibility => '접근성';

  @override
  String get settingsReducedColors => '정류장 페이지 색상 줄이기';

  @override
  String get settingsReducedColorsHelp => '노선 배지를 하나의 중립적인 스타일로 표시합니다.';

  @override
  String get settingsCompactMode => '간결한 정류장 및 운행 페이지';

  @override
  String get settingsCompactModeHelp => '여백을 줄여 화면에 더 많은 내용을 표시합니다.';

  @override
  String get settingsSectionWalking => '걷는 속도';

  @override
  String get settingsWalkingSpeed => '걷는 속도';

  @override
  String get settingsWalkingSpeedHelp => '도보 시간과 도착 시간을 추정하는 데 사용됩니다.';

  @override
  String get settingsSpeedSlow => '느림';

  @override
  String get settingsSpeedAverage => '보통';

  @override
  String get settingsSpeedFast => '빠름';

  @override
  String settingsSpeedCustom(String speed) {
    return '사용자 지정(${speed}m/s)';
  }

  @override
  String get settingsSectionBike => '자전거 모드';

  @override
  String get settingsBikeMode => '자전거 모드';

  @override
  String get settingsBikeModeHelp =>
      '도보 시간 추정, 도착 시간, 정류장 페이지에 더 빠른 이동 속도를 사용합니다.';

  @override
  String get settingsSectionSurveys => '설문조사';

  @override
  String get settingsSurveysEnabled => '설문조사 표시';

  @override
  String get settingsSurveysAlways => '정류장에서 항상 설문조사 표시';

  @override
  String get settingsSectionPrivacy => '개인정보 보호';

  @override
  String get settingsAnalytics => '개발자에게 사용 데이터 보내기';

  @override
  String get settingsAnalyticsHelp => '개발자가 어떤 기능이 사용되는지 파악하는 데 도움이 됩니다.';

  @override
  String get settingsSectionDebug => '디버그';

  @override
  String get settingsDebugMode => '디버그 모드';

  @override
  String get settingsDebugAlwaysFeedback => '피드백 요청 항상 표시';

  @override
  String get settingsDebugResetFeedback => '피드백 요청 상태 초기화';

  @override
  String get settingsDebugResetDonation => '기부 카드 상태 초기화';

  @override
  String get settingsDebugResetDone => '초기화됨';

  @override
  String get settingsSectionTripPlanner => '경로 계획';

  @override
  String get settingsHomeCustomizeMap => '지도 맞춤 설정';

  @override
  String get moreHeaderSupport => '이 앱은 자원봉사자들이 만들고 지원합니다.';

  @override
  String get moreSectionDonate => '후원하기';

  @override
  String moreDonate(String appName) {
    return '$appName에 기부';
  }

  @override
  String get moreManageDonations => '기부 관리';

  @override
  String get moreSectionUpdates => '업데이트 및 알림';

  @override
  String get moreAlerts => '알림';

  @override
  String get moreSectionLocation => '내 위치';

  @override
  String get moreRegion => '지역';

  @override
  String get moreRegionNone => '선택 안 됨';

  @override
  String get morePayFare => '요금 결제';

  @override
  String get moreAgencies => '운영 기관';

  @override
  String get moreSectionAbout => '앱 정보';

  @override
  String moreRateApp(String appName) {
    return '$appName 평가';
  }

  @override
  String get moreContactUs => '문의하기';

  @override
  String get morePrivacy => '개인정보 처리방침';

  @override
  String get moreCredits => '크레딧';

  @override
  String moreVersion(String appName, String version) {
    return '$appName 버전 $version';
  }

  @override
  String get moreSectionHelpOut => '앱 개선에 참여하기';

  @override
  String get moreTranslate => '앱 번역 돕기';

  @override
  String get moreDevelop => '버그 수정과 새 기능 개발 돕기';

  @override
  String get moreSectionContact => '문의 및 도움말';

  @override
  String get moreTutorials => '사용 안내';

  @override
  String get moreCallAgency => '운영 기관에 전화';

  @override
  String get moreTextAgency => '운영 기관에 문자';

  @override
  String get moreSectionResources => '자료';

  @override
  String get moreContactTitle => '문의하기';

  @override
  String get moreContactDevelopers => '기능 요청 또는 버그 신고';

  @override
  String get moreContactAgency => '차량 또는 시간표 문제';

  @override
  String moreEmailSubject(String appName) {
    return '$appName 의견';
  }

  @override
  String get moreEmailAgencySubject => '대중교통 이용자 의견';

  @override
  String get moreEmailIntro => '무엇을 도와드릴까요? 아래에 내용을 입력해 주세요.';

  @override
  String get moreEmailDebugIntro =>
      '다음 정보는 문제 해결을 위해 제공됩니다. 공유하고 싶지 않은 정보는 삭제할 수 있지만, 도움을 드리기 어려워질 수 있습니다.';

  @override
  String get moreDebugAppVersion => '앱 버전';

  @override
  String get moreDebugOs => '운영체제';

  @override
  String get moreDebugLocale => '언어';

  @override
  String get moreDebugBookmarks => '즐겨찾기 수';

  @override
  String get moreDebugLocationPermission => '위치 권한';

  @override
  String get moreDebugRegion => '지역';

  @override
  String get moreDebugRegionId => '지역 ID';

  @override
  String get moreDebugApiUrl => '기본 API URL';

  @override
  String get moreDebugUserId => '사용자 ID';

  @override
  String get moreCantEmailTitle => '이메일 앱을 열 수 없습니다';

  @override
  String moreCantEmailBody(String email) {
    return '문의하려면 $email(으)로 이메일을 보내 주세요. 디버그 정보를 복사하여 메시지에 붙여넣으면 문제 해결에 도움이 됩니다.';
  }

  @override
  String get moreCopyEmail => '이메일 주소 복사';

  @override
  String get moreCopyDebug => '디버그 정보 복사';

  @override
  String get moreCopied => '클립보드에 복사됨';

  @override
  String get moreFareContinue => '계속';

  @override
  String get moreFareDontShowAgain => '계속하고 다시 표시 안 함';

  @override
  String get moreCantOpenLink => '링크를 열 수 없습니다.';

  @override
  String get regionPickerAutomatic => '지역 자동 선택';

  @override
  String get regionPickerAutomaticHelp =>
      '현재 위치가 속한 지역으로 전환합니다. 직접 지역을 선택하면 이 기능이 꺼집니다.';

  @override
  String get regionPickerShowExperimental => '실험 지역 표시';

  @override
  String get regionPickerShowInactive => '비활성 지역 표시';

  @override
  String get regionPickerRegionsSection => '지역';

  @override
  String get regionPickerCustomSection => '사용자 지정 지역';

  @override
  String get regionPickerCurrent => '현재 지역';

  @override
  String get regionPickerExperimentalTag => '실험';

  @override
  String get regionPickerInactiveTag => '비활성';

  @override
  String get regionPickerCustomTag => '사용자 지정';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => '사용자 지정 지역 추가';

  @override
  String get regionPickerRefresh => '지역 새로고침';

  @override
  String get regionPickerRefreshed => '지역이 업데이트되었습니다';

  @override
  String get regionPickerRefreshFailed => '지역 목록을 업데이트할 수 없습니다. 저장된 목록을 표시합니다.';

  @override
  String regionPickerSelected(String name) {
    return '$name 선택됨';
  }

  @override
  String regionPickerEdit(String name) {
    return '$name 편집';
  }

  @override
  String regionPickerDelete(String name) {
    return '$name 삭제';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return '$name을(를) 삭제할까요?';
  }

  @override
  String get regionPickerDeleteBody => '이 사용자 지정 지역이 이 기기에서 삭제됩니다.';

  @override
  String get regionPickerDeleteConfirm => '삭제';

  @override
  String get regionPickerCantDeleteCurrent => '이 지역을 삭제하기 전에 다른 지역을 선택하세요.';

  @override
  String get regionPickerEmpty => '사용 가능한 지역 없음';

  @override
  String get regionPickerEmptyBody => '실험 또는 비활성 지역을 켜거나 사용자 지정 지역을 추가하세요.';

  @override
  String get regionPickerTripPlanner => '이 지역의 경로 계획';

  @override
  String get customRegionEditTitle => '사용자 지정 지역 편집';

  @override
  String get customRegionName => '이름';

  @override
  String get customRegionObaUrl => 'OneBusAway 서버 URL';

  @override
  String get customRegionObaUrlHelp => '서버 주소(예: https://oba.example.com/)';

  @override
  String get customRegionSidecar => 'Sidecar 서버 URL(선택사항)';

  @override
  String get customRegionOtp => '경로 계획 URL(선택사항)';

  @override
  String get customRegionOtpGraphql => '경로 계획 GraphQL URL(선택사항)';

  @override
  String get customRegionServiceArea => '서비스 지역';

  @override
  String get customRegionServiceAreaHelp => '이 지역이 포함하는 영역으로, 중심점과 범위로 지정합니다.';

  @override
  String get customRegionLatitude => '중심 위도';

  @override
  String get customRegionLongitude => '중심 경도';

  @override
  String get customRegionLatSpan => '위도 범위(도)';

  @override
  String get customRegionLonSpan => '경도 범위(도)';

  @override
  String get customRegionUseMap => '현재 지도 영역 사용';

  @override
  String get customRegionSave => '저장';

  @override
  String get customRegionErrorRequired => '필수 입력 항목입니다';

  @override
  String get customRegionErrorUrl => 'http:// 또는 https://로 시작하는 웹 주소를 입력하세요';

  @override
  String get customRegionErrorNumber => '숫자를 입력하세요';

  @override
  String get customRegionErrorRange => '범위를 벗어난 숫자입니다';

  @override
  String get customRegionChecking => '서버 확인 중';

  @override
  String get customRegionServerOk => '서버가 응답했습니다';

  @override
  String get customRegionServerUnreachable => '이 서버에 연결할 수 없습니다';

  @override
  String get customRegionServerNotOba => '이 서버는 OneBusAway처럼 응답하지 않았습니다';

  @override
  String customRegionSaved(String name) {
    return '$name 저장됨';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway는 자원봉사자들이 만들고 Open Transit Software Foundation이 지원하는 무료 오픈소스 대중교통 소프트웨어입니다.';

  @override
  String get creditsLicenseTitle => '라이선스';

  @override
  String get creditsMapData => '지도 데이터';

  @override
  String get creditsLicenses => '오픈소스 라이선스';

  @override
  String get creditsLicensesHelp => '이 앱을 만드는 데 사용된 라이브러리입니다.';

  @override
  String get creditsLicensesLoading => '라이선스 불러오는 중';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '라이선스 $count개',
      one: '라이선스 $count개',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote => '전 세계 수십 개 대중교통 지역에서 사용할 수 있습니다.';

  @override
  String get onboardingBenefitNearbyTitle => '주변 정류장 보기';

  @override
  String get onboardingBenefitNearbyBody => '주변 버스와 열차를 거리순으로 보여 드립니다.';

  @override
  String get onboardingBenefitMapTitle => '지도를 내 위치에 맞추기';

  @override
  String get onboardingBenefitMapBody => '검색하지 않아도 바로 내 주변 지도가 열립니다.';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName은(는) 앱이 열려 있는 동안에만 위치를 사용합니다. 기기 설정에서 언제든지 변경할 수 있습니다.';
  }

  @override
  String get onboardingLocationDenied => '위치 접근이 꺼져 있습니다. 지역은 직접 선택할 수 있습니다.';

  @override
  String get onboardingRegionDetected => '내 주변에서 감지됨';

  @override
  String onboardingRegionUse(String name) {
    return '$name 사용';
  }

  @override
  String get onboardingRegionOthers => '또는 다른 지역 선택';

  @override
  String get onboardingRegionEmpty => '현재 사용 가능한 지역이 없습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String get surveyCardTitle => '대중교통 개선에 도움을 주세요';

  @override
  String get surveyDefaultPrompt => '짧은 설문조사에 참여하여 대중교통 개선에 도움을 주세요.';

  @override
  String get surveyTake => '설문조사 참여';

  @override
  String get surveyNotNow => '나중에';

  @override
  String get surveyDismiss => '설문조사 닫기';

  @override
  String get surveyNext => '다음';

  @override
  String get surveySubmit => '설문조사 제출';

  @override
  String get surveySubmitting => '제출 중';

  @override
  String get surveyQuestionsTitle => '설문조사';

  @override
  String get surveyTextHint => '답변을 입력하세요';

  @override
  String get surveyRequired => '필수';

  @override
  String get surveyIncomplete => '제출하기 전에 필수 질문에 모두 답해 주세요.';

  @override
  String get surveyFailed => '답변을 보낼 수 없습니다. 다시 시도하세요.';

  @override
  String get surveyThanks => '의견을 보내 주셔서 감사합니다.';

  @override
  String get surveyOpenSurvey => '설문조사 열기';

  @override
  String get surveyLearnMore => '자세히 알아보기';

  @override
  String get surveyShareFeedback => '의견 보내기';

  @override
  String get surveySignUp => '가입';

  @override
  String get surveyExternalError => '설문조사 링크를 열 수 없습니다. 나중에 다시 시도하세요.';

  @override
  String donationTitle(String appName) {
    return '$appName에 여러분의 도움이 필요합니다';
  }

  @override
  String get donationBody =>
      '이 앱은 자원봉사자들의 노력으로 만들어졌으며, 앞으로의 개발 비용을 마련하는 데 여러분의 도움이 필요합니다.';

  @override
  String get donationLearnMore => '자세히 알아보기';

  @override
  String get donationDonate => '지금 기부하기';

  @override
  String get donationRemindLater => '나중에 알림';

  @override
  String get donationDismiss => '괜찮습니다';

  @override
  String get donationHeader => '도움이 필요한 이유';

  @override
  String donationExplanation(String appName) {
    return '$appName을(를) 개선할 큰 계획이 있지만, 여러분의 도움 없이는 실현할 수 없습니다. 이 앱은 자원봉사자들의 노력으로 만들어졌으며, 앞으로의 개발 비용을 마련하는 데 여러분의 도움이 필요합니다.\n\n비영리 단체인 Open Transit Software Foundation의 핵심 프로젝트이므로, 기부금은 미국에서 세금 공제를 받을 수 있습니다.';
  }

  @override
  String get donationDonateWebsite => '웹사이트에서 기부하기';

  @override
  String titleDonation(String appName) {
    return '$appName 후원';
  }

  @override
  String feedbackTitle(String appName) {
    return '$appName이(가) 마음에 드시나요?';
  }

  @override
  String get feedbackYes => '네!';

  @override
  String get feedbackNo => '별로예요';

  @override
  String get feedbackLater => '나중에 묻기';

  @override
  String get feedbackNegativeTitle => '죄송합니다.';

  @override
  String get feedbackNegativeBody => '무엇이 문제인지 알려 주시겠어요? 모든 메시지를 읽고 있습니다.';

  @override
  String get feedbackSend => '의견 보내기';

  @override
  String get feedbackDecline => '괜찮습니다';

  @override
  String get tripPlanningUnavailable => '이 지역에서는 경로 계획을 사용할 수 없습니다.';

  @override
  String get deepLinkOtherRegion => '이 링크는 다른 지역용입니다. 지역을 전환하여 여세요.';

  @override
  String get dataUpdated => '업데이트됨';

  @override
  String get bookmarksEtaNow => '지금';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 후',
      one: '$minutes분 후',
      zero: '지금',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => '정시';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 지연',
      one: '$minutes분 지연',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 일찍',
      one: '$minutes분 일찍',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => '예정';

  @override
  String get bookmarksStatusCanceled => '취소됨';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return '$headsign 방면 $route 노선';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return '$route 노선';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => '출발 정보 불러오는 중';

  @override
  String get bookmarksNoDepartures => '예정된 출발 없음';

  @override
  String get bookmarksDeparturesError => '출발 정보를 불러올 수 없습니다';

  @override
  String get bookmarksDeparturesStale => '새로고침할 수 없습니다. 이전 시간을 표시합니다.';

  @override
  String get bookmarksUpdated => '출발 정보가 업데이트되었습니다';

  @override
  String get bookmarksSortTooltip => '즐겨찾기 정렬';

  @override
  String get bookmarksSortByGroup => '그룹별 정렬';

  @override
  String get bookmarksSortByDistance => '거리순 정렬';

  @override
  String get bookmarksManageTooltip => '즐겨찾기 및 그룹 편집';

  @override
  String get bookmarksRefreshTooltip => '출발 정보 새로고침';

  @override
  String get bookmarksEmptyTitle => '아직 즐겨찾기가 없습니다';

  @override
  String get bookmarksEmptyBody =>
      '정류장을 열고 즐겨찾기 버튼을 탭하면 여기에 저장됩니다. 출발 정보에서 해당 정류장의 특정 노선만 즐겨찾기에 추가할 수도 있습니다.';

  @override
  String get bookmarksFindStops => '지도에서 정류장 찾기';

  @override
  String get bookmarksUngrouped => '그룹 없음';

  @override
  String get bookmarksGroupExpanded => '펼쳐짐';

  @override
  String get bookmarksGroupCollapsed => '접힘';

  @override
  String get bookmarksGroupToggleHint => '이 그룹의 즐겨찾기를 표시하거나 숨깁니다';

  @override
  String bookmarksActionsFor(String name) {
    return '$name 작업';
  }

  @override
  String get bookmarksActionEdit => '편집';

  @override
  String get bookmarksActionPin => '맨 위에 고정';

  @override
  String get bookmarksActionUnpin => '고정 해제';

  @override
  String get bookmarksActionMove => '그룹으로 이동';

  @override
  String get bookmarksActionDelete => '삭제';

  @override
  String get bookmarksPinned => '고정됨';

  @override
  String bookmarksDeleted(String name) {
    return '$name 삭제됨';
  }

  @override
  String get bookmarksUndo => '실행 취소';

  @override
  String get bookmarksMoveTitle => '그룹으로 이동';

  @override
  String get bookmarksNoGroup => '그룹 없음';

  @override
  String bookmarksMoved(String group) {
    return '$group(으)로 이동됨';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name, $details';
  }

  @override
  String get bookmarksEditorNameLabel => '즐겨찾기 이름';

  @override
  String get bookmarksEditorNameRequired => '이 즐겨찾기의 이름을 입력하세요.';

  @override
  String get bookmarksEditorDuplicate =>
      '이 정류장과 노선에 같은 이름의 즐겨찾기가 이미 있습니다. 다른 즐겨찾기를 저장하려면 이름을 변경하세요.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return '정류장 즐겨찾기: $stop의 모든 노선의 다음 출발을 표시합니다.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return '운행 즐겨찾기: $stop에서 $route 노선의 다음 출발을 표시합니다.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return '$route만';
  }

  @override
  String get bookmarksEditorGroup => '그룹';

  @override
  String get bookmarksEditorNewGroup => '새 그룹…';

  @override
  String get bookmarksEditorNewGroupTitle => '새 그룹';

  @override
  String get bookmarksEditorGroupName => '그룹 이름';

  @override
  String get bookmarksEditorSave => '저장';

  @override
  String get bookmarksEditorSaved => '즐겨찾기가 저장되었습니다';

  @override
  String get bookmarksEditorDelete => '즐겨찾기 삭제';

  @override
  String get bookmarksEditorDeleteTitle => '이 즐겨찾기를 삭제할까요?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '“$name”이(가) 즐겨찾기에서 삭제됩니다.';
  }

  @override
  String get bookmarksEditorNoRegion => '즐겨찾기를 추가하기 전에 지역을 선택하세요.';

  @override
  String get bookmarksManageGroupsHeader => '그룹';

  @override
  String get bookmarksManageBookmarksHeader => '즐겨찾기';

  @override
  String get bookmarksManageAddGroup => '그룹 추가';

  @override
  String get bookmarksManageRenameGroup => '그룹 이름 변경';

  @override
  String get bookmarksManageDeleteGroup => '그룹 삭제';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return '“$name”의 즐겨찾기는 그룹 없음으로 변경됩니다.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return '$name 위로 이동';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return '$name 아래로 이동';
  }

  @override
  String bookmarksManageReorder(String name) {
    return '$name 순서 변경';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, $count개 중 $position번째';
  }

  @override
  String get bookmarksManageEmpty => '아직 관리할 즐겨찾기나 그룹이 없습니다.';

  @override
  String get bookmarksManageUngrouped => '그룹 없는 즐겨찾기';

  @override
  String get recentsEmptyTitle => '최근 정류장 없음';

  @override
  String get recentsEmptyBody => '확인한 정류장이 최신순으로 여기에 표시됩니다.';

  @override
  String get recentsFindStops => '지도에서 정류장 찾기';

  @override
  String get recentsClearAll => '모두 지우기';

  @override
  String get recentsClearTitle => '최근 정류장을 지울까요?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '최근 정류장 $count개가 모두 삭제됩니다. 즐겨찾기는 영향을 받지 않습니다.',
      one: '최근 정류장 $count개가 삭제됩니다. 즐겨찾기는 영향을 받지 않습니다.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return '최근 정류장에서 $name 삭제';
  }

  @override
  String recentsRemoved(String name) {
    return '$name 삭제됨';
  }

  @override
  String get recentsSectionEmpty => '확인한 정류장이 여기에 표시됩니다.';

  @override
  String get alarmsSectionTitle => '미리 알림';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '출발 $minutes분 전, $time',
      one: '출발 $minutes분 전, $time',
    );
    return '$_temp0';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return '$title 미리 알림, $details';
  }

  @override
  String alarmsDelete(String title) {
    return '$title 미리 알림 삭제';
  }

  @override
  String get alarmsDeleted => '미리 알림이 삭제되었습니다';

  @override
  String get alarmsDeleteFailed => '미리 알림을 삭제할 수 없습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String get alarmsOpen => '운행 정보를 엽니다';

  @override
  String get alertsEmptyTitle => '운행 알림 없음';

  @override
  String get alertsEmptyBody => '현재 진행 중인 운행 알림이 없습니다.';

  @override
  String get alertsRegionNote => '즐겨찾기, 최근, 주변 정류장의 알림이 포함됩니다.';

  @override
  String get alertsMarkAllRead => '모두 읽음으로 표시';

  @override
  String get alertsAllRead => '모든 알림을 읽음으로 표시했습니다';

  @override
  String get alertsUnread => '읽지 않음';

  @override
  String get alertsSeverityInfo => '정보';

  @override
  String get alertsSeverityWarning => '경고';

  @override
  String get alertsSeveritySevere => '심각';

  @override
  String get alertsSeverityUnknown => '운행 알림';

  @override
  String get alertsNoTitle => '운행 알림';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => '읽지 않음. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '읽지 않은 알림 $count개',
      one: '읽지 않은 알림 $count개',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '알림 $count개 더',
      one: '알림 $count개 더',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => '적용 기간';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start ~ $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return '$start부터';
  }

  @override
  String get alertsDetailAffects => '영향 범위';

  @override
  String get alertsDetailRoutes => '노선';

  @override
  String get alertsDetailStops => '정류장';

  @override
  String get alertsDetailAgencies => '운영 기관';

  @override
  String get alertsDetailLearnMore => '자세히 알아보기';

  @override
  String get alertsDetailNoDetails => '추가 세부 정보가 없습니다.';

  @override
  String alertsDetailUpdated(String date) {
    return '$date 발행';
  }

  @override
  String get alertsCouldNotOpen => '링크를 열 수 없습니다.';

  @override
  String get agenciesEmptyTitle => '운영 기관 없음';

  @override
  String get agenciesEmptyBody => '이 지역에는 등록된 운영 기관이 없습니다.';

  @override
  String get agenciesWebsite => '웹사이트';

  @override
  String agenciesPhone(String phone) {
    return '$phone로 전화';
  }

  @override
  String agenciesEmail(String email) {
    return '$email로 이메일 보내기';
  }

  @override
  String get agenciesFares => '요금 정보';

  @override
  String get agenciesDisclaimer => '면책 조항';

  @override
  String get agenciesShowOnMap => '지도에 운행 범위 표시';

  @override
  String get searchFieldLabel => '검색';

  @override
  String get searchFieldHint => '노선, 정류장 번호, 주소 또는 차량';

  @override
  String get searchClear => '검색어 지우기';

  @override
  String get searchScopeLabel => '검색 대상';

  @override
  String get searchScopeAll => '전체';

  @override
  String get searchScopeStops => '정류장';

  @override
  String get searchScopeRoutes => '노선';

  @override
  String get searchScopePlaces => '장소';

  @override
  String get searchQuickHeader => '검색 대상';

  @override
  String searchQuickRoute(String query) {
    return '노선: $query';
  }

  @override
  String searchQuickStop(String query) {
    return '정류장 번호: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return '주소: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return '차량: $query';
  }

  @override
  String get searchRecentStopsHeader => '최근 정류장';

  @override
  String get searchBookmarksHeader => '즐겨찾기';

  @override
  String get searchRecentSearchesHeader => '최근 검색';

  @override
  String get searchRecentPlacesHeader => '최근 장소';

  @override
  String get searchPlacesHeader => '장소';

  @override
  String get searchClearRecent => '최근 검색 지우기';

  @override
  String get searchClearRecentConfirm => '최근 검색어와 장소를 지울까요?';

  @override
  String get searchClearAction => '지우기';

  @override
  String get searchRecentCleared => '최근 검색을 지웠습니다';

  @override
  String get searchPlacesLoading => '장소 검색 중';

  @override
  String get searchPlacesNone => '장소를 찾을 수 없습니다';

  @override
  String get searchPlacesError => '장소를 검색할 수 없습니다. 연결을 확인하세요.';

  @override
  String get searchSearching => '검색 중';

  @override
  String get searchNoResultsTitle => '결과 없음';

  @override
  String searchNoResultsBody(String query) {
    return '“$query”에 대한 검색 결과가 없습니다.';
  }

  @override
  String get searchUnavailableNoRegion => '검색하기 전에 지역을 선택하세요.';

  @override
  String get searchUnavailableAddress => '이 앱에서는 주소 검색이 설정되어 있지 않습니다.';

  @override
  String get searchUnavailableVehicle => '이 지역에서는 차량 검색을 사용할 수 없습니다.';

  @override
  String get searchEmptyTitle => '노선, 정류장, 장소 찾기';

  @override
  String get searchEmptyBody => '노선 이름, 정류장 번호, 주소 또는 차량 ID를 입력하세요.';

  @override
  String get searchDismissMessage => '닫기';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '“$query” 검색 결과 $count개',
      one: '“$query” 검색 결과 $count개',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => '노선';

  @override
  String get searchResultsStops => '정류장';

  @override
  String get searchResultsVehicles => '차량';

  @override
  String get searchResultsPlaces => '장소';

  @override
  String searchRouteRowLabel(String name, String details) {
    return '$name 노선, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return '차량 $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return '차량 $id은(는) 현재 운행 중이 아닙니다.';
  }

  @override
  String searchVehicleLoading(String id) {
    return '차량 $id 불러오는 중';
  }

  @override
  String get searchNearbyLocationPrompt => '위치를 켜면 주변 정류장의 출발 정보를 볼 수 있습니다.';

  @override
  String get searchNearbyLocationButton => '내 위치 사용';

  @override
  String get searchNearbyLocationDenied =>
      '위치 접근이 꺼져 있습니다. 주변 정류장을 보려면 기기 설정에서 켜세요.';

  @override
  String get searchNearbyLocationServicesOff =>
      '위치 서비스가 꺼져 있습니다. 주변 정류장을 보려면 켜세요.';

  @override
  String get searchNearbyLocationUnavailable =>
      '이 앱은 위치를 사용하지 않으므로 주변 정류장을 표시할 수 없습니다.';

  @override
  String get searchNearbyEmpty => '주변 정류장 없음';

  @override
  String get searchNearbyEmptyBody => '도보 거리 내에 정류장이 없습니다.';

  @override
  String get searchNearbyMapCenter => '지도 중심 부근의 정류장을 표시합니다.';

  @override
  String get searchNearbyNoDepartures => '다음 1시간 동안 출발 없음';

  @override
  String get searchNearbyLoadingDepartures => '출발 정보 불러오는 중';

  @override
  String get searchNearbyUpdated => '주변 출발 정보가 업데이트되었습니다';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '주변 정류장 $count개',
      one: '주변 정류장 $count개',
      zero: '주변 정류장 없음',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => '내 위치를 찾는 중…';

  @override
  String get searchNearbyRefresh => '새로고침';

  @override
  String searchNearbyDistance(String distance) {
    return '$distance 떨어짐';
  }

  @override
  String get searchNearbyOtherDirection => '기타 정류장';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return '$direction 정류장';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$headsign 방면 $route, $eta, $status. $stop 출발';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return '$stop 출발';
  }

  @override
  String get searchNearbyCardTitle => '내 주변 출발 정보';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get searchEtaNow => '지금';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 후',
      one: '$minutes분 후',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => '지금 출발';

  @override
  String get searchStatusOnTime => '정시';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 지연',
      one: '$minutes분 지연',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 일찍',
      one: '$minutes분 일찍',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => '예정';

  @override
  String get searchExplorePlanTrip => '경로 계획';

  @override
  String get searchExploreWeather => '날씨';

  @override
  String get searchExploreAgencies => '운영 기관';

  @override
  String get searchPlaceAddress => '주소';

  @override
  String get searchPlaceCoordinates => '좌표';

  @override
  String get searchPlaceDistance => '거리';

  @override
  String get searchPlaceDirectionsTo => '여기까지 길찾기';

  @override
  String get searchPlaceDirectionsFrom => '여기서부터 길찾기';

  @override
  String get searchPlaceNearbyStops => '주변 정류장';

  @override
  String get searchPlaceShare => '공유';

  @override
  String get searchPlaceOpenInMaps => '지도 앱에서 열기';

  @override
  String get searchPlaceRemovePin => '핀 제거';

  @override
  String get searchPlaceOpenFailed => '지도 앱을 열 수 없습니다.';

  @override
  String get searchPlaceShareFailed => '이 장소를 공유할 수 없습니다.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return '장소: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return '날씨: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => '일기예보를 표시합니다';

  @override
  String get searchWeatherClear => '맑음';

  @override
  String get searchWeatherPartlyCloudy => '구름 조금';

  @override
  String get searchWeatherCloudy => '흐림';

  @override
  String get searchWeatherRain => '비';

  @override
  String get searchWeatherSleet => '진눈깨비';

  @override
  String get searchWeatherSnow => '눈';

  @override
  String get searchWeatherWindy => '바람';

  @override
  String get searchWeatherFog => '안개';

  @override
  String get searchWeatherUnknown => '알 수 없는 날씨';

  @override
  String searchWeatherDegreesF(int value) {
    return '$value°F';
  }

  @override
  String searchWeatherDegreesC(int value) {
    return '$value°C';
  }

  @override
  String searchWeatherSpokenF(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '화씨 $value도',
      one: '화씨 $value도',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '섭씨 $value도',
      one: '섭씨 $value도',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherMph(int value) {
    return '${value}mph';
  }

  @override
  String searchWeatherKmh(int value) {
    return '${value}km/h';
  }

  @override
  String searchWeatherMps(int value) {
    return '${value}m/s';
  }

  @override
  String searchWeatherPercent(int value) {
    return '$value%';
  }

  @override
  String get searchWeatherFeelsLike => '체감';

  @override
  String get searchWeatherWind => '바람';

  @override
  String get searchWeatherPrecip => '강수 확률';

  @override
  String searchWeatherHighLow(String high, String low) {
    return '최고 $high · 최저 $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return '앞으로 24시간 동안 최고 $high, 최저 $low';
  }

  @override
  String get searchWeatherHourly => '다음 24시간';

  @override
  String get searchWeatherNow => '지금';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, 강수 확률 $precip';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return '기온 단위: $unit';
  }

  @override
  String get searchWeatherFahrenheit => '화씨(°F)';

  @override
  String get searchWeatherCelsius => '섭씨(°C)';

  @override
  String searchWeatherUpdated(String time) {
    return '$time 예보';
  }

  @override
  String get searchWeatherUnavailable => '이 지역의 날씨 정보를 사용할 수 없습니다.';

  @override
  String get searchWeatherSummaryLabel => '오늘';

  @override
  String get bookmarksSectionEmpty => '즐겨찾기한 정류장이 여기에 표시됩니다.';

  @override
  String get coreDirectionNameN => '북쪽';

  @override
  String get coreDirectionNameNE => '북동쪽';

  @override
  String get coreDirectionNameE => '동쪽';

  @override
  String get coreDirectionNameSE => '남동쪽';

  @override
  String get coreDirectionNameS => '남쪽';

  @override
  String get coreDirectionNameSW => '남서쪽';

  @override
  String get coreDirectionNameW => '서쪽';

  @override
  String get coreDirectionNameNW => '북서쪽';

  @override
  String get coreDirectionAbbrN => '북';

  @override
  String get coreDirectionAbbrNE => '북동';

  @override
  String get coreDirectionAbbrE => '동';

  @override
  String get coreDirectionAbbrSE => '남동';

  @override
  String get coreDirectionAbbrS => '남';

  @override
  String get coreDirectionAbbrSW => '남서';

  @override
  String get coreDirectionAbbrW => '서';

  @override
  String get coreDirectionAbbrNW => '북서';

  @override
  String get coreDirectionBoundN => '북쪽 방면';

  @override
  String get coreDirectionBoundNE => '북동쪽 방면';

  @override
  String get coreDirectionBoundE => '동쪽 방면';

  @override
  String get coreDirectionBoundSE => '남동쪽 방면';

  @override
  String get coreDirectionBoundS => '남쪽 방면';

  @override
  String get coreDirectionBoundSW => '남서쪽 방면';

  @override
  String get coreDirectionBoundW => '서쪽 방면';

  @override
  String get coreDirectionBoundNW => '북서쪽 방면';

  @override
  String get coreRouteTypeLightRail => '경전철';

  @override
  String get coreRouteTypeSubway => '지하철';

  @override
  String get coreRouteTypeRail => '철도';

  @override
  String get coreRouteTypeBus => '버스';

  @override
  String get coreRouteTypeFerry => '여객선';

  @override
  String get coreRouteTypeCableCar => '케이블카';

  @override
  String get coreRouteTypeGondola => '곤돌라';

  @override
  String get coreRouteTypeFunicular => '푸니쿨라';

  @override
  String coreStopCodeNumeric(String code) {
    return '정류장 #$code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return '정류장: \'$code\'';
  }

  @override
  String coreStopId(String code) {
    return '정류장 ID: $code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return '노선: $routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '노선: $routes 외 $count개',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return '$region에서 검색';
  }

  @override
  String get coreNow => '지금';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get coreOneMinute => '1분';

  @override
  String get coreOneMinuteAgo => '1분 전';

  @override
  String coreMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분',
    );
    return '$_temp0';
  }

  @override
  String get coreJustNow => '방금';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds초 전';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days일 전',
      one: '$days일 전',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return '업데이트: $ago';
  }

  @override
  String get coreScheduledNotRealTime => '예정/실시간 아님';

  @override
  String coreArrivedMinAgo(int minutes) {
    return '$minutes분 전 도착';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return '$minutes분 전 출발';
  }

  @override
  String get coreArrivingNow => '지금 도착';

  @override
  String get coreDepartingNow => '지금 출발';

  @override
  String coreArrivesInMin(int minutes) {
    return '$minutes분 후 도착';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return '$minutes분 후 출발';
  }

  @override
  String coreArrivedLate(int minutes) {
    return '$minutes분 늦게 도착';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return '$minutes분 일찍 도착';
  }

  @override
  String get coreArrivedOnTime => '정시에 도착';

  @override
  String coreDepartedLate(int minutes) {
    return '$minutes분 늦게 출발';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return '$minutes분 일찍 출발';
  }

  @override
  String get coreDepartedOnTime => '정시에 출발';

  @override
  String coreArrivesLate(int minutes) {
    return '$minutes분 늦게 도착 예정';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return '$minutes분 일찍 도착 예정';
  }

  @override
  String get coreArrivesOnTime => '정시 도착 예정';

  @override
  String coreDepartsLate(int minutes) {
    return '$minutes분 늦게 출발 예정';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return '$minutes분 일찍 출발 예정';
  }

  @override
  String get coreDepartsOnTime => '정시 출발 예정';

  @override
  String coreMeters(String value) {
    return '${value}m';
  }

  @override
  String coreKilometers(String value) {
    return '${value}km';
  }

  @override
  String coreFeet(String value) {
    return '${value}ft';
  }

  @override
  String coreMiles(String value) {
    return '${value}mi';
  }

  @override
  String coreAlarmMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분',
      one: '$minutes분',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsNow => '지금';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes분';
  }

  @override
  String get arrivalsCanceled => '취소됨';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return '$time부터 $minutes분 간격';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return '$time까지 $minutes분 간격';
  }

  @override
  String get arrivalsDirectionBoundN => '북쪽 방면';

  @override
  String get arrivalsDirectionBoundNE => '북동쪽 방면';

  @override
  String get arrivalsDirectionBoundE => '동쪽 방면';

  @override
  String get arrivalsDirectionBoundSE => '남동쪽 방면';

  @override
  String get arrivalsDirectionBoundS => '남쪽 방면';

  @override
  String get arrivalsDirectionBoundSW => '남서쪽 방면';

  @override
  String get arrivalsDirectionBoundW => '서쪽 방면';

  @override
  String get arrivalsDirectionBoundNW => '북서쪽 방면';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return '$code 방면';
  }

  @override
  String get arrivalsRefresh => '도착 정보 새로고침';

  @override
  String get arrivalsRetry => '다시 시도';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '다음 $minutes분 동안 도착 예정 차량 없음',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound => '정류장을 찾을 수 없거나 서비스를 사용할 수 없습니다';

  @override
  String get arrivalsNetworkError => '교통 서버에 연결할 수 없습니다. 연결을 확인하세요.';

  @override
  String get arrivalsLoadError => '도착 정보를 불러올 수 없습니다.';

  @override
  String arrivalsStaleNotice(String time) {
    return '업데이트할 수 없습니다. $time 결과를 표시합니다';
  }

  @override
  String get arrivalsArrivingNow => '지금 도착';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 후 도착',
      one: '$minutes분 후 도착',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => '실시간';

  @override
  String get arrivalsRowTapHint => '상세 정보 보기';

  @override
  String arrivalsAtTime(String time) {
    return '$time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 지연',
      one: '$minutes분 지연',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분 일찍',
      one: '$minutes분 일찍',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$time부터 $minutes분마다',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$time까지 $minutes분마다',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => '예정 시각';

  @override
  String get arrivalsLoading => '도착 정보 불러오는 중';

  @override
  String get arrivalsRefreshing => '도착 정보 새로고침 중';

  @override
  String get arrivalsUpdated => '도착 정보가 업데이트되었습니다';

  @override
  String get tripPlannerOriginLabel => '출발';

  @override
  String get tripPlannerDestinationLabel => '도착';

  @override
  String get tripPlannerChooseOrigin => '출발지 선택';

  @override
  String get tripPlannerChooseDestination => '목적지 선택';

  @override
  String get tripPlannerCurrentLocation => '현재 위치';

  @override
  String get tripPlannerSwapEndpoints => '출발지와 목적지 바꾸기';

  @override
  String get tripPlannerPlanTrip => '경로 검색';

  @override
  String get tripPlannerPlanningTrip => '경로를 검색하는 중';

  @override
  String get tripPlannerOptions => '경로 옵션';

  @override
  String get tripPlannerLeaveNow => '지금 출발';

  @override
  String get tripPlannerDepartAt => '출발 시각';

  @override
  String get tripPlannerArriveBy => '도착 시각';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return '시간 변경, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => '대중교통';

  @override
  String get tripPlannerModeWalk => '도보';

  @override
  String get tripPlannerModeBike => '자전거';

  @override
  String get tripPlannerModeCar => '자동차';

  @override
  String get tripPlannerModeBikeRental => '공유 자전거만';

  @override
  String get tripPlannerModeTransitBikeRental => '대중교통 + 공유 자전거';

  @override
  String get tripPlannerWheelchairAccessible => '휠체어 이용 가능';

  @override
  String get tripPlannerWalkQuarterMile => '0.25마일';

  @override
  String get tripPlannerWalkHalfMile => '0.5마일';

  @override
  String get tripPlannerWalkOneMile => '1마일';

  @override
  String get tripPlannerWalkTwoMiles => '2마일';

  @override
  String tripPlannerMaxWalk(String distance) {
    return '최대 $distance 도보';
  }

  @override
  String get tripPlannerNoTripsFound => '경로를 찾을 수 없습니다';

  @override
  String get tripPlannerRetry => '다시 시도';

  @override
  String get tripPlannerRealTime => '실시간';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours시간';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String tripPlannerTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String tripPlannerTransfers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '환승 $count회',
      one: '환승 $count회',
      zero: '환승 없음',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return '도보 $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return '$time에 $place에서 출발';
  }

  @override
  String get tripPlannerStatusOnTime => '정시';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '$minutes분 지연';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '$minutes분 일찍';
  }

  @override
  String get tripPlannerStatusScheduled => '예정';

  @override
  String get tripPlannerLegBus => '버스';

  @override
  String get tripPlannerLegTram => '트램';

  @override
  String get tripPlannerLegSubway => '지하철';

  @override
  String get tripPlannerLegRail => '열차';

  @override
  String get tripPlannerLegFerry => '여객선';

  @override
  String get tripPlannerLegCableCar => '케이블카';

  @override
  String get tripPlannerLegGondola => '곤돌라';

  @override
  String get tripPlannerLegFunicular => '푸니쿨라';

  @override
  String get tripPlannerLegAirplane => '비행기';

  @override
  String get tripPlannerLegTrolleybus => '트롤리버스';

  @override
  String get tripPlannerLegMonorail => '모노레일';

  @override
  String tripPlannerItinerarySemantics(
    String timeRange,
    String duration,
    String legs,
    String details,
  ) {
    return '$timeRange, $duration. $legs. $details';
  }

  @override
  String tripPlannerLegWalkSemantics(String duration) {
    return '도보 $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return '자전거 $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return '공유 자전거 $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return '자동차 $duration';
  }

  @override
  String tripPlannerLegTransitSemantics(String mode, String duration) {
    return '$mode, $duration';
  }

  @override
  String tripPlannerLegTransitRouteSemantics(
    String mode,
    String route,
    String duration,
  ) {
    return '$mode $route, $duration';
  }

  @override
  String get tripPlannerThen => '그다음';

  @override
  String get tripPlannerOpenItineraryHint => '경로 상세 정보 보기';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes분',
      one: '$minutes분',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours시간',
      one: '$hours시간',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursMinutesSemantics(String hours, String minutes) {
    return '$hours $minutes';
  }

  @override
  String tripPlannerFeetSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value피트',
      one: '$value피트',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value마일',
      one: '$value마일',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value미터',
      one: '$value미터',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value킬로미터',
      one: '$value킬로미터',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return '$start부터 $end까지';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => '실시간, 정시';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '실시간, $minutes분 지연',
      one: '실시간, $minutes분 지연',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '실시간, $minutes분 일찍',
      one: '실시간, $minutes분 일찍',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => '예정 시각';

  @override
  String get tripPlannerResultsHeading => '추천 경로';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '경로 $count개 찾음',
      one: '경로 $count개 찾음',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '장소 $count곳 찾음',
      one: '장소 $count곳 찾음',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel => '경로 지도입니다. 아래 안내는 같은 경로를 설명합니다.';

  @override
  String get tripPlannerTripDetails => '경로 상세 정보';

  @override
  String get tripPlannerMapLabel => '경로 지도';

  @override
  String get tripPlannerStart => '출발';

  @override
  String get tripPlannerDestination => '목적지';

  @override
  String get tripPlannerUnnamedPlace => '이름 없는 위치';

  @override
  String get tripPlannerRentalBike => '공유 자전거';

  @override
  String tripPlannerWalkTo(String place) {
    return '$place까지 도보';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return '$place까지 자전거';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return '$place까지 공유 자전거';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return '$place까지 자동차';
  }

  @override
  String tripPlannerBoard(String mode) {
    return '$mode 탑승';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return '$mode $route 탑승';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return '$headsign 방면 $mode 탑승';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return '$headsign 방면 $mode $route 탑승';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return '$place에서 하차';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return '$place 도착';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '정류장 $count개',
      one: '정류장 $count개',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '정류장 $count개 보기',
      one: '정류장 $count개 보기',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '정류장 $count개 숨기기',
      one: '정류장 $count개 숨기기',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count단계',
      one: '$count단계',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count단계 보기',
      one: '$count단계 보기',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count단계 숨기기',
      one: '$count단계 숨기기',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, 약 $duration';
  }

  @override
  String get tripPlannerDirectionDepart => '출발';

  @override
  String get tripPlannerDirectionHardLeft => '급좌회전';

  @override
  String get tripPlannerDirectionLeft => '좌회전';

  @override
  String get tripPlannerDirectionSlightlyLeft => '약간 왼쪽으로';

  @override
  String get tripPlannerDirectionContinue => '계속 직진';

  @override
  String get tripPlannerDirectionSlightlyRight => '약간 오른쪽으로';

  @override
  String get tripPlannerDirectionRight => '우회전';

  @override
  String get tripPlannerDirectionHardRight => '급우회전';

  @override
  String get tripPlannerDirectionCircleClockwise => '회전교차로에서 시계 방향으로 진입';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      '회전교차로에서 반시계 방향으로 진입';

  @override
  String get tripPlannerDirectionElevator => '엘리베이터 이용';

  @override
  String get tripPlannerDirectionUturnLeft => '왼쪽으로 유턴';

  @override
  String get tripPlannerDirectionUturnRight => '오른쪽으로 유턴';

  @override
  String get tripPlannerDirectionEnterStation => '역으로 진입';

  @override
  String get tripPlannerDirectionExitStation => '역에서 나가기';

  @override
  String get tripPlannerDirectionFollowSigns => '표지판을 따라 이동';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return '$street을(를) 따라 $distance 이동합니다.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction, $street(으)로 $distance 이동합니다.';
  }

  @override
  String get tripPlannerSearchHint => '장소 검색';

  @override
  String get tripPlannerSearchNoResults => '장소를 찾을 수 없습니다';

  @override
  String get tripPlannerSearchError => '장소를 검색할 수 없습니다. 다시 시도하세요.';

  @override
  String get tripPlannerUseCurrentLocation => '현재 위치 사용';

  @override
  String get tripPlannerLocationUnavailable => '현재 위치를 가져올 수 없습니다.';

  @override
  String get tripPlannerClearSearch => '검색어 지우기';

  @override
  String get tripPlannerErrorMissingEndpoints => '출발지와 목적지를 모두 선택하세요.';

  @override
  String get tripPlannerErrorNetwork => '경로 계획 서버에 연결할 수 없습니다. 연결을 확인하세요.';

  @override
  String get tripPlannerErrorInvalidResponse => '서버가 잘못된 응답을 반환했습니다';

  @override
  String get tripPlannerErrorUnknown => '알 수 없는 오류가 발생했습니다.';

  @override
  String get tripPlannerPlannerSystemError => '지금은 경로를 검색할 수 없습니다. 다시 시도하세요.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      '경로 계획을 일시적으로 사용할 수 없습니다. 잠시 후 다시 시도하세요.';

  @override
  String get tripPlannerPlannerOutsideBounds => '이 위치는 아직 지원되지 않습니다.';

  @override
  String get tripPlannerPlannerPathNotFound => '이 이동에 가능한 경로가 없습니다.';

  @override
  String get tripPlannerPlannerNoTransitTimes => '현재 이용 가능한 대중교통이 없습니다.';

  @override
  String get tripPlannerPlannerRequestTimeout => '예상보다 오래 걸렸습니다. 다시 시도하세요.';

  @override
  String get tripPlannerPlannerBogusParameter => '요청에 문제가 발생했습니다. 다시 시도하세요.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound => '출발지를 찾을 수 없습니다.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound => '목적지를 찾을 수 없습니다.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      '출발지와 목적지를 모두 찾을 수 없습니다.';

  @override
  String get tripPlannerPlannerTooClose => '출발지와 목적지가 너무 가깝습니다.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      '선택한 옵션으로는 이 경로를 이용할 수 없습니다.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      '출발지가 명확하지 않습니다. 더 구체적으로 입력해 보세요.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      '목적지가 명확하지 않습니다. 더 구체적으로 입력해 보세요.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      '두 위치 모두 더 자세한 정보가 필요합니다. 더 구체적으로 입력해 보세요.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle => '일부 경로 옵션이 누락되었습니다.';

  @override
  String get tripPlannerPlannerTriangleNotAffine => '선택한 경로 옵션을 함께 사용할 수 없습니다.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet => '경로 선호 옵션을 선택하세요.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet => '경로 선호 옵션을 조정하세요.';
}
