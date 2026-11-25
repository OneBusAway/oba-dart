// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class ObaLocalizationsIt extends ObaLocalizations {
  ObaLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get commonBack => 'Indietro';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonDone => 'Fatto';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonContinue => 'Continua';

  @override
  String get commonNotNow => 'Non ora';

  @override
  String get commonSeeAll => 'Mostra tutto';

  @override
  String get commonLoading => 'Caricamento';

  @override
  String get commonErrorTitle => 'Qualcosa è andato storto';

  @override
  String get commonEmptyTitle => 'Ancora niente qui';

  @override
  String get commonComingSoon => 'Prossimamente';

  @override
  String get commonComingSoonBody =>
      'Questa schermata non è ancora disponibile.';

  @override
  String get commonOffline =>
      'Sembra che tu sia offline. Controlla la connessione e riprova.';

  @override
  String get commonServerError =>
      'Il server non ha risposto come previsto. Riprova tra un attimo.';

  @override
  String get sheetLabel => 'Pannello';

  @override
  String get sheetExpand => 'Espandi il pannello';

  @override
  String get sheetCollapse => 'Comprimi il pannello';

  @override
  String get sheetHandleHint =>
      'Trascina o tocca due volte per ridimensionare il pannello';

  @override
  String get homeTabHome => 'Home';

  @override
  String get homeTabRecent => 'Recenti';

  @override
  String get homeTabBookmarks => 'Segnalibri';

  @override
  String get homeSearchPlaceholder => 'Cerca fermate, linee, luoghi';

  @override
  String get homeSearchLabel => 'Cerca';

  @override
  String get homeSectionNearby => 'Nelle vicinanze';

  @override
  String get homeSectionRecent => 'Fermate recenti';

  @override
  String get homeSectionBookmarks => 'Segnalibri';

  @override
  String get homeSectionAlerts => 'Avvisi';

  @override
  String get homeSectionExplore => 'Esplora';

  @override
  String get homeSectionMore => 'Impostazioni e altro';

  @override
  String get mapLabel => 'Mappa';

  @override
  String get mapZoomInForStops => 'Ingrandisci per vedere le fermate';

  @override
  String get mapLocationDenied =>
      'L’accesso alla posizione è disattivato. Tocca per consentirlo.';

  @override
  String get mapLocationServicesOff =>
      'I servizi di localizzazione sono disattivati';

  @override
  String get mapRecenter => 'Mostra la mia posizione';

  @override
  String get mapSettingsButton => 'Impostazioni mappa';

  @override
  String get mapStopsListButton => 'Fermate sulla mappa';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fermate sulla mappa',
      one: '$count fermata sulla mappa',
      zero: 'Nessuna fermata sulla mappa',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'La tua posizione';

  @override
  String get mapDroppedPin => 'Segnaposto inserito';

  @override
  String get mapVehicle => 'Veicolo';

  @override
  String get mapSelectedStop => 'Selezionata';

  @override
  String get mapBookmarkedStop => 'Nei segnalibri';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, fermata: $routeType';
  }

  @override
  String get mapStopMarkerHint => 'Apre le partenze della fermata';

  @override
  String mapAttribution(String attribution) {
    return 'Dati della mappa: $attribution';
  }

  @override
  String get mapTypeTitle => 'Tipo di mappa';

  @override
  String get mapTypeStandard => 'Standard';

  @override
  String get mapTypeSatellite => 'Satellite';

  @override
  String get mapTypeHybrid => 'Ibrida';

  @override
  String get mapShowScale => 'Mostra scala';

  @override
  String get mapShowHeading => 'Mostra direzione';

  @override
  String get mapShowStopLabels => 'Mostra nomi delle fermate';

  @override
  String mapPlaceAt(String lat, String lon) {
    return 'Posizione: $lat, $lon';
  }

  @override
  String get directionN => 'Direzione nord';

  @override
  String get directionNE => 'Direzione nord-est';

  @override
  String get directionE => 'Direzione est';

  @override
  String get directionSE => 'Direzione sud-est';

  @override
  String get directionS => 'Direzione sud';

  @override
  String get directionSW => 'Direzione sud-ovest';

  @override
  String get directionW => 'Direzione ovest';

  @override
  String get directionNW => 'Direzione nord-ovest';

  @override
  String get routeTypeBus => 'Autobus';

  @override
  String get routeTypeLightRail => 'Metropolitana leggera';

  @override
  String get routeTypeSubway => 'Metropolitana';

  @override
  String get routeTypeRail => 'Treno';

  @override
  String get routeTypeFerry => 'Traghetto';

  @override
  String get routeTypeCableCar => 'Tram a fune';

  @override
  String get routeTypeGondola => 'Cabinovia';

  @override
  String get routeTypeFunicular => 'Funicolare';

  @override
  String get routeTypeUnknown => 'Trasporto';

  @override
  String stopCode(String code) {
    return 'Fermata $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'Linee $routes';
  }

  @override
  String get stopPageRefresh => 'Aggiorna';

  @override
  String get stopPageRefreshed => 'Partenze aggiornate';

  @override
  String get stopPageBookmark => 'Aggiungi la fermata ai segnalibri';

  @override
  String get stopPageBookmarked =>
      'Aggiunta ai segnalibri. Modifica segnalibro';

  @override
  String get stopPageMoreActions => 'Altre azioni per la fermata';

  @override
  String get stopPageSchedules => 'Orari';

  @override
  String get stopPageServiceAlerts => 'Avvisi di servizio';

  @override
  String get stopPageNearbyStops => 'Fermate vicine';

  @override
  String get stopPageWalkingDirections => 'Indicazioni a piedi';

  @override
  String get stopPageBikeDirections => 'Indicazioni in bicicletta';

  @override
  String get stopPagePlanTripFrom => 'Pianifica un viaggio da qui';

  @override
  String get stopPagePlanTripTo => 'Pianifica un viaggio fino a qui';

  @override
  String get stopPageShareStop => 'Condividi la fermata';

  @override
  String get stopPageReportProblem => 'Segnala un problema';

  @override
  String get stopPageFilterRoutes => 'Filtra le linee';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linee nascoste',
      one: '$count linea nascosta',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'Per orario';

  @override
  String get stopPageModeRoute => 'Per linea';

  @override
  String get stopPageDepartureTypes => 'Tipi di partenze';

  @override
  String get stopPageFilterAll => 'Tutte le partenze';

  @override
  String get stopPageFilterRealtime => 'Solo in tempo reale';

  @override
  String get stopPageFilterScheduled => 'Solo orario previsto';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostra $count partenze passate',
      one: 'Mostra $count partenza passata',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Nascondi le partenze passate';

  @override
  String get stopPageLoadMore => 'Carica altre partenze';

  @override
  String stopPageWindow(int minutes) {
    return 'Prossimi $minutes minuti';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Aggiornato $ago';
  }

  @override
  String get stopPageStaleTitle => 'Impossibile aggiornare le partenze';

  @override
  String get stopPageStaleBody =>
      'Questi orari potrebbero non essere aggiornati.';

  @override
  String get stopPageEmptyTitle => 'Nessuna partenza imminente';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'Nessuna partenza nei prossimi $minutes minuti.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Tutte le linee con partenze qui sono nascoste.';

  @override
  String get stopPageShowAllRoutes => 'Mostra tutte le linee';

  @override
  String get stopPageEmptyFilter =>
      'Nessuna partenza corrisponde al filtro del tipo di partenza.';

  @override
  String get stopPageShowAllTypes => 'Mostra tutte le partenze';

  @override
  String get stopPageMissingTitle => 'Fermata non trovata';

  @override
  String get stopPageMissingBody =>
      'Questa fermata potrebbe essere stata rimossa o rinumerata.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes min a piedi';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes min in bici';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti a piedi',
      one: '$minutes minuto a piedi',
    );
    return '$_temp0, $distance. Apre le indicazioni.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti in bici',
      one: '$minutes minuto in bici',
    );
    return '$_temp0, $distance. Apre le indicazioni.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '$minutes min a piedi fino a questa fermata. Le partenze qui sopra sono troppo anticipate.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '$minutes min in bici fino a questa fermata. Le partenze qui sopra sono troppo anticipate.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Servizio di $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avvisi di servizio',
      one: '$count avviso di servizio',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count non letti',
      one: '$count non letto',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Non letto';

  @override
  String get stopPageAlertImportant => 'Importante';

  @override
  String get stopPageDirectionsChooser => 'Apri le indicazioni in';

  @override
  String get stopPageAppleMaps => 'Mappe';

  @override
  String get stopPageGoogleMaps => 'Google Maps';

  @override
  String get stopPageCannotOpen => 'Impossibile aprire quel link.';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Coincidenza da $route $headsign, arrivo $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Partenze';

  @override
  String get stopRowNow => 'ORA';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return '$minutes min fa';
  }

  @override
  String get stopRowOnTime => 'in orario';

  @override
  String stopRowLate(int minutes) {
    return '$minutes min di ritardo';
  }

  @override
  String stopRowEarly(int minutes) {
    return '$minutes min di anticipo';
  }

  @override
  String get stopRowScheduled => 'previsto';

  @override
  String get stopRowCanceled => 'cancellato';

  @override
  String get stopRowOccupancyEmpty => 'Vuoto';

  @override
  String get stopRowOccupancyManySeats => 'Molti posti a sedere';

  @override
  String get stopRowOccupancyFewSeats => 'Pochi posti a sedere';

  @override
  String get stopRowOccupancyStanding => 'Solo posti in piedi';

  @override
  String get stopRowOccupancyCrushed => 'Molto affollato';

  @override
  String get stopRowOccupancyFull => 'Pieno';

  @override
  String get stopRowOccupancyNotAccepting => 'Non accetta passeggeri';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arriva tra $minutes minuti',
      one: 'arriva tra $minutes minuto',
      zero: 'in arrivo ora',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'parte tra $minutes minuti',
      one: 'parte tra $minutes minuto',
      zero: 'in partenza ora',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arrivato $minutes minuti fa',
      one: 'arrivato $minutes minuto fa',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'partito $minutes minuti fa',
      one: 'partito $minutes minuto fa',
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
    return 'Linea $route verso $headsign, $eta, alle $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'monitoraggio in tempo reale, $status';
  }

  @override
  String get stopRowA11yScheduledOnly =>
      'solo orario previsto, senza dati in tempo reale';

  @override
  String get stopRowA11yTransfer => 'la tua corsa di coincidenza';

  @override
  String get stopRowA11yMissed =>
      'probabilmente perso, parte prima che tu possa arrivarci a piedi';

  @override
  String get stopRowA11yAlarm => 'sveglia impostata';

  @override
  String stopRowActions(String route) {
    return 'Altre azioni per la linea $route';
  }

  @override
  String get stopRowShowTrip => 'Mostra i dettagli della corsa';

  @override
  String get stopRowAddAlarm => 'Aggiungi sveglia';

  @override
  String get stopRowRemoveAlarm => 'Rimuovi sveglia';

  @override
  String get stopRowBookmarkTrip => 'Aggiungi questa corsa ai segnalibri';

  @override
  String get stopRowShareTrip => 'Condividi la corsa';

  @override
  String get stopRowRouteSchedule => 'Orari della linea';

  @override
  String get stopRowRouteStops => 'Fermate di questa linea';

  @override
  String stopRouteGroupNext(String times) {
    return 'Prossime: $times';
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
      other: '$count partenze',
      one: '$count partenza',
    );
    return 'Linea $route verso $headsigns, $_temp0, prossima $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Avvisami prima della partenza';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti prima',
      one: '$minutes minuto prima',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Sveglia impostata $minutes minuti prima',
      one: 'Sveglia impostata $minutes minuto prima',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Sveglia rimossa';

  @override
  String get stopAlarmFailed => 'Impossibile aggiornare la sveglia.';

  @override
  String get stopAlarmPermissionDenied =>
      'Le notifiche sono disattivate per questa app.';

  @override
  String get stopFilterTitle => 'Filtra le linee';

  @override
  String get stopFilterSort => 'Ordina le partenze';

  @override
  String get stopFilterRoutesHeader => 'Linee mostrate a questa fermata';

  @override
  String get stopFilterShowAll => 'Mostra tutte le linee';

  @override
  String get stopTripArrivingAtYourStop => 'In arrivo alla tua fermata';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A $count fermate di distanza',
      one: 'A $count fermata di distanza',
      zero: 'Alla tua fermata',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return 'A $distance di distanza';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'A $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Posizione aggiornata $ago';
  }

  @override
  String get stopTripNoPosition =>
      'Nessuna posizione in tempo reale per questo veicolo';

  @override
  String stopTripStartsAs(String trip) {
    return 'Inizia come $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Prosegue come $trip';
  }

  @override
  String get stopTripStopsHeader => 'Fermate';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fermate passate',
      one: '$count fermata passata',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fermate prima della tua',
      one: '$count fermata prima della tua',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'La tua fermata';

  @override
  String get stopTripBoarding => 'Salita in corso';

  @override
  String get stopTripVehicleHere => 'Il veicolo è qui';

  @override
  String get stopTripTerminal => 'Capolinea';

  @override
  String get stopTripPassed => 'Passata';

  @override
  String get stopTripRouteStops => 'Tutte le fermate di questa linea';

  @override
  String get stopTripReport => 'Segnala un problema con questa corsa';

  @override
  String get stopTripGhostBus => 'Segnala autobus fantasma';

  @override
  String get stopTripCanceled => 'Questa corsa è cancellata';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Veicolo della linea $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'Ogni $minutes min';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Linea $route';
  }

  @override
  String get stopRouteStopsDirection => 'Direzione';

  @override
  String stopRouteStopsToward(String name) {
    return 'Verso $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fermate',
      one: '$count fermata',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => 'Nessuna fermata trovata per questa linea.';

  @override
  String get stopSchedPrevDay => 'Giorno precedente';

  @override
  String get stopSchedNextDay => 'Giorno successivo';

  @override
  String stopSchedPickDate(String date) {
    return 'Scegli la data, $date';
  }

  @override
  String get stopSchedRoute => 'Linea';

  @override
  String get stopSchedDirection => 'Direzione';

  @override
  String get stopSchedStop => 'Fermata';

  @override
  String get stopSchedEmpty => 'Nessun servizio programmato in questo giorno.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'Ogni $minutes min dalle $start alle $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'Verso $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partenze',
      one: '$count partenza',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return 'Ore $hour: $times';
  }

  @override
  String get stopSchedNotSupported =>
      'Gli orari non sono disponibili in questa regione.';

  @override
  String get stopSchedViewList => 'Elenco';

  @override
  String get stopSchedViewGrid => 'Griglia';

  @override
  String get stopSchedNoDeparture => 'Nessuna partenza';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (la tua fermata)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, corsa $trip: $time';
  }

  @override
  String get stopReportProblemHeader => 'Qual è il problema?';

  @override
  String get stopReportStopNameWrong => 'Il nome della fermata è sbagliato';

  @override
  String get stopReportStopNumberWrong => 'Il numero della fermata è sbagliato';

  @override
  String get stopReportStopLocationWrong => 'La fermata è nel posto sbagliato';

  @override
  String get stopReportRouteMissing => 'Manca una linea o una corsa';

  @override
  String get stopReportOther => 'Altro';

  @override
  String get stopReportNeverCame => 'Il veicolo non è mai arrivato';

  @override
  String get stopReportCameEarly => 'È passato in anticipo';

  @override
  String get stopReportCameLate => 'È passato in ritardo';

  @override
  String get stopReportWrongHeadsign =>
      'La destinazione indicata era sbagliata';

  @override
  String get stopReportNotStopHere => 'Non si è fermato qui';

  @override
  String get stopReportComment => 'Commenti aggiuntivi (facoltativo)';

  @override
  String get stopReportShareLocation => 'Condividi la mia posizione';

  @override
  String get stopReportShareLocationHelp =>
      'Condividere la tua posizione può aiutare la tua azienda di trasporto a risolvere il problema.';

  @override
  String get stopReportOnVehicle => 'Sono su questo veicolo';

  @override
  String get stopReportVehicleId => 'Numero del veicolo (facoltativo)';

  @override
  String get stopReportSend => 'Invia segnalazione';

  @override
  String get stopReportSending => 'Invio della segnalazione';

  @override
  String get stopReportSent => 'Grazie! La tua segnalazione è stata inviata.';

  @override
  String get stopReportFailed =>
      'Impossibile inviare la segnalazione. Riprova.';

  @override
  String get stopReportChooseProblem => 'Scegli prima un problema.';

  @override
  String stopReportAbout(String name) {
    return 'Segnalazione: $name';
  }

  @override
  String get stopGhostTitle => 'Segnala autobus fantasma';

  @override
  String get stopGhostExplain =>
      'Un autobus fantasma è un autobus mostrato dall’app che non è mai arrivato.';

  @override
  String get stopGhostWait =>
      'Per quanto tempo hai aspettato dopo l’orario previsto?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30+ min';

  @override
  String get stopCardEmpty => 'Nessuna partenza a breve';

  @override
  String get titleSearch => 'Cerca';

  @override
  String get titleSearchResults => 'Risultati';

  @override
  String get titleNearbyStops => 'Fermate vicine';

  @override
  String get titleRecentStops => 'Fermate recenti';

  @override
  String get titleBookmarks => 'Segnalibri';

  @override
  String get titleStop => 'Fermata';

  @override
  String get titleTrip => 'Corsa';

  @override
  String get titleRouteStops => 'Linea';

  @override
  String get titleStopSchedule => 'Orari';

  @override
  String get titleRouteSchedule => 'Orari della linea';

  @override
  String get titleAlerts => 'Avvisi';

  @override
  String get titleAlertDetail => 'Avviso';

  @override
  String get titleAgencies => 'Aziende di trasporto';

  @override
  String get titleRegionPicker => 'Regioni';

  @override
  String get titleCustomRegion => 'Regione personalizzata';

  @override
  String get titleSettings => 'Impostazioni';

  @override
  String get titleMapSettings => 'Impostazioni mappa';

  @override
  String get titleMore => 'Altro';

  @override
  String get titleTripPlanner => 'Pianifica viaggio';

  @override
  String get titlePlace => 'Luogo';

  @override
  String get titleReportStopProblem => 'Segnala un problema';

  @override
  String get titleReportTripProblem => 'Segnala un problema';

  @override
  String get titleBookmarkEditor => 'Segnalibro';

  @override
  String get titleManageBookmarks => 'Modifica segnalibri';

  @override
  String get titleCredits => 'Riconoscimenti';

  @override
  String get titleWeather => 'Meteo';

  @override
  String get titleStopsOnMap => 'Fermate sulla mappa';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Benvenuto in $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Gli arrivi in tempo reale di autobus, treni e traghetti vicino a te.';

  @override
  String get onboardingLocationTitle => 'Trova le fermate vicino a te';

  @override
  String get onboardingLocationBody =>
      'Consenti l’accesso alla posizione per vedere le fermate vicine e scegliere automaticamente la tua regione.';

  @override
  String get onboardingAllowLocation => 'Consenti l’accesso alla posizione';

  @override
  String get onboardingRegionTitle => 'Scegli la tua regione';

  @override
  String get onboardingRegionBody =>
      'Scegli l’area di cui vuoi vedere i trasporti.';

  @override
  String get settingsSectionMap => 'Mappa';

  @override
  String get settingsMapTypeRow => 'Tipo di mappa e livelli';

  @override
  String get settingsMapTypeHelp => 'Scegli l’aspetto della mappa.';

  @override
  String get settingsHeadingHelp =>
      'Mostra sulla mappa la direzione in cui stai guardando.';

  @override
  String get settingsStopLabelsHelp =>
      'Mostra i nomi delle linee accanto alle fermate sulla mappa.';

  @override
  String get settingsWalkingDirections => 'Indicazioni a piedi';

  @override
  String get settingsWalkingDirectionsHelp =>
      'L’app che si apre quando richiedi le indicazioni a piedi per una fermata.';

  @override
  String get settingsDirectionsAsk => 'Chiedi ogni volta';

  @override
  String get settingsDirectionsAppleMaps => 'Mappe';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Maps';

  @override
  String get settingsSectionDepartures => 'Partenze';

  @override
  String get settingsDepartureFilter => 'Mostra partenze';

  @override
  String get settingsDepartureFilterHelp =>
      'Scegli se le pagine delle fermate elencano tutte le partenze o solo quelle con dati in tempo reale o previsti.';

  @override
  String get settingsFilterAll => 'Tutte le partenze';

  @override
  String get settingsFilterRealtime => 'Solo in tempo reale';

  @override
  String get settingsFilterScheduled => 'Solo orario previsto';

  @override
  String get settingsRegionTimeZone =>
      'Mostra gli orari nel fuso orario della regione';

  @override
  String get settingsRegionTimeZoneHelp =>
      'Gli orari usano il fuso orario della regione di trasporto, con una nota quando è diverso da quello del tuo dispositivo.';

  @override
  String get settingsSectionAccessibility => 'Accessibilità';

  @override
  String get settingsReducedColors =>
      'Riduci i colori nelle pagine delle fermate';

  @override
  String get settingsReducedColorsHelp =>
      'Mostra i badge delle linee in un unico stile neutro.';

  @override
  String get settingsCompactMode => 'Pagine di fermate e corse compatte';

  @override
  String get settingsCompactModeHelp =>
      'Riduce gli spazi per mostrare più contenuto sullo schermo.';

  @override
  String get settingsSectionWalking => 'Velocità di camminata';

  @override
  String get settingsWalkingSpeed => 'Velocità di camminata';

  @override
  String get settingsWalkingSpeedHelp =>
      'Usata per stimare i tempi a piedi e gli orari di arrivo.';

  @override
  String get settingsSpeedSlow => 'Lenta';

  @override
  String get settingsSpeedAverage => 'Media';

  @override
  String get settingsSpeedFast => 'Veloce';

  @override
  String settingsSpeedCustom(String speed) {
    return 'Personalizzata ($speed m/s)';
  }

  @override
  String get settingsSectionBike => 'Modalità bici';

  @override
  String get settingsBikeMode => 'Modalità bici';

  @override
  String get settingsBikeModeHelp =>
      'Usa una velocità di spostamento più alta per le stime dei tempi, gli orari di arrivo e la pagina della fermata.';

  @override
  String get settingsSectionSurveys => 'Sondaggi';

  @override
  String get settingsSurveysEnabled => 'Mostra sondaggi';

  @override
  String get settingsSurveysAlways => 'Mostra sempre i sondaggi alle fermate';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsAnalytics => 'Invia i dati di utilizzo agli sviluppatori';

  @override
  String get settingsAnalyticsHelp =>
      'Aiuta gli sviluppatori a capire quali funzionalità vengono usate.';

  @override
  String get settingsSectionDebug => 'Debug';

  @override
  String get settingsDebugMode => 'Modalità debug';

  @override
  String get settingsDebugAlwaysFeedback =>
      'Mostra sempre la richiesta di feedback';

  @override
  String get settingsDebugResetFeedback =>
      'Reimposta lo stato della richiesta di feedback';

  @override
  String get settingsDebugResetDonation =>
      'Reimposta lo stato della scheda delle donazioni';

  @override
  String get settingsDebugResetDone => 'Reimpostato';

  @override
  String get settingsSectionTripPlanner => 'Pianificatore di viaggio';

  @override
  String get settingsHomeCustomizeMap => 'Personalizza mappa';

  @override
  String get moreHeaderSupport =>
      'Questa app è creata e supportata da volontari.';

  @override
  String get moreSectionDonate => 'Sostienici';

  @override
  String moreDonate(String appName) {
    return 'Dona a $appName';
  }

  @override
  String get moreManageDonations => 'Gestisci le donazioni';

  @override
  String get moreSectionUpdates => 'Aggiornamenti e avvisi';

  @override
  String get moreAlerts => 'Avvisi';

  @override
  String get moreSectionLocation => 'La mia posizione';

  @override
  String get moreRegion => 'Regione';

  @override
  String get moreRegionNone => 'Non selezionata';

  @override
  String get morePayFare => 'Paga il mio biglietto';

  @override
  String get moreAgencies => 'Aziende di trasporto';

  @override
  String get moreSectionAbout => 'Informazioni sull’app';

  @override
  String moreRateApp(String appName) {
    return 'Valuta $appName';
  }

  @override
  String get moreContactUs => 'Contattaci';

  @override
  String get morePrivacy => 'Informativa sulla privacy';

  @override
  String get moreCredits => 'Riconoscimenti';

  @override
  String moreVersion(String appName, String version) {
    return '$appName versione $version';
  }

  @override
  String get moreSectionHelpOut => 'Aiutaci a migliorare l’app';

  @override
  String get moreTranslate => 'Aiutaci a tradurre l’app';

  @override
  String get moreDevelop =>
      'Aiutaci a correggere i bug e a implementare nuove funzionalità';

  @override
  String get moreSectionContact => 'Contatti e assistenza';

  @override
  String get moreTutorials => 'Tutorial';

  @override
  String get moreCallAgency => 'Chiama l’azienda di trasporto';

  @override
  String get moreTextAgency => 'Scrivi all’azienda di trasporto';

  @override
  String get moreSectionResources => 'Risorse';

  @override
  String get moreContactTitle => 'Contattaci';

  @override
  String get moreContactDevelopers =>
      'Richiesta di funzionalità o segnalazione di bug';

  @override
  String get moreContactAgency => 'Problema con mezzo o orario';

  @override
  String moreEmailSubject(String appName) {
    return 'Feedback su $appName';
  }

  @override
  String get moreEmailAgencySubject => 'Feedback di un utente dei trasporti';

  @override
  String get moreEmailIntro =>
      'Come possiamo aiutarti? Scrivi qui sotto il tuo messaggio:';

  @override
  String get moreEmailDebugIntro =>
      'Le seguenti informazioni sono fornite a scopo di risoluzione dei problemi. Se non vuoi condividerne una parte, puoi rimuoverla, ma potremmo avere più difficoltà ad aiutarti.';

  @override
  String get moreDebugAppVersion => 'Versione dell’app';

  @override
  String get moreDebugOs => 'Sistema operativo';

  @override
  String get moreDebugLocale => 'Lingua';

  @override
  String get moreDebugBookmarks => 'Numero di segnalibri';

  @override
  String get moreDebugLocationPermission => 'Autorizzazione alla posizione';

  @override
  String get moreDebugRegion => 'Regione';

  @override
  String get moreDebugRegionId => 'ID regione';

  @override
  String get moreDebugApiUrl => 'URL di base dell’API';

  @override
  String get moreDebugUserId => 'ID utente';

  @override
  String get moreCantEmailTitle => 'Impossibile aprire la tua app di posta';

  @override
  String moreCantEmailBody(String email) {
    return 'Per contattarci, invia un’e-mail a $email. Copia le info di debug e incollale nel messaggio per aiutarci a risolvere il problema.';
  }

  @override
  String get moreCopyEmail => 'Copia indirizzo e-mail';

  @override
  String get moreCopyDebug => 'Copia info di debug';

  @override
  String get moreCopied => 'Copiato negli appunti';

  @override
  String get moreFareContinue => 'Continua';

  @override
  String get moreFareDontShowAgain => 'Continua e non mostrare più';

  @override
  String get moreCantOpenLink => 'Impossibile aprire quel link.';

  @override
  String get regionPickerAutomatic => 'Scegli la regione automaticamente';

  @override
  String get regionPickerAutomaticHelp =>
      'Passa alla regione in cui ti trovi. Se scegli una regione manualmente, questa opzione si disattiva.';

  @override
  String get regionPickerShowExperimental => 'Mostra regioni sperimentali';

  @override
  String get regionPickerShowInactive => 'Mostra regioni inattive';

  @override
  String get regionPickerRegionsSection => 'Regioni';

  @override
  String get regionPickerCustomSection => 'Regioni personalizzate';

  @override
  String get regionPickerCurrent => 'Regione attuale';

  @override
  String get regionPickerExperimentalTag => 'Sperimentale';

  @override
  String get regionPickerInactiveTag => 'Inattiva';

  @override
  String get regionPickerCustomTag => 'Personalizzata';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Aggiungi regione personalizzata';

  @override
  String get regionPickerRefresh => 'Aggiorna regioni';

  @override
  String get regionPickerRefreshed => 'Regioni aggiornate';

  @override
  String get regionPickerRefreshFailed =>
      'Impossibile aggiornare l’elenco delle regioni. Viene mostrato l’elenco salvato.';

  @override
  String regionPickerSelected(String name) {
    return '$name selezionata';
  }

  @override
  String regionPickerEdit(String name) {
    return 'Modifica $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'Elimina $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'Eliminare $name?';
  }

  @override
  String get regionPickerDeleteBody =>
      'Questa regione personalizzata verrà rimossa da questo dispositivo.';

  @override
  String get regionPickerDeleteConfirm => 'Elimina';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Scegli un’altra regione prima di eliminare questa.';

  @override
  String get regionPickerEmpty => 'Nessuna regione disponibile';

  @override
  String get regionPickerEmptyBody =>
      'Attiva le regioni sperimentali o inattive, oppure aggiungi una regione personalizzata.';

  @override
  String get regionPickerTripPlanner =>
      'Pianificatore di viaggio in questa regione';

  @override
  String get customRegionEditTitle => 'Modifica regione personalizzata';

  @override
  String get customRegionName => 'Nome';

  @override
  String get customRegionObaUrl => 'URL del server OneBusAway';

  @override
  String get customRegionObaUrlHelp =>
      'L’indirizzo del server, ad esempio https://oba.example.com/';

  @override
  String get customRegionSidecar => 'URL del server Sidecar (facoltativo)';

  @override
  String get customRegionOtp =>
      'URL del pianificatore di viaggio (facoltativo)';

  @override
  String get customRegionOtpGraphql =>
      'URL GraphQL del pianificatore di viaggio (facoltativo)';

  @override
  String get customRegionServiceArea => 'Area di servizio';

  @override
  String get customRegionServiceAreaHelp =>
      'L’area coperta da questa regione: un punto centrale e la sua estensione.';

  @override
  String get customRegionLatitude => 'Latitudine del centro';

  @override
  String get customRegionLongitude => 'Longitudine del centro';

  @override
  String get customRegionLatSpan => 'Estensione in latitudine (gradi)';

  @override
  String get customRegionLonSpan => 'Estensione in longitudine (gradi)';

  @override
  String get customRegionUseMap => 'Usa l’area corrente della mappa';

  @override
  String get customRegionSave => 'Salva';

  @override
  String get customRegionErrorRequired => 'Questo campo è obbligatorio';

  @override
  String get customRegionErrorUrl =>
      'Inserisci un indirizzo web che inizia con http:// o https://';

  @override
  String get customRegionErrorNumber => 'Inserisci un numero';

  @override
  String get customRegionErrorRange => 'Questo numero è fuori intervallo';

  @override
  String get customRegionChecking => 'Verifica del server in corso';

  @override
  String get customRegionServerOk => 'Il server ha risposto';

  @override
  String get customRegionServerUnreachable =>
      'Impossibile raggiungere questo server';

  @override
  String get customRegionServerNotOba =>
      'Questo server non ha risposto come OneBusAway';

  @override
  String customRegionSaved(String name) {
    return '$name salvata';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway è un software di trasporto pubblico gratuito e open source, creato da volontari e supportato dalla Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'Licenza';

  @override
  String get creditsMapData => 'Dati della mappa';

  @override
  String get creditsLicenses => 'Licenze open source';

  @override
  String get creditsLicensesHelp =>
      'Le librerie con cui è realizzata questa app.';

  @override
  String get creditsLicensesLoading => 'Caricamento delle licenze';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count licenze',
      one: '$count licenza',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Disponibile in decine di regioni di trasporto in tutto il mondo.';

  @override
  String get onboardingBenefitNearbyTitle => 'Vedi le fermate vicine';

  @override
  String get onboardingBenefitNearbyBody =>
      'Autobus e treni intorno a te, ordinati per distanza.';

  @override
  String get onboardingBenefitMapTitle => 'Centra la mappa su di te';

  @override
  String get onboardingBenefitMapBody =>
      'Apri subito la mappa su ciò che ti circonda, senza cercare.';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName usa la tua posizione solo quando l’app è aperta. Puoi cambiare questa impostazione in qualsiasi momento nelle impostazioni del dispositivo.';
  }

  @override
  String get onboardingLocationDenied =>
      'L’accesso alla posizione è disattivato. Puoi comunque scegliere la tua regione manualmente.';

  @override
  String get onboardingRegionDetected => 'Rilevata vicino a te';

  @override
  String onboardingRegionUse(String name) {
    return 'Usa $name';
  }

  @override
  String get onboardingRegionOthers => 'Oppure scegli un’altra regione';

  @override
  String get onboardingRegionEmpty =>
      'Al momento non ci sono regioni disponibili. Controlla la connessione e riprova.';

  @override
  String get surveyCardTitle => 'Aiutaci a migliorare i trasporti';

  @override
  String get surveyDefaultPrompt =>
      'Rispondi a un breve sondaggio per aiutarci a migliorare i trasporti.';

  @override
  String get surveyTake => 'Partecipa al sondaggio';

  @override
  String get surveyNotNow => 'Non ora';

  @override
  String get surveyDismiss => 'Ignora sondaggio';

  @override
  String get surveyNext => 'Avanti';

  @override
  String get surveySubmit => 'Invia sondaggio';

  @override
  String get surveySubmitting => 'Invio in corso';

  @override
  String get surveyQuestionsTitle => 'Sondaggio';

  @override
  String get surveyTextHint => 'Inserisci la tua risposta';

  @override
  String get surveyRequired => 'Obbligatorio';

  @override
  String get surveyIncomplete =>
      'Rispondi a tutte le domande obbligatorie prima di inviare.';

  @override
  String get surveyFailed =>
      'Non è stato possibile inviare le tue risposte. Riprova.';

  @override
  String get surveyThanks => 'Grazie per il tuo feedback.';

  @override
  String get surveyOpenSurvey => 'Apri sondaggio';

  @override
  String get surveyLearnMore => 'Scopri di più';

  @override
  String get surveyShareFeedback => 'Condividi un feedback';

  @override
  String get surveySignUp => 'Iscriviti';

  @override
  String get surveyExternalError =>
      'Non è stato possibile aprire il link del sondaggio. Riprova più tardi.';

  @override
  String donationTitle(String appName) {
    return '$appName ha bisogno del tuo aiuto';
  }

  @override
  String get donationBody =>
      'Questa app è realizzata con il lavoro di volontari e abbiamo bisogno del tuo aiuto per finanziare lo sviluppo futuro.';

  @override
  String get donationLearnMore => 'Scopri di più';

  @override
  String get donationDonate => 'Dona ora';

  @override
  String get donationRemindLater => 'Ricordamelo più tardi';

  @override
  String get donationDismiss => 'No, grazie';

  @override
  String get donationHeader => 'Ecco perché abbiamo bisogno del tuo aiuto';

  @override
  String donationExplanation(String appName) {
    return 'Abbiamo grandi progetti per migliorare $appName, ma non possiamo realizzarli senza il tuo aiuto. Questa app è realizzata con il lavoro di volontari e abbiamo bisogno del tuo aiuto per finanziare lo sviluppo futuro.\n\nPoiché è un progetto chiave della Open Transit Software Foundation, un’organizzazione senza scopo di lucro, la tua donazione è deducibile dalle tasse negli Stati Uniti.';
  }

  @override
  String get donationDonateWebsite => 'Dona sul nostro sito web';

  @override
  String titleDonation(String appName) {
    return 'Sostieni $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'Ti piace $appName?';
  }

  @override
  String get feedbackYes => 'Sì!';

  @override
  String get feedbackNo => 'Non molto';

  @override
  String get feedbackLater => 'Chiedimelo più tardi';

  @override
  String get feedbackNegativeTitle => 'Ci dispiace.';

  @override
  String get feedbackNegativeBody =>
      'Vuoi dirci cosa non va? Leggiamo tutti i messaggi.';

  @override
  String get feedbackSend => 'Invia feedback';

  @override
  String get feedbackDecline => 'No, grazie';

  @override
  String get tripPlanningUnavailable =>
      'La pianificazione dei viaggi non è disponibile in questa regione.';

  @override
  String get deepLinkOtherRegion =>
      'Questo link è per un’altra regione. Cambia regione per aprirlo.';

  @override
  String get dataUpdated => 'Aggiornato';

  @override
  String get bookmarksEtaNow => 'Ora';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'tra $minutes minuti',
      one: 'tra $minutes minuto',
      zero: 'ora',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => 'In orario';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min di ritardo',
      one: '$minutes min di ritardo',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min di anticipo',
      one: '$minutes min di anticipo',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => 'Previsto';

  @override
  String get bookmarksStatusCanceled => 'Cancellato';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Linea $route verso $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Linea $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Caricamento delle partenze';

  @override
  String get bookmarksNoDepartures => 'Nessuna partenza imminente';

  @override
  String get bookmarksDeparturesError => 'Impossibile caricare le partenze';

  @override
  String get bookmarksDeparturesStale =>
      'Impossibile aggiornare. Vengono mostrati gli orari precedenti.';

  @override
  String get bookmarksUpdated => 'Partenze aggiornate';

  @override
  String get bookmarksSortTooltip => 'Ordina i segnalibri';

  @override
  String get bookmarksSortByGroup => 'Ordina per gruppo';

  @override
  String get bookmarksSortByDistance => 'Ordina per distanza';

  @override
  String get bookmarksManageTooltip => 'Modifica segnalibri e gruppi';

  @override
  String get bookmarksRefreshTooltip => 'Aggiorna le partenze';

  @override
  String get bookmarksEmptyTitle => 'Ancora nessun segnalibro';

  @override
  String get bookmarksEmptyBody =>
      'Apri una fermata e tocca il pulsante dei segnalibri per salvarla qui. Da una partenza puoi anche salvare solo quella linea alla fermata.';

  @override
  String get bookmarksFindStops => 'Trova fermate sulla mappa';

  @override
  String get bookmarksUngrouped => 'Senza gruppo';

  @override
  String get bookmarksGroupExpanded => 'espanso';

  @override
  String get bookmarksGroupCollapsed => 'compresso';

  @override
  String get bookmarksGroupToggleHint =>
      'Mostra o nasconde i segnalibri di questo gruppo';

  @override
  String bookmarksActionsFor(String name) {
    return 'Azioni per $name';
  }

  @override
  String get bookmarksActionEdit => 'Modifica';

  @override
  String get bookmarksActionPin => 'Fissa in alto';

  @override
  String get bookmarksActionUnpin => 'Rimuovi';

  @override
  String get bookmarksActionMove => 'Sposta nel gruppo';

  @override
  String get bookmarksActionDelete => 'Elimina';

  @override
  String get bookmarksPinned => 'Fissato';

  @override
  String bookmarksDeleted(String name) {
    return '$name eliminato';
  }

  @override
  String get bookmarksUndo => 'Annulla';

  @override
  String get bookmarksMoveTitle => 'Sposta nel gruppo';

  @override
  String get bookmarksNoGroup => 'Nessun gruppo';

  @override
  String bookmarksMoved(String group) {
    return 'Spostato in $group';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name, $details';
  }

  @override
  String get bookmarksEditorNameLabel => 'Nome del segnalibro';

  @override
  String get bookmarksEditorNameRequired =>
      'Inserisci un nome per questo segnalibro.';

  @override
  String get bookmarksEditorDuplicate =>
      'Hai già un segnalibro con questo nome per questa fermata e questa linea. Cambia il nome per salvarne un altro.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Segnalibro di fermata: mostra le prossime partenze di tutte le linee a $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Segnalibro di corsa: mostra le prossime partenze di $route a $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'Solo $route';
  }

  @override
  String get bookmarksEditorGroup => 'Gruppo';

  @override
  String get bookmarksEditorNewGroup => 'Nuovo gruppo…';

  @override
  String get bookmarksEditorNewGroupTitle => 'Nuovo gruppo';

  @override
  String get bookmarksEditorGroupName => 'Nome del gruppo';

  @override
  String get bookmarksEditorSave => 'Salva';

  @override
  String get bookmarksEditorSaved => 'Segnalibro salvato';

  @override
  String get bookmarksEditorDelete => 'Elimina segnalibro';

  @override
  String get bookmarksEditorDeleteTitle => 'Eliminare questo segnalibro?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '“$name” verrà rimosso dai tuoi segnalibri.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Scegli una regione prima di aggiungere segnalibri.';

  @override
  String get bookmarksManageGroupsHeader => 'Gruppi';

  @override
  String get bookmarksManageBookmarksHeader => 'Segnalibri';

  @override
  String get bookmarksManageAddGroup => 'Aggiungi gruppo';

  @override
  String get bookmarksManageRenameGroup => 'Rinomina gruppo';

  @override
  String get bookmarksManageDeleteGroup => 'Elimina gruppo';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'I segnalibri di “$name” resteranno senza gruppo.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Sposta $name in su';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Sposta $name in giù';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Riordina $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, posizione $position di $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'Non ci sono ancora segnalibri o gruppi da gestire.';

  @override
  String get bookmarksManageUngrouped => 'Segnalibri senza gruppo';

  @override
  String get recentsEmptyTitle => 'Nessuna fermata recente';

  @override
  String get recentsEmptyBody =>
      'Le fermate che consulti compaiono qui, le più recenti per prime.';

  @override
  String get recentsFindStops => 'Trova fermate sulla mappa';

  @override
  String get recentsClearAll => 'Cancella tutto';

  @override
  String get recentsClearTitle => 'Cancellare le fermate recenti?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Questa azione rimuove tutte le $count fermate recenti. I tuoi segnalibri non vengono modificati.',
      one:
          'Questa azione rimuove $count fermata recente. I tuoi segnalibri non vengono modificati.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Rimuovi $name dalle fermate recenti';
  }

  @override
  String recentsRemoved(String name) {
    return '$name rimossa';
  }

  @override
  String get recentsSectionEmpty => 'Le fermate che consulti compaiono qui.';

  @override
  String get alarmsSectionTitle => 'Sveglie';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti prima della partenza',
      one: '$minutes minuto prima della partenza',
    );
    return '$_temp0, alle $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Sveglia per $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'Elimina la sveglia per $title';
  }

  @override
  String get alarmsDeleted => 'Sveglia eliminata';

  @override
  String get alarmsDeleteFailed =>
      'Impossibile eliminare la sveglia. Controlla la connessione e riprova.';

  @override
  String get alarmsOpen => 'Apre la corsa';

  @override
  String get alertsEmptyTitle => 'Nessun avviso di servizio';

  @override
  String get alertsEmptyBody =>
      'Al momento non ci sono avvisi di servizio attivi.';

  @override
  String get alertsRegionNote =>
      'Include gli avvisi per le fermate nei segnalibri, recenti e vicine.';

  @override
  String get alertsMarkAllRead => 'Segna tutto come letto';

  @override
  String get alertsAllRead => 'Tutti gli avvisi sono stati segnati come letti';

  @override
  String get alertsUnread => 'Non letto';

  @override
  String get alertsSeverityInfo => 'Informazione';

  @override
  String get alertsSeverityWarning => 'Avvertenza';

  @override
  String get alertsSeveritySevere => 'Grave';

  @override
  String get alertsSeverityUnknown => 'Avviso di servizio';

  @override
  String get alertsNoTitle => 'Avviso di servizio';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Non letto. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avvisi non letti',
      one: '$count avviso non letto',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'altri $count avvisi',
      one: '$count altro avviso',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Periodo di validità';

  @override
  String alertsDetailRange(String start, String end) {
    return 'Dal $start al $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'Dal $start';
  }

  @override
  String get alertsDetailAffects => 'Interessa';

  @override
  String get alertsDetailRoutes => 'Linee';

  @override
  String get alertsDetailStops => 'Fermate';

  @override
  String get alertsDetailAgencies => 'Aziende di trasporto';

  @override
  String get alertsDetailLearnMore => 'Scopri di più';

  @override
  String get alertsDetailNoDetails =>
      'Nessun dettaglio aggiuntivo disponibile.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Pubblicato il $date';
  }

  @override
  String get alertsCouldNotOpen => 'Impossibile aprire quel link.';

  @override
  String get agenciesEmptyTitle => 'Nessuna azienda di trasporto';

  @override
  String get agenciesEmptyBody =>
      'Questa regione non elenca nessuna azienda di trasporto.';

  @override
  String get agenciesWebsite => 'Sito web';

  @override
  String agenciesPhone(String phone) {
    return 'Chiama $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'Scrivi a $email';
  }

  @override
  String get agenciesFares => 'Informazioni sulle tariffe';

  @override
  String get agenciesDisclaimer => 'Esclusione di responsabilità';

  @override
  String get agenciesShowOnMap => 'Mostra l’area coperta sulla mappa';

  @override
  String get searchFieldLabel => 'Cerca';

  @override
  String get searchFieldHint => 'Linea, numero di fermata, indirizzo o veicolo';

  @override
  String get searchClear => 'Cancella ricerca';

  @override
  String get searchScopeLabel => 'Cerca tra';

  @override
  String get searchScopeAll => 'Tutto';

  @override
  String get searchScopeStops => 'Fermate';

  @override
  String get searchScopeRoutes => 'Linee';

  @override
  String get searchScopePlaces => 'Luoghi';

  @override
  String get searchQuickHeader => 'Cerca';

  @override
  String searchQuickRoute(String query) {
    return 'Linea: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Numero di fermata: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Indirizzo: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Veicolo: $query';
  }

  @override
  String get searchRecentStopsHeader => 'Fermate recenti';

  @override
  String get searchBookmarksHeader => 'Segnalibri';

  @override
  String get searchRecentSearchesHeader => 'Ricerche recenti';

  @override
  String get searchRecentPlacesHeader => 'Luoghi recenti';

  @override
  String get searchPlacesHeader => 'Luoghi';

  @override
  String get searchClearRecent => 'Cancella le ricerche recenti';

  @override
  String get searchClearRecentConfirm =>
      'Cancellare le ricerche e i luoghi recenti?';

  @override
  String get searchClearAction => 'Cancella';

  @override
  String get searchRecentCleared => 'Ricerche recenti cancellate';

  @override
  String get searchPlacesLoading => 'Ricerca di luoghi';

  @override
  String get searchPlacesNone => 'Nessun luogo trovato';

  @override
  String get searchPlacesError =>
      'Impossibile cercare i luoghi. Controlla la connessione.';

  @override
  String get searchSearching => 'Ricerca in corso';

  @override
  String get searchNoResultsTitle => 'Nessun risultato';

  @override
  String searchNoResultsBody(String query) {
    return 'Nessun risultato trovato per “$query”.';
  }

  @override
  String get searchUnavailableNoRegion =>
      'Scegli una regione prima di cercare.';

  @override
  String get searchUnavailableAddress =>
      'La ricerca di indirizzi non è configurata in questa app.';

  @override
  String get searchUnavailableVehicle =>
      'La ricerca dei veicoli non è disponibile in questa regione.';

  @override
  String get searchEmptyTitle => 'Trova linee, fermate e luoghi';

  @override
  String get searchEmptyBody =>
      'Digita il nome di una linea, un numero di fermata, un indirizzo o l’ID di un veicolo.';

  @override
  String get searchDismissMessage => 'Chiudi';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count risultati per “$query”',
      one: '$count risultato per “$query”',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'Linee';

  @override
  String get searchResultsStops => 'Fermate';

  @override
  String get searchResultsVehicles => 'Veicoli';

  @override
  String get searchResultsPlaces => 'Luoghi';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Linea $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Veicolo $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'Il veicolo $id non sta effettuando nessuna corsa al momento.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Caricamento del veicolo $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'Attiva la posizione per vedere le partenze dalle fermate vicino a te.';

  @override
  String get searchNearbyLocationButton => 'Usa la mia posizione';

  @override
  String get searchNearbyLocationDenied =>
      'L’accesso alla posizione è disattivato. Attivalo nelle impostazioni del dispositivo per vedere le fermate vicino a te.';

  @override
  String get searchNearbyLocationServicesOff =>
      'I servizi di localizzazione sono disattivati. Attivali per vedere le fermate vicino a te.';

  @override
  String get searchNearbyLocationUnavailable =>
      'Questa app non usa la tua posizione, quindi non può mostrare le fermate vicino a te.';

  @override
  String get searchNearbyEmpty => 'Nessuna fermata nelle vicinanze';

  @override
  String get searchNearbyEmptyBody =>
      'Non ci sono fermate raggiungibili a piedi.';

  @override
  String get searchNearbyMapCenter => 'Fermate vicine al centro della mappa.';

  @override
  String get searchNearbyNoDepartures => 'Nessuna partenza nella prossima ora';

  @override
  String get searchNearbyLoadingDepartures => 'Caricamento delle partenze';

  @override
  String get searchNearbyUpdated => 'Partenze vicine aggiornate';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fermate nelle vicinanze',
      one: '$count fermata nelle vicinanze',
      zero: 'Nessuna fermata nelle vicinanze',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Ricerca della tua posizione…';

  @override
  String get searchNearbyRefresh => 'Aggiorna';

  @override
  String searchNearbyDistance(String distance) {
    return 'A $distance di distanza';
  }

  @override
  String get searchNearbyOtherDirection => 'Altre fermate';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return 'Fermate $direction';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route verso $headsign, $eta, $status. Da $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'Da $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Partenze vicino a te';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get searchEtaNow => 'Ora';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'tra $minutes minuti',
      one: 'tra $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => 'parte ora';

  @override
  String get searchStatusOnTime => 'In orario';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min di ritardo',
      one: '$minutes min di ritardo',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min di anticipo',
      one: '$minutes min di anticipo',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => 'Previsto';

  @override
  String get searchExplorePlanTrip => 'Pianifica viaggio';

  @override
  String get searchExploreWeather => 'Meteo';

  @override
  String get searchExploreAgencies => 'Aziende di trasporto';

  @override
  String get searchPlaceAddress => 'Indirizzo';

  @override
  String get searchPlaceCoordinates => 'Coordinate';

  @override
  String get searchPlaceDistance => 'Distanza';

  @override
  String get searchPlaceDirectionsTo => 'Indicazioni per arrivare qui';

  @override
  String get searchPlaceDirectionsFrom => 'Indicazioni da qui';

  @override
  String get searchPlaceNearbyStops => 'Fermate vicine';

  @override
  String get searchPlaceShare => 'Condividi';

  @override
  String get searchPlaceOpenInMaps => 'Apri in un’app di mappe';

  @override
  String get searchPlaceRemovePin => 'Rimuovi segnaposto';

  @override
  String get searchPlaceOpenFailed => 'Impossibile aprire un’app di mappe.';

  @override
  String get searchPlaceShareFailed => 'Impossibile condividere questo luogo.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Luogo: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Meteo: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Mostra le previsioni';

  @override
  String get searchWeatherClear => 'Sereno';

  @override
  String get searchWeatherPartlyCloudy => 'Parzialmente nuvoloso';

  @override
  String get searchWeatherCloudy => 'Nuvoloso';

  @override
  String get searchWeatherRain => 'Pioggia';

  @override
  String get searchWeatherSleet => 'Nevischio';

  @override
  String get searchWeatherSnow => 'Neve';

  @override
  String get searchWeatherWindy => 'Ventoso';

  @override
  String get searchWeatherFog => 'Nebbia';

  @override
  String get searchWeatherUnknown => 'Condizioni sconosciute';

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
      other: '$value gradi Fahrenheit',
      one: '$value grado Fahrenheit',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value gradi Celsius',
      one: '$value grado Celsius',
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
  String get searchWeatherFeelsLike => 'Percepita';

  @override
  String get searchWeatherWind => 'Vento';

  @override
  String get searchWeatherPrecip => 'Probabilità di pioggia';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'Max $high · Min $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'Massima $high, minima $low, nelle prossime 24 ore';
  }

  @override
  String get searchWeatherHourly => 'Prossime 24 ore';

  @override
  String get searchWeatherNow => 'Adesso';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, probabilità di pioggia $precip';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Temperature in $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'gradi Fahrenheit (°F)';

  @override
  String get searchWeatherCelsius => 'gradi Celsius (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Previsioni delle $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'Il meteo non è disponibile per questa regione.';

  @override
  String get searchWeatherSummaryLabel => 'Oggi';

  @override
  String get bookmarksSectionEmpty =>
      'Le fermate nei segnalibri compaiono qui.';

  @override
  String get coreDirectionNameN => 'Nord';

  @override
  String get coreDirectionNameNE => 'Nord-est';

  @override
  String get coreDirectionNameE => 'Est';

  @override
  String get coreDirectionNameSE => 'Sud-est';

  @override
  String get coreDirectionNameS => 'Sud';

  @override
  String get coreDirectionNameSW => 'Sud-ovest';

  @override
  String get coreDirectionNameW => 'Ovest';

  @override
  String get coreDirectionNameNW => 'Nord-ovest';

  @override
  String get coreDirectionAbbrN => 'N';

  @override
  String get coreDirectionAbbrNE => 'NE';

  @override
  String get coreDirectionAbbrE => 'E';

  @override
  String get coreDirectionAbbrSE => 'SE';

  @override
  String get coreDirectionAbbrS => 'S';

  @override
  String get coreDirectionAbbrSW => 'SO';

  @override
  String get coreDirectionAbbrW => 'O';

  @override
  String get coreDirectionAbbrNW => 'NO';

  @override
  String get coreDirectionBoundN => 'Direzione nord';

  @override
  String get coreDirectionBoundNE => 'Direzione NE';

  @override
  String get coreDirectionBoundE => 'Direzione est';

  @override
  String get coreDirectionBoundSE => 'Direzione SE';

  @override
  String get coreDirectionBoundS => 'Direzione sud';

  @override
  String get coreDirectionBoundSW => 'Direzione SO';

  @override
  String get coreDirectionBoundW => 'Direzione ovest';

  @override
  String get coreDirectionBoundNW => 'Direzione NO';

  @override
  String get coreRouteTypeLightRail => 'Metropolitana leggera';

  @override
  String get coreRouteTypeSubway => 'Metropolitana';

  @override
  String get coreRouteTypeRail => 'Ferrovia';

  @override
  String get coreRouteTypeBus => 'Autobus';

  @override
  String get coreRouteTypeFerry => 'Traghetto';

  @override
  String get coreRouteTypeCableCar => 'Tram a fune';

  @override
  String get coreRouteTypeGondola => 'Cabinovia';

  @override
  String get coreRouteTypeFunicular => 'Funicolare';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Fermata n. $code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Fermata: \'$code\'';
  }

  @override
  String coreStopId(String code) {
    return 'ID fermata: $code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return 'Linee: $routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Linee: $routes, + altre $count',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return 'Cerca in $region';
  }

  @override
  String get coreNow => 'ORA';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get coreOneMinute => 'Un minuto';

  @override
  String get coreOneMinuteAgo => 'Un minuto fa';

  @override
  String coreMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti',
    );
    return '$_temp0';
  }

  @override
  String get coreJustNow => 'Proprio ora';

  @override
  String coreSecondsAgo(int seconds) {
    return '$seconds s fa';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return '$minutes min fa';
  }

  @override
  String coreHoursAgo(int hours) {
    return '$hours h fa';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni fa',
      one: '$days giorno fa',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return 'Aggiornato: $ago';
  }

  @override
  String get coreScheduledNotRealTime => 'Orario previsto, non in tempo reale';

  @override
  String coreArrivedMinAgo(int minutes) {
    return 'Arrivato $minutes min fa';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return 'Partito $minutes min fa';
  }

  @override
  String get coreArrivingNow => 'In arrivo ora';

  @override
  String get coreDepartingNow => 'In partenza ora';

  @override
  String coreArrivesInMin(int minutes) {
    return 'Arriva tra $minutes min';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return 'Parte tra $minutes min';
  }

  @override
  String coreArrivedLate(int minutes) {
    return 'arrivato con $minutes min di ritardo';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return 'arrivato con $minutes min di anticipo';
  }

  @override
  String get coreArrivedOnTime => 'arrivato in orario';

  @override
  String coreDepartedLate(int minutes) {
    return 'partito con $minutes min di ritardo';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return 'partito con $minutes min di anticipo';
  }

  @override
  String get coreDepartedOnTime => 'partito in orario';

  @override
  String coreArrivesLate(int minutes) {
    return 'arriva con $minutes min di ritardo';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return 'arriva con $minutes min di anticipo';
  }

  @override
  String get coreArrivesOnTime => 'arriva in orario';

  @override
  String coreDepartsLate(int minutes) {
    return 'parte con $minutes min di ritardo';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return 'parte con $minutes min di anticipo';
  }

  @override
  String get coreDepartsOnTime => 'parte in orario';

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
      other: '$minutes minuti',
      one: '$minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsNow => 'ora';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes min';
  }

  @override
  String get arrivalsCanceled => 'cancellato';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'ogni $minutes min dalle $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'ogni $minutes min fino alle $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'Direzione nord';

  @override
  String get arrivalsDirectionBoundNE => 'Direzione nord-est';

  @override
  String get arrivalsDirectionBoundE => 'Direzione est';

  @override
  String get arrivalsDirectionBoundSE => 'Direzione sud-est';

  @override
  String get arrivalsDirectionBoundS => 'Direzione sud';

  @override
  String get arrivalsDirectionBoundSW => 'Direzione sud-ovest';

  @override
  String get arrivalsDirectionBoundW => 'Direzione ovest';

  @override
  String get arrivalsDirectionBoundNW => 'Direzione nord-ovest';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'Direzione $code';
  }

  @override
  String get arrivalsRefresh => 'Aggiorna gli arrivi';

  @override
  String get arrivalsRetry => 'Riprova';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Nessun arrivo nei prossimi $minutes minuti',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound =>
      'Fermata non trovata o servizio non disponibile';

  @override
  String get arrivalsNetworkError =>
      'Impossibile raggiungere il server dei trasporti. Controlla la connessione.';

  @override
  String get arrivalsLoadError => 'Impossibile caricare gli arrivi.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'Impossibile aggiornare. Vengono mostrati i risultati delle $time';
  }

  @override
  String get arrivalsArrivingNow => 'in arrivo ora';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arriva tra $minutes minuti',
      one: 'arriva tra $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'in tempo reale';

  @override
  String get arrivalsRowTapHint => 'mostra i dettagli';

  @override
  String arrivalsAtTime(String time) {
    return 'alle $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti di ritardo',
      one: '$minutes minuto di ritardo',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti di anticipo',
      one: '$minutes minuto di anticipo',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'ogni $minutes minuti dalle $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'ogni $minutes minuti fino alle $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'orario previsto';

  @override
  String get arrivalsLoading => 'Caricamento degli arrivi';

  @override
  String get arrivalsRefreshing => 'Aggiornamento degli arrivi';

  @override
  String get arrivalsUpdated => 'Arrivi aggiornati';

  @override
  String get tripPlannerOriginLabel => 'Da';

  @override
  String get tripPlannerDestinationLabel => 'A';

  @override
  String get tripPlannerChooseOrigin => 'Scegli il punto di partenza';

  @override
  String get tripPlannerChooseDestination => 'Scegli la destinazione';

  @override
  String get tripPlannerCurrentLocation => 'Posizione attuale';

  @override
  String get tripPlannerSwapEndpoints => 'Inverti partenza e destinazione';

  @override
  String get tripPlannerPlanTrip => 'Pianifica viaggio';

  @override
  String get tripPlannerPlanningTrip => 'Pianificazione del viaggio in corso';

  @override
  String get tripPlannerOptions => 'Opzioni del viaggio';

  @override
  String get tripPlannerLeaveNow => 'Parti ora';

  @override
  String get tripPlannerDepartAt => 'Parti alle';

  @override
  String get tripPlannerArriveBy => 'Arriva entro le';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Cambia orario, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Mezzi pubblici';

  @override
  String get tripPlannerModeWalk => 'A piedi';

  @override
  String get tripPlannerModeBike => 'Bici';

  @override
  String get tripPlannerModeCar => 'Auto';

  @override
  String get tripPlannerModeBikeRental => 'Solo bike sharing';

  @override
  String get tripPlannerModeTransitBikeRental =>
      'Mezzi pubblici + bike sharing';

  @override
  String get tripPlannerWheelchairAccessible =>
      'Accessibile in sedia a rotelle';

  @override
  String get tripPlannerWalkQuarterMile => '0,25 miglia';

  @override
  String get tripPlannerWalkHalfMile => '0,5 miglia';

  @override
  String get tripPlannerWalkOneMile => '1 miglio';

  @override
  String get tripPlannerWalkTwoMiles => '2 miglia';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'Cammina fino a $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'Nessun viaggio trovato';

  @override
  String get tripPlannerRetry => 'Riprova';

  @override
  String get tripPlannerRealTime => 'Tempo reale';

  @override
  String tripPlannerDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String tripPlannerDurationHours(int hours) {
    return '$hours h';
  }

  @override
  String tripPlannerDurationHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
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
      other: '$count cambi',
      one: '$count cambio',
      zero: 'Nessun cambio',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return 'A piedi: $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Parte alle $time da $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'In orario';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '$minutes min di ritardo';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '$minutes min di anticipo';
  }

  @override
  String get tripPlannerStatusScheduled => 'Previsto';

  @override
  String get tripPlannerLegBus => 'Autobus';

  @override
  String get tripPlannerLegTram => 'Tram';

  @override
  String get tripPlannerLegSubway => 'Metropolitana';

  @override
  String get tripPlannerLegRail => 'Treno';

  @override
  String get tripPlannerLegFerry => 'Traghetto';

  @override
  String get tripPlannerLegCableCar => 'Tram a fune';

  @override
  String get tripPlannerLegGondola => 'Cabinovia';

  @override
  String get tripPlannerLegFunicular => 'Funicolare';

  @override
  String get tripPlannerLegAirplane => 'Aereo';

  @override
  String get tripPlannerLegTrolleybus => 'Filobus';

  @override
  String get tripPlannerLegMonorail => 'Monorotaia';

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
    return 'Cammina per $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return 'Bici per $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return 'Bici a noleggio per $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return 'Guida per $duration';
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
  String get tripPlannerThen => 'poi';

  @override
  String get tripPlannerOpenItineraryHint => 'mostra i dettagli del viaggio';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minuti',
      one: '$minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ore',
      one: '$hours ora',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursMinutesSemantics(String hours, String minutes) {
    return '$hours e $minutes';
  }

  @override
  String tripPlannerFeetSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value piedi',
      one: '$value piede',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value miglia',
      one: '$value miglio',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value metri',
      one: '$value metro',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value chilometri',
      one: '$value chilometro',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return 'dalle $start alle $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'in tempo reale, in orario';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'in tempo reale, $minutes minuti di ritardo',
      one: 'in tempo reale, $minutes minuto di ritardo',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'in tempo reale, $minutes minuti di anticipo',
      one: 'in tempo reale, $minutes minuto di anticipo',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'orario previsto';

  @override
  String get tripPlannerResultsHeading => 'Viaggi suggeriti';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viaggi trovati',
      one: '$count viaggio trovato',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count luoghi trovati',
      one: '$count luogo trovato',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'Mappa del viaggio. Le indicazioni qui sotto descrivono lo stesso viaggio.';

  @override
  String get tripPlannerTripDetails => 'Dettagli del viaggio';

  @override
  String get tripPlannerMapLabel => 'Mappa del viaggio';

  @override
  String get tripPlannerStart => 'Partenza';

  @override
  String get tripPlannerDestination => 'Destinazione';

  @override
  String get tripPlannerUnnamedPlace => 'Luogo senza nome';

  @override
  String get tripPlannerRentalBike => 'Bici a noleggio';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Cammina fino a $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Vai in bici fino a $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Vai con la bici a noleggio fino a $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Guida fino a $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Prendi: $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Prendi: $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Prendi: $mode in direzione $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Prendi: $mode $route in direzione $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Scendi a $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Arriva a $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fermate',
      one: '$count fermata',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostra $count fermate',
      one: 'Mostra $count fermata',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nascondi $count fermate',
      one: 'Nascondi $count fermata',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passaggi',
      one: '$count passaggio',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostra $count passaggi',
      one: 'Mostra $count passaggio',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nascondi $count passaggi',
      one: 'Nascondi $count passaggio',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, circa $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Parti';

  @override
  String get tripPlannerDirectionHardLeft => 'Svolta bruscamente a sinistra';

  @override
  String get tripPlannerDirectionLeft => 'Svolta a sinistra';

  @override
  String get tripPlannerDirectionSlightlyLeft =>
      'Svolta leggermente a sinistra';

  @override
  String get tripPlannerDirectionContinue => 'Continua';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Svolta leggermente a destra';

  @override
  String get tripPlannerDirectionRight => 'Svolta a destra';

  @override
  String get tripPlannerDirectionHardRight => 'Svolta bruscamente a destra';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Entra nella rotonda in senso orario';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Entra nella rotonda in senso antiorario';

  @override
  String get tripPlannerDirectionElevator => 'Prendi l’ascensore';

  @override
  String get tripPlannerDirectionUturnLeft =>
      'Fai inversione a U verso sinistra';

  @override
  String get tripPlannerDirectionUturnRight =>
      'Fai inversione a U verso destra';

  @override
  String get tripPlannerDirectionEnterStation => 'Entra nella stazione';

  @override
  String get tripPlannerDirectionExitStation => 'Esci dalla stazione';

  @override
  String get tripPlannerDirectionFollowSigns => 'Segui i cartelli';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Cammina lungo $street per $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction su $street, cammina per $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Cerca un luogo';

  @override
  String get tripPlannerSearchNoResults => 'Nessun luogo trovato';

  @override
  String get tripPlannerSearchError => 'Impossibile cercare i luoghi. Riprova.';

  @override
  String get tripPlannerUseCurrentLocation => 'Usa la posizione attuale';

  @override
  String get tripPlannerLocationUnavailable =>
      'Impossibile ottenere la tua posizione.';

  @override
  String get tripPlannerClearSearch => 'Cancella ricerca';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Seleziona sia il punto di partenza sia la destinazione.';

  @override
  String get tripPlannerErrorNetwork =>
      'Impossibile raggiungere il pianificatore di viaggio. Controlla la connessione.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'Il server ha restituito una risposta non valida';

  @override
  String get tripPlannerErrorUnknown =>
      'Si è verificato un errore sconosciuto.';

  @override
  String get tripPlannerPlannerSystemError =>
      'Al momento non è stato possibile pianificare il viaggio. Riprova.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'La pianificazione dei viaggi è temporaneamente non disponibile. Riprova a breve.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'Questo luogo non è ancora supportato.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'Non è disponibile alcun percorso per questo viaggio.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'Al momento non sono disponibili opzioni di trasporto pubblico.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'L’operazione ha richiesto più tempo del previsto. Riprova.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'Si è verificato un problema con la richiesta. Riprova.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'Non siamo riusciti a trovare il punto di partenza.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'Non siamo riusciti a trovare la destinazione.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'Non siamo riusciti a trovare né il punto di partenza né la destinazione.';

  @override
  String get tripPlannerPlannerTooClose =>
      'La partenza e la destinazione sono troppo vicine.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'Questo percorso non è accessibile con l’opzione selezionata.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'Il punto di partenza non è chiaro. Prova a essere più preciso.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'La destinazione non è chiara. Prova a essere più preciso.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Entrambi i luoghi richiedono più dettagli. Prova a perfezionarli.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'Mancano alcune opzioni di percorso.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'Le opzioni di percorso selezionate non sono compatibili tra loro.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Scegli una preferenza di percorso.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Regola le preferenze di percorso.';
}
