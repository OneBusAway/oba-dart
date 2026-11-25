// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class ObaLocalizationsVi extends ObaLocalizations {
  ObaLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get commonBack => 'Quay lại';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonDone => 'Xong';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonContinue => 'Tiếp tục';

  @override
  String get commonNotNow => 'Để sau';

  @override
  String get commonSeeAll => 'Xem tất cả';

  @override
  String get commonLoading => 'Đang tải';

  @override
  String get commonErrorTitle => 'Đã xảy ra lỗi';

  @override
  String get commonOffline =>
      'Có vẻ bạn đang ngoại tuyến. Hãy kiểm tra kết nối và thử lại.';

  @override
  String get commonServerError =>
      'Máy chủ không phản hồi như mong đợi. Hãy thử lại sau giây lát.';

  @override
  String get sheetLabel => 'Bảng';

  @override
  String get sheetExpand => 'Mở rộng bảng';

  @override
  String get sheetCollapse => 'Thu gọn bảng';

  @override
  String get sheetHandleHint => 'Kéo hoặc nhấn đúp để đổi kích thước bảng';

  @override
  String get homeTabHome => 'Trang chủ';

  @override
  String get homeTabRecent => 'Gần đây';

  @override
  String get homeTabBookmarks => 'Dấu trang';

  @override
  String get homeSearchPlaceholder => 'Tìm điểm dừng, tuyến, địa điểm';

  @override
  String get homeSearchLabel => 'Tìm kiếm';

  @override
  String get homeSectionNearby => 'Lân cận';

  @override
  String get homeSectionRecent => 'Điểm dừng gần đây';

  @override
  String get homeSectionBookmarks => 'Dấu trang';

  @override
  String get homeSectionAlerts => 'Cảnh báo';

  @override
  String get homeSectionExplore => 'Khám phá';

  @override
  String get homeSectionMore => 'Cài đặt và khác';

  @override
  String get mapLabel => 'Bản đồ';

  @override
  String get mapZoomInForStops => 'Phóng to để xem các điểm dừng';

  @override
  String get mapLocationDenied =>
      'Quyền truy cập vị trí đang tắt. Chạm để cho phép.';

  @override
  String get mapLocationServicesOff => 'Dịch vụ vị trí đang tắt';

  @override
  String get mapRecenter => 'Hiển thị vị trí của tôi';

  @override
  String get mapSettingsButton => 'Cài đặt bản đồ';

  @override
  String get mapStopsListButton => 'Các điểm dừng trên bản đồ';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm dừng trên bản đồ',
      one: '$count điểm dừng trên bản đồ',
      zero: 'Không có điểm dừng nào trên bản đồ',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'Vị trí của bạn';

  @override
  String get mapDroppedPin => 'Ghim đã thả';

  @override
  String get mapVehicle => 'Phương tiện';

  @override
  String get mapBookmarkedStop => 'Đã đánh dấu';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, điểm dừng $routeType';
  }

  @override
  String get mapStopMarkerHint => 'Mở các chuyến khởi hành của điểm dừng';

  @override
  String mapAttribution(String attribution) {
    return 'Dữ liệu bản đồ: $attribution';
  }

  @override
  String get mapTypeTitle => 'Loại bản đồ';

  @override
  String get mapTypeStandard => 'Tiêu chuẩn';

  @override
  String get mapTypeSatellite => 'Vệ tinh';

  @override
  String get mapTypeHybrid => 'Kết hợp';

  @override
  String get mapShowHeading => 'Hiển thị hướng';

  @override
  String get directionN => 'Hướng Bắc';

  @override
  String get directionNE => 'Hướng Đông Bắc';

  @override
  String get directionE => 'Hướng Đông';

  @override
  String get directionSE => 'Hướng Đông Nam';

  @override
  String get directionS => 'Hướng Nam';

  @override
  String get directionSW => 'Hướng Tây Nam';

  @override
  String get directionW => 'Hướng Tây';

  @override
  String get directionNW => 'Hướng Tây Bắc';

  @override
  String get routeTypeBus => 'Xe buýt';

  @override
  String get routeTypeLightRail => 'Đường sắt nhẹ';

  @override
  String get routeTypeSubway => 'Tàu điện ngầm';

  @override
  String get routeTypeRail => 'Tàu hỏa';

  @override
  String get routeTypeFerry => 'Phà';

  @override
  String get routeTypeCableCar => 'Xe cáp treo';

  @override
  String get routeTypeGondola => 'Cáp treo gondola';

  @override
  String get routeTypeFunicular => 'Đường sắt leo núi';

  @override
  String get routeTypeUnknown => 'Phương tiện công cộng';

  @override
  String stopCode(String code) {
    return 'Điểm dừng $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'Tuyến $routes';
  }

  @override
  String get stopPageRefresh => 'Làm mới';

  @override
  String get stopPageRefreshed => 'Đã cập nhật các chuyến khởi hành';

  @override
  String get stopPageBookmark => 'Đánh dấu điểm dừng';

  @override
  String get stopPageBookmarked => 'Đã đánh dấu. Sửa dấu trang';

  @override
  String get stopPageMoreActions => 'Thêm thao tác cho điểm dừng';

  @override
  String get stopPageSchedules => 'Lịch trình';

  @override
  String get stopPageServiceAlerts => 'Cảnh báo dịch vụ';

  @override
  String get stopPageNearbyStops => 'Điểm dừng lân cận';

  @override
  String get stopPageWalkingDirections => 'Chỉ đường đi bộ';

  @override
  String get stopPageBikeDirections => 'Chỉ đường đi xe đạp';

  @override
  String get stopPagePlanTripFrom => 'Lên kế hoạch chuyến đi từ đây';

  @override
  String get stopPagePlanTripTo => 'Lên kế hoạch chuyến đi đến đây';

  @override
  String get stopPageShareStop => 'Chia sẻ điểm dừng';

  @override
  String get stopPageReportProblem => 'Báo cáo sự cố';

  @override
  String get stopPageFilterRoutes => 'Lọc tuyến';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã ẩn $count tuyến',
      one: 'Đã ẩn $count tuyến',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'Theo thời gian';

  @override
  String get stopPageModeRoute => 'Theo tuyến';

  @override
  String get stopPageDepartureTypes => 'Loại chuyến khởi hành';

  @override
  String get stopPageFilterAll => 'Tất cả chuyến khởi hành';

  @override
  String get stopPageFilterRealtime => 'Chỉ thời gian thực';

  @override
  String get stopPageFilterScheduled => 'Chỉ theo lịch trình';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hiển thị $count chuyến đã khởi hành',
      one: 'Hiển thị $count chuyến đã khởi hành',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Ẩn các chuyến đã khởi hành';

  @override
  String get stopPageLoadMore => 'Tải thêm chuyến khởi hành';

  @override
  String stopPageWindow(int minutes) {
    return 'Hiển thị $minutes phút tới';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Đã cập nhật $ago';
  }

  @override
  String get stopPageStaleTitle => 'Không thể làm mới các chuyến khởi hành';

  @override
  String get stopPageStaleBody => 'Các thời gian này có thể đã lỗi thời.';

  @override
  String get stopPageEmptyTitle => 'Không có chuyến khởi hành sắp tới';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'Không có chuyến nào khởi hành trong $minutes phút tới.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Mọi tuyến có chuyến khởi hành tại đây đều đang bị ẩn.';

  @override
  String get stopPageShowAllRoutes => 'Hiển thị tất cả tuyến';

  @override
  String get stopPageEmptyFilter =>
      'Không có chuyến khởi hành nào khớp với bộ lọc loại chuyến khởi hành.';

  @override
  String get stopPageShowAllTypes => 'Hiển thị tất cả chuyến khởi hành';

  @override
  String get stopPageMissingTitle => 'Không tìm thấy điểm dừng';

  @override
  String get stopPageMissingBody =>
      'Điểm dừng này có thể đã bị xóa hoặc đổi số.';

  @override
  String stopPageWalkTime(int minutes) {
    return 'Đi bộ $minutes phút';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return 'Đi xe đạp $minutes phút';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Đi bộ $minutes phút',
      one: 'Đi bộ $minutes phút',
    );
    return '$_temp0, $distance. Mở chỉ đường.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Đi xe đạp $minutes phút',
      one: 'Đi xe đạp $minutes phút',
    );
    return '$_temp0, $distance. Mở chỉ đường.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return 'Đi bộ $minutes phút đến điểm dừng này. Các chuyến khởi hành phía trên sẽ rời đi sớm hơn.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return 'Đi xe đạp $minutes phút đến điểm dừng này. Các chuyến khởi hành phía trên sẽ rời đi sớm hơn.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Dịch vụ bởi $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cảnh báo dịch vụ',
      one: '$count cảnh báo dịch vụ',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chưa đọc',
      one: '$count chưa đọc',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Chưa đọc';

  @override
  String get stopPageAlertImportant => 'Quan trọng';

  @override
  String get stopPageDirectionsChooser => 'Mở chỉ đường trong';

  @override
  String get stopPageAppleMaps => 'Apple Maps';

  @override
  String get stopPageGoogleMaps => 'Google Maps';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Chuyển từ $route $headsign, đến lúc $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Chuyến khởi hành';

  @override
  String get stopRowNow => 'BÂY GIỜ';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String get stopRowOnTime => 'đúng giờ';

  @override
  String stopRowLate(int minutes) {
    return 'trễ $minutes phút';
  }

  @override
  String stopRowEarly(int minutes) {
    return 'sớm $minutes phút';
  }

  @override
  String get stopRowScheduled => 'theo lịch';

  @override
  String get stopRowCanceled => 'đã hủy';

  @override
  String get stopRowOccupancyEmpty => 'Trống';

  @override
  String get stopRowOccupancyManySeats => 'Còn nhiều chỗ ngồi';

  @override
  String get stopRowOccupancyFewSeats => 'Còn ít chỗ ngồi';

  @override
  String get stopRowOccupancyStanding => 'Chỉ còn chỗ đứng';

  @override
  String get stopRowOccupancyCrushed => 'Rất đông';

  @override
  String get stopRowOccupancyFull => 'Đầy';

  @override
  String get stopRowOccupancyNotAccepting => 'Không nhận hành khách';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'sẽ đến sau $minutes phút',
      one: 'sẽ đến sau $minutes phút',
      zero: 'đang đến ngay bây giờ',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'sẽ khởi hành sau $minutes phút',
      one: 'sẽ khởi hành sau $minutes phút',
      zero: 'đang khởi hành ngay bây giờ',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'đã đến cách đây $minutes phút',
      one: 'đã đến cách đây $minutes phút',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'đã khởi hành cách đây $minutes phút',
      one: 'đã khởi hành cách đây $minutes phút',
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
    return 'Tuyến $route đi $headsign, $eta, lúc $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'theo dõi trực tiếp, $status';
  }

  @override
  String get stopRowA11yScheduledOnly =>
      'chỉ có giờ theo lịch, không có dữ liệu trực tiếp';

  @override
  String get stopRowA11yTransfer => 'chuyến chuyển tiếp của bạn';

  @override
  String get stopRowA11yMissed =>
      'có thể đã lỡ, chuyến này rời đi trước khi bạn đi bộ đến kịp';

  @override
  String get stopRowA11yAlarm => 'đã đặt lời nhắc';

  @override
  String stopRowActions(String route) {
    return 'Thêm thao tác cho tuyến $route';
  }

  @override
  String get stopRowShowTrip => 'Hiển thị chi tiết chuyến đi';

  @override
  String get stopRowAddAlarm => 'Thêm lời nhắc';

  @override
  String get stopRowRemoveAlarm => 'Xóa lời nhắc';

  @override
  String get stopRowBookmarkTrip => 'Đánh dấu chuyến đi này';

  @override
  String get stopRowShareTrip => 'Chia sẻ chuyến đi';

  @override
  String get stopRowRouteSchedule => 'Lịch trình của tuyến';

  @override
  String get stopRowRouteStops => 'Các điểm dừng trên tuyến này';

  @override
  String stopRouteGroupNext(String times) {
    return 'Tiếp theo: $times';
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
      other: '$count chuyến khởi hành',
      one: '$count chuyến khởi hành',
    );
    return 'Tuyến $route đi $headsigns, $_temp0, chuyến tiếp theo $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Nhắc tôi trước khi xe khởi hành';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Trước $minutes phút',
      one: 'Trước $minutes phút',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Đã đặt lời nhắc trước $minutes phút',
      one: 'Đã đặt lời nhắc trước $minutes phút',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Đã xóa lời nhắc';

  @override
  String get stopAlarmFailed => 'Không thể cập nhật lời nhắc.';

  @override
  String get stopAlarmPermissionDenied =>
      'Thông báo đã bị tắt cho ứng dụng này.';

  @override
  String get stopFilterTitle => 'Lọc tuyến';

  @override
  String get stopFilterSort => 'Sắp xếp các chuyến khởi hành';

  @override
  String get stopFilterRoutesHeader => 'Các tuyến hiển thị tại điểm dừng này';

  @override
  String get stopFilterShowAll => 'Hiển thị tất cả tuyến';

  @override
  String get stopTripArrivingAtYourStop => 'Sắp đến điểm dừng của bạn';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cách $count điểm dừng',
      one: 'Cách $count điểm dừng',
      zero: 'Tại điểm dừng của bạn',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return 'Cách $distance';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'Tại $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Vị trí được cập nhật $ago';
  }

  @override
  String get stopTripNoPosition =>
      'Không có vị trí thời gian thực cho phương tiện này';

  @override
  String stopTripStartsAs(String trip) {
    return 'Bắt đầu là $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Tiếp tục là $trip';
  }

  @override
  String get stopTripStopsHeader => 'Điểm dừng';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm dừng đã qua',
      one: '$count điểm dừng đã qua',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm dừng trước điểm dừng của bạn',
      one: '$count điểm dừng trước điểm dừng của bạn',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'Điểm dừng của bạn';

  @override
  String get stopTripBoarding => 'Đang đón khách';

  @override
  String get stopTripVehicleHere => 'Phương tiện đã đến đây';

  @override
  String get stopTripTerminal => 'Điểm dừng cuối';

  @override
  String get stopTripPassed => 'Đã qua';

  @override
  String get stopTripRouteStops => 'Tất cả điểm dừng trên tuyến này';

  @override
  String get stopTripReport => 'Báo cáo sự cố với chuyến đi này';

  @override
  String get stopTripGhostBus => 'Báo cáo xe buýt ma';

  @override
  String get stopTripCanceled => 'Chuyến đi này đã bị hủy';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Phương tiện trên tuyến $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'Cứ $minutes phút một chuyến';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Tuyến $route';
  }

  @override
  String get stopRouteStopsDirection => 'Hướng đi';

  @override
  String stopRouteStopsToward(String name) {
    return 'Đi $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm dừng',
      one: '$count điểm dừng',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty =>
      'Không tìm thấy điểm dừng nào cho tuyến này.';

  @override
  String get stopSchedPrevDay => 'Ngày trước';

  @override
  String get stopSchedNextDay => 'Ngày sau';

  @override
  String stopSchedPickDate(String date) {
    return 'Chọn ngày, $date';
  }

  @override
  String get stopSchedRoute => 'Tuyến';

  @override
  String get stopSchedDirection => 'Hướng đi';

  @override
  String get stopSchedStop => 'Điểm dừng';

  @override
  String get stopSchedEmpty => 'Không có dịch vụ theo lịch vào ngày này.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'Cứ $minutes phút một chuyến từ $start đến $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'Đi $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chuyến khởi hành',
      one: '$count chuyến khởi hành',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported =>
      'Bảng giờ chạy không khả dụng ở khu vực này.';

  @override
  String get stopSchedViewList => 'Danh sách';

  @override
  String get stopSchedViewGrid => 'Lưới';

  @override
  String get stopSchedNoDeparture => 'Không có chuyến khởi hành';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (điểm dừng của bạn)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, chuyến $trip: $time';
  }

  @override
  String get stopReportProblemHeader => 'Vấn đề là gì?';

  @override
  String get stopReportStopNameWrong => 'Tên điểm dừng bị sai';

  @override
  String get stopReportStopNumberWrong => 'Số điểm dừng bị sai';

  @override
  String get stopReportStopLocationWrong => 'Điểm dừng nằm sai vị trí';

  @override
  String get stopReportRouteMissing => 'Thiếu một tuyến hoặc chuyến đi';

  @override
  String get stopReportOther => 'Vấn đề khác';

  @override
  String get stopReportNeverCame => 'Phương tiện không đến';

  @override
  String get stopReportCameEarly => 'Đến sớm';

  @override
  String get stopReportCameLate => 'Đến trễ';

  @override
  String get stopReportWrongHeadsign => 'Bảng hiệu điểm đến bị sai';

  @override
  String get stopReportNotStopHere => 'Xe không dừng ở đây';

  @override
  String get stopReportComment => 'Nhận xét thêm (không bắt buộc)';

  @override
  String get stopReportShareLocation => 'Chia sẻ vị trí của tôi';

  @override
  String get stopReportShareLocationHelp =>
      'Chia sẻ vị trí của bạn có thể giúp cơ quan vận tải khắc phục sự cố này.';

  @override
  String get stopReportOnVehicle => 'Tôi đang ở trên phương tiện này';

  @override
  String get stopReportVehicleId => 'Số hiệu phương tiện (không bắt buộc)';

  @override
  String get stopReportSend => 'Gửi báo cáo';

  @override
  String get stopReportSending => 'Đang gửi báo cáo';

  @override
  String get stopReportSent => 'Cảm ơn bạn! Báo cáo của bạn đã được gửi.';

  @override
  String get stopReportFailed => 'Không thể gửi báo cáo. Vui lòng thử lại.';

  @override
  String get stopReportChooseProblem => 'Hãy chọn một vấn đề trước.';

  @override
  String stopReportAbout(String name) {
    return 'Đang báo cáo: $name';
  }

  @override
  String get stopGhostTitle => 'Báo cáo xe buýt ma';

  @override
  String get stopGhostExplain =>
      'Xe buýt ma là xe mà ứng dụng đã hiển thị nhưng không bao giờ đến.';

  @override
  String get stopGhostWait => 'Bạn đã chờ bao lâu sau giờ theo lịch?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30+ phút';

  @override
  String get stopCardEmpty => 'Sắp tới không có chuyến khởi hành';

  @override
  String get titleSearch => 'Tìm kiếm';

  @override
  String get titleSearchResults => 'Kết quả';

  @override
  String get titleNearbyStops => 'Điểm dừng lân cận';

  @override
  String get titleRecentStops => 'Điểm dừng gần đây';

  @override
  String get titleBookmarks => 'Dấu trang';

  @override
  String get titleStop => 'Điểm dừng';

  @override
  String get titleTrip => 'Chuyến đi';

  @override
  String get titleRouteStops => 'Tuyến';

  @override
  String get titleStopSchedule => 'Lịch trình';

  @override
  String get titleRouteSchedule => 'Lịch trình tuyến';

  @override
  String get titleAlerts => 'Cảnh báo';

  @override
  String get titleAlertDetail => 'Cảnh báo';

  @override
  String get titleAgencies => 'Cơ quan vận tải';

  @override
  String get titleRegionPicker => 'Khu vực';

  @override
  String get titleCustomRegion => 'Khu vực tùy chỉnh';

  @override
  String get titleSettings => 'Cài đặt';

  @override
  String get titleMapSettings => 'Cài đặt bản đồ';

  @override
  String get titleMore => 'Thêm';

  @override
  String get titleTripPlanner => 'Lên kế hoạch chuyến đi';

  @override
  String get titlePlace => 'Địa điểm';

  @override
  String get titleReportStopProblem => 'Báo cáo sự cố';

  @override
  String get titleReportTripProblem => 'Báo cáo sự cố';

  @override
  String get titleBookmarkEditor => 'Dấu trang';

  @override
  String get titleManageBookmarks => 'Sửa dấu trang';

  @override
  String get titleCredits => 'Ghi công';

  @override
  String get titleWeather => 'Thời tiết';

  @override
  String get titleStopsOnMap => 'Các điểm dừng trên bản đồ';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Chào mừng đến với $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Giờ đến thời gian thực cho xe buýt, tàu hỏa và phà gần bạn.';

  @override
  String get onboardingLocationTitle => 'Tìm điểm dừng gần bạn';

  @override
  String get onboardingLocationBody =>
      'Cho phép truy cập vị trí để xem các điểm dừng lân cận và tự động chọn khu vực của bạn.';

  @override
  String get onboardingAllowLocation => 'Cho phép truy cập vị trí';

  @override
  String get onboardingRegionTitle => 'Chọn khu vực của bạn';

  @override
  String get onboardingRegionBody =>
      'Chọn khu vực mà bạn muốn xem phương tiện công cộng.';

  @override
  String get settingsSectionMap => 'Bản đồ';

  @override
  String get settingsMapTypeRow => 'Loại bản đồ và lớp hiển thị';

  @override
  String get settingsMapTypeHelp => 'Chọn giao diện của bản đồ.';

  @override
  String get settingsHeadingHelp =>
      'Hiển thị hướng bạn đang quay mặt trên bản đồ.';

  @override
  String get settingsWalkingDirections => 'Chỉ đường đi bộ';

  @override
  String get settingsWalkingDirectionsHelp =>
      'Ứng dụng sẽ mở khi bạn yêu cầu chỉ đường đi bộ đến một điểm dừng.';

  @override
  String get settingsDirectionsAsk => 'Hỏi mỗi lần';

  @override
  String get settingsDirectionsAppleMaps => 'Apple Maps';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Maps';

  @override
  String get settingsSectionDepartures => 'Chuyến khởi hành';

  @override
  String get settingsDepartureFilter => 'Hiển thị chuyến khởi hành';

  @override
  String get settingsDepartureFilterHelp =>
      'Chọn xem trang điểm dừng liệt kê mọi chuyến khởi hành hay chỉ những chuyến có dữ liệu thời gian thực hoặc theo lịch trình.';

  @override
  String get settingsFilterAll => 'Tất cả chuyến khởi hành';

  @override
  String get settingsFilterRealtime => 'Chỉ thời gian thực';

  @override
  String get settingsFilterScheduled => 'Chỉ theo lịch trình';

  @override
  String get settingsSectionAccessibility => 'Trợ năng';

  @override
  String get settingsReducedColors => 'Giảm màu sắc trên trang điểm dừng';

  @override
  String get settingsReducedColorsHelp =>
      'Hiển thị huy hiệu tuyến theo một kiểu trung tính duy nhất.';

  @override
  String get settingsSectionWalking => 'Tốc độ đi bộ';

  @override
  String get settingsWalkingSpeed => 'Tốc độ đi bộ';

  @override
  String get settingsWalkingSpeedHelp =>
      'Dùng để ước tính thời gian đi bộ và giờ đến.';

  @override
  String get settingsSpeedSlow => 'Chậm';

  @override
  String get settingsSpeedAverage => 'Trung bình';

  @override
  String get settingsSpeedFast => 'Nhanh';

  @override
  String settingsSpeedCustom(String speed) {
    return 'Tùy chỉnh ($speed m/s)';
  }

  @override
  String get settingsSectionBike => 'Chế độ xe đạp';

  @override
  String get settingsBikeMode => 'Chế độ xe đạp';

  @override
  String get settingsBikeModeHelp =>
      'Dùng tốc độ di chuyển nhanh hơn để ước tính thời gian đi bộ, giờ đến và trang điểm dừng.';

  @override
  String get settingsSectionSurveys => 'Khảo sát';

  @override
  String get settingsSurveysEnabled => 'Hiển thị khảo sát';

  @override
  String get settingsSurveysAlways =>
      'Luôn hiển thị khảo sát tại các điểm dừng';

  @override
  String get settingsSectionPrivacy => 'Quyền riêng tư';

  @override
  String get settingsAnalytics => 'Gửi dữ liệu sử dụng cho nhà phát triển';

  @override
  String get settingsAnalyticsHelp =>
      'Giúp nhà phát triển biết những tính năng nào đang được sử dụng.';

  @override
  String get settingsSectionDebug => 'Gỡ lỗi';

  @override
  String get settingsDebugMode => 'Chế độ gỡ lỗi';

  @override
  String get settingsDebugAlwaysFeedback => 'Luôn hiển thị lời nhắc phản hồi';

  @override
  String get settingsDebugResetFeedback =>
      'Đặt lại trạng thái lời nhắc phản hồi';

  @override
  String get settingsDebugResetDonation => 'Đặt lại trạng thái thẻ quyên góp';

  @override
  String get settingsDebugResetDone => 'Đã đặt lại';

  @override
  String get settingsSectionTripPlanner => 'Trình lên kế hoạch chuyến đi';

  @override
  String get settingsHomeCustomizeMap => 'Tùy chỉnh bản đồ';

  @override
  String get moreHeaderSupport =>
      'Ứng dụng này do các tình nguyện viên xây dựng và hỗ trợ.';

  @override
  String get moreSectionDonate => 'Trở thành người ủng hộ';

  @override
  String moreDonate(String appName) {
    return 'Quyên góp cho $appName';
  }

  @override
  String get moreManageDonations => 'Quản lý các khoản quyên góp';

  @override
  String get moreSectionUpdates => 'Cập nhật và cảnh báo';

  @override
  String get moreAlerts => 'Cảnh báo';

  @override
  String get moreSectionLocation => 'Vị trí của tôi';

  @override
  String get moreRegion => 'Khu vực';

  @override
  String get moreRegionNone => 'Chưa chọn';

  @override
  String get morePayFare => 'Thanh toán giá vé của tôi';

  @override
  String get moreAgencies => 'Cơ quan vận tải';

  @override
  String get moreSectionAbout => 'Giới thiệu về ứng dụng này';

  @override
  String moreRateApp(String appName) {
    return 'Đánh giá $appName';
  }

  @override
  String get moreContactUs => 'Liên hệ với chúng tôi';

  @override
  String get morePrivacy => 'Chính sách quyền riêng tư';

  @override
  String get moreCredits => 'Ghi công';

  @override
  String moreVersion(String appName, String version) {
    return '$appName phiên bản $version';
  }

  @override
  String get moreSectionHelpOut => 'Giúp cải thiện ứng dụng';

  @override
  String get moreTranslate => 'Giúp dịch ứng dụng';

  @override
  String get moreDevelop => 'Giúp sửa lỗi và xây dựng tính năng mới';

  @override
  String get moreSectionContact => 'Liên hệ và trợ giúp';

  @override
  String get moreTutorials => 'Hướng dẫn';

  @override
  String get moreCallAgency => 'Gọi cho cơ quan vận tải';

  @override
  String get moreTextAgency => 'Nhắn tin cho cơ quan vận tải';

  @override
  String get moreSectionResources => 'Tài nguyên';

  @override
  String get moreContactTitle => 'Liên hệ với chúng tôi';

  @override
  String get moreContactDevelopers => 'Yêu cầu tính năng hoặc báo cáo lỗi';

  @override
  String get moreContactAgency => 'Sự cố về phương tiện hoặc lịch trình';

  @override
  String moreEmailSubject(String appName) {
    return 'Phản hồi về $appName';
  }

  @override
  String get moreEmailAgencySubject =>
      'Phản hồi của hành khách đi phương tiện công cộng';

  @override
  String get moreEmailIntro =>
      'Chúng tôi có thể giúp gì cho bạn? Vui lòng nhập phản hồi của bạn bên dưới:';

  @override
  String get moreEmailDebugIntro =>
      'Thông tin sau được cung cấp nhằm mục đích khắc phục sự cố. Nếu bạn không muốn chia sẻ bất kỳ thông tin nào, bạn có thể xóa đi, nhưng điều đó có thể ảnh hưởng đến khả năng hỗ trợ bạn của chúng tôi.';

  @override
  String get moreDebugAppVersion => 'Phiên bản ứng dụng';

  @override
  String get moreDebugOs => 'Hệ điều hành';

  @override
  String get moreDebugLocale => 'Ngôn ngữ';

  @override
  String get moreDebugBookmarks => 'Số lượng dấu trang';

  @override
  String get moreDebugLocationPermission => 'Quyền truy cập vị trí';

  @override
  String get moreDebugRegion => 'Khu vực';

  @override
  String get moreDebugRegionId => 'ID khu vực';

  @override
  String get moreDebugApiUrl => 'URL API gốc';

  @override
  String get moreDebugUserId => 'ID người dùng';

  @override
  String get moreCantEmailTitle => 'Không thể mở ứng dụng email của bạn';

  @override
  String moreCantEmailBody(String email) {
    return 'Để liên hệ với chúng tôi, hãy gửi email đến $email. Hãy sao chép thông tin gỡ lỗi và dán vào tin nhắn của bạn để giúp chúng tôi khắc phục sự cố.';
  }

  @override
  String get moreCopyEmail => 'Sao chép địa chỉ email';

  @override
  String get moreCopyDebug => 'Sao chép thông tin gỡ lỗi';

  @override
  String get moreCopied => 'Đã sao chép vào bộ nhớ tạm';

  @override
  String get moreFareContinue => 'Tiếp tục';

  @override
  String get moreFareDontShowAgain => 'Tiếp tục và không hiển thị lại';

  @override
  String get commonCantOpenLink => 'Không thể mở liên kết đó.';

  @override
  String get regionPickerAutomatic => 'Tự động chọn khu vực';

  @override
  String get regionPickerAutomaticHelp =>
      'Chuyển sang khu vực chứa vị trí của bạn. Tùy chọn này sẽ tắt khi bạn tự chọn khu vực.';

  @override
  String get regionPickerShowExperimental => 'Hiển thị khu vực thử nghiệm';

  @override
  String get regionPickerShowInactive => 'Hiển thị khu vực không hoạt động';

  @override
  String get regionPickerRegionsSection => 'Khu vực';

  @override
  String get regionPickerCustomSection => 'Khu vực tùy chỉnh';

  @override
  String get regionPickerCurrent => 'Khu vực hiện tại';

  @override
  String get regionPickerExperimentalTag => 'Thử nghiệm';

  @override
  String get regionPickerInactiveTag => 'Không hoạt động';

  @override
  String get regionPickerCustomTag => 'Tùy chỉnh';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Thêm khu vực tùy chỉnh';

  @override
  String get regionPickerRefresh => 'Làm mới khu vực';

  @override
  String get regionPickerRefreshed => 'Đã cập nhật các khu vực';

  @override
  String get regionPickerRefreshFailed =>
      'Không thể cập nhật danh sách khu vực. Đang hiển thị danh sách đã lưu.';

  @override
  String regionPickerSelected(String name) {
    return 'Đã chọn $name';
  }

  @override
  String regionPickerEdit(String name) {
    return 'Sửa $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'Xóa $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'Xóa $name?';
  }

  @override
  String get regionPickerDeleteBody =>
      'Khu vực tùy chỉnh này sẽ bị xóa khỏi thiết bị này.';

  @override
  String get regionPickerDeleteConfirm => 'Xóa';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Hãy chọn một khu vực khác trước khi xóa khu vực này.';

  @override
  String get regionPickerEmpty => 'Không có khu vực nào';

  @override
  String get regionPickerEmptyBody =>
      'Hãy bật khu vực thử nghiệm hoặc không hoạt động, hoặc thêm khu vực tùy chỉnh.';

  @override
  String get regionPickerTripPlanner =>
      'Trình lên kế hoạch chuyến đi trong khu vực này';

  @override
  String get customRegionEditTitle => 'Sửa khu vực tùy chỉnh';

  @override
  String get customRegionName => 'Tên';

  @override
  String get customRegionObaUrl => 'URL máy chủ OneBusAway';

  @override
  String get customRegionObaUrlHelp =>
      'Địa chỉ của máy chủ, ví dụ https://oba.example.com/';

  @override
  String get customRegionSidecar => 'URL máy chủ Sidecar (không bắt buộc)';

  @override
  String get customRegionOtp =>
      'URL trình lên kế hoạch chuyến đi (không bắt buộc)';

  @override
  String get customRegionOtpGraphql =>
      'URL GraphQL của trình lên kế hoạch chuyến đi (không bắt buộc)';

  @override
  String get customRegionServiceArea => 'Khu vực phục vụ';

  @override
  String get customRegionServiceAreaHelp =>
      'Vùng mà khu vực này bao phủ: một điểm trung tâm và phạm vi mở rộng của nó.';

  @override
  String get customRegionLatitude => 'Vĩ độ trung tâm';

  @override
  String get customRegionLongitude => 'Kinh độ trung tâm';

  @override
  String get customRegionLatSpan => 'Biên độ vĩ độ (độ)';

  @override
  String get customRegionLonSpan => 'Biên độ kinh độ (độ)';

  @override
  String get customRegionUseMap => 'Dùng vùng bản đồ hiện tại';

  @override
  String get customRegionSave => 'Lưu';

  @override
  String get customRegionErrorRequired => 'Trường này là bắt buộc';

  @override
  String get customRegionErrorUrl =>
      'Nhập địa chỉ web bắt đầu bằng http:// hoặc https://';

  @override
  String get customRegionErrorNumber => 'Nhập một số';

  @override
  String get customRegionErrorRange => 'Số này nằm ngoài phạm vi cho phép';

  @override
  String get customRegionChecking => 'Đang kiểm tra máy chủ';

  @override
  String get customRegionServerOk => 'Máy chủ đã phản hồi';

  @override
  String get customRegionServerUnreachable =>
      'Không thể kết nối đến máy chủ này';

  @override
  String get customRegionServerNotOba =>
      'Máy chủ này không phản hồi giống OneBusAway';

  @override
  String customRegionSaved(String name) {
    return 'Đã lưu $name';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway là phần mềm vận tải công cộng mã nguồn mở, miễn phí, do các tình nguyện viên xây dựng và được Open Transit Software Foundation hỗ trợ.';

  @override
  String get creditsLicenseTitle => 'Giấy phép';

  @override
  String get creditsMapData => 'Dữ liệu bản đồ';

  @override
  String get creditsLicenses => 'Giấy phép mã nguồn mở';

  @override
  String get creditsLicensesHelp =>
      'Các thư viện được dùng để xây dựng ứng dụng này.';

  @override
  String get creditsLicensesLoading => 'Đang tải giấy phép';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giấy phép',
      one: '$count giấy phép',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Có mặt tại hàng chục khu vực vận tải trên toàn thế giới.';

  @override
  String get onboardingBenefitNearbyTitle => 'Xem các điểm dừng lân cận';

  @override
  String get onboardingBenefitNearbyBody =>
      'Xe buýt và tàu hỏa quanh bạn, sắp xếp theo khoảng cách.';

  @override
  String get onboardingBenefitMapTitle => 'Đưa bản đồ về vị trí của bạn';

  @override
  String get onboardingBenefitMapBody =>
      'Mở thẳng đến khu vực xung quanh bạn mà không cần tìm kiếm.';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName chỉ sử dụng vị trí của bạn khi ứng dụng đang mở. Bạn có thể thay đổi điều này bất cứ lúc nào trong cài đặt thiết bị.';
  }

  @override
  String get onboardingLocationDenied =>
      'Quyền truy cập vị trí đang tắt. Bạn vẫn có thể tự chọn khu vực của mình.';

  @override
  String get onboardingRegionDetected => 'Được phát hiện gần bạn';

  @override
  String onboardingRegionUse(String name) {
    return 'Dùng $name';
  }

  @override
  String get onboardingRegionOthers => 'Hoặc chọn khu vực khác';

  @override
  String get onboardingRegionEmpty =>
      'Hiện không có khu vực nào. Hãy kiểm tra kết nối và thử lại.';

  @override
  String get surveyCardTitle => 'Giúp cải thiện giao thông công cộng';

  @override
  String get surveyDefaultPrompt =>
      'Hãy thực hiện một khảo sát ngắn để giúp cải thiện giao thông công cộng.';

  @override
  String get surveyTake => 'Làm khảo sát';

  @override
  String get surveyNotNow => 'Để sau';

  @override
  String get surveyDismiss => 'Đóng khảo sát';

  @override
  String get surveyNext => 'Tiếp theo';

  @override
  String get surveySubmit => 'Gửi khảo sát';

  @override
  String get surveySubmitting => 'Đang gửi';

  @override
  String get surveyQuestionsTitle => 'Khảo sát';

  @override
  String get surveyTextHint => 'Nhập câu trả lời của bạn';

  @override
  String get surveyRequired => 'Bắt buộc';

  @override
  String get surveyIncomplete =>
      'Vui lòng trả lời tất cả các câu hỏi bắt buộc trước khi gửi.';

  @override
  String get surveyFailed =>
      'Không thể gửi câu trả lời của bạn. Vui lòng thử lại.';

  @override
  String get surveyThanks => 'Cảm ơn phản hồi của bạn.';

  @override
  String get surveyOpenSurvey => 'Mở khảo sát';

  @override
  String get surveyLearnMore => 'Tìm hiểu thêm';

  @override
  String get surveyShareFeedback => 'Chia sẻ phản hồi';

  @override
  String get surveySignUp => 'Đăng ký';

  @override
  String get surveyExternalError =>
      'Không thể mở liên kết khảo sát này. Vui lòng thử lại sau.';

  @override
  String donationTitle(String appName) {
    return '$appName cần sự giúp đỡ của bạn';
  }

  @override
  String get donationBody =>
      'Ứng dụng này được xây dựng bằng công sức của các tình nguyện viên, và chúng tôi cần bạn giúp tài trợ cho việc phát triển trong tương lai.';

  @override
  String get donationLearnMore => 'Tìm hiểu thêm';

  @override
  String get donationDonate => 'Quyên góp ngay';

  @override
  String get donationRemindLater => 'Nhắc tôi sau';

  @override
  String get donationDismiss => 'Không, cảm ơn';

  @override
  String get donationHeader => 'Đây là lý do chúng tôi cần sự giúp đỡ của bạn';

  @override
  String donationExplanation(String appName) {
    return 'Chúng tôi có những kế hoạch lớn để cải thiện $appName, nhưng không thể thực hiện nếu thiếu sự giúp đỡ của bạn. Ứng dụng này được xây dựng bằng công sức của các tình nguyện viên, và chúng tôi cần bạn giúp tài trợ cho việc phát triển trong tương lai.\n\nLà một dự án trọng điểm của Open Transit Software Foundation, một tổ chức phi lợi nhuận, khoản quyên góp của bạn được khấu trừ thuế tại Hoa Kỳ.';
  }

  @override
  String get donationDonateWebsite => 'Quyên góp trên trang web của chúng tôi';

  @override
  String titleDonation(String appName) {
    return 'Ủng hộ $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'Bạn có thích $appName không?';
  }

  @override
  String get feedbackYes => 'Có!';

  @override
  String get feedbackNo => 'Không hẳn';

  @override
  String get feedbackLater => 'Hỏi tôi sau';

  @override
  String get feedbackNegativeTitle => 'Rất tiếc về điều đó.';

  @override
  String get feedbackNegativeBody =>
      'Bạn có thể cho chúng tôi biết điều gì chưa ổn không? Chúng tôi đọc mọi tin nhắn.';

  @override
  String get feedbackSend => 'Gửi phản hồi';

  @override
  String get feedbackDecline => 'Không, cảm ơn';

  @override
  String get tripPlanningUnavailable =>
      'Tính năng lên kế hoạch chuyến đi không khả dụng ở khu vực này.';

  @override
  String get deepLinkOtherRegion =>
      'Liên kết này dành cho một khu vực khác. Hãy chuyển khu vực để mở.';

  @override
  String get dataUpdated => 'Đã cập nhật';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Tuyến $route đi $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Tuyến $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Đang tải các chuyến khởi hành';

  @override
  String get bookmarksNoDepartures => 'Không có chuyến khởi hành sắp tới';

  @override
  String get bookmarksDeparturesError => 'Không thể tải các chuyến khởi hành';

  @override
  String get bookmarksDeparturesStale =>
      'Không thể làm mới. Đang hiển thị các giờ trước đó.';

  @override
  String get bookmarksUpdated => 'Đã cập nhật các chuyến khởi hành';

  @override
  String get bookmarksSortTooltip => 'Sắp xếp dấu trang';

  @override
  String get bookmarksSortByGroup => 'Sắp xếp theo nhóm';

  @override
  String get bookmarksSortByDistance => 'Sắp xếp theo khoảng cách';

  @override
  String get bookmarksManageTooltip => 'Sửa dấu trang và nhóm';

  @override
  String get bookmarksRefreshTooltip => 'Làm mới các chuyến khởi hành';

  @override
  String get bookmarksEmptyTitle => 'Chưa có dấu trang';

  @override
  String get bookmarksEmptyBody =>
      'Hãy mở một điểm dừng và chạm vào nút dấu trang để lưu tại đây. Từ một chuyến khởi hành, bạn cũng có thể chỉ đánh dấu riêng tuyến đó tại điểm dừng.';

  @override
  String get bookmarksFindStops => 'Tìm điểm dừng trên bản đồ';

  @override
  String get bookmarksUngrouped => 'Chưa phân nhóm';

  @override
  String get bookmarksGroupExpanded => 'đã mở rộng';

  @override
  String get bookmarksGroupCollapsed => 'đã thu gọn';

  @override
  String get bookmarksGroupToggleHint =>
      'Hiện hoặc ẩn các dấu trang trong nhóm này';

  @override
  String bookmarksActionsFor(String name) {
    return 'Thao tác cho $name';
  }

  @override
  String get bookmarksActionEdit => 'Sửa';

  @override
  String get bookmarksActionPin => 'Ghim lên đầu';

  @override
  String get bookmarksActionUnpin => 'Bỏ ghim';

  @override
  String get bookmarksActionMove => 'Chuyển vào nhóm';

  @override
  String get bookmarksActionDelete => 'Xóa';

  @override
  String get bookmarksPinned => 'Đã ghim';

  @override
  String bookmarksDeleted(String name) {
    return 'Đã xóa $name';
  }

  @override
  String get bookmarksUndo => 'Hoàn tác';

  @override
  String get bookmarksMoveTitle => 'Chuyển vào nhóm';

  @override
  String get bookmarksNoGroup => 'Không có nhóm';

  @override
  String bookmarksMoved(String group) {
    return 'Đã chuyển vào $group';
  }

  @override
  String get bookmarksEditorNameLabel => 'Tên dấu trang';

  @override
  String get bookmarksEditorNameRequired => 'Hãy nhập tên cho dấu trang này.';

  @override
  String get bookmarksEditorDuplicate =>
      'Bạn đã có một dấu trang với tên này cho điểm dừng và tuyến này. Hãy đổi tên để lưu thêm một dấu trang khác.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Dấu trang điểm dừng: hiển thị các chuyến khởi hành tiếp theo của mọi tuyến tại $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Dấu trang chuyến đi: hiển thị các chuyến khởi hành tiếp theo của $route tại $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'Chỉ $route';
  }

  @override
  String get bookmarksEditorGroup => 'Nhóm';

  @override
  String get bookmarksEditorNewGroup => 'Nhóm mới…';

  @override
  String get bookmarksEditorNewGroupTitle => 'Nhóm mới';

  @override
  String get bookmarksEditorGroupName => 'Tên nhóm';

  @override
  String get bookmarksEditorSave => 'Lưu';

  @override
  String get bookmarksEditorSaved => 'Đã lưu dấu trang';

  @override
  String get bookmarksEditorDelete => 'Xóa dấu trang';

  @override
  String get bookmarksEditorDeleteTitle => 'Xóa dấu trang này?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '“$name” sẽ bị xóa khỏi dấu trang của bạn.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Hãy chọn khu vực trước khi thêm dấu trang.';

  @override
  String get bookmarksManageGroupsHeader => 'Nhóm';

  @override
  String get bookmarksManageAddGroup => 'Thêm nhóm';

  @override
  String get bookmarksManageRenameGroup => 'Đổi tên nhóm';

  @override
  String get bookmarksManageDeleteGroup => 'Xóa nhóm';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'Các dấu trang trong “$name” sẽ trở thành chưa phân nhóm.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Di chuyển $name lên';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Di chuyển $name xuống';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Sắp xếp lại $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, vị trí $position trên $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'Chưa có dấu trang hoặc nhóm nào để quản lý.';

  @override
  String get bookmarksManageUngrouped => 'Dấu trang chưa phân nhóm';

  @override
  String get recentsEmptyTitle => 'Không có điểm dừng gần đây';

  @override
  String get recentsEmptyBody =>
      'Các điểm dừng bạn đã xem sẽ hiển thị ở đây, mới nhất trước.';

  @override
  String get recentsFindStops => 'Tìm điểm dừng trên bản đồ';

  @override
  String get recentsClearAll => 'Xóa tất cả';

  @override
  String get recentsClearTitle => 'Xóa các điểm dừng gần đây?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Thao tác này sẽ xóa tất cả $count điểm dừng gần đây. Dấu trang của bạn không bị ảnh hưởng.',
      one:
          'Thao tác này sẽ xóa $count điểm dừng gần đây. Dấu trang của bạn không bị ảnh hưởng.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Xóa $name khỏi các điểm dừng gần đây';
  }

  @override
  String recentsRemoved(String name) {
    return 'Đã xóa $name';
  }

  @override
  String get recentsSectionEmpty =>
      'Các điểm dừng bạn đã xem sẽ hiển thị ở đây.';

  @override
  String get alarmsSectionTitle => 'Lời nhắc';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Trước giờ khởi hành $minutes phút',
      one: 'Trước giờ khởi hành $minutes phút',
    );
    return '$_temp0, lúc $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Lời nhắc cho $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'Xóa lời nhắc cho $title';
  }

  @override
  String get alarmsDeleted => 'Đã xóa lời nhắc';

  @override
  String get alarmsDeleteFailed =>
      'Không thể xóa lời nhắc. Hãy kiểm tra kết nối và thử lại.';

  @override
  String get alertsEmptyTitle => 'Không có cảnh báo dịch vụ';

  @override
  String get alertsEmptyBody =>
      'Hiện không có cảnh báo dịch vụ nào đang hiệu lực.';

  @override
  String get alertsRegionNote =>
      'Bao gồm cảnh báo cho các điểm dừng bạn đã đánh dấu, gần đây và lân cận.';

  @override
  String get alertsMarkAllRead => 'Đánh dấu tất cả là đã đọc';

  @override
  String get alertsAllRead => 'Đã đánh dấu tất cả cảnh báo là đã đọc';

  @override
  String get alertsUnread => 'Chưa đọc';

  @override
  String get alertsSeverityInfo => 'Thông tin';

  @override
  String get alertsSeverityWarning => 'Cảnh báo';

  @override
  String get alertsSeveritySevere => 'Nghiêm trọng';

  @override
  String get alertsSeverityUnknown => 'Cảnh báo dịch vụ';

  @override
  String get alertsNoTitle => 'Cảnh báo dịch vụ';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Chưa đọc. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cảnh báo chưa đọc',
      one: '$count cảnh báo chưa đọc',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Thêm $count cảnh báo',
      one: 'Thêm $count cảnh báo',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Thời gian hiệu lực';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start đến $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'Từ $start';
  }

  @override
  String get alertsDetailAffects => 'Ảnh hưởng đến';

  @override
  String get alertsDetailRoutes => 'Tuyến';

  @override
  String get alertsDetailStops => 'Điểm dừng';

  @override
  String get alertsDetailLearnMore => 'Tìm hiểu thêm';

  @override
  String get alertsDetailNoDetails => 'Không có thêm chi tiết nào.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Phát hành $date';
  }

  @override
  String get agenciesEmptyTitle => 'Không có cơ quan vận tải';

  @override
  String get agenciesEmptyBody =>
      'Khu vực này không liệt kê cơ quan vận tải nào.';

  @override
  String get agenciesWebsite => 'Trang web';

  @override
  String agenciesPhone(String phone) {
    return 'Gọi $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'Gửi email đến $email';
  }

  @override
  String get agenciesFares => 'Thông tin giá vé';

  @override
  String get agenciesDisclaimer => 'Tuyên bố miễn trừ trách nhiệm';

  @override
  String get agenciesShowOnMap => 'Hiển thị phạm vi phục vụ trên bản đồ';

  @override
  String get searchFieldLabel => 'Tìm kiếm';

  @override
  String get searchFieldHint => 'Tuyến, số điểm dừng, địa chỉ hoặc phương tiện';

  @override
  String get searchClear => 'Xóa nội dung tìm kiếm';

  @override
  String get searchScopeLabel => 'Tìm kiếm';

  @override
  String get searchScopeAll => 'Tất cả';

  @override
  String get searchScopeStops => 'Điểm dừng';

  @override
  String get searchScopeRoutes => 'Tuyến';

  @override
  String get searchScopePlaces => 'Địa điểm';

  @override
  String get searchQuickHeader => 'Tìm kiếm';

  @override
  String searchQuickRoute(String query) {
    return 'Tuyến: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Số điểm dừng: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Địa chỉ: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Phương tiện: $query';
  }

  @override
  String get searchRecentStopsHeader => 'Điểm dừng gần đây';

  @override
  String get searchBookmarksHeader => 'Dấu trang';

  @override
  String get searchRecentSearchesHeader => 'Tìm kiếm gần đây';

  @override
  String get searchRecentPlacesHeader => 'Địa điểm gần đây';

  @override
  String get searchPlacesHeader => 'Địa điểm';

  @override
  String get searchClearRecent => 'Xóa các tìm kiếm gần đây';

  @override
  String get searchClearRecentConfirm =>
      'Xóa các tìm kiếm và địa điểm gần đây của bạn?';

  @override
  String get searchClearAction => 'Xóa';

  @override
  String get searchRecentCleared => 'Đã xóa các tìm kiếm gần đây';

  @override
  String get searchPlacesLoading => 'Đang tìm địa điểm';

  @override
  String get searchPlacesNone => 'Không tìm thấy địa điểm nào';

  @override
  String get searchPlacesError =>
      'Không thể tìm địa điểm. Hãy kiểm tra kết nối của bạn.';

  @override
  String get searchSearching => 'Đang tìm kiếm';

  @override
  String get searchNoResultsTitle => 'Không có kết quả';

  @override
  String searchNoResultsBody(String query) {
    return 'Không tìm thấy kết quả nào cho “$query”.';
  }

  @override
  String get searchUnavailableNoRegion =>
      'Hãy chọn khu vực trước khi tìm kiếm.';

  @override
  String get searchUnavailableAddress =>
      'Tính năng tìm kiếm địa chỉ chưa được thiết lập trong ứng dụng này.';

  @override
  String get searchUnavailableVehicle =>
      'Tính năng tìm kiếm phương tiện không khả dụng ở khu vực này.';

  @override
  String get searchEmptyTitle => 'Tìm tuyến, điểm dừng và địa điểm';

  @override
  String get searchEmptyBody =>
      'Nhập tên tuyến, số điểm dừng, địa chỉ hoặc ID phương tiện.';

  @override
  String get searchDismissMessage => 'Đóng';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kết quả cho “$query”',
      one: '$count kết quả cho “$query”',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'Tuyến';

  @override
  String get searchResultsStops => 'Điểm dừng';

  @override
  String get searchResultsVehicles => 'Phương tiện';

  @override
  String get searchResultsPlaces => 'Địa điểm';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Tuyến $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Phương tiện $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'Phương tiện $id hiện không chạy chuyến nào.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Đang tải phương tiện $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'Hãy bật vị trí để xem các chuyến khởi hành từ những điểm dừng gần bạn.';

  @override
  String get searchNearbyLocationButton => 'Dùng vị trí của tôi';

  @override
  String get searchNearbyLocationDenied =>
      'Quyền truy cập vị trí đang tắt. Hãy bật trong cài đặt thiết bị để xem các điểm dừng gần bạn.';

  @override
  String get searchNearbyLocationServicesOff =>
      'Dịch vụ vị trí đang tắt. Hãy bật để xem các điểm dừng gần bạn.';

  @override
  String get searchNearbyLocationUnavailable =>
      'Ứng dụng này không dùng vị trí của bạn nên không thể hiển thị các điểm dừng gần bạn.';

  @override
  String get searchNearbyEmpty => 'Không có điểm dừng gần đây';

  @override
  String get searchNearbyEmptyBody =>
      'Không có điểm dừng nào trong khoảng cách đi bộ.';

  @override
  String get searchNearbyMapCenter =>
      'Hiển thị các điểm dừng gần trung tâm bản đồ.';

  @override
  String get searchNearbyNoDepartures =>
      'Không có chuyến khởi hành trong giờ tới';

  @override
  String get searchNearbyLoadingDepartures => 'Đang tải các chuyến khởi hành';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm dừng lân cận',
      one: '$count điểm dừng lân cận',
      zero: 'Không có điểm dừng lân cận',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Đang tìm vị trí của bạn…';

  @override
  String get searchNearbyRefresh => 'Làm mới';

  @override
  String searchNearbyDistance(String distance) {
    return 'Cách $distance';
  }

  @override
  String get searchNearbyOtherDirection => 'Các điểm dừng khác';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return 'Các điểm dừng $direction';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route đi $headsign, $eta, $status. Từ $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'Từ $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Chuyến khởi hành gần bạn';

  @override
  String get searchExplorePlanTrip => 'Lên kế hoạch chuyến đi';

  @override
  String get searchExploreWeather => 'Thời tiết';

  @override
  String get searchExploreAgencies => 'Cơ quan vận tải';

  @override
  String get searchPlaceAddress => 'Địa chỉ';

  @override
  String get searchPlaceCoordinates => 'Tọa độ';

  @override
  String get searchPlaceDistance => 'Khoảng cách';

  @override
  String get searchPlaceDirectionsTo => 'Chỉ đường đến đây';

  @override
  String get searchPlaceDirectionsFrom => 'Chỉ đường từ đây';

  @override
  String get searchPlaceNearbyStops => 'Điểm dừng lân cận';

  @override
  String get searchPlaceShare => 'Chia sẻ';

  @override
  String get searchPlaceOpenInMaps => 'Mở trong ứng dụng bản đồ';

  @override
  String get searchPlaceRemovePin => 'Xóa ghim';

  @override
  String get searchPlaceOpenFailed => 'Không thể mở ứng dụng bản đồ.';

  @override
  String get searchPlaceShareFailed => 'Không thể chia sẻ địa điểm này.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Địa điểm: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Thời tiết: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Hiển thị dự báo';

  @override
  String get searchWeatherClear => 'Quang đãng';

  @override
  String get searchWeatherPartlyCloudy => 'Có mây rải rác';

  @override
  String get searchWeatherCloudy => 'Nhiều mây';

  @override
  String get searchWeatherRain => 'Mưa';

  @override
  String get searchWeatherSleet => 'Mưa tuyết';

  @override
  String get searchWeatherSnow => 'Tuyết';

  @override
  String get searchWeatherWindy => 'Có gió';

  @override
  String get searchWeatherFog => 'Sương mù';

  @override
  String get searchWeatherUnknown => 'Không rõ điều kiện';

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
      other: '$value độ F',
      one: '$value độ F',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value độ C',
      one: '$value độ C',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherMph(int value) {
    return '$value mph';
  }

  @override
  String searchWeatherKmh(int value) {
    return '$value km/h';
  }

  @override
  String searchWeatherMps(int value) {
    return '$value m/s';
  }

  @override
  String searchWeatherPercent(int value) {
    return '$value%';
  }

  @override
  String get searchWeatherFeelsLike => 'Cảm giác như';

  @override
  String get searchWeatherWind => 'Gió';

  @override
  String get searchWeatherPrecip => 'Khả năng có mưa';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'Cao nhất $high · Thấp nhất $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'Cao nhất $high, thấp nhất $low, trong 24 giờ tới';
  }

  @override
  String get searchWeatherHourly => '24 giờ tới';

  @override
  String get searchWeatherNow => 'Bây giờ';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, khả năng có mưa $precip';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Nhiệt độ tính bằng $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'độ Fahrenheit (°F)';

  @override
  String get searchWeatherCelsius => 'độ Celsius (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Dự báo từ $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'Thông tin thời tiết không khả dụng cho khu vực này.';

  @override
  String get searchWeatherSummaryLabel => 'Hôm nay';

  @override
  String get bookmarksSectionEmpty =>
      'Các điểm dừng đã đánh dấu sẽ hiển thị ở đây.';

  @override
  String get coreDirectionBoundN => 'Hướng Bắc';

  @override
  String get coreDirectionBoundNE => 'Hướng ĐB';

  @override
  String get coreDirectionBoundE => 'Hướng Đông';

  @override
  String get coreDirectionBoundSE => 'Hướng ĐN';

  @override
  String get coreDirectionBoundS => 'Hướng Nam';

  @override
  String get coreDirectionBoundSW => 'Hướng TN';

  @override
  String get coreDirectionBoundW => 'Hướng Tây';

  @override
  String get coreDirectionBoundNW => 'Hướng TB';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Điểm dừng #$code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Điểm dừng: \'$code\'';
  }

  @override
  String get coreJustNow => 'Vừa xong';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds giây trước';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes phút trước';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours giờ trước';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ngày trước',
      one: '$days ngày trước',
    );
    return '$_temp0';
  }

  @override
  String coreMeters(String value) {
    return '$value m';
  }

  @override
  String coreKilometers(String value) {
    return '$value km';
  }

  @override
  String coreFeet(String value) {
    return '$value ft';
  }

  @override
  String coreMiles(String value) {
    return '$value mi';
  }

  @override
  String get arrivalsNow => 'bây giờ';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes ph';
  }

  @override
  String get arrivalsCanceled => 'đã hủy';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'cứ $minutes phút một chuyến từ $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'cứ $minutes phút một chuyến đến $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'Hướng Bắc';

  @override
  String get arrivalsDirectionBoundNE => 'Hướng Đông Bắc';

  @override
  String get arrivalsDirectionBoundE => 'Hướng Đông';

  @override
  String get arrivalsDirectionBoundSE => 'Hướng Đông Nam';

  @override
  String get arrivalsDirectionBoundS => 'Hướng Nam';

  @override
  String get arrivalsDirectionBoundSW => 'Hướng Tây Nam';

  @override
  String get arrivalsDirectionBoundW => 'Hướng Tây';

  @override
  String get arrivalsDirectionBoundNW => 'Hướng Tây Bắc';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'Hướng $code';
  }

  @override
  String get arrivalsRefresh => 'Làm mới giờ đến';

  @override
  String get arrivalsRetry => 'Thử lại';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Không có chuyến nào đến trong $minutes phút tới',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound =>
      'Không tìm thấy điểm dừng hoặc dịch vụ không khả dụng';

  @override
  String get arrivalsNetworkError =>
      'Không thể kết nối đến máy chủ vận tải. Hãy kiểm tra kết nối của bạn.';

  @override
  String get arrivalsLoadError => 'Không thể tải giờ đến.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'Không thể cập nhật. Đang hiển thị kết quả từ $time';
  }

  @override
  String get arrivalsArrivingNow => 'đang đến';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'sẽ đến sau $minutes phút',
      one: 'sẽ đến sau $minutes phút',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'thời gian thực';

  @override
  String get arrivalsRowTapHint => 'hiển thị chi tiết';

  @override
  String arrivalsAtTime(String time) {
    return 'lúc $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'trễ $minutes phút',
      one: 'trễ $minutes phút',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'sớm $minutes phút',
      one: 'sớm $minutes phút',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'cứ $minutes phút một chuyến từ $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'cứ $minutes phút một chuyến đến $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'giờ theo lịch';

  @override
  String get arrivalsLoading => 'Đang tải giờ đến';

  @override
  String get arrivalsRefreshing => 'Đang làm mới giờ đến';

  @override
  String get arrivalsUpdated => 'Đã cập nhật giờ đến';

  @override
  String get tripPlannerOriginLabel => 'Từ';

  @override
  String get tripPlannerDestinationLabel => 'Đến';

  @override
  String get tripPlannerChooseOrigin => 'Chọn điểm xuất phát';

  @override
  String get tripPlannerChooseDestination => 'Chọn điểm đến';

  @override
  String get tripPlannerCurrentLocation => 'Vị trí hiện tại';

  @override
  String get tripPlannerSwapEndpoints =>
      'Đổi điểm xuất phát và điểm đến cho nhau';

  @override
  String get tripPlannerPlanTrip => 'Lên kế hoạch chuyến đi';

  @override
  String get tripPlannerPlanningTrip =>
      'Đang lên kế hoạch cho chuyến đi của bạn';

  @override
  String get tripPlannerOptions => 'Tùy chọn chuyến đi';

  @override
  String get tripPlannerLeaveNow => 'Đi ngay bây giờ';

  @override
  String get tripPlannerDepartAt => 'Khởi hành lúc';

  @override
  String get tripPlannerArriveBy => 'Đến trước';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Đổi thời gian, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Phương tiện công cộng';

  @override
  String get tripPlannerModeWalk => 'Đi bộ';

  @override
  String get tripPlannerModeBike => 'Xe đạp';

  @override
  String get tripPlannerModeCar => 'Ô tô';

  @override
  String get tripPlannerModeBikeRental => 'Chỉ xe đạp công cộng';

  @override
  String get tripPlannerModeTransitBikeRental =>
      'Phương tiện công cộng + xe đạp công cộng';

  @override
  String get tripPlannerWheelchairAccessible => 'Phù hợp với xe lăn';

  @override
  String get tripPlannerWalkQuarterMile => '0,25 dặm';

  @override
  String get tripPlannerWalkHalfMile => '0,5 dặm';

  @override
  String get tripPlannerWalkOneMile => '1 dặm';

  @override
  String get tripPlannerWalkTwoMiles => '2 dặm';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'Đi bộ tối đa $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'Không tìm thấy chuyến đi nào';

  @override
  String get tripPlannerRetry => 'Thử lại';

  @override
  String get tripPlannerRealTime => 'Thời gian thực';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes phút';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours giờ';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours giờ $minutes phút';
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
      other: '$count lần chuyển tuyến',
      one: '$count lần chuyển tuyến',
      zero: 'Không chuyển tuyến',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return 'Đi bộ $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Khởi hành lúc $time từ $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'Đúng giờ';

  @override
  String tripPlannerStatusLate(int minutes) {
    return 'Trễ $minutes phút';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return 'Sớm $minutes phút';
  }

  @override
  String get tripPlannerStatusScheduled => 'Theo lịch';

  @override
  String get tripPlannerLegBus => 'Xe buýt';

  @override
  String get tripPlannerLegTram => 'Xe điện';

  @override
  String get tripPlannerLegSubway => 'Tàu điện ngầm';

  @override
  String get tripPlannerLegRail => 'Tàu hỏa';

  @override
  String get tripPlannerLegFerry => 'Phà';

  @override
  String get tripPlannerLegCableCar => 'Xe cáp treo';

  @override
  String get tripPlannerLegGondola => 'Cáp treo gondola';

  @override
  String get tripPlannerLegFunicular => 'Đường sắt leo núi';

  @override
  String get tripPlannerLegAirplane => 'Máy bay';

  @override
  String get tripPlannerLegTrolleybus => 'Xe buýt điện';

  @override
  String get tripPlannerLegMonorail => 'Tàu một ray';

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
    return 'Đi bộ $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return 'Đi xe đạp $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return 'Xe đạp thuê $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return 'Lái xe $duration';
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
  String get tripPlannerThen => 'sau đó';

  @override
  String get tripPlannerOpenItineraryHint => 'hiển thị chi tiết chuyến đi';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes phút',
      one: '$minutes phút',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours giờ',
      one: '$hours giờ',
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
      other: '$value foot',
      one: '$value foot',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value dặm',
      one: '$value dặm',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value mét',
      one: '$value mét',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value ki-lô-mét',
      one: '$value ki-lô-mét',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return '$start đến $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'thời gian thực, đúng giờ';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'thời gian thực, trễ $minutes phút',
      one: 'thời gian thực, trễ $minutes phút',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'thời gian thực, sớm $minutes phút',
      one: 'thời gian thực, sớm $minutes phút',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'giờ theo lịch';

  @override
  String get tripPlannerResultsHeading => 'Chuyến đi được đề xuất';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tìm thấy $count chuyến đi',
      one: 'Tìm thấy $count chuyến đi',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tìm thấy $count địa điểm',
      one: 'Tìm thấy $count địa điểm',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'Bản đồ chuyến đi. Các chỉ dẫn bên dưới mô tả cùng chuyến đi này.';

  @override
  String get tripPlannerTripDetails => 'Chi tiết chuyến đi';

  @override
  String get tripPlannerMapLabel => 'Bản đồ chuyến đi';

  @override
  String get tripPlannerStart => 'Bắt đầu';

  @override
  String get tripPlannerDestination => 'Điểm đến';

  @override
  String get tripPlannerUnnamedPlace => 'Vị trí không tên';

  @override
  String get tripPlannerRentalBike => 'Xe đạp thuê';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Đi bộ đến $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Đi xe đạp đến $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Đi xe đạp thuê đến $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Lái xe đến $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Đi $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Đi $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Đi $mode hướng $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Đi $mode $route hướng $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Xuống tại $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Đến $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count điểm dừng',
      one: '$count điểm dừng',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hiện $count điểm dừng',
      one: 'Hiện $count điểm dừng',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ẩn $count điểm dừng',
      one: 'Ẩn $count điểm dừng',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bước',
      one: '$count bước',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hiện $count bước',
      one: 'Hiện $count bước',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ẩn $count bước',
      one: 'Ẩn $count bước',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, khoảng $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Xuất phát';

  @override
  String get tripPlannerDirectionHardLeft => 'Rẽ trái gấp';

  @override
  String get tripPlannerDirectionLeft => 'Rẽ trái';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'Chếch sang trái';

  @override
  String get tripPlannerDirectionContinue => 'Đi tiếp';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Chếch sang phải';

  @override
  String get tripPlannerDirectionRight => 'Rẽ phải';

  @override
  String get tripPlannerDirectionHardRight => 'Rẽ phải gấp';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Vào vòng xuyến theo chiều kim đồng hồ';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Vào vòng xuyến ngược chiều kim đồng hồ';

  @override
  String get tripPlannerDirectionElevator => 'Đi thang máy';

  @override
  String get tripPlannerDirectionUturnLeft => 'Quay đầu sang trái';

  @override
  String get tripPlannerDirectionUturnRight => 'Quay đầu sang phải';

  @override
  String get tripPlannerDirectionEnterStation => 'Vào ga';

  @override
  String get tripPlannerDirectionExitStation => 'Ra khỏi ga';

  @override
  String get tripPlannerDirectionFollowSigns => 'Đi theo biển chỉ dẫn';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Đi bộ dọc theo $street trong $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction vào $street, đi bộ $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Tìm một địa điểm';

  @override
  String get tripPlannerSearchNoResults => 'Không tìm thấy địa điểm nào';

  @override
  String get tripPlannerSearchError => 'Không thể tìm địa điểm. Hãy thử lại.';

  @override
  String get tripPlannerUseCurrentLocation => 'Dùng vị trí hiện tại';

  @override
  String get tripPlannerLocationUnavailable => 'Không thể lấy vị trí của bạn.';

  @override
  String get tripPlannerClearSearch => 'Xóa nội dung tìm kiếm';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Vui lòng chọn cả điểm xuất phát và điểm đến.';

  @override
  String get tripPlannerErrorNetwork =>
      'Không thể kết nối đến trình lên kế hoạch chuyến đi. Hãy kiểm tra kết nối của bạn.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'Máy chủ trả về phản hồi không hợp lệ';

  @override
  String get tripPlannerErrorUnknown => 'Đã xảy ra lỗi không xác định.';

  @override
  String get tripPlannerPlannerSystemError =>
      'Hiện chúng tôi không thể lên kế hoạch cho chuyến đi của bạn. Vui lòng thử lại.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'Tính năng lên kế hoạch chuyến đi tạm thời không khả dụng. Hãy thử lại sau ít phút.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'Vị trí này hiện chưa được hỗ trợ.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'Không có tuyến đường nào cho chuyến đi này.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'Hiện không có lựa chọn phương tiện công cộng nào.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'Việc này mất nhiều thời gian hơn dự kiến. Vui lòng thử lại.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'Đã xảy ra sự cố với yêu cầu. Vui lòng thử lại.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'Chúng tôi không tìm thấy vị trí xuất phát.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'Chúng tôi không tìm thấy điểm đến.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'Chúng tôi không tìm thấy điểm xuất phát lẫn điểm đến.';

  @override
  String get tripPlannerPlannerTooClose =>
      'Điểm xuất phát và điểm đến quá gần nhau.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'Tuyến đường này không phù hợp với tùy chọn đã chọn.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'Vị trí xuất phát chưa rõ ràng. Hãy thử nhập cụ thể hơn.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'Điểm đến chưa rõ ràng. Hãy thử nhập cụ thể hơn.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Cả hai vị trí cần chi tiết hơn. Hãy thử làm rõ hơn.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'Thiếu một số lựa chọn tuyến đường.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'Các tùy chọn tuyến đường đã chọn không tương thích với nhau.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Vui lòng chọn một ưu tiên cho tuyến đường.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Vui lòng điều chỉnh các tùy chọn tuyến đường.';
}
