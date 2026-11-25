// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class ObaLocalizationsZh extends ObaLocalizations {
  ObaLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get commonBack => '返回';

  @override
  String get commonClose => '关闭';

  @override
  String get commonDone => '完成';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonContinue => '继续';

  @override
  String get commonNotNow => '暂不';

  @override
  String get commonSeeAll => '查看全部';

  @override
  String get commonLoading => '正在加载';

  @override
  String get commonErrorTitle => '出了点问题';

  @override
  String get commonEmptyTitle => '这里还没有内容';

  @override
  String get commonComingSoon => '即将推出';

  @override
  String get commonComingSoonBody => '此页面暂不可用。';

  @override
  String get commonOffline => '你似乎已离线。请检查网络连接后重试。';

  @override
  String get commonServerError => '服务器未按预期响应。请稍后重试。';

  @override
  String get sheetLabel => '面板';

  @override
  String get sheetExpand => '展开面板';

  @override
  String get sheetCollapse => '收起面板';

  @override
  String get sheetHandleHint => '拖动或双击即可调整面板大小';

  @override
  String get homeTabHome => '首页';

  @override
  String get homeTabRecent => '最近';

  @override
  String get homeTabBookmarks => '书签';

  @override
  String get homeSearchPlaceholder => '搜索站点、路线、地点';

  @override
  String get homeSearchLabel => '搜索';

  @override
  String get homeSectionNearby => '附近';

  @override
  String get homeSectionRecent => '最近查看的站点';

  @override
  String get homeSectionBookmarks => '书签';

  @override
  String get homeSectionAlerts => '服务通知';

  @override
  String get homeSectionExplore => '探索';

  @override
  String get homeSectionMore => '设置及更多';

  @override
  String get mapLabel => '地图';

  @override
  String get mapZoomInForStops => '放大以查看站点';

  @override
  String get mapLocationDenied => '定位权限已关闭。点按以允许。';

  @override
  String get mapLocationServicesOff => '定位服务已关闭';

  @override
  String get mapRecenter => '显示我的位置';

  @override
  String get mapSettingsButton => '地图设置';

  @override
  String get mapStopsListButton => '地图上的站点';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '地图上有 $count 个站点',
      one: '地图上有 $count 个站点',
      zero: '地图上没有站点',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => '你的位置';

  @override
  String get mapDroppedPin => '已放置的大头针';

  @override
  String get mapVehicle => '车辆';

  @override
  String get mapSelectedStop => '已选中';

  @override
  String get mapBookmarkedStop => '已加书签';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name，$routeType站点';
  }

  @override
  String get mapStopMarkerHint => '打开该站点的发车信息';

  @override
  String mapAttribution(String attribution) {
    return '地图数据：$attribution';
  }

  @override
  String get mapTypeTitle => '地图类型';

  @override
  String get mapTypeStandard => '标准';

  @override
  String get mapTypeSatellite => '卫星';

  @override
  String get mapTypeHybrid => '混合';

  @override
  String get mapShowScale => '显示比例尺';

  @override
  String get mapShowHeading => '显示朝向';

  @override
  String get mapShowStopLabels => '显示站点标签';

  @override
  String mapPlaceAt(String lat, String lon) {
    return '位于 $lat、$lon 的位置';
  }

  @override
  String get directionN => '北向';

  @override
  String get directionNE => '东北向';

  @override
  String get directionE => '东向';

  @override
  String get directionSE => '东南向';

  @override
  String get directionS => '南向';

  @override
  String get directionSW => '西南向';

  @override
  String get directionW => '西向';

  @override
  String get directionNW => '西北向';

  @override
  String get routeTypeBus => '公交车';

  @override
  String get routeTypeLightRail => '轻轨';

  @override
  String get routeTypeSubway => '地铁';

  @override
  String get routeTypeRail => '火车';

  @override
  String get routeTypeFerry => '渡轮';

  @override
  String get routeTypeCableCar => '缆车';

  @override
  String get routeTypeGondola => '索道';

  @override
  String get routeTypeFunicular => '缆索铁路';

  @override
  String get routeTypeUnknown => '公共交通';

  @override
  String stopCode(String code) {
    return '站点 $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name，$details';
  }

  @override
  String stopRoutes(String routes) {
    return '路线 $routes';
  }

  @override
  String get stopPageRefresh => '刷新';

  @override
  String get stopPageRefreshed => '发车信息已更新';

  @override
  String get stopPageBookmark => '为站点添加书签';

  @override
  String get stopPageBookmarked => '已加书签。编辑书签';

  @override
  String get stopPageMoreActions => '更多站点操作';

  @override
  String get stopPageSchedules => '时刻表';

  @override
  String get stopPageServiceAlerts => '服务通知';

  @override
  String get stopPageNearbyStops => '附近站点';

  @override
  String get stopPageWalkingDirections => '步行路线';

  @override
  String get stopPageBikeDirections => '骑行路线';

  @override
  String get stopPagePlanTripFrom => '从这里出发规划行程';

  @override
  String get stopPagePlanTripTo => '规划前往这里的行程';

  @override
  String get stopPageShareStop => '分享站点';

  @override
  String get stopPageReportProblem => '报告问题';

  @override
  String get stopPageFilterRoutes => '筛选路线';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已隐藏 $count 条路线',
      one: '已隐藏 $count 条路线',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => '按时间';

  @override
  String get stopPageModeRoute => '按路线';

  @override
  String get stopPageDepartureTypes => '发车类型';

  @override
  String get stopPageFilterAll => '所有班次';

  @override
  String get stopPageFilterRealtime => '仅实时';

  @override
  String get stopPageFilterScheduled => '仅按时刻表';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '显示 $count 个已离站的班次',
      one: '显示 $count 个已离站的班次',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => '隐藏已离站的班次';

  @override
  String get stopPageLoadMore => '加载更多班次';

  @override
  String stopPageWindow(int minutes) {
    return '显示未来 $minutes 分钟的班次';
  }

  @override
  String stopPageUpdated(String ago) {
    return '更新于 $ago';
  }

  @override
  String get stopPageStaleTitle => '无法刷新发车信息';

  @override
  String get stopPageStaleBody => '这些时间可能已过时。';

  @override
  String get stopPageEmptyTitle => '暂无即将发车的班次';

  @override
  String stopPageEmptyBody(int minutes) {
    return '未来 $minutes 分钟内没有发车班次。';
  }

  @override
  String get stopPageEmptyHiddenRoutes => '此处有发车班次的路线均已隐藏。';

  @override
  String get stopPageShowAllRoutes => '显示所有路线';

  @override
  String get stopPageEmptyFilter => '没有符合发车类型筛选条件的班次。';

  @override
  String get stopPageShowAllTypes => '显示所有班次';

  @override
  String get stopPageMissingTitle => '未找到站点';

  @override
  String get stopPageMissingBody => '此站点可能已被移除或重新编号。';

  @override
  String stopPageWalkTime(int minutes) {
    return '步行 $minutes 分钟';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '骑行 $minutes 分钟';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '步行 $minutes 分钟',
      one: '步行 $minutes 分钟',
    );
    return '$_temp0，$distance。打开路线。';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '骑行 $minutes 分钟',
      one: '骑行 $minutes 分钟',
    );
    return '$_temp0，$distance。打开路线。';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '步行到此站点需 $minutes 分钟。上方的班次将更早离站。';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '骑行到此站点需 $minutes 分钟。上方的班次将更早离站。';
  }

  @override
  String stopPageAgencies(String names) {
    return '运营方：$names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条服务通知',
      one: '$count 条服务通知',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条未读',
      one: '$count 条未读',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => '未读';

  @override
  String get stopPageAlertImportant => '重要';

  @override
  String get stopPageDirectionsChooser => '用以下应用打开路线';

  @override
  String get stopPageAppleMaps => 'Apple 地图';

  @override
  String get stopPageGoogleMaps => 'Google 地图';

  @override
  String get stopPageCannotOpen => '无法打开该链接。';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return '从 $route $headsign 换乘，$time到达';
  }

  @override
  String get stopPageDeparturesHeader => '发车信息';

  @override
  String get stopRowNow => '现在';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes 分钟前';
  }

  @override
  String get stopRowOnTime => '准点';

  @override
  String stopRowLate(int minutes) {
    return '晚点 $minutes 分钟';
  }

  @override
  String stopRowEarly(int minutes) {
    return '提前 $minutes 分钟';
  }

  @override
  String get stopRowScheduled => '按时刻表';

  @override
  String get stopRowCanceled => '已取消';

  @override
  String get stopRowOccupancyEmpty => '空';

  @override
  String get stopRowOccupancyManySeats => '座位充足';

  @override
  String get stopRowOccupancyFewSeats => '座位较少';

  @override
  String get stopRowOccupancyStanding => '仅有站位';

  @override
  String get stopRowOccupancyCrushed => '非常拥挤';

  @override
  String get stopRowOccupancyFull => '已满';

  @override
  String get stopRowOccupancyNotAccepting => '不再接受乘客';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟后到站',
      one: '$minutes 分钟后到站',
      zero: '正在进站',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟后发车',
      one: '$minutes 分钟后发车',
      zero: '正在发车',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟前已到站',
      one: '$minutes 分钟前已到站',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟前已发车',
      one: '$minutes 分钟前已发车',
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
    return '$route 路，开往 $headsign，$eta，$time，$status';
  }

  @override
  String stopRowA11yLive(String status) {
    return '实时追踪，$status';
  }

  @override
  String get stopRowA11yScheduledOnly => '仅有时刻表时间，无实时数据';

  @override
  String get stopRowA11yTransfer => '你的换乘班次';

  @override
  String get stopRowA11yMissed => '很可能赶不上，它会在你步行到达之前离站';

  @override
  String get stopRowA11yAlarm => '已设置闹钟';

  @override
  String stopRowActions(String route) {
    return '$route 路的更多操作';
  }

  @override
  String get stopRowShowTrip => '显示行程详情';

  @override
  String get stopRowAddAlarm => '添加闹钟';

  @override
  String get stopRowRemoveAlarm => '移除闹钟';

  @override
  String get stopRowBookmarkTrip => '为此行程添加书签';

  @override
  String get stopRowShareTrip => '分享行程';

  @override
  String get stopRowRouteSchedule => '路线时刻表';

  @override
  String get stopRowRouteStops => '此路线的站点';

  @override
  String stopRouteGroupNext(String times) {
    return '下一班：$times';
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
      other: '$count 个班次',
      one: '$count 个班次',
    );
    return '$route 路，开往 $headsigns，$_temp0，下一班 $eta';
  }

  @override
  String get stopAlarmPickerTitle => '发车前提醒我';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '提前 $minutes 分钟',
      one: '提前 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '已设置提前 $minutes 分钟的闹钟',
      one: '已设置提前 $minutes 分钟的闹钟',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => '闹钟已移除';

  @override
  String get stopAlarmFailed => '无法更新闹钟。';

  @override
  String get stopAlarmPermissionDenied => '此应用的通知已关闭。';

  @override
  String get stopFilterTitle => '筛选路线';

  @override
  String get stopFilterSort => '班次排序';

  @override
  String get stopFilterRoutesHeader => '此站点显示的路线';

  @override
  String get stopFilterShowAll => '显示所有路线';

  @override
  String get stopTripArrivingAtYourStop => '即将到达你的站点';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '还有 $count 站',
      one: '还有 $count 站',
      zero: '已在你的站点',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return '距离 $distance';
  }

  @override
  String stopTripAtStop(String stop) {
    return '在 $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return '位置更新于 $ago';
  }

  @override
  String get stopTripNoPosition => '此车辆暂无实时位置';

  @override
  String stopTripStartsAs(String trip) {
    return '起始班次：$trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return '后续班次：$trip';
  }

  @override
  String get stopTripStopsHeader => '站点';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已过 $count 站',
      one: '已过 $count 站',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你的站点前还有 $count 站',
      one: '你的站点前还有 $count 站',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => '你的站点';

  @override
  String get stopTripBoarding => '上车';

  @override
  String get stopTripVehicleHere => '车辆在此';

  @override
  String get stopTripTerminal => '终点站';

  @override
  String get stopTripPassed => '已过';

  @override
  String get stopTripRouteStops => '此路线的所有站点';

  @override
  String get stopTripReport => '报告此行程的问题';

  @override
  String get stopTripGhostBus => '报告幽灵公交';

  @override
  String get stopTripCanceled => '此行程已取消';

  @override
  String stopTripVehicleLabel(String route) {
    return '$route 路上的车辆';
  }

  @override
  String stopTripFrequency(int minutes) {
    return '每 $minutes 分钟一班';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return '$route 路';
  }

  @override
  String get stopRouteStopsDirection => '方向';

  @override
  String stopRouteStopsToward(String name) {
    return '开往 $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个站点',
      one: '$count 个站点',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => '未找到此路线的站点。';

  @override
  String get stopSchedPrevDay => '前一天';

  @override
  String get stopSchedNextDay => '后一天';

  @override
  String stopSchedPickDate(String date) {
    return '选择日期，$date';
  }

  @override
  String get stopSchedRoute => '路线';

  @override
  String get stopSchedDirection => '方向';

  @override
  String get stopSchedStop => '站点';

  @override
  String get stopSchedEmpty => '这一天没有运营班次。';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return '$start 至 $end，每 $minutes 分钟一班';
  }

  @override
  String stopSchedTo(String headsign) {
    return '开往 $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个班次',
      one: '$count 个班次',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour：$times';
  }

  @override
  String get stopSchedNotSupported => '此地区暂不提供时刻表。';

  @override
  String get stopSchedViewList => '列表';

  @override
  String get stopSchedViewGrid => '网格';

  @override
  String get stopSchedNoDeparture => '无发车';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop（你的站点）';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop，班次 $trip：$time';
  }

  @override
  String get stopReportProblemHeader => '遇到了什么问题？';

  @override
  String get stopReportStopNameWrong => '站点名称有误';

  @override
  String get stopReportStopNumberWrong => '站点编号有误';

  @override
  String get stopReportStopLocationWrong => '站点位置有误';

  @override
  String get stopReportRouteMissing => '缺少路线或班次';

  @override
  String get stopReportOther => '其他问题';

  @override
  String get stopReportNeverCame => '车辆一直没来';

  @override
  String get stopReportCameEarly => '来得太早';

  @override
  String get stopReportCameLate => '来得太晚';

  @override
  String get stopReportWrongHeadsign => '车头方向牌有误';

  @override
  String get stopReportNotStopHere => '没有在此停靠';

  @override
  String get stopReportComment => '补充说明（选填）';

  @override
  String get stopReportShareLocation => '分享我的位置';

  @override
  String get stopReportShareLocationHelp => '分享你的位置有助于公交机构解决此问题。';

  @override
  String get stopReportOnVehicle => '我在这辆车上';

  @override
  String get stopReportVehicleId => '车辆编号（选填）';

  @override
  String get stopReportSend => '发送报告';

  @override
  String get stopReportSending => '正在发送报告';

  @override
  String get stopReportSent => '谢谢！你的报告已发送。';

  @override
  String get stopReportFailed => '无法发送报告。请重试。';

  @override
  String get stopReportChooseProblem => '请先选择一个问题。';

  @override
  String stopReportAbout(String name) {
    return '报告对象：$name';
  }

  @override
  String get stopGhostTitle => '报告幽灵公交';

  @override
  String get stopGhostExplain => '幽灵公交是指应用中显示有、但实际一直没来的车。';

  @override
  String get stopGhostWait => '你比预定时间多等了多久？';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30 分钟以上';

  @override
  String get stopCardEmpty => '近期没有班次';

  @override
  String get titleSearch => '搜索';

  @override
  String get titleSearchResults => '结果';

  @override
  String get titleNearbyStops => '附近站点';

  @override
  String get titleRecentStops => '最近查看的站点';

  @override
  String get titleBookmarks => '书签';

  @override
  String get titleStop => '站点';

  @override
  String get titleTrip => '行程';

  @override
  String get titleRouteStops => '路线';

  @override
  String get titleStopSchedule => '时刻表';

  @override
  String get titleRouteSchedule => '路线时刻表';

  @override
  String get titleAlerts => '服务通知';

  @override
  String get titleAlertDetail => '通知';

  @override
  String get titleAgencies => '运营机构';

  @override
  String get titleRegionPicker => '地区';

  @override
  String get titleCustomRegion => '自定义地区';

  @override
  String get titleSettings => '设置';

  @override
  String get titleMapSettings => '地图设置';

  @override
  String get titleMore => '更多';

  @override
  String get titleTripPlanner => '规划行程';

  @override
  String get titlePlace => '地点';

  @override
  String get titleReportStopProblem => '报告问题';

  @override
  String get titleReportTripProblem => '报告问题';

  @override
  String get titleBookmarkEditor => '书签';

  @override
  String get titleManageBookmarks => '编辑书签';

  @override
  String get titleCredits => '致谢';

  @override
  String get titleWeather => '天气';

  @override
  String get titleStopsOnMap => '地图上的站点';

  @override
  String onboardingWelcomeTitle(String appName) {
    return '欢迎使用 $appName';
  }

  @override
  String get onboardingWelcomeBody => '查看你附近公交车、火车和渡轮的实时到站信息。';

  @override
  String get onboardingLocationTitle => '查找你附近的站点';

  @override
  String get onboardingLocationBody => '允许访问位置信息，即可查看附近站点并自动选择你所在的地区。';

  @override
  String get onboardingAllowLocation => '允许访问位置信息';

  @override
  String get onboardingRegionTitle => '选择你的地区';

  @override
  String get onboardingRegionBody => '选择你想查看公共交通信息的区域。';

  @override
  String get settingsSectionMap => '地图';

  @override
  String get settingsMapTypeRow => '地图类型和图层';

  @override
  String get settingsMapTypeHelp => '选择地图的显示样式。';

  @override
  String get settingsHeadingHelp => '在地图上显示你所面对的方向。';

  @override
  String get settingsStopLabelsHelp => '在地图上的站点旁显示路线名称。';

  @override
  String get settingsWalkingDirections => '步行路线';

  @override
  String get settingsWalkingDirectionsHelp => '请求前往站点的步行路线时打开的应用。';

  @override
  String get settingsDirectionsAsk => '每次询问';

  @override
  String get settingsDirectionsAppleMaps => 'Apple 地图';

  @override
  String get settingsDirectionsGoogleMaps => 'Google 地图';

  @override
  String get settingsSectionDepartures => '发车信息';

  @override
  String get settingsDepartureFilter => '显示班次';

  @override
  String get settingsDepartureFilterHelp => '选择站点页面是列出所有班次，还是仅列出有实时或时刻表数据的班次。';

  @override
  String get settingsFilterAll => '所有班次';

  @override
  String get settingsFilterRealtime => '仅实时';

  @override
  String get settingsFilterScheduled => '仅按时刻表';

  @override
  String get settingsRegionTimeZone => '以所在地区的时区显示时间';

  @override
  String get settingsRegionTimeZoneHelp => '时钟时间使用公交地区的时区，与你的设备不同时会附带说明。';

  @override
  String get settingsSectionAccessibility => '辅助功能';

  @override
  String get settingsReducedColors => '减少站点页面的颜色';

  @override
  String get settingsReducedColorsHelp => '以统一的中性样式显示路线标识。';

  @override
  String get settingsCompactMode => '紧凑的站点和行程页面';

  @override
  String get settingsCompactModeHelp => '缩小间距，让屏幕容纳更多内容。';

  @override
  String get settingsSectionWalking => '步行速度';

  @override
  String get settingsWalkingSpeed => '步行速度';

  @override
  String get settingsWalkingSpeedHelp => '用于估算步行时间和到达时间。';

  @override
  String get settingsSpeedSlow => '慢';

  @override
  String get settingsSpeedAverage => '中等';

  @override
  String get settingsSpeedFast => '快';

  @override
  String settingsSpeedCustom(String speed) {
    return '自定义（$speed 米/秒）';
  }

  @override
  String get settingsSectionBike => '骑行模式';

  @override
  String get settingsBikeMode => '骑行模式';

  @override
  String get settingsBikeModeHelp => '在步行时间估算、到达时间和站点页面中使用更快的出行速度。';

  @override
  String get settingsSectionSurveys => '问卷调查';

  @override
  String get settingsSurveysEnabled => '显示问卷调查';

  @override
  String get settingsSurveysAlways => '始终在站点显示问卷调查';

  @override
  String get settingsSectionPrivacy => '隐私';

  @override
  String get settingsAnalytics => '向开发者发送使用数据';

  @override
  String get settingsAnalyticsHelp => '帮助开发者了解哪些功能在被使用。';

  @override
  String get settingsSectionDebug => '调试';

  @override
  String get settingsDebugMode => '调试模式';

  @override
  String get settingsDebugAlwaysFeedback => '始终显示反馈提示';

  @override
  String get settingsDebugResetFeedback => '重置反馈提示状态';

  @override
  String get settingsDebugResetDonation => '重置捐款卡片状态';

  @override
  String get settingsDebugResetDone => '已重置';

  @override
  String get settingsSectionTripPlanner => '行程规划';

  @override
  String get settingsHomeCustomizeMap => '自定义地图';

  @override
  String get moreHeaderSupport => '本应用由志愿者开发和维护。';

  @override
  String get moreSectionDonate => '成为支持者';

  @override
  String moreDonate(String appName) {
    return '向 $appName 捐款';
  }

  @override
  String get moreManageDonations => '管理捐款';

  @override
  String get moreSectionUpdates => '更新与通知';

  @override
  String get moreAlerts => '服务通知';

  @override
  String get moreSectionLocation => '我的位置';

  @override
  String get moreRegion => '地区';

  @override
  String get moreRegionNone => '未选择';

  @override
  String get morePayFare => '支付车费';

  @override
  String get moreAgencies => '运营机构';

  @override
  String get moreSectionAbout => '关于本应用';

  @override
  String moreRateApp(String appName) {
    return '为 $appName 评分';
  }

  @override
  String get moreContactUs => '联系我们';

  @override
  String get morePrivacy => '隐私政策';

  @override
  String get moreCredits => '致谢';

  @override
  String moreVersion(String appName, String version) {
    return '$appName 版本 $version';
  }

  @override
  String get moreSectionHelpOut => '帮助改进本应用';

  @override
  String get moreTranslate => '帮助翻译本应用';

  @override
  String get moreDevelop => '帮助修复错误并开发新功能';

  @override
  String get moreSectionContact => '联系与帮助';

  @override
  String get moreTutorials => '使用教程';

  @override
  String get moreCallAgency => '致电运营机构';

  @override
  String get moreTextAgency => '给运营机构发短信';

  @override
  String get moreSectionResources => '资源';

  @override
  String get moreContactTitle => '联系我们';

  @override
  String get moreContactDevelopers => '功能建议或错误报告';

  @override
  String get moreContactAgency => '车辆或时刻表问题';

  @override
  String moreEmailSubject(String appName) {
    return '$appName 反馈';
  }

  @override
  String get moreEmailAgencySubject => '乘客反馈';

  @override
  String get moreEmailIntro => '我们能帮你什么？请在下方输入你的回复：';

  @override
  String get moreEmailDebugIntro =>
      '以下信息用于排查问题。如果你不方便分享其中任何内容，可以将其删除，但这可能会影响我们为你提供帮助。';

  @override
  String get moreDebugAppVersion => '应用版本';

  @override
  String get moreDebugOs => '操作系统';

  @override
  String get moreDebugLocale => '语言';

  @override
  String get moreDebugBookmarks => '书签数量';

  @override
  String get moreDebugLocationPermission => '位置权限';

  @override
  String get moreDebugRegion => '地区';

  @override
  String get moreDebugRegionId => '地区 ID';

  @override
  String get moreDebugApiUrl => 'API 基础网址';

  @override
  String get moreDebugUserId => '用户 ID';

  @override
  String get moreCantEmailTitle => '无法打开你的邮件应用';

  @override
  String moreCantEmailBody(String email) {
    return '如需联系我们，请发送邮件至 $email。请复制调试信息并粘贴到邮件中，以帮助我们解决问题。';
  }

  @override
  String get moreCopyEmail => '复制邮箱地址';

  @override
  String get moreCopyDebug => '复制调试信息';

  @override
  String get moreCopied => '已复制到剪贴板';

  @override
  String get moreFareContinue => '继续';

  @override
  String get moreFareDontShowAgain => '继续且不再显示';

  @override
  String get moreCantOpenLink => '无法打开该链接。';

  @override
  String get regionPickerAutomatic => '自动选择地区';

  @override
  String get regionPickerAutomaticHelp => '切换到包含你所在位置的地区。自行选择地区后将关闭此功能。';

  @override
  String get regionPickerShowExperimental => '显示实验性地区';

  @override
  String get regionPickerShowInactive => '显示未启用的地区';

  @override
  String get regionPickerRegionsSection => '地区';

  @override
  String get regionPickerCustomSection => '自定义地区';

  @override
  String get regionPickerCurrent => '当前地区';

  @override
  String get regionPickerExperimentalTag => '实验性';

  @override
  String get regionPickerInactiveTag => '未启用';

  @override
  String get regionPickerCustomTag => '自定义';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name，$details';
  }

  @override
  String get regionPickerAdd => '添加自定义地区';

  @override
  String get regionPickerRefresh => '刷新地区';

  @override
  String get regionPickerRefreshed => '地区已更新';

  @override
  String get regionPickerRefreshFailed => '无法更新地区列表。正在显示已保存的列表。';

  @override
  String regionPickerSelected(String name) {
    return '已选择 $name';
  }

  @override
  String regionPickerEdit(String name) {
    return '编辑 $name';
  }

  @override
  String regionPickerDelete(String name) {
    return '删除 $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return '要删除 $name 吗？';
  }

  @override
  String get regionPickerDeleteBody => '此自定义地区将从此设备中移除。';

  @override
  String get regionPickerDeleteConfirm => '删除';

  @override
  String get regionPickerCantDeleteCurrent => '请先选择其他地区，再删除此地区。';

  @override
  String get regionPickerEmpty => '没有可用的地区';

  @override
  String get regionPickerEmptyBody => '请开启实验性或未启用的地区，或添加自定义地区。';

  @override
  String get regionPickerTripPlanner => '此地区的行程规划';

  @override
  String get customRegionEditTitle => '编辑自定义地区';

  @override
  String get customRegionName => '名称';

  @override
  String get customRegionObaUrl => 'OneBusAway 服务器网址';

  @override
  String get customRegionObaUrlHelp => '服务器的地址，例如 https://oba.example.com/';

  @override
  String get customRegionSidecar => '辅助服务器网址（选填）';

  @override
  String get customRegionOtp => '行程规划网址（选填）';

  @override
  String get customRegionOtpGraphql => '行程规划 GraphQL 网址（选填）';

  @override
  String get customRegionServiceArea => '服务范围';

  @override
  String get customRegionServiceAreaHelp => '此地区覆盖的范围：一个中心点及其延伸距离。';

  @override
  String get customRegionLatitude => '中心纬度';

  @override
  String get customRegionLongitude => '中心经度';

  @override
  String get customRegionLatSpan => '纬度跨度（度）';

  @override
  String get customRegionLonSpan => '经度跨度（度）';

  @override
  String get customRegionUseMap => '使用当前地图范围';

  @override
  String get customRegionSave => '存储';

  @override
  String get customRegionErrorRequired => '此项为必填';

  @override
  String get customRegionErrorUrl => '请输入以 http:// 或 https:// 开头的网址';

  @override
  String get customRegionErrorNumber => '请输入数字';

  @override
  String get customRegionErrorRange => '此数字超出范围';

  @override
  String get customRegionChecking => '正在检查服务器';

  @override
  String get customRegionServerOk => '服务器已响应';

  @override
  String get customRegionServerUnreachable => '无法连接到此服务器';

  @override
  String get customRegionServerNotOba => '此服务器的响应不像 OneBusAway';

  @override
  String customRegionSaved(String name) {
    return '已存储 $name';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway 是免费的开源公共交通软件，由志愿者开发，并得到 Open Transit Software Foundation 的支持。';

  @override
  String get creditsLicenseTitle => '许可证';

  @override
  String get creditsMapData => '地图数据';

  @override
  String get creditsLicenses => '开源许可证';

  @override
  String get creditsLicensesHelp => '本应用所使用的库。';

  @override
  String get creditsLicensesLoading => '正在加载许可证';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项许可证',
      one: '$count 项许可证',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote => '已覆盖全球数十个公共交通地区。';

  @override
  String get onboardingBenefitNearbyTitle => '查看附近站点';

  @override
  String get onboardingBenefitNearbyBody => '按距离排序，显示你周围的公交车和火车。';

  @override
  String get onboardingBenefitMapTitle => '地图以你为中心';

  @override
  String get onboardingBenefitMapBody => '打开即显示你周围的环境，无需搜索。';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName 仅在应用打开时使用你的位置。你可以随时在设备设置中更改。';
  }

  @override
  String get onboardingLocationDenied => '定位权限已关闭。你仍可以自行选择地区。';

  @override
  String get onboardingRegionDetected => '在你附近检测到';

  @override
  String onboardingRegionUse(String name) {
    return '使用 $name';
  }

  @override
  String get onboardingRegionOthers => '或选择其他地区';

  @override
  String get onboardingRegionEmpty => '目前没有可用的地区。请检查网络连接后重试。';

  @override
  String get surveyCardTitle => '帮助改进公共交通';

  @override
  String get surveyDefaultPrompt => '参与一份简短问卷，帮助改进公共交通。';

  @override
  String get surveyTake => '参与问卷';

  @override
  String get surveyNotNow => '暂不';

  @override
  String get surveyDismiss => '关闭问卷';

  @override
  String get surveyNext => '下一步';

  @override
  String get surveySubmit => '提交问卷';

  @override
  String get surveySubmitting => '正在提交';

  @override
  String get surveyQuestionsTitle => '问卷';

  @override
  String get surveyTextHint => '输入你的回答';

  @override
  String get surveyRequired => '必填';

  @override
  String get surveyIncomplete => '请回答所有必填问题后再提交。';

  @override
  String get surveyFailed => '无法发送你的回答。请重试。';

  @override
  String get surveyThanks => '感谢你的反馈。';

  @override
  String get surveyOpenSurvey => '打开问卷';

  @override
  String get surveyLearnMore => '了解更多';

  @override
  String get surveyShareFeedback => '分享反馈';

  @override
  String get surveySignUp => '注册';

  @override
  String get surveyExternalError => '无法打开此问卷链接。请稍后重试。';

  @override
  String donationTitle(String appName) {
    return '$appName 需要你的帮助';
  }

  @override
  String get donationBody => '本应用由志愿者开发，我们需要你帮助我们资助未来的开发工作。';

  @override
  String get donationLearnMore => '了解更多';

  @override
  String get donationDonate => '立即捐款';

  @override
  String get donationRemindLater => '稍后提醒我';

  @override
  String get donationDismiss => '不用了';

  @override
  String get donationHeader => '为什么我们需要你的帮助';

  @override
  String donationExplanation(String appName) {
    return '我们有许多改进 $appName 的宏大计划，但没有你的帮助就无法实现。本应用由志愿者开发，我们需要你帮助我们资助未来的开发工作。\n\n作为非营利组织 Open Transit Software Foundation 的核心项目，你在美国的捐款可以抵税。';
  }

  @override
  String get donationDonateWebsite => '在我们的网站上捐款';

  @override
  String titleDonation(String appName) {
    return '支持 $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return '喜欢 $appName 吗？';
  }

  @override
  String get feedbackYes => '喜欢！';

  @override
  String get feedbackNo => '不太喜欢';

  @override
  String get feedbackLater => '稍后再问';

  @override
  String get feedbackNegativeTitle => '很抱歉让你失望了。';

  @override
  String get feedbackNegativeBody => '能告诉我们哪里不好吗？我们会阅读每一条消息。';

  @override
  String get feedbackSend => '发送反馈';

  @override
  String get feedbackDecline => '不用了';

  @override
  String get tripPlanningUnavailable => '此地区暂不支持行程规划。';

  @override
  String get deepLinkOtherRegion => '此链接属于另一个地区。请切换地区后再打开。';

  @override
  String get dataUpdated => '已更新';

  @override
  String get bookmarksEtaNow => '现在';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟后',
      one: '$minutes 分钟后',
      zero: '现在',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => '准点';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '晚点 $minutes 分钟',
      one: '晚点 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '提前 $minutes 分钟',
      one: '提前 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => '按时刻表';

  @override
  String get bookmarksStatusCanceled => '已取消';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return '$route 路，开往 $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return '$route 路';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route，$eta，$status';
  }

  @override
  String get bookmarksLoadingDepartures => '正在加载班次';

  @override
  String get bookmarksNoDepartures => '暂无即将发车的班次';

  @override
  String get bookmarksDeparturesError => '无法加载班次';

  @override
  String get bookmarksDeparturesStale => '无法刷新。正在显示较早的时间。';

  @override
  String get bookmarksUpdated => '发车信息已更新';

  @override
  String get bookmarksSortTooltip => '为书签排序';

  @override
  String get bookmarksSortByGroup => '按分组排序';

  @override
  String get bookmarksSortByDistance => '按距离排序';

  @override
  String get bookmarksManageTooltip => '编辑书签和分组';

  @override
  String get bookmarksRefreshTooltip => '刷新班次';

  @override
  String get bookmarksEmptyTitle => '还没有书签';

  @override
  String get bookmarksEmptyBody =>
      '打开一个站点并点按其书签按钮，即可将其保存在这里。你也可以在某个班次上仅为该站点的这条路线添加书签。';

  @override
  String get bookmarksFindStops => '在地图上查找站点';

  @override
  String get bookmarksUngrouped => '未分组';

  @override
  String get bookmarksGroupExpanded => '已展开';

  @override
  String get bookmarksGroupCollapsed => '已收起';

  @override
  String get bookmarksGroupToggleHint => '显示或隐藏此分组中的书签';

  @override
  String bookmarksActionsFor(String name) {
    return '$name 的操作';
  }

  @override
  String get bookmarksActionEdit => '编辑';

  @override
  String get bookmarksActionPin => '置顶';

  @override
  String get bookmarksActionUnpin => '取消置顶';

  @override
  String get bookmarksActionMove => '移到分组';

  @override
  String get bookmarksActionDelete => '删除';

  @override
  String get bookmarksPinned => '已置顶';

  @override
  String bookmarksDeleted(String name) {
    return '已删除 $name';
  }

  @override
  String get bookmarksUndo => '撤销';

  @override
  String get bookmarksMoveTitle => '移到分组';

  @override
  String get bookmarksNoGroup => '无分组';

  @override
  String bookmarksMoved(String group) {
    return '已移到 $group';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name，$details';
  }

  @override
  String get bookmarksEditorNameLabel => '书签名称';

  @override
  String get bookmarksEditorNameRequired => '请为此书签输入名称。';

  @override
  String get bookmarksEditorDuplicate => '你已有一个针对此站点和路线的同名书签。请更改名称后再存储另一个。';

  @override
  String bookmarksEditorStopKind(String stop) {
    return '站点书签：显示 $stop 所有路线的下几班发车信息。';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return '行程书签：显示 $route 在 $stop 的下几班发车信息。';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return '仅 $route';
  }

  @override
  String get bookmarksEditorGroup => '分组';

  @override
  String get bookmarksEditorNewGroup => '新建分组…';

  @override
  String get bookmarksEditorNewGroupTitle => '新建分组';

  @override
  String get bookmarksEditorGroupName => '分组名称';

  @override
  String get bookmarksEditorSave => '存储';

  @override
  String get bookmarksEditorSaved => '书签已存储';

  @override
  String get bookmarksEditorDelete => '删除书签';

  @override
  String get bookmarksEditorDeleteTitle => '要删除此书签吗？';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '“$name”将从你的书签中移除。';
  }

  @override
  String get bookmarksEditorNoRegion => '请先选择地区，再添加书签。';

  @override
  String get bookmarksManageGroupsHeader => '分组';

  @override
  String get bookmarksManageBookmarksHeader => '书签';

  @override
  String get bookmarksManageAddGroup => '添加分组';

  @override
  String get bookmarksManageRenameGroup => '重命名分组';

  @override
  String get bookmarksManageDeleteGroup => '删除分组';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return '“$name”中的书签将变为未分组。';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return '上移 $name';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return '下移 $name';
  }

  @override
  String bookmarksManageReorder(String name) {
    return '为 $name 重新排序';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name，第 $position 位，共 $count 项';
  }

  @override
  String get bookmarksManageEmpty => '还没有可管理的书签或分组。';

  @override
  String get bookmarksManageUngrouped => '未分组的书签';

  @override
  String get recentsEmptyTitle => '没有最近查看的站点';

  @override
  String get recentsEmptyBody => '你查看过的站点会显示在这里，最新的在最前。';

  @override
  String get recentsFindStops => '在地图上查找站点';

  @override
  String get recentsClearAll => '全部清除';

  @override
  String get recentsClearTitle => '要清除最近查看的站点吗？';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '这将移除全部 $count 个最近查看的站点。你的书签不受影响。',
      one: '这将移除 $count 个最近查看的站点。你的书签不受影响。',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return '从最近查看的站点中移除 $name';
  }

  @override
  String recentsRemoved(String name) {
    return '已移除 $name';
  }

  @override
  String get recentsSectionEmpty => '你查看过的站点会显示在这里。';

  @override
  String get alarmsSectionTitle => '闹钟';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '发车前 $minutes 分钟',
      one: '发车前 $minutes 分钟',
    );
    return '$_temp0，$time发车';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return '$title 的闹钟，$details';
  }

  @override
  String alarmsDelete(String title) {
    return '删除 $title 的闹钟';
  }

  @override
  String get alarmsDeleted => '闹钟已删除';

  @override
  String get alarmsDeleteFailed => '无法删除闹钟。请检查网络连接后重试。';

  @override
  String get alarmsOpen => '打开该行程';

  @override
  String get alertsEmptyTitle => '没有服务通知';

  @override
  String get alertsEmptyBody => '目前没有生效的服务通知。';

  @override
  String get alertsRegionNote => '包含你的书签、最近查看和附近站点的通知。';

  @override
  String get alertsMarkAllRead => '全部标为已读';

  @override
  String get alertsAllRead => '所有通知已标为已读';

  @override
  String get alertsUnread => '未读';

  @override
  String get alertsSeverityInfo => '信息';

  @override
  String get alertsSeverityWarning => '警告';

  @override
  String get alertsSeveritySevere => '严重';

  @override
  String get alertsSeverityUnknown => '服务通知';

  @override
  String get alertsNoTitle => '服务通知';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity。$title';
  }

  @override
  String get alertsUnreadPrefix => '未读。';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条未读通知',
      one: '$count 条未读通知',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '另有 $count 条通知',
      one: '另有 $count 条通知',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => '生效时间';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start 至 $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return '自 $start 起';
  }

  @override
  String get alertsDetailAffects => '影响范围';

  @override
  String get alertsDetailRoutes => '路线';

  @override
  String get alertsDetailStops => '站点';

  @override
  String get alertsDetailAgencies => '运营机构';

  @override
  String get alertsDetailLearnMore => '了解更多';

  @override
  String get alertsDetailNoDetails => '没有更多详细信息。';

  @override
  String alertsDetailUpdated(String date) {
    return '发布于 $date';
  }

  @override
  String get alertsCouldNotOpen => '无法打开该链接。';

  @override
  String get agenciesEmptyTitle => '没有运营机构';

  @override
  String get agenciesEmptyBody => '此地区未列出任何公共交通运营机构。';

  @override
  String get agenciesWebsite => '网站';

  @override
  String agenciesPhone(String phone) {
    return '致电 $phone';
  }

  @override
  String agenciesEmail(String email) {
    return '发邮件至 $email';
  }

  @override
  String get agenciesFares => '票价信息';

  @override
  String get agenciesDisclaimer => '免责声明';

  @override
  String get agenciesShowOnMap => '在地图上显示服务范围';

  @override
  String get searchFieldLabel => '搜索';

  @override
  String get searchFieldHint => '路线、站点编号、地址或车辆';

  @override
  String get searchClear => '清除搜索';

  @override
  String get searchScopeLabel => '搜索范围';

  @override
  String get searchScopeAll => '全部';

  @override
  String get searchScopeStops => '站点';

  @override
  String get searchScopeRoutes => '路线';

  @override
  String get searchScopePlaces => '地点';

  @override
  String get searchQuickHeader => '搜索';

  @override
  String searchQuickRoute(String query) {
    return '路线：$query';
  }

  @override
  String searchQuickStop(String query) {
    return '站点编号：$query';
  }

  @override
  String searchQuickAddress(String query) {
    return '地址：$query';
  }

  @override
  String searchQuickVehicle(String query) {
    return '车辆：$query';
  }

  @override
  String get searchRecentStopsHeader => '最近查看的站点';

  @override
  String get searchBookmarksHeader => '书签';

  @override
  String get searchRecentSearchesHeader => '最近搜索';

  @override
  String get searchRecentPlacesHeader => '最近的地点';

  @override
  String get searchPlacesHeader => '地点';

  @override
  String get searchClearRecent => '清除最近搜索';

  @override
  String get searchClearRecentConfirm => '要清除你最近的搜索和地点吗？';

  @override
  String get searchClearAction => '清除';

  @override
  String get searchRecentCleared => '最近搜索已清除';

  @override
  String get searchPlacesLoading => '正在搜索地点';

  @override
  String get searchPlacesNone => '未找到地点';

  @override
  String get searchPlacesError => '无法搜索地点。请检查网络连接。';

  @override
  String get searchSearching => '正在搜索';

  @override
  String get searchNoResultsTitle => '无结果';

  @override
  String searchNoResultsBody(String query) {
    return '未找到“$query”的搜索结果。';
  }

  @override
  String get searchUnavailableNoRegion => '请先选择地区，再进行搜索。';

  @override
  String get searchUnavailableAddress => '本应用未设置地址搜索。';

  @override
  String get searchUnavailableVehicle => '此地区不支持车辆搜索。';

  @override
  String get searchEmptyTitle => '查找路线、站点和地点';

  @override
  String get searchEmptyBody => '输入路线名称、站点编号、地址或车辆 ID。';

  @override
  String get searchDismissMessage => '关闭';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '“$query”的 $count 条结果',
      one: '“$query”的 $count 条结果',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => '路线';

  @override
  String get searchResultsStops => '站点';

  @override
  String get searchResultsVehicles => '车辆';

  @override
  String get searchResultsPlaces => '地点';

  @override
  String searchRouteRowLabel(String name, String details) {
    return '$name 路，$details';
  }

  @override
  String searchVehicleTitle(String id) {
    return '车辆 $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return '车辆 $id 目前没有执行行程。';
  }

  @override
  String searchVehicleLoading(String id) {
    return '正在加载车辆 $id';
  }

  @override
  String get searchNearbyLocationPrompt => '开启定位，即可查看你附近站点的发车信息。';

  @override
  String get searchNearbyLocationButton => '使用我的位置';

  @override
  String get searchNearbyLocationDenied => '定位权限已关闭。请在设备设置中开启，以查看你附近的站点。';

  @override
  String get searchNearbyLocationServicesOff => '定位服务已关闭。请开启后查看你附近的站点。';

  @override
  String get searchNearbyLocationUnavailable => '此应用不使用你的位置，因此无法显示你附近的站点。';

  @override
  String get searchNearbyEmpty => '附近没有站点';

  @override
  String get searchNearbyEmptyBody => '步行可达的范围内没有站点。';

  @override
  String get searchNearbyMapCenter => '正在显示地图中心附近的站点。';

  @override
  String get searchNearbyNoDepartures => '未来一小时内没有班次';

  @override
  String get searchNearbyLoadingDepartures => '正在加载班次';

  @override
  String get searchNearbyUpdated => '附近的发车信息已更新';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '附近有 $count 个站点',
      one: '附近有 $count 个站点',
      zero: '附近没有站点',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => '正在获取你的位置…';

  @override
  String get searchNearbyRefresh => '刷新';

  @override
  String searchNearbyDistance(String distance) {
    return '距离 $distance';
  }

  @override
  String get searchNearbyOtherDirection => '其他站点';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return '$direction站点';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route 路，开往 $headsign，$eta，$status。从 $stop 发车';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return '从 $stop 发车';
  }

  @override
  String get searchNearbyCardTitle => '你附近的发车信息';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String get searchEtaNow => '现在';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟后',
      one: '$minutes 分钟后',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => '正在发车';

  @override
  String get searchStatusOnTime => '准点';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '晚点 $minutes 分钟',
      one: '晚点 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '提前 $minutes 分钟',
      one: '提前 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => '按时刻表';

  @override
  String get searchExplorePlanTrip => '规划行程';

  @override
  String get searchExploreWeather => '天气';

  @override
  String get searchExploreAgencies => '运营机构';

  @override
  String get searchPlaceAddress => '地址';

  @override
  String get searchPlaceCoordinates => '坐标';

  @override
  String get searchPlaceDistance => '距离';

  @override
  String get searchPlaceDirectionsTo => '前往这里的路线';

  @override
  String get searchPlaceDirectionsFrom => '从这里出发的路线';

  @override
  String get searchPlaceNearbyStops => '附近站点';

  @override
  String get searchPlaceShare => '分享';

  @override
  String get searchPlaceOpenInMaps => '在地图应用中打开';

  @override
  String get searchPlaceRemovePin => '移除大头针';

  @override
  String get searchPlaceOpenFailed => '无法打开地图应用。';

  @override
  String get searchPlaceShareFailed => '无法分享此地点。';

  @override
  String searchPlaceMarkerLabel(String name) {
    return '地点：$name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return '天气：$temperature，$condition';
  }

  @override
  String get searchWeatherButtonHint => '显示天气预报';

  @override
  String get searchWeatherClear => '晴';

  @override
  String get searchWeatherPartlyCloudy => '局部多云';

  @override
  String get searchWeatherCloudy => '阴';

  @override
  String get searchWeatherRain => '雨';

  @override
  String get searchWeatherSleet => '雨夹雪';

  @override
  String get searchWeatherSnow => '雪';

  @override
  String get searchWeatherWindy => '大风';

  @override
  String get searchWeatherFog => '雾';

  @override
  String get searchWeatherUnknown => '天气状况未知';

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
      other: '华氏 $value 度',
      one: '华氏 $value 度',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '摄氏 $value 度',
      one: '摄氏 $value 度',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherMph(int value) {
    return '$value 英里/小时';
  }

  @override
  String searchWeatherKmh(int value) {
    return '$value 公里/小时';
  }

  @override
  String searchWeatherMps(int value) {
    return '$value 米/秒';
  }

  @override
  String searchWeatherPercent(int value) {
    return '$value%';
  }

  @override
  String get searchWeatherFeelsLike => '体感温度';

  @override
  String get searchWeatherWind => '风速';

  @override
  String get searchWeatherPrecip => '降雨概率';

  @override
  String searchWeatherHighLow(String high, String low) {
    return '最高 $high · 最低 $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return '未来 24 小时最高 $high，最低 $low';
  }

  @override
  String get searchWeatherHourly => '未来 24 小时';

  @override
  String get searchWeatherNow => '现在';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time：$temperature，$condition，降雨概率 $precip';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return '温度单位：$unit';
  }

  @override
  String get searchWeatherFahrenheit => '华氏度（°F）';

  @override
  String get searchWeatherCelsius => '摄氏度（°C）';

  @override
  String searchWeatherUpdated(String time) {
    return '预报时间：$time';
  }

  @override
  String get searchWeatherUnavailable => '此地区暂无天气信息。';

  @override
  String get searchWeatherSummaryLabel => '今天';

  @override
  String get bookmarksSectionEmpty => '已加书签的站点会显示在这里。';

  @override
  String get coreDirectionNameN => '北';

  @override
  String get coreDirectionNameNE => '东北';

  @override
  String get coreDirectionNameE => '东';

  @override
  String get coreDirectionNameSE => '东南';

  @override
  String get coreDirectionNameS => '南';

  @override
  String get coreDirectionNameSW => '西南';

  @override
  String get coreDirectionNameW => '西';

  @override
  String get coreDirectionNameNW => '西北';

  @override
  String get coreDirectionAbbrN => '北';

  @override
  String get coreDirectionAbbrNE => '东北';

  @override
  String get coreDirectionAbbrE => '东';

  @override
  String get coreDirectionAbbrSE => '东南';

  @override
  String get coreDirectionAbbrS => '南';

  @override
  String get coreDirectionAbbrSW => '西南';

  @override
  String get coreDirectionAbbrW => '西';

  @override
  String get coreDirectionAbbrNW => '西北';

  @override
  String get coreDirectionBoundN => '北向';

  @override
  String get coreDirectionBoundNE => '东北向';

  @override
  String get coreDirectionBoundE => '东向';

  @override
  String get coreDirectionBoundSE => '东南向';

  @override
  String get coreDirectionBoundS => '南向';

  @override
  String get coreDirectionBoundSW => '西南向';

  @override
  String get coreDirectionBoundW => '西向';

  @override
  String get coreDirectionBoundNW => '西北向';

  @override
  String get coreRouteTypeLightRail => '轻轨';

  @override
  String get coreRouteTypeSubway => '地铁';

  @override
  String get coreRouteTypeRail => '铁路';

  @override
  String get coreRouteTypeBus => '公交车';

  @override
  String get coreRouteTypeFerry => '渡轮';

  @override
  String get coreRouteTypeCableCar => '缆车';

  @override
  String get coreRouteTypeGondola => '索道';

  @override
  String get coreRouteTypeFunicular => '缆索铁路';

  @override
  String coreStopCodeNumeric(String code) {
    return '站点 #$code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return '站点：\'$code\'';
  }

  @override
  String coreStopId(String code) {
    return '站点编号：$code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return '路线：$routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '路线：$routes，另有 $count 条',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return '在 $region 中搜索';
  }

  @override
  String get coreNow => '现在';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String get coreOneMinute => '1 分钟';

  @override
  String get coreOneMinuteAgo => '1 分钟前';

  @override
  String coreMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String get coreJustNow => '刚刚';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds 秒前';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes 分钟前';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours 小时前';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天前',
      one: '$days 天前',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return '更新时间：$ago';
  }

  @override
  String get coreScheduledNotRealTime => '按时刻表/非实时';

  @override
  String coreArrivedMinAgo(int minutes) {
    return '$minutes 分钟前已到站';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return '$minutes 分钟前已发车';
  }

  @override
  String get coreArrivingNow => '正在进站';

  @override
  String get coreDepartingNow => '正在发车';

  @override
  String coreArrivesInMin(int minutes) {
    return '$minutes 分钟后到站';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return '$minutes 分钟后发车';
  }

  @override
  String coreArrivedLate(int minutes) {
    return '晚点 $minutes 分钟到站';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return '提前 $minutes 分钟到站';
  }

  @override
  String get coreArrivedOnTime => '准点到站';

  @override
  String coreDepartedLate(int minutes) {
    return '晚点 $minutes 分钟发车';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return '提前 $minutes 分钟发车';
  }

  @override
  String get coreDepartedOnTime => '准点发车';

  @override
  String coreArrivesLate(int minutes) {
    return '将晚点 $minutes 分钟到站';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return '将提前 $minutes 分钟到站';
  }

  @override
  String get coreArrivesOnTime => '将准点到站';

  @override
  String coreDepartsLate(int minutes) {
    return '将晚点 $minutes 分钟发车';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return '将提前 $minutes 分钟发车';
  }

  @override
  String get coreDepartsOnTime => '将准点发车';

  @override
  String coreMeters(String value) {
    return '$value 米';
  }

  @override
  String coreKilometers(String value) {
    return '$value 公里';
  }

  @override
  String coreFeet(String value) {
    return '$value 英尺';
  }

  @override
  String coreMiles(String value) {
    return '$value 英里';
  }

  @override
  String coreAlarmMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟',
      one: '$minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsNow => '现在';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes分';
  }

  @override
  String get arrivalsCanceled => '已取消';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return '$time 起每 $minutes 分钟一班';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return '每 $minutes 分钟一班，至 $time';
  }

  @override
  String get arrivalsDirectionBoundN => '北向';

  @override
  String get arrivalsDirectionBoundNE => '东北向';

  @override
  String get arrivalsDirectionBoundE => '东向';

  @override
  String get arrivalsDirectionBoundSE => '东南向';

  @override
  String get arrivalsDirectionBoundS => '南向';

  @override
  String get arrivalsDirectionBoundSW => '西南向';

  @override
  String get arrivalsDirectionBoundW => '西向';

  @override
  String get arrivalsDirectionBoundNW => '西北向';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return '$code 向';
  }

  @override
  String get arrivalsRefresh => '刷新到站信息';

  @override
  String get arrivalsRetry => '重试';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '未来 $minutes 分钟内没有到站班次',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound => '未找到站点或服务不可用';

  @override
  String get arrivalsNetworkError => '无法连接到公交服务器。请检查网络连接。';

  @override
  String get arrivalsLoadError => '无法加载到站信息。';

  @override
  String arrivalsStaleNotice(String time) {
    return '无法更新。正在显示 $time 的结果';
  }

  @override
  String get arrivalsArrivingNow => '正在进站';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟后到站',
      one: '$minutes 分钟后到站',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => '实时';

  @override
  String get arrivalsRowTapHint => '显示详情';

  @override
  String arrivalsAtTime(String time) {
    return '$time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '晚点 $minutes 分钟',
      one: '晚点 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '提前 $minutes 分钟',
      one: '提前 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$time 起每 $minutes 分钟一班',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '每 $minutes 分钟一班，至 $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => '时刻表时间';

  @override
  String get arrivalsLoading => '正在加载到站信息';

  @override
  String get arrivalsRefreshing => '正在刷新到站信息';

  @override
  String get arrivalsUpdated => '到站信息已更新';

  @override
  String get tripPlannerOriginLabel => '起点';

  @override
  String get tripPlannerDestinationLabel => '终点';

  @override
  String get tripPlannerChooseOrigin => '选择起点';

  @override
  String get tripPlannerChooseDestination => '选择终点';

  @override
  String get tripPlannerCurrentLocation => '当前位置';

  @override
  String get tripPlannerSwapEndpoints => '对调起点和终点';

  @override
  String get tripPlannerPlanTrip => '规划行程';

  @override
  String get tripPlannerPlanningTrip => '正在规划你的行程';

  @override
  String get tripPlannerOptions => '行程选项';

  @override
  String get tripPlannerLeaveNow => '现在出发';

  @override
  String get tripPlannerDepartAt => '出发时间';

  @override
  String get tripPlannerArriveBy => '到达时间';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return '更改时间，$dateTime';
  }

  @override
  String get tripPlannerModeTransit => '公共交通';

  @override
  String get tripPlannerModeWalk => '步行';

  @override
  String get tripPlannerModeBike => '骑行';

  @override
  String get tripPlannerModeCar => '驾车';

  @override
  String get tripPlannerModeBikeRental => '仅共享单车';

  @override
  String get tripPlannerModeTransitBikeRental => '公共交通 + 共享单车';

  @override
  String get tripPlannerWheelchairAccessible => '无障碍轮椅通行';

  @override
  String get tripPlannerWalkQuarterMile => '0.25 英里';

  @override
  String get tripPlannerWalkHalfMile => '0.5 英里';

  @override
  String get tripPlannerWalkOneMile => '1 英里';

  @override
  String get tripPlannerWalkTwoMiles => '2 英里';

  @override
  String tripPlannerMaxWalk(String distance) {
    return '最多步行 $distance';
  }

  @override
  String get tripPlannerNoTripsFound => '未找到行程';

  @override
  String get tripPlannerRetry => '重试';

  @override
  String get tripPlannerRealTime => '实时';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes 分钟';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours 小时';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours 小时 $minutes 分钟';
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
      other: '换乘 $count 次',
      one: '换乘 $count 次',
      zero: '无需换乘',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return '步行 $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return '$time 从 $place 出发';
  }

  @override
  String get tripPlannerStatusOnTime => '准点';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '晚点 $minutes 分钟';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '提前 $minutes 分钟';
  }

  @override
  String get tripPlannerStatusScheduled => '按时刻表';

  @override
  String get tripPlannerLegBus => '公交车';

  @override
  String get tripPlannerLegTram => '有轨电车';

  @override
  String get tripPlannerLegSubway => '地铁';

  @override
  String get tripPlannerLegRail => '火车';

  @override
  String get tripPlannerLegFerry => '渡轮';

  @override
  String get tripPlannerLegCableCar => '缆车';

  @override
  String get tripPlannerLegGondola => '索道';

  @override
  String get tripPlannerLegFunicular => '缆索铁路';

  @override
  String get tripPlannerLegAirplane => '飞机';

  @override
  String get tripPlannerLegTrolleybus => '无轨电车';

  @override
  String get tripPlannerLegMonorail => '单轨列车';

  @override
  String tripPlannerItinerarySemantics(
    String timeRange,
    String duration,
    String legs,
    String details,
  ) {
    return '$timeRange，$duration。$legs。$details';
  }

  @override
  String tripPlannerLegWalkSemantics(String duration) {
    return '步行 $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return '骑行 $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return '骑共享单车 $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return '驾车 $duration';
  }

  @override
  String tripPlannerLegTransitSemantics(String mode, String duration) {
    return '$mode，$duration';
  }

  @override
  String tripPlannerLegTransitRouteSemantics(
    String mode,
    String route,
    String duration,
  ) {
    return '$mode $route，$duration';
  }

  @override
  String get tripPlannerThen => '然后';

  @override
  String get tripPlannerOpenItineraryHint => '显示行程详情';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分钟',
      one: '$minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours 小时',
      one: '$hours 小时',
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
      other: '$value 英尺',
      one: '$value 英尺',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value 英里',
      one: '$value 英里',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value 米',
      one: '$value 米',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value 公里',
      one: '$value 公里',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return '$start 至 $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => '实时，准点';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '实时，晚点 $minutes 分钟',
      one: '实时，晚点 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '实时，提前 $minutes 分钟',
      one: '实时，提前 $minutes 分钟',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => '时刻表时间';

  @override
  String get tripPlannerResultsHeading => '推荐行程';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 个行程',
      one: '找到 $count 个行程',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 个地点',
      one: '找到 $count 个地点',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel => '行程地图。下方的路线指引描述的是同一个行程。';

  @override
  String get tripPlannerTripDetails => '行程详情';

  @override
  String get tripPlannerMapLabel => '行程地图';

  @override
  String get tripPlannerStart => '起点';

  @override
  String get tripPlannerDestination => '终点';

  @override
  String get tripPlannerUnnamedPlace => '未命名地点';

  @override
  String get tripPlannerRentalBike => '共享单车';

  @override
  String tripPlannerWalkTo(String place) {
    return '步行至 $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return '骑行至 $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return '骑共享单车至 $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return '驾车至 $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return '乘坐$mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return '乘坐$mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return '乘坐开往 $headsign 的$mode';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return '乘坐开往 $headsign 的$mode $route';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return '在 $place 下车';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return '到达 $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 站',
      one: '$count 站',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '显示 $count 站',
      one: '显示 $count 站',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '隐藏 $count 站',
      one: '隐藏 $count 站',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个步骤',
      one: '$count 个步骤',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '显示 $count 个步骤',
      one: '显示 $count 个步骤',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '隐藏 $count 个步骤',
      one: '隐藏 $count 个步骤',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance，约 $duration';
  }

  @override
  String get tripPlannerDirectionDepart => '出发';

  @override
  String get tripPlannerDirectionHardLeft => '向左急转';

  @override
  String get tripPlannerDirectionLeft => '左转';

  @override
  String get tripPlannerDirectionSlightlyLeft => '向左微转';

  @override
  String get tripPlannerDirectionContinue => '继续前行';

  @override
  String get tripPlannerDirectionSlightlyRight => '向右微转';

  @override
  String get tripPlannerDirectionRight => '右转';

  @override
  String get tripPlannerDirectionHardRight => '向右急转';

  @override
  String get tripPlannerDirectionCircleClockwise => '顺时针进入环岛';

  @override
  String get tripPlannerDirectionCircleCounterclockwise => '逆时针进入环岛';

  @override
  String get tripPlannerDirectionElevator => '乘坐电梯';

  @override
  String get tripPlannerDirectionUturnLeft => '向左掉头';

  @override
  String get tripPlannerDirectionUturnRight => '向右掉头';

  @override
  String get tripPlannerDirectionEnterStation => '进入车站';

  @override
  String get tripPlannerDirectionExitStation => '离开车站';

  @override
  String get tripPlannerDirectionFollowSigns => '按指示牌前行';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return '沿 $street 步行 $distance。';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction，进入 $street，步行 $distance。';
  }

  @override
  String get tripPlannerSearchHint => '搜索地点';

  @override
  String get tripPlannerSearchNoResults => '未找到地点';

  @override
  String get tripPlannerSearchError => '无法搜索地点。请重试。';

  @override
  String get tripPlannerUseCurrentLocation => '使用当前位置';

  @override
  String get tripPlannerLocationUnavailable => '无法获取你的位置。';

  @override
  String get tripPlannerClearSearch => '清除搜索';

  @override
  String get tripPlannerErrorMissingEndpoints => '请同时选择起点和终点。';

  @override
  String get tripPlannerErrorNetwork => '无法连接到行程规划服务。请检查网络连接。';

  @override
  String get tripPlannerErrorInvalidResponse => '服务器返回了无效的响应';

  @override
  String get tripPlannerErrorUnknown => '发生未知错误。';

  @override
  String get tripPlannerPlannerSystemError => '暂时无法规划你的行程。请重试。';

  @override
  String get tripPlannerPlannerGraphUnavailable => '行程规划暂时不可用。请稍后再试。';

  @override
  String get tripPlannerPlannerOutsideBounds => '暂不支持此位置。';

  @override
  String get tripPlannerPlannerPathNotFound => '此行程没有可用的路线。';

  @override
  String get tripPlannerPlannerNoTransitTimes => '目前没有可用的公共交通方案。';

  @override
  String get tripPlannerPlannerRequestTimeout => '耗时超出预期。请重试。';

  @override
  String get tripPlannerPlannerBogusParameter => '请求出现问题。请重试。';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound => '找不到起点位置。';

  @override
  String get tripPlannerPlannerGeocodeToNotFound => '找不到终点位置。';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound => '找不到起点和终点。';

  @override
  String get tripPlannerPlannerTooClose => '起点和终点距离太近。';

  @override
  String get tripPlannerPlannerLocationNotAccessible => '所选选项无法通行此路线。';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous => '起点位置不够明确。请尝试更具体地描述。';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous => '终点位置不够明确。请尝试更具体地描述。';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      '两个位置都需要更详细的信息。请尝试进一步完善。';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle => '缺少部分路线选项。';

  @override
  String get tripPlannerPlannerTriangleNotAffine => '所选的路线选项互相冲突。';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet => '请选择路线偏好。';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet => '请调整路线偏好。';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class ObaLocalizationsZhHant extends ObaLocalizationsZh {
  ObaLocalizationsZhHant() : super('zh_Hant');

  @override
  String get commonBack => '返回';

  @override
  String get commonClose => '關閉';

  @override
  String get commonDone => '完成';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重試';

  @override
  String get commonContinue => '繼續';

  @override
  String get commonNotNow => '暫時不要';

  @override
  String get commonSeeAll => '查看全部';

  @override
  String get commonLoading => '載入中';

  @override
  String get commonErrorTitle => '發生問題';

  @override
  String get commonEmptyTitle => '這裡還沒有內容';

  @override
  String get commonComingSoon => '即將推出';

  @override
  String get commonComingSoonBody => '此畫面目前尚無法使用。';

  @override
  String get commonOffline => '你似乎已離線。請檢查網路連線後再試一次。';

  @override
  String get commonServerError => '伺服器未如預期回應。請稍後再試。';

  @override
  String get sheetLabel => '面板';

  @override
  String get sheetExpand => '展開面板';

  @override
  String get sheetCollapse => '收合面板';

  @override
  String get sheetHandleHint => '拖移或點兩下即可調整面板大小';

  @override
  String get homeTabHome => '首頁';

  @override
  String get homeTabRecent => '最近';

  @override
  String get homeTabBookmarks => '書籤';

  @override
  String get homeSearchPlaceholder => '搜尋站牌、路線、地點';

  @override
  String get homeSearchLabel => '搜尋';

  @override
  String get homeSectionNearby => '附近';

  @override
  String get homeSectionRecent => '最近查看的站牌';

  @override
  String get homeSectionBookmarks => '書籤';

  @override
  String get homeSectionAlerts => '服務警示';

  @override
  String get homeSectionExplore => '探索';

  @override
  String get homeSectionMore => '設定與更多';

  @override
  String get mapLabel => '地圖';

  @override
  String get mapZoomInForStops => '放大以查看站牌';

  @override
  String get mapLocationDenied => '定位權限已關閉。點一下即可允許。';

  @override
  String get mapLocationServicesOff => '定位服務已關閉';

  @override
  String get mapRecenter => '顯示我的位置';

  @override
  String get mapSettingsButton => '地圖設定';

  @override
  String get mapStopsListButton => '地圖上的站牌';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '地圖上有 $count 個站牌',
      one: '地圖上有 $count 個站牌',
      zero: '地圖上沒有站牌',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => '你的位置';

  @override
  String get mapDroppedPin => '已放置的圖釘';

  @override
  String get mapVehicle => '車輛';

  @override
  String get mapSelectedStop => '已選取';

  @override
  String get mapBookmarkedStop => '已加入書籤';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name，$routeType站牌';
  }

  @override
  String get mapStopMarkerHint => '開啟該站牌的發車資訊';

  @override
  String mapAttribution(String attribution) {
    return '地圖資料：$attribution';
  }

  @override
  String get mapTypeTitle => '地圖類型';

  @override
  String get mapTypeStandard => '標準';

  @override
  String get mapTypeSatellite => '衛星';

  @override
  String get mapTypeHybrid => '混合';

  @override
  String get mapShowScale => '顯示比例尺';

  @override
  String get mapShowHeading => '顯示朝向';

  @override
  String get mapShowStopLabels => '顯示站牌標籤';

  @override
  String mapPlaceAt(String lat, String lon) {
    return '位於 $lat、$lon 的位置';
  }

  @override
  String get directionN => '北行';

  @override
  String get directionNE => '東北行';

  @override
  String get directionE => '東行';

  @override
  String get directionSE => '東南行';

  @override
  String get directionS => '南行';

  @override
  String get directionSW => '西南行';

  @override
  String get directionW => '西行';

  @override
  String get directionNW => '西北行';

  @override
  String get routeTypeBus => '公車';

  @override
  String get routeTypeLightRail => '輕軌';

  @override
  String get routeTypeSubway => '捷運';

  @override
  String get routeTypeRail => '火車';

  @override
  String get routeTypeFerry => '渡輪';

  @override
  String get routeTypeCableCar => '纜車';

  @override
  String get routeTypeGondola => '空中纜車';

  @override
  String get routeTypeFunicular => '登山纜車';

  @override
  String get routeTypeUnknown => '大眾運輸';

  @override
  String stopCode(String code) {
    return '站牌 $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name，$details';
  }

  @override
  String stopRoutes(String routes) {
    return '路線 $routes';
  }

  @override
  String get stopPageRefresh => '重新整理';

  @override
  String get stopPageRefreshed => '發車資訊已更新';

  @override
  String get stopPageBookmark => '將站牌加入書籤';

  @override
  String get stopPageBookmarked => '已加入書籤。編輯書籤';

  @override
  String get stopPageMoreActions => '更多站牌操作';

  @override
  String get stopPageSchedules => '時刻表';

  @override
  String get stopPageServiceAlerts => '服務警示';

  @override
  String get stopPageNearbyStops => '附近站牌';

  @override
  String get stopPageWalkingDirections => '步行路線';

  @override
  String get stopPageBikeDirections => '單車路線';

  @override
  String get stopPagePlanTripFrom => '從這裡出發規劃行程';

  @override
  String get stopPagePlanTripTo => '規劃前往這裡的行程';

  @override
  String get stopPageShareStop => '分享站牌';

  @override
  String get stopPageReportProblem => '回報問題';

  @override
  String get stopPageFilterRoutes => '篩選路線';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已隱藏 $count 條路線',
      one: '已隱藏 $count 條路線',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => '依時間';

  @override
  String get stopPageModeRoute => '依路線';

  @override
  String get stopPageDepartureTypes => '發車類型';

  @override
  String get stopPageFilterAll => '所有班次';

  @override
  String get stopPageFilterRealtime => '僅即時';

  @override
  String get stopPageFilterScheduled => '僅依時刻表';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '顯示 $count 班已離站的班次',
      one: '顯示 $count 班已離站的班次',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => '隱藏已離站的班次';

  @override
  String get stopPageLoadMore => '載入更多班次';

  @override
  String stopPageWindow(int minutes) {
    return '顯示未來 $minutes 分鐘的班次';
  }

  @override
  String stopPageUpdated(String ago) {
    return '更新於 $ago';
  }

  @override
  String get stopPageStaleTitle => '無法重新整理發車資訊';

  @override
  String get stopPageStaleBody => '這些時間可能已過時。';

  @override
  String get stopPageEmptyTitle => '暫無即將發車的班次';

  @override
  String stopPageEmptyBody(int minutes) {
    return '未來 $minutes 分鐘內沒有發車班次。';
  }

  @override
  String get stopPageEmptyHiddenRoutes => '此處有發車班次的路線均已隱藏。';

  @override
  String get stopPageShowAllRoutes => '顯示所有路線';

  @override
  String get stopPageEmptyFilter => '沒有符合發車類型篩選條件的班次。';

  @override
  String get stopPageShowAllTypes => '顯示所有班次';

  @override
  String get stopPageMissingTitle => '找不到站牌';

  @override
  String get stopPageMissingBody => '此站牌可能已被移除或重新編號。';

  @override
  String stopPageWalkTime(int minutes) {
    return '步行 $minutes 分鐘';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '騎乘 $minutes 分鐘';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '步行 $minutes 分鐘',
      one: '步行 $minutes 分鐘',
    );
    return '$_temp0，$distance。開啟路線。';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '騎乘 $minutes 分鐘',
      one: '騎乘 $minutes 分鐘',
    );
    return '$_temp0，$distance。開啟路線。';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '步行到此站牌需 $minutes 分鐘。上方的班次會更早離站。';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '騎乘到此站牌需 $minutes 分鐘。上方的班次會更早離站。';
  }

  @override
  String stopPageAgencies(String names) {
    return '營運單位：$names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 則服務警示',
      one: '$count 則服務警示',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 則未讀',
      one: '$count 則未讀',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => '未讀';

  @override
  String get stopPageAlertImportant => '重要';

  @override
  String get stopPageDirectionsChooser => '使用以下 App 開啟路線';

  @override
  String get stopPageAppleMaps => 'Apple 地圖';

  @override
  String get stopPageGoogleMaps => 'Google 地圖';

  @override
  String get stopPageCannotOpen => '無法開啟該連結。';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return '從 $route $headsign 轉乘，$time抵達';
  }

  @override
  String get stopPageDeparturesHeader => '發車資訊';

  @override
  String get stopRowNow => '現在';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes 分鐘前';
  }

  @override
  String get stopRowOnTime => '準點';

  @override
  String stopRowLate(int minutes) {
    return '誤點 $minutes 分鐘';
  }

  @override
  String stopRowEarly(int minutes) {
    return '提早 $minutes 分鐘';
  }

  @override
  String get stopRowScheduled => '依時刻表';

  @override
  String get stopRowCanceled => '已取消';

  @override
  String get stopRowOccupancyEmpty => '空車';

  @override
  String get stopRowOccupancyManySeats => '座位充足';

  @override
  String get stopRowOccupancyFewSeats => '座位較少';

  @override
  String get stopRowOccupancyStanding => '僅剩站位';

  @override
  String get stopRowOccupancyCrushed => '非常擁擠';

  @override
  String get stopRowOccupancyFull => '已客滿';

  @override
  String get stopRowOccupancyNotAccepting => '不再接受乘客';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘後到站',
      one: '$minutes 分鐘後到站',
      zero: '正在進站',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘後發車',
      one: '$minutes 分鐘後發車',
      zero: '正在發車',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘前已到站',
      one: '$minutes 分鐘前已到站',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘前已發車',
      one: '$minutes 分鐘前已發車',
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
    return '$route 路線，往 $headsign，$eta，$time，$status';
  }

  @override
  String stopRowA11yLive(String status) {
    return '即時追蹤，$status';
  }

  @override
  String get stopRowA11yScheduledOnly => '僅有時刻表時間，沒有即時資料';

  @override
  String get stopRowA11yTransfer => '你的轉乘班次';

  @override
  String get stopRowA11yMissed => '很可能趕不上，它會在你步行抵達之前離站';

  @override
  String get stopRowA11yAlarm => '已設定提醒';

  @override
  String stopRowActions(String route) {
    return '$route 路線的更多操作';
  }

  @override
  String get stopRowShowTrip => '顯示行程詳情';

  @override
  String get stopRowAddAlarm => '新增提醒';

  @override
  String get stopRowRemoveAlarm => '移除提醒';

  @override
  String get stopRowBookmarkTrip => '將此行程加入書籤';

  @override
  String get stopRowShareTrip => '分享行程';

  @override
  String get stopRowRouteSchedule => '路線時刻表';

  @override
  String get stopRowRouteStops => '此路線的站牌';

  @override
  String stopRouteGroupNext(String times) {
    return '下一班：$times';
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
      other: '$count 班次',
      one: '$count 班次',
    );
    return '$route 路線，往 $headsigns，$_temp0，下一班 $eta';
  }

  @override
  String get stopAlarmPickerTitle => '發車前提醒我';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '提前 $minutes 分鐘',
      one: '提前 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '已設定提前 $minutes 分鐘提醒',
      one: '已設定提前 $minutes 分鐘提醒',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => '提醒已移除';

  @override
  String get stopAlarmFailed => '無法更新提醒。';

  @override
  String get stopAlarmPermissionDenied => '此 App 的通知已關閉。';

  @override
  String get stopFilterTitle => '篩選路線';

  @override
  String get stopFilterSort => '班次排序';

  @override
  String get stopFilterRoutesHeader => '此站牌顯示的路線';

  @override
  String get stopFilterShowAll => '顯示所有路線';

  @override
  String get stopTripArrivingAtYourStop => '即將抵達你的站牌';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '還有 $count 站',
      one: '還有 $count 站',
      zero: '已在你的站牌',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return '距離 $distance';
  }

  @override
  String stopTripAtStop(String stop) {
    return '在 $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return '位置更新於 $ago';
  }

  @override
  String get stopTripNoPosition => '此車輛暫無即時位置';

  @override
  String stopTripStartsAs(String trip) {
    return '起始班次：$trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return '後續班次：$trip';
  }

  @override
  String get stopTripStopsHeader => '站牌';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已過 $count 站',
      one: '已過 $count 站',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你的站牌前還有 $count 站',
      one: '你的站牌前還有 $count 站',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => '你的站牌';

  @override
  String get stopTripBoarding => '上車';

  @override
  String get stopTripVehicleHere => '車輛在此';

  @override
  String get stopTripTerminal => '終點站';

  @override
  String get stopTripPassed => '已過';

  @override
  String get stopTripRouteStops => '此路線的所有站牌';

  @override
  String get stopTripReport => '回報此行程的問題';

  @override
  String get stopTripGhostBus => '回報幽靈公車';

  @override
  String get stopTripCanceled => '此行程已取消';

  @override
  String stopTripVehicleLabel(String route) {
    return '$route 路線上的車輛';
  }

  @override
  String stopTripFrequency(int minutes) {
    return '每 $minutes 分鐘一班';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return '$route 路線';
  }

  @override
  String get stopRouteStopsDirection => '方向';

  @override
  String stopRouteStopsToward(String name) {
    return '往 $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個站牌',
      one: '$count 個站牌',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => '找不到此路線的站牌。';

  @override
  String get stopSchedPrevDay => '前一天';

  @override
  String get stopSchedNextDay => '後一天';

  @override
  String stopSchedPickDate(String date) {
    return '選擇日期，$date';
  }

  @override
  String get stopSchedRoute => '路線';

  @override
  String get stopSchedDirection => '方向';

  @override
  String get stopSchedStop => '站牌';

  @override
  String get stopSchedEmpty => '這一天沒有營運班次。';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return '$start 至 $end，每 $minutes 分鐘一班';
  }

  @override
  String stopSchedTo(String headsign) {
    return '往 $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 班次',
      one: '$count 班次',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour：$times';
  }

  @override
  String get stopSchedNotSupported => '此地區暫不提供時刻表。';

  @override
  String get stopSchedViewList => '列表';

  @override
  String get stopSchedViewGrid => '表格';

  @override
  String get stopSchedNoDeparture => '無發車';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop（你的站牌）';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop，班次 $trip：$time';
  }

  @override
  String get stopReportProblemHeader => '發生了什麼問題？';

  @override
  String get stopReportStopNameWrong => '站牌名稱有誤';

  @override
  String get stopReportStopNumberWrong => '站牌編號有誤';

  @override
  String get stopReportStopLocationWrong => '站牌位置有誤';

  @override
  String get stopReportRouteMissing => '缺少路線或班次';

  @override
  String get stopReportOther => '其他問題';

  @override
  String get stopReportNeverCame => '車輛一直沒來';

  @override
  String get stopReportCameEarly => '來得太早';

  @override
  String get stopReportCameLate => '來得太晚';

  @override
  String get stopReportWrongHeadsign => '車頭路線牌有誤';

  @override
  String get stopReportNotStopHere => '沒有在此停靠';

  @override
  String get stopReportComment => '補充說明（選填）';

  @override
  String get stopReportShareLocation => '分享我的位置';

  @override
  String get stopReportShareLocationHelp => '分享你的位置有助於營運機構解決此問題。';

  @override
  String get stopReportOnVehicle => '我在這輛車上';

  @override
  String get stopReportVehicleId => '車輛編號（選填）';

  @override
  String get stopReportSend => '送出回報';

  @override
  String get stopReportSending => '正在送出回報';

  @override
  String get stopReportSent => '謝謝！你的回報已送出。';

  @override
  String get stopReportFailed => '無法送出回報。請再試一次。';

  @override
  String get stopReportChooseProblem => '請先選擇一個問題。';

  @override
  String stopReportAbout(String name) {
    return '回報對象：$name';
  }

  @override
  String get stopGhostTitle => '回報幽靈公車';

  @override
  String get stopGhostExplain => '幽靈公車是指 App 中顯示有、但實際一直沒來的車。';

  @override
  String get stopGhostWait => '你比預定時間多等了多久？';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30 分鐘以上';

  @override
  String get stopCardEmpty => '近期沒有班次';

  @override
  String get titleSearch => '搜尋';

  @override
  String get titleSearchResults => '結果';

  @override
  String get titleNearbyStops => '附近站牌';

  @override
  String get titleRecentStops => '最近查看的站牌';

  @override
  String get titleBookmarks => '書籤';

  @override
  String get titleStop => '站牌';

  @override
  String get titleTrip => '行程';

  @override
  String get titleRouteStops => '路線';

  @override
  String get titleStopSchedule => '時刻表';

  @override
  String get titleRouteSchedule => '路線時刻表';

  @override
  String get titleAlerts => '服務警示';

  @override
  String get titleAlertDetail => '警示';

  @override
  String get titleAgencies => '營運機構';

  @override
  String get titleRegionPicker => '地區';

  @override
  String get titleCustomRegion => '自訂地區';

  @override
  String get titleSettings => '設定';

  @override
  String get titleMapSettings => '地圖設定';

  @override
  String get titleMore => '更多';

  @override
  String get titleTripPlanner => '規劃行程';

  @override
  String get titlePlace => '地點';

  @override
  String get titleReportStopProblem => '回報問題';

  @override
  String get titleReportTripProblem => '回報問題';

  @override
  String get titleBookmarkEditor => '書籤';

  @override
  String get titleManageBookmarks => '編輯書籤';

  @override
  String get titleCredits => '致謝';

  @override
  String get titleWeather => '天氣';

  @override
  String get titleStopsOnMap => '地圖上的站牌';

  @override
  String onboardingWelcomeTitle(String appName) {
    return '歡迎使用 $appName';
  }

  @override
  String get onboardingWelcomeBody => '查看你附近公車、火車和渡輪的即時到站資訊。';

  @override
  String get onboardingLocationTitle => '尋找你附近的站牌';

  @override
  String get onboardingLocationBody => '允許存取位置，即可查看附近站牌並自動選擇你所在的地區。';

  @override
  String get onboardingAllowLocation => '允許存取位置';

  @override
  String get onboardingRegionTitle => '選擇你的地區';

  @override
  String get onboardingRegionBody => '選擇你想查看大眾運輸資訊的區域。';

  @override
  String get settingsSectionMap => '地圖';

  @override
  String get settingsMapTypeRow => '地圖類型與圖層';

  @override
  String get settingsMapTypeHelp => '選擇地圖的顯示樣式。';

  @override
  String get settingsHeadingHelp => '在地圖上顯示你所面對的方向。';

  @override
  String get settingsStopLabelsHelp => '在地圖上的站牌旁顯示路線名稱。';

  @override
  String get settingsWalkingDirections => '步行路線';

  @override
  String get settingsWalkingDirectionsHelp => '要求前往站牌的步行路線時開啟的 App。';

  @override
  String get settingsDirectionsAsk => '每次詢問';

  @override
  String get settingsDirectionsAppleMaps => 'Apple 地圖';

  @override
  String get settingsDirectionsGoogleMaps => 'Google 地圖';

  @override
  String get settingsSectionDepartures => '發車資訊';

  @override
  String get settingsDepartureFilter => '顯示班次';

  @override
  String get settingsDepartureFilterHelp => '選擇站牌頁面要列出所有班次，或僅列出有即時或時刻表資料的班次。';

  @override
  String get settingsFilterAll => '所有班次';

  @override
  String get settingsFilterRealtime => '僅即時';

  @override
  String get settingsFilterScheduled => '僅依時刻表';

  @override
  String get settingsRegionTimeZone => '以所在地區的時區顯示時間';

  @override
  String get settingsRegionTimeZoneHelp => '時鐘時間使用交通地區的時區，與你的裝置不同時會附上說明。';

  @override
  String get settingsSectionAccessibility => '輔助使用';

  @override
  String get settingsReducedColors => '減少站牌頁面的顏色';

  @override
  String get settingsReducedColorsHelp => '以統一的中性樣式顯示路線標章。';

  @override
  String get settingsCompactMode => '精簡的站牌與行程頁面';

  @override
  String get settingsCompactModeHelp => '縮小間距，讓畫面容納更多內容。';

  @override
  String get settingsSectionWalking => '步行速度';

  @override
  String get settingsWalkingSpeed => '步行速度';

  @override
  String get settingsWalkingSpeedHelp => '用於估算步行時間與抵達時間。';

  @override
  String get settingsSpeedSlow => '慢';

  @override
  String get settingsSpeedAverage => '一般';

  @override
  String get settingsSpeedFast => '快';

  @override
  String settingsSpeedCustom(String speed) {
    return '自訂（$speed 公尺/秒）';
  }

  @override
  String get settingsSectionBike => '單車模式';

  @override
  String get settingsBikeMode => '單車模式';

  @override
  String get settingsBikeModeHelp => '在步行時間估算、抵達時間與站牌頁面中使用較快的移動速度。';

  @override
  String get settingsSectionSurveys => '問卷調查';

  @override
  String get settingsSurveysEnabled => '顯示問卷調查';

  @override
  String get settingsSurveysAlways => '一律在站牌顯示問卷調查';

  @override
  String get settingsSectionPrivacy => '隱私權';

  @override
  String get settingsAnalytics => '向開發者傳送使用資料';

  @override
  String get settingsAnalyticsHelp => '協助開發者了解哪些功能有被使用。';

  @override
  String get settingsSectionDebug => '除錯';

  @override
  String get settingsDebugMode => '除錯模式';

  @override
  String get settingsDebugAlwaysFeedback => '一律顯示意見回饋提示';

  @override
  String get settingsDebugResetFeedback => '重置意見回饋提示狀態';

  @override
  String get settingsDebugResetDonation => '重置捐款卡片狀態';

  @override
  String get settingsDebugResetDone => '已重置';

  @override
  String get settingsSectionTripPlanner => '行程規劃';

  @override
  String get settingsHomeCustomizeMap => '自訂地圖';

  @override
  String get moreHeaderSupport => '本 App 由志工開發與維護。';

  @override
  String get moreSectionDonate => '成為支持者';

  @override
  String moreDonate(String appName) {
    return '捐款支持 $appName';
  }

  @override
  String get moreManageDonations => '管理捐款';

  @override
  String get moreSectionUpdates => '更新與警示';

  @override
  String get moreAlerts => '服務警示';

  @override
  String get moreSectionLocation => '我的位置';

  @override
  String get moreRegion => '地區';

  @override
  String get moreRegionNone => '未選擇';

  @override
  String get morePayFare => '支付車資';

  @override
  String get moreAgencies => '營運機構';

  @override
  String get moreSectionAbout => '關於本 App';

  @override
  String moreRateApp(String appName) {
    return '為 $appName 評分';
  }

  @override
  String get moreContactUs => '聯絡我們';

  @override
  String get morePrivacy => '隱私權政策';

  @override
  String get moreCredits => '致謝';

  @override
  String moreVersion(String appName, String version) {
    return '$appName 版本 $version';
  }

  @override
  String get moreSectionHelpOut => '協助改進本 App';

  @override
  String get moreTranslate => '協助翻譯本 App';

  @override
  String get moreDevelop => '協助修正錯誤並開發新功能';

  @override
  String get moreSectionContact => '聯絡與協助';

  @override
  String get moreTutorials => '使用教學';

  @override
  String get moreCallAgency => '致電營運機構';

  @override
  String get moreTextAgency => '傳訊息給營運機構';

  @override
  String get moreSectionResources => '資源';

  @override
  String get moreContactTitle => '聯絡我們';

  @override
  String get moreContactDevelopers => '功能建議或錯誤回報';

  @override
  String get moreContactAgency => '車輛或時刻表問題';

  @override
  String moreEmailSubject(String appName) {
    return '$appName 意見回饋';
  }

  @override
  String get moreEmailAgencySubject => '乘客意見回饋';

  @override
  String get moreEmailIntro => '我們能幫上什麼忙？請在下方輸入你的回覆：';

  @override
  String get moreEmailDebugIntro =>
      '以下資訊用於排查問題。如果你不方便分享其中任何內容，可以將其刪除，但這可能會影響我們為你提供協助。';

  @override
  String get moreDebugAppVersion => 'App 版本';

  @override
  String get moreDebugOs => '作業系統';

  @override
  String get moreDebugLocale => '語言';

  @override
  String get moreDebugBookmarks => '書籤數量';

  @override
  String get moreDebugLocationPermission => '位置權限';

  @override
  String get moreDebugRegion => '地區';

  @override
  String get moreDebugRegionId => '地區 ID';

  @override
  String get moreDebugApiUrl => 'API 基本網址';

  @override
  String get moreDebugUserId => '使用者 ID';

  @override
  String get moreCantEmailTitle => '無法開啟你的郵件 App';

  @override
  String moreCantEmailBody(String email) {
    return '如需聯絡我們，請寄送電子郵件至 $email。請拷貝除錯資訊並貼到郵件中，以協助我們解決問題。';
  }

  @override
  String get moreCopyEmail => '拷貝電子郵件地址';

  @override
  String get moreCopyDebug => '拷貝除錯資訊';

  @override
  String get moreCopied => '已拷貝到剪貼簿';

  @override
  String get moreFareContinue => '繼續';

  @override
  String get moreFareDontShowAgain => '繼續且不再顯示';

  @override
  String get moreCantOpenLink => '無法開啟該連結。';

  @override
  String get regionPickerAutomatic => '自動選擇地區';

  @override
  String get regionPickerAutomaticHelp => '切換到包含你所在位置的地區。自行選擇地區後將關閉此功能。';

  @override
  String get regionPickerShowExperimental => '顯示實驗性地區';

  @override
  String get regionPickerShowInactive => '顯示未啟用的地區';

  @override
  String get regionPickerRegionsSection => '地區';

  @override
  String get regionPickerCustomSection => '自訂地區';

  @override
  String get regionPickerCurrent => '目前地區';

  @override
  String get regionPickerExperimentalTag => '實驗性';

  @override
  String get regionPickerInactiveTag => '未啟用';

  @override
  String get regionPickerCustomTag => '自訂';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name，$details';
  }

  @override
  String get regionPickerAdd => '新增自訂地區';

  @override
  String get regionPickerRefresh => '重新整理地區';

  @override
  String get regionPickerRefreshed => '地區已更新';

  @override
  String get regionPickerRefreshFailed => '無法更新地區列表。正在顯示已儲存的列表。';

  @override
  String regionPickerSelected(String name) {
    return '已選擇 $name';
  }

  @override
  String regionPickerEdit(String name) {
    return '編輯 $name';
  }

  @override
  String regionPickerDelete(String name) {
    return '刪除 $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return '要刪除 $name 嗎？';
  }

  @override
  String get regionPickerDeleteBody => '此自訂地區將從這部裝置中移除。';

  @override
  String get regionPickerDeleteConfirm => '刪除';

  @override
  String get regionPickerCantDeleteCurrent => '請先選擇其他地區，再刪除此地區。';

  @override
  String get regionPickerEmpty => '沒有可用的地區';

  @override
  String get regionPickerEmptyBody => '請開啟實驗性或未啟用的地區，或新增自訂地區。';

  @override
  String get regionPickerTripPlanner => '此地區的行程規劃';

  @override
  String get customRegionEditTitle => '編輯自訂地區';

  @override
  String get customRegionName => '名稱';

  @override
  String get customRegionObaUrl => 'OneBusAway 伺服器網址';

  @override
  String get customRegionObaUrlHelp => '伺服器的位址，例如 https://oba.example.com/';

  @override
  String get customRegionSidecar => '輔助伺服器網址（選填）';

  @override
  String get customRegionOtp => '行程規劃網址（選填）';

  @override
  String get customRegionOtpGraphql => '行程規劃 GraphQL 網址（選填）';

  @override
  String get customRegionServiceArea => '服務範圍';

  @override
  String get customRegionServiceAreaHelp => '此地區涵蓋的範圍：一個中心點及其延伸距離。';

  @override
  String get customRegionLatitude => '中心緯度';

  @override
  String get customRegionLongitude => '中心經度';

  @override
  String get customRegionLatSpan => '緯度跨度（度）';

  @override
  String get customRegionLonSpan => '經度跨度（度）';

  @override
  String get customRegionUseMap => '使用目前的地圖範圍';

  @override
  String get customRegionSave => '儲存';

  @override
  String get customRegionErrorRequired => '此欄位為必填';

  @override
  String get customRegionErrorUrl => '請輸入以 http:// 或 https:// 開頭的網址';

  @override
  String get customRegionErrorNumber => '請輸入數字';

  @override
  String get customRegionErrorRange => '此數字超出範圍';

  @override
  String get customRegionChecking => '正在檢查伺服器';

  @override
  String get customRegionServerOk => '伺服器已回應';

  @override
  String get customRegionServerUnreachable => '無法連線到此伺服器';

  @override
  String get customRegionServerNotOba => '此伺服器的回應不像 OneBusAway';

  @override
  String customRegionSaved(String name) {
    return '已儲存 $name';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway 是免費的開源大眾運輸軟體，由志工開發，並獲得 Open Transit Software Foundation 的支持。';

  @override
  String get creditsLicenseTitle => '授權';

  @override
  String get creditsMapData => '地圖資料';

  @override
  String get creditsLicenses => '開源授權';

  @override
  String get creditsLicensesHelp => '本 App 所使用的程式庫。';

  @override
  String get creditsLicensesLoading => '正在載入授權';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 項授權',
      one: '$count 項授權',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote => '已涵蓋全球數十個大眾運輸地區。';

  @override
  String get onboardingBenefitNearbyTitle => '查看附近站牌';

  @override
  String get onboardingBenefitNearbyBody => '依距離排序，顯示你周圍的公車和火車。';

  @override
  String get onboardingBenefitMapTitle => '地圖以你為中心';

  @override
  String get onboardingBenefitMapBody => '開啟即顯示你周圍的環境，不必搜尋。';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName 僅在 App 開啟時使用你的位置。你可以隨時在裝置設定中變更。';
  }

  @override
  String get onboardingLocationDenied => '定位權限已關閉。你仍可以自行選擇地區。';

  @override
  String get onboardingRegionDetected => '在你附近偵測到';

  @override
  String onboardingRegionUse(String name) {
    return '使用 $name';
  }

  @override
  String get onboardingRegionOthers => '或選擇其他地區';

  @override
  String get onboardingRegionEmpty => '目前沒有可用的地區。請檢查網路連線後再試一次。';

  @override
  String get surveyCardTitle => '協助改善大眾運輸';

  @override
  String get surveyDefaultPrompt => '填寫一份簡短問卷，協助改善大眾運輸。';

  @override
  String get surveyTake => '填寫問卷';

  @override
  String get surveyNotNow => '暫時不要';

  @override
  String get surveyDismiss => '關閉問卷';

  @override
  String get surveyNext => '下一步';

  @override
  String get surveySubmit => '送出問卷';

  @override
  String get surveySubmitting => '正在送出';

  @override
  String get surveyQuestionsTitle => '問卷';

  @override
  String get surveyTextHint => '輸入你的答案';

  @override
  String get surveyRequired => '必填';

  @override
  String get surveyIncomplete => '請回答所有必填問題後再送出。';

  @override
  String get surveyFailed => '無法傳送你的答案。請再試一次。';

  @override
  String get surveyThanks => '感謝你的意見回饋。';

  @override
  String get surveyOpenSurvey => '開啟問卷';

  @override
  String get surveyLearnMore => '瞭解更多';

  @override
  String get surveyShareFeedback => '分享意見回饋';

  @override
  String get surveySignUp => '註冊';

  @override
  String get surveyExternalError => '無法開啟此問卷連結。請稍後再試。';

  @override
  String donationTitle(String appName) {
    return '$appName 需要你的協助';
  }

  @override
  String get donationBody => '本 App 由志工開發，我們需要你協助我們資助未來的開發工作。';

  @override
  String get donationLearnMore => '瞭解更多';

  @override
  String get donationDonate => '立即捐款';

  @override
  String get donationRemindLater => '稍後提醒我';

  @override
  String get donationDismiss => '不用了';

  @override
  String get donationHeader => '為什麼我們需要你的協助';

  @override
  String donationExplanation(String appName) {
    return '我們有許多改善 $appName 的遠大計畫，但沒有你的協助就無法實現。本 App 由志工開發，我們需要你協助我們資助未來的開發工作。\n\n身為非營利組織 Open Transit Software Foundation 的核心專案，你在美國的捐款可以抵稅。';
  }

  @override
  String get donationDonateWebsite => '在我們的網站上捐款';

  @override
  String titleDonation(String appName) {
    return '支持 $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return '喜歡 $appName 嗎？';
  }

  @override
  String get feedbackYes => '喜歡！';

  @override
  String get feedbackNo => '不太喜歡';

  @override
  String get feedbackLater => '稍後再問';

  @override
  String get feedbackNegativeTitle => '很抱歉讓你失望了。';

  @override
  String get feedbackNegativeBody => '可以告訴我們哪裡不好嗎？我們會閱讀每一則訊息。';

  @override
  String get feedbackSend => '傳送意見回饋';

  @override
  String get feedbackDecline => '不用了';

  @override
  String get tripPlanningUnavailable => '此地區暫不支援行程規劃。';

  @override
  String get deepLinkOtherRegion => '此連結屬於另一個地區。請切換地區後再開啟。';

  @override
  String get dataUpdated => '已更新';

  @override
  String get bookmarksEtaNow => '現在';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘後',
      one: '$minutes 分鐘後',
      zero: '現在',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => '準點';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '誤點 $minutes 分鐘',
      one: '誤點 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '提早 $minutes 分鐘',
      one: '提早 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => '依時刻表';

  @override
  String get bookmarksStatusCanceled => '已取消';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return '$route 路線，往 $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return '$route 路線';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route，$eta，$status';
  }

  @override
  String get bookmarksLoadingDepartures => '正在載入班次';

  @override
  String get bookmarksNoDepartures => '暫無即將發車的班次';

  @override
  String get bookmarksDeparturesError => '無法載入班次';

  @override
  String get bookmarksDeparturesStale => '無法重新整理。正在顯示較早的時間。';

  @override
  String get bookmarksUpdated => '發車資訊已更新';

  @override
  String get bookmarksSortTooltip => '排序書籤';

  @override
  String get bookmarksSortByGroup => '依群組排序';

  @override
  String get bookmarksSortByDistance => '依距離排序';

  @override
  String get bookmarksManageTooltip => '編輯書籤與群組';

  @override
  String get bookmarksRefreshTooltip => '重新整理班次';

  @override
  String get bookmarksEmptyTitle => '尚無書籤';

  @override
  String get bookmarksEmptyBody =>
      '開啟一個站牌並點一下其書籤按鈕，即可將其儲存在這裡。你也可以在某個班次上，僅將該站牌的這條路線加入書籤。';

  @override
  String get bookmarksFindStops => '在地圖上尋找站牌';

  @override
  String get bookmarksUngrouped => '未分組';

  @override
  String get bookmarksGroupExpanded => '已展開';

  @override
  String get bookmarksGroupCollapsed => '已收合';

  @override
  String get bookmarksGroupToggleHint => '顯示或隱藏此群組中的書籤';

  @override
  String bookmarksActionsFor(String name) {
    return '$name 的操作';
  }

  @override
  String get bookmarksActionEdit => '編輯';

  @override
  String get bookmarksActionPin => '釘選到最上方';

  @override
  String get bookmarksActionUnpin => '取消釘選';

  @override
  String get bookmarksActionMove => '移至群組';

  @override
  String get bookmarksActionDelete => '刪除';

  @override
  String get bookmarksPinned => '已釘選';

  @override
  String bookmarksDeleted(String name) {
    return '已刪除 $name';
  }

  @override
  String get bookmarksUndo => '復原';

  @override
  String get bookmarksMoveTitle => '移至群組';

  @override
  String get bookmarksNoGroup => '無群組';

  @override
  String bookmarksMoved(String group) {
    return '已移至 $group';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name，$details';
  }

  @override
  String get bookmarksEditorNameLabel => '書籤名稱';

  @override
  String get bookmarksEditorNameRequired => '請為此書籤輸入名稱。';

  @override
  String get bookmarksEditorDuplicate => '你已有一個針對此站牌和路線的同名書籤。請變更名稱後再儲存另一個。';

  @override
  String bookmarksEditorStopKind(String stop) {
    return '站牌書籤：顯示 $stop 所有路線的下幾班發車資訊。';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return '行程書籤：顯示 $route 在 $stop 的下幾班發車資訊。';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return '僅 $route';
  }

  @override
  String get bookmarksEditorGroup => '群組';

  @override
  String get bookmarksEditorNewGroup => '新增群組…';

  @override
  String get bookmarksEditorNewGroupTitle => '新增群組';

  @override
  String get bookmarksEditorGroupName => '群組名稱';

  @override
  String get bookmarksEditorSave => '儲存';

  @override
  String get bookmarksEditorSaved => '書籤已儲存';

  @override
  String get bookmarksEditorDelete => '刪除書籤';

  @override
  String get bookmarksEditorDeleteTitle => '要刪除此書籤嗎？';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '「$name」將從你的書籤中移除。';
  }

  @override
  String get bookmarksEditorNoRegion => '請先選擇地區，再新增書籤。';

  @override
  String get bookmarksManageGroupsHeader => '群組';

  @override
  String get bookmarksManageBookmarksHeader => '書籤';

  @override
  String get bookmarksManageAddGroup => '新增群組';

  @override
  String get bookmarksManageRenameGroup => '重新命名群組';

  @override
  String get bookmarksManageDeleteGroup => '刪除群組';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return '「$name」中的書籤將變為未分組。';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return '上移 $name';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return '下移 $name';
  }

  @override
  String bookmarksManageReorder(String name) {
    return '重新排序 $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name，第 $position 位，共 $count 項';
  }

  @override
  String get bookmarksManageEmpty => '尚無可管理的書籤或群組。';

  @override
  String get bookmarksManageUngrouped => '未分組的書籤';

  @override
  String get recentsEmptyTitle => '沒有最近查看的站牌';

  @override
  String get recentsEmptyBody => '你查看過的站牌會顯示在這裡，最新的在最前。';

  @override
  String get recentsFindStops => '在地圖上尋找站牌';

  @override
  String get recentsClearAll => '全部清除';

  @override
  String get recentsClearTitle => '要清除最近查看的站牌嗎？';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '這將移除全部 $count 個最近查看的站牌。你的書籤不受影響。',
      one: '這將移除 $count 個最近查看的站牌。你的書籤不受影響。',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return '從最近查看的站牌中移除 $name';
  }

  @override
  String recentsRemoved(String name) {
    return '已移除 $name';
  }

  @override
  String get recentsSectionEmpty => '你查看過的站牌會顯示在這裡。';

  @override
  String get alarmsSectionTitle => '提醒';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '發車前 $minutes 分鐘',
      one: '發車前 $minutes 分鐘',
    );
    return '$_temp0，$time發車';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return '$title 的提醒，$details';
  }

  @override
  String alarmsDelete(String title) {
    return '刪除 $title 的提醒';
  }

  @override
  String get alarmsDeleted => '提醒已刪除';

  @override
  String get alarmsDeleteFailed => '無法刪除提醒。請檢查網路連線後再試一次。';

  @override
  String get alarmsOpen => '開啟該行程';

  @override
  String get alertsEmptyTitle => '沒有服務警示';

  @override
  String get alertsEmptyBody => '目前沒有生效的服務警示。';

  @override
  String get alertsRegionNote => '包含你的書籤、最近查看和附近站牌的警示。';

  @override
  String get alertsMarkAllRead => '全部標為已讀';

  @override
  String get alertsAllRead => '所有警示已標為已讀';

  @override
  String get alertsUnread => '未讀';

  @override
  String get alertsSeverityInfo => '資訊';

  @override
  String get alertsSeverityWarning => '警告';

  @override
  String get alertsSeveritySevere => '嚴重';

  @override
  String get alertsSeverityUnknown => '服務警示';

  @override
  String get alertsNoTitle => '服務警示';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity。$title';
  }

  @override
  String get alertsUnreadPrefix => '未讀。';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 則未讀警示',
      one: '$count 則未讀警示',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '另有 $count 則警示',
      one: '另有 $count 則警示',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => '生效時間';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start 至 $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return '自 $start 起';
  }

  @override
  String get alertsDetailAffects => '影響範圍';

  @override
  String get alertsDetailRoutes => '路線';

  @override
  String get alertsDetailStops => '站牌';

  @override
  String get alertsDetailAgencies => '營運機構';

  @override
  String get alertsDetailLearnMore => '瞭解更多';

  @override
  String get alertsDetailNoDetails => '沒有更多詳細資訊。';

  @override
  String alertsDetailUpdated(String date) {
    return '發布於 $date';
  }

  @override
  String get alertsCouldNotOpen => '無法開啟該連結。';

  @override
  String get agenciesEmptyTitle => '沒有營運機構';

  @override
  String get agenciesEmptyBody => '此地區未列出任何大眾運輸營運機構。';

  @override
  String get agenciesWebsite => '網站';

  @override
  String agenciesPhone(String phone) {
    return '致電 $phone';
  }

  @override
  String agenciesEmail(String email) {
    return '寄電子郵件至 $email';
  }

  @override
  String get agenciesFares => '票價資訊';

  @override
  String get agenciesDisclaimer => '免責聲明';

  @override
  String get agenciesShowOnMap => '在地圖上顯示服務範圍';

  @override
  String get searchFieldLabel => '搜尋';

  @override
  String get searchFieldHint => '路線、站牌編號、地址或車輛';

  @override
  String get searchClear => '清除搜尋';

  @override
  String get searchScopeLabel => '搜尋範圍';

  @override
  String get searchScopeAll => '全部';

  @override
  String get searchScopeStops => '站牌';

  @override
  String get searchScopeRoutes => '路線';

  @override
  String get searchScopePlaces => '地點';

  @override
  String get searchQuickHeader => '搜尋';

  @override
  String searchQuickRoute(String query) {
    return '路線：$query';
  }

  @override
  String searchQuickStop(String query) {
    return '站牌編號：$query';
  }

  @override
  String searchQuickAddress(String query) {
    return '地址：$query';
  }

  @override
  String searchQuickVehicle(String query) {
    return '車輛：$query';
  }

  @override
  String get searchRecentStopsHeader => '最近查看的站牌';

  @override
  String get searchBookmarksHeader => '書籤';

  @override
  String get searchRecentSearchesHeader => '最近搜尋';

  @override
  String get searchRecentPlacesHeader => '最近的地點';

  @override
  String get searchPlacesHeader => '地點';

  @override
  String get searchClearRecent => '清除最近搜尋';

  @override
  String get searchClearRecentConfirm => '要清除你最近的搜尋和地點嗎？';

  @override
  String get searchClearAction => '清除';

  @override
  String get searchRecentCleared => '最近搜尋已清除';

  @override
  String get searchPlacesLoading => '正在搜尋地點';

  @override
  String get searchPlacesNone => '找不到地點';

  @override
  String get searchPlacesError => '無法搜尋地點。請檢查網路連線。';

  @override
  String get searchSearching => '正在搜尋';

  @override
  String get searchNoResultsTitle => '沒有結果';

  @override
  String searchNoResultsBody(String query) {
    return '找不到「$query」的搜尋結果。';
  }

  @override
  String get searchUnavailableNoRegion => '請先選擇地區，再進行搜尋。';

  @override
  String get searchUnavailableAddress => '本 App 未設定地址搜尋。';

  @override
  String get searchUnavailableVehicle => '此地區不支援車輛搜尋。';

  @override
  String get searchEmptyTitle => '尋找路線、站牌和地點';

  @override
  String get searchEmptyBody => '輸入路線名稱、站牌編號、地址或車輛 ID。';

  @override
  String get searchDismissMessage => '關閉';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '「$query」的 $count 筆結果',
      one: '「$query」的 $count 筆結果',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => '路線';

  @override
  String get searchResultsStops => '站牌';

  @override
  String get searchResultsVehicles => '車輛';

  @override
  String get searchResultsPlaces => '地點';

  @override
  String searchRouteRowLabel(String name, String details) {
    return '$name 路線，$details';
  }

  @override
  String searchVehicleTitle(String id) {
    return '車輛 $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return '車輛 $id 目前沒有執行行程。';
  }

  @override
  String searchVehicleLoading(String id) {
    return '正在載入車輛 $id';
  }

  @override
  String get searchNearbyLocationPrompt => '開啟定位，即可查看你附近站牌的發車資訊。';

  @override
  String get searchNearbyLocationButton => '使用我的位置';

  @override
  String get searchNearbyLocationDenied => '定位權限已關閉。請在裝置設定中開啟，以查看你附近的站牌。';

  @override
  String get searchNearbyLocationServicesOff => '定位服務已關閉。請開啟後查看你附近的站牌。';

  @override
  String get searchNearbyLocationUnavailable => '此應用程式不使用你的位置，因此無法顯示你附近的站牌。';

  @override
  String get searchNearbyEmpty => '附近沒有站牌';

  @override
  String get searchNearbyEmptyBody => '步行可達的範圍內沒有站牌。';

  @override
  String get searchNearbyMapCenter => '正在顯示地圖中心附近的站牌。';

  @override
  String get searchNearbyNoDepartures => '未來一小時內沒有班次';

  @override
  String get searchNearbyLoadingDepartures => '正在載入班次';

  @override
  String get searchNearbyUpdated => '附近的發車資訊已更新';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '附近有 $count 個站牌',
      one: '附近有 $count 個站牌',
      zero: '附近沒有站牌',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => '正在取得你的位置…';

  @override
  String get searchNearbyRefresh => '重新整理';

  @override
  String searchNearbyDistance(String distance) {
    return '距離 $distance';
  }

  @override
  String get searchNearbyOtherDirection => '其他站牌';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return '$direction站牌';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route 路線，往 $headsign，$eta，$status。從 $stop 發車';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return '從 $stop 發車';
  }

  @override
  String get searchNearbyCardTitle => '你附近的發車資訊';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get searchEtaNow => '現在';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘後',
      one: '$minutes 分鐘後',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => '正在發車';

  @override
  String get searchStatusOnTime => '準點';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '誤點 $minutes 分鐘',
      one: '誤點 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '提早 $minutes 分鐘',
      one: '提早 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => '依時刻表';

  @override
  String get searchExplorePlanTrip => '規劃行程';

  @override
  String get searchExploreWeather => '天氣';

  @override
  String get searchExploreAgencies => '營運機構';

  @override
  String get searchPlaceAddress => '地址';

  @override
  String get searchPlaceCoordinates => '座標';

  @override
  String get searchPlaceDistance => '距離';

  @override
  String get searchPlaceDirectionsTo => '前往這裡的路線';

  @override
  String get searchPlaceDirectionsFrom => '從這裡出發的路線';

  @override
  String get searchPlaceNearbyStops => '附近站牌';

  @override
  String get searchPlaceShare => '分享';

  @override
  String get searchPlaceOpenInMaps => '在地圖 App 中開啟';

  @override
  String get searchPlaceRemovePin => '移除圖釘';

  @override
  String get searchPlaceOpenFailed => '無法開啟地圖 App。';

  @override
  String get searchPlaceShareFailed => '無法分享此地點。';

  @override
  String searchPlaceMarkerLabel(String name) {
    return '地點：$name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return '天氣：$temperature，$condition';
  }

  @override
  String get searchWeatherButtonHint => '顯示天氣預報';

  @override
  String get searchWeatherClear => '晴';

  @override
  String get searchWeatherPartlyCloudy => '局部多雲';

  @override
  String get searchWeatherCloudy => '陰';

  @override
  String get searchWeatherRain => '雨';

  @override
  String get searchWeatherSleet => '雨夾雪';

  @override
  String get searchWeatherSnow => '雪';

  @override
  String get searchWeatherWindy => '強風';

  @override
  String get searchWeatherFog => '霧';

  @override
  String get searchWeatherUnknown => '天氣狀況不明';

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
      other: '華氏 $value 度',
      one: '華氏 $value 度',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '攝氏 $value 度',
      one: '攝氏 $value 度',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherMph(int value) {
    return '$value 英里/小時';
  }

  @override
  String searchWeatherKmh(int value) {
    return '$value 公里/小時';
  }

  @override
  String searchWeatherMps(int value) {
    return '$value 公尺/秒';
  }

  @override
  String searchWeatherPercent(int value) {
    return '$value%';
  }

  @override
  String get searchWeatherFeelsLike => '體感溫度';

  @override
  String get searchWeatherWind => '風速';

  @override
  String get searchWeatherPrecip => '降雨機率';

  @override
  String searchWeatherHighLow(String high, String low) {
    return '最高 $high · 最低 $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return '未來 24 小時最高 $high，最低 $low';
  }

  @override
  String get searchWeatherHourly => '未來 24 小時';

  @override
  String get searchWeatherNow => '現在';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time：$temperature，$condition，降雨機率 $precip';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return '溫度單位：$unit';
  }

  @override
  String get searchWeatherFahrenheit => '華氏度（°F）';

  @override
  String get searchWeatherCelsius => '攝氏度（°C）';

  @override
  String searchWeatherUpdated(String time) {
    return '預報時間：$time';
  }

  @override
  String get searchWeatherUnavailable => '此地區暫無天氣資訊。';

  @override
  String get searchWeatherSummaryLabel => '今天';

  @override
  String get bookmarksSectionEmpty => '已加入書籤的站牌會顯示在這裡。';

  @override
  String get coreDirectionNameN => '北';

  @override
  String get coreDirectionNameNE => '東北';

  @override
  String get coreDirectionNameE => '東';

  @override
  String get coreDirectionNameSE => '東南';

  @override
  String get coreDirectionNameS => '南';

  @override
  String get coreDirectionNameSW => '西南';

  @override
  String get coreDirectionNameW => '西';

  @override
  String get coreDirectionNameNW => '西北';

  @override
  String get coreDirectionAbbrN => '北';

  @override
  String get coreDirectionAbbrNE => '東北';

  @override
  String get coreDirectionAbbrE => '東';

  @override
  String get coreDirectionAbbrSE => '東南';

  @override
  String get coreDirectionAbbrS => '南';

  @override
  String get coreDirectionAbbrSW => '西南';

  @override
  String get coreDirectionAbbrW => '西';

  @override
  String get coreDirectionAbbrNW => '西北';

  @override
  String get coreDirectionBoundN => '北行';

  @override
  String get coreDirectionBoundNE => '東北行';

  @override
  String get coreDirectionBoundE => '東行';

  @override
  String get coreDirectionBoundSE => '東南行';

  @override
  String get coreDirectionBoundS => '南行';

  @override
  String get coreDirectionBoundSW => '西南行';

  @override
  String get coreDirectionBoundW => '西行';

  @override
  String get coreDirectionBoundNW => '西北行';

  @override
  String get coreRouteTypeLightRail => '輕軌';

  @override
  String get coreRouteTypeSubway => '捷運';

  @override
  String get coreRouteTypeRail => '鐵路';

  @override
  String get coreRouteTypeBus => '公車';

  @override
  String get coreRouteTypeFerry => '渡輪';

  @override
  String get coreRouteTypeCableCar => '纜車';

  @override
  String get coreRouteTypeGondola => '空中纜車';

  @override
  String get coreRouteTypeFunicular => '登山纜車';

  @override
  String coreStopCodeNumeric(String code) {
    return '站牌 #$code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return '站牌：\'$code\'';
  }

  @override
  String coreStopId(String code) {
    return '站牌代碼：$code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return '路線：$routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '路線：$routes，另有 $count 條',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return '在 $region 中搜尋';
  }

  @override
  String get coreNow => '現在';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String get coreOneMinute => '1 分鐘';

  @override
  String get coreOneMinuteAgo => '1 分鐘前';

  @override
  String coreMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String get coreJustNow => '剛剛';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds 秒前';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes 分鐘前';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours 小時前';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天前',
      one: '$days 天前',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return '更新時間：$ago';
  }

  @override
  String get coreScheduledNotRealTime => '依時刻表／非即時';

  @override
  String coreArrivedMinAgo(int minutes) {
    return '$minutes 分鐘前已到站';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return '$minutes 分鐘前已發車';
  }

  @override
  String get coreArrivingNow => '正在進站';

  @override
  String get coreDepartingNow => '正在發車';

  @override
  String coreArrivesInMin(int minutes) {
    return '$minutes 分鐘後到站';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return '$minutes 分鐘後發車';
  }

  @override
  String coreArrivedLate(int minutes) {
    return '誤點 $minutes 分鐘到站';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return '提早 $minutes 分鐘到站';
  }

  @override
  String get coreArrivedOnTime => '準點到站';

  @override
  String coreDepartedLate(int minutes) {
    return '誤點 $minutes 分鐘發車';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return '提早 $minutes 分鐘發車';
  }

  @override
  String get coreDepartedOnTime => '準點發車';

  @override
  String coreArrivesLate(int minutes) {
    return '將誤點 $minutes 分鐘到站';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return '將提早 $minutes 分鐘到站';
  }

  @override
  String get coreArrivesOnTime => '將準點到站';

  @override
  String coreDepartsLate(int minutes) {
    return '將誤點 $minutes 分鐘發車';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return '將提早 $minutes 分鐘發車';
  }

  @override
  String get coreDepartsOnTime => '將準點發車';

  @override
  String coreMeters(String value) {
    return '$value 公尺';
  }

  @override
  String coreKilometers(String value) {
    return '$value 公里';
  }

  @override
  String coreFeet(String value) {
    return '$value 英尺';
  }

  @override
  String coreMiles(String value) {
    return '$value 英里';
  }

  @override
  String coreAlarmMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘',
      one: '$minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsNow => '現在';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes分';
  }

  @override
  String get arrivalsCanceled => '已取消';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return '$time 起每 $minutes 分鐘一班';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return '每 $minutes 分鐘一班，至 $time';
  }

  @override
  String get arrivalsDirectionBoundN => '北行';

  @override
  String get arrivalsDirectionBoundNE => '東北行';

  @override
  String get arrivalsDirectionBoundE => '東行';

  @override
  String get arrivalsDirectionBoundSE => '東南行';

  @override
  String get arrivalsDirectionBoundS => '南行';

  @override
  String get arrivalsDirectionBoundSW => '西南行';

  @override
  String get arrivalsDirectionBoundW => '西行';

  @override
  String get arrivalsDirectionBoundNW => '西北行';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return '$code 行';
  }

  @override
  String get arrivalsRefresh => '重新整理到站資訊';

  @override
  String get arrivalsRetry => '重試';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '未來 $minutes 分鐘內沒有到站班次',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound => '找不到站牌或服務無法使用';

  @override
  String get arrivalsNetworkError => '無法連線到大眾運輸伺服器。請檢查網路連線。';

  @override
  String get arrivalsLoadError => '無法載入到站資訊。';

  @override
  String arrivalsStaleNotice(String time) {
    return '無法更新。正在顯示 $time 的結果';
  }

  @override
  String get arrivalsArrivingNow => '正在進站';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘後到站',
      one: '$minutes 分鐘後到站',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => '即時';

  @override
  String get arrivalsRowTapHint => '顯示詳情';

  @override
  String arrivalsAtTime(String time) {
    return '$time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '誤點 $minutes 分鐘',
      one: '誤點 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '提早 $minutes 分鐘',
      one: '提早 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$time 起每 $minutes 分鐘一班',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '每 $minutes 分鐘一班，至 $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => '時刻表時間';

  @override
  String get arrivalsLoading => '正在載入到站資訊';

  @override
  String get arrivalsRefreshing => '正在重新整理到站資訊';

  @override
  String get arrivalsUpdated => '到站資訊已更新';

  @override
  String get tripPlannerOriginLabel => '起點';

  @override
  String get tripPlannerDestinationLabel => '終點';

  @override
  String get tripPlannerChooseOrigin => '選擇起點';

  @override
  String get tripPlannerChooseDestination => '選擇終點';

  @override
  String get tripPlannerCurrentLocation => '目前位置';

  @override
  String get tripPlannerSwapEndpoints => '對調起點和終點';

  @override
  String get tripPlannerPlanTrip => '規劃行程';

  @override
  String get tripPlannerPlanningTrip => '正在規劃你的行程';

  @override
  String get tripPlannerOptions => '行程選項';

  @override
  String get tripPlannerLeaveNow => '現在出發';

  @override
  String get tripPlannerDepartAt => '出發時間';

  @override
  String get tripPlannerArriveBy => '抵達時間';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return '變更時間，$dateTime';
  }

  @override
  String get tripPlannerModeTransit => '大眾運輸';

  @override
  String get tripPlannerModeWalk => '步行';

  @override
  String get tripPlannerModeBike => '單車';

  @override
  String get tripPlannerModeCar => '開車';

  @override
  String get tripPlannerModeBikeRental => '僅共享單車';

  @override
  String get tripPlannerModeTransitBikeRental => '大眾運輸 + 共享單車';

  @override
  String get tripPlannerWheelchairAccessible => '無障礙輪椅通行';

  @override
  String get tripPlannerWalkQuarterMile => '0.25 英里';

  @override
  String get tripPlannerWalkHalfMile => '0.5 英里';

  @override
  String get tripPlannerWalkOneMile => '1 英里';

  @override
  String get tripPlannerWalkTwoMiles => '2 英里';

  @override
  String tripPlannerMaxWalk(String distance) {
    return '最多步行 $distance';
  }

  @override
  String get tripPlannerNoTripsFound => '找不到行程';

  @override
  String get tripPlannerRetry => '重試';

  @override
  String get tripPlannerRealTime => '即時';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes 分鐘';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours 小時';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours 小時 $minutes 分鐘';
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
      other: '轉乘 $count 次',
      one: '轉乘 $count 次',
      zero: '無需轉乘',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return '步行 $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return '$time 從 $place 出發';
  }

  @override
  String get tripPlannerStatusOnTime => '準點';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '誤點 $minutes 分鐘';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '提早 $minutes 分鐘';
  }

  @override
  String get tripPlannerStatusScheduled => '依時刻表';

  @override
  String get tripPlannerLegBus => '公車';

  @override
  String get tripPlannerLegTram => '有軌電車';

  @override
  String get tripPlannerLegSubway => '捷運';

  @override
  String get tripPlannerLegRail => '火車';

  @override
  String get tripPlannerLegFerry => '渡輪';

  @override
  String get tripPlannerLegCableCar => '纜車';

  @override
  String get tripPlannerLegGondola => '空中纜車';

  @override
  String get tripPlannerLegFunicular => '登山纜車';

  @override
  String get tripPlannerLegAirplane => '飛機';

  @override
  String get tripPlannerLegTrolleybus => '無軌電車';

  @override
  String get tripPlannerLegMonorail => '單軌電車';

  @override
  String tripPlannerItinerarySemantics(
    String timeRange,
    String duration,
    String legs,
    String details,
  ) {
    return '$timeRange，$duration。$legs。$details';
  }

  @override
  String tripPlannerLegWalkSemantics(String duration) {
    return '步行 $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return '騎單車 $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return '騎共享單車 $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return '開車 $duration';
  }

  @override
  String tripPlannerLegTransitSemantics(String mode, String duration) {
    return '$mode，$duration';
  }

  @override
  String tripPlannerLegTransitRouteSemantics(
    String mode,
    String route,
    String duration,
  ) {
    return '$mode $route，$duration';
  }

  @override
  String get tripPlannerThen => '然後';

  @override
  String get tripPlannerOpenItineraryHint => '顯示行程詳情';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes 分鐘',
      one: '$minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours 小時',
      one: '$hours 小時',
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
      other: '$value 英尺',
      one: '$value 英尺',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value 英里',
      one: '$value 英里',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value 公尺',
      one: '$value 公尺',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value 公里',
      one: '$value 公里',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return '$start 至 $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => '即時，準點';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '即時，誤點 $minutes 分鐘',
      one: '即時，誤點 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '即時，提早 $minutes 分鐘',
      one: '即時，提早 $minutes 分鐘',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => '時刻表時間';

  @override
  String get tripPlannerResultsHeading => '建議行程';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 個行程',
      one: '找到 $count 個行程',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到 $count 個地點',
      one: '找到 $count 個地點',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel => '行程地圖。下方的路線指引描述的是同一個行程。';

  @override
  String get tripPlannerTripDetails => '行程詳情';

  @override
  String get tripPlannerMapLabel => '行程地圖';

  @override
  String get tripPlannerStart => '起點';

  @override
  String get tripPlannerDestination => '終點';

  @override
  String get tripPlannerUnnamedPlace => '未命名地點';

  @override
  String get tripPlannerRentalBike => '共享單車';

  @override
  String tripPlannerWalkTo(String place) {
    return '步行至 $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return '騎單車至 $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return '騎共享單車至 $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return '開車至 $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return '搭乘$mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return '搭乘$mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return '搭乘往 $headsign 的$mode';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return '搭乘往 $headsign 的$mode $route';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return '在 $place 下車';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return '抵達 $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 站',
      one: '$count 站',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '顯示 $count 站',
      one: '顯示 $count 站',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '隱藏 $count 站',
      one: '隱藏 $count 站',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個步驟',
      one: '$count 個步驟',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '顯示 $count 個步驟',
      one: '顯示 $count 個步驟',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '隱藏 $count 個步驟',
      one: '隱藏 $count 個步驟',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance，約 $duration';
  }

  @override
  String get tripPlannerDirectionDepart => '出發';

  @override
  String get tripPlannerDirectionHardLeft => '向左急轉';

  @override
  String get tripPlannerDirectionLeft => '左轉';

  @override
  String get tripPlannerDirectionSlightlyLeft => '向左微轉';

  @override
  String get tripPlannerDirectionContinue => '繼續前行';

  @override
  String get tripPlannerDirectionSlightlyRight => '向右微轉';

  @override
  String get tripPlannerDirectionRight => '右轉';

  @override
  String get tripPlannerDirectionHardRight => '向右急轉';

  @override
  String get tripPlannerDirectionCircleClockwise => '順時針進入圓環';

  @override
  String get tripPlannerDirectionCircleCounterclockwise => '逆時針進入圓環';

  @override
  String get tripPlannerDirectionElevator => '搭乘電梯';

  @override
  String get tripPlannerDirectionUturnLeft => '向左迴轉';

  @override
  String get tripPlannerDirectionUturnRight => '向右迴轉';

  @override
  String get tripPlannerDirectionEnterStation => '進入車站';

  @override
  String get tripPlannerDirectionExitStation => '離開車站';

  @override
  String get tripPlannerDirectionFollowSigns => '依指標前行';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return '沿 $street 步行 $distance。';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction，進入 $street，步行 $distance。';
  }

  @override
  String get tripPlannerSearchHint => '搜尋地點';

  @override
  String get tripPlannerSearchNoResults => '找不到地點';

  @override
  String get tripPlannerSearchError => '無法搜尋地點。請再試一次。';

  @override
  String get tripPlannerUseCurrentLocation => '使用目前位置';

  @override
  String get tripPlannerLocationUnavailable => '無法取得你的位置。';

  @override
  String get tripPlannerClearSearch => '清除搜尋';

  @override
  String get tripPlannerErrorMissingEndpoints => '請同時選擇起點和終點。';

  @override
  String get tripPlannerErrorNetwork => '無法連線到行程規劃服務。請檢查網路連線。';

  @override
  String get tripPlannerErrorInvalidResponse => '伺服器傳回了無效的回應';

  @override
  String get tripPlannerErrorUnknown => '發生未知錯誤。';

  @override
  String get tripPlannerPlannerSystemError => '暫時無法規劃你的行程。請再試一次。';

  @override
  String get tripPlannerPlannerGraphUnavailable => '行程規劃暫時無法使用。請稍後再試。';

  @override
  String get tripPlannerPlannerOutsideBounds => '目前尚不支援此位置。';

  @override
  String get tripPlannerPlannerPathNotFound => '此行程沒有可用的路線。';

  @override
  String get tripPlannerPlannerNoTransitTimes => '目前沒有可用的大眾運輸方案。';

  @override
  String get tripPlannerPlannerRequestTimeout => '耗時超出預期。請再試一次。';

  @override
  String get tripPlannerPlannerBogusParameter => '要求發生問題。請再試一次。';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound => '找不到起點位置。';

  @override
  String get tripPlannerPlannerGeocodeToNotFound => '找不到終點位置。';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound => '找不到起點和終點。';

  @override
  String get tripPlannerPlannerTooClose => '起點和終點距離太近。';

  @override
  String get tripPlannerPlannerLocationNotAccessible => '所選選項無法通行此路線。';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous => '起點位置不夠明確。請嘗試更具體地描述。';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous => '終點位置不夠明確。請嘗試更具體地描述。';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      '兩個位置都需要更詳細的資訊。請嘗試進一步調整。';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle => '缺少部分路線選項。';

  @override
  String get tripPlannerPlannerTriangleNotAffine => '所選的路線選項互相衝突。';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet => '請選擇路線偏好。';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet => '請調整路線偏好。';
}
