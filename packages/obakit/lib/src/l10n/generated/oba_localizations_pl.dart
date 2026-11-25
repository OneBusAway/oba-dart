// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class ObaLocalizationsPl extends ObaLocalizations {
  ObaLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get commonBack => 'Wstecz';

  @override
  String get commonClose => 'Zamknij';

  @override
  String get commonDone => 'Gotowe';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonRetry => 'Spróbuj ponownie';

  @override
  String get commonContinue => 'Dalej';

  @override
  String get commonNotNow => 'Nie teraz';

  @override
  String get commonSeeAll => 'Zobacz wszystko';

  @override
  String get commonLoading => 'Wczytywanie';

  @override
  String get commonErrorTitle => 'Coś poszło nie tak';

  @override
  String get commonEmptyTitle => 'Jeszcze nic tu nie ma';

  @override
  String get commonComingSoon => 'Wkrótce';

  @override
  String get commonComingSoonBody => 'Ten ekran nie jest jeszcze dostępny.';

  @override
  String get commonOffline =>
      'Wygląda na to, że jesteś offline. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get commonServerError =>
      'Serwer odpowiedział w nieoczekiwany sposób. Spróbuj ponownie za chwilę.';

  @override
  String get sheetLabel => 'Panel';

  @override
  String get sheetExpand => 'Rozwiń panel';

  @override
  String get sheetCollapse => 'Zwiń panel';

  @override
  String get sheetHandleHint =>
      'Przeciągnij lub dotknij dwukrotnie, aby zmienić rozmiar panelu';

  @override
  String get homeTabHome => 'Start';

  @override
  String get homeTabRecent => 'Ostatnie';

  @override
  String get homeTabBookmarks => 'Zakładki';

  @override
  String get homeSearchPlaceholder => 'Szukaj przystanków, linii, miejsc';

  @override
  String get homeSearchLabel => 'Szukaj';

  @override
  String get homeSectionNearby => 'W pobliżu';

  @override
  String get homeSectionRecent => 'Ostatnie przystanki';

  @override
  String get homeSectionBookmarks => 'Zakładki';

  @override
  String get homeSectionAlerts => 'Alerty';

  @override
  String get homeSectionExplore => 'Odkrywaj';

  @override
  String get homeSectionMore => 'Ustawienia i więcej';

  @override
  String get mapLabel => 'Mapa';

  @override
  String get mapZoomInForStops => 'Przybliż, aby zobaczyć przystanki';

  @override
  String get mapLocationDenied =>
      'Dostęp do lokalizacji jest wyłączony. Dotknij, aby zezwolić.';

  @override
  String get mapLocationServicesOff => 'Usługi lokalizacji są wyłączone';

  @override
  String get mapRecenter => 'Pokaż moją lokalizację';

  @override
  String get mapSettingsButton => 'Ustawienia mapy';

  @override
  String get mapStopsListButton => 'Przystanki na mapie';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count przystanku na mapie',
      many: '$count przystanków na mapie',
      few: '$count przystanki na mapie',
      one: '$count przystanek na mapie',
      zero: 'Brak przystanków na mapie',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'Twoja lokalizacja';

  @override
  String get mapDroppedPin => 'Upuszczona pinezka';

  @override
  String get mapVehicle => 'Pojazd';

  @override
  String get mapSelectedStop => 'Wybrany';

  @override
  String get mapBookmarkedStop => 'W zakładkach';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, przystanek ($routeType)';
  }

  @override
  String get mapStopMarkerHint => 'Otwiera odjazdy z tego przystanku';

  @override
  String mapAttribution(String attribution) {
    return 'Dane mapy: $attribution';
  }

  @override
  String get mapTypeTitle => 'Typ mapy';

  @override
  String get mapTypeStandard => 'Standardowa';

  @override
  String get mapTypeSatellite => 'Satelitarna';

  @override
  String get mapTypeHybrid => 'Hybrydowa';

  @override
  String get mapShowScale => 'Pokaż skalę';

  @override
  String get mapShowHeading => 'Pokaż kierunek';

  @override
  String get mapShowStopLabels => 'Pokaż etykiety przystanków';

  @override
  String mapPlaceAt(String lat, String lon) {
    return 'Lokalizacja: $lat, $lon';
  }

  @override
  String get directionN => 'W kierunku północnym';

  @override
  String get directionNE => 'W kierunku północno-wschodnim';

  @override
  String get directionE => 'W kierunku wschodnim';

  @override
  String get directionSE => 'W kierunku południowo-wschodnim';

  @override
  String get directionS => 'W kierunku południowym';

  @override
  String get directionSW => 'W kierunku południowo-zachodnim';

  @override
  String get directionW => 'W kierunku zachodnim';

  @override
  String get directionNW => 'W kierunku północno-zachodnim';

  @override
  String get routeTypeBus => 'Autobus';

  @override
  String get routeTypeLightRail => 'Szybki tramwaj';

  @override
  String get routeTypeSubway => 'Metro';

  @override
  String get routeTypeRail => 'Pociąg';

  @override
  String get routeTypeFerry => 'Prom';

  @override
  String get routeTypeCableCar => 'Tramwaj linowy';

  @override
  String get routeTypeGondola => 'Gondola';

  @override
  String get routeTypeFunicular => 'Kolej linowo-terenowa';

  @override
  String get routeTypeUnknown => 'Komunikacja';

  @override
  String stopCode(String code) {
    return 'Przystanek $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'Linie $routes';
  }

  @override
  String get stopPageRefresh => 'Odśwież';

  @override
  String get stopPageRefreshed => 'Odjazdy zaktualizowane';

  @override
  String get stopPageBookmark => 'Dodaj przystanek do zakładek';

  @override
  String get stopPageBookmarked => 'Dodano do zakładek. Edytuj zakładkę';

  @override
  String get stopPageMoreActions => 'Więcej działań dla przystanku';

  @override
  String get stopPageSchedules => 'Rozkłady jazdy';

  @override
  String get stopPageServiceAlerts => 'Alerty o utrudnieniach';

  @override
  String get stopPageNearbyStops => 'Przystanki w pobliżu';

  @override
  String get stopPageWalkingDirections => 'Trasa piesza';

  @override
  String get stopPageBikeDirections => 'Trasa rowerowa';

  @override
  String get stopPagePlanTripFrom => 'Zaplanuj podróż stąd';

  @override
  String get stopPagePlanTripTo => 'Zaplanuj podróż tutaj';

  @override
  String get stopPageShareStop => 'Udostępnij przystanek';

  @override
  String get stopPageReportProblem => 'Zgłoś problem';

  @override
  String get stopPageFilterRoutes => 'Filtruj linie';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linii ukrytej',
      many: '$count linii ukrytych',
      few: '$count linie ukryte',
      one: '$count linia ukryta',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'Według czasu';

  @override
  String get stopPageModeRoute => 'Według linii';

  @override
  String get stopPageDepartureTypes => 'Typy odjazdów';

  @override
  String get stopPageFilterAll => 'Wszystkie odjazdy';

  @override
  String get stopPageFilterRealtime => 'Tylko na żywo';

  @override
  String get stopPageFilterScheduled => 'Tylko planowe';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pokaż $count minionego odjazdu',
      many: 'Pokaż $count minionych odjazdów',
      few: 'Pokaż $count minione odjazdy',
      one: 'Pokaż $count miniony odjazd',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Ukryj minione odjazdy';

  @override
  String get stopPageLoadMore => 'Załaduj więcej odjazdów';

  @override
  String stopPageWindow(int minutes) {
    return 'Pokazano odjazdy w ciągu najbliższych $minutes min';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Zaktualizowano $ago';
  }

  @override
  String get stopPageStaleTitle => 'Nie udało się odświeżyć odjazdów';

  @override
  String get stopPageStaleBody => 'Te godziny mogą być nieaktualne.';

  @override
  String get stopPageEmptyTitle => 'Brak nadchodzących odjazdów';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'Brak odjazdów w ciągu najbliższych $minutes min.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Wszystkie linie z odjazdami z tego przystanku są ukryte.';

  @override
  String get stopPageShowAllRoutes => 'Pokaż wszystkie linie';

  @override
  String get stopPageEmptyFilter =>
      'Żaden odjazd nie pasuje do filtra typu odjazdu.';

  @override
  String get stopPageShowAllTypes => 'Pokaż wszystkie odjazdy';

  @override
  String get stopPageMissingTitle => 'Nie znaleziono przystanku';

  @override
  String get stopPageMissingBody =>
      'Ten przystanek mógł zostać usunięty lub otrzymać nowy numer.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes min pieszo';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes min rowerem';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty pieszo',
      many: '$minutes minut pieszo',
      few: '$minutes minuty pieszo',
      one: '$minutes minuta pieszo',
    );
    return '$_temp0, $distance. Otwiera trasę.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty rowerem',
      many: '$minutes minut rowerem',
      few: '$minutes minuty rowerem',
      one: '$minutes minuta rowerem',
    );
    return '$_temp0, $distance. Otwiera trasę.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '$minutes min pieszo do tego przystanku. Odjazdy powyżej nastąpią wcześniej.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '$minutes min rowerem do tego przystanku. Odjazdy powyżej nastąpią wcześniej.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Obsługuje: $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertu o utrudnieniach',
      many: '$count alertów o utrudnieniach',
      few: '$count alerty o utrudnieniach',
      one: '$count alert o utrudnieniach',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nieprzeczytanego',
      many: '$count nieprzeczytanych',
      few: '$count nieprzeczytane',
      one: '$count nieprzeczytany',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Nieprzeczytany';

  @override
  String get stopPageAlertImportant => 'Ważne';

  @override
  String get stopPageDirectionsChooser => 'Otwórz trasę w aplikacji';

  @override
  String get stopPageAppleMaps => 'Mapy Apple';

  @override
  String get stopPageGoogleMaps => 'Mapy Google';

  @override
  String get stopPageCannotOpen => 'Nie udało się otworzyć tego linku.';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Przesiadka z linii $route $headsign, przyjazd $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Odjazdy';

  @override
  String get stopRowNow => 'TERAZ';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes min temu';
  }

  @override
  String get stopRowOnTime => 'punktualnie';

  @override
  String stopRowLate(int minutes) {
    return '$minutes min opóźnienia';
  }

  @override
  String stopRowEarly(int minutes) {
    return '$minutes min wcześniej';
  }

  @override
  String get stopRowScheduled => 'planowo';

  @override
  String get stopRowCanceled => 'odwołany';

  @override
  String get stopRowOccupancyEmpty => 'Pusty';

  @override
  String get stopRowOccupancyManySeats => 'Wiele dostępnych miejsc siedzących';

  @override
  String get stopRowOccupancyFewSeats => 'Mało dostępnych miejsc siedzących';

  @override
  String get stopRowOccupancyStanding => 'Tylko miejsca stojące';

  @override
  String get stopRowOccupancyCrushed => 'Bardzo zatłoczony';

  @override
  String get stopRowOccupancyFull => 'Pełny';

  @override
  String get stopRowOccupancyNotAccepting => 'Nie przyjmuje pasażerów';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'przyjedzie za $minutes minuty',
      many: 'przyjedzie za $minutes minut',
      few: 'przyjedzie za $minutes minuty',
      one: 'przyjedzie za $minutes minutę',
      zero: 'przyjeżdża teraz',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'odjedzie za $minutes minuty',
      many: 'odjedzie za $minutes minut',
      few: 'odjedzie za $minutes minuty',
      one: 'odjedzie za $minutes minutę',
      zero: 'odjeżdża teraz',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'przyjechał $minutes minuty temu',
      many: 'przyjechał $minutes minut temu',
      few: 'przyjechał $minutes minuty temu',
      one: 'przyjechał $minutes minutę temu',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'odjechał $minutes minuty temu',
      many: 'odjechał $minutes minut temu',
      few: 'odjechał $minutes minuty temu',
      one: 'odjechał $minutes minutę temu',
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
    return 'Linia $route do $headsign, $eta, o $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'śledzenie na żywo, $status';
  }

  @override
  String get stopRowA11yScheduledOnly =>
      'tylko godzina rozkładowa, brak danych na żywo';

  @override
  String get stopRowA11yTransfer => 'Twój kurs po przesiadce';

  @override
  String get stopRowA11yMissed =>
      'prawdopodobnie nie zdążysz, odjazd nastąpi, zanim dojdziesz na przystanek';

  @override
  String get stopRowA11yAlarm => 'alarm ustawiony';

  @override
  String stopRowActions(String route) {
    return 'Więcej działań dla linii $route';
  }

  @override
  String get stopRowShowTrip => 'Pokaż szczegóły kursu';

  @override
  String get stopRowAddAlarm => 'Dodaj alarm';

  @override
  String get stopRowRemoveAlarm => 'Usuń alarm';

  @override
  String get stopRowBookmarkTrip => 'Dodaj ten kurs do zakładek';

  @override
  String get stopRowShareTrip => 'Udostępnij kurs';

  @override
  String get stopRowRouteSchedule => 'Rozkład linii';

  @override
  String get stopRowRouteStops => 'Przystanki tej linii';

  @override
  String stopRouteGroupNext(String times) {
    return 'Najbliższe: $times';
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
      other: '$count odjazdu',
      many: '$count odjazdów',
      few: '$count odjazdy',
      one: '$count odjazd',
    );
    return 'Linia $route do $headsigns, $_temp0, najbliższy $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Przypomnij mi przed odjazdem';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty przed',
      many: '$minutes minut przed',
      few: '$minutes minuty przed',
      one: '$minutes minutę przed',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Alarm ustawiony na $minutes minuty przed',
      many: 'Alarm ustawiony na $minutes minut przed',
      few: 'Alarm ustawiony na $minutes minuty przed',
      one: 'Alarm ustawiony na $minutes minutę przed',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Alarm usunięty';

  @override
  String get stopAlarmFailed => 'Nie udało się zaktualizować alarmu.';

  @override
  String get stopAlarmPermissionDenied =>
      'Powiadomienia są wyłączone dla tej aplikacji.';

  @override
  String get stopFilterTitle => 'Filtruj linie';

  @override
  String get stopFilterSort => 'Sortuj odjazdy';

  @override
  String get stopFilterRoutesHeader => 'Linie pokazywane na tym przystanku';

  @override
  String get stopFilterShowAll => 'Pokaż wszystkie linie';

  @override
  String get stopTripArrivingAtYourStop => 'Dojeżdża do Twojego przystanku';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count przystanku stąd',
      many: '$count przystanków stąd',
      few: '$count przystanki stąd',
      one: '$count przystanek stąd',
      zero: 'Na Twoim przystanku',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return '$distance stąd';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'Na przystanku $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Pozycja zaktualizowana $ago';
  }

  @override
  String get stopTripNoPosition => 'Brak pozycji na żywo dla tego pojazdu';

  @override
  String stopTripStartsAs(String trip) {
    return 'Zaczyna jako $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Kontynuuje jako $trip';
  }

  @override
  String get stopTripStopsHeader => 'Przystanki';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minionego przystanku',
      many: '$count minionych przystanków',
      few: '$count minione przystanki',
      one: '$count miniony przystanek',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count przystanku przed Twoim przystankiem',
      many: '$count przystanków przed Twoim przystankiem',
      few: '$count przystanki przed Twoim przystankiem',
      one: '$count przystanek przed Twoim przystankiem',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'Twój przystanek';

  @override
  String get stopTripBoarding => 'Wsiadanie';

  @override
  String get stopTripVehicleHere => 'Pojazd jest tutaj';

  @override
  String get stopTripTerminal => 'Ostatni przystanek';

  @override
  String get stopTripPassed => 'Miniony';

  @override
  String get stopTripRouteStops => 'Wszystkie przystanki tej linii';

  @override
  String get stopTripReport => 'Zgłoś problem z tym kursem';

  @override
  String get stopTripGhostBus => 'Zgłoś autobus widmo';

  @override
  String get stopTripCanceled => 'Ten kurs został odwołany';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Pojazd na linii $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'Co $minutes min';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Linia $route';
  }

  @override
  String get stopRouteStopsDirection => 'Kierunek';

  @override
  String stopRouteStopsToward(String name) {
    return 'Do: $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count przystanku',
      many: '$count przystanków',
      few: '$count przystanki',
      one: '$count przystanek',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => 'Nie znaleziono przystanków dla tej linii.';

  @override
  String get stopSchedPrevDay => 'Poprzedni dzień';

  @override
  String get stopSchedNextDay => 'Następny dzień';

  @override
  String stopSchedPickDate(String date) {
    return 'Wybierz datę, $date';
  }

  @override
  String get stopSchedRoute => 'Linia';

  @override
  String get stopSchedDirection => 'Kierunek';

  @override
  String get stopSchedStop => 'Przystanek';

  @override
  String get stopSchedEmpty => 'Brak kursów w tym dniu.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'Co $minutes min od $start do $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'Do: $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odjazdu',
      many: '$count odjazdów',
      few: '$count odjazdy',
      one: '$count odjazd',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported =>
      'Rozkłady jazdy nie są dostępne w tym regionie.';

  @override
  String get stopSchedViewList => 'Lista';

  @override
  String get stopSchedViewGrid => 'Siatka';

  @override
  String get stopSchedNoDeparture => 'Brak odjazdu';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (Twój przystanek)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, kurs $trip: $time';
  }

  @override
  String get stopReportProblemHeader => 'Co jest nie tak?';

  @override
  String get stopReportStopNameWrong => 'Nazwa przystanku jest błędna';

  @override
  String get stopReportStopNumberWrong => 'Numer przystanku jest błędny';

  @override
  String get stopReportStopLocationWrong => 'Przystanek jest w złym miejscu';

  @override
  String get stopReportRouteMissing => 'Brakuje linii lub kursu';

  @override
  String get stopReportOther => 'Coś innego';

  @override
  String get stopReportNeverCame => 'Pojazd nie przyjechał';

  @override
  String get stopReportCameEarly => 'Przyjechał za wcześnie';

  @override
  String get stopReportCameLate => 'Przyjechał za późno';

  @override
  String get stopReportWrongHeadsign => 'Kierunek na tablicy był błędny';

  @override
  String get stopReportNotStopHere => 'Nie zatrzymał się tutaj';

  @override
  String get stopReportComment => 'Dodatkowe uwagi (opcjonalnie)';

  @override
  String get stopReportShareLocation => 'Udostępnij moją lokalizację';

  @override
  String get stopReportShareLocationHelp =>
      'Udostępnienie lokalizacji może pomóc przewoźnikowi rozwiązać ten problem.';

  @override
  String get stopReportOnVehicle => 'Jadę tym pojazdem';

  @override
  String get stopReportVehicleId => 'Numer pojazdu (opcjonalnie)';

  @override
  String get stopReportSend => 'Wyślij zgłoszenie';

  @override
  String get stopReportSending => 'Wysyłanie zgłoszenia';

  @override
  String get stopReportSent => 'Dziękujemy! Zgłoszenie zostało wysłane.';

  @override
  String get stopReportFailed =>
      'Nie udało się wysłać zgłoszenia. Spróbuj ponownie.';

  @override
  String get stopReportChooseProblem => 'Najpierw wybierz problem.';

  @override
  String stopReportAbout(String name) {
    return 'Zgłoszenie: $name';
  }

  @override
  String get stopGhostTitle => 'Zgłoś autobus widmo';

  @override
  String get stopGhostExplain =>
      'Autobus widmo to pojazd, który aplikacja pokazywała, ale który nigdy nie przyjechał.';

  @override
  String get stopGhostWait => 'Jak długo czekałeś po planowej godzinie?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30+ min';

  @override
  String get stopCardEmpty => 'Wkrótce brak odjazdów';

  @override
  String get titleSearch => 'Szukaj';

  @override
  String get titleSearchResults => 'Wyniki';

  @override
  String get titleNearbyStops => 'Przystanki w pobliżu';

  @override
  String get titleRecentStops => 'Ostatnie przystanki';

  @override
  String get titleBookmarks => 'Zakładki';

  @override
  String get titleStop => 'Przystanek';

  @override
  String get titleTrip => 'Kurs';

  @override
  String get titleRouteStops => 'Linia';

  @override
  String get titleStopSchedule => 'Rozkład';

  @override
  String get titleRouteSchedule => 'Rozkład linii';

  @override
  String get titleAlerts => 'Alerty';

  @override
  String get titleAlertDetail => 'Alert';

  @override
  String get titleAgencies => 'Przewoźnicy';

  @override
  String get titleRegionPicker => 'Regiony';

  @override
  String get titleCustomRegion => 'Region niestandardowy';

  @override
  String get titleSettings => 'Ustawienia';

  @override
  String get titleMapSettings => 'Ustawienia mapy';

  @override
  String get titleMore => 'Więcej';

  @override
  String get titleTripPlanner => 'Zaplanuj podróż';

  @override
  String get titlePlace => 'Miejsce';

  @override
  String get titleReportStopProblem => 'Zgłoś problem';

  @override
  String get titleReportTripProblem => 'Zgłoś problem';

  @override
  String get titleBookmarkEditor => 'Zakładka';

  @override
  String get titleManageBookmarks => 'Edytuj zakładki';

  @override
  String get titleCredits => 'Podziękowania';

  @override
  String get titleWeather => 'Pogoda';

  @override
  String get titleStopsOnMap => 'Przystanki na mapie';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Witaj w $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Odjazdy autobusów, pociągów i promów w pobliżu, na żywo.';

  @override
  String get onboardingLocationTitle => 'Znajdź przystanki w pobliżu';

  @override
  String get onboardingLocationBody =>
      'Zezwól na dostęp do lokalizacji, aby zobaczyć pobliskie przystanki i automatycznie wybrać region.';

  @override
  String get onboardingAllowLocation => 'Zezwól na dostęp do lokalizacji';

  @override
  String get onboardingRegionTitle => 'Wybierz region';

  @override
  String get onboardingRegionBody =>
      'Wybierz obszar, którego komunikację chcesz zobaczyć.';

  @override
  String get settingsSectionMap => 'Mapa';

  @override
  String get settingsMapTypeRow => 'Typ mapy i warstwy';

  @override
  String get settingsMapTypeHelp => 'Wybierz wygląd mapy.';

  @override
  String get settingsHeadingHelp =>
      'Pokazuje na mapie kierunek, w którym jesteś zwrócony.';

  @override
  String get settingsStopLabelsHelp =>
      'Pokazuje nazwy linii obok przystanków na mapie.';

  @override
  String get settingsWalkingDirections => 'Trasa piesza';

  @override
  String get settingsWalkingDirectionsHelp =>
      'Aplikacja otwierana po wybraniu trasy pieszej do przystanku.';

  @override
  String get settingsDirectionsAsk => 'Pytaj za każdym razem';

  @override
  String get settingsDirectionsAppleMaps => 'Mapy Apple';

  @override
  String get settingsDirectionsGoogleMaps => 'Mapy Google';

  @override
  String get settingsSectionDepartures => 'Odjazdy';

  @override
  String get settingsDepartureFilter => 'Pokazuj odjazdy';

  @override
  String get settingsDepartureFilterHelp =>
      'Wybierz, czy strony przystanków mają pokazywać wszystkie odjazdy, czy tylko te z danymi na żywo lub rozkładowymi.';

  @override
  String get settingsFilterAll => 'Wszystkie odjazdy';

  @override
  String get settingsFilterRealtime => 'Tylko na żywo';

  @override
  String get settingsFilterScheduled => 'Tylko planowe';

  @override
  String get settingsRegionTimeZone =>
      'Pokazuj godziny w strefie czasowej regionu';

  @override
  String get settingsRegionTimeZoneHelp =>
      'Godziny używają strefy czasowej regionu komunikacji, z dopiskiem, gdy różni się od strefy urządzenia.';

  @override
  String get settingsSectionAccessibility => 'Dostępność';

  @override
  String get settingsReducedColors => 'Ogranicz kolory na stronach przystanków';

  @override
  String get settingsReducedColorsHelp =>
      'Pokazuje oznaczenia linii w jednym neutralnym stylu.';

  @override
  String get settingsCompactMode => 'Zwarte strony przystanków i kursów';

  @override
  String get settingsCompactModeHelp =>
      'Zmniejsza odstępy, aby więcej mieściło się na ekranie.';

  @override
  String get settingsSectionWalking => 'Tempo chodzenia';

  @override
  String get settingsWalkingSpeed => 'Tempo chodzenia';

  @override
  String get settingsWalkingSpeedHelp =>
      'Używane do szacowania czasu dojścia i godzin przybycia.';

  @override
  String get settingsSpeedSlow => 'Wolne';

  @override
  String get settingsSpeedAverage => 'Przeciętne';

  @override
  String get settingsSpeedFast => 'Szybkie';

  @override
  String settingsSpeedCustom(String speed) {
    return 'Własne ($speed m/s)';
  }

  @override
  String get settingsSectionBike => 'Tryb rowerowy';

  @override
  String get settingsBikeMode => 'Tryb rowerowy';

  @override
  String get settingsBikeModeHelp =>
      'Używa większej prędkości do szacowania czasu dojścia, godzin przybycia i na stronie przystanku.';

  @override
  String get settingsSectionSurveys => 'Ankiety';

  @override
  String get settingsSurveysEnabled => 'Pokazuj ankiety';

  @override
  String get settingsSurveysAlways => 'Zawsze pokazuj ankiety na przystankach';

  @override
  String get settingsSectionPrivacy => 'Prywatność';

  @override
  String get settingsAnalytics => 'Wysyłaj dane o użytkowaniu deweloperom';

  @override
  String get settingsAnalyticsHelp =>
      'Pomaga deweloperom sprawdzić, z jakich funkcji korzysta się najczęściej.';

  @override
  String get settingsSectionDebug => 'Debugowanie';

  @override
  String get settingsDebugMode => 'Tryb debugowania';

  @override
  String get settingsDebugAlwaysFeedback => 'Zawsze pokazuj prośbę o opinię';

  @override
  String get settingsDebugResetFeedback => 'Zresetuj stan prośby o opinię';

  @override
  String get settingsDebugResetDonation => 'Zresetuj stan karty darowizny';

  @override
  String get settingsDebugResetDone => 'Zresetowano';

  @override
  String get settingsSectionTripPlanner => 'Planer podróży';

  @override
  String get settingsHomeCustomizeMap => 'Dostosuj mapę';

  @override
  String get moreHeaderSupport =>
      'Ta aplikacja jest tworzona i wspierana przez wolontariuszy.';

  @override
  String get moreSectionDonate => 'Zostań wspierającym';

  @override
  String moreDonate(String appName) {
    return 'Wesprzyj $appName';
  }

  @override
  String get moreManageDonations => 'Zarządzaj darowiznami';

  @override
  String get moreSectionUpdates => 'Aktualizacje i alerty';

  @override
  String get moreAlerts => 'Alerty';

  @override
  String get moreSectionLocation => 'Moja lokalizacja';

  @override
  String get moreRegion => 'Region';

  @override
  String get moreRegionNone => 'Nie wybrano';

  @override
  String get morePayFare => 'Zapłać za przejazd';

  @override
  String get moreAgencies => 'Przewoźnicy';

  @override
  String get moreSectionAbout => 'O tej aplikacji';

  @override
  String moreRateApp(String appName) {
    return 'Oceń $appName';
  }

  @override
  String get moreContactUs => 'Kontakt';

  @override
  String get morePrivacy => 'Polityka prywatności';

  @override
  String get moreCredits => 'Podziękowania';

  @override
  String moreVersion(String appName, String version) {
    return '$appName, wersja $version';
  }

  @override
  String get moreSectionHelpOut => 'Pomóż ulepszyć aplikację';

  @override
  String get moreTranslate => 'Pomóż przetłumaczyć aplikację';

  @override
  String get moreDevelop => 'Pomóż naprawić błędy i tworzyć nowe funkcje';

  @override
  String get moreSectionContact => 'Kontakt i pomoc';

  @override
  String get moreTutorials => 'Poradniki';

  @override
  String get moreCallAgency => 'Zadzwoń do przewoźnika';

  @override
  String get moreTextAgency => 'Napisz do przewoźnika';

  @override
  String get moreSectionResources => 'Zasoby';

  @override
  String get moreContactTitle => 'Kontakt z nami';

  @override
  String get moreContactDevelopers => 'Zgłoszenie nowej funkcji lub błędu';

  @override
  String get moreContactAgency => 'Problem z pojazdem lub rozkładem';

  @override
  String moreEmailSubject(String appName) {
    return 'Opinia o $appName';
  }

  @override
  String get moreEmailAgencySubject => 'Opinia pasażera komunikacji';

  @override
  String get moreEmailIntro =>
      'W czym możemy pomóc? Wpisz swoją odpowiedź poniżej:';

  @override
  String get moreEmailDebugIntro =>
      'Poniższe informacje służą do diagnozowania problemów. Jeśli nie chcesz ich udostępniać, możesz je usunąć, ale może to utrudnić nam udzielenie pomocy.';

  @override
  String get moreDebugAppVersion => 'Wersja aplikacji';

  @override
  String get moreDebugOs => 'System operacyjny';

  @override
  String get moreDebugLocale => 'Język';

  @override
  String get moreDebugBookmarks => 'Liczba zakładek';

  @override
  String get moreDebugLocationPermission => 'Uprawnienie do lokalizacji';

  @override
  String get moreDebugRegion => 'Region';

  @override
  String get moreDebugRegionId => 'ID regionu';

  @override
  String get moreDebugApiUrl => 'Bazowy adres URL API';

  @override
  String get moreDebugUserId => 'ID użytkownika';

  @override
  String get moreCantEmailTitle => 'Nie można otworzyć aplikacji poczty';

  @override
  String moreCantEmailBody(String email) {
    return 'Aby się z nami skontaktować, wyślij e-mail na adres $email. Skopiuj informacje diagnostyczne i wklej je do wiadomości, aby pomóc nam naprawić problem.';
  }

  @override
  String get moreCopyEmail => 'Skopiuj adres e-mail';

  @override
  String get moreCopyDebug => 'Skopiuj informacje diagnostyczne';

  @override
  String get moreCopied => 'Skopiowano do schowka';

  @override
  String get moreFareContinue => 'Dalej';

  @override
  String get moreFareDontShowAgain => 'Dalej i nie pokazuj ponownie';

  @override
  String get moreCantOpenLink => 'Nie udało się otworzyć tego linku.';

  @override
  String get regionPickerAutomatic => 'Wybieraj region automatycznie';

  @override
  String get regionPickerAutomaticHelp =>
      'Przełącza na region, w którym się znajdujesz. Wybranie regionu ręcznie wyłącza tę opcję.';

  @override
  String get regionPickerShowExperimental => 'Pokaż regiony eksperymentalne';

  @override
  String get regionPickerShowInactive => 'Pokaż regiony nieaktywne';

  @override
  String get regionPickerRegionsSection => 'Regiony';

  @override
  String get regionPickerCustomSection => 'Regiony niestandardowe';

  @override
  String get regionPickerCurrent => 'Bieżący region';

  @override
  String get regionPickerExperimentalTag => 'Eksperymentalny';

  @override
  String get regionPickerInactiveTag => 'Nieaktywny';

  @override
  String get regionPickerCustomTag => 'Niestandardowy';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Dodaj region niestandardowy';

  @override
  String get regionPickerRefresh => 'Odśwież regiony';

  @override
  String get regionPickerRefreshed => 'Regiony zaktualizowane';

  @override
  String get regionPickerRefreshFailed =>
      'Nie udało się zaktualizować listy regionów. Pokazano zapisaną listę.';

  @override
  String regionPickerSelected(String name) {
    return 'Wybrano: $name';
  }

  @override
  String regionPickerEdit(String name) {
    return 'Edytuj: $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'Usuń: $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'Usunąć: $name?';
  }

  @override
  String get regionPickerDeleteBody =>
      'Ten region niestandardowy zostanie usunięty z tego urządzenia.';

  @override
  String get regionPickerDeleteConfirm => 'Usuń';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Wybierz inny region, zanim usuniesz ten.';

  @override
  String get regionPickerEmpty => 'Brak dostępnych regionów';

  @override
  String get regionPickerEmptyBody =>
      'Włącz regiony eksperymentalne lub nieaktywne albo dodaj region niestandardowy.';

  @override
  String get regionPickerTripPlanner => 'Planer podróży w tym regionie';

  @override
  String get customRegionEditTitle => 'Edytuj region niestandardowy';

  @override
  String get customRegionName => 'Nazwa';

  @override
  String get customRegionObaUrl => 'Adres URL serwera OneBusAway';

  @override
  String get customRegionObaUrlHelp =>
      'Adres serwera, na przykład https://oba.example.com/';

  @override
  String get customRegionSidecar => 'Adres URL serwera Sidecar (opcjonalnie)';

  @override
  String get customRegionOtp => 'Adres URL planera podróży (opcjonalnie)';

  @override
  String get customRegionOtpGraphql =>
      'Adres URL GraphQL planera podróży (opcjonalnie)';

  @override
  String get customRegionServiceArea => 'Obszar usług';

  @override
  String get customRegionServiceAreaHelp =>
      'Obszar objęty tym regionem: punkt środkowy i zasięg.';

  @override
  String get customRegionLatitude => 'Szerokość geograficzna środka';

  @override
  String get customRegionLongitude => 'Długość geograficzna środka';

  @override
  String get customRegionLatSpan => 'Zakres szerokości (stopnie)';

  @override
  String get customRegionLonSpan => 'Zakres długości (stopnie)';

  @override
  String get customRegionUseMap => 'Użyj bieżącego obszaru mapy';

  @override
  String get customRegionSave => 'Zapisz';

  @override
  String get customRegionErrorRequired => 'To pole jest wymagane';

  @override
  String get customRegionErrorUrl =>
      'Wpisz adres internetowy zaczynający się od http:// lub https://';

  @override
  String get customRegionErrorNumber => 'Wpisz liczbę';

  @override
  String get customRegionErrorRange => 'Ta liczba jest poza zakresem';

  @override
  String get customRegionChecking => 'Sprawdzanie serwera';

  @override
  String get customRegionServerOk => 'Serwer odpowiedział';

  @override
  String get customRegionServerUnreachable =>
      'Nie udało się połączyć z tym serwerem';

  @override
  String get customRegionServerNotOba =>
      'Ten serwer nie odpowiedział jak OneBusAway';

  @override
  String customRegionSaved(String name) {
    return 'Zapisano: $name';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway to darmowe oprogramowanie transportu publicznego o otwartym kodzie, tworzone przez wolontariuszy i wspierane przez Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'Licencja';

  @override
  String get creditsMapData => 'Dane mapy';

  @override
  String get creditsLicenses => 'Licencje open source';

  @override
  String get creditsLicensesHelp =>
      'Biblioteki, z których zbudowana jest ta aplikacja.';

  @override
  String get creditsLicensesLoading => 'Wczytywanie licencji';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count licencji',
      many: '$count licencji',
      few: '$count licencje',
      one: '$count licencja',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Dostępne w dziesiątkach regionów komunikacji na całym świecie.';

  @override
  String get onboardingBenefitNearbyTitle => 'Zobacz przystanki w pobliżu';

  @override
  String get onboardingBenefitNearbyBody =>
      'Autobusy i pociągi wokół Ciebie, posortowane według odległości.';

  @override
  String get onboardingBenefitMapTitle => 'Wyśrodkuj mapę na sobie';

  @override
  String get onboardingBenefitMapBody =>
      'Otwieraj od razu swoją okolicę, bez szukania.';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName używa Twojej lokalizacji tylko wtedy, gdy aplikacja jest otwarta. Możesz to zmienić w dowolnym momencie w ustawieniach urządzenia.';
  }

  @override
  String get onboardingLocationDenied =>
      'Dostęp do lokalizacji jest wyłączony. Nadal możesz sam wybrać region.';

  @override
  String get onboardingRegionDetected => 'Wykryto w pobliżu';

  @override
  String onboardingRegionUse(String name) {
    return 'Użyj: $name';
  }

  @override
  String get onboardingRegionOthers => 'Albo wybierz inny region';

  @override
  String get onboardingRegionEmpty =>
      'Brak dostępnych regionów. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get surveyCardTitle => 'Pomóż ulepszyć komunikację';

  @override
  String get surveyDefaultPrompt =>
      'Wypełnij krótką ankietę, aby pomóc ulepszyć komunikację.';

  @override
  String get surveyTake => 'Wypełnij ankietę';

  @override
  String get surveyNotNow => 'Nie teraz';

  @override
  String get surveyDismiss => 'Odrzuć ankietę';

  @override
  String get surveyNext => 'Dalej';

  @override
  String get surveySubmit => 'Wyślij ankietę';

  @override
  String get surveySubmitting => 'Wysyłanie';

  @override
  String get surveyQuestionsTitle => 'Ankieta';

  @override
  String get surveyTextHint => 'Wpisz odpowiedź';

  @override
  String get surveyRequired => 'Wymagane';

  @override
  String get surveyIncomplete =>
      'Odpowiedz na wszystkie wymagane pytania przed wysłaniem.';

  @override
  String get surveyFailed =>
      'Nie udało się wysłać odpowiedzi. Spróbuj ponownie.';

  @override
  String get surveyThanks => 'Dziękujemy za opinię.';

  @override
  String get surveyOpenSurvey => 'Otwórz ankietę';

  @override
  String get surveyLearnMore => 'Dowiedz się więcej';

  @override
  String get surveyShareFeedback => 'Prześlij opinię';

  @override
  String get surveySignUp => 'Zapisz się';

  @override
  String get surveyExternalError =>
      'Nie udało się otworzyć linku do ankiety. Spróbuj ponownie później.';

  @override
  String donationTitle(String appName) {
    return '$appName potrzebuje Twojej pomocy';
  }

  @override
  String get donationBody =>
      'Ta aplikacja jest tworzona przez wolontariuszy i potrzebujemy Twojej pomocy w finansowaniu dalszego rozwoju.';

  @override
  String get donationLearnMore => 'Dowiedz się więcej';

  @override
  String get donationDonate => 'Przekaż darowiznę';

  @override
  String get donationRemindLater => 'Przypomnij później';

  @override
  String get donationDismiss => 'Nie, dziękuję';

  @override
  String get donationHeader => 'Dlaczego potrzebujemy Twojej pomocy';

  @override
  String donationExplanation(String appName) {
    return 'Mamy duże plany rozwoju aplikacji $appName, ale nie zrealizujemy ich bez Twojej pomocy. Ta aplikacja jest tworzona przez wolontariuszy i potrzebujemy Twojej pomocy w finansowaniu dalszego rozwoju.\n\nJako kluczowy projekt Open Transit Software Foundation, organizacji non-profit, Twoja darowizna podlega odliczeniu od podatku w Stanach Zjednoczonych.';
  }

  @override
  String get donationDonateWebsite => 'Przekaż darowiznę na naszej stronie';

  @override
  String titleDonation(String appName) {
    return 'Wesprzyj $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'Podoba Ci się $appName?';
  }

  @override
  String get feedbackYes => 'Tak!';

  @override
  String get feedbackNo => 'Nie bardzo';

  @override
  String get feedbackLater => 'Zapytaj mnie później';

  @override
  String get feedbackNegativeTitle => 'Przykro nam.';

  @override
  String get feedbackNegativeBody =>
      'Powiesz nam, co jest nie tak? Czytamy każdą wiadomość.';

  @override
  String get feedbackSend => 'Wyślij opinię';

  @override
  String get feedbackDecline => 'Nie, dziękuję';

  @override
  String get tripPlanningUnavailable =>
      'Planowanie podróży nie jest dostępne w tym regionie.';

  @override
  String get deepLinkOtherRegion =>
      'Ten link dotyczy innego regionu. Zmień region, aby go otworzyć.';

  @override
  String get dataUpdated => 'Zaktualizowano';

  @override
  String get bookmarksEtaNow => 'Teraz';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'za $minutes minuty',
      many: 'za $minutes minut',
      few: 'za $minutes minuty',
      one: 'za $minutes minutę',
      zero: 'teraz',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => 'Punktualnie';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min opóźnienia',
      one: '$minutes min opóźnienia',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min wcześniej',
      one: '$minutes min wcześniej',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => 'Planowo';

  @override
  String get bookmarksStatusCanceled => 'Odwołany';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Linia $route do $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Linia $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Wczytywanie odjazdów';

  @override
  String get bookmarksNoDepartures => 'Brak nadchodzących odjazdów';

  @override
  String get bookmarksDeparturesError => 'Nie udało się wczytać odjazdów';

  @override
  String get bookmarksDeparturesStale =>
      'Nie udało się odświeżyć. Pokazano wcześniejsze godziny.';

  @override
  String get bookmarksUpdated => 'Odjazdy zaktualizowane';

  @override
  String get bookmarksSortTooltip => 'Sortuj zakładki';

  @override
  String get bookmarksSortByGroup => 'Sortuj według grupy';

  @override
  String get bookmarksSortByDistance => 'Sortuj według odległości';

  @override
  String get bookmarksManageTooltip => 'Edytuj zakładki i grupy';

  @override
  String get bookmarksRefreshTooltip => 'Odśwież odjazdy';

  @override
  String get bookmarksEmptyTitle => 'Brak zakładek';

  @override
  String get bookmarksEmptyBody =>
      'Otwórz przystanek i dotknij przycisku zakładki, aby zapisać go tutaj. Z poziomu odjazdu możesz też dodać do zakładek tylko daną linię na tym przystanku.';

  @override
  String get bookmarksFindStops => 'Znajdź przystanki na mapie';

  @override
  String get bookmarksUngrouped => 'Bez grupy';

  @override
  String get bookmarksGroupExpanded => 'rozwinięte';

  @override
  String get bookmarksGroupCollapsed => 'zwinięte';

  @override
  String get bookmarksGroupToggleHint =>
      'Pokazuje lub ukrywa zakładki w tej grupie';

  @override
  String bookmarksActionsFor(String name) {
    return 'Działania dla: $name';
  }

  @override
  String get bookmarksActionEdit => 'Edytuj';

  @override
  String get bookmarksActionPin => 'Przypnij na górze';

  @override
  String get bookmarksActionUnpin => 'Odepnij';

  @override
  String get bookmarksActionMove => 'Przenieś do grupy';

  @override
  String get bookmarksActionDelete => 'Usuń';

  @override
  String get bookmarksPinned => 'Przypięte';

  @override
  String bookmarksDeleted(String name) {
    return 'Usunięto: $name';
  }

  @override
  String get bookmarksUndo => 'Cofnij';

  @override
  String get bookmarksMoveTitle => 'Przenieś do grupy';

  @override
  String get bookmarksNoGroup => 'Bez grupy';

  @override
  String bookmarksMoved(String group) {
    return 'Przeniesiono do: $group';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name, $details';
  }

  @override
  String get bookmarksEditorNameLabel => 'Nazwa zakładki';

  @override
  String get bookmarksEditorNameRequired => 'Wpisz nazwę tej zakładki.';

  @override
  String get bookmarksEditorDuplicate =>
      'Masz już zakładkę o tej nazwie dla tego przystanku i tej linii. Zmień nazwę, aby zapisać kolejną.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Zakładka przystanku: pokazuje najbliższe odjazdy wszystkich linii na przystanku $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Zakładka kursu: pokazuje najbliższe odjazdy linii $route na przystanku $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'Tylko linia $route';
  }

  @override
  String get bookmarksEditorGroup => 'Grupa';

  @override
  String get bookmarksEditorNewGroup => 'Nowa grupa…';

  @override
  String get bookmarksEditorNewGroupTitle => 'Nowa grupa';

  @override
  String get bookmarksEditorGroupName => 'Nazwa grupy';

  @override
  String get bookmarksEditorSave => 'Zapisz';

  @override
  String get bookmarksEditorSaved => 'Zakładka zapisana';

  @override
  String get bookmarksEditorDelete => 'Usuń zakładkę';

  @override
  String get bookmarksEditorDeleteTitle => 'Usunąć tę zakładkę?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return 'Zakładka „$name” zostanie usunięta z Twoich zakładek.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Wybierz region, zanim dodasz zakładki.';

  @override
  String get bookmarksManageGroupsHeader => 'Grupy';

  @override
  String get bookmarksManageBookmarksHeader => 'Zakładki';

  @override
  String get bookmarksManageAddGroup => 'Dodaj grupę';

  @override
  String get bookmarksManageRenameGroup => 'Zmień nazwę grupy';

  @override
  String get bookmarksManageDeleteGroup => 'Usuń grupę';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'Zakładki z grupy „$name” zostaną przeniesione do sekcji bez grupy.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Przesuń w górę: $name';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Przesuń w dół: $name';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Zmień kolejność: $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, pozycja $position z $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'Nie ma jeszcze zakładek ani grup do zarządzania.';

  @override
  String get bookmarksManageUngrouped => 'Zakładki bez grupy';

  @override
  String get recentsEmptyTitle => 'Brak ostatnich przystanków';

  @override
  String get recentsEmptyBody =>
      'Przystanki, które oglądasz, pojawiają się tutaj, najnowsze na górze.';

  @override
  String get recentsFindStops => 'Znajdź przystanki na mapie';

  @override
  String get recentsClearAll => 'Wyczyść wszystko';

  @override
  String get recentsClearTitle => 'Wyczyścić ostatnie przystanki?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Zostanie usuniętych wszystkie $count ostatnich przystanków. Twoje zakładki nie zostaną naruszone.',
      many:
          'Zostanie usuniętych wszystkie $count ostatnich przystanków. Twoje zakładki nie zostaną naruszone.',
      few:
          'Zostaną usunięte wszystkie $count ostatnie przystanki. Twoje zakładki nie zostaną naruszone.',
      one:
          'Zostanie usunięty $count ostatni przystanek. Twoje zakładki nie zostaną naruszone.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Usuń z ostatnich przystanków: $name';
  }

  @override
  String recentsRemoved(String name) {
    return 'Usunięto: $name';
  }

  @override
  String get recentsSectionEmpty =>
      'Przystanki, które oglądasz, pojawiają się tutaj.';

  @override
  String get alarmsSectionTitle => 'Alarmy';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty przed odjazdem',
      many: '$minutes minut przed odjazdem',
      few: '$minutes minuty przed odjazdem',
      one: '$minutes minutę przed odjazdem',
    );
    return '$_temp0, o $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Alarm dla: $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'Usuń alarm dla: $title';
  }

  @override
  String get alarmsDeleted => 'Alarm usunięty';

  @override
  String get alarmsDeleteFailed =>
      'Nie udało się usunąć alarmu. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get alarmsOpen => 'Otwiera kurs';

  @override
  String get alertsEmptyTitle => 'Brak alertów o utrudnieniach';

  @override
  String get alertsEmptyBody =>
      'Obecnie nie ma aktywnych alertów o utrudnieniach.';

  @override
  String get alertsRegionNote =>
      'Obejmuje alerty dla przystanków z zakładek, ostatnich i znajdujących się w pobliżu.';

  @override
  String get alertsMarkAllRead => 'Oznacz wszystkie jako przeczytane';

  @override
  String get alertsAllRead => 'Wszystkie alerty oznaczono jako przeczytane';

  @override
  String get alertsUnread => 'Nieprzeczytany';

  @override
  String get alertsSeverityInfo => 'Informacja';

  @override
  String get alertsSeverityWarning => 'Ostrzeżenie';

  @override
  String get alertsSeveritySevere => 'Poważne';

  @override
  String get alertsSeverityUnknown => 'Alert o utrudnieniach';

  @override
  String get alertsNoTitle => 'Alert o utrudnieniach';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Nieprzeczytany. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nieprzeczytanego alertu',
      many: '$count nieprzeczytanych alertów',
      few: '$count nieprzeczytane alerty',
      one: '$count nieprzeczytany alert',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kolejnego alertu',
      many: '$count kolejnych alertów',
      few: '$count kolejne alerty',
      one: '$count kolejny alert',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Okres obowiązywania';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start do $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'Od $start';
  }

  @override
  String get alertsDetailAffects => 'Dotyczy';

  @override
  String get alertsDetailRoutes => 'Linie';

  @override
  String get alertsDetailStops => 'Przystanki';

  @override
  String get alertsDetailAgencies => 'Przewoźnicy';

  @override
  String get alertsDetailLearnMore => 'Dowiedz się więcej';

  @override
  String get alertsDetailNoDetails => 'Brak dodatkowych szczegółów.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Wydano $date';
  }

  @override
  String get alertsCouldNotOpen => 'Nie udało się otworzyć tego linku.';

  @override
  String get agenciesEmptyTitle => 'Brak przewoźników';

  @override
  String get agenciesEmptyBody => 'Ten region nie podał żadnych przewoźników.';

  @override
  String get agenciesWebsite => 'Strona internetowa';

  @override
  String agenciesPhone(String phone) {
    return 'Zadzwoń: $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'Napisz e-mail: $email';
  }

  @override
  String get agenciesFares => 'Informacje o cenach biletów';

  @override
  String get agenciesDisclaimer => 'Zastrzeżenie';

  @override
  String get agenciesShowOnMap => 'Pokaż zasięg na mapie';

  @override
  String get searchFieldLabel => 'Szukaj';

  @override
  String get searchFieldHint => 'Linia, numer przystanku, adres lub pojazd';

  @override
  String get searchClear => 'Wyczyść wyszukiwanie';

  @override
  String get searchScopeLabel => 'Szukaj';

  @override
  String get searchScopeAll => 'Wszystko';

  @override
  String get searchScopeStops => 'Przystanki';

  @override
  String get searchScopeRoutes => 'Linie';

  @override
  String get searchScopePlaces => 'Miejsca';

  @override
  String get searchQuickHeader => 'Szukaj';

  @override
  String searchQuickRoute(String query) {
    return 'Linia: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Numer przystanku: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Adres: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Pojazd: $query';
  }

  @override
  String get searchRecentStopsHeader => 'Ostatnie przystanki';

  @override
  String get searchBookmarksHeader => 'Zakładki';

  @override
  String get searchRecentSearchesHeader => 'Ostatnie wyszukiwania';

  @override
  String get searchRecentPlacesHeader => 'Ostatnie miejsca';

  @override
  String get searchPlacesHeader => 'Miejsca';

  @override
  String get searchClearRecent => 'Wyczyść ostatnie wyszukiwania';

  @override
  String get searchClearRecentConfirm =>
      'Wyczyścić ostatnie wyszukiwania i miejsca?';

  @override
  String get searchClearAction => 'Wyczyść';

  @override
  String get searchRecentCleared => 'Ostatnie wyszukiwania wyczyszczone';

  @override
  String get searchPlacesLoading => 'Wyszukiwanie miejsc';

  @override
  String get searchPlacesNone => 'Nie znaleziono miejsc';

  @override
  String get searchPlacesError =>
      'Nie udało się wyszukać miejsc. Sprawdź połączenie.';

  @override
  String get searchSearching => 'Wyszukiwanie';

  @override
  String get searchNoResultsTitle => 'Brak wyników';

  @override
  String searchNoResultsBody(String query) {
    return 'Nie znaleziono wyników dla „$query”.';
  }

  @override
  String get searchUnavailableNoRegion =>
      'Wybierz region, zanim zaczniesz szukać.';

  @override
  String get searchUnavailableAddress =>
      'Wyszukiwanie adresów nie jest skonfigurowane w tej aplikacji.';

  @override
  String get searchUnavailableVehicle =>
      'Wyszukiwanie pojazdów nie jest dostępne w tym regionie.';

  @override
  String get searchEmptyTitle => 'Znajdź linie, przystanki i miejsca';

  @override
  String get searchEmptyBody =>
      'Wpisz nazwę linii, numer przystanku, adres lub ID pojazdu.';

  @override
  String get searchDismissMessage => 'Zamknij';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wyniku dla „$query”',
      many: '$count wyników dla „$query”',
      few: '$count wyniki dla „$query”',
      one: '$count wynik dla „$query”',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'Linie';

  @override
  String get searchResultsStops => 'Przystanki';

  @override
  String get searchResultsVehicles => 'Pojazdy';

  @override
  String get searchResultsPlaces => 'Miejsca';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Linia $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Pojazd $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'Pojazd $id nie obsługuje teraz żadnego kursu.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Wczytywanie pojazdu $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'Włącz lokalizację, aby zobaczyć odjazdy z pobliskich przystanków.';

  @override
  String get searchNearbyLocationButton => 'Użyj mojej lokalizacji';

  @override
  String get searchNearbyLocationDenied =>
      'Dostęp do lokalizacji jest wyłączony. Włącz go w ustawieniach urządzenia, aby zobaczyć pobliskie przystanki.';

  @override
  String get searchNearbyLocationServicesOff =>
      'Usługi lokalizacji są wyłączone. Włącz je, aby zobaczyć pobliskie przystanki.';

  @override
  String get searchNearbyLocationUnavailable =>
      'Ta aplikacja nie korzysta z Twojej lokalizacji, więc nie może pokazać pobliskich przystanków.';

  @override
  String get searchNearbyEmpty => 'Brak przystanków w pobliżu';

  @override
  String get searchNearbyEmptyBody =>
      'W odległości spaceru nie ma żadnych przystanków.';

  @override
  String get searchNearbyMapCenter =>
      'Pokazano przystanki w pobliżu środka mapy.';

  @override
  String get searchNearbyNoDepartures =>
      'Brak odjazdów w ciągu najbliższej godziny';

  @override
  String get searchNearbyLoadingDepartures => 'Wczytywanie odjazdów';

  @override
  String get searchNearbyUpdated => 'Pobliskie odjazdy zaktualizowane';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count przystanku w pobliżu',
      many: '$count przystanków w pobliżu',
      few: '$count przystanki w pobliżu',
      one: '$count przystanek w pobliżu',
      zero: 'Brak przystanków w pobliżu',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Ustalanie Twojej lokalizacji…';

  @override
  String get searchNearbyRefresh => 'Odśwież';

  @override
  String searchNearbyDistance(String distance) {
    return '$distance stąd';
  }

  @override
  String get searchNearbyOtherDirection => 'Inne przystanki';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return 'Przystanki: $direction';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route do $headsign, $eta, $status. Z przystanku $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'Z przystanku $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Odjazdy w pobliżu';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get searchEtaNow => 'Teraz';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'za $minutes minuty',
      many: 'za $minutes minut',
      few: 'za $minutes minuty',
      one: 'za $minutes minutę',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => 'odjeżdża teraz';

  @override
  String get searchStatusOnTime => 'Punktualnie';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min opóźnienia',
      one: '$minutes min opóźnienia',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min wcześniej',
      one: '$minutes min wcześniej',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => 'Planowo';

  @override
  String get searchExplorePlanTrip => 'Zaplanuj podróż';

  @override
  String get searchExploreWeather => 'Pogoda';

  @override
  String get searchExploreAgencies => 'Przewoźnicy';

  @override
  String get searchPlaceAddress => 'Adres';

  @override
  String get searchPlaceCoordinates => 'Współrzędne';

  @override
  String get searchPlaceDistance => 'Odległość';

  @override
  String get searchPlaceDirectionsTo => 'Trasa do tego miejsca';

  @override
  String get searchPlaceDirectionsFrom => 'Trasa stąd';

  @override
  String get searchPlaceNearbyStops => 'Przystanki w pobliżu';

  @override
  String get searchPlaceShare => 'Udostępnij';

  @override
  String get searchPlaceOpenInMaps => 'Otwórz w aplikacji map';

  @override
  String get searchPlaceRemovePin => 'Usuń pinezkę';

  @override
  String get searchPlaceOpenFailed => 'Nie udało się otworzyć aplikacji map.';

  @override
  String get searchPlaceShareFailed => 'Nie udało się udostępnić tego miejsca.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Miejsce: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Pogoda: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Pokazuje prognozę';

  @override
  String get searchWeatherClear => 'Bezchmurnie';

  @override
  String get searchWeatherPartlyCloudy => 'Częściowe zachmurzenie';

  @override
  String get searchWeatherCloudy => 'Pochmurno';

  @override
  String get searchWeatherRain => 'Deszcz';

  @override
  String get searchWeatherSleet => 'Deszcz ze śniegiem';

  @override
  String get searchWeatherSnow => 'Śnieg';

  @override
  String get searchWeatherWindy => 'Wietrznie';

  @override
  String get searchWeatherFog => 'Mgła';

  @override
  String get searchWeatherUnknown => 'Nieznane warunki';

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
      other: '$value stopnia Fahrenheita',
      many: '$value stopni Fahrenheita',
      few: '$value stopnie Fahrenheita',
      one: '$value stopień Fahrenheita',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value stopnia Celsjusza',
      many: '$value stopni Celsjusza',
      few: '$value stopnie Celsjusza',
      one: '$value stopień Celsjusza',
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
  String get searchWeatherFeelsLike => 'Odczuwalna';

  @override
  String get searchWeatherWind => 'Wiatr';

  @override
  String get searchWeatherPrecip => 'Szansa deszczu';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'Maks. $high · Min. $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'Maksymalnie $high, minimalnie $low, w ciągu najbliższych 24 godzin';
  }

  @override
  String get searchWeatherHourly => 'Najbliższe 24 godziny';

  @override
  String get searchWeatherNow => 'Teraz';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, szansa deszczu $precip';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Temperatury w: $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'stopnie Fahrenheita (°F)';

  @override
  String get searchWeatherCelsius => 'stopnie Celsjusza (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Prognoza z $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'Pogoda nie jest dostępna dla tego regionu.';

  @override
  String get searchWeatherSummaryLabel => 'Dzisiaj';

  @override
  String get bookmarksSectionEmpty =>
      'Przystanki z zakładek pojawiają się tutaj.';

  @override
  String get coreDirectionNameN => 'Północ';

  @override
  String get coreDirectionNameNE => 'Północny wschód';

  @override
  String get coreDirectionNameE => 'Wschód';

  @override
  String get coreDirectionNameSE => 'Południowy wschód';

  @override
  String get coreDirectionNameS => 'Południe';

  @override
  String get coreDirectionNameSW => 'Południowy zachód';

  @override
  String get coreDirectionNameW => 'Zachód';

  @override
  String get coreDirectionNameNW => 'Północny zachód';

  @override
  String get coreDirectionAbbrN => 'Pn';

  @override
  String get coreDirectionAbbrNE => 'Pn-Wsch';

  @override
  String get coreDirectionAbbrE => 'Wsch';

  @override
  String get coreDirectionAbbrSE => 'Pd-Wsch';

  @override
  String get coreDirectionAbbrS => 'Pd';

  @override
  String get coreDirectionAbbrSW => 'Pd-Zach';

  @override
  String get coreDirectionAbbrW => 'Zach';

  @override
  String get coreDirectionAbbrNW => 'Pn-Zach';

  @override
  String get coreDirectionBoundN => 'Na północ';

  @override
  String get coreDirectionBoundNE => 'Na północny wschód';

  @override
  String get coreDirectionBoundE => 'Na wschód';

  @override
  String get coreDirectionBoundSE => 'Na południowy wschód';

  @override
  String get coreDirectionBoundS => 'Na południe';

  @override
  String get coreDirectionBoundSW => 'Na południowy zachód';

  @override
  String get coreDirectionBoundW => 'Na zachód';

  @override
  String get coreDirectionBoundNW => 'Na północny zachód';

  @override
  String get coreRouteTypeLightRail => 'Szybki tramwaj';

  @override
  String get coreRouteTypeSubway => 'Metro';

  @override
  String get coreRouteTypeRail => 'Kolej';

  @override
  String get coreRouteTypeBus => 'Autobus';

  @override
  String get coreRouteTypeFerry => 'Prom';

  @override
  String get coreRouteTypeCableCar => 'Tramwaj linowy';

  @override
  String get coreRouteTypeGondola => 'Gondola';

  @override
  String get coreRouteTypeFunicular => 'Kolej linowo-terenowa';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Przystanek nr $code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Przystanek: \'$code\'';
  }

  @override
  String coreStopId(String code) {
    return 'ID przystanku: $code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return 'Linie: $routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Linie: $routes, + $count więcej',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return 'Szukaj w: $region';
  }

  @override
  String get coreNow => 'TERAZ';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get coreOneMinute => 'Jedna minuta';

  @override
  String get coreOneMinuteAgo => 'Minutę temu';

  @override
  String coreMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty',
      many: '$minutes minut',
      few: '$minutes minuty',
      one: '$minutes minuta',
    );
    return '$_temp0';
  }

  @override
  String get coreJustNow => 'Przed chwilą';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds s temu';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes min temu';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours godz. temu';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnia temu',
      many: '$days dni temu',
      few: '$days dni temu',
      one: '$days dzień temu',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return 'Zaktualizowano: $ago';
  }

  @override
  String get coreScheduledNotRealTime => 'Planowo, nie na żywo';

  @override
  String coreArrivedMinAgo(int minutes) {
    return 'Przyjechał $minutes min temu';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return 'Odjechał $minutes min temu';
  }

  @override
  String get coreArrivingNow => 'Przyjeżdża teraz';

  @override
  String get coreDepartingNow => 'Odjeżdża teraz';

  @override
  String coreArrivesInMin(int minutes) {
    return 'Przyjedzie za $minutes min';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return 'Odjedzie za $minutes min';
  }

  @override
  String coreArrivedLate(int minutes) {
    return 'przyjechał z opóźnieniem $minutes min';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return 'przyjechał $minutes min wcześniej';
  }

  @override
  String get coreArrivedOnTime => 'przyjechał punktualnie';

  @override
  String coreDepartedLate(int minutes) {
    return 'odjechał z opóźnieniem $minutes min';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return 'odjechał $minutes min wcześniej';
  }

  @override
  String get coreDepartedOnTime => 'odjechał punktualnie';

  @override
  String coreArrivesLate(int minutes) {
    return 'przyjedzie z opóźnieniem $minutes min';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return 'przyjedzie $minutes min wcześniej';
  }

  @override
  String get coreArrivesOnTime => 'przyjedzie punktualnie';

  @override
  String coreDepartsLate(int minutes) {
    return 'odjedzie z opóźnieniem $minutes min';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return 'odjedzie $minutes min wcześniej';
  }

  @override
  String get coreDepartsOnTime => 'odjedzie punktualnie';

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
  String coreAlarmMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty',
      many: '$minutes minut',
      few: '$minutes minuty',
      one: '$minutes minuta',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsNow => 'teraz';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes min';
  }

  @override
  String get arrivalsCanceled => 'odwołany';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'co $minutes min od $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'co $minutes min do $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'Na północ';

  @override
  String get arrivalsDirectionBoundNE => 'Na północny wschód';

  @override
  String get arrivalsDirectionBoundE => 'Na wschód';

  @override
  String get arrivalsDirectionBoundSE => 'Na południowy wschód';

  @override
  String get arrivalsDirectionBoundS => 'Na południe';

  @override
  String get arrivalsDirectionBoundSW => 'Na południowy zachód';

  @override
  String get arrivalsDirectionBoundW => 'Na zachód';

  @override
  String get arrivalsDirectionBoundNW => 'Na północny zachód';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'Kierunek: $code';
  }

  @override
  String get arrivalsRefresh => 'Odśwież przyjazdy';

  @override
  String get arrivalsRetry => 'Spróbuj ponownie';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Brak przyjazdów w ciągu najbliższych $minutes min',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound =>
      'Nie znaleziono przystanku lub usługa jest niedostępna';

  @override
  String get arrivalsNetworkError =>
      'Nie udało się połączyć z serwerem komunikacji. Sprawdź połączenie.';

  @override
  String get arrivalsLoadError => 'Nie udało się wczytać przyjazdów.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'Nie udało się zaktualizować. Pokazano wyniki z $time';
  }

  @override
  String get arrivalsArrivingNow => 'przyjeżdża teraz';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'przyjedzie za $minutes minuty',
      many: 'przyjedzie za $minutes minut',
      few: 'przyjedzie za $minutes minuty',
      one: 'przyjedzie za $minutes minutę',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'na żywo';

  @override
  String get arrivalsRowTapHint => 'pokaż szczegóły';

  @override
  String arrivalsAtTime(String time) {
    return 'o $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty opóźnienia',
      many: '$minutes minut opóźnienia',
      few: '$minutes minuty opóźnienia',
      one: '$minutes minuta opóźnienia',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty wcześniej',
      many: '$minutes minut wcześniej',
      few: '$minutes minuty wcześniej',
      one: '$minutes minutę wcześniej',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'co $minutes minuty od $time',
      many: 'co $minutes minut od $time',
      few: 'co $minutes minuty od $time',
      one: 'co minutę od $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'co $minutes minuty do $time',
      many: 'co $minutes minut do $time',
      few: 'co $minutes minuty do $time',
      one: 'co minutę do $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'godzina rozkładowa';

  @override
  String get arrivalsLoading => 'Wczytywanie przyjazdów';

  @override
  String get arrivalsRefreshing => 'Odświeżanie przyjazdów';

  @override
  String get arrivalsUpdated => 'Przyjazdy zaktualizowane';

  @override
  String get tripPlannerOriginLabel => 'Z';

  @override
  String get tripPlannerDestinationLabel => 'Do';

  @override
  String get tripPlannerChooseOrigin => 'Wybierz punkt początkowy';

  @override
  String get tripPlannerChooseDestination => 'Wybierz cel podróży';

  @override
  String get tripPlannerCurrentLocation => 'Bieżąca lokalizacja';

  @override
  String get tripPlannerSwapEndpoints =>
      'Zamień punkt początkowy i cel podróży';

  @override
  String get tripPlannerPlanTrip => 'Zaplanuj podróż';

  @override
  String get tripPlannerPlanningTrip => 'Planowanie podróży';

  @override
  String get tripPlannerOptions => 'Opcje podróży';

  @override
  String get tripPlannerLeaveNow => 'Wyrusz teraz';

  @override
  String get tripPlannerDepartAt => 'Odjazd o';

  @override
  String get tripPlannerArriveBy => 'Przyjazd do';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Zmień godzinę, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Komunikacja';

  @override
  String get tripPlannerModeWalk => 'Pieszo';

  @override
  String get tripPlannerModeBike => 'Rower';

  @override
  String get tripPlannerModeCar => 'Samochód';

  @override
  String get tripPlannerModeBikeRental => 'Tylko rower miejski';

  @override
  String get tripPlannerModeTransitBikeRental => 'Komunikacja + rower miejski';

  @override
  String get tripPlannerWheelchairAccessible =>
      'Dostępne dla wózków inwalidzkich';

  @override
  String get tripPlannerWalkQuarterMile => '0,25 mili';

  @override
  String get tripPlannerWalkHalfMile => '0,5 mili';

  @override
  String get tripPlannerWalkOneMile => '1 mila';

  @override
  String get tripPlannerWalkTwoMiles => '2 mile';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'Pieszo do $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'Nie znaleziono podróży';

  @override
  String get tripPlannerRetry => 'Spróbuj ponownie';

  @override
  String get tripPlannerRealTime => 'Na żywo';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours godz.';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours godz. $minutes min';
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
      other: '$count przesiadki',
      many: '$count przesiadek',
      few: '$count przesiadki',
      one: '$count przesiadka',
      zero: 'Bez przesiadek',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return 'Pieszo $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Odjazd o $time z: $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'Punktualnie';

  @override
  String tripPlannerStatusLate(int minutes) {
    return 'opóźn. $minutes min';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '$minutes min wcześniej';
  }

  @override
  String get tripPlannerStatusScheduled => 'Planowo';

  @override
  String get tripPlannerLegBus => 'Autobus';

  @override
  String get tripPlannerLegTram => 'Tramwaj';

  @override
  String get tripPlannerLegSubway => 'Metro';

  @override
  String get tripPlannerLegRail => 'Pociąg';

  @override
  String get tripPlannerLegFerry => 'Prom';

  @override
  String get tripPlannerLegCableCar => 'Tramwaj linowy';

  @override
  String get tripPlannerLegGondola => 'Gondola';

  @override
  String get tripPlannerLegFunicular => 'Kolej linowo-terenowa';

  @override
  String get tripPlannerLegAirplane => 'Samolot';

  @override
  String get tripPlannerLegTrolleybus => 'Trolejbus';

  @override
  String get tripPlannerLegMonorail => 'Kolej jednoszynowa';

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
    return 'Pieszo $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return 'Rowerem $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return 'Rowerem miejskim $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return 'Samochodem $duration';
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
  String get tripPlannerThen => 'potem';

  @override
  String get tripPlannerOpenItineraryHint => 'pokaż szczegóły podróży';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuty',
      many: '$minutes minut',
      few: '$minutes minuty',
      one: '$minutes minuta',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours godziny',
      many: '$hours godzin',
      few: '$hours godziny',
      one: '$hours godzina',
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
      other: '$value stopy',
      many: '$value stóp',
      few: '$value stopy',
      one: '$value stopa',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value mili',
      many: '$value mil',
      few: '$value mile',
      one: '$value mila',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value metra',
      many: '$value metrów',
      few: '$value metry',
      one: '$value metr',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value kilometra',
      many: '$value kilometrów',
      few: '$value kilometry',
      one: '$value kilometr',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return '$start do $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'na żywo, punktualnie';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'na żywo, $minutes minuty opóźnienia',
      many: 'na żywo, $minutes minut opóźnienia',
      few: 'na żywo, $minutes minuty opóźnienia',
      one: 'na żywo, $minutes minuta opóźnienia',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'na żywo, $minutes minuty wcześniej',
      many: 'na żywo, $minutes minut wcześniej',
      few: 'na żywo, $minutes minuty wcześniej',
      one: 'na żywo, $minutes minutę wcześniej',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'godzina rozkładowa';

  @override
  String get tripPlannerResultsHeading => 'Proponowane podróże';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znaleziono $count podróży',
      many: 'Znaleziono $count podróży',
      few: 'Znaleziono $count podróże',
      one: 'Znaleziono $count podróż',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Znaleziono $count miejsca',
      many: 'Znaleziono $count miejsc',
      few: 'Znaleziono $count miejsca',
      one: 'Znaleziono $count miejsce',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'Mapa podróży. Wskazówki poniżej opisują tę samą podróż.';

  @override
  String get tripPlannerTripDetails => 'Szczegóły podróży';

  @override
  String get tripPlannerMapLabel => 'Mapa podróży';

  @override
  String get tripPlannerStart => 'Start';

  @override
  String get tripPlannerDestination => 'Cel podróży';

  @override
  String get tripPlannerUnnamedPlace => 'Miejsce bez nazwy';

  @override
  String get tripPlannerRentalBike => 'Rower miejski';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Idź do: $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Jedź rowerem do: $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Jedź rowerem miejskim do: $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Jedź samochodem do: $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Wsiądź: $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Wsiądź: $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Wsiądź: $mode, kierunek $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Wsiądź: $mode $route, kierunek $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Wysiądź na: $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Przyjazd do: $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count przystanku',
      many: '$count przystanków',
      few: '$count przystanki',
      one: '$count przystanek',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pokaż $count przystanku',
      many: 'Pokaż $count przystanków',
      few: 'Pokaż $count przystanki',
      one: 'Pokaż $count przystanek',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ukryj $count przystanku',
      many: 'Ukryj $count przystanków',
      few: 'Ukryj $count przystanki',
      one: 'Ukryj $count przystanek',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kroku',
      many: '$count kroków',
      few: '$count kroki',
      one: '$count krok',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pokaż $count kroku',
      many: 'Pokaż $count kroków',
      few: 'Pokaż $count kroki',
      one: 'Pokaż $count krok',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ukryj $count kroku',
      many: 'Ukryj $count kroków',
      few: 'Ukryj $count kroki',
      one: 'Ukryj $count krok',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, około $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Wyrusz';

  @override
  String get tripPlannerDirectionHardLeft => 'Skręć ostro w lewo';

  @override
  String get tripPlannerDirectionLeft => 'Skręć w lewo';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'Skręć lekko w lewo';

  @override
  String get tripPlannerDirectionContinue => 'Kontynuuj';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Skręć lekko w prawo';

  @override
  String get tripPlannerDirectionRight => 'Skręć w prawo';

  @override
  String get tripPlannerDirectionHardRight => 'Skręć ostro w prawo';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Wejdź na rondo i idź zgodnie z ruchem wskazówek zegara';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Wejdź na rondo i idź przeciwnie do ruchu wskazówek zegara';

  @override
  String get tripPlannerDirectionElevator => 'Skorzystaj z windy';

  @override
  String get tripPlannerDirectionUturnLeft => 'Zawróć w lewo';

  @override
  String get tripPlannerDirectionUturnRight => 'Zawróć w prawo';

  @override
  String get tripPlannerDirectionEnterStation => 'Wejdź na stację';

  @override
  String get tripPlannerDirectionExitStation => 'Wyjdź ze stacji';

  @override
  String get tripPlannerDirectionFollowSigns => 'Idź za oznaczeniami';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Idź: $street, $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction: $street, przejdź $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Szukaj miejsca';

  @override
  String get tripPlannerSearchNoResults => 'Nie znaleziono miejsc';

  @override
  String get tripPlannerSearchError =>
      'Nie udało się wyszukać miejsc. Spróbuj ponownie.';

  @override
  String get tripPlannerUseCurrentLocation => 'Użyj bieżącej lokalizacji';

  @override
  String get tripPlannerLocationUnavailable =>
      'Nie udało się ustalić Twojej lokalizacji.';

  @override
  String get tripPlannerClearSearch => 'Wyczyść wyszukiwanie';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Wybierz punkt początkowy i cel podróży.';

  @override
  String get tripPlannerErrorNetwork =>
      'Nie udało się połączyć z planerem podróży. Sprawdź połączenie.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'Serwer zwrócił nieprawidłową odpowiedź';

  @override
  String get tripPlannerErrorUnknown => 'Wystąpił nieznany błąd.';

  @override
  String get tripPlannerPlannerSystemError =>
      'Nie udało się teraz zaplanować podróży. Spróbuj ponownie.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'Planowanie podróży jest chwilowo niedostępne. Spróbuj ponownie za chwilę.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'Ta lokalizacja nie jest jeszcze obsługiwana.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'Brak dostępnej trasy dla tej podróży.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'Obecnie brak dostępnych połączeń komunikacją.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'To trwało dłużej niż zwykle. Spróbuj ponownie.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'Coś poszło nie tak z zapytaniem. Spróbuj ponownie.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'Nie udało się znaleźć punktu początkowego.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'Nie udało się znaleźć celu podróży.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'Nie udało się znaleźć ani punktu początkowego, ani celu podróży.';

  @override
  String get tripPlannerPlannerTooClose =>
      'Punkt początkowy i cel są zbyt blisko siebie.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'Ta trasa nie jest dostępna przy wybranej opcji.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'Punkt początkowy jest niejasny. Spróbuj podać go dokładniej.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'Cel podróży jest niejasny. Spróbuj podać go dokładniej.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Obie lokalizacje wymagają dokładniejszego opisu. Spróbuj je doprecyzować.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'Brakuje niektórych opcji trasy.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'Wybrane opcje trasy nie pasują do siebie.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Wybierz preferencję trasy.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Dostosuj preferencje trasy.';
}
