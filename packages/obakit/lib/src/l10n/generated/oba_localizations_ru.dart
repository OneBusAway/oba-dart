// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class ObaLocalizationsRu extends ObaLocalizations {
  ObaLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get commonBack => 'Назад';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonDone => 'Готово';

  @override
  String get commonCancel => 'Отменить';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonContinue => 'Продолжить';

  @override
  String get commonNotNow => 'Не сейчас';

  @override
  String get commonSeeAll => 'Показать все';

  @override
  String get commonLoading => 'Загрузка';

  @override
  String get commonErrorTitle => 'Что-то пошло не так';

  @override
  String get commonEmptyTitle => 'Здесь пока ничего нет';

  @override
  String get commonComingSoon => 'Скоро';

  @override
  String get commonComingSoonBody => 'Этот экран пока недоступен.';

  @override
  String get commonOffline =>
      'Похоже, нет подключения к интернету. Проверьте соединение и повторите попытку.';

  @override
  String get commonServerError =>
      'Сервер ответил неожиданным образом. Повторите попытку через минуту.';

  @override
  String get sheetLabel => 'Панель';

  @override
  String get sheetExpand => 'Развернуть панель';

  @override
  String get sheetCollapse => 'Свернуть панель';

  @override
  String get sheetHandleHint =>
      'Перетащите или дважды коснитесь, чтобы изменить размер панели';

  @override
  String get homeTabHome => 'Главная';

  @override
  String get homeTabRecent => 'Недавние';

  @override
  String get homeTabBookmarks => 'Закладки';

  @override
  String get homeSearchPlaceholder => 'Поиск остановок, маршрутов, мест';

  @override
  String get homeSearchLabel => 'Поиск';

  @override
  String get homeSectionNearby => 'Рядом';

  @override
  String get homeSectionRecent => 'Недавние остановки';

  @override
  String get homeSectionBookmarks => 'Закладки';

  @override
  String get homeSectionAlerts => 'Оповещения';

  @override
  String get homeSectionExplore => 'Обзор';

  @override
  String get homeSectionMore => 'Настройки и ещё';

  @override
  String get mapLabel => 'Карта';

  @override
  String get mapZoomInForStops => 'Приблизьте карту, чтобы увидеть остановки';

  @override
  String get mapLocationDenied =>
      'Доступ к геопозиции отключён. Нажмите, чтобы разрешить.';

  @override
  String get mapLocationServicesOff => 'Службы геолокации отключены';

  @override
  String get mapRecenter => 'Показать моё местоположение';

  @override
  String get mapSettingsButton => 'Настройки карты';

  @override
  String get mapStopsListButton => 'Остановки на карте';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count остановки на карте',
      many: '$count остановок на карте',
      few: '$count остановки на карте',
      one: '$count остановка на карте',
      zero: 'На карте нет остановок',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'Ваше местоположение';

  @override
  String get mapDroppedPin => 'Установленная метка';

  @override
  String get mapVehicle => 'Транспорт';

  @override
  String get mapSelectedStop => 'Выбрана';

  @override
  String get mapBookmarkedStop => 'В закладках';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, остановка ($routeType)';
  }

  @override
  String get mapStopMarkerHint => 'Открывает отправления с этой остановки';

  @override
  String mapAttribution(String attribution) {
    return 'Данные карты: $attribution';
  }

  @override
  String get mapTypeTitle => 'Тип карты';

  @override
  String get mapTypeStandard => 'Стандартная';

  @override
  String get mapTypeSatellite => 'Спутник';

  @override
  String get mapTypeHybrid => 'Гибрид';

  @override
  String get mapShowScale => 'Показывать масштаб';

  @override
  String get mapShowHeading => 'Показывать направление';

  @override
  String get mapShowStopLabels => 'Показывать подписи остановок';

  @override
  String mapPlaceAt(String lat, String lon) {
    return 'Место: $lat, $lon';
  }

  @override
  String get directionN => 'На север';

  @override
  String get directionNE => 'На северо-восток';

  @override
  String get directionE => 'На восток';

  @override
  String get directionSE => 'На юго-восток';

  @override
  String get directionS => 'На юг';

  @override
  String get directionSW => 'На юго-запад';

  @override
  String get directionW => 'На запад';

  @override
  String get directionNW => 'На северо-запад';

  @override
  String get routeTypeBus => 'Автобус';

  @override
  String get routeTypeLightRail => 'Скоростной трамвай';

  @override
  String get routeTypeSubway => 'Метро';

  @override
  String get routeTypeRail => 'Поезд';

  @override
  String get routeTypeFerry => 'Паром';

  @override
  String get routeTypeCableCar => 'Канатный трамвай';

  @override
  String get routeTypeGondola => 'Гондола';

  @override
  String get routeTypeFunicular => 'Фуникулёр';

  @override
  String get routeTypeUnknown => 'Транспорт';

  @override
  String stopCode(String code) {
    return 'Остановка $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'Маршруты $routes';
  }

  @override
  String get stopPageRefresh => 'Обновить';

  @override
  String get stopPageRefreshed => 'Отправления обновлены';

  @override
  String get stopPageBookmark => 'Добавить остановку в закладки';

  @override
  String get stopPageBookmarked => 'В закладках. Изменить закладку';

  @override
  String get stopPageMoreActions => 'Другие действия с остановкой';

  @override
  String get stopPageSchedules => 'Расписания';

  @override
  String get stopPageServiceAlerts => 'Оповещения о движении';

  @override
  String get stopPageNearbyStops => 'Остановки рядом';

  @override
  String get stopPageWalkingDirections => 'Пешеходный маршрут';

  @override
  String get stopPageBikeDirections => 'Велосипедный маршрут';

  @override
  String get stopPagePlanTripFrom => 'Спланировать поездку отсюда';

  @override
  String get stopPagePlanTripTo => 'Спланировать поездку сюда';

  @override
  String get stopPageShareStop => 'Поделиться остановкой';

  @override
  String get stopPageReportProblem => 'Сообщить о проблеме';

  @override
  String get stopPageFilterRoutes => 'Фильтр маршрутов';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count маршрута скрыто',
      many: '$count маршрутов скрыто',
      few: '$count маршрута скрыто',
      one: '$count маршрут скрыт',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'По времени';

  @override
  String get stopPageModeRoute => 'По маршруту';

  @override
  String get stopPageDepartureTypes => 'Типы отправлений';

  @override
  String get stopPageFilterAll => 'Все отправления';

  @override
  String get stopPageFilterRealtime => 'Только в реальном времени';

  @override
  String get stopPageFilterScheduled => 'Только по расписанию';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Показать $count прошедших отправления',
      many: 'Показать $count прошедших отправлений',
      few: 'Показать $count прошедших отправления',
      one: 'Показать $count прошедшее отправление',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Скрыть прошедшие отправления';

  @override
  String get stopPageLoadMore => 'Загрузить ещё отправления';

  @override
  String stopPageWindow(int minutes) {
    return 'Показаны отправления в ближайшие $minutes мин.';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Обновлено $ago';
  }

  @override
  String get stopPageStaleTitle => 'Не удалось обновить отправления';

  @override
  String get stopPageStaleBody => 'Это время может быть неактуальным.';

  @override
  String get stopPageEmptyTitle => 'Нет ближайших отправлений';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'Нет отправлений в ближайшие $minutes мин.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Все маршруты с отправлениями отсюда скрыты.';

  @override
  String get stopPageShowAllRoutes => 'Показать все маршруты';

  @override
  String get stopPageEmptyFilter =>
      'Нет отправлений, соответствующих фильтру типа отправления.';

  @override
  String get stopPageShowAllTypes => 'Показать все отправления';

  @override
  String get stopPageMissingTitle => 'Остановка не найдена';

  @override
  String get stopPageMissingBody =>
      'Возможно, эта остановка удалена или получила другой номер.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes мин. пешком';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes мин. на велосипеде';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes минуты пешком',
      many: '$minutes минут пешком',
      few: '$minutes минуты пешком',
      one: '$minutes минута пешком',
    );
    return '$_temp0, $distance. Открывает маршрут.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes минуты на велосипеде',
      many: '$minutes минут на велосипеде',
      few: '$minutes минуты на велосипеде',
      one: '$minutes минута на велосипеде',
    );
    return '$_temp0, $distance. Открывает маршрут.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '$minutes мин. пешком до этой остановки. Отправления выше уйдут раньше.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '$minutes мин. на велосипеде до этой остановки. Отправления выше уйдут раньше.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Перевозчик: $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count оповещения о движении',
      many: '$count оповещений о движении',
      few: '$count оповещения о движении',
      one: '$count оповещение о движении',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count непрочитанных',
      many: '$count непрочитанных',
      few: '$count непрочитанных',
      one: '$count непрочитанное',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Непрочитано';

  @override
  String get stopPageAlertImportant => 'Важно';

  @override
  String get stopPageDirectionsChooser => 'Открыть маршрут в приложении';

  @override
  String get stopPageAppleMaps => 'Apple Карты';

  @override
  String get stopPageGoogleMaps => 'Google Карты';

  @override
  String get stopPageCannotOpen => 'Не удалось открыть эту ссылку.';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Пересадка с маршрута $route $headsign, прибытие $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Отправления';

  @override
  String get stopRowNow => 'СЕЙЧАС';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes мин.';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes мин. назад';
  }

  @override
  String get stopRowOnTime => 'вовремя';

  @override
  String stopRowLate(int minutes) {
    return 'опоздание $minutes мин.';
  }

  @override
  String stopRowEarly(int minutes) {
    return 'раньше на $minutes мин.';
  }

  @override
  String get stopRowScheduled => 'по расписанию';

  @override
  String get stopRowCanceled => 'отменён';

  @override
  String get stopRowOccupancyEmpty => 'Пусто';

  @override
  String get stopRowOccupancyManySeats => 'Много свободных мест';

  @override
  String get stopRowOccupancyFewSeats => 'Мало свободных мест';

  @override
  String get stopRowOccupancyStanding => 'Только стоячие места';

  @override
  String get stopRowOccupancyCrushed => 'Очень много людей';

  @override
  String get stopRowOccupancyFull => 'Заполнен';

  @override
  String get stopRowOccupancyNotAccepting => 'Не принимает пассажиров';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'прибудет через $minutes минуты',
      many: 'прибудет через $minutes минут',
      few: 'прибудет через $minutes минуты',
      one: 'прибудет через $minutes минуту',
      zero: 'прибывает сейчас',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'отправится через $minutes минуты',
      many: 'отправится через $minutes минут',
      few: 'отправится через $minutes минуты',
      one: 'отправится через $minutes минуту',
      zero: 'отправляется сейчас',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'прибыл $minutes минуты назад',
      many: 'прибыл $minutes минут назад',
      few: 'прибыл $minutes минуты назад',
      one: 'прибыл $minutes минуту назад',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'отправился $minutes минуты назад',
      many: 'отправился $minutes минут назад',
      few: 'отправился $minutes минуты назад',
      one: 'отправился $minutes минуту назад',
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
    return 'Маршрут $route до $headsign, $eta, в $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'отслеживание в реальном времени, $status';
  }

  @override
  String get stopRowA11yScheduledOnly =>
      'только время по расписанию, данных в реальном времени нет';

  @override
  String get stopRowA11yTransfer => 'ваш рейс для пересадки';

  @override
  String get stopRowA11yMissed =>
      'вероятно, вы не успеете: он отправится раньше, чем вы дойдёте до остановки';

  @override
  String get stopRowA11yAlarm => 'напоминание установлено';

  @override
  String stopRowActions(String route) {
    return 'Другие действия для маршрута $route';
  }

  @override
  String get stopRowShowTrip => 'Показать сведения о рейсе';

  @override
  String get stopRowAddAlarm => 'Добавить напоминание';

  @override
  String get stopRowRemoveAlarm => 'Удалить напоминание';

  @override
  String get stopRowBookmarkTrip => 'Добавить этот рейс в закладки';

  @override
  String get stopRowShareTrip => 'Поделиться рейсом';

  @override
  String get stopRowRouteSchedule => 'Расписание маршрута';

  @override
  String get stopRowRouteStops => 'Остановки этого маршрута';

  @override
  String stopRouteGroupNext(String times) {
    return 'Далее: $times';
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
      other: '$count отправления',
      many: '$count отправлений',
      few: '$count отправления',
      one: '$count отправление',
    );
    return 'Маршрут $route до $headsigns, $_temp0, ближайшее $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Напомнить перед отправлением';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'За $minutes минуты',
      many: 'За $minutes минут',
      few: 'За $minutes минуты',
      one: 'За $minutes минуту',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Напоминание за $minutes минуты установлено',
      many: 'Напоминание за $minutes минут установлено',
      few: 'Напоминание за $minutes минуты установлено',
      one: 'Напоминание за $minutes минуту установлено',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Напоминание удалено';

  @override
  String get stopAlarmFailed => 'Не удалось обновить напоминание.';

  @override
  String get stopAlarmPermissionDenied =>
      'Уведомления для этого приложения отключены.';

  @override
  String get stopFilterTitle => 'Фильтр маршрутов';

  @override
  String get stopFilterSort => 'Сортировка отправлений';

  @override
  String get stopFilterRoutesHeader =>
      'Маршруты, показываемые на этой остановке';

  @override
  String get stopFilterShowAll => 'Показать все маршруты';

  @override
  String get stopTripArrivingAtYourStop => 'Прибывает на вашу остановку';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count остановки до вас',
      many: '$count остановок до вас',
      few: '$count остановки до вас',
      one: '$count остановка до вас',
      zero: 'На вашей остановке',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return '$distance от вас';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'На остановке $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Положение обновлено $ago';
  }

  @override
  String get stopTripNoPosition =>
      'Нет данных о положении этого транспорта в реальном времени';

  @override
  String stopTripStartsAs(String trip) {
    return 'Начинается как $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Продолжается как $trip';
  }

  @override
  String get stopTripStopsHeader => 'Остановки';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пройденной остановки',
      many: '$count пройденных остановок',
      few: '$count пройденные остановки',
      one: '$count пройденная остановка',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count остановки до вашей',
      many: '$count остановок до вашей',
      few: '$count остановки до вашей',
      one: '$count остановка до вашей',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'Ваша остановка';

  @override
  String get stopTripBoarding => 'Посадка';

  @override
  String get stopTripVehicleHere => 'Транспорт здесь';

  @override
  String get stopTripTerminal => 'Конечная';

  @override
  String get stopTripPassed => 'Пройдена';

  @override
  String get stopTripRouteStops => 'Все остановки этого маршрута';

  @override
  String get stopTripReport => 'Сообщить о проблеме с этим рейсом';

  @override
  String get stopTripGhostBus => 'Сообщить об автобусе-призраке';

  @override
  String get stopTripCanceled => 'Этот рейс отменён';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Транспорт на маршруте $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'Каждые $minutes мин.';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Маршрут $route';
  }

  @override
  String get stopRouteStopsDirection => 'Направление';

  @override
  String stopRouteStopsToward(String name) {
    return 'До: $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count остановки',
      many: '$count остановок',
      few: '$count остановки',
      one: '$count остановка',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => 'Для этого маршрута остановки не найдены.';

  @override
  String get stopSchedPrevDay => 'Предыдущий день';

  @override
  String get stopSchedNextDay => 'Следующий день';

  @override
  String stopSchedPickDate(String date) {
    return 'Выбрать дату, $date';
  }

  @override
  String get stopSchedRoute => 'Маршрут';

  @override
  String get stopSchedDirection => 'Направление';

  @override
  String get stopSchedStop => 'Остановка';

  @override
  String get stopSchedEmpty => 'В этот день нет рейсов по расписанию.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'Каждые $minutes мин. с $start до $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'До: $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отправления',
      many: '$count отправлений',
      few: '$count отправления',
      one: '$count отправление',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported => 'В этом регионе расписания недоступны.';

  @override
  String get stopSchedViewList => 'Список';

  @override
  String get stopSchedViewGrid => 'Таблица';

  @override
  String get stopSchedNoDeparture => 'Нет отправления';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (ваша остановка)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, рейс $trip: $time';
  }

  @override
  String get stopReportProblemHeader => 'В чём проблема?';

  @override
  String get stopReportStopNameWrong => 'Неверное название остановки';

  @override
  String get stopReportStopNumberWrong => 'Неверный номер остановки';

  @override
  String get stopReportStopLocationWrong => 'Остановка находится не там';

  @override
  String get stopReportRouteMissing => 'Отсутствует маршрут или рейс';

  @override
  String get stopReportOther => 'Другое';

  @override
  String get stopReportNeverCame => 'Транспорт не приехал';

  @override
  String get stopReportCameEarly => 'Приехал раньше';

  @override
  String get stopReportCameLate => 'Приехал позже';

  @override
  String get stopReportWrongHeadsign => 'Неверное направление на табло';

  @override
  String get stopReportNotStopHere => 'Не остановился здесь';

  @override
  String get stopReportComment => 'Дополнительные комментарии (необязательно)';

  @override
  String get stopReportShareLocation => 'Поделиться моим местоположением';

  @override
  String get stopReportShareLocationHelp =>
      'Если вы поделитесь местоположением, перевозчику будет проще исправить проблему.';

  @override
  String get stopReportOnVehicle => 'Я еду в этом транспорте';

  @override
  String get stopReportVehicleId => 'Номер транспорта (необязательно)';

  @override
  String get stopReportSend => 'Отправить сообщение';

  @override
  String get stopReportSending => 'Отправка сообщения';

  @override
  String get stopReportSent => 'Спасибо! Ваше сообщение отправлено.';

  @override
  String get stopReportFailed =>
      'Не удалось отправить сообщение. Повторите попытку.';

  @override
  String get stopReportChooseProblem => 'Сначала выберите проблему.';

  @override
  String stopReportAbout(String name) {
    return 'Сообщение о: $name';
  }

  @override
  String get stopGhostTitle => 'Сообщить об автобусе-призраке';

  @override
  String get stopGhostExplain =>
      'Автобус-призрак — это автобус, который показывался в приложении, но так и не приехал.';

  @override
  String get stopGhostWait => 'Как долго вы ждали после времени по расписанию?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes мин.';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30+ мин.';

  @override
  String get stopCardEmpty => 'Скоро отправлений нет';

  @override
  String get titleSearch => 'Поиск';

  @override
  String get titleSearchResults => 'Результаты';

  @override
  String get titleNearbyStops => 'Остановки рядом';

  @override
  String get titleRecentStops => 'Недавние остановки';

  @override
  String get titleBookmarks => 'Закладки';

  @override
  String get titleStop => 'Остановка';

  @override
  String get titleTrip => 'Рейс';

  @override
  String get titleRouteStops => 'Маршрут';

  @override
  String get titleStopSchedule => 'Расписание';

  @override
  String get titleRouteSchedule => 'Расписание маршрута';

  @override
  String get titleAlerts => 'Оповещения';

  @override
  String get titleAlertDetail => 'Оповещение';

  @override
  String get titleAgencies => 'Агентства';

  @override
  String get titleRegionPicker => 'Регионы';

  @override
  String get titleCustomRegion => 'Пользовательский регион';

  @override
  String get titleSettings => 'Настройки';

  @override
  String get titleMapSettings => 'Настройки карты';

  @override
  String get titleMore => 'Ещё';

  @override
  String get titleTripPlanner => 'Спланировать поездку';

  @override
  String get titlePlace => 'Место';

  @override
  String get titleReportStopProblem => 'Сообщить о проблеме';

  @override
  String get titleReportTripProblem => 'Сообщить о проблеме';

  @override
  String get titleBookmarkEditor => 'Закладка';

  @override
  String get titleManageBookmarks => 'Изменить закладки';

  @override
  String get titleCredits => 'Благодарности';

  @override
  String get titleWeather => 'Погода';

  @override
  String get titleStopsOnMap => 'Остановки на карте';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Добро пожаловать в $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Прибытие автобусов, поездов и паромов рядом с вами в реальном времени.';

  @override
  String get onboardingLocationTitle => 'Найдите остановки рядом';

  @override
  String get onboardingLocationBody =>
      'Разрешите доступ к геопозиции, чтобы видеть ближайшие остановки и автоматически выбирать регион.';

  @override
  String get onboardingAllowLocation => 'Разрешить доступ к геопозиции';

  @override
  String get onboardingRegionTitle => 'Выберите регион';

  @override
  String get onboardingRegionBody =>
      'Выберите территорию, транспорт которой вы хотите видеть.';

  @override
  String get settingsSectionMap => 'Карта';

  @override
  String get settingsMapTypeRow => 'Тип карты и слои';

  @override
  String get settingsMapTypeHelp => 'Выберите внешний вид карты.';

  @override
  String get settingsHeadingHelp =>
      'Показывает на карте направление, в котором вы смотрите.';

  @override
  String get settingsStopLabelsHelp =>
      'Показывает названия маршрутов рядом с остановками на карте.';

  @override
  String get settingsWalkingDirections => 'Пешеходный маршрут';

  @override
  String get settingsWalkingDirectionsHelp =>
      'Приложение, которое открывается при запросе пешеходного маршрута до остановки.';

  @override
  String get settingsDirectionsAsk => 'Спрашивать каждый раз';

  @override
  String get settingsDirectionsAppleMaps => 'Apple Карты';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Карты';

  @override
  String get settingsSectionDepartures => 'Отправления';

  @override
  String get settingsDepartureFilter => 'Показывать отправления';

  @override
  String get settingsDepartureFilterHelp =>
      'Выберите, показывать ли на страницах остановок все отправления или только те, для которых есть данные в реальном времени или по расписанию.';

  @override
  String get settingsFilterAll => 'Все отправления';

  @override
  String get settingsFilterRealtime => 'Только в реальном времени';

  @override
  String get settingsFilterScheduled => 'Только по расписанию';

  @override
  String get settingsRegionTimeZone =>
      'Показывать время в часовом поясе региона';

  @override
  String get settingsRegionTimeZoneHelp =>
      'Время показывается в часовом поясе региона транспорта, с пометкой, если он отличается от пояса вашего устройства.';

  @override
  String get settingsSectionAccessibility => 'Универсальный доступ';

  @override
  String get settingsReducedColors => 'Меньше цветов на страницах остановок';

  @override
  String get settingsReducedColorsHelp =>
      'Показывает значки маршрутов в одном нейтральном стиле.';

  @override
  String get settingsCompactMode => 'Компактные страницы остановок и рейсов';

  @override
  String get settingsCompactModeHelp =>
      'Уменьшает отступы, чтобы на экране помещалось больше.';

  @override
  String get settingsSectionWalking => 'Скорость ходьбы';

  @override
  String get settingsWalkingSpeed => 'Скорость ходьбы';

  @override
  String get settingsWalkingSpeedHelp =>
      'Используется для оценки времени в пути пешком и времени прибытия.';

  @override
  String get settingsSpeedSlow => 'Медленная';

  @override
  String get settingsSpeedAverage => 'Средняя';

  @override
  String get settingsSpeedFast => 'Быстрая';

  @override
  String settingsSpeedCustom(String speed) {
    return 'Своя ($speed м/с)';
  }

  @override
  String get settingsSectionBike => 'Режим велосипеда';

  @override
  String get settingsBikeMode => 'Режим велосипеда';

  @override
  String get settingsBikeModeHelp =>
      'Использует более высокую скорость для оценки времени в пути, времени прибытия и страницы остановки.';

  @override
  String get settingsSectionSurveys => 'Опросы';

  @override
  String get settingsSurveysEnabled => 'Показывать опросы';

  @override
  String get settingsSurveysAlways => 'Всегда показывать опросы на остановках';

  @override
  String get settingsSectionPrivacy => 'Конфиденциальность';

  @override
  String get settingsAnalytics =>
      'Отправлять данные об использовании разработчикам';

  @override
  String get settingsAnalyticsHelp =>
      'Помогает разработчикам понять, какими функциями пользуются.';

  @override
  String get settingsSectionDebug => 'Отладка';

  @override
  String get settingsDebugMode => 'Режим отладки';

  @override
  String get settingsDebugAlwaysFeedback => 'Всегда показывать запрос отзыва';

  @override
  String get settingsDebugResetFeedback => 'Сбросить состояние запроса отзыва';

  @override
  String get settingsDebugResetDonation =>
      'Сбросить состояние карточки пожертвования';

  @override
  String get settingsDebugResetDone => 'Сброшено';

  @override
  String get settingsSectionTripPlanner => 'Планировщик поездок';

  @override
  String get settingsHomeCustomizeMap => 'Настроить карту';

  @override
  String get moreHeaderSupport =>
      'Это приложение создано и поддерживается волонтёрами.';

  @override
  String get moreSectionDonate => 'Станьте спонсором';

  @override
  String moreDonate(String appName) {
    return 'Пожертвовать на $appName';
  }

  @override
  String get moreManageDonations => 'Управление пожертвованиями';

  @override
  String get moreSectionUpdates => 'Обновления и оповещения';

  @override
  String get moreAlerts => 'Оповещения';

  @override
  String get moreSectionLocation => 'Моё местоположение';

  @override
  String get moreRegion => 'Регион';

  @override
  String get moreRegionNone => 'Не выбран';

  @override
  String get morePayFare => 'Оплатить проезд';

  @override
  String get moreAgencies => 'Агентства';

  @override
  String get moreSectionAbout => 'О приложении';

  @override
  String moreRateApp(String appName) {
    return 'Оценить $appName';
  }

  @override
  String get moreContactUs => 'Связаться с нами';

  @override
  String get morePrivacy => 'Политика конфиденциальности';

  @override
  String get moreCredits => 'Благодарности';

  @override
  String moreVersion(String appName, String version) {
    return '$appName, версия $version';
  }

  @override
  String get moreSectionHelpOut => 'Помогите улучшить приложение';

  @override
  String get moreTranslate => 'Помочь с переводом приложения';

  @override
  String get moreDevelop =>
      'Помочь исправлять ошибки и создавать новые функции';

  @override
  String get moreSectionContact => 'Связь и помощь';

  @override
  String get moreTutorials => 'Руководства';

  @override
  String get moreCallAgency => 'Позвонить в агентство';

  @override
  String get moreTextAgency => 'Написать в агентство';

  @override
  String get moreSectionResources => 'Ресурсы';

  @override
  String get moreContactTitle => 'Связаться с нами';

  @override
  String get moreContactDevelopers =>
      'Предложить функцию или сообщить об ошибке';

  @override
  String get moreContactAgency => 'Проблема с транспортом или расписанием';

  @override
  String moreEmailSubject(String appName) {
    return 'Отзыв о $appName';
  }

  @override
  String get moreEmailAgencySubject => 'Отзыв пассажира';

  @override
  String get moreEmailIntro =>
      'Чем мы можем помочь? Напишите ваше сообщение ниже:';

  @override
  String get moreEmailDebugIntro =>
      'Следующая информация нужна для диагностики. Если вы не хотите ею делиться, можете удалить её, но это может осложнить нам помощь.';

  @override
  String get moreDebugAppVersion => 'Версия приложения';

  @override
  String get moreDebugOs => 'Операционная система';

  @override
  String get moreDebugLocale => 'Язык';

  @override
  String get moreDebugBookmarks => 'Количество закладок';

  @override
  String get moreDebugLocationPermission => 'Доступ к геопозиции';

  @override
  String get moreDebugRegion => 'Регион';

  @override
  String get moreDebugRegionId => 'ID региона';

  @override
  String get moreDebugApiUrl => 'Базовый URL API';

  @override
  String get moreDebugUserId => 'ID пользователя';

  @override
  String get moreCantEmailTitle => 'Не удаётся открыть почтовое приложение';

  @override
  String moreCantEmailBody(String email) {
    return 'Чтобы связаться с нами, отправьте письмо на $email. Скопируйте отладочную информацию и вставьте её в сообщение, чтобы помочь нам исправить проблему.';
  }

  @override
  String get moreCopyEmail => 'Скопировать адрес электронной почты';

  @override
  String get moreCopyDebug => 'Скопировать отладочную информацию';

  @override
  String get moreCopied => 'Скопировано в буфер обмена';

  @override
  String get moreFareContinue => 'Продолжить';

  @override
  String get moreFareDontShowAgain => 'Продолжить и больше не показывать';

  @override
  String get moreCantOpenLink => 'Не удалось открыть эту ссылку.';

  @override
  String get regionPickerAutomatic => 'Выбирать регион автоматически';

  @override
  String get regionPickerAutomaticHelp =>
      'Переключается на регион, в котором вы находитесь. Если выбрать регион вручную, эта функция отключится.';

  @override
  String get regionPickerShowExperimental =>
      'Показывать экспериментальные регионы';

  @override
  String get regionPickerShowInactive => 'Показывать неактивные регионы';

  @override
  String get regionPickerRegionsSection => 'Регионы';

  @override
  String get regionPickerCustomSection => 'Пользовательские регионы';

  @override
  String get regionPickerCurrent => 'Текущий регион';

  @override
  String get regionPickerExperimentalTag => 'Экспериментальный';

  @override
  String get regionPickerInactiveTag => 'Неактивный';

  @override
  String get regionPickerCustomTag => 'Пользовательский';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Добавить пользовательский регион';

  @override
  String get regionPickerRefresh => 'Обновить регионы';

  @override
  String get regionPickerRefreshed => 'Регионы обновлены';

  @override
  String get regionPickerRefreshFailed =>
      'Не удалось обновить список регионов. Показан сохранённый список.';

  @override
  String regionPickerSelected(String name) {
    return 'Выбрано: $name';
  }

  @override
  String regionPickerEdit(String name) {
    return 'Изменить: $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'Удалить: $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'Удалить: $name?';
  }

  @override
  String get regionPickerDeleteBody =>
      'Этот пользовательский регион будет удалён с этого устройства.';

  @override
  String get regionPickerDeleteConfirm => 'Удалить';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Выберите другой регион, прежде чем удалять этот.';

  @override
  String get regionPickerEmpty => 'Нет доступных регионов';

  @override
  String get regionPickerEmptyBody =>
      'Включите экспериментальные или неактивные регионы либо добавьте пользовательский регион.';

  @override
  String get regionPickerTripPlanner => 'Планировщик поездок в этом регионе';

  @override
  String get customRegionEditTitle => 'Изменить пользовательский регион';

  @override
  String get customRegionName => 'Название';

  @override
  String get customRegionObaUrl => 'URL сервера OneBusAway';

  @override
  String get customRegionObaUrlHelp =>
      'Адрес сервера, например https://oba.example.com/';

  @override
  String get customRegionSidecar => 'URL сервера Sidecar (необязательно)';

  @override
  String get customRegionOtp => 'URL планировщика поездок (необязательно)';

  @override
  String get customRegionOtpGraphql =>
      'URL GraphQL планировщика поездок (необязательно)';

  @override
  String get customRegionServiceArea => 'Зона обслуживания';

  @override
  String get customRegionServiceAreaHelp =>
      'Территория, которую охватывает этот регион: центральная точка и размер области.';

  @override
  String get customRegionLatitude => 'Широта центра';

  @override
  String get customRegionLongitude => 'Долгота центра';

  @override
  String get customRegionLatSpan => 'Охват по широте (градусы)';

  @override
  String get customRegionLonSpan => 'Охват по долготе (градусы)';

  @override
  String get customRegionUseMap => 'Использовать текущую область карты';

  @override
  String get customRegionSave => 'Сохранить';

  @override
  String get customRegionErrorRequired => 'Это поле обязательно';

  @override
  String get customRegionErrorUrl =>
      'Введите веб-адрес, начинающийся с http:// или https://';

  @override
  String get customRegionErrorNumber => 'Введите число';

  @override
  String get customRegionErrorRange => 'Это число вне допустимого диапазона';

  @override
  String get customRegionChecking => 'Проверка сервера';

  @override
  String get customRegionServerOk => 'Сервер ответил';

  @override
  String get customRegionServerUnreachable =>
      'Не удалось связаться с этим сервером';

  @override
  String get customRegionServerNotOba =>
      'Этот сервер ответил не так, как OneBusAway';

  @override
  String customRegionSaved(String name) {
    return 'Сохранено: $name';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway — бесплатное программное обеспечение для общественного транспорта с открытым исходным кодом, созданное волонтёрами при поддержке Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'Лицензия';

  @override
  String get creditsMapData => 'Данные карты';

  @override
  String get creditsLicenses => 'Лицензии открытого ПО';

  @override
  String get creditsLicensesHelp =>
      'Библиотеки, на которых построено это приложение.';

  @override
  String get creditsLicensesLoading => 'Загрузка лицензий';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count лицензии',
      many: '$count лицензий',
      few: '$count лицензии',
      one: '$count лицензия',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Доступно в десятках транспортных регионов по всему миру.';

  @override
  String get onboardingBenefitNearbyTitle => 'Остановки рядом';

  @override
  String get onboardingBenefitNearbyBody =>
      'Автобусы и поезда вокруг вас, отсортированные по расстоянию.';

  @override
  String get onboardingBenefitMapTitle => 'Карта с вами в центре';

  @override
  String get onboardingBenefitMapBody =>
      'Сразу открывайте окрестности без поиска.';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName использует ваше местоположение, только пока приложение открыто. Это можно изменить в любой момент в настройках устройства.';
  }

  @override
  String get onboardingLocationDenied =>
      'Доступ к геопозиции отключён. Вы всё равно можете выбрать регион самостоятельно.';

  @override
  String get onboardingRegionDetected => 'Определён рядом с вами';

  @override
  String onboardingRegionUse(String name) {
    return 'Выбрать: $name';
  }

  @override
  String get onboardingRegionOthers => 'Или выберите другой регион';

  @override
  String get onboardingRegionEmpty =>
      'Сейчас нет доступных регионов. Проверьте подключение и повторите попытку.';

  @override
  String get surveyCardTitle => 'Помогите улучшить транспорт';

  @override
  String get surveyDefaultPrompt =>
      'Пройдите короткий опрос, чтобы помочь улучшить транспорт.';

  @override
  String get surveyTake => 'Пройти опрос';

  @override
  String get surveyNotNow => 'Не сейчас';

  @override
  String get surveyDismiss => 'Закрыть опрос';

  @override
  String get surveyNext => 'Далее';

  @override
  String get surveySubmit => 'Отправить опрос';

  @override
  String get surveySubmitting => 'Отправка';

  @override
  String get surveyQuestionsTitle => 'Опрос';

  @override
  String get surveyTextHint => 'Введите ответ';

  @override
  String get surveyRequired => 'Обязательно';

  @override
  String get surveyIncomplete =>
      'Перед отправкой ответьте на все обязательные вопросы.';

  @override
  String get surveyFailed =>
      'Не удалось отправить ваши ответы. Повторите попытку.';

  @override
  String get surveyThanks => 'Спасибо за отзыв.';

  @override
  String get surveyOpenSurvey => 'Открыть опрос';

  @override
  String get surveyLearnMore => 'Подробнее';

  @override
  String get surveyShareFeedback => 'Оставить отзыв';

  @override
  String get surveySignUp => 'Зарегистрироваться';

  @override
  String get surveyExternalError =>
      'Не удалось открыть ссылку на опрос. Повторите попытку позже.';

  @override
  String donationTitle(String appName) {
    return '$appName нужна ваша помощь';
  }

  @override
  String get donationBody =>
      'Это приложение создано волонтёрами, и нам нужна ваша помощь, чтобы финансировать его дальнейшую разработку.';

  @override
  String get donationLearnMore => 'Подробнее';

  @override
  String get donationDonate => 'Пожертвовать';

  @override
  String get donationRemindLater => 'Напомнить позже';

  @override
  String get donationDismiss => 'Нет, спасибо';

  @override
  String get donationHeader => 'Почему нам нужна ваша помощь';

  @override
  String donationExplanation(String appName) {
    return 'У нас большие планы по развитию $appName, но без вашей помощи мы не сможем их осуществить. Это приложение создано волонтёрами, и нам нужна ваша помощь, чтобы финансировать его дальнейшую разработку.\n\nКак ключевой проект некоммерческой организации Open Transit Software Foundation, ваше пожертвование не облагается налогом в США.';
  }

  @override
  String get donationDonateWebsite => 'Пожертвовать на нашем сайте';

  @override
  String titleDonation(String appName) {
    return 'Поддержать $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'Нравится $appName?';
  }

  @override
  String get feedbackYes => 'Да!';

  @override
  String get feedbackNo => 'Не очень';

  @override
  String get feedbackLater => 'Спросить позже';

  @override
  String get feedbackNegativeTitle => 'Нам жаль.';

  @override
  String get feedbackNegativeBody =>
      'Расскажете, что не так? Мы читаем каждое сообщение.';

  @override
  String get feedbackSend => 'Отправить отзыв';

  @override
  String get feedbackDecline => 'Нет, спасибо';

  @override
  String get tripPlanningUnavailable =>
      'Планирование поездок недоступно в этом регионе.';

  @override
  String get deepLinkOtherRegion =>
      'Эта ссылка относится к другому региону. Смените регион, чтобы её открыть.';

  @override
  String get dataUpdated => 'Обновлено';

  @override
  String get bookmarksEtaNow => 'Сейчас';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes мин.';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'через $minutes минуты',
      many: 'через $minutes минут',
      few: 'через $minutes минуты',
      one: 'через $minutes минуту',
      zero: 'сейчас',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => 'Вовремя';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'опоздание $minutes мин.',
      one: 'опоздание $minutes мин.',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'раньше на $minutes мин.',
      one: 'раньше на $minutes мин.',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => 'По расписанию';

  @override
  String get bookmarksStatusCanceled => 'Отменён';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Маршрут $route до $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Маршрут $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Загрузка отправлений';

  @override
  String get bookmarksNoDepartures => 'Нет ближайших отправлений';

  @override
  String get bookmarksDeparturesError => 'Не удалось загрузить отправления';

  @override
  String get bookmarksDeparturesStale =>
      'Не удалось обновить. Показано прежнее время.';

  @override
  String get bookmarksUpdated => 'Отправления обновлены';

  @override
  String get bookmarksSortTooltip => 'Сортировка закладок';

  @override
  String get bookmarksSortByGroup => 'Сортировать по группам';

  @override
  String get bookmarksSortByDistance => 'Сортировать по расстоянию';

  @override
  String get bookmarksManageTooltip => 'Изменить закладки и группы';

  @override
  String get bookmarksRefreshTooltip => 'Обновить отправления';

  @override
  String get bookmarksEmptyTitle => 'Закладок пока нет';

  @override
  String get bookmarksEmptyBody =>
      'Откройте остановку и нажмите кнопку закладки, чтобы сохранить её здесь. Из отправления можно также добавить в закладки только этот маршрут на остановке.';

  @override
  String get bookmarksFindStops => 'Найти остановки на карте';

  @override
  String get bookmarksUngrouped => 'Без группы';

  @override
  String get bookmarksGroupExpanded => 'развёрнуто';

  @override
  String get bookmarksGroupCollapsed => 'свёрнуто';

  @override
  String get bookmarksGroupToggleHint =>
      'Показывает или скрывает закладки в этой группе';

  @override
  String bookmarksActionsFor(String name) {
    return 'Действия для: $name';
  }

  @override
  String get bookmarksActionEdit => 'Изменить';

  @override
  String get bookmarksActionPin => 'Закрепить вверху';

  @override
  String get bookmarksActionUnpin => 'Открепить';

  @override
  String get bookmarksActionMove => 'Переместить в группу';

  @override
  String get bookmarksActionDelete => 'Удалить';

  @override
  String get bookmarksPinned => 'Закреплено';

  @override
  String bookmarksDeleted(String name) {
    return 'Удалено: $name';
  }

  @override
  String get bookmarksUndo => 'Отменить';

  @override
  String get bookmarksMoveTitle => 'Переместить в группу';

  @override
  String get bookmarksNoGroup => 'Без группы';

  @override
  String bookmarksMoved(String group) {
    return 'Перемещено в группу: $group';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name, $details';
  }

  @override
  String get bookmarksEditorNameLabel => 'Название закладки';

  @override
  String get bookmarksEditorNameRequired =>
      'Введите название для этой закладки.';

  @override
  String get bookmarksEditorDuplicate =>
      'У вас уже есть закладка с таким названием для этой остановки и маршрута. Измените название, чтобы сохранить ещё одну.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Закладка остановки: показывает ближайшие отправления всех маршрутов на остановке $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Закладка рейса: показывает ближайшие отправления маршрута $route на остановке $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'Только маршрут $route';
  }

  @override
  String get bookmarksEditorGroup => 'Группа';

  @override
  String get bookmarksEditorNewGroup => 'Новая группа…';

  @override
  String get bookmarksEditorNewGroupTitle => 'Новая группа';

  @override
  String get bookmarksEditorGroupName => 'Название группы';

  @override
  String get bookmarksEditorSave => 'Сохранить';

  @override
  String get bookmarksEditorSaved => 'Закладка сохранена';

  @override
  String get bookmarksEditorDelete => 'Удалить закладку';

  @override
  String get bookmarksEditorDeleteTitle => 'Удалить эту закладку?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return 'Закладка «$name» будет удалена из ваших закладок.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Выберите регион, прежде чем добавлять закладки.';

  @override
  String get bookmarksManageGroupsHeader => 'Группы';

  @override
  String get bookmarksManageBookmarksHeader => 'Закладки';

  @override
  String get bookmarksManageAddGroup => 'Добавить группу';

  @override
  String get bookmarksManageRenameGroup => 'Переименовать группу';

  @override
  String get bookmarksManageDeleteGroup => 'Удалить группу';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'Закладки из группы «$name» окажутся вне групп.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Переместить выше: $name';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Переместить ниже: $name';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Изменить порядок: $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, позиция $position из $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'Пока нет закладок или групп для управления.';

  @override
  String get bookmarksManageUngrouped => 'Закладки без группы';

  @override
  String get recentsEmptyTitle => 'Нет недавних остановок';

  @override
  String get recentsEmptyBody =>
      'Остановки, которые вы просматриваете, появляются здесь, самые новые сверху.';

  @override
  String get recentsFindStops => 'Найти остановки на карте';

  @override
  String get recentsClearAll => 'Очистить все';

  @override
  String get recentsClearTitle => 'Очистить недавние остановки?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Будут удалены все $count недавние остановки. Ваши закладки не затрагиваются.',
      many:
          'Будут удалены все $count недавних остановок. Ваши закладки не затрагиваются.',
      few:
          'Будут удалены все $count недавние остановки. Ваши закладки не затрагиваются.',
      one:
          'Будет удалена $count недавняя остановка. Ваши закладки не затрагиваются.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Убрать из недавних остановок: $name';
  }

  @override
  String recentsRemoved(String name) {
    return 'Убрано: $name';
  }

  @override
  String get recentsSectionEmpty =>
      'Остановки, которые вы просматриваете, появляются здесь.';

  @override
  String get alarmsSectionTitle => 'Напоминания';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'За $minutes минуты до отправления',
      many: 'За $minutes минут до отправления',
      few: 'За $minutes минуты до отправления',
      one: 'За $minutes минуту до отправления',
    );
    return '$_temp0, в $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Напоминание для: $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'Удалить напоминание для: $title';
  }

  @override
  String get alarmsDeleted => 'Напоминание удалено';

  @override
  String get alarmsDeleteFailed =>
      'Не удалось удалить напоминание. Проверьте подключение и повторите попытку.';

  @override
  String get alarmsOpen => 'Открывает рейс';

  @override
  String get alertsEmptyTitle => 'Нет оповещений о движении';

  @override
  String get alertsEmptyBody => 'Сейчас нет действующих оповещений о движении.';

  @override
  String get alertsRegionNote =>
      'Включает оповещения для остановок из закладок, недавних и ближайших остановок.';

  @override
  String get alertsMarkAllRead => 'Отметить все как прочитанные';

  @override
  String get alertsAllRead => 'Все оповещения отмечены как прочитанные';

  @override
  String get alertsUnread => 'Непрочитано';

  @override
  String get alertsSeverityInfo => 'Информация';

  @override
  String get alertsSeverityWarning => 'Предупреждение';

  @override
  String get alertsSeveritySevere => 'Серьёзно';

  @override
  String get alertsSeverityUnknown => 'Оповещение о движении';

  @override
  String get alertsNoTitle => 'Оповещение о движении';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Непрочитано. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count непрочитанного оповещения',
      many: '$count непрочитанных оповещений',
      few: '$count непрочитанных оповещения',
      one: '$count непрочитанное оповещение',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ещё $count оповещения',
      many: 'ещё $count оповещений',
      few: 'ещё $count оповещения',
      one: 'ещё $count оповещение',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Период действия';

  @override
  String alertsDetailRange(String start, String end) {
    return 'С $start по $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'С $start';
  }

  @override
  String get alertsDetailAffects => 'Затрагивает';

  @override
  String get alertsDetailRoutes => 'Маршруты';

  @override
  String get alertsDetailStops => 'Остановки';

  @override
  String get alertsDetailAgencies => 'Агентства';

  @override
  String get alertsDetailLearnMore => 'Подробнее';

  @override
  String get alertsDetailNoDetails => 'Дополнительных сведений нет.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Опубликовано $date';
  }

  @override
  String get alertsCouldNotOpen => 'Не удалось открыть эту ссылку.';

  @override
  String get agenciesEmptyTitle => 'Нет агентств';

  @override
  String get agenciesEmptyBody =>
      'Этот регион не указал ни одного транспортного агентства.';

  @override
  String get agenciesWebsite => 'Сайт';

  @override
  String agenciesPhone(String phone) {
    return 'Позвонить: $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'Написать на $email';
  }

  @override
  String get agenciesFares => 'Информация о тарифах';

  @override
  String get agenciesDisclaimer => 'Отказ от ответственности';

  @override
  String get agenciesShowOnMap => 'Показать зону охвата на карте';

  @override
  String get searchFieldLabel => 'Поиск';

  @override
  String get searchFieldHint => 'Маршрут, номер остановки, адрес или транспорт';

  @override
  String get searchClear => 'Очистить поиск';

  @override
  String get searchScopeLabel => 'Искать';

  @override
  String get searchScopeAll => 'Всё';

  @override
  String get searchScopeStops => 'Остановки';

  @override
  String get searchScopeRoutes => 'Маршруты';

  @override
  String get searchScopePlaces => 'Места';

  @override
  String get searchQuickHeader => 'Искать';

  @override
  String searchQuickRoute(String query) {
    return 'Маршрут: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Номер остановки: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Адрес: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Транспорт: $query';
  }

  @override
  String get searchRecentStopsHeader => 'Недавние остановки';

  @override
  String get searchBookmarksHeader => 'Закладки';

  @override
  String get searchRecentSearchesHeader => 'Недавние запросы';

  @override
  String get searchRecentPlacesHeader => 'Недавние места';

  @override
  String get searchPlacesHeader => 'Места';

  @override
  String get searchClearRecent => 'Очистить недавние запросы';

  @override
  String get searchClearRecentConfirm => 'Очистить недавние запросы и места?';

  @override
  String get searchClearAction => 'Очистить';

  @override
  String get searchRecentCleared => 'Недавние запросы очищены';

  @override
  String get searchPlacesLoading => 'Поиск мест';

  @override
  String get searchPlacesNone => 'Места не найдены';

  @override
  String get searchPlacesError =>
      'Не удалось выполнить поиск мест. Проверьте подключение.';

  @override
  String get searchSearching => 'Поиск';

  @override
  String get searchNoResultsTitle => 'Нет результатов';

  @override
  String searchNoResultsBody(String query) {
    return 'По запросу «$query» ничего не найдено.';
  }

  @override
  String get searchUnavailableNoRegion => 'Выберите регион, прежде чем искать.';

  @override
  String get searchUnavailableAddress =>
      'Поиск по адресу не настроен в этом приложении.';

  @override
  String get searchUnavailableVehicle =>
      'Поиск транспорта недоступен в этом регионе.';

  @override
  String get searchEmptyTitle => 'Найдите маршруты, остановки и места';

  @override
  String get searchEmptyBody =>
      'Введите название маршрута, номер остановки, адрес или ID транспорта.';

  @override
  String get searchDismissMessage => 'Закрыть';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count результата по запросу «$query»',
      many: '$count результатов по запросу «$query»',
      few: '$count результата по запросу «$query»',
      one: '$count результат по запросу «$query»',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'Маршруты';

  @override
  String get searchResultsStops => 'Остановки';

  @override
  String get searchResultsVehicles => 'Транспорт';

  @override
  String get searchResultsPlaces => 'Места';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Маршрут $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Транспорт $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'Транспорт $id сейчас не выполняет рейс.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Загрузка данных о транспорте $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'Включите геолокацию, чтобы видеть отправления с ближайших остановок.';

  @override
  String get searchNearbyLocationButton => 'Использовать моё местоположение';

  @override
  String get searchNearbyLocationDenied =>
      'Доступ к геопозиции отключён. Включите его в настройках устройства, чтобы видеть остановки рядом.';

  @override
  String get searchNearbyLocationServicesOff =>
      'Службы геолокации отключены. Включите их, чтобы видеть остановки рядом.';

  @override
  String get searchNearbyLocationUnavailable =>
      'Это приложение не использует геолокацию, поэтому не может показать остановки рядом.';

  @override
  String get searchNearbyEmpty => 'Нет остановок рядом';

  @override
  String get searchNearbyEmptyBody =>
      'В пределах пешей доступности нет остановок.';

  @override
  String get searchNearbyMapCenter =>
      'Показаны остановки рядом с центром карты.';

  @override
  String get searchNearbyNoDepartures => 'Нет отправлений в ближайший час';

  @override
  String get searchNearbyLoadingDepartures => 'Загрузка отправлений';

  @override
  String get searchNearbyUpdated => 'Ближайшие отправления обновлены';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count остановки рядом',
      many: '$count остановок рядом',
      few: '$count остановки рядом',
      one: '$count остановка рядом',
      zero: 'Нет остановок рядом',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Определение вашего местоположения…';

  @override
  String get searchNearbyRefresh => 'Обновить';

  @override
  String searchNearbyDistance(String distance) {
    return '$distance от вас';
  }

  @override
  String get searchNearbyOtherDirection => 'Другие остановки';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return 'Остановки: $direction';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route до $headsign, $eta, $status. С остановки $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'С остановки $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Отправления рядом';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes мин.';
  }

  @override
  String get searchEtaNow => 'Сейчас';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'через $minutes минуты',
      many: 'через $minutes минут',
      few: 'через $minutes минуты',
      one: 'через $minutes минуту',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => 'отправляется сейчас';

  @override
  String get searchStatusOnTime => 'Вовремя';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'опоздание $minutes мин.',
      one: 'опоздание $minutes мин.',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'раньше на $minutes мин.',
      one: 'раньше на $minutes мин.',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => 'По расписанию';

  @override
  String get searchExplorePlanTrip => 'Спланировать поездку';

  @override
  String get searchExploreWeather => 'Погода';

  @override
  String get searchExploreAgencies => 'Агентства';

  @override
  String get searchPlaceAddress => 'Адрес';

  @override
  String get searchPlaceCoordinates => 'Координаты';

  @override
  String get searchPlaceDistance => 'Расстояние';

  @override
  String get searchPlaceDirectionsTo => 'Маршрут сюда';

  @override
  String get searchPlaceDirectionsFrom => 'Маршрут отсюда';

  @override
  String get searchPlaceNearbyStops => 'Остановки рядом';

  @override
  String get searchPlaceShare => 'Поделиться';

  @override
  String get searchPlaceOpenInMaps => 'Открыть в приложении карт';

  @override
  String get searchPlaceRemovePin => 'Удалить метку';

  @override
  String get searchPlaceOpenFailed => 'Не удалось открыть приложение карт.';

  @override
  String get searchPlaceShareFailed => 'Не удалось поделиться этим местом.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Место: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Погода: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Показывает прогноз';

  @override
  String get searchWeatherClear => 'Ясно';

  @override
  String get searchWeatherPartlyCloudy => 'Переменная облачность';

  @override
  String get searchWeatherCloudy => 'Облачно';

  @override
  String get searchWeatherRain => 'Дождь';

  @override
  String get searchWeatherSleet => 'Мокрый снег';

  @override
  String get searchWeatherSnow => 'Снег';

  @override
  String get searchWeatherWindy => 'Ветрено';

  @override
  String get searchWeatherFog => 'Туман';

  @override
  String get searchWeatherUnknown => 'Погодные условия неизвестны';

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
      other: '$value градуса по Фаренгейту',
      many: '$value градусов по Фаренгейту',
      few: '$value градуса по Фаренгейту',
      one: '$value градус по Фаренгейту',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value градуса Цельсия',
      many: '$value градусов Цельсия',
      few: '$value градуса Цельсия',
      one: '$value градус Цельсия',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherMph(int value) {
    return '$value миль/ч';
  }

  @override
  String searchWeatherKmh(int value) {
    return '$value км/ч';
  }

  @override
  String searchWeatherMps(int value) {
    return '$value м/с';
  }

  @override
  String searchWeatherPercent(int value) {
    return '$value%';
  }

  @override
  String get searchWeatherFeelsLike => 'Ощущается как';

  @override
  String get searchWeatherWind => 'Ветер';

  @override
  String get searchWeatherPrecip => 'Вероятность дождя';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'Макс. $high · Мин. $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'Максимум $high, минимум $low в ближайшие 24 часа';
  }

  @override
  String get searchWeatherHourly => 'Ближайшие 24 часа';

  @override
  String get searchWeatherNow => 'Сейчас';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, вероятность дождя $precip';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Температура: $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'градусы Фаренгейта (°F)';

  @override
  String get searchWeatherCelsius => 'градусы Цельсия (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Прогноз от $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'Прогноз погоды для этого региона недоступен.';

  @override
  String get searchWeatherSummaryLabel => 'Сегодня';

  @override
  String get bookmarksSectionEmpty => 'Остановки из закладок появляются здесь.';

  @override
  String get coreDirectionNameN => 'Север';

  @override
  String get coreDirectionNameNE => 'Северо-восток';

  @override
  String get coreDirectionNameE => 'Восток';

  @override
  String get coreDirectionNameSE => 'Юго-восток';

  @override
  String get coreDirectionNameS => 'Юг';

  @override
  String get coreDirectionNameSW => 'Юго-запад';

  @override
  String get coreDirectionNameW => 'Запад';

  @override
  String get coreDirectionNameNW => 'Северо-запад';

  @override
  String get coreDirectionAbbrN => 'С';

  @override
  String get coreDirectionAbbrNE => 'СВ';

  @override
  String get coreDirectionAbbrE => 'В';

  @override
  String get coreDirectionAbbrSE => 'ЮВ';

  @override
  String get coreDirectionAbbrS => 'Ю';

  @override
  String get coreDirectionAbbrSW => 'ЮЗ';

  @override
  String get coreDirectionAbbrW => 'З';

  @override
  String get coreDirectionAbbrNW => 'СЗ';

  @override
  String get coreDirectionBoundN => 'На север';

  @override
  String get coreDirectionBoundNE => 'На северо-восток';

  @override
  String get coreDirectionBoundE => 'На восток';

  @override
  String get coreDirectionBoundSE => 'На юго-восток';

  @override
  String get coreDirectionBoundS => 'На юг';

  @override
  String get coreDirectionBoundSW => 'На юго-запад';

  @override
  String get coreDirectionBoundW => 'На запад';

  @override
  String get coreDirectionBoundNW => 'На северо-запад';

  @override
  String get coreRouteTypeLightRail => 'Скоростной трамвай';

  @override
  String get coreRouteTypeSubway => 'Метро';

  @override
  String get coreRouteTypeRail => 'Железная дорога';

  @override
  String get coreRouteTypeBus => 'Автобус';

  @override
  String get coreRouteTypeFerry => 'Паром';

  @override
  String get coreRouteTypeCableCar => 'Канатный трамвай';

  @override
  String get coreRouteTypeGondola => 'Гондола';

  @override
  String get coreRouteTypeFunicular => 'Фуникулёр';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Остановка № $code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Остановка: \'$code\'';
  }

  @override
  String coreStopId(String code) {
    return 'ID остановки: $code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return 'Маршруты: $routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Маршруты: $routes, ещё $count',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return 'Поиск: $region';
  }

  @override
  String get coreNow => 'СЕЙЧАС';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String get coreOneMinute => 'Одна минута';

  @override
  String get coreOneMinuteAgo => 'Минуту назад';

  @override
  String coreMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes минуты',
      many: '$minutes минут',
      few: '$minutes минуты',
      one: '$minutes минута',
    );
    return '$_temp0';
  }

  @override
  String get coreJustNow => 'Только что';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds сек. назад';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes мин. назад';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours ч назад';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня назад',
      many: '$days дней назад',
      few: '$days дня назад',
      one: '$days день назад',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return 'Обновлено: $ago';
  }

  @override
  String get coreScheduledNotRealTime =>
      'По расписанию / не в реальном времени';

  @override
  String coreArrivedMinAgo(int minutes) {
    return 'Прибыл $minutes мин. назад';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return 'Отправился $minutes мин. назад';
  }

  @override
  String get coreArrivingNow => 'Прибывает сейчас';

  @override
  String get coreDepartingNow => 'Отправляется сейчас';

  @override
  String coreArrivesInMin(int minutes) {
    return 'Прибудет через $minutes мин.';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return 'Отправится через $minutes мин.';
  }

  @override
  String coreArrivedLate(int minutes) {
    return 'прибыл с опозданием $minutes мин.';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return 'прибыл раньше на $minutes мин.';
  }

  @override
  String get coreArrivedOnTime => 'прибыл вовремя';

  @override
  String coreDepartedLate(int minutes) {
    return 'отправился с опозданием $minutes мин.';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return 'отправился раньше на $minutes мин.';
  }

  @override
  String get coreDepartedOnTime => 'отправился вовремя';

  @override
  String coreArrivesLate(int minutes) {
    return 'прибудет с опозданием $minutes мин.';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return 'прибудет раньше на $minutes мин.';
  }

  @override
  String get coreArrivesOnTime => 'прибудет вовремя';

  @override
  String coreDepartsLate(int minutes) {
    return 'отправится с опозданием $minutes мин.';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return 'отправится раньше на $minutes мин.';
  }

  @override
  String get coreDepartsOnTime => 'отправится вовремя';

  @override
  String coreMeters(String value) {
    return '$value м';
  }

  @override
  String coreKilometers(String value) {
    return '$value км';
  }

  @override
  String coreFeet(String value) {
    return '$value фт';
  }

  @override
  String coreMiles(String value) {
    return '$value ми';
  }

  @override
  String coreAlarmMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes минуты',
      many: '$minutes минут',
      few: '$minutes минуты',
      one: '$minutes минута',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsNow => 'сейчас';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes мин';
  }

  @override
  String get arrivalsCanceled => 'отменён';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'каждые $minutes мин. с $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'каждые $minutes мин. до $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'На север';

  @override
  String get arrivalsDirectionBoundNE => 'На северо-восток';

  @override
  String get arrivalsDirectionBoundE => 'На восток';

  @override
  String get arrivalsDirectionBoundSE => 'На юго-восток';

  @override
  String get arrivalsDirectionBoundS => 'На юг';

  @override
  String get arrivalsDirectionBoundSW => 'На юго-запад';

  @override
  String get arrivalsDirectionBoundW => 'На запад';

  @override
  String get arrivalsDirectionBoundNW => 'На северо-запад';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'Направление: $code';
  }

  @override
  String get arrivalsRefresh => 'Обновить прибытия';

  @override
  String get arrivalsRetry => 'Повторить';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Нет прибытий в ближайшие $minutes мин.',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound =>
      'Остановка не найдена или сервис недоступен';

  @override
  String get arrivalsNetworkError =>
      'Не удалось связаться с сервером транспортных данных. Проверьте подключение.';

  @override
  String get arrivalsLoadError => 'Не удалось загрузить прибытия.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'Не удалось обновить. Показаны данные на $time';
  }

  @override
  String get arrivalsArrivingNow => 'прибывает сейчас';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'прибудет через $minutes минуты',
      many: 'прибудет через $minutes минут',
      few: 'прибудет через $minutes минуты',
      one: 'прибудет через $minutes минуту',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'в реальном времени';

  @override
  String get arrivalsRowTapHint => 'показать сведения';

  @override
  String arrivalsAtTime(String time) {
    return 'в $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'опоздание на $minutes минуты',
      many: 'опоздание на $minutes минут',
      few: 'опоздание на $minutes минуты',
      one: 'опоздание на $minutes минуту',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'раньше на $minutes минуты',
      many: 'раньше на $minutes минут',
      few: 'раньше на $minutes минуты',
      one: 'раньше на $minutes минуту',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'каждые $minutes минуты с $time',
      many: 'каждые $minutes минут с $time',
      few: 'каждые $minutes минуты с $time',
      one: 'каждые $minutes минуту с $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'каждые $minutes минуты до $time',
      many: 'каждые $minutes минут до $time',
      few: 'каждые $minutes минуты до $time',
      one: 'каждые $minutes минуту до $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'время по расписанию';

  @override
  String get arrivalsLoading => 'Загрузка прибытий';

  @override
  String get arrivalsRefreshing => 'Обновление прибытий';

  @override
  String get arrivalsUpdated => 'Прибытия обновлены';

  @override
  String get tripPlannerOriginLabel => 'Откуда';

  @override
  String get tripPlannerDestinationLabel => 'Куда';

  @override
  String get tripPlannerChooseOrigin => 'Выберите пункт отправления';

  @override
  String get tripPlannerChooseDestination => 'Выберите пункт назначения';

  @override
  String get tripPlannerCurrentLocation => 'Текущее местоположение';

  @override
  String get tripPlannerSwapEndpoints =>
      'Поменять местами пункт отправления и пункт назначения';

  @override
  String get tripPlannerPlanTrip => 'Спланировать поездку';

  @override
  String get tripPlannerPlanningTrip => 'Планирование поездки';

  @override
  String get tripPlannerOptions => 'Параметры поездки';

  @override
  String get tripPlannerLeaveNow => 'Выехать сейчас';

  @override
  String get tripPlannerDepartAt => 'Отправление в';

  @override
  String get tripPlannerArriveBy => 'Прибыть к';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Изменить время, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Транспорт';

  @override
  String get tripPlannerModeWalk => 'Пешком';

  @override
  String get tripPlannerModeBike => 'Велосипед';

  @override
  String get tripPlannerModeCar => 'Автомобиль';

  @override
  String get tripPlannerModeBikeRental => 'Только велопрокат';

  @override
  String get tripPlannerModeTransitBikeRental => 'Транспорт + велопрокат';

  @override
  String get tripPlannerWheelchairAccessible =>
      'Доступно для инвалидных колясок';

  @override
  String get tripPlannerWalkQuarterMile => '0,25 мили';

  @override
  String get tripPlannerWalkHalfMile => '0,5 мили';

  @override
  String get tripPlannerWalkOneMile => '1 миля';

  @override
  String get tripPlannerWalkTwoMiles => '2 мили';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'Пешком до $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'Поездки не найдены';

  @override
  String get tripPlannerRetry => 'Повторить';

  @override
  String get tripPlannerRealTime => 'В реальном времени';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes мин.';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours ч';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин.';
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
      other: '$count пересадки',
      many: '$count пересадок',
      few: '$count пересадки',
      one: '$count пересадка',
      zero: 'Без пересадок',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return 'Пешком $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Отправление в $time с: $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'Вовремя';

  @override
  String tripPlannerStatusLate(int minutes) {
    return 'опоздание $minutes мин.';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return 'раньше на $minutes мин.';
  }

  @override
  String get tripPlannerStatusScheduled => 'По расписанию';

  @override
  String get tripPlannerLegBus => 'Автобус';

  @override
  String get tripPlannerLegTram => 'Трамвай';

  @override
  String get tripPlannerLegSubway => 'Метро';

  @override
  String get tripPlannerLegRail => 'Поезд';

  @override
  String get tripPlannerLegFerry => 'Паром';

  @override
  String get tripPlannerLegCableCar => 'Канатный трамвай';

  @override
  String get tripPlannerLegGondola => 'Гондола';

  @override
  String get tripPlannerLegFunicular => 'Фуникулёр';

  @override
  String get tripPlannerLegAirplane => 'Самолёт';

  @override
  String get tripPlannerLegTrolleybus => 'Троллейбус';

  @override
  String get tripPlannerLegMonorail => 'Монорельс';

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
    return 'Пешком $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return 'На велосипеде $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return 'На прокатном велосипеде $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return 'На автомобиле $duration';
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
  String get tripPlannerThen => 'затем';

  @override
  String get tripPlannerOpenItineraryHint => 'показать сведения о поездке';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes минуты',
      many: '$minutes минут',
      few: '$minutes минуты',
      one: '$minutes минута',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours часа',
      many: '$hours часов',
      few: '$hours часа',
      one: '$hours час',
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
      other: '$value фута',
      many: '$value футов',
      few: '$value фута',
      one: '$value фут',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value мили',
      many: '$value миль',
      few: '$value мили',
      one: '$value миля',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value метра',
      many: '$value метров',
      few: '$value метра',
      one: '$value метр',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value километра',
      many: '$value километров',
      few: '$value километра',
      one: '$value километр',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return 'с $start до $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'в реальном времени, вовремя';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'в реальном времени, опоздание на $minutes минуты',
      many: 'в реальном времени, опоздание на $minutes минут',
      few: 'в реальном времени, опоздание на $minutes минуты',
      one: 'в реальном времени, опоздание на $minutes минуту',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'в реальном времени, раньше на $minutes минуты',
      many: 'в реальном времени, раньше на $minutes минут',
      few: 'в реальном времени, раньше на $minutes минуты',
      one: 'в реальном времени, раньше на $minutes минуту',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'время по расписанию';

  @override
  String get tripPlannerResultsHeading => 'Предлагаемые поездки';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count поездки',
      many: 'Найдено $count поездок',
      few: 'Найдено $count поездки',
      one: 'Найдена $count поездка',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count места',
      many: 'Найдено $count мест',
      few: 'Найдено $count места',
      one: 'Найдено $count место',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'Карта поездки. Указания ниже описывают ту же поездку.';

  @override
  String get tripPlannerTripDetails => 'Сведения о поездке';

  @override
  String get tripPlannerMapLabel => 'Карта поездки';

  @override
  String get tripPlannerStart => 'Начало';

  @override
  String get tripPlannerDestination => 'Пункт назначения';

  @override
  String get tripPlannerUnnamedPlace => 'Место без названия';

  @override
  String get tripPlannerRentalBike => 'Прокатный велосипед';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Идите до: $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Поезжайте на велосипеде до: $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Поезжайте на прокатном велосипеде до: $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Поезжайте на автомобиле до: $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Посадка: $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Посадка: $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Посадка: $mode, направление $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Посадка: $mode $route, направление $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Выход на: $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Прибытие: $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count остановки',
      many: '$count остановок',
      few: '$count остановки',
      one: '$count остановка',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Показать $count остановки',
      many: 'Показать $count остановок',
      few: 'Показать $count остановки',
      one: 'Показать $count остановку',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скрыть $count остановки',
      many: 'Скрыть $count остановок',
      few: 'Скрыть $count остановки',
      one: 'Скрыть $count остановку',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count шага',
      many: '$count шагов',
      few: '$count шага',
      one: '$count шаг',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Показать $count шага',
      many: 'Показать $count шагов',
      few: 'Показать $count шага',
      one: 'Показать $count шаг',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скрыть $count шага',
      many: 'Скрыть $count шагов',
      few: 'Скрыть $count шага',
      one: 'Скрыть $count шаг',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, около $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Начните движение';

  @override
  String get tripPlannerDirectionHardLeft => 'Резко поверните налево';

  @override
  String get tripPlannerDirectionLeft => 'Поверните налево';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'Возьмите левее';

  @override
  String get tripPlannerDirectionContinue => 'Продолжайте движение';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Возьмите правее';

  @override
  String get tripPlannerDirectionRight => 'Поверните направо';

  @override
  String get tripPlannerDirectionHardRight => 'Резко поверните направо';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Войдите на кольцо и двигайтесь по часовой стрелке';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Войдите на кольцо и двигайтесь против часовой стрелки';

  @override
  String get tripPlannerDirectionElevator => 'Воспользуйтесь лифтом';

  @override
  String get tripPlannerDirectionUturnLeft => 'Развернитесь налево';

  @override
  String get tripPlannerDirectionUturnRight => 'Развернитесь направо';

  @override
  String get tripPlannerDirectionEnterStation => 'Войдите на станцию';

  @override
  String get tripPlannerDirectionExitStation => 'Выйдите со станции';

  @override
  String get tripPlannerDirectionFollowSigns => 'Следуйте указателям';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Идите: $street, $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction: $street, пройдите $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Поиск места';

  @override
  String get tripPlannerSearchNoResults => 'Места не найдены';

  @override
  String get tripPlannerSearchError =>
      'Не удалось выполнить поиск мест. Повторите попытку.';

  @override
  String get tripPlannerUseCurrentLocation =>
      'Использовать текущее местоположение';

  @override
  String get tripPlannerLocationUnavailable =>
      'Не удалось определить ваше местоположение.';

  @override
  String get tripPlannerClearSearch => 'Очистить поиск';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Выберите пункт отправления и пункт назначения.';

  @override
  String get tripPlannerErrorNetwork =>
      'Не удалось связаться с планировщиком поездок. Проверьте подключение.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'Сервер вернул недопустимый ответ';

  @override
  String get tripPlannerErrorUnknown => 'Произошла неизвестная ошибка.';

  @override
  String get tripPlannerPlannerSystemError =>
      'Сейчас не удалось спланировать поездку. Повторите попытку.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'Планирование поездок временно недоступно. Повторите попытку чуть позже.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'Это место пока не поддерживается.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'Для этой поездки нет доступного маршрута.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'Сейчас нет доступных вариантов общественного транспорта.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'Это заняло больше времени, чем ожидалось. Повторите попытку.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'Что-то пошло не так с запросом. Повторите попытку.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'Не удалось найти пункт отправления.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'Не удалось найти пункт назначения.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'Не удалось найти ни пункт отправления, ни пункт назначения.';

  @override
  String get tripPlannerPlannerTooClose =>
      'Пункты отправления и назначения слишком близко друг к другу.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'Этот маршрут недоступен при выбранном параметре.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'Пункт отправления определён неоднозначно. Попробуйте уточнить его.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'Пункт назначения определён неоднозначно. Попробуйте уточнить его.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Оба места нужно описать подробнее. Попробуйте их уточнить.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'Не хватает некоторых параметров маршрута.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'Выбранные параметры маршрута несовместимы.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Выберите предпочтение для маршрута.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Измените предпочтения для маршрута.';
}
