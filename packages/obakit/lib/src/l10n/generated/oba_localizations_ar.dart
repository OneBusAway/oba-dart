// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class ObaLocalizationsAr extends ObaLocalizations {
  ObaLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonDone => 'تم';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonRetry => 'حاول مرة أخرى';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonNotNow => 'ليس الآن';

  @override
  String get commonSeeAll => 'عرض الكل';

  @override
  String get commonLoading => 'جارٍ التحميل';

  @override
  String get commonErrorTitle => 'حدث خطأ ما';

  @override
  String get commonOffline =>
      'يبدو أنك غير متصل بالإنترنت. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get commonServerError =>
      'لم يستجب الخادم كما هو متوقع. حاول مرة أخرى بعد قليل.';

  @override
  String get sheetLabel => 'اللوحة';

  @override
  String get sheetExpand => 'توسيع اللوحة';

  @override
  String get sheetCollapse => 'طي اللوحة';

  @override
  String get sheetHandleHint => 'اسحب أو انقر مرتين لتغيير حجم اللوحة';

  @override
  String get homeTabHome => 'الرئيسية';

  @override
  String get homeTabRecent => 'الأخيرة';

  @override
  String get homeTabBookmarks => 'الإشارات المرجعية';

  @override
  String get homeSearchPlaceholder => 'ابحث عن مواقف أو خطوط أو أماكن';

  @override
  String get homeSearchLabel => 'بحث';

  @override
  String get homeSectionNearby => 'بالقرب منك';

  @override
  String get homeSectionRecent => 'المواقف الأخيرة';

  @override
  String get homeSectionBookmarks => 'الإشارات المرجعية';

  @override
  String get homeSectionAlerts => 'التنبيهات';

  @override
  String get homeSectionExplore => 'استكشاف';

  @override
  String get homeSectionMore => 'الإعدادات والمزيد';

  @override
  String get mapLabel => 'الخريطة';

  @override
  String get mapZoomInForStops => 'قرّب الخريطة لعرض المواقف';

  @override
  String get mapLocationDenied => 'الوصول إلى الموقع معطل. انقر للسماح.';

  @override
  String get mapLocationServicesOff => 'خدمات الموقع معطلة';

  @override
  String get mapRecenter => 'إظهار موقعي';

  @override
  String get mapSettingsButton => 'إعدادات الخريطة';

  @override
  String get mapStopsListButton => 'المواقف على الخريطة';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موقف على الخريطة',
      many: '$count موقفًا على الخريطة',
      few: '$count مواقف على الخريطة',
      two: 'موقفان على الخريطة',
      one: 'موقف واحد على الخريطة',
      zero: 'لا توجد مواقف على الخريطة',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'موقعك';

  @override
  String get mapDroppedPin => 'دبوس مثبّت';

  @override
  String get mapVehicle => 'مركبة';

  @override
  String get mapBookmarkedStop => 'مضاف إلى الإشارات المرجعية';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name، موقف $routeType';
  }

  @override
  String get mapStopMarkerHint => 'يفتح مواعيد المغادرة من الموقف';

  @override
  String mapAttribution(String attribution) {
    return 'بيانات الخريطة: $attribution';
  }

  @override
  String get mapTypeTitle => 'نوع الخريطة';

  @override
  String get mapTypeStandard => 'قياسية';

  @override
  String get mapTypeSatellite => 'قمر صناعي';

  @override
  String get mapTypeHybrid => 'هجينة';

  @override
  String get mapShowHeading => 'إظهار الاتجاه';

  @override
  String get directionN => 'متجه شمالاً';

  @override
  String get directionNE => 'متجه شمالاً شرقياً';

  @override
  String get directionE => 'متجه شرقاً';

  @override
  String get directionSE => 'متجه جنوباً شرقياً';

  @override
  String get directionS => 'متجه جنوباً';

  @override
  String get directionSW => 'متجه جنوباً غربياً';

  @override
  String get directionW => 'متجه غرباً';

  @override
  String get directionNW => 'متجه شمالاً غربياً';

  @override
  String get routeTypeBus => 'حافلة';

  @override
  String get routeTypeLightRail => 'قطار خفيف';

  @override
  String get routeTypeSubway => 'مترو';

  @override
  String get routeTypeRail => 'قطار';

  @override
  String get routeTypeFerry => 'عبّارة';

  @override
  String get routeTypeCableCar => 'تلفريك';

  @override
  String get routeTypeGondola => 'مصعد هوائي';

  @override
  String get routeTypeFunicular => 'قطار جبلي';

  @override
  String get routeTypeUnknown => 'نقل عام';

  @override
  String stopCode(String code) {
    return 'الموقف $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name، $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'الخطوط $routes';
  }

  @override
  String get stopPageRefresh => 'تحديث';

  @override
  String get stopPageRefreshed => 'تم تحديث مواعيد المغادرة';

  @override
  String get stopPageBookmark => 'إضافة الموقف إلى الإشارات المرجعية';

  @override
  String get stopPageBookmarked =>
      'تمت الإضافة إلى الإشارات المرجعية. تعديل الإشارة المرجعية';

  @override
  String get stopPageMoreActions => 'المزيد من إجراءات الموقف';

  @override
  String get stopPageSchedules => 'الجداول';

  @override
  String get stopPageServiceAlerts => 'تنبيهات الخدمة';

  @override
  String get stopPageNearbyStops => 'المواقف القريبة';

  @override
  String get stopPageWalkingDirections => 'اتجاهات المشي';

  @override
  String get stopPageBikeDirections => 'اتجاهات ركوب الدراجة';

  @override
  String get stopPagePlanTripFrom => 'خطط لرحلة من هنا';

  @override
  String get stopPagePlanTripTo => 'خطط لرحلة إلى هنا';

  @override
  String get stopPageShareStop => 'مشاركة الموقف';

  @override
  String get stopPageReportProblem => 'الإبلاغ عن مشكلة';

  @override
  String get stopPageFilterRoutes => 'تصفية الخطوط';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خط مخفي',
      many: '$count خطًا مخفيًا',
      few: '$count خطوط مخفية',
      two: 'خطان مخفيان',
      one: 'خط واحد مخفي',
      zero: 'لا توجد خطوط مخفية',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'حسب الوقت';

  @override
  String get stopPageModeRoute => 'حسب الخط';

  @override
  String get stopPageDepartureTypes => 'أنواع المغادرات';

  @override
  String get stopPageFilterAll => 'كل المغادرات';

  @override
  String get stopPageFilterRealtime => 'الوقت الفعلي فقط';

  @override
  String get stopPageFilterScheduled => 'المجدولة فقط';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عرض $count مغادرة سابقة',
      many: 'عرض $count مغادرة سابقة',
      few: 'عرض $count مغادرات سابقة',
      two: 'عرض مغادرتين سابقتين',
      one: 'عرض مغادرة سابقة واحدة',
      zero: 'عرض 0 مغادرة سابقة',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'إخفاء المغادرات السابقة';

  @override
  String get stopPageLoadMore => 'تحميل المزيد من المغادرات';

  @override
  String stopPageWindow(int minutes) {
    return 'عرض الدقائق الـ $minutes القادمة';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'آخر تحديث $ago';
  }

  @override
  String get stopPageStaleTitle => 'تعذّر تحديث المغادرات';

  @override
  String get stopPageStaleBody => 'قد تكون هذه الأوقات قديمة.';

  @override
  String get stopPageEmptyTitle => 'لا توجد مغادرات قادمة';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'لا توجد مغادرات خلال الدقائق الـ $minutes القادمة.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'جميع الخطوط التي لها مغادرات هنا مخفية.';

  @override
  String get stopPageShowAllRoutes => 'إظهار كل الخطوط';

  @override
  String get stopPageEmptyFilter =>
      'لا توجد مغادرات تطابق عامل تصفية نوع المغادرة.';

  @override
  String get stopPageShowAllTypes => 'إظهار كل المغادرات';

  @override
  String get stopPageMissingTitle => 'لم يُعثر على الموقف';

  @override
  String get stopPageMissingBody => 'ربما أُزيل هذا الموقف أو أُعيد ترقيمه.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes د مشياً';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes د بالدراجة';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'المشي $minutes دقيقة',
      many: 'المشي $minutes دقيقة',
      few: 'المشي $minutes دقائق',
      two: 'المشي دقيقتان',
      one: 'المشي دقيقة واحدة',
      zero: 'المشي أقل من دقيقة',
    );
    return '$_temp0، $distance. يفتح الاتجاهات.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'ركوب الدراجة $minutes دقيقة',
      many: 'ركوب الدراجة $minutes دقيقة',
      few: 'ركوب الدراجة $minutes دقائق',
      two: 'ركوب الدراجة دقيقتان',
      one: 'ركوب الدراجة دقيقة واحدة',
      zero: 'ركوب الدراجة أقل من دقيقة',
    );
    return '$_temp0، $distance. يفتح الاتجاهات.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return 'المشي إلى هذا الموقف يستغرق $minutes دقيقة. المغادرات أعلاه تغادر قبل ذلك.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return 'ركوب الدراجة إلى هذا الموقف يستغرق $minutes دقيقة. المغادرات أعلاه تغادر قبل ذلك.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'الخدمة من $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تنبيه خدمة',
      many: '$count تنبيه خدمة',
      few: '$count تنبيهات خدمة',
      two: 'تنبيها خدمة',
      one: 'تنبيه خدمة واحد',
      zero: 'لا توجد تنبيهات خدمة',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count غير مقروء',
      many: '$count غير مقروء',
      few: '$count غير مقروءة',
      two: '2 غير مقروءين',
      one: '1 غير مقروء',
      zero: 'لا شيء غير مقروء',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'غير مقروء';

  @override
  String get stopPageAlertImportant => 'مهم';

  @override
  String get stopPageDirectionsChooser => 'فتح الاتجاهات في';

  @override
  String get stopPageAppleMaps => 'Apple Maps';

  @override
  String get stopPageGoogleMaps => 'Google Maps';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'التحويل من الخط $route $headsign، الوصول $time';
  }

  @override
  String get stopPageDeparturesHeader => 'المغادرات';

  @override
  String get stopRowNow => 'الآن';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return 'قبل $minutes د';
  }

  @override
  String get stopRowOnTime => 'في الموعد';

  @override
  String stopRowLate(int minutes) {
    return 'متأخرة بـ $minutes د';
  }

  @override
  String stopRowEarly(int minutes) {
    return 'مبكرة بـ $minutes د';
  }

  @override
  String get stopRowScheduled => 'مجدولة';

  @override
  String get stopRowCanceled => 'ملغاة';

  @override
  String get stopRowOccupancyEmpty => 'فارغة';

  @override
  String get stopRowOccupancyManySeats => 'مقاعد كثيرة متاحة';

  @override
  String get stopRowOccupancyFewSeats => 'مقاعد قليلة متاحة';

  @override
  String get stopRowOccupancyStanding => 'أماكن وقوف فقط';

  @override
  String get stopRowOccupancyCrushed => 'مزدحمة جداً';

  @override
  String get stopRowOccupancyFull => 'ممتلئة';

  @override
  String get stopRowOccupancyNotAccepting => 'لا تقبل ركاباً';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'تصل خلال $minutes دقيقة',
      many: 'تصل خلال $minutes دقيقة',
      few: 'تصل خلال $minutes دقائق',
      two: 'تصل خلال دقيقتين',
      one: 'تصل خلال دقيقة واحدة',
      zero: 'تصل الآن',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'تغادر خلال $minutes دقيقة',
      many: 'تغادر خلال $minutes دقيقة',
      few: 'تغادر خلال $minutes دقائق',
      two: 'تغادر خلال دقيقتين',
      one: 'تغادر خلال دقيقة واحدة',
      zero: 'تغادر الآن',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'وصلت قبل $minutes دقيقة',
      many: 'وصلت قبل $minutes دقيقة',
      few: 'وصلت قبل $minutes دقائق',
      two: 'وصلت قبل دقيقتين',
      one: 'وصلت قبل دقيقة واحدة',
      zero: 'وصلت الآن',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'غادرت قبل $minutes دقيقة',
      many: 'غادرت قبل $minutes دقيقة',
      few: 'غادرت قبل $minutes دقائق',
      two: 'غادرت قبل دقيقتين',
      one: 'غادرت قبل دقيقة واحدة',
      zero: 'غادرت الآن',
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
    return 'الخط $route إلى $headsign، $eta، في الساعة $time، $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'تتبع مباشر، $status';
  }

  @override
  String get stopRowA11yScheduledOnly => 'الوقت المجدول فقط، بلا بيانات مباشرة';

  @override
  String get stopRowA11yTransfer => 'رحلة التحويل الخاصة بك';

  @override
  String get stopRowA11yMissed =>
      'من المرجح أنك ستفوتها، فهي تغادر قبل أن تتمكن من المشي إلى هناك';

  @override
  String get stopRowA11yAlarm => 'تم ضبط التذكير';

  @override
  String stopRowActions(String route) {
    return 'المزيد من الإجراءات للخط $route';
  }

  @override
  String get stopRowShowTrip => 'عرض تفاصيل الرحلة';

  @override
  String get stopRowAddAlarm => 'إضافة تذكير';

  @override
  String get stopRowRemoveAlarm => 'إزالة التذكير';

  @override
  String get stopRowBookmarkTrip => 'إضافة هذه الرحلة إلى الإشارات المرجعية';

  @override
  String get stopRowShareTrip => 'مشاركة الرحلة';

  @override
  String get stopRowRouteSchedule => 'جدول الخط';

  @override
  String get stopRowRouteStops => 'مواقف هذا الخط';

  @override
  String stopRouteGroupNext(String times) {
    return 'التالية: $times';
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
      other: '$count مغادرة',
      many: '$count مغادرة',
      few: '$count مغادرات',
      two: 'مغادرتان',
      one: 'مغادرة واحدة',
      zero: 'لا توجد مغادرات',
    );
    return 'الخط $route إلى $headsigns، $_temp0، التالية $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'ذكّرني قبل المغادرة';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'قبل $minutes دقيقة',
      many: 'قبل $minutes دقيقة',
      few: 'قبل $minutes دقائق',
      two: 'قبل دقيقتين',
      one: 'قبل دقيقة واحدة',
      zero: 'عند المغادرة',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'تم ضبط التذكير قبل $minutes دقيقة',
      many: 'تم ضبط التذكير قبل $minutes دقيقة',
      few: 'تم ضبط التذكير قبل $minutes دقائق',
      two: 'تم ضبط التذكير قبل دقيقتين',
      one: 'تم ضبط التذكير قبل دقيقة واحدة',
      zero: 'تم ضبط التذكير عند المغادرة',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'تمت إزالة التذكير';

  @override
  String get stopAlarmFailed => 'تعذّر تحديث التذكير.';

  @override
  String get stopAlarmPermissionDenied => 'الإشعارات متوقفة لهذا التطبيق.';

  @override
  String get stopFilterTitle => 'تصفية الخطوط';

  @override
  String get stopFilterSort => 'ترتيب المغادرات';

  @override
  String get stopFilterRoutesHeader => 'الخطوط المعروضة في هذا الموقف';

  @override
  String get stopFilterShowAll => 'إظهار كل الخطوط';

  @override
  String get stopTripArrivingAtYourStop => 'تصل إلى موقفك';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'يبعد $count موقف',
      many: 'يبعد $count موقفًا',
      few: 'يبعد $count مواقف',
      two: 'يبعد موقفان',
      one: 'يبعد موقف واحد',
      zero: 'عند موقفك',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return 'على بعد $distance';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'عند $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'تم تحديث الموقع $ago';
  }

  @override
  String get stopTripNoPosition => 'لا يوجد موقع فعلي لهذه المركبة';

  @override
  String stopTripStartsAs(String trip) {
    return 'تبدأ كرحلة $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'تستمر كرحلة $trip';
  }

  @override
  String get stopTripStopsHeader => 'المواقف';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موقف تم تجاوزها',
      many: '$count موقفًا تم تجاوزها',
      few: '$count مواقف تم تجاوزها',
      two: 'موقفان تم تجاوزهما',
      one: 'موقف واحد تم تجاوزه',
      zero: 'لا توجد مواقف تم تجاوزها',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موقف قبل موقفك',
      many: '$count موقفًا قبل موقفك',
      few: '$count مواقف قبل موقفك',
      two: 'موقفان قبل موقفك',
      one: 'موقف واحد قبل موقفك',
      zero: 'لا توجد مواقف قبل موقفك',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'موقفك';

  @override
  String get stopTripBoarding => 'جارٍ الصعود';

  @override
  String get stopTripVehicleHere => 'المركبة هنا';

  @override
  String get stopTripTerminal => 'آخر موقف';

  @override
  String get stopTripPassed => 'تم تجاوزه';

  @override
  String get stopTripRouteStops => 'كل مواقف هذا الخط';

  @override
  String get stopTripReport => 'الإبلاغ عن مشكلة في هذه الرحلة';

  @override
  String get stopTripGhostBus => 'الإبلاغ عن حافلة وهمية';

  @override
  String get stopTripCanceled => 'هذه الرحلة ملغاة';

  @override
  String stopTripVehicleLabel(String route) {
    return 'مركبة على الخط $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'كل $minutes د';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'الخط $route';
  }

  @override
  String get stopRouteStopsDirection => 'الاتجاه';

  @override
  String stopRouteStopsToward(String name) {
    return 'إلى $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موقف',
      many: '$count موقفًا',
      few: '$count مواقف',
      two: 'موقفان',
      one: 'موقف واحد',
      zero: 'لا توجد مواقف',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => 'لم يُعثر على مواقف لهذا الخط.';

  @override
  String get stopSchedPrevDay => 'اليوم السابق';

  @override
  String get stopSchedNextDay => 'اليوم التالي';

  @override
  String stopSchedPickDate(String date) {
    return 'اختيار التاريخ، $date';
  }

  @override
  String get stopSchedRoute => 'الخط';

  @override
  String get stopSchedDirection => 'الاتجاه';

  @override
  String get stopSchedStop => 'الموقف';

  @override
  String get stopSchedEmpty => 'لا توجد خدمة مجدولة في هذا اليوم.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'كل $minutes د من $start إلى $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'إلى $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مغادرة',
      many: '$count مغادرة',
      few: '$count مغادرات',
      two: 'مغادرتان',
      one: 'مغادرة واحدة',
      zero: 'لا توجد مغادرات',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported =>
      'الجداول الزمنية غير متاحة في هذه المنطقة.';

  @override
  String get stopSchedViewList => 'قائمة';

  @override
  String get stopSchedViewGrid => 'شبكة';

  @override
  String get stopSchedNoDeparture => 'لا توجد مغادرة';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (موقفك)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop، الرحلة $trip: $time';
  }

  @override
  String get stopReportProblemHeader => 'ما المشكلة؟';

  @override
  String get stopReportStopNameWrong => 'اسم الموقف غير صحيح';

  @override
  String get stopReportStopNumberWrong => 'رقم الموقف غير صحيح';

  @override
  String get stopReportStopLocationWrong => 'الموقف في المكان الخطأ';

  @override
  String get stopReportRouteMissing => 'هناك خط أو رحلة مفقودة';

  @override
  String get stopReportOther => 'شيء آخر';

  @override
  String get stopReportNeverCame => 'لم تصل المركبة أبداً';

  @override
  String get stopReportCameEarly => 'وصلت مبكرة';

  @override
  String get stopReportCameLate => 'وصلت متأخرة';

  @override
  String get stopReportWrongHeadsign => 'وجهة الحافلة المعروضة غير صحيحة';

  @override
  String get stopReportNotStopHere => 'لم تتوقف هنا';

  @override
  String get stopReportComment => 'تعليقات إضافية (اختياري)';

  @override
  String get stopReportShareLocation => 'مشاركة موقعي';

  @override
  String get stopReportShareLocationHelp =>
      'قد تساعد مشاركة موقعك هيئة النقل على إصلاح هذه المشكلة.';

  @override
  String get stopReportOnVehicle => 'أنا على متن هذه المركبة';

  @override
  String get stopReportVehicleId => 'رقم المركبة (اختياري)';

  @override
  String get stopReportSend => 'إرسال البلاغ';

  @override
  String get stopReportSending => 'جارٍ إرسال البلاغ';

  @override
  String get stopReportSent => 'شكراً لك! تم إرسال بلاغك.';

  @override
  String get stopReportFailed => 'تعذّر إرسال البلاغ. حاول مرة أخرى.';

  @override
  String get stopReportChooseProblem => 'اختر مشكلة أولاً.';

  @override
  String stopReportAbout(String name) {
    return 'الإبلاغ عن: $name';
  }

  @override
  String get stopGhostTitle => 'الإبلاغ عن حافلة وهمية';

  @override
  String get stopGhostExplain =>
      'الحافلة الوهمية هي حافلة عرضها التطبيق لكنها لم تصل أبداً.';

  @override
  String get stopGhostWait => 'كم انتظرت بعد الوقت المجدول؟';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30+ د';

  @override
  String get stopCardEmpty => 'لا توجد مغادرات قريبة';

  @override
  String get titleSearch => 'بحث';

  @override
  String get titleSearchResults => 'النتائج';

  @override
  String get titleNearbyStops => 'المواقف القريبة';

  @override
  String get titleRecentStops => 'المواقف الأخيرة';

  @override
  String get titleBookmarks => 'الإشارات المرجعية';

  @override
  String get titleStop => 'الموقف';

  @override
  String get titleTrip => 'الرحلة';

  @override
  String get titleRouteStops => 'الخط';

  @override
  String get titleStopSchedule => 'الجدول';

  @override
  String get titleRouteSchedule => 'جدول الخط';

  @override
  String get titleAlerts => 'التنبيهات';

  @override
  String get titleAlertDetail => 'تنبيه';

  @override
  String get titleAgencies => 'هيئات النقل';

  @override
  String get titleRegionPicker => 'المناطق';

  @override
  String get titleCustomRegion => 'منطقة مخصصة';

  @override
  String get titleSettings => 'الإعدادات';

  @override
  String get titleMapSettings => 'إعدادات الخريطة';

  @override
  String get titleMore => 'المزيد';

  @override
  String get titleTripPlanner => 'تخطيط رحلة';

  @override
  String get titlePlace => 'المكان';

  @override
  String get titleReportStopProblem => 'الإبلاغ عن مشكلة';

  @override
  String get titleReportTripProblem => 'الإبلاغ عن مشكلة';

  @override
  String get titleBookmarkEditor => 'إشارة مرجعية';

  @override
  String get titleManageBookmarks => 'تعديل الإشارات المرجعية';

  @override
  String get titleCredits => 'إشادات';

  @override
  String get titleWeather => 'الطقس';

  @override
  String get titleStopsOnMap => 'المواقف على الخريطة';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'مرحباً بك في $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'أوقات وصول مباشرة للحافلات والقطارات والعبّارات القريبة منك.';

  @override
  String get onboardingLocationTitle => 'اعثر على المواقف القريبة منك';

  @override
  String get onboardingLocationBody =>
      'اسمح بالوصول إلى الموقع لعرض المواقف القريبة واختيار منطقتك تلقائياً.';

  @override
  String get onboardingAllowLocation => 'السماح بالوصول إلى الموقع';

  @override
  String get onboardingRegionTitle => 'اختر منطقتك';

  @override
  String get onboardingRegionBody =>
      'اختر المنطقة التي تريد عرض وسائل النقل فيها.';

  @override
  String get settingsSectionMap => 'الخريطة';

  @override
  String get settingsMapTypeRow => 'نوع الخريطة والطبقات';

  @override
  String get settingsMapTypeHelp => 'اختر مظهر الخريطة.';

  @override
  String get settingsHeadingHelp => 'يعرض الاتجاه الذي تواجهه على الخريطة.';

  @override
  String get settingsWalkingDirections => 'اتجاهات المشي';

  @override
  String get settingsWalkingDirectionsHelp =>
      'التطبيق الذي يُفتح عند طلب اتجاهات المشي إلى موقف.';

  @override
  String get settingsDirectionsAsk => 'اسأل في كل مرة';

  @override
  String get settingsDirectionsAppleMaps => 'Apple Maps';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Maps';

  @override
  String get settingsSectionDepartures => 'المغادرات';

  @override
  String get settingsDepartureFilter => 'إظهار المغادرات';

  @override
  String get settingsDepartureFilterHelp =>
      'اختر ما إذا كانت صفحات المواقف تعرض كل المغادرات أو تلك التي لها بيانات فعلية أو مجدولة فقط.';

  @override
  String get settingsFilterAll => 'كل المغادرات';

  @override
  String get settingsFilterRealtime => 'الوقت الفعلي فقط';

  @override
  String get settingsFilterScheduled => 'المجدولة فقط';

  @override
  String get settingsSectionAccessibility => 'إمكانية الوصول';

  @override
  String get settingsReducedColors => 'تقليل الألوان في صفحات المواقف';

  @override
  String get settingsReducedColorsHelp => 'يعرض شارات الخطوط بنمط محايد واحد.';

  @override
  String get settingsSectionWalking => 'سرعة المشي';

  @override
  String get settingsWalkingSpeed => 'سرعة المشي';

  @override
  String get settingsWalkingSpeedHelp =>
      'تُستخدم لتقدير وقت المشي وأوقات الوصول.';

  @override
  String get settingsSpeedSlow => 'بطيئة';

  @override
  String get settingsSpeedAverage => 'متوسطة';

  @override
  String get settingsSpeedFast => 'سريعة';

  @override
  String settingsSpeedCustom(String speed) {
    return 'مخصصة ($speed م/ث)';
  }

  @override
  String get settingsSectionBike => 'وضع الدراجة';

  @override
  String get settingsBikeMode => 'وضع الدراجة';

  @override
  String get settingsBikeModeHelp =>
      'يستخدم سرعة سفر أعلى لتقدير وقت المشي وأوقات الوصول وصفحة الموقف.';

  @override
  String get settingsSectionSurveys => 'الاستطلاعات';

  @override
  String get settingsSurveysEnabled => 'إظهار الاستطلاعات';

  @override
  String get settingsSurveysAlways => 'إظهار الاستطلاعات دائماً في المواقف';

  @override
  String get settingsSectionPrivacy => 'الخصوصية';

  @override
  String get settingsAnalytics => 'إرسال بيانات الاستخدام إلى المطورين';

  @override
  String get settingsAnalyticsHelp =>
      'يساعد المطورين على معرفة الميزات المستخدمة.';

  @override
  String get settingsSectionDebug => 'تصحيح الأخطاء';

  @override
  String get settingsDebugMode => 'وضع تصحيح الأخطاء';

  @override
  String get settingsDebugAlwaysFeedback => 'إظهار طلب التقييم دائماً';

  @override
  String get settingsDebugResetFeedback => 'إعادة ضبط حالة طلب التقييم';

  @override
  String get settingsDebugResetDonation => 'إعادة ضبط حالة بطاقة التبرع';

  @override
  String get settingsDebugResetDone => 'تمت إعادة الضبط';

  @override
  String get settingsSectionTripPlanner => 'مخطط الرحلات';

  @override
  String get settingsHomeCustomizeMap => 'تخصيص الخريطة';

  @override
  String get moreHeaderSupport =>
      'هذا التطبيق من تطوير متطوعين ويدعمه متطوعون.';

  @override
  String get moreSectionDonate => 'كن داعماً';

  @override
  String moreDonate(String appName) {
    return 'تبرّع لـ $appName';
  }

  @override
  String get moreManageDonations => 'إدارة التبرعات';

  @override
  String get moreSectionUpdates => 'التحديثات والتنبيهات';

  @override
  String get moreAlerts => 'التنبيهات';

  @override
  String get moreSectionLocation => 'موقعي';

  @override
  String get moreRegion => 'المنطقة';

  @override
  String get moreRegionNone => 'غير محددة';

  @override
  String get morePayFare => 'دفع أجرتي';

  @override
  String get moreAgencies => 'هيئات النقل';

  @override
  String get moreSectionAbout => 'حول هذا التطبيق';

  @override
  String moreRateApp(String appName) {
    return 'قيّم $appName';
  }

  @override
  String get moreContactUs => 'اتصل بنا';

  @override
  String get morePrivacy => 'سياسة الخصوصية';

  @override
  String get moreCredits => 'إشادات';

  @override
  String moreVersion(String appName, String version) {
    return '$appName الإصدار $version';
  }

  @override
  String get moreSectionHelpOut => 'ساعد في تحسين التطبيق';

  @override
  String get moreTranslate => 'ساعد في ترجمة التطبيق';

  @override
  String get moreDevelop => 'ساعد في إصلاح الأخطاء وبناء ميزات جديدة';

  @override
  String get moreSectionContact => 'التواصل والمساعدة';

  @override
  String get moreTutorials => 'الدروس التعليمية';

  @override
  String get moreCallAgency => 'اتصل بهيئة النقل';

  @override
  String get moreTextAgency => 'راسل هيئة النقل';

  @override
  String get moreSectionResources => 'الموارد';

  @override
  String get moreContactTitle => 'اتصل بنا';

  @override
  String get moreContactDevelopers => 'طلب ميزة أو الإبلاغ عن خطأ';

  @override
  String get moreContactAgency => 'مشكلة في مركبة أو جدول';

  @override
  String moreEmailSubject(String appName) {
    return 'ملاحظات حول $appName';
  }

  @override
  String get moreEmailAgencySubject => 'ملاحظات من راكب';

  @override
  String get moreEmailIntro => 'كيف يمكننا مساعدتك؟ يرجى كتابة ردك أدناه:';

  @override
  String get moreEmailDebugIntro =>
      'المعلومات التالية مقدَّمة لأغراض استكشاف الأخطاء وإصلاحها. إذا لم تكن مرتاحاً لمشاركة أي منها فيمكنك حذفه، لكن ذلك قد يؤثر على قدرتنا على مساعدتك.';

  @override
  String get moreDebugAppVersion => 'إصدار التطبيق';

  @override
  String get moreDebugOs => 'نظام التشغيل';

  @override
  String get moreDebugLocale => 'اللغة';

  @override
  String get moreDebugBookmarks => 'عدد الإشارات المرجعية';

  @override
  String get moreDebugLocationPermission => 'إذن الموقع';

  @override
  String get moreDebugRegion => 'المنطقة';

  @override
  String get moreDebugRegionId => 'معرّف المنطقة';

  @override
  String get moreDebugApiUrl => 'عنوان API الأساسي';

  @override
  String get moreDebugUserId => 'معرّف المستخدم';

  @override
  String get moreCantEmailTitle => 'تعذّر فتح تطبيق البريد';

  @override
  String moreCantEmailBody(String email) {
    return 'للتواصل معنا، أرسل رسالة إلى $email. انسخ معلومات تصحيح الأخطاء والصقها في رسالتك لمساعدتنا على إصلاح المشكلة.';
  }

  @override
  String get moreCopyEmail => 'نسخ البريد الإلكتروني';

  @override
  String get moreCopyDebug => 'نسخ معلومات تصحيح الأخطاء';

  @override
  String get moreCopied => 'تم النسخ إلى الحافظة';

  @override
  String get moreFareContinue => 'متابعة';

  @override
  String get moreFareDontShowAgain => 'متابعة وعدم الإظهار مرة أخرى';

  @override
  String get commonCantOpenLink => 'تعذّر فتح هذا الرابط.';

  @override
  String get regionPickerAutomatic => 'اختيار المنطقة تلقائياً';

  @override
  String get regionPickerAutomaticHelp =>
      'ينتقل إلى المنطقة التي تضم موقعك. اختيارك للمنطقة بنفسك يوقف هذا الخيار.';

  @override
  String get regionPickerShowExperimental => 'إظهار المناطق التجريبية';

  @override
  String get regionPickerShowInactive => 'إظهار المناطق غير النشطة';

  @override
  String get regionPickerRegionsSection => 'المناطق';

  @override
  String get regionPickerCustomSection => 'المناطق المخصصة';

  @override
  String get regionPickerCurrent => 'المنطقة الحالية';

  @override
  String get regionPickerExperimentalTag => 'تجريبية';

  @override
  String get regionPickerInactiveTag => 'غير نشطة';

  @override
  String get regionPickerCustomTag => 'مخصصة';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name، $details';
  }

  @override
  String get regionPickerAdd => 'إضافة منطقة مخصصة';

  @override
  String get regionPickerRefresh => 'تحديث المناطق';

  @override
  String get regionPickerRefreshed => 'تم تحديث المناطق';

  @override
  String get regionPickerRefreshFailed =>
      'تعذّر تحديث قائمة المناطق. تُعرض القائمة المحفوظة.';

  @override
  String regionPickerSelected(String name) {
    return 'تم اختيار $name';
  }

  @override
  String regionPickerEdit(String name) {
    return 'تعديل $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'حذف $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'حذف $name؟';
  }

  @override
  String get regionPickerDeleteBody =>
      'ستُزال هذه المنطقة المخصصة من هذا الجهاز.';

  @override
  String get regionPickerDeleteConfirm => 'حذف';

  @override
  String get regionPickerCantDeleteCurrent =>
      'اختر منطقة أخرى قبل حذف هذه المنطقة.';

  @override
  String get regionPickerEmpty => 'لا توجد مناطق متاحة';

  @override
  String get regionPickerEmptyBody =>
      'فعّل المناطق التجريبية أو غير النشطة، أو أضف منطقة مخصصة.';

  @override
  String get regionPickerTripPlanner => 'مخطط الرحلات في هذه المنطقة';

  @override
  String get customRegionEditTitle => 'تعديل المنطقة المخصصة';

  @override
  String get customRegionName => 'الاسم';

  @override
  String get customRegionObaUrl => 'عنوان خادم OneBusAway';

  @override
  String get customRegionObaUrlHelp =>
      'عنوان الخادم، مثل https://oba.example.com/';

  @override
  String get customRegionSidecar => 'عنوان خادم Sidecar (اختياري)';

  @override
  String get customRegionOtp => 'عنوان مخطط الرحلات (اختياري)';

  @override
  String get customRegionOtpGraphql => 'عنوان GraphQL لمخطط الرحلات (اختياري)';

  @override
  String get customRegionServiceArea => 'منطقة الخدمة';

  @override
  String get customRegionServiceAreaHelp =>
      'المساحة التي تغطيها هذه المنطقة: نقطة مركزية ومدى امتدادها.';

  @override
  String get customRegionLatitude => 'خط عرض المركز';

  @override
  String get customRegionLongitude => 'خط طول المركز';

  @override
  String get customRegionLatSpan => 'امتداد خط العرض (درجات)';

  @override
  String get customRegionLonSpan => 'امتداد خط الطول (درجات)';

  @override
  String get customRegionUseMap => 'استخدام منطقة الخريطة الحالية';

  @override
  String get customRegionSave => 'حفظ';

  @override
  String get customRegionErrorRequired => 'هذا الحقل مطلوب';

  @override
  String get customRegionErrorUrl =>
      'أدخل عنوان ويب يبدأ بـ http:// أو https://';

  @override
  String get customRegionErrorNumber => 'أدخل رقماً';

  @override
  String get customRegionErrorRange => 'هذا الرقم خارج النطاق';

  @override
  String get customRegionChecking => 'جارٍ فحص الخادم';

  @override
  String get customRegionServerOk => 'استجاب الخادم';

  @override
  String get customRegionServerUnreachable => 'تعذّر الوصول إلى هذا الخادم';

  @override
  String get customRegionServerNotOba =>
      'لم يستجب هذا الخادم كما يستجيب OneBusAway';

  @override
  String customRegionSaved(String name) {
    return 'تم حفظ $name';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway برنامج نقل عام مجاني ومفتوح المصدر، طوّره متطوعون وتدعمه Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'الترخيص';

  @override
  String get creditsMapData => 'بيانات الخريطة';

  @override
  String get creditsLicenses => 'تراخيص المصادر المفتوحة';

  @override
  String get creditsLicensesHelp => 'المكتبات التي بُني عليها هذا التطبيق.';

  @override
  String get creditsLicensesLoading => 'جارٍ تحميل التراخيص';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ترخيص',
      many: '$count ترخيصًا',
      few: '$count تراخيص',
      two: 'ترخيصان',
      one: 'ترخيص واحد',
      zero: 'لا توجد تراخيص',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'متوفر في عشرات مناطق النقل حول العالم.';

  @override
  String get onboardingBenefitNearbyTitle => 'اعرض المواقف القريبة';

  @override
  String get onboardingBenefitNearbyBody =>
      'الحافلات والقطارات من حولك، مرتبة حسب المسافة.';

  @override
  String get onboardingBenefitMapTitle => 'وسّط الخريطة على موقعك';

  @override
  String get onboardingBenefitMapBody =>
      'افتح التطبيق مباشرة على محيطك دون الحاجة إلى البحث.';

  @override
  String onboardingLocationFootnote(String appName) {
    return 'يستخدم $appName موقعك فقط أثناء فتح التطبيق. يمكنك تغيير ذلك في أي وقت من إعدادات جهازك.';
  }

  @override
  String get onboardingLocationDenied =>
      'الوصول إلى الموقع معطل. لا يزال بإمكانك اختيار منطقتك بنفسك.';

  @override
  String get onboardingRegionDetected => 'تم رصدها بالقرب منك';

  @override
  String onboardingRegionUse(String name) {
    return 'استخدام $name';
  }

  @override
  String get onboardingRegionOthers => 'أو اختر منطقة أخرى';

  @override
  String get onboardingRegionEmpty =>
      'لا توجد مناطق متاحة حالياً. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get surveyCardTitle => 'ساعد في تحسين النقل العام';

  @override
  String get surveyDefaultPrompt =>
      'أجب عن استطلاع قصير للمساعدة في تحسين النقل العام.';

  @override
  String get surveyTake => 'المشاركة في الاستطلاع';

  @override
  String get surveyNotNow => 'ليس الآن';

  @override
  String get surveyDismiss => 'تجاهل الاستطلاع';

  @override
  String get surveyNext => 'التالي';

  @override
  String get surveySubmit => 'إرسال الاستطلاع';

  @override
  String get surveySubmitting => 'جارٍ الإرسال';

  @override
  String get surveyQuestionsTitle => 'استطلاع';

  @override
  String get surveyTextHint => 'أدخل إجابتك';

  @override
  String get surveyRequired => 'مطلوب';

  @override
  String get surveyIncomplete =>
      'يرجى الإجابة عن جميع الأسئلة المطلوبة قبل الإرسال.';

  @override
  String get surveyFailed => 'تعذّر إرسال إجاباتك. حاول مرة أخرى.';

  @override
  String get surveyThanks => 'شكراً لملاحظاتك.';

  @override
  String get surveyOpenSurvey => 'فتح الاستطلاع';

  @override
  String get surveyLearnMore => 'اعرف المزيد';

  @override
  String get surveyShareFeedback => 'شارك ملاحظاتك';

  @override
  String get surveySignUp => 'التسجيل';

  @override
  String get surveyExternalError =>
      'تعذّر فتح رابط هذا الاستطلاع. حاول مرة أخرى لاحقاً.';

  @override
  String donationTitle(String appName) {
    return '$appName يحتاج إلى مساعدتك';
  }

  @override
  String get donationBody =>
      'بُني هذا التطبيق بجهود المتطوعين، ونحتاج إلى مساعدتك لتمويل التطوير مستقبلاً.';

  @override
  String get donationLearnMore => 'اعرف المزيد';

  @override
  String get donationDonate => 'تبرّع الآن';

  @override
  String get donationRemindLater => 'ذكّرني لاحقاً';

  @override
  String get donationDismiss => 'لا، شكراً';

  @override
  String get donationHeader => 'لماذا نحتاج إلى مساعدتك';

  @override
  String donationExplanation(String appName) {
    return 'لدينا خطط كبيرة لتحسين $appName، لكن لا يمكننا تنفيذها دون مساعدتك. بُني هذا التطبيق بجهود المتطوعين، ونحتاج إلى مساعدتك لتمويل التطوير مستقبلاً.\n\nبصفته مشروعاً رئيسياً لدى Open Transit Software Foundation، وهي منظمة غير ربحية، فإن تبرعك معفى من الضرائب في الولايات المتحدة.';
  }

  @override
  String get donationDonateWebsite => 'تبرّع عبر موقعنا';

  @override
  String titleDonation(String appName) {
    return 'ادعم $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'هل يعجبك $appName؟';
  }

  @override
  String get feedbackYes => 'نعم!';

  @override
  String get feedbackNo => 'ليس تماماً';

  @override
  String get feedbackLater => 'اسألني لاحقاً';

  @override
  String get feedbackNegativeTitle => 'نأسف لذلك.';

  @override
  String get feedbackNegativeBody => 'هل تخبرنا بما حدث؟ نقرأ كل رسالة.';

  @override
  String get feedbackSend => 'إرسال الملاحظات';

  @override
  String get feedbackDecline => 'لا، شكراً';

  @override
  String get tripPlanningUnavailable =>
      'تخطيط الرحلات غير متاح في هذه المنطقة.';

  @override
  String get deepLinkOtherRegion =>
      'هذا الرابط لمنطقة أخرى. بدّل المنطقة لفتحه.';

  @override
  String get dataUpdated => 'تم التحديث';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'الخط $route إلى $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'الخط $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route، $eta، $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'جارٍ تحميل المغادرات';

  @override
  String get bookmarksNoDepartures => 'لا توجد مغادرات قادمة';

  @override
  String get bookmarksDeparturesError => 'تعذّر تحميل المغادرات';

  @override
  String get bookmarksDeparturesStale =>
      'تعذّر التحديث. تُعرض الأوقات السابقة.';

  @override
  String get bookmarksUpdated => 'تم تحديث المغادرات';

  @override
  String get bookmarksSortTooltip => 'ترتيب الإشارات المرجعية';

  @override
  String get bookmarksSortByGroup => 'الترتيب حسب المجموعة';

  @override
  String get bookmarksSortByDistance => 'الترتيب حسب المسافة';

  @override
  String get bookmarksManageTooltip => 'تعديل الإشارات المرجعية والمجموعات';

  @override
  String get bookmarksRefreshTooltip => 'تحديث المغادرات';

  @override
  String get bookmarksEmptyTitle => 'لا توجد إشارات مرجعية بعد';

  @override
  String get bookmarksEmptyBody =>
      'افتح موقفاً وانقر زر الإشارة المرجعية لحفظه هنا. ومن أي مغادرة يمكنك أيضاً حفظ ذلك الخط فقط عند الموقف.';

  @override
  String get bookmarksFindStops => 'ابحث عن مواقف على الخريطة';

  @override
  String get bookmarksUngrouped => 'بدون مجموعة';

  @override
  String get bookmarksGroupExpanded => 'موسّعة';

  @override
  String get bookmarksGroupCollapsed => 'مطوية';

  @override
  String get bookmarksGroupToggleHint =>
      'يعرض الإشارات المرجعية في هذه المجموعة أو يخفيها';

  @override
  String bookmarksActionsFor(String name) {
    return 'إجراءات $name';
  }

  @override
  String get bookmarksActionEdit => 'تعديل';

  @override
  String get bookmarksActionPin => 'تثبيت في الأعلى';

  @override
  String get bookmarksActionUnpin => 'إلغاء التثبيت';

  @override
  String get bookmarksActionMove => 'نقل إلى مجموعة';

  @override
  String get bookmarksActionDelete => 'حذف';

  @override
  String get bookmarksPinned => 'مثبّتة';

  @override
  String bookmarksDeleted(String name) {
    return 'تم حذف $name';
  }

  @override
  String get bookmarksUndo => 'تراجع';

  @override
  String get bookmarksMoveTitle => 'نقل إلى مجموعة';

  @override
  String get bookmarksNoGroup => 'بدون مجموعة';

  @override
  String bookmarksMoved(String group) {
    return 'تم النقل إلى $group';
  }

  @override
  String get bookmarksEditorNameLabel => 'اسم الإشارة المرجعية';

  @override
  String get bookmarksEditorNameRequired => 'أدخل اسماً لهذه الإشارة المرجعية.';

  @override
  String get bookmarksEditorDuplicate =>
      'لديك بالفعل إشارة مرجعية بهذا الاسم لهذا الموقف والخط. غيّر الاسم لحفظ أخرى.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'إشارة مرجعية لموقف: تعرض المغادرات القادمة لكل الخطوط عند $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'إشارة مرجعية لرحلة: تعرض المغادرات القادمة للخط $route عند $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'الخط $route فقط';
  }

  @override
  String get bookmarksEditorGroup => 'المجموعة';

  @override
  String get bookmarksEditorNewGroup => 'مجموعة جديدة…';

  @override
  String get bookmarksEditorNewGroupTitle => 'مجموعة جديدة';

  @override
  String get bookmarksEditorGroupName => 'اسم المجموعة';

  @override
  String get bookmarksEditorSave => 'حفظ';

  @override
  String get bookmarksEditorSaved => 'تم حفظ الإشارة المرجعية';

  @override
  String get bookmarksEditorDelete => 'حذف الإشارة المرجعية';

  @override
  String get bookmarksEditorDeleteTitle => 'حذف هذه الإشارة المرجعية؟';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return 'ستُزال «$name» من إشاراتك المرجعية.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'اختر منطقة قبل إضافة الإشارات المرجعية.';

  @override
  String get bookmarksManageGroupsHeader => 'المجموعات';

  @override
  String get bookmarksManageAddGroup => 'إضافة مجموعة';

  @override
  String get bookmarksManageRenameGroup => 'إعادة تسمية المجموعة';

  @override
  String get bookmarksManageDeleteGroup => 'حذف المجموعة';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'ستصبح الإشارات المرجعية في «$name» بدون مجموعة.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'نقل $name لأعلى';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'نقل $name لأسفل';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'إعادة ترتيب $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name، الموضع $position من $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'لا توجد إشارات مرجعية أو مجموعات لإدارتها بعد.';

  @override
  String get bookmarksManageUngrouped => 'إشارات مرجعية بدون مجموعة';

  @override
  String get recentsEmptyTitle => 'لا توجد مواقف أخيرة';

  @override
  String get recentsEmptyBody =>
      'تظهر هنا المواقف التي تطّلع عليها، الأحدث أولاً.';

  @override
  String get recentsFindStops => 'ابحث عن مواقف على الخريطة';

  @override
  String get recentsClearAll => 'مسح الكل';

  @override
  String get recentsClearTitle => 'مسح المواقف الأخيرة؟';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'سيؤدي هذا إلى إزالة جميع المواقف الأخيرة وعددها $count. لن تتأثر إشاراتك المرجعية.',
      many:
          'سيؤدي هذا إلى إزالة جميع المواقف الأخيرة وعددها $count. لن تتأثر إشاراتك المرجعية.',
      few:
          'سيؤدي هذا إلى إزالة جميع المواقف الأخيرة وعددها $count. لن تتأثر إشاراتك المرجعية.',
      two: 'سيؤدي هذا إلى إزالة الموقفين الأخيرين. لن تتأثر إشاراتك المرجعية.',
      one: 'سيؤدي هذا إلى إزالة موقف أخير واحد. لن تتأثر إشاراتك المرجعية.',
      zero: 'لا توجد مواقف أخيرة لإزالتها. لن تتأثر إشاراتك المرجعية.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'إزالة $name من المواقف الأخيرة';
  }

  @override
  String recentsRemoved(String name) {
    return 'تمت إزالة $name';
  }

  @override
  String get recentsSectionEmpty => 'تظهر هنا المواقف التي تطّلع عليها.';

  @override
  String get alarmsSectionTitle => 'التذكيرات';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'قبل $minutes دقيقة من المغادرة، في الساعة $time',
      many: 'قبل $minutes دقيقة من المغادرة، في الساعة $time',
      few: 'قبل $minutes دقائق من المغادرة، في الساعة $time',
      two: 'قبل دقيقتين من المغادرة، في الساعة $time',
      one: 'قبل دقيقة واحدة من المغادرة، في الساعة $time',
      zero: 'عند المغادرة، في الساعة $time',
    );
    return '$_temp0';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'تذكير لـ $title، $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'حذف التذكير الخاص بـ $title';
  }

  @override
  String get alarmsDeleted => 'تم حذف التذكير';

  @override
  String get alarmsDeleteFailed =>
      'تعذّر حذف التذكير. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get alertsEmptyTitle => 'لا توجد تنبيهات خدمة';

  @override
  String get alertsEmptyBody => 'لا توجد تنبيهات خدمة نشطة حالياً.';

  @override
  String get alertsRegionNote =>
      'تشمل تنبيهات المواقف التي أضفتها إلى الإشارات المرجعية والأخيرة والقريبة.';

  @override
  String get alertsMarkAllRead => 'تحديد الكل كمقروء';

  @override
  String get alertsAllRead => 'تم تحديد كل التنبيهات كمقروءة';

  @override
  String get alertsUnread => 'غير مقروء';

  @override
  String get alertsSeverityInfo => 'معلومات';

  @override
  String get alertsSeverityWarning => 'تحذير';

  @override
  String get alertsSeveritySevere => 'شديد';

  @override
  String get alertsSeverityUnknown => 'تنبيه خدمة';

  @override
  String get alertsNoTitle => 'تنبيه خدمة';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'غير مقروء. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تنبيه غير مقروء',
      many: '$count تنبيهًا غير مقروء',
      few: '$count تنبيهات غير مقروءة',
      two: 'تنبيهان غير مقروءين',
      one: 'تنبيه واحد غير مقروء',
      zero: 'لا توجد تنبيهات غير مقروءة',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تنبيه آخر',
      many: '$count تنبيهًا آخر',
      few: '$count تنبيهات أخرى',
      two: 'تنبيهان آخران',
      one: 'تنبيه آخر واحد',
      zero: 'لا توجد تنبيهات أخرى',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'فترة السريان';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start إلى $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'من $start';
  }

  @override
  String get alertsDetailAffects => 'يؤثر على';

  @override
  String get alertsDetailRoutes => 'الخطوط';

  @override
  String get alertsDetailStops => 'المواقف';

  @override
  String get alertsDetailLearnMore => 'اعرف المزيد';

  @override
  String get alertsDetailNoDetails => 'لا توجد تفاصيل إضافية.';

  @override
  String alertsDetailUpdated(String date) {
    return 'صدر في $date';
  }

  @override
  String get agenciesEmptyTitle => 'لا توجد هيئات نقل';

  @override
  String get agenciesEmptyBody => 'لم تُدرج هذه المنطقة أي هيئة نقل.';

  @override
  String get agenciesWebsite => 'الموقع الإلكتروني';

  @override
  String agenciesPhone(String phone) {
    return 'اتصل بالرقم $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'راسل $email';
  }

  @override
  String get agenciesFares => 'معلومات الأجرة';

  @override
  String get agenciesDisclaimer => 'إخلاء المسؤولية';

  @override
  String get agenciesShowOnMap => 'إظهار التغطية على الخريطة';

  @override
  String get searchFieldLabel => 'بحث';

  @override
  String get searchFieldHint => 'خط أو رقم موقف أو عنوان أو مركبة';

  @override
  String get searchClear => 'مسح البحث';

  @override
  String get searchScopeLabel => 'البحث عن';

  @override
  String get searchScopeAll => 'الكل';

  @override
  String get searchScopeStops => 'المواقف';

  @override
  String get searchScopeRoutes => 'الخطوط';

  @override
  String get searchScopePlaces => 'الأماكن';

  @override
  String get searchQuickHeader => 'البحث عن';

  @override
  String searchQuickRoute(String query) {
    return 'الخط: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'رقم الموقف: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'العنوان: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'المركبة: $query';
  }

  @override
  String get searchRecentStopsHeader => 'المواقف الأخيرة';

  @override
  String get searchBookmarksHeader => 'الإشارات المرجعية';

  @override
  String get searchRecentSearchesHeader => 'عمليات البحث الأخيرة';

  @override
  String get searchRecentPlacesHeader => 'الأماكن الأخيرة';

  @override
  String get searchPlacesHeader => 'الأماكن';

  @override
  String get searchClearRecent => 'مسح عمليات البحث الأخيرة';

  @override
  String get searchClearRecentConfirm =>
      'هل تريد مسح عمليات البحث والأماكن الأخيرة؟';

  @override
  String get searchClearAction => 'مسح';

  @override
  String get searchRecentCleared => 'تم مسح عمليات البحث الأخيرة';

  @override
  String get searchPlacesLoading => 'جارٍ البحث عن الأماكن';

  @override
  String get searchPlacesNone => 'لم يُعثر على أماكن';

  @override
  String get searchPlacesError => 'تعذّر البحث عن الأماكن. تحقق من اتصالك.';

  @override
  String get searchSearching => 'جارٍ البحث';

  @override
  String get searchNoResultsTitle => 'لا توجد نتائج';

  @override
  String searchNoResultsBody(String query) {
    return 'لم يُعثر على نتائج بحث عن «$query».';
  }

  @override
  String get searchUnavailableNoRegion => 'اختر منطقة قبل البحث.';

  @override
  String get searchUnavailableAddress =>
      'البحث عن العناوين غير مُعدّ في هذا التطبيق.';

  @override
  String get searchUnavailableVehicle =>
      'البحث عن المركبات غير متاح في هذه المنطقة.';

  @override
  String get searchEmptyTitle => 'ابحث عن خطوط ومواقف وأماكن';

  @override
  String get searchEmptyBody =>
      'اكتب اسم خط أو رقم موقف أو عنواناً أو معرّف مركبة.';

  @override
  String get searchDismissMessage => 'إغلاق';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نتيجة لـ «$query»',
      many: '$count نتيجة لـ «$query»',
      few: '$count نتائج لـ «$query»',
      two: 'نتيجتان لـ «$query»',
      one: 'نتيجة واحدة لـ «$query»',
      zero: 'لا توجد نتائج لـ «$query»',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'الخطوط';

  @override
  String get searchResultsStops => 'المواقف';

  @override
  String get searchResultsVehicles => 'المركبات';

  @override
  String get searchResultsPlaces => 'الأماكن';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'الخط $name، $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'المركبة $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'المركبة $id لا تخدم رحلة حالياً.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'جارٍ تحميل المركبة $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'فعّل الموقع لعرض المغادرات من المواقف القريبة منك.';

  @override
  String get searchNearbyLocationButton => 'استخدام موقعي';

  @override
  String get searchNearbyLocationDenied =>
      'الوصول إلى الموقع معطل. فعّله من إعدادات جهازك لعرض المواقف القريبة منك.';

  @override
  String get searchNearbyLocationServicesOff =>
      'خدمات الموقع معطلة. فعّلها لعرض المواقف القريبة منك.';

  @override
  String get searchNearbyLocationUnavailable =>
      'لا يستخدم هذا التطبيق موقعك، لذا لا يمكنه عرض المواقف القريبة منك.';

  @override
  String get searchNearbyEmpty => 'لا توجد مواقف قريبة';

  @override
  String get searchNearbyEmptyBody =>
      'لا توجد مواقف على مسافة يمكن المشي إليها.';

  @override
  String get searchNearbyMapCenter => 'تُعرض المواقف القريبة من وسط الخريطة.';

  @override
  String get searchNearbyNoDepartures => 'لا توجد مغادرات خلال الساعة القادمة';

  @override
  String get searchNearbyLoadingDepartures => 'جارٍ تحميل المغادرات';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موقف قريب',
      many: '$count موقفًا قريبًا',
      few: '$count مواقف قريبة',
      two: 'موقفان قريبان',
      one: 'موقف واحد قريب',
      zero: 'لا توجد مواقف قريبة',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'جارٍ تحديد موقعك…';

  @override
  String get searchNearbyRefresh => 'تحديث';

  @override
  String searchNearbyDistance(String distance) {
    return 'على بعد $distance';
  }

  @override
  String get searchNearbyOtherDirection => 'مواقف أخرى';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return 'مواقف $direction';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route إلى $headsign، $eta، $status. من $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'من $stop';
  }

  @override
  String get searchNearbyCardTitle => 'مغادرات بالقرب منك';

  @override
  String get searchExplorePlanTrip => 'تخطيط رحلة';

  @override
  String get searchExploreWeather => 'الطقس';

  @override
  String get searchExploreAgencies => 'هيئات النقل';

  @override
  String get searchPlaceAddress => 'العنوان';

  @override
  String get searchPlaceCoordinates => 'الإحداثيات';

  @override
  String get searchPlaceDistance => 'المسافة';

  @override
  String get searchPlaceDirectionsTo => 'الاتجاهات إلى هنا';

  @override
  String get searchPlaceDirectionsFrom => 'الاتجاهات من هنا';

  @override
  String get searchPlaceNearbyStops => 'المواقف القريبة';

  @override
  String get searchPlaceShare => 'مشاركة';

  @override
  String get searchPlaceOpenInMaps => 'فتح في تطبيق الخرائط';

  @override
  String get searchPlaceRemovePin => 'إزالة الدبوس';

  @override
  String get searchPlaceOpenFailed => 'تعذّر فتح تطبيق خرائط.';

  @override
  String get searchPlaceShareFailed => 'تعذّرت مشاركة هذا المكان.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'المكان: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'الطقس: $temperature، $condition';
  }

  @override
  String get searchWeatherButtonHint => 'يعرض التوقعات';

  @override
  String get searchWeatherClear => 'صافٍ';

  @override
  String get searchWeatherPartlyCloudy => 'غائم جزئياً';

  @override
  String get searchWeatherCloudy => 'غائم';

  @override
  String get searchWeatherRain => 'مطر';

  @override
  String get searchWeatherSleet => 'مطر متجمد';

  @override
  String get searchWeatherSnow => 'ثلج';

  @override
  String get searchWeatherWindy => 'رياح';

  @override
  String get searchWeatherFog => 'ضباب';

  @override
  String get searchWeatherUnknown => 'أحوال غير معروفة';

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
      other: '$value درجة فهرنهايت',
      many: '$value درجة فهرنهايت',
      few: '$value درجات فهرنهايت',
      two: 'درجتان فهرنهايت',
      one: 'درجة فهرنهايت واحدة',
      zero: 'صفر درجة فهرنهايت',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value درجة مئوية',
      many: '$value درجة مئوية',
      few: '$value درجات مئوية',
      two: 'درجتان مئويتان',
      one: 'درجة مئوية واحدة',
      zero: 'صفر درجة مئوية',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherMph(int value) {
    return '$value ميل/س';
  }

  @override
  String searchWeatherKmh(int value) {
    return '$value كم/س';
  }

  @override
  String searchWeatherMps(int value) {
    return '$value م/ث';
  }

  @override
  String searchWeatherPercent(int value) {
    return '$value%';
  }

  @override
  String get searchWeatherFeelsLike => 'الإحساس الفعلي';

  @override
  String get searchWeatherWind => 'الرياح';

  @override
  String get searchWeatherPrecip => 'احتمال المطر';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'العظمى $high · الصغرى $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'العظمى $high، والصغرى $low، خلال الأربع والعشرين ساعة القادمة';
  }

  @override
  String get searchWeatherHourly => 'الـ 24 ساعة القادمة';

  @override
  String get searchWeatherNow => 'الآن';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature، $condition، احتمال المطر $precip';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'درجات الحرارة بـ$unit';
  }

  @override
  String get searchWeatherFahrenheit => 'درجة فهرنهايت (°F)';

  @override
  String get searchWeatherCelsius => 'درجة مئوية (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'التوقعات من $time';
  }

  @override
  String get searchWeatherUnavailable => 'الطقس غير متاح لهذه المنطقة.';

  @override
  String get searchWeatherSummaryLabel => 'اليوم';

  @override
  String get bookmarksSectionEmpty =>
      'تظهر هنا المواقف المضافة إلى الإشارات المرجعية.';

  @override
  String get coreDirectionBoundN => 'متجه شمالاً';

  @override
  String get coreDirectionBoundNE => 'متجه شمالاً شرقياً';

  @override
  String get coreDirectionBoundE => 'متجه شرقاً';

  @override
  String get coreDirectionBoundSE => 'متجه جنوباً شرقياً';

  @override
  String get coreDirectionBoundS => 'متجه جنوباً';

  @override
  String get coreDirectionBoundSW => 'متجه جنوباً غربياً';

  @override
  String get coreDirectionBoundW => 'متجه غرباً';

  @override
  String get coreDirectionBoundNW => 'متجه شمالاً غربياً';

  @override
  String coreStopCodeNumeric(String code) {
    return 'الموقف رقم $code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'الموقف: \'$code\'';
  }

  @override
  String get coreJustNow => 'الآن تواً';

  @override
  String coreSecondsAgo(int seconds) {
    return 'قبل $seconds ث';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return 'قبل $minutes د';
  }

  @override
  String coreHoursAgo(int hours) {
    return 'قبل $hours س';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'قبل $days يوم',
      many: 'قبل $days يومًا',
      few: 'قبل $days أيام',
      two: 'قبل يومين',
      one: 'قبل يوم واحد',
      zero: 'اليوم',
    );
    return '$_temp0';
  }

  @override
  String coreMeters(String value) {
    return '$value م';
  }

  @override
  String coreKilometers(String value) {
    return '$value كم';
  }

  @override
  String coreFeet(String value) {
    return '$value قدم';
  }

  @override
  String coreMiles(String value) {
    return '$value ميل';
  }

  @override
  String get arrivalsNow => 'الآن';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutesد';
  }

  @override
  String get arrivalsCanceled => 'ملغاة';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'كل $minutes د من $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'كل $minutes د حتى $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'متجه شمالاً';

  @override
  String get arrivalsDirectionBoundNE => 'متجه شمالاً شرقياً';

  @override
  String get arrivalsDirectionBoundE => 'متجه شرقاً';

  @override
  String get arrivalsDirectionBoundSE => 'متجه جنوباً شرقياً';

  @override
  String get arrivalsDirectionBoundS => 'متجه جنوباً';

  @override
  String get arrivalsDirectionBoundSW => 'متجه جنوباً غربياً';

  @override
  String get arrivalsDirectionBoundW => 'متجه غرباً';

  @override
  String get arrivalsDirectionBoundNW => 'متجه شمالاً غربياً';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'متجه $code';
  }

  @override
  String get arrivalsRefresh => 'تحديث مواعيد الوصول';

  @override
  String get arrivalsRetry => 'إعادة المحاولة';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'لا توجد وصولات خلال الدقائق الـ $minutes القادمة',
      many: 'لا توجد وصولات خلال الدقائق الـ $minutes القادمة',
      few: 'لا توجد وصولات خلال الدقائق الـ $minutes القادمة',
      two: 'لا توجد وصولات خلال الدقائق الـ $minutes القادمة',
      one: 'لا توجد وصولات خلال الدقائق الـ $minutes القادمة',
      zero: 'لا توجد وصولات خلال الدقائق الـ $minutes القادمة',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound => 'لم يُعثر على الموقف أو الخدمة غير متاحة';

  @override
  String get arrivalsNetworkError =>
      'تعذّر الوصول إلى خادم النقل. تحقق من اتصالك.';

  @override
  String get arrivalsLoadError => 'تعذّر تحميل مواعيد الوصول.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'تعذّر التحديث. تُعرض نتائج $time';
  }

  @override
  String get arrivalsArrivingNow => 'تصل الآن';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'تصل خلال $minutes دقيقة',
      many: 'تصل خلال $minutes دقيقة',
      few: 'تصل خلال $minutes دقائق',
      two: 'تصل خلال دقيقتين',
      one: 'تصل خلال دقيقة واحدة',
      zero: 'تصل الآن',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'في الوقت الفعلي';

  @override
  String get arrivalsRowTapHint => 'عرض التفاصيل';

  @override
  String arrivalsAtTime(String time) {
    return 'في الساعة $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'متأخرة $minutes دقيقة',
      many: 'متأخرة $minutes دقيقة',
      few: 'متأخرة $minutes دقائق',
      two: 'متأخرة دقيقتين',
      one: 'متأخرة دقيقة واحدة',
      zero: 'في الموعد',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'مبكرة $minutes دقيقة',
      many: 'مبكرة $minutes دقيقة',
      few: 'مبكرة $minutes دقائق',
      two: 'مبكرة دقيقتين',
      one: 'مبكرة دقيقة واحدة',
      zero: 'في الموعد',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'كل $minutes دقيقة من الساعة $time',
      many: 'كل $minutes دقيقة من الساعة $time',
      few: 'كل $minutes دقائق من الساعة $time',
      two: 'كل دقيقتين من الساعة $time',
      one: 'كل دقيقة واحدة من الساعة $time',
      zero: 'كل أقل من دقيقة من الساعة $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'كل $minutes دقيقة حتى الساعة $time',
      many: 'كل $minutes دقيقة حتى الساعة $time',
      few: 'كل $minutes دقائق حتى الساعة $time',
      two: 'كل دقيقتين حتى الساعة $time',
      one: 'كل دقيقة واحدة حتى الساعة $time',
      zero: 'كل أقل من دقيقة حتى الساعة $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'الوقت المجدول';

  @override
  String get arrivalsLoading => 'جارٍ تحميل مواعيد الوصول';

  @override
  String get arrivalsRefreshing => 'جارٍ تحديث مواعيد الوصول';

  @override
  String get arrivalsUpdated => 'تم تحديث مواعيد الوصول';

  @override
  String get tripPlannerOriginLabel => 'من';

  @override
  String get tripPlannerDestinationLabel => 'إلى';

  @override
  String get tripPlannerChooseOrigin => 'اختر نقطة البداية';

  @override
  String get tripPlannerChooseDestination => 'اختر الوجهة';

  @override
  String get tripPlannerCurrentLocation => 'الموقع الحالي';

  @override
  String get tripPlannerSwapEndpoints => 'تبديل نقطة البداية والوجهة';

  @override
  String get tripPlannerPlanTrip => 'خطط الرحلة';

  @override
  String get tripPlannerPlanningTrip => 'جارٍ تخطيط رحلتك';

  @override
  String get tripPlannerOptions => 'خيارات الرحلة';

  @override
  String get tripPlannerLeaveNow => 'المغادرة الآن';

  @override
  String get tripPlannerDepartAt => 'المغادرة في';

  @override
  String get tripPlannerArriveBy => 'الوصول بحلول';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'تغيير الوقت، $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'نقل عام';

  @override
  String get tripPlannerModeWalk => 'مشي';

  @override
  String get tripPlannerModeBike => 'دراجة';

  @override
  String get tripPlannerModeCar => 'سيارة';

  @override
  String get tripPlannerModeBikeRental => 'دراجات مشتركة فقط';

  @override
  String get tripPlannerModeTransitBikeRental => 'نقل عام + دراجات مشتركة';

  @override
  String get tripPlannerWheelchairAccessible => 'مهيأ للكراسي المتحركة';

  @override
  String get tripPlannerWalkQuarterMile => '0.25 ميل';

  @override
  String get tripPlannerWalkHalfMile => '0.5 ميل';

  @override
  String get tripPlannerWalkOneMile => '1 ميل';

  @override
  String get tripPlannerWalkTwoMiles => '2 ميل';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'المشي حتى $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'لم يُعثر على رحلات';

  @override
  String get tripPlannerRetry => 'إعادة المحاولة';

  @override
  String get tripPlannerRealTime => 'الوقت الفعلي';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours س';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours س $minutes د';
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
      other: '$count تحويل',
      many: '$count تحويلًا',
      few: '$count تحويلات',
      two: 'تحويلان',
      one: 'تحويل واحد',
      zero: 'بدون تحويلات',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return 'مشي $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'تغادر في $time من $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'في الموعد';

  @override
  String tripPlannerStatusLate(int minutes) {
    return 'متأخرة $minutes د';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return 'مبكرة $minutes د';
  }

  @override
  String get tripPlannerStatusScheduled => 'مجدولة';

  @override
  String get tripPlannerLegBus => 'حافلة';

  @override
  String get tripPlannerLegTram => 'ترام';

  @override
  String get tripPlannerLegSubway => 'مترو';

  @override
  String get tripPlannerLegRail => 'قطار';

  @override
  String get tripPlannerLegFerry => 'عبّارة';

  @override
  String get tripPlannerLegCableCar => 'تلفريك';

  @override
  String get tripPlannerLegGondola => 'مصعد هوائي';

  @override
  String get tripPlannerLegFunicular => 'قطار جبلي';

  @override
  String get tripPlannerLegAirplane => 'طائرة';

  @override
  String get tripPlannerLegTrolleybus => 'حافلة كهربائية';

  @override
  String get tripPlannerLegMonorail => 'قطار أحادي السكة';

  @override
  String tripPlannerItinerarySemantics(
    String timeRange,
    String duration,
    String legs,
    String details,
  ) {
    return '$timeRange، $duration. $legs. $details';
  }

  @override
  String tripPlannerLegWalkSemantics(String duration) {
    return 'مشي $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return 'دراجة $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return 'دراجة مشتركة $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return 'قيادة $duration';
  }

  @override
  String tripPlannerLegTransitSemantics(String mode, String duration) {
    return '$mode، $duration';
  }

  @override
  String tripPlannerLegTransitRouteSemantics(
    String mode,
    String route,
    String duration,
  ) {
    return '$mode $route، $duration';
  }

  @override
  String get tripPlannerThen => 'ثم';

  @override
  String get tripPlannerOpenItineraryHint => 'عرض تفاصيل الرحلة';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes دقيقة',
      many: '$minutes دقيقة',
      few: '$minutes دقائق',
      two: 'دقيقتين',
      one: 'دقيقة واحدة',
      zero: 'أقل من دقيقة',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ساعة',
      many: '$hours ساعة',
      few: '$hours ساعات',
      two: 'ساعتان',
      one: 'ساعة واحدة',
      zero: '$hours ساعة',
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
      other: '$value قدم',
      many: '$value قدمًا',
      few: '$value أقدام',
      two: 'قدمان',
      one: 'قدم واحدة',
      zero: '$value قدم',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value ميل',
      many: '$value ميلًا',
      few: '$value أميال',
      two: 'ميلان',
      one: 'ميل واحد',
      zero: '$value ميل',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value متر',
      many: '$value مترًا',
      few: '$value أمتار',
      two: 'متران',
      one: 'متر واحد',
      zero: '$value متر',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value كيلومتر',
      many: '$value كيلومترًا',
      few: '$value كيلومترات',
      two: 'كيلومتران',
      one: 'كيلومتر واحد',
      zero: '$value كيلومتر',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return 'من $start إلى $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'في الوقت الفعلي، في الموعد';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'في الوقت الفعلي، متأخرة $minutes دقيقة',
      many: 'في الوقت الفعلي، متأخرة $minutes دقيقة',
      few: 'في الوقت الفعلي، متأخرة $minutes دقائق',
      two: 'في الوقت الفعلي، متأخرة دقيقتين',
      one: 'في الوقت الفعلي، متأخرة دقيقة واحدة',
      zero: 'في الوقت الفعلي، في الموعد',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'في الوقت الفعلي، مبكرة $minutes دقيقة',
      many: 'في الوقت الفعلي، مبكرة $minutes دقيقة',
      few: 'في الوقت الفعلي، مبكرة $minutes دقائق',
      two: 'في الوقت الفعلي، مبكرة دقيقتين',
      one: 'في الوقت الفعلي، مبكرة دقيقة واحدة',
      zero: 'في الوقت الفعلي، في الموعد',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'الوقت المجدول';

  @override
  String get tripPlannerResultsHeading => 'الرحلات المقترحة';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count رحلة',
      many: 'تم العثور على $count رحلة',
      few: 'تم العثور على $count رحلات',
      two: 'تم العثور على رحلتين',
      one: 'تم العثور على رحلة واحدة',
      zero: 'لم يُعثر على رحلات',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count مكان',
      many: 'تم العثور على $count مكانًا',
      few: 'تم العثور على $count أماكن',
      two: 'تم العثور على مكانين',
      one: 'تم العثور على مكان واحد',
      zero: 'لم يُعثر على أماكن',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'خريطة الرحلة. تصف الاتجاهات أدناه الرحلة نفسها.';

  @override
  String get tripPlannerTripDetails => 'تفاصيل الرحلة';

  @override
  String get tripPlannerMapLabel => 'خريطة الرحلة';

  @override
  String get tripPlannerStart => 'البداية';

  @override
  String get tripPlannerDestination => 'الوجهة';

  @override
  String get tripPlannerUnnamedPlace => 'موقع بلا اسم';

  @override
  String get tripPlannerRentalBike => 'دراجة مشتركة';

  @override
  String tripPlannerWalkTo(String place) {
    return 'امشِ إلى $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'اركب الدراجة إلى $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'اركب دراجة مشتركة إلى $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'قُد إلى $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'استقل $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'استقل $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'استقل $mode باتجاه $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'استقل $mode $route باتجاه $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'انزل عند $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'الوصول إلى $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موقف',
      many: '$count موقفًا',
      few: '$count مواقف',
      two: 'موقفان',
      one: 'موقف واحد',
      zero: 'لا توجد مواقف',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إظهار $count موقف',
      many: 'إظهار $count موقفًا',
      few: 'إظهار $count مواقف',
      two: 'إظهار موقفين',
      one: 'إظهار موقف واحد',
      zero: 'إظهار 0 موقف',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إخفاء $count موقف',
      many: 'إخفاء $count موقفًا',
      few: 'إخفاء $count مواقف',
      two: 'إخفاء موقفين',
      one: 'إخفاء موقف واحد',
      zero: 'إخفاء 0 موقف',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count خطوة',
      many: '$count خطوة',
      few: '$count خطوات',
      two: 'خطوتان',
      one: 'خطوة واحدة',
      zero: 'لا توجد خطوات',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إظهار $count خطوة',
      many: 'إظهار $count خطوة',
      few: 'إظهار $count خطوات',
      two: 'إظهار خطوتين',
      one: 'إظهار خطوة واحدة',
      zero: 'إظهار 0 خطوة',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إخفاء $count خطوة',
      many: 'إخفاء $count خطوة',
      few: 'إخفاء $count خطوات',
      two: 'إخفاء خطوتين',
      one: 'إخفاء خطوة واحدة',
      zero: 'إخفاء 0 خطوة',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance، حوالي $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'انطلق';

  @override
  String get tripPlannerDirectionHardLeft => 'انعطف يساراً بحدة';

  @override
  String get tripPlannerDirectionLeft => 'انعطف يساراً';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'مِل قليلاً إلى اليسار';

  @override
  String get tripPlannerDirectionContinue => 'تابع';

  @override
  String get tripPlannerDirectionSlightlyRight => 'مِل قليلاً إلى اليمين';

  @override
  String get tripPlannerDirectionRight => 'انعطف يميناً';

  @override
  String get tripPlannerDirectionHardRight => 'انعطف يميناً بحدة';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'ادخل الدوّار في اتجاه عقارب الساعة';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'ادخل الدوّار عكس اتجاه عقارب الساعة';

  @override
  String get tripPlannerDirectionElevator => 'استخدم المصعد';

  @override
  String get tripPlannerDirectionUturnLeft => 'استدر للخلف إلى اليسار';

  @override
  String get tripPlannerDirectionUturnRight => 'استدر للخلف إلى اليمين';

  @override
  String get tripPlannerDirectionEnterStation => 'ادخل المحطة';

  @override
  String get tripPlannerDirectionExitStation => 'اخرج من المحطة';

  @override
  String get tripPlannerDirectionFollowSigns => 'اتبع اللافتات';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'امشِ على طول $street مسافة $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction إلى $street، وامشِ $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'ابحث عن مكان';

  @override
  String get tripPlannerSearchNoResults => 'لم يُعثر على أماكن';

  @override
  String get tripPlannerSearchError => 'تعذّر البحث عن الأماكن. حاول مرة أخرى.';

  @override
  String get tripPlannerUseCurrentLocation => 'استخدام الموقع الحالي';

  @override
  String get tripPlannerLocationUnavailable => 'تعذّر تحديد موقعك.';

  @override
  String get tripPlannerClearSearch => 'مسح البحث';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'يرجى تحديد موقعي البداية والوجهة.';

  @override
  String get tripPlannerErrorNetwork =>
      'تعذّر الوصول إلى مخطط الرحلات. تحقق من اتصالك.';

  @override
  String get tripPlannerErrorInvalidResponse => 'أعاد الخادم استجابة غير صالحة';

  @override
  String get tripPlannerErrorUnknown => 'حدث خطأ غير معروف.';

  @override
  String get tripPlannerPlannerSystemError =>
      'تعذّر تخطيط رحلتك الآن. حاول مرة أخرى.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'تخطيط الرحلات غير متاح مؤقتاً. حاول مرة أخرى بعد قليل.';

  @override
  String get tripPlannerPlannerOutsideBounds => 'هذا الموقع غير مدعوم بعد.';

  @override
  String get tripPlannerPlannerPathNotFound => 'لا يتوفر مسار لهذه الرحلة.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'لا تتوفر خيارات نقل عام حالياً.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'استغرق هذا وقتاً أطول من المتوقع. حاول مرة أخرى.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'حدث خطأ في الطلب. حاول مرة أخرى.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'تعذّر العثور على موقع البداية.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound => 'تعذّر العثور على الوجهة.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'تعذّر العثور على نقطة البداية ولا على الوجهة.';

  @override
  String get tripPlannerPlannerTooClose =>
      'نقطة البداية والوجهة متقاربتان جداً.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'هذا المسار غير متاح مع الخيار المحدد.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'موقع البداية غير واضح. حاول أن تكون أكثر تحديداً.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'الوجهة غير واضحة. حاول أن تكون أكثر تحديداً.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'يحتاج الموقعان إلى مزيد من التفاصيل. حاول تحديدهما بدقة أكبر.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'بعض خيارات المسار مفقودة.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'خيارات المسار المحددة لا تعمل معاً.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'يرجى اختيار تفضيل للمسار.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'يرجى ضبط تفضيلات المسار.';
}
