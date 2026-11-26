// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class ObaLocalizationsFil extends ObaLocalizations {
  ObaLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get commonBack => 'Bumalik';

  @override
  String get commonClose => 'Isara';

  @override
  String get commonDone => 'Tapos na';

  @override
  String get commonCancel => 'Kanselahin';

  @override
  String get commonRetry => 'Subukang muli';

  @override
  String get commonContinue => 'Magpatuloy';

  @override
  String get commonNotNow => 'Huwag muna';

  @override
  String get commonSeeAll => 'Tingnan lahat';

  @override
  String get commonLoading => 'Naglo-load';

  @override
  String get commonErrorTitle => 'May nangyaring mali';

  @override
  String get commonOffline =>
      'Mukhang offline ka. Tingnan ang iyong koneksyon at subukang muli.';

  @override
  String get commonServerError =>
      'Hindi tumugon ang server gaya ng inaasahan. Subukang muli sa ilang sandali.';

  @override
  String get sheetLabel => 'Panel';

  @override
  String get sheetExpand => 'Palawakin ang panel';

  @override
  String get sheetCollapse => 'I-collapse ang panel';

  @override
  String get sheetHandleHint =>
      'I-drag o i-double-tap para baguhin ang laki ng panel';

  @override
  String get homeTabHome => 'Home';

  @override
  String get homeTabRecent => 'Kamakailan';

  @override
  String get homeTabBookmarks => 'Mga Bookmark';

  @override
  String get homeSearchPlaceholder => 'Maghanap ng hintuan, ruta, lugar';

  @override
  String get homeSearchLabel => 'Hanapin';

  @override
  String get homeSectionNearby => 'Malapit';

  @override
  String get homeSectionRecent => 'Mga kamakailang hintuan';

  @override
  String get homeSectionBookmarks => 'Mga Bookmark';

  @override
  String get homeSectionAlerts => 'Mga Alerto';

  @override
  String get homeSectionExplore => 'Mag-explore';

  @override
  String get homeSectionMore => 'Mga setting at iba pa';

  @override
  String get mapLabel => 'Mapa';

  @override
  String get mapZoomInForStops => 'Mag-zoom in para makita ang mga hintuan';

  @override
  String get mapLocationDenied =>
      'Naka-off ang access sa lokasyon. I-tap para payagan.';

  @override
  String get mapLocationServicesOff => 'Naka-off ang mga serbisyo ng lokasyon';

  @override
  String get mapRecenter => 'Ipakita ang aking lokasyon';

  @override
  String get mapSettingsButton => 'Mga setting ng mapa';

  @override
  String get mapStopsListButton => 'Mga hintuan sa mapa';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hintuan sa mapa',
      one: '$count hintuan sa mapa',
      zero: 'Walang hintuan sa mapa',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'Iyong lokasyon';

  @override
  String get mapDroppedPin => 'Nakalagay na pin';

  @override
  String get mapVehicle => 'Sasakyan';

  @override
  String get mapBookmarkedStop => 'Naka-bookmark';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, hintuan ng $routeType';
  }

  @override
  String get mapStopMarkerHint => 'Binubuksan ang mga pag-alis ng hintuan';

  @override
  String mapAttribution(String attribution) {
    return 'Data ng mapa: $attribution';
  }

  @override
  String get mapTypeTitle => 'Uri ng mapa';

  @override
  String get mapTypeStandard => 'Standard';

  @override
  String get mapTypeSatellite => 'Satellite';

  @override
  String get mapTypeHybrid => 'Hybrid';

  @override
  String get mapShowHeading => 'Ipakita ang heading';

  @override
  String get directionN => 'Pa-hilaga';

  @override
  String get directionNE => 'Pa-hilagang-silangan';

  @override
  String get directionE => 'Pa-silangan';

  @override
  String get directionSE => 'Pa-timog-silangan';

  @override
  String get directionS => 'Pa-timog';

  @override
  String get directionSW => 'Pa-timog-kanluran';

  @override
  String get directionW => 'Pa-kanluran';

  @override
  String get directionNW => 'Pa-hilagang-kanluran';

  @override
  String get routeTypeBus => 'Bus';

  @override
  String get routeTypeLightRail => 'Light rail';

  @override
  String get routeTypeSubway => 'Subway';

  @override
  String get routeTypeRail => 'Tren';

  @override
  String get routeTypeFerry => 'Ferry';

  @override
  String get routeTypeCableCar => 'Cable car';

  @override
  String get routeTypeGondola => 'Gondola';

  @override
  String get routeTypeFunicular => 'Funicular';

  @override
  String get routeTypeUnknown => 'Transit';

  @override
  String stopCode(String code) {
    return 'Hintuan $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'Mga ruta $routes';
  }

  @override
  String get stopPageRefresh => 'I-refresh';

  @override
  String get stopPageRefreshed => 'Na-update ang mga pag-alis';

  @override
  String get stopPageBookmark => 'I-bookmark ang hintuan';

  @override
  String get stopPageBookmarked => 'Naka-bookmark. I-edit ang bookmark';

  @override
  String get stopPageMoreActions => 'Higit pang aksyon sa hintuan';

  @override
  String get stopPageSchedules => 'Mga iskedyul';

  @override
  String get stopPageServiceAlerts => 'Mga alerto sa serbisyo';

  @override
  String get stopPageNearbyStops => 'Mga kalapit na hintuan';

  @override
  String get stopPageWalkingDirections => 'Mga direksyon sa paglalakad';

  @override
  String get stopPageBikeDirections => 'Mga direksyon sa pagbibisikleta';

  @override
  String get stopPagePlanTripFrom => 'Magplano ng biyahe mula rito';

  @override
  String get stopPagePlanTripTo => 'Magplano ng biyahe papunta rito';

  @override
  String get stopPageShareStop => 'Ibahagi ang hintuan';

  @override
  String get stopPageReportProblem => 'Mag-ulat ng problema';

  @override
  String get stopPageFilterRoutes => 'I-filter ang mga ruta';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ruta ang nakatago',
      one: '$count ruta ang nakatago',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'Ayon sa oras';

  @override
  String get stopPageModeRoute => 'Ayon sa ruta';

  @override
  String get stopPageDepartureTypes => 'Mga uri ng pag-alis';

  @override
  String get stopPageFilterAll => 'Lahat ng pag-alis';

  @override
  String get stopPageFilterRealtime => 'Real-time lang';

  @override
  String get stopPageFilterScheduled => 'Nakaiskedyul lang';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ipakita ang $count nakaraang pag-alis',
      one: 'Ipakita ang $count nakaraang pag-alis',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Itago ang mga nakaraang pag-alis';

  @override
  String get stopPageLoadMore => 'Mag-load pa ng mga pag-alis';

  @override
  String stopPageWindow(int minutes) {
    return 'Ipinapakita ang susunod na $minutes minuto';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Na-update $ago';
  }

  @override
  String get stopPageStaleTitle => 'Hindi ma-refresh ang mga pag-alis';

  @override
  String get stopPageStaleBody => 'Maaaring luma na ang mga oras na ito.';

  @override
  String get stopPageEmptyTitle => 'Walang paparating na pag-alis';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'Walang aalis sa susunod na $minutes minuto.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Nakatago ang bawat rutang may pag-alis dito.';

  @override
  String get stopPageShowAllRoutes => 'Ipakita ang lahat ng ruta';

  @override
  String get stopPageEmptyFilter =>
      'Walang pag-alis na tumutugma sa filter ng uri ng pag-alis.';

  @override
  String get stopPageShowAllTypes => 'Ipakita ang lahat ng pag-alis';

  @override
  String get stopPageMissingTitle => 'Hindi nahanap ang hintuan';

  @override
  String get stopPageMissingBody =>
      'Maaaring inalis o binago ang numero ng hintuang ito.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes min na lakad';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes min na sakay';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutong lakad',
      one: '$minutes minutong lakad',
    );
    return '$_temp0, $distance. Binubuksan ang mga direksyon.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutong sakay',
      one: '$minutes minutong sakay',
    );
    return '$_temp0, $distance. Binubuksan ang mga direksyon.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '$minutes min na lakad papunta sa hintuang ito. Mas maagang aalis ang mga pag-alis sa itaas.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '$minutes min na sakay papunta sa hintuang ito. Mas maagang aalis ang mga pag-alis sa itaas.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Serbisyo ng $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alerto sa serbisyo',
      one: '$count alerto sa serbisyo',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hindi pa nababasa',
      one: '$count hindi pa nababasa',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Hindi pa nababasa';

  @override
  String get stopPageAlertImportant => 'Mahalaga';

  @override
  String get stopPageDirectionsChooser => 'Buksan ang mga direksyon sa';

  @override
  String get stopPageAppleMaps => 'Apple Maps';

  @override
  String get stopPageGoogleMaps => 'Google Maps';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Lipat mula sa $route $headsign, darating $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Mga pag-alis';

  @override
  String get stopRowNow => 'NGAYON';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes min ang nakalipas';
  }

  @override
  String get stopRowOnTime => 'nasa oras';

  @override
  String stopRowLate(int minutes) {
    return '$minutes min na huli';
  }

  @override
  String stopRowEarly(int minutes) {
    return '$minutes min na maaga';
  }

  @override
  String get stopRowScheduled => 'nakaiskedyul';

  @override
  String get stopRowCanceled => 'kanselado';

  @override
  String get stopRowOccupancyEmpty => 'Walang laman';

  @override
  String get stopRowOccupancyManySeats => 'Maraming bakanteng upuan';

  @override
  String get stopRowOccupancyFewSeats => 'Kaunting bakanteng upuan';

  @override
  String get stopRowOccupancyStanding => 'Standing room lang';

  @override
  String get stopRowOccupancyCrushed => 'Siksikan';

  @override
  String get stopRowOccupancyFull => 'Puno';

  @override
  String get stopRowOccupancyNotAccepting => 'Hindi tumatanggap ng pasahero';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'darating sa loob ng $minutes minuto',
      one: 'darating sa loob ng $minutes minuto',
      zero: 'darating na ngayon',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'aalis sa loob ng $minutes minuto',
      one: 'aalis sa loob ng $minutes minuto',
      zero: 'aalis na ngayon',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'dumating $minutes minuto ang nakalipas',
      one: 'dumating $minutes minuto ang nakalipas',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'umalis $minutes minuto ang nakalipas',
      one: 'umalis $minutes minuto ang nakalipas',
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
    return 'Rutang $route papuntang $headsign, $eta, sa $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'live na pagsubaybay, $status';
  }

  @override
  String get stopRowA11yScheduledOnly =>
      'nakaiskedyul na oras lang, walang live data';

  @override
  String get stopRowA11yTransfer => 'ang iyong biyaheng lilipatan';

  @override
  String get stopRowA11yMissed =>
      'malamang na hindi maabutan, aalis ito bago ka makarating doon sa paglalakad';

  @override
  String get stopRowA11yAlarm => 'may nakatakdang paalala';

  @override
  String stopRowActions(String route) {
    return 'Higit pang aksyon para sa rutang $route';
  }

  @override
  String get stopRowShowTrip => 'Ipakita ang mga detalye ng biyahe';

  @override
  String get stopRowAddAlarm => 'Magdagdag ng paalala';

  @override
  String get stopRowRemoveAlarm => 'Alisin ang paalala';

  @override
  String get stopRowBookmarkTrip => 'I-bookmark ang biyaheng ito';

  @override
  String get stopRowShareTrip => 'Ibahagi ang biyahe';

  @override
  String get stopRowRouteSchedule => 'Iskedyul ng ruta';

  @override
  String get stopRowRouteStops => 'Mga hintuan sa rutang ito';

  @override
  String stopRouteGroupNext(String times) {
    return 'Susunod: $times';
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
      other: '$count pag-alis',
      one: '$count pag-alis',
    );
    return 'Rutang $route papuntang $headsigns, $_temp0, susunod $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Paalalahanan ako bago ito umalis';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuto bago',
      one: '$minutes minuto bago',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Nakatakda ang paalala $minutes minuto bago',
      one: 'Nakatakda ang paalala $minutes minuto bago',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Naalis ang paalala';

  @override
  String get stopAlarmFailed => 'Hindi ma-update ang paalala.';

  @override
  String get stopAlarmPermissionDenied =>
      'Naka-off ang mga notification para sa app na ito.';

  @override
  String get stopFilterTitle => 'I-filter ang mga ruta';

  @override
  String get stopFilterSort => 'I-sort ang mga pag-alis';

  @override
  String get stopFilterRoutesHeader => 'Mga rutang ipinapakita sa hintuang ito';

  @override
  String get stopFilterShowAll => 'Ipakita ang lahat ng ruta';

  @override
  String get stopTripArrivingAtYourStop => 'Paparating na sa iyong hintuan';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hintuan ang layo',
      one: '$count hintuan ang layo',
      zero: 'Nasa iyong hintuan',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return '$distance ang layo';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'Sa $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Na-update ang posisyon $ago';
  }

  @override
  String get stopTripNoPosition =>
      'Walang real-time na posisyon para sa sasakyang ito';

  @override
  String stopTripStartsAs(String trip) {
    return 'Nagsisimula bilang $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Nagpapatuloy bilang $trip';
  }

  @override
  String get stopTripStopsHeader => 'Mga hintuan';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hintuang nadaanan',
      one: '$count hintuang nadaanan',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hintuan bago ang iyong hintuan',
      one: '$count hintuan bago ang iyong hintuan',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'Iyong hintuan';

  @override
  String get stopTripBoarding => 'Sumasakay';

  @override
  String get stopTripVehicleHere => 'Nandito na ang sasakyan';

  @override
  String get stopTripTerminal => 'Huling hintuan';

  @override
  String get stopTripPassed => 'Nadaanan na';

  @override
  String get stopTripRouteStops => 'Lahat ng hintuan sa rutang ito';

  @override
  String get stopTripReport => 'Mag-ulat ng problema sa biyaheng ito';

  @override
  String get stopTripGhostBus => 'Iulat ang ghost bus';

  @override
  String get stopTripCanceled => 'Kanselado ang biyaheng ito';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Sasakyan sa rutang $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'Kada $minutes min';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Ruta $route';
  }

  @override
  String get stopRouteStopsDirection => 'Direksyon';

  @override
  String stopRouteStopsToward(String name) {
    return 'Papuntang $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hintuan',
      one: '$count hintuan',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty =>
      'Walang nahanap na hintuan para sa rutang ito.';

  @override
  String get stopSchedPrevDay => 'Nakaraang araw';

  @override
  String get stopSchedNextDay => 'Susunod na araw';

  @override
  String stopSchedPickDate(String date) {
    return 'Pumili ng petsa, $date';
  }

  @override
  String get stopSchedRoute => 'Ruta';

  @override
  String get stopSchedDirection => 'Direksyon';

  @override
  String get stopSchedStop => 'Hintuan';

  @override
  String get stopSchedEmpty =>
      'Walang nakaiskedyul na serbisyo sa araw na ito.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'Kada $minutes min mula $start hanggang $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'Papuntang $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pag-alis',
      one: '$count pag-alis',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported =>
      'Hindi available ang mga timetable sa rehiyong ito.';

  @override
  String get stopSchedViewList => 'Listahan';

  @override
  String get stopSchedViewGrid => 'Grid';

  @override
  String get stopSchedNoDeparture => 'Walang pag-alis';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (iyong hintuan)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, biyahe $trip: $time';
  }

  @override
  String get stopReportProblemHeader => 'Ano ang tila problema?';

  @override
  String get stopReportStopNameWrong => 'Mali ang pangalan ng hintuan';

  @override
  String get stopReportStopNumberWrong => 'Mali ang numero ng hintuan';

  @override
  String get stopReportStopLocationWrong => 'Nasa maling lugar ang hintuan';

  @override
  String get stopReportRouteMissing => 'May nawawalang ruta o biyahe';

  @override
  String get stopReportOther => 'Iba pa';

  @override
  String get stopReportNeverCame => 'Hindi dumating ang sasakyan';

  @override
  String get stopReportCameEarly => 'Dumating itong maaga';

  @override
  String get stopReportCameLate => 'Dumating itong huli';

  @override
  String get stopReportWrongHeadsign => 'Mali ang headsign';

  @override
  String get stopReportNotStopHere => 'Hindi ito huminto rito';

  @override
  String get stopReportComment => 'Karagdagang komento (opsyonal)';

  @override
  String get stopReportShareLocation => 'Ibahagi ang aking lokasyon';

  @override
  String get stopReportShareLocationHelp =>
      'Makakatulong ang pagbabahagi ng iyong lokasyon sa iyong transit agency na ayusin ang problemang ito.';

  @override
  String get stopReportOnVehicle => 'Nasa sasakyang ito ako';

  @override
  String get stopReportVehicleId => 'Numero ng sasakyan (opsyonal)';

  @override
  String get stopReportSend => 'Ipadala ang ulat';

  @override
  String get stopReportSending => 'Ipinapadala ang ulat';

  @override
  String get stopReportSent => 'Salamat! Naipadala ang iyong ulat.';

  @override
  String get stopReportFailed => 'Hindi maipadala ang ulat. Pakisubukang muli.';

  @override
  String get stopReportChooseProblem => 'Pumili muna ng problema.';

  @override
  String stopReportAbout(String name) {
    return 'Nag-uulat: $name';
  }

  @override
  String get stopGhostTitle => 'Iulat ang ghost bus';

  @override
  String get stopGhostExplain =>
      'Ang ghost bus ay bus na ipinakita ng app pero hindi kailanman dumating.';

  @override
  String get stopGhostWait =>
      'Gaano ka katagal naghintay lampas sa nakaiskedyul na oras?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30+ min';

  @override
  String get stopCardEmpty => 'Walang pag-alis sa lalong madaling panahon';

  @override
  String get titleSearch => 'Hanapin';

  @override
  String get titleSearchResults => 'Mga resulta';

  @override
  String get titleNearbyStops => 'Mga kalapit na hintuan';

  @override
  String get titleRecentStops => 'Mga kamakailang hintuan';

  @override
  String get titleBookmarks => 'Mga Bookmark';

  @override
  String get titleStop => 'Hintuan';

  @override
  String get titleTrip => 'Biyahe';

  @override
  String get titleRouteStops => 'Ruta';

  @override
  String get titleStopSchedule => 'Iskedyul';

  @override
  String get titleRouteSchedule => 'Iskedyul ng ruta';

  @override
  String get titleAlerts => 'Mga Alerto';

  @override
  String get titleAlertDetail => 'Alerto';

  @override
  String get titleAgencies => 'Mga Ahensya';

  @override
  String get titleRegionPicker => 'Mga Rehiyon';

  @override
  String get titleCustomRegion => 'Custom na rehiyon';

  @override
  String get titleSettings => 'Mga Setting';

  @override
  String get titleMapSettings => 'Mga setting ng mapa';

  @override
  String get titleMore => 'Higit pa';

  @override
  String get titleTripPlanner => 'Magplano ng biyahe';

  @override
  String get titlePlace => 'Lugar';

  @override
  String get titleReportStopProblem => 'Mag-ulat ng problema';

  @override
  String get titleReportTripProblem => 'Mag-ulat ng problema';

  @override
  String get titleBookmarkEditor => 'Bookmark';

  @override
  String get titleManageBookmarks => 'I-edit ang mga bookmark';

  @override
  String get titleCredits => 'Mga Kredito';

  @override
  String get titleWeather => 'Panahon';

  @override
  String get titleStopsOnMap => 'Mga hintuan sa mapa';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Maligayang pagdating sa $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Mga real-time na pagdating para sa mga bus, tren, at ferry malapit sa iyo.';

  @override
  String get onboardingLocationTitle =>
      'Hanapin ang mga hintuan malapit sa iyo';

  @override
  String get onboardingLocationBody =>
      'Payagan ang access sa lokasyon para makita ang mga kalapit na hintuan at awtomatikong mapili ang iyong rehiyon.';

  @override
  String get onboardingAllowLocation => 'Payagan ang access sa lokasyon';

  @override
  String get onboardingRegionTitle => 'Piliin ang iyong rehiyon';

  @override
  String get onboardingRegionBody =>
      'Piliin ang lugar na gusto mong makita ang transit.';

  @override
  String get settingsSectionMap => 'Mapa';

  @override
  String get settingsMapTypeRow => 'Uri ng mapa at mga layer';

  @override
  String get settingsMapTypeHelp => 'Piliin kung paano lumalabas ang mapa.';

  @override
  String get settingsHeadingHelp =>
      'Ipinapakita ang direksyong kinakaharap mo sa mapa.';

  @override
  String get settingsWalkingDirections => 'Mga direksyon sa paglalakad';

  @override
  String get settingsWalkingDirectionsHelp =>
      'Ang app na bubukas kapag humingi ka ng mga direksyon sa paglalakad papunta sa isang hintuan.';

  @override
  String get settingsDirectionsAsk => 'Magtanong tuwing gagamitin';

  @override
  String get settingsDirectionsAppleMaps => 'Apple Maps';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Maps';

  @override
  String get settingsSectionDepartures => 'Mga pag-alis';

  @override
  String get settingsDepartureFilter => 'Ipakita ang mga pag-alis';

  @override
  String get settingsDepartureFilterHelp =>
      'Piliin kung ililista ng mga pahina ng hintuan ang lahat ng pag-alis o ang mga may real-time o nakaiskedyul na data lang.';

  @override
  String get settingsFilterAll => 'Lahat ng pag-alis';

  @override
  String get settingsFilterRealtime => 'Real-time lang';

  @override
  String get settingsFilterScheduled => 'Nakaiskedyul lang';

  @override
  String get settingsSectionAccessibility => 'Accessibility';

  @override
  String get settingsReducedColors =>
      'Bawasan ang mga kulay sa mga pahina ng hintuan';

  @override
  String get settingsReducedColorsHelp =>
      'Ipinapakita ang mga badge ng ruta sa iisang neutral na istilo.';

  @override
  String get settingsSectionWalking => 'Bilis ng paglalakad';

  @override
  String get settingsWalkingSpeed => 'Bilis ng paglalakad';

  @override
  String get settingsWalkingSpeedHelp =>
      'Ginagamit para sa mga pagtatantya ng oras ng paglalakad at oras ng pagdating.';

  @override
  String get settingsSpeedSlow => 'Mabagal';

  @override
  String get settingsSpeedAverage => 'Katamtaman';

  @override
  String get settingsSpeedFast => 'Mabilis';

  @override
  String settingsSpeedCustom(String speed) {
    return 'Custom ($speed m/s)';
  }

  @override
  String get settingsSectionBike => 'Bike mode';

  @override
  String get settingsBikeMode => 'Bike mode';

  @override
  String get settingsBikeModeHelp =>
      'Gumagamit ng mas mabilis na bilis ng paglalakbay para sa mga pagtatantya ng oras ng paglalakad, oras ng pagdating, at pahina ng hintuan.';

  @override
  String get settingsSectionSurveys => 'Mga survey';

  @override
  String get settingsSurveysEnabled => 'Ipakita ang mga survey';

  @override
  String get settingsSurveysAlways =>
      'Palaging ipakita ang mga survey sa mga hintuan';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsAnalytics =>
      'Magpadala ng data ng paggamit sa mga developer';

  @override
  String get settingsAnalyticsHelp =>
      'Tumutulong sa mga developer na makita kung aling mga feature ang ginagamit.';

  @override
  String get settingsSectionDebug => 'Debug';

  @override
  String get settingsDebugMode => 'Debug mode';

  @override
  String get settingsDebugAlwaysFeedback =>
      'Palaging ipakita ang prompt ng feedback';

  @override
  String get settingsDebugResetFeedback =>
      'I-reset ang estado ng prompt ng feedback';

  @override
  String get settingsDebugResetDonation =>
      'I-reset ang estado ng card ng donasyon';

  @override
  String get settingsDebugResetDone => 'Na-reset';

  @override
  String get settingsSectionTripPlanner => 'Trip planner';

  @override
  String get settingsHomeCustomizeMap => 'I-customize ang mapa';

  @override
  String get moreHeaderSupport =>
      'Ang app na ito ay ginawa at sinusuportahan ng mga boluntaryo.';

  @override
  String get moreSectionDonate => 'Maging supporter';

  @override
  String moreDonate(String appName) {
    return 'Mag-donate sa $appName';
  }

  @override
  String get moreManageDonations => 'Pamahalaan ang mga donasyon';

  @override
  String get moreSectionUpdates => 'Mga update at alerto';

  @override
  String get moreAlerts => 'Mga Alerto';

  @override
  String get moreSectionLocation => 'Aking lokasyon';

  @override
  String get moreRegion => 'Rehiyon';

  @override
  String get moreRegionNone => 'Hindi napili';

  @override
  String get morePayFare => 'Bayaran ang aking pamasahe';

  @override
  String get moreAgencies => 'Mga Ahensya';

  @override
  String get moreSectionAbout => 'Tungkol sa app na ito';

  @override
  String moreRateApp(String appName) {
    return 'I-rate ang $appName';
  }

  @override
  String get moreContactUs => 'Makipag-ugnayan sa amin';

  @override
  String get morePrivacy => 'Patakaran sa privacy';

  @override
  String get moreCredits => 'Mga Kredito';

  @override
  String moreVersion(String appName, String version) {
    return '$appName bersyon $version';
  }

  @override
  String get moreSectionHelpOut => 'Tumulong gawing mas maganda ang app';

  @override
  String get moreTranslate => 'Tumulong sa pagsasalin ng app';

  @override
  String get moreDevelop =>
      'Tumulong mag-ayos ng mga bug at bumuo ng mga bagong feature';

  @override
  String get moreSectionContact => 'Makipag-ugnayan at tulong';

  @override
  String get moreTutorials => 'Mga tutorial';

  @override
  String get moreCallAgency => 'Tawagan ang ahensya';

  @override
  String get moreTextAgency => 'Padalhan ng mensahe ang ahensya';

  @override
  String get moreSectionResources => 'Mga resource';

  @override
  String get moreContactTitle => 'Makipag-ugnayan sa amin';

  @override
  String get moreContactDevelopers => 'Kahilingan ng feature o ulat ng bug';

  @override
  String get moreContactAgency => 'Problema sa sasakyan o iskedyul';

  @override
  String moreEmailSubject(String appName) {
    return 'Feedback sa $appName';
  }

  @override
  String get moreEmailAgencySubject => 'Feedback ng sumasakay sa transit';

  @override
  String get moreEmailIntro =>
      'Paano kami makakatulong? Pakilagay ang iyong tugon sa ibaba:';

  @override
  String get moreEmailDebugIntro =>
      'Ibinibigay ang sumusunod na impormasyon para sa layunin ng pag-troubleshoot. Kung hindi ka komportableng ibahagi ang alinman dito, maaari mo itong alisin, ngunit maaari nitong maapektuhan ang kakayahan naming tulungan ka.';

  @override
  String get moreDebugAppVersion => 'Bersyon ng app';

  @override
  String get moreDebugOs => 'Operating system';

  @override
  String get moreDebugLocale => 'Wika';

  @override
  String get moreDebugBookmarks => 'Bilang ng bookmark';

  @override
  String get moreDebugLocationPermission => 'Pahintulot sa lokasyon';

  @override
  String get moreDebugRegion => 'Rehiyon';

  @override
  String get moreDebugRegionId => 'ID ng rehiyon';

  @override
  String get moreDebugApiUrl => 'Base API URL';

  @override
  String get moreDebugUserId => 'User ID';

  @override
  String get moreCantEmailTitle => 'Hindi mabuksan ang iyong email app';

  @override
  String moreCantEmailBody(String email) {
    return 'Para makipag-ugnayan sa amin, magpadala ng email sa $email. Kopyahin ang debug information at i-paste ito sa iyong mensahe para matulungan kaming ayusin ang problema.';
  }

  @override
  String get moreCopyEmail => 'Kopyahin ang email address';

  @override
  String get moreCopyDebug => 'Kopyahin ang debug info';

  @override
  String get moreCopied => 'Nakopya sa clipboard';

  @override
  String get moreFareContinue => 'Magpatuloy';

  @override
  String get moreFareDontShowAgain => 'Magpatuloy at huwag nang ipakita muli';

  @override
  String get commonCantOpenLink => 'Hindi mabuksan ang link na iyon.';

  @override
  String get regionPickerAutomatic => 'Awtomatikong piliin ang rehiyon';

  @override
  String get regionPickerAutomaticHelp =>
      'Lumilipat sa rehiyong naglalaman ng iyong lokasyon. Mag-o-off ito kapag ikaw mismo ang pumili ng rehiyon.';

  @override
  String get regionPickerShowExperimental =>
      'Ipakita ang mga experimental na rehiyon';

  @override
  String get regionPickerShowInactive =>
      'Ipakita ang mga hindi aktibong rehiyon';

  @override
  String get regionPickerRegionsSection => 'Mga Rehiyon';

  @override
  String get regionPickerCustomSection => 'Mga custom na rehiyon';

  @override
  String get regionPickerCurrent => 'Kasalukuyang rehiyon';

  @override
  String get regionPickerExperimentalTag => 'Experimental';

  @override
  String get regionPickerInactiveTag => 'Hindi aktibo';

  @override
  String get regionPickerCustomTag => 'Custom';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Magdagdag ng custom na rehiyon';

  @override
  String get regionPickerRefresh => 'I-refresh ang mga rehiyon';

  @override
  String get regionPickerRefreshed => 'Na-update ang mga rehiyon';

  @override
  String get regionPickerRefreshFailed =>
      'Hindi ma-update ang listahan ng mga rehiyon. Ipinapakita ang naka-save na listahan.';

  @override
  String regionPickerSelected(String name) {
    return 'Napili ang $name';
  }

  @override
  String regionPickerEdit(String name) {
    return 'I-edit ang $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'I-delete ang $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'I-delete ang $name?';
  }

  @override
  String get regionPickerDeleteBody =>
      'Aalisin ang custom na rehiyong ito sa device na ito.';

  @override
  String get regionPickerDeleteConfirm => 'I-delete';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Pumili ng ibang rehiyon bago i-delete ang isang ito.';

  @override
  String get regionPickerEmpty => 'Walang available na rehiyon';

  @override
  String get regionPickerEmptyBody =>
      'I-on ang mga experimental o hindi aktibong rehiyon, o magdagdag ng custom na rehiyon.';

  @override
  String get regionPickerTripPlanner => 'Trip planner sa rehiyong ito';

  @override
  String get customRegionEditTitle => 'I-edit ang custom na rehiyon';

  @override
  String get customRegionName => 'Pangalan';

  @override
  String get customRegionObaUrl => 'URL ng OneBusAway server';

  @override
  String get customRegionObaUrlHelp =>
      'Ang address ng server, halimbawa https://oba.example.com/';

  @override
  String get customRegionSidecar => 'URL ng Sidecar server (opsyonal)';

  @override
  String get customRegionOtp => 'URL ng trip planner (opsyonal)';

  @override
  String get customRegionOtpGraphql => 'GraphQL URL ng trip planner (opsyonal)';

  @override
  String get customRegionServiceArea => 'Lugar na sineserbisyuhan';

  @override
  String get customRegionServiceAreaHelp =>
      'Ang lugar na sakop ng rehiyong ito: isang gitnang punto at kung gaano ito kalayo umaabot.';

  @override
  String get customRegionLatitude => 'Latitude ng sentro';

  @override
  String get customRegionLongitude => 'Longitude ng sentro';

  @override
  String get customRegionLatSpan => 'Sakop ng latitude (degrees)';

  @override
  String get customRegionLonSpan => 'Sakop ng longitude (degrees)';

  @override
  String get customRegionUseMap => 'Gamitin ang kasalukuyang lugar ng mapa';

  @override
  String get customRegionSave => 'I-save';

  @override
  String get customRegionErrorRequired => 'Kinakailangan ang field na ito';

  @override
  String get customRegionErrorUrl =>
      'Maglagay ng web address na nagsisimula sa http:// o https://';

  @override
  String get customRegionErrorNumber => 'Maglagay ng numero';

  @override
  String get customRegionErrorRange => 'Wala sa saklaw ang numerong ito';

  @override
  String get customRegionChecking => 'Sinusuri ang server';

  @override
  String get customRegionServerOk => 'Tumugon ang server';

  @override
  String get customRegionServerUnreachable => 'Hindi maabot ang server na ito';

  @override
  String get customRegionServerNotOba =>
      'Hindi tumugon ang server na ito gaya ng OneBusAway';

  @override
  String customRegionSaved(String name) {
    return 'Na-save ang $name';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'Ang OneBusAway ay libre at open source na transit software, binuo ng mga boluntaryo at sinusuportahan ng Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'Lisensya';

  @override
  String get creditsMapData => 'Data ng mapa';

  @override
  String get creditsLicenses => 'Mga lisensya ng open source';

  @override
  String get creditsLicensesHelp =>
      'Ang mga library na ginamit sa pagbuo ng app na ito.';

  @override
  String get creditsLicensesLoading => 'Naglo-load ng mga lisensya';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lisensya',
      one: '$count lisensya',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Available sa dose-dosenang rehiyon ng transit sa buong mundo.';

  @override
  String get onboardingBenefitNearbyTitle =>
      'Tingnan ang mga kalapit na hintuan';

  @override
  String get onboardingBenefitNearbyBody =>
      'Mga bus at tren sa paligid mo, nakaayos ayon sa distansya.';

  @override
  String get onboardingBenefitMapTitle => 'I-center ang mapa sa iyo';

  @override
  String get onboardingBenefitMapBody =>
      'Direktang magbukas sa iyong paligid nang hindi naghahanap.';

  @override
  String onboardingLocationFootnote(String appName) {
    return 'Ginagamit lang ng $appName ang iyong lokasyon habang bukas ang app. Maaari mo itong baguhin anumang oras sa mga setting ng iyong device.';
  }

  @override
  String get onboardingLocationDenied =>
      'Naka-off ang access sa lokasyon. Maaari mo pa ring piliin ang iyong rehiyon nang mag-isa.';

  @override
  String get onboardingRegionDetected => 'Natukoy malapit sa iyo';

  @override
  String onboardingRegionUse(String name) {
    return 'Gamitin ang $name';
  }

  @override
  String get onboardingRegionOthers => 'O pumili ng ibang rehiyon';

  @override
  String get onboardingRegionEmpty =>
      'Walang available na rehiyon ngayon. Tingnan ang iyong koneksyon at subukang muli.';

  @override
  String get surveyCardTitle => 'Tumulong na pagbutihin ang transit';

  @override
  String get surveyDefaultPrompt =>
      'Sumagot ng maikling survey para makatulong na pagbutihin ang transit.';

  @override
  String get surveyTake => 'Sumagot sa survey';

  @override
  String get surveyNotNow => 'Huwag muna';

  @override
  String get surveyDismiss => 'Isara ang survey';

  @override
  String get surveyNext => 'Susunod';

  @override
  String get surveySubmit => 'Isumite ang survey';

  @override
  String get surveySubmitting => 'Isinusumite';

  @override
  String get surveyQuestionsTitle => 'Survey';

  @override
  String get surveyTextHint => 'Ilagay ang iyong sagot';

  @override
  String get surveyRequired => 'Kinakailangan';

  @override
  String get surveyIncomplete =>
      'Pakisagot ang lahat ng kinakailangang tanong bago isumite.';

  @override
  String get surveyFailed =>
      'Hindi naipadala ang iyong mga sagot. Pakisubukang muli.';

  @override
  String get surveyThanks => 'Salamat sa iyong feedback.';

  @override
  String get surveyOpenSurvey => 'Buksan ang survey';

  @override
  String get surveyLearnMore => 'Matuto pa';

  @override
  String get surveyShareFeedback => 'Magbahagi ng feedback';

  @override
  String get surveySignUp => 'Mag-sign up';

  @override
  String get surveyExternalError =>
      'Hindi mabuksan ang link ng survey na ito. Pakisubukang muli mamaya.';

  @override
  String donationTitle(String appName) {
    return 'Kailangan ng $appName ang iyong tulong';
  }

  @override
  String get donationBody =>
      'Ang app na ito ay binuo gamit ang trabaho ng mga boluntaryo, at kailangan namin ang tulong mo para pondohan ang susunod na pagbuo nito.';

  @override
  String get donationLearnMore => 'Matuto pa';

  @override
  String get donationDonate => 'Mag-donate ngayon';

  @override
  String get donationRemindLater => 'Paalalahanan ako mamaya';

  @override
  String get donationDismiss => 'Huwag na lang';

  @override
  String get donationHeader =>
      'Narito kung bakit kailangan namin ang iyong tulong';

  @override
  String donationExplanation(String appName) {
    return 'Mayroon kaming malalaking plano para pagbutihin ang $appName, ngunit hindi namin ito magagawa kung wala ang iyong tulong. Ang app na ito ay binuo gamit ang trabaho ng mga boluntaryo, at kailangan namin ang tulong mo para pondohan ang susunod na pagbuo nito.\n\nBilang pangunahing proyekto ng Open Transit Software Foundation, isang nonprofit, ang iyong donasyon ay tax deductible sa United States.';
  }

  @override
  String get donationDonateWebsite => 'Mag-donate sa aming website';

  @override
  String titleDonation(String appName) {
    return 'Suportahan ang $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'Nag-eenjoy ka ba sa $appName?';
  }

  @override
  String get feedbackYes => 'Oo!';

  @override
  String get feedbackNo => 'Hindi masyado';

  @override
  String get feedbackLater => 'Magtanong mamaya';

  @override
  String get feedbackNegativeTitle => 'Pasensya na sa nangyari.';

  @override
  String get feedbackNegativeBody =>
      'Maaari mo bang sabihin kung ano ang mali? Binabasa namin ang bawat mensahe.';

  @override
  String get feedbackSend => 'Magpadala ng feedback';

  @override
  String get feedbackDecline => 'Huwag na lang';

  @override
  String get tripPlanningUnavailable =>
      'Hindi available ang pagpaplano ng biyahe sa rehiyong ito.';

  @override
  String get deepLinkOtherRegion =>
      'Para sa ibang rehiyon ang link na ito. Lumipat ng rehiyon para buksan ito.';

  @override
  String get dataUpdated => 'Na-update';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Rutang $route papuntang $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Rutang $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Naglo-load ng mga pag-alis';

  @override
  String get bookmarksNoDepartures => 'Walang paparating na pag-alis';

  @override
  String get bookmarksDeparturesError => 'Hindi ma-load ang mga pag-alis';

  @override
  String get bookmarksDeparturesStale =>
      'Hindi ma-refresh. Ipinapakita ang mga naunang oras.';

  @override
  String get bookmarksUpdated => 'Na-update ang mga pag-alis';

  @override
  String get bookmarksSortTooltip => 'I-sort ang mga bookmark';

  @override
  String get bookmarksSortByGroup => 'I-sort ayon sa grupo';

  @override
  String get bookmarksSortByDistance => 'I-sort ayon sa distansya';

  @override
  String get bookmarksManageTooltip => 'I-edit ang mga bookmark at grupo';

  @override
  String get bookmarksRefreshTooltip => 'I-refresh ang mga pag-alis';

  @override
  String get bookmarksEmptyTitle => 'Wala pang bookmark';

  @override
  String get bookmarksEmptyBody =>
      'Magbukas ng hintuan at i-tap ang bookmark button nito para i-save dito. Mula sa isang pag-alis, maaari mo ring i-bookmark ang rutang iyon lang sa hintuan.';

  @override
  String get bookmarksFindStops => 'Maghanap ng mga hintuan sa mapa';

  @override
  String get bookmarksUngrouped => 'Walang grupo';

  @override
  String get bookmarksGroupExpanded => 'nakabukas';

  @override
  String get bookmarksGroupCollapsed => 'nakasara';

  @override
  String get bookmarksGroupToggleHint =>
      'Ipinapakita o itinatago ang mga bookmark sa grupong ito';

  @override
  String bookmarksActionsFor(String name) {
    return 'Mga aksyon para sa $name';
  }

  @override
  String get bookmarksActionEdit => 'I-edit';

  @override
  String get bookmarksActionPin => 'I-pin sa itaas';

  @override
  String get bookmarksActionUnpin => 'I-unpin';

  @override
  String get bookmarksActionMove => 'Ilipat sa grupo';

  @override
  String get bookmarksActionDelete => 'I-delete';

  @override
  String get bookmarksPinned => 'Naka-pin';

  @override
  String bookmarksDeleted(String name) {
    return 'Na-delete ang $name';
  }

  @override
  String get bookmarksUndo => 'I-undo';

  @override
  String get bookmarksMoveTitle => 'Ilipat sa grupo';

  @override
  String get bookmarksNoGroup => 'Walang grupo';

  @override
  String bookmarksMoved(String group) {
    return 'Inilipat sa $group';
  }

  @override
  String get bookmarksEditorNameLabel => 'Pangalan ng bookmark';

  @override
  String get bookmarksEditorNameRequired =>
      'Maglagay ng pangalan para sa bookmark na ito.';

  @override
  String get bookmarksEditorDuplicate =>
      'Mayroon ka nang bookmark na may ganitong pangalan para sa hintuan at rutang ito. Palitan ang pangalan para makapag-save ng isa pa.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Bookmark ng hintuan: ipinapakita ang mga susunod na pag-alis ng bawat ruta sa $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Bookmark ng biyahe: ipinapakita ang mga susunod na pag-alis ng $route sa $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return '$route lang';
  }

  @override
  String get bookmarksEditorGroup => 'Grupo';

  @override
  String get bookmarksEditorNewGroup => 'Bagong grupo…';

  @override
  String get bookmarksEditorNewGroupTitle => 'Bagong grupo';

  @override
  String get bookmarksEditorGroupName => 'Pangalan ng grupo';

  @override
  String get bookmarksEditorSave => 'I-save';

  @override
  String get bookmarksEditorSaved => 'Na-save ang bookmark';

  @override
  String get bookmarksEditorDelete => 'I-delete ang bookmark';

  @override
  String get bookmarksEditorDeleteTitle => 'I-delete ang bookmark na ito?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return 'Aalisin ang “$name” sa iyong mga bookmark.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Pumili ng rehiyon bago magdagdag ng mga bookmark.';

  @override
  String get bookmarksManageGroupsHeader => 'Mga grupo';

  @override
  String get bookmarksManageAddGroup => 'Magdagdag ng grupo';

  @override
  String get bookmarksManageRenameGroup => 'Palitan ang pangalan ng grupo';

  @override
  String get bookmarksManageDeleteGroup => 'I-delete ang grupo';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'Mawawalan ng grupo ang mga bookmark sa “$name”.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Ilipat pataas ang $name';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Ilipat pababa ang $name';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Baguhin ang pagkakasunod ng $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, posisyon $position sa $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'Wala pang mga bookmark o grupong mapapamahalaan.';

  @override
  String get bookmarksManageUngrouped => 'Mga bookmark na walang grupo';

  @override
  String get recentsEmptyTitle => 'Walang kamakailang hintuan';

  @override
  String get recentsEmptyBody =>
      'Lalabas dito ang mga hintuang tiningnan mo, pinakabago muna.';

  @override
  String get recentsFindStops => 'Maghanap ng mga hintuan sa mapa';

  @override
  String get recentsClearAll => 'I-clear lahat';

  @override
  String get recentsClearTitle => 'I-clear ang mga kamakailang hintuan?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Aalisin nito ang lahat ng $count kamakailang hintuan. Hindi maaapektuhan ang iyong mga bookmark.',
      one:
          'Aalisin nito ang $count kamakailang hintuan. Hindi maaapektuhan ang iyong mga bookmark.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Alisin ang $name sa mga kamakailang hintuan';
  }

  @override
  String recentsRemoved(String name) {
    return 'Inalis ang $name';
  }

  @override
  String get recentsSectionEmpty =>
      'Lalabas dito ang mga hintuang tiningnan mo.';

  @override
  String get alarmsSectionTitle => 'Mga paalala';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuto bago ang pag-alis',
      one: '$minutes minuto bago ang pag-alis',
    );
    return '$_temp0, sa $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Paalala para sa $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'I-delete ang paalala para sa $title';
  }

  @override
  String get alarmsDeleted => 'Na-delete ang paalala';

  @override
  String get alarmsDeleteFailed =>
      'Hindi ma-delete ang paalala. Tingnan ang iyong koneksyon at subukang muli.';

  @override
  String get alertsEmptyTitle => 'Walang alerto sa serbisyo';

  @override
  String get alertsEmptyBody => 'Walang aktibong alerto sa serbisyo ngayon.';

  @override
  String get alertsRegionNote =>
      'Kasama ang mga alerto para sa iyong mga naka-bookmark, kamakailan, at kalapit na hintuan.';

  @override
  String get alertsMarkAllRead => 'Markahan lahat bilang nabasa';

  @override
  String get alertsAllRead => 'Namarkahan bilang nabasa ang lahat ng alerto';

  @override
  String get alertsUnread => 'Hindi pa nababasa';

  @override
  String get alertsSeverityInfo => 'Impormasyon';

  @override
  String get alertsSeverityWarning => 'Babala';

  @override
  String get alertsSeveritySevere => 'Malubha';

  @override
  String get alertsSeverityUnknown => 'Alerto sa serbisyo';

  @override
  String get alertsNoTitle => 'Alerto sa serbisyo';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Hindi pa nababasa. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hindi pa nababasang alerto',
      one: '$count hindi pa nababasang alerto',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pang alerto',
      one: '$count pang alerto',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Panahong aktibo';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start hanggang $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'Mula $start';
  }

  @override
  String get alertsDetailAffects => 'Naaapektuhan';

  @override
  String get alertsDetailRoutes => 'Mga ruta';

  @override
  String get alertsDetailStops => 'Mga hintuan';

  @override
  String get alertsDetailLearnMore => 'Matuto pa';

  @override
  String get alertsDetailNoDetails => 'Walang karagdagang detalyeng available.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Inilabas $date';
  }

  @override
  String get agenciesEmptyTitle => 'Walang ahensya';

  @override
  String get agenciesEmptyBody =>
      'Walang inilistang ahensya ng transit ang rehiyong ito.';

  @override
  String get agenciesWebsite => 'Website';

  @override
  String agenciesPhone(String phone) {
    return 'Tawagan ang $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'I-email ang $email';
  }

  @override
  String get agenciesFares => 'Impormasyon sa pamasahe';

  @override
  String get agenciesDisclaimer => 'Disclaimer';

  @override
  String get agenciesShowOnMap => 'Ipakita ang sakop sa mapa';

  @override
  String get searchFieldLabel => 'Hanapin';

  @override
  String get searchFieldHint => 'Ruta, numero ng hintuan, address, o sasakyan';

  @override
  String get searchClear => 'I-clear ang paghahanap';

  @override
  String get searchScopeLabel => 'Hanapin ang';

  @override
  String get searchScopeAll => 'Lahat';

  @override
  String get searchScopeStops => 'Mga hintuan';

  @override
  String get searchScopeRoutes => 'Mga ruta';

  @override
  String get searchScopePlaces => 'Mga lugar';

  @override
  String get searchQuickHeader => 'Hanapin ang';

  @override
  String searchQuickRoute(String query) {
    return 'Ruta: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Numero ng hintuan: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Address: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Sasakyan: $query';
  }

  @override
  String get searchRecentStopsHeader => 'Mga kamakailang hintuan';

  @override
  String get searchBookmarksHeader => 'Mga Bookmark';

  @override
  String get searchRecentSearchesHeader => 'Mga kamakailang paghahanap';

  @override
  String get searchRecentPlacesHeader => 'Mga kamakailang lugar';

  @override
  String get searchPlacesHeader => 'Mga lugar';

  @override
  String get searchClearRecent => 'I-clear ang mga kamakailang paghahanap';

  @override
  String get searchClearRecentConfirm =>
      'I-clear ang iyong mga kamakailang paghahanap at lugar?';

  @override
  String get searchClearAction => 'I-clear';

  @override
  String get searchRecentCleared => 'Na-clear ang mga kamakailang paghahanap';

  @override
  String get searchPlacesLoading => 'Naghahanap ng mga lugar';

  @override
  String get searchPlacesNone => 'Walang nahanap na lugar';

  @override
  String get searchPlacesError =>
      'Hindi mahanap ang mga lugar. Tingnan ang iyong koneksyon.';

  @override
  String get searchSearching => 'Naghahanap';

  @override
  String get searchNoResultsTitle => 'Walang resulta';

  @override
  String searchNoResultsBody(String query) {
    return 'Walang nahanap na resulta ng paghahanap para sa “$query”.';
  }

  @override
  String get searchUnavailableNoRegion => 'Pumili ng rehiyon bago maghanap.';

  @override
  String get searchUnavailableAddress =>
      'Hindi naka-set up ang paghahanap ng address sa app na ito.';

  @override
  String get searchUnavailableVehicle =>
      'Hindi available ang paghahanap ng sasakyan sa rehiyong ito.';

  @override
  String get searchEmptyTitle => 'Maghanap ng mga ruta, hintuan, at lugar';

  @override
  String get searchEmptyBody =>
      'Mag-type ng pangalan ng ruta, numero ng hintuan, address, o ID ng sasakyan.';

  @override
  String get searchDismissMessage => 'Isara';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resulta para sa “$query”',
      one: '$count resulta para sa “$query”',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'Mga ruta';

  @override
  String get searchResultsStops => 'Mga hintuan';

  @override
  String get searchResultsVehicles => 'Mga sasakyan';

  @override
  String get searchResultsPlaces => 'Mga lugar';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Rutang $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Sasakyan $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'Hindi nagseserbisyo ng biyahe ang sasakyang $id ngayon.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Nilo-load ang sasakyang $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'I-on ang lokasyon para makita ang mga pag-alis mula sa mga hintuan malapit sa iyo.';

  @override
  String get searchNearbyLocationButton => 'Gamitin ang aking lokasyon';

  @override
  String get searchNearbyLocationDenied =>
      'Naka-off ang access sa lokasyon. I-on ito sa mga setting ng iyong device para makita ang mga hintuan malapit sa iyo.';

  @override
  String get searchNearbyLocationServicesOff =>
      'Naka-off ang mga serbisyo ng lokasyon. I-on ang mga ito para makita ang mga hintuan malapit sa iyo.';

  @override
  String get searchNearbyLocationUnavailable =>
      'Hindi ginagamit ng app na ito ang iyong lokasyon, kaya hindi nito maipapakita ang mga hintuan malapit sa iyo.';

  @override
  String get searchNearbyEmpty => 'Walang kalapit na hintuan';

  @override
  String get searchNearbyEmptyBody => 'Walang hintuan na nasa layo ng lakad.';

  @override
  String get searchNearbyMapCenter =>
      'Ipinapakita ang mga hintuan malapit sa gitna ng mapa.';

  @override
  String get searchNearbyNoDepartures => 'Walang pag-alis sa susunod na oras';

  @override
  String get searchNearbyLoadingDepartures => 'Naglo-load ng mga pag-alis';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kalapit na hintuan',
      one: '$count kalapit na hintuan',
      zero: 'Walang kalapit na hintuan',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Hinahanap ang iyong lokasyon…';

  @override
  String get searchNearbyRefresh => 'I-refresh';

  @override
  String searchNearbyDistance(String distance) {
    return '$distance ang layo';
  }

  @override
  String get searchNearbyOtherDirection => 'Iba pang hintuan';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return 'Mga hintuan $direction';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route papuntang $headsign, $eta, $status. Mula sa $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'Mula sa $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Mga pag-alis malapit sa iyo';

  @override
  String get searchExplorePlanTrip => 'Magplano ng biyahe';

  @override
  String get searchExploreWeather => 'Panahon';

  @override
  String get searchExploreAgencies => 'Mga Ahensya';

  @override
  String get searchPlaceAddress => 'Address';

  @override
  String get searchPlaceCoordinates => 'Mga coordinate';

  @override
  String get searchPlaceDistance => 'Distansya';

  @override
  String get searchPlaceDirectionsTo => 'Mga direksyon papunta rito';

  @override
  String get searchPlaceDirectionsFrom => 'Mga direksyon mula rito';

  @override
  String get searchPlaceNearbyStops => 'Mga kalapit na hintuan';

  @override
  String get searchPlaceShare => 'Ibahagi';

  @override
  String get searchPlaceOpenInMaps => 'Buksan sa maps app';

  @override
  String get searchPlaceRemovePin => 'Alisin ang pin';

  @override
  String get searchPlaceOpenFailed => 'Hindi mabuksan ang isang maps app.';

  @override
  String get searchPlaceShareFailed => 'Hindi maibahagi ang lugar na ito.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Lugar: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Panahon: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Ipinapakita ang forecast';

  @override
  String get searchWeatherClear => 'Maaliwalas';

  @override
  String get searchWeatherPartlyCloudy => 'Bahagyang maulap';

  @override
  String get searchWeatherCloudy => 'Maulap';

  @override
  String get searchWeatherRain => 'Ulan';

  @override
  String get searchWeatherSleet => 'Ulan na may yelo';

  @override
  String get searchWeatherSnow => 'Niyebe';

  @override
  String get searchWeatherWindy => 'Mahangin';

  @override
  String get searchWeatherFog => 'Hamog';

  @override
  String get searchWeatherUnknown => 'Hindi alam na kondisyon';

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
      other: '$value digri Fahrenheit',
      one: '$value digri Fahrenheit',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value digri Celsius',
      one: '$value digri Celsius',
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
  String get searchWeatherFeelsLike => 'Pakiramdam na';

  @override
  String get searchWeatherWind => 'Hangin';

  @override
  String get searchWeatherPrecip => 'Tsansa ng ulan';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'Pinakamataas $high · Pinakamababa $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'Pinakamataas $high, pinakamababa $low, sa susunod na 24 oras';
  }

  @override
  String get searchWeatherHourly => 'Susunod na 24 oras';

  @override
  String get searchWeatherNow => 'Ngayon';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, $precip tsansa ng ulan';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Mga temperatura sa $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'digri Fahrenheit (°F)';

  @override
  String get searchWeatherCelsius => 'digri Celsius (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Forecast mula $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'Hindi available ang panahon para sa rehiyong ito.';

  @override
  String get searchWeatherSummaryLabel => 'Ngayong araw';

  @override
  String get bookmarksSectionEmpty =>
      'Lalabas dito ang mga naka-bookmark na hintuan.';

  @override
  String get coreDirectionBoundN => 'Pa-hilaga';

  @override
  String get coreDirectionBoundNE => 'Pa-HS';

  @override
  String get coreDirectionBoundE => 'Pa-silangan';

  @override
  String get coreDirectionBoundSE => 'Pa-TS';

  @override
  String get coreDirectionBoundS => 'Pa-timog';

  @override
  String get coreDirectionBoundSW => 'Pa-TK';

  @override
  String get coreDirectionBoundW => 'Pa-kanluran';

  @override
  String get coreDirectionBoundNW => 'Pa-HK';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Hintuan #$code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Hintuan: \'$code\'';
  }

  @override
  String get coreJustNow => 'Ngayon lang';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds seg. ang nakalipas';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes min. ang nakalipas';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours oras ang nakalipas';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days araw ang nakalipas',
      one: '$days araw ang nakalipas',
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
  String get arrivalsNow => 'ngayon';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '${minutes}m';
  }

  @override
  String get arrivalsCanceled => 'kanselado';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'kada $minutes min mula $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'kada $minutes min hanggang $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'Pa-hilaga';

  @override
  String get arrivalsDirectionBoundNE => 'Pa-hilagang-silangan';

  @override
  String get arrivalsDirectionBoundE => 'Pa-silangan';

  @override
  String get arrivalsDirectionBoundSE => 'Pa-timog-silangan';

  @override
  String get arrivalsDirectionBoundS => 'Pa-timog';

  @override
  String get arrivalsDirectionBoundSW => 'Pa-timog-kanluran';

  @override
  String get arrivalsDirectionBoundW => 'Pa-kanluran';

  @override
  String get arrivalsDirectionBoundNW => 'Pa-hilagang-kanluran';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'Pa-$code';
  }

  @override
  String get arrivalsRefresh => 'I-refresh ang mga pagdating';

  @override
  String get arrivalsRetry => 'Subukang muli';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Walang pagdating sa susunod na $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound =>
      'Hindi nahanap ang hintuan o hindi available ang serbisyo';

  @override
  String get arrivalsNetworkError =>
      'Hindi maabot ang transit server. Tingnan ang iyong koneksyon.';

  @override
  String get arrivalsLoadError => 'Hindi ma-load ang mga pagdating.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'Hindi ma-update. Ipinapakita ang mga resulta mula $time';
  }

  @override
  String get arrivalsArrivingNow => 'dumarating na';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'darating sa loob ng $minutes minuto',
      one: 'darating sa loob ng $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'real-time';

  @override
  String get arrivalsRowTapHint => 'ipakita ang mga detalye';

  @override
  String arrivalsAtTime(String time) {
    return 'sa $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutong huli',
      one: '$minutes minutong huli',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutong maaga',
      one: '$minutes minutong maaga',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'kada $minutes minuto mula $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'kada $minutes minuto hanggang $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'nakaiskedyul na oras';

  @override
  String get arrivalsLoading => 'Naglo-load ng mga pagdating';

  @override
  String get arrivalsRefreshing => 'Nire-refresh ang mga pagdating';

  @override
  String get arrivalsUpdated => 'Na-update ang mga pagdating';

  @override
  String get tripPlannerOriginLabel => 'Mula';

  @override
  String get tripPlannerDestinationLabel => 'Papunta';

  @override
  String get tripPlannerChooseOrigin => 'Pumili ng panimulang punto';

  @override
  String get tripPlannerChooseDestination => 'Pumili ng destinasyon';

  @override
  String get tripPlannerCurrentLocation => 'Kasalukuyang Lokasyon';

  @override
  String get tripPlannerSwapEndpoints =>
      'Ipagpalit ang panimulang punto at destinasyon';

  @override
  String get tripPlannerPlanTrip => 'Magplano ng biyahe';

  @override
  String get tripPlannerPlanningTrip => 'Pinaplano ang iyong biyahe';

  @override
  String get tripPlannerOptions => 'Mga opsyon sa biyahe';

  @override
  String get tripPlannerLeaveNow => 'Umalis ngayon';

  @override
  String get tripPlannerDepartAt => 'Umalis nang';

  @override
  String get tripPlannerArriveBy => 'Dumating nang';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Baguhin ang oras, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Transit';

  @override
  String get tripPlannerModeWalk => 'Lakad';

  @override
  String get tripPlannerModeBike => 'Bisikleta';

  @override
  String get tripPlannerModeCar => 'Kotse';

  @override
  String get tripPlannerModeBikeRental => 'Bikeshare Lang';

  @override
  String get tripPlannerModeTransitBikeRental => 'Transit + Bikeshare';

  @override
  String get tripPlannerWheelchairAccessible => 'Accessible sa wheelchair';

  @override
  String get tripPlannerWalkQuarterMile => '0.25 milya';

  @override
  String get tripPlannerWalkHalfMile => '0.5 milya';

  @override
  String get tripPlannerWalkOneMile => '1 milya';

  @override
  String get tripPlannerWalkTwoMiles => '2 milya';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'Maglakad hanggang $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'Walang nahanap na biyahe';

  @override
  String get tripPlannerRetry => 'Subukang muli';

  @override
  String get tripPlannerRealTime => 'Real-time';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours oras';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours oras $minutes min';
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
      other: '$count paglipat',
      one: '$count paglipat',
      zero: 'Walang paglipat',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return 'Maglakad ng $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Aalis $time mula sa $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'Nasa oras';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '$minutes min na huli';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '$minutes min na maaga';
  }

  @override
  String get tripPlannerStatusScheduled => 'Nakaiskedyul';

  @override
  String get tripPlannerLegBus => 'Bus';

  @override
  String get tripPlannerLegTram => 'Tram';

  @override
  String get tripPlannerLegSubway => 'Subway';

  @override
  String get tripPlannerLegRail => 'Tren';

  @override
  String get tripPlannerLegFerry => 'Ferry';

  @override
  String get tripPlannerLegCableCar => 'Cable Car';

  @override
  String get tripPlannerLegGondola => 'Gondola';

  @override
  String get tripPlannerLegFunicular => 'Funicular';

  @override
  String get tripPlannerLegAirplane => 'Eroplano';

  @override
  String get tripPlannerLegTrolleybus => 'Trolleybus';

  @override
  String get tripPlannerLegMonorail => 'Monorail';

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
    return 'Maglakad nang $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return 'Magbisikleta nang $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return 'Nirentahang bisikleta $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return 'Magmaneho nang $duration';
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
  String get tripPlannerThen => 'pagkatapos';

  @override
  String get tripPlannerOpenItineraryHint =>
      'ipakita ang mga detalye ng biyahe';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuto',
      one: '$minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours oras',
      one: '$hours oras',
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
      other: '$value talampakan',
      one: '$value talampakan',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value milya',
      one: '$value milya',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value metro',
      one: '$value metro',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value kilometro',
      one: '$value kilometro',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return '$start hanggang $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'real-time, nasa oras';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'real-time, $minutes minutong huli',
      one: 'real-time, $minutes minutong huli',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'real-time, $minutes minutong maaga',
      one: 'real-time, $minutes minutong maaga',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'nakaiskedyul na oras';

  @override
  String get tripPlannerResultsHeading => 'Mga iminungkahing biyahe';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count biyahe ang nahanap',
      one: '$count biyahe ang nahanap',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lugar ang nahanap',
      one: '$count lugar ang nahanap',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'Mapa ng biyahe. Inilalarawan ng mga direksyon sa ibaba ang parehong biyahe.';

  @override
  String get tripPlannerTripDetails => 'Mga detalye ng biyahe';

  @override
  String get tripPlannerMapLabel => 'Mapa ng biyahe';

  @override
  String get tripPlannerStart => 'Simula';

  @override
  String get tripPlannerDestination => 'Destinasyon';

  @override
  String get tripPlannerUnnamedPlace => 'Lokasyong walang pangalan';

  @override
  String get tripPlannerRentalBike => 'Nirentahang bisikleta';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Maglakad papuntang $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Magbisikleta papuntang $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Sumakay ng rental bike papuntang $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Magmaneho papuntang $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Sumakay ng $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Sumakay ng $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Sumakay ng $mode papuntang $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Sumakay ng $mode $route papuntang $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Bumaba sa $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Dumating sa $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hintuan',
      one: '$count hintuan',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ipakita ang $count hintuan',
      one: 'Ipakita ang $count hintuan',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Itago ang $count hintuan',
      one: 'Itago ang $count hintuan',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hakbang',
      one: '$count hakbang',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ipakita ang $count hakbang',
      one: 'Ipakita ang $count hakbang',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Itago ang $count hakbang',
      one: 'Itago ang $count hakbang',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, mga $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Umalis na';

  @override
  String get tripPlannerDirectionHardLeft => 'Kumaliwa nang matalim';

  @override
  String get tripPlannerDirectionLeft => 'Kumaliwa';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'Bahagyang kumaliwa';

  @override
  String get tripPlannerDirectionContinue => 'Magpatuloy';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Bahagyang kumanan';

  @override
  String get tripPlannerDirectionRight => 'Kumanan';

  @override
  String get tripPlannerDirectionHardRight => 'Kumanan nang matalim';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Pumasok sa rotonda nang pakanan';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Pumasok sa rotonda nang pakaliwa';

  @override
  String get tripPlannerDirectionElevator => 'Sumakay sa elevator';

  @override
  String get tripPlannerDirectionUturnLeft => 'Mag-U-turn pakaliwa';

  @override
  String get tripPlannerDirectionUturnRight => 'Mag-U-turn pakanan';

  @override
  String get tripPlannerDirectionEnterStation => 'Pumasok sa istasyon';

  @override
  String get tripPlannerDirectionExitStation => 'Lumabas sa istasyon';

  @override
  String get tripPlannerDirectionFollowSigns => 'Sundin ang mga karatula';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Maglakad sa $street nang $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction sa $street, maglakad nang $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Maghanap ng lugar';

  @override
  String get tripPlannerSearchNoResults => 'Walang nahanap na lugar';

  @override
  String get tripPlannerSearchError =>
      'Hindi mahanap ang mga lugar. Subukang muli.';

  @override
  String get tripPlannerUseCurrentLocation =>
      'Gamitin ang kasalukuyang lokasyon';

  @override
  String get tripPlannerLocationUnavailable =>
      'Hindi makuha ang iyong lokasyon.';

  @override
  String get tripPlannerClearSearch => 'I-clear ang paghahanap';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Pumili ng parehong pinagmulan at destinasyon.';

  @override
  String get tripPlannerErrorNetwork =>
      'Hindi maabot ang trip planner. Tingnan ang iyong koneksyon.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'Nagbalik ang server ng di-wastong tugon';

  @override
  String get tripPlannerErrorUnknown => 'May naganap na hindi kilalang error.';

  @override
  String get tripPlannerPlannerSystemError =>
      'Hindi namin napaplano ang iyong biyahe ngayon. Pakisubukang muli.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'Pansamantalang hindi available ang pagpaplano ng biyahe. Subukang muli sa ilang sandali.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'Hindi pa suportado ang lokasyong ito.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'Walang available na ruta para sa biyaheng ito.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'Walang available na opsyon sa transit ngayon.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'Mas natagalan ito kaysa inaasahan. Pakisubukang muli.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'May nagkamali sa kahilingan. Pakisubukang muli.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'Hindi namin mahanap ang panimulang lokasyon.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'Hindi namin mahanap ang destinasyon.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'Hindi namin mahanap ang panimulang punto o ang destinasyon.';

  @override
  String get tripPlannerPlannerTooClose =>
      'Masyadong malapit ang simula at destinasyon.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'Hindi accessible ang rutang ito sa napiling opsyon.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'Hindi malinaw ang panimulang lokasyon. Subukang maging mas tiyak.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'Hindi malinaw ang destinasyon. Subukang maging mas tiyak.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Kailangan ng higit pang detalye ang parehong lokasyon. Subukang gawing mas tiyak ang mga ito.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'May mga kulang na opsyon sa ruta.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'Hindi nagkakatugma ang mga napiling opsyon sa ruta.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Pumili ng gustong uri ng ruta.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Pakisaayos ang mga kagustuhan sa ruta.';
}
