// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class ObaLocalizationsEs extends ObaLocalizations {
  ObaLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get commonBack => 'Volver';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonDone => 'Listo';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonNotNow => 'Ahora no';

  @override
  String get commonSeeAll => 'Ver todo';

  @override
  String get commonLoading => 'Cargando';

  @override
  String get commonErrorTitle => 'Algo salió mal';

  @override
  String get commonEmptyTitle => 'Aún no hay nada aquí';

  @override
  String get commonComingSoon => 'Próximamente';

  @override
  String get commonComingSoonBody => 'Esta pantalla aún no está disponible.';

  @override
  String get commonOffline =>
      'Parece que no tienes conexión. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get commonServerError =>
      'El servidor no respondió como se esperaba. Inténtalo de nuevo en un momento.';

  @override
  String get sheetLabel => 'Panel';

  @override
  String get sheetExpand => 'Expandir panel';

  @override
  String get sheetCollapse => 'Contraer panel';

  @override
  String get sheetHandleHint =>
      'Arrastra o toca dos veces para cambiar el tamaño del panel';

  @override
  String get homeTabHome => 'Inicio';

  @override
  String get homeTabRecent => 'Reciente';

  @override
  String get homeTabBookmarks => 'Marcadores';

  @override
  String get homeSearchPlaceholder => 'Buscar paradas, rutas, lugares';

  @override
  String get homeSearchLabel => 'Buscar';

  @override
  String get homeSectionNearby => 'Cerca de ti';

  @override
  String get homeSectionRecent => 'Paradas recientes';

  @override
  String get homeSectionBookmarks => 'Marcadores';

  @override
  String get homeSectionAlerts => 'Alertas';

  @override
  String get homeSectionExplore => 'Explorar';

  @override
  String get homeSectionMore => 'Ajustes y más';

  @override
  String get mapLabel => 'Mapa';

  @override
  String get mapZoomInForStops => 'Acerca el mapa para ver las paradas';

  @override
  String get mapLocationDenied =>
      'El acceso a la ubicación está desactivado. Toca para permitirlo.';

  @override
  String get mapLocationServicesOff =>
      'Los servicios de ubicación están desactivados';

  @override
  String get mapRecenter => 'Mostrar mi ubicación';

  @override
  String get mapSettingsButton => 'Ajustes del mapa';

  @override
  String get mapStopsListButton => 'Paradas en el mapa';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas en el mapa',
      one: '$count parada en el mapa',
      zero: 'No hay paradas en el mapa',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'Tu ubicación';

  @override
  String get mapDroppedPin => 'Marcador colocado';

  @override
  String get mapVehicle => 'Vehículo';

  @override
  String get mapSelectedStop => 'Seleccionada';

  @override
  String get mapBookmarkedStop => 'Guardada en marcadores';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, parada: $routeType';
  }

  @override
  String get mapStopMarkerHint => 'Abre las salidas de la parada';

  @override
  String mapAttribution(String attribution) {
    return 'Datos del mapa: $attribution';
  }

  @override
  String get mapTypeTitle => 'Tipo de mapa';

  @override
  String get mapTypeStandard => 'Estándar';

  @override
  String get mapTypeSatellite => 'Satélite';

  @override
  String get mapTypeHybrid => 'Híbrido';

  @override
  String get mapShowScale => 'Mostrar escala';

  @override
  String get mapShowHeading => 'Mostrar orientación';

  @override
  String get mapShowStopLabels => 'Mostrar etiquetas de paradas';

  @override
  String mapPlaceAt(String lat, String lon) {
    return 'Ubicación en $lat, $lon';
  }

  @override
  String get directionN => 'Hacia el norte';

  @override
  String get directionNE => 'Hacia el noreste';

  @override
  String get directionE => 'Hacia el este';

  @override
  String get directionSE => 'Hacia el sureste';

  @override
  String get directionS => 'Hacia el sur';

  @override
  String get directionSW => 'Hacia el suroeste';

  @override
  String get directionW => 'Hacia el oeste';

  @override
  String get directionNW => 'Hacia el noroeste';

  @override
  String get routeTypeBus => 'Autobús';

  @override
  String get routeTypeLightRail => 'Tranvía';

  @override
  String get routeTypeSubway => 'Metro';

  @override
  String get routeTypeRail => 'Tren';

  @override
  String get routeTypeFerry => 'Transbordador';

  @override
  String get routeTypeCableCar => 'Teleférico';

  @override
  String get routeTypeGondola => 'Góndola';

  @override
  String get routeTypeFunicular => 'Funicular';

  @override
  String get routeTypeUnknown => 'Transporte público';

  @override
  String stopCode(String code) {
    return 'Parada $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'Rutas $routes';
  }

  @override
  String get stopPageRefresh => 'Actualizar';

  @override
  String get stopPageRefreshed => 'Salidas actualizadas';

  @override
  String get stopPageBookmark => 'Guardar parada en marcadores';

  @override
  String get stopPageBookmarked => 'Guardada en marcadores. Editar marcador';

  @override
  String get stopPageMoreActions => 'Más acciones de la parada';

  @override
  String get stopPageSchedules => 'Horarios';

  @override
  String get stopPageServiceAlerts => 'Alertas de servicio';

  @override
  String get stopPageNearbyStops => 'Paradas cercanas';

  @override
  String get stopPageWalkingDirections => 'Direcciones para caminar';

  @override
  String get stopPageBikeDirections => 'Direcciones en bicicleta';

  @override
  String get stopPagePlanTripFrom => 'Planificar un viaje desde aquí';

  @override
  String get stopPagePlanTripTo => 'Planificar un viaje hasta aquí';

  @override
  String get stopPageShareStop => 'Compartir parada';

  @override
  String get stopPageReportProblem => 'Informar de un problema';

  @override
  String get stopPageFilterRoutes => 'Filtrar rutas';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rutas ocultas',
      one: '$count ruta oculta',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'Por hora';

  @override
  String get stopPageModeRoute => 'Por ruta';

  @override
  String get stopPageDepartureTypes => 'Tipos de salida';

  @override
  String get stopPageFilterAll => 'Todas las salidas';

  @override
  String get stopPageFilterRealtime => 'Solo en tiempo real';

  @override
  String get stopPageFilterScheduled => 'Solo programadas';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count salidas anteriores',
      one: 'Mostrar $count salida anterior',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Ocultar salidas anteriores';

  @override
  String get stopPageLoadMore => 'Cargar más salidas';

  @override
  String stopPageWindow(int minutes) {
    return 'Mostrando los próximos $minutes minutos';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Actualizado $ago';
  }

  @override
  String get stopPageStaleTitle => 'No se pudieron actualizar las salidas';

  @override
  String get stopPageStaleBody =>
      'Es posible que estos horarios estén desactualizados.';

  @override
  String get stopPageEmptyTitle => 'No hay próximas salidas';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'No sale nada en los próximos $minutes minutos.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Todas las rutas con salidas aquí están ocultas.';

  @override
  String get stopPageShowAllRoutes => 'Mostrar todas las rutas';

  @override
  String get stopPageEmptyFilter =>
      'Ninguna salida coincide con el filtro de tipo de salida.';

  @override
  String get stopPageShowAllTypes => 'Mostrar todas las salidas';

  @override
  String get stopPageMissingTitle => 'Parada no encontrada';

  @override
  String get stopPageMissingBody =>
      'Es posible que esta parada se haya eliminado o renumerado.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes min a pie';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes min en bici';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos a pie',
      one: '$minutes minuto a pie',
    );
    return '$_temp0, $distance. Abre las direcciones.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos en bicicleta',
      one: '$minutes minuto en bicicleta',
    );
    return '$_temp0, $distance. Abre las direcciones.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '$minutes min a pie hasta esta parada. Las salidas de arriba parten antes.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '$minutes min en bici hasta esta parada. Las salidas de arriba parten antes.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Servicio de $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertas de servicio',
      one: '$count alerta de servicio',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sin leer',
      one: '$count sin leer',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Sin leer';

  @override
  String get stopPageAlertImportant => 'Importante';

  @override
  String get stopPageDirectionsChooser => 'Abrir direcciones en';

  @override
  String get stopPageAppleMaps => 'Apple Maps';

  @override
  String get stopPageGoogleMaps => 'Google Maps';

  @override
  String get stopPageCannotOpen => 'No se pudo abrir ese enlace.';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Transbordo desde $route $headsign, llegada a las $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Salidas';

  @override
  String get stopRowNow => 'AHORA';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String get stopRowOnTime => 'a tiempo';

  @override
  String stopRowLate(int minutes) {
    return '$minutes min de retraso';
  }

  @override
  String stopRowEarly(int minutes) {
    return '$minutes min antes';
  }

  @override
  String get stopRowScheduled => 'programado';

  @override
  String get stopRowCanceled => 'cancelado';

  @override
  String get stopRowOccupancyEmpty => 'Vacío';

  @override
  String get stopRowOccupancyManySeats => 'Muchos asientos disponibles';

  @override
  String get stopRowOccupancyFewSeats => 'Pocos asientos disponibles';

  @override
  String get stopRowOccupancyStanding => 'Solo de pie';

  @override
  String get stopRowOccupancyCrushed => 'Muy lleno';

  @override
  String get stopRowOccupancyFull => 'Lleno';

  @override
  String get stopRowOccupancyNotAccepting => 'No acepta pasajeros';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'llega en $minutes minutos',
      one: 'llega en $minutes minuto',
      zero: 'llega ahora',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'sale en $minutes minutos',
      one: 'sale en $minutes minuto',
      zero: 'sale ahora',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'llegó hace $minutes minutos',
      one: 'llegó hace $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'salió hace $minutes minutos',
      one: 'salió hace $minutes minuto',
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
    return 'Ruta $route hacia $headsign, $eta, a las $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'seguimiento en vivo, $status';
  }

  @override
  String get stopRowA11yScheduledOnly =>
      'solo hora programada, sin datos en tiempo real';

  @override
  String get stopRowA11yTransfer => 'tu viaje de transbordo';

  @override
  String get stopRowA11yMissed =>
      'probablemente lo pierdas, sale antes de que puedas llegar caminando';

  @override
  String get stopRowA11yAlarm => 'alarma activada';

  @override
  String stopRowActions(String route) {
    return 'Más acciones para la ruta $route';
  }

  @override
  String get stopRowShowTrip => 'Ver detalles del viaje';

  @override
  String get stopRowAddAlarm => 'Añadir alarma';

  @override
  String get stopRowRemoveAlarm => 'Eliminar alarma';

  @override
  String get stopRowBookmarkTrip => 'Guardar este viaje en marcadores';

  @override
  String get stopRowShareTrip => 'Compartir viaje';

  @override
  String get stopRowRouteSchedule => 'Horario de la ruta';

  @override
  String get stopRowRouteStops => 'Paradas de esta ruta';

  @override
  String stopRouteGroupNext(String times) {
    return 'Próximas: $times';
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
      other: '$count salidas',
      one: '$count salida',
    );
    return 'Ruta $route hacia $headsigns, $_temp0, próxima $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Avísame antes de que salga';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos antes',
      one: '$minutes minuto antes',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Alarma configurada para $minutes minutos antes',
      one: 'Alarma configurada para $minutes minuto antes',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Alarma eliminada';

  @override
  String get stopAlarmFailed => 'No se pudo actualizar la alarma.';

  @override
  String get stopAlarmPermissionDenied =>
      'Las notificaciones están desactivadas para esta app.';

  @override
  String get stopFilterTitle => 'Filtrar rutas';

  @override
  String get stopFilterSort => 'Ordenar salidas';

  @override
  String get stopFilterRoutesHeader => 'Rutas mostradas en esta parada';

  @override
  String get stopFilterShowAll => 'Mostrar todas las rutas';

  @override
  String get stopTripArrivingAtYourStop => 'Llegando a tu parada';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A $count paradas',
      one: 'A $count parada',
      zero: 'En tu parada',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return 'A $distance';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'En $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Posición actualizada $ago';
  }

  @override
  String get stopTripNoPosition =>
      'Sin posición en tiempo real para este vehículo';

  @override
  String stopTripStartsAs(String trip) {
    return 'Comienza como $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Continúa como $trip';
  }

  @override
  String get stopTripStopsHeader => 'Paradas';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas pasadas',
      one: '$count parada pasada',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas antes de tu parada',
      one: '$count parada antes de tu parada',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'Tu parada';

  @override
  String get stopTripBoarding => 'Embarcando';

  @override
  String get stopTripVehicleHere => 'El vehículo está aquí';

  @override
  String get stopTripTerminal => 'Última parada';

  @override
  String get stopTripPassed => 'Pasada';

  @override
  String get stopTripRouteStops => 'Todas las paradas de esta ruta';

  @override
  String get stopTripReport => 'Informar de un problema con este viaje';

  @override
  String get stopTripGhostBus => 'Informar de autobús fantasma';

  @override
  String get stopTripCanceled => 'Este viaje está cancelado';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Vehículo de la ruta $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'Cada $minutes min';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Ruta $route';
  }

  @override
  String get stopRouteStopsDirection => 'Dirección';

  @override
  String stopRouteStopsToward(String name) {
    return 'Hacia $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas',
      one: '$count parada',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => 'No se encontraron paradas para esta ruta.';

  @override
  String get stopSchedPrevDay => 'Día anterior';

  @override
  String get stopSchedNextDay => 'Día siguiente';

  @override
  String stopSchedPickDate(String date) {
    return 'Elegir fecha, $date';
  }

  @override
  String get stopSchedRoute => 'Ruta';

  @override
  String get stopSchedDirection => 'Dirección';

  @override
  String get stopSchedStop => 'Parada';

  @override
  String get stopSchedEmpty => 'No hay servicio programado este día.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'Cada $minutes min de $start a $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'Hacia $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count salidas',
      one: '$count salida',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported =>
      'Los horarios no están disponibles en esta región.';

  @override
  String get stopSchedViewList => 'Lista';

  @override
  String get stopSchedViewGrid => 'Cuadrícula';

  @override
  String get stopSchedNoDeparture => 'Sin salida';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (tu parada)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, viaje $trip: $time';
  }

  @override
  String get stopReportProblemHeader => '¿Cuál parece ser el problema?';

  @override
  String get stopReportStopNameWrong => 'El nombre de la parada es incorrecto';

  @override
  String get stopReportStopNumberWrong =>
      'El número de la parada es incorrecto';

  @override
  String get stopReportStopLocationWrong =>
      'La parada está en el lugar equivocado';

  @override
  String get stopReportRouteMissing => 'Falta una ruta o un viaje';

  @override
  String get stopReportOther => 'Otro motivo';

  @override
  String get stopReportNeverCame => 'El vehículo nunca llegó';

  @override
  String get stopReportCameEarly => 'Llegó antes de tiempo';

  @override
  String get stopReportCameLate => 'Llegó tarde';

  @override
  String get stopReportWrongHeadsign => 'El destino indicado era incorrecto';

  @override
  String get stopReportNotStopHere => 'No se detuvo aquí';

  @override
  String get stopReportComment => 'Comentarios adicionales (opcional)';

  @override
  String get stopReportShareLocation => 'Compartir mi ubicación';

  @override
  String get stopReportShareLocationHelp =>
      'Compartir tu ubicación puede ayudar a tu agencia de transporte a solucionar este problema.';

  @override
  String get stopReportOnVehicle => 'Estoy en este vehículo';

  @override
  String get stopReportVehicleId => 'Número de vehículo (opcional)';

  @override
  String get stopReportSend => 'Enviar informe';

  @override
  String get stopReportSending => 'Enviando informe';

  @override
  String get stopReportSent => '¡Gracias! Se envió tu informe.';

  @override
  String get stopReportFailed =>
      'No se pudo enviar el informe. Inténtalo de nuevo.';

  @override
  String get stopReportChooseProblem => 'Elige primero un problema.';

  @override
  String stopReportAbout(String name) {
    return 'Informando sobre: $name';
  }

  @override
  String get stopGhostTitle => 'Informar de autobús fantasma';

  @override
  String get stopGhostExplain =>
      'Un autobús fantasma es uno que la app mostró pero que nunca llegó.';

  @override
  String get stopGhostWait =>
      '¿Cuánto esperaste después de la hora programada?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get stopGhostWaitThirtyPlus => 'Más de 30 min';

  @override
  String get stopCardEmpty => 'No hay salidas próximas';

  @override
  String get titleSearch => 'Buscar';

  @override
  String get titleSearchResults => 'Resultados';

  @override
  String get titleNearbyStops => 'Paradas cercanas';

  @override
  String get titleRecentStops => 'Paradas recientes';

  @override
  String get titleBookmarks => 'Marcadores';

  @override
  String get titleStop => 'Parada';

  @override
  String get titleTrip => 'Viaje';

  @override
  String get titleRouteStops => 'Ruta';

  @override
  String get titleStopSchedule => 'Horario';

  @override
  String get titleRouteSchedule => 'Horario de la ruta';

  @override
  String get titleAlerts => 'Alertas';

  @override
  String get titleAlertDetail => 'Alerta';

  @override
  String get titleAgencies => 'Agencias';

  @override
  String get titleRegionPicker => 'Regiones';

  @override
  String get titleCustomRegion => 'Región personalizada';

  @override
  String get titleSettings => 'Configuración';

  @override
  String get titleMapSettings => 'Ajustes del mapa';

  @override
  String get titleMore => 'Más';

  @override
  String get titleTripPlanner => 'Planificar un viaje';

  @override
  String get titlePlace => 'Lugar';

  @override
  String get titleReportStopProblem => 'Informar de un problema';

  @override
  String get titleReportTripProblem => 'Informar de un problema';

  @override
  String get titleBookmarkEditor => 'Marcador';

  @override
  String get titleManageBookmarks => 'Editar marcadores';

  @override
  String get titleCredits => 'Reconocimientos';

  @override
  String get titleWeather => 'Clima';

  @override
  String get titleStopsOnMap => 'Paradas en el mapa';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Te damos la bienvenida a $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Llegadas en tiempo real de autobuses, trenes y transbordadores cerca de ti.';

  @override
  String get onboardingLocationTitle => 'Encuentra paradas cerca de ti';

  @override
  String get onboardingLocationBody =>
      'Permite el acceso a la ubicación para ver las paradas cercanas y elegir tu región automáticamente.';

  @override
  String get onboardingAllowLocation => 'Permitir acceso a la ubicación';

  @override
  String get onboardingRegionTitle => 'Elige tu región';

  @override
  String get onboardingRegionBody =>
      'Elige la zona cuyo transporte quieres ver.';

  @override
  String get settingsSectionMap => 'Mapa';

  @override
  String get settingsMapTypeRow => 'Tipo de mapa y capas';

  @override
  String get settingsMapTypeHelp => 'Elige el aspecto del mapa.';

  @override
  String get settingsHeadingHelp =>
      'Muestra en el mapa hacia dónde estás mirando.';

  @override
  String get settingsStopLabelsHelp =>
      'Muestra los nombres de las rutas junto a las paradas del mapa.';

  @override
  String get settingsWalkingDirections => 'Direcciones para caminar';

  @override
  String get settingsWalkingDirectionsHelp =>
      'La app que se abre cuando pides direcciones a pie hasta una parada.';

  @override
  String get settingsDirectionsAsk => 'Preguntar siempre';

  @override
  String get settingsDirectionsAppleMaps => 'Apple Maps';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Maps';

  @override
  String get settingsSectionDepartures => 'Salidas';

  @override
  String get settingsDepartureFilter => 'Mostrar salidas';

  @override
  String get settingsDepartureFilterHelp =>
      'Elige si las páginas de parada muestran todas las salidas o solo las que tienen datos en tiempo real o programados.';

  @override
  String get settingsFilterAll => 'Todas las salidas';

  @override
  String get settingsFilterRealtime => 'Solo en tiempo real';

  @override
  String get settingsFilterScheduled => 'Solo programadas';

  @override
  String get settingsRegionTimeZone =>
      'Mostrar las horas en la zona horaria de la región';

  @override
  String get settingsRegionTimeZoneHelp =>
      'Las horas usan la zona horaria de la región de transporte, con una nota cuando difiere de la de tu dispositivo.';

  @override
  String get settingsSectionAccessibility => 'Accesibilidad';

  @override
  String get settingsReducedColors =>
      'Reducir colores en las páginas de parada';

  @override
  String get settingsReducedColorsHelp =>
      'Muestra las insignias de ruta con un único estilo neutro.';

  @override
  String get settingsCompactMode => 'Páginas de parada y viaje compactas';

  @override
  String get settingsCompactModeHelp =>
      'Reduce el espaciado para que quepa más en pantalla.';

  @override
  String get settingsSectionWalking => 'Velocidad al caminar';

  @override
  String get settingsWalkingSpeed => 'Velocidad al caminar';

  @override
  String get settingsWalkingSpeedHelp =>
      'Se usa para estimar el tiempo a pie y las horas de llegada.';

  @override
  String get settingsSpeedSlow => 'Lenta';

  @override
  String get settingsSpeedAverage => 'Media';

  @override
  String get settingsSpeedFast => 'Rápida';

  @override
  String settingsSpeedCustom(String speed) {
    return 'Personalizada ($speed m/s)';
  }

  @override
  String get settingsSectionBike => 'Modo bicicleta';

  @override
  String get settingsBikeMode => 'Modo bicicleta';

  @override
  String get settingsBikeModeHelp =>
      'Usa una velocidad de desplazamiento mayor para las estimaciones de tiempo a pie, las horas de llegada y la página de parada.';

  @override
  String get settingsSectionSurveys => 'Encuestas';

  @override
  String get settingsSurveysEnabled => 'Mostrar encuestas';

  @override
  String get settingsSurveysAlways =>
      'Mostrar siempre encuestas en las paradas';

  @override
  String get settingsSectionPrivacy => 'Privacidad';

  @override
  String get settingsAnalytics => 'Enviar datos de uso a los desarrolladores';

  @override
  String get settingsAnalyticsHelp =>
      'Ayuda a los desarrolladores a saber qué funciones se usan.';

  @override
  String get settingsSectionDebug => 'Depuración';

  @override
  String get settingsDebugMode => 'Modo de depuración';

  @override
  String get settingsDebugAlwaysFeedback =>
      'Mostrar siempre la solicitud de opinión';

  @override
  String get settingsDebugResetFeedback =>
      'Restablecer el estado de la solicitud de opinión';

  @override
  String get settingsDebugResetDonation =>
      'Restablecer el estado de la tarjeta de donación';

  @override
  String get settingsDebugResetDone => 'Restablecido';

  @override
  String get settingsSectionTripPlanner => 'Planificador de viajes';

  @override
  String get settingsHomeCustomizeMap => 'Personalizar mapa';

  @override
  String get moreHeaderSupport =>
      'Esta aplicación está hecha y apoyada por voluntarios.';

  @override
  String get moreSectionDonate => 'Sé un colaborador';

  @override
  String moreDonate(String appName) {
    return 'Donar a $appName';
  }

  @override
  String get moreManageDonations => 'Gestionar donaciones';

  @override
  String get moreSectionUpdates => 'Novedades y alertas';

  @override
  String get moreAlerts => 'Alertas';

  @override
  String get moreSectionLocation => 'Mi ubicación';

  @override
  String get moreRegion => 'Región';

  @override
  String get moreRegionNone => 'Sin seleccionar';

  @override
  String get morePayFare => 'Pagar mi pasaje';

  @override
  String get moreAgencies => 'Agencias';

  @override
  String get moreSectionAbout => 'Acerca de esta app';

  @override
  String moreRateApp(String appName) {
    return 'Valorar $appName';
  }

  @override
  String get moreContactUs => 'Contáctanos';

  @override
  String get morePrivacy => 'Política de privacidad';

  @override
  String get moreCredits => 'Reconocimientos';

  @override
  String moreVersion(String appName, String version) {
    return '$appName versión $version';
  }

  @override
  String get moreSectionHelpOut => 'Ayuda a mejorar la app';

  @override
  String get moreTranslate => 'Ayuda a traducir la app';

  @override
  String get moreDevelop => 'Ayuda a corregir errores y crear nuevas funciones';

  @override
  String get moreSectionContact => 'Contacto y ayuda';

  @override
  String get moreTutorials => 'Tutoriales';

  @override
  String get moreCallAgency => 'Llamar a la agencia';

  @override
  String get moreTextAgency => 'Enviar mensaje a la agencia';

  @override
  String get moreSectionResources => 'Recursos';

  @override
  String get moreContactTitle => 'Contáctanos';

  @override
  String get moreContactDevelopers =>
      'Sugerencia de función o informe de error';

  @override
  String get moreContactAgency => 'Problema con un vehículo o un horario';

  @override
  String moreEmailSubject(String appName) {
    return 'Comentarios sobre $appName';
  }

  @override
  String get moreEmailAgencySubject =>
      'Comentarios de un usuario del transporte';

  @override
  String get moreEmailIntro =>
      '¿En qué podemos ayudarte? Escribe tu respuesta a continuación:';

  @override
  String get moreEmailDebugIntro =>
      'La siguiente información se proporciona para resolver problemas. Si no te sientes cómodo compartiendo algo de ella, puedes eliminarlo, aunque esto puede afectar nuestra capacidad de ayudarte.';

  @override
  String get moreDebugAppVersion => 'Versión de la app';

  @override
  String get moreDebugOs => 'Sistema operativo';

  @override
  String get moreDebugLocale => 'Idioma';

  @override
  String get moreDebugBookmarks => 'Cantidad de marcadores';

  @override
  String get moreDebugLocationPermission => 'Permiso de ubicación';

  @override
  String get moreDebugRegion => 'Región';

  @override
  String get moreDebugRegionId => 'ID de la región';

  @override
  String get moreDebugApiUrl => 'URL base de la API';

  @override
  String get moreDebugUserId => 'ID de usuario';

  @override
  String get moreCantEmailTitle => 'No se puede abrir tu app de correo';

  @override
  String moreCantEmailBody(String email) {
    return 'Para contactarnos, envía un correo a $email. Copia la información de depuración y pégala en tu mensaje para ayudarnos a resolver el problema.';
  }

  @override
  String get moreCopyEmail => 'Copiar dirección de correo';

  @override
  String get moreCopyDebug => 'Copiar información de depuración';

  @override
  String get moreCopied => 'Copiado al portapapeles';

  @override
  String get moreFareContinue => 'Continuar';

  @override
  String get moreFareDontShowAgain => 'Continuar y no volver a mostrar';

  @override
  String get moreCantOpenLink => 'No se pudo abrir ese enlace.';

  @override
  String get regionPickerAutomatic => 'Elegir la región automáticamente';

  @override
  String get regionPickerAutomaticHelp =>
      'Cambia a la región que contiene tu ubicación. Si eliges una región tú mismo, esto se desactiva.';

  @override
  String get regionPickerShowExperimental => 'Mostrar regiones experimentales';

  @override
  String get regionPickerShowInactive => 'Mostrar regiones inactivas';

  @override
  String get regionPickerRegionsSection => 'Regiones';

  @override
  String get regionPickerCustomSection => 'Regiones personalizadas';

  @override
  String get regionPickerCurrent => 'Región actual';

  @override
  String get regionPickerExperimentalTag => 'Experimental';

  @override
  String get regionPickerInactiveTag => 'Inactiva';

  @override
  String get regionPickerCustomTag => 'Personalizada';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Añadir región personalizada';

  @override
  String get regionPickerRefresh => 'Actualizar regiones';

  @override
  String get regionPickerRefreshed => 'Regiones actualizadas';

  @override
  String get regionPickerRefreshFailed =>
      'No se pudo actualizar la lista de regiones. Se muestra la lista guardada.';

  @override
  String regionPickerSelected(String name) {
    return '$name seleccionada';
  }

  @override
  String regionPickerEdit(String name) {
    return 'Editar $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'Eliminar $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return '¿Eliminar $name?';
  }

  @override
  String get regionPickerDeleteBody =>
      'Esta región personalizada se eliminará de este dispositivo.';

  @override
  String get regionPickerDeleteConfirm => 'Eliminar';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Elige otra región antes de eliminar esta.';

  @override
  String get regionPickerEmpty => 'No hay regiones disponibles';

  @override
  String get regionPickerEmptyBody =>
      'Activa las regiones experimentales o inactivas, o añade una región personalizada.';

  @override
  String get regionPickerTripPlanner => 'Planificador de viajes en esta región';

  @override
  String get customRegionEditTitle => 'Editar región personalizada';

  @override
  String get customRegionName => 'Nombre';

  @override
  String get customRegionObaUrl => 'URL del servidor de OneBusAway';

  @override
  String get customRegionObaUrlHelp =>
      'La dirección del servidor, por ejemplo https://oba.example.com/';

  @override
  String get customRegionSidecar => 'URL del servidor Sidecar (opcional)';

  @override
  String get customRegionOtp => 'URL del planificador de viajes (opcional)';

  @override
  String get customRegionOtpGraphql =>
      'URL GraphQL del planificador de viajes (opcional)';

  @override
  String get customRegionServiceArea => 'Área de servicio';

  @override
  String get customRegionServiceAreaHelp =>
      'La zona que cubre esta región: un punto central y hasta dónde se extiende.';

  @override
  String get customRegionLatitude => 'Latitud del centro';

  @override
  String get customRegionLongitude => 'Longitud del centro';

  @override
  String get customRegionLatSpan => 'Extensión de latitud (grados)';

  @override
  String get customRegionLonSpan => 'Extensión de longitud (grados)';

  @override
  String get customRegionUseMap => 'Usar el área actual del mapa';

  @override
  String get customRegionSave => 'Guardar';

  @override
  String get customRegionErrorRequired => 'Este campo es obligatorio';

  @override
  String get customRegionErrorUrl =>
      'Introduce una dirección web que empiece por http:// o https://';

  @override
  String get customRegionErrorNumber => 'Introduce un número';

  @override
  String get customRegionErrorRange => 'Este número está fuera de rango';

  @override
  String get customRegionChecking => 'Comprobando el servidor';

  @override
  String get customRegionServerOk => 'El servidor respondió';

  @override
  String get customRegionServerUnreachable =>
      'No se pudo conectar con este servidor';

  @override
  String get customRegionServerNotOba =>
      'Este servidor no respondió como OneBusAway';

  @override
  String customRegionSaved(String name) {
    return '$name guardada';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway es software de transporte público libre y de código abierto, creado por voluntarios y respaldado por la Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'Licencia';

  @override
  String get creditsMapData => 'Datos del mapa';

  @override
  String get creditsLicenses => 'Licencias de código abierto';

  @override
  String get creditsLicensesHelp =>
      'Las bibliotecas con las que se creó esta app.';

  @override
  String get creditsLicensesLoading => 'Cargando licencias';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count licencias',
      one: '$count licencia',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Disponible en decenas de regiones de transporte de todo el mundo.';

  @override
  String get onboardingBenefitNearbyTitle => 'Ver paradas cercanas';

  @override
  String get onboardingBenefitNearbyBody =>
      'Autobuses y trenes cerca de ti, ordenados por distancia.';

  @override
  String get onboardingBenefitMapTitle => 'Centrar el mapa en ti';

  @override
  String get onboardingBenefitMapBody =>
      'Abre directamente tu entorno, sin buscar.';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName solo usa tu ubicación mientras la app está abierta. Puedes cambiarlo en cualquier momento en los ajustes de tu dispositivo.';
  }

  @override
  String get onboardingLocationDenied =>
      'El acceso a la ubicación está desactivado. Aun así puedes elegir tu región tú mismo.';

  @override
  String get onboardingRegionDetected => 'Detectada cerca de ti';

  @override
  String onboardingRegionUse(String name) {
    return 'Usar $name';
  }

  @override
  String get onboardingRegionOthers => 'O elige otra región';

  @override
  String get onboardingRegionEmpty =>
      'No hay regiones disponibles por ahora. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get surveyCardTitle => 'Ayuda a mejorar el transporte';

  @override
  String get surveyDefaultPrompt =>
      'Responde una breve encuesta para ayudar a mejorar el transporte.';

  @override
  String get surveyTake => 'Responder encuesta';

  @override
  String get surveyNotNow => 'Ahora no';

  @override
  String get surveyDismiss => 'Descartar encuesta';

  @override
  String get surveyNext => 'Siguiente';

  @override
  String get surveySubmit => 'Enviar encuesta';

  @override
  String get surveySubmitting => 'Enviando';

  @override
  String get surveyQuestionsTitle => 'Encuesta';

  @override
  String get surveyTextHint => 'Escribe tu respuesta';

  @override
  String get surveyRequired => 'Obligatorio';

  @override
  String get surveyIncomplete =>
      'Responde todas las preguntas obligatorias antes de enviar.';

  @override
  String get surveyFailed =>
      'No se pudieron enviar tus respuestas. Inténtalo de nuevo.';

  @override
  String get surveyThanks => 'Gracias por tus comentarios.';

  @override
  String get surveyOpenSurvey => 'Abrir encuesta';

  @override
  String get surveyLearnMore => 'Más información';

  @override
  String get surveyShareFeedback => 'Compartir comentarios';

  @override
  String get surveySignUp => 'Registrarse';

  @override
  String get surveyExternalError =>
      'No se pudo abrir el enlace de esta encuesta. Inténtalo más tarde.';

  @override
  String donationTitle(String appName) {
    return '$appName necesita tu ayuda';
  }

  @override
  String get donationBody =>
      'Esta app se crea con trabajo voluntario y necesitamos tu ayuda para financiar su desarrollo futuro.';

  @override
  String get donationLearnMore => 'Más información';

  @override
  String get donationDonate => 'Donar ahora';

  @override
  String get donationRemindLater => 'Recordármelo más tarde';

  @override
  String get donationDismiss => 'No, gracias';

  @override
  String get donationHeader => 'Por qué necesitamos tu ayuda';

  @override
  String donationExplanation(String appName) {
    return 'Tenemos grandes planes para mejorar $appName, pero no podemos hacerlo sin tu ayuda. Esta app se crea con trabajo voluntario y necesitamos tu ayuda para financiar su desarrollo futuro.\n\nComo proyecto clave de la Open Transit Software Foundation, una organización sin fines de lucro, tu donación es deducible de impuestos en Estados Unidos.';
  }

  @override
  String get donationDonateWebsite => 'Donar en nuestro sitio web';

  @override
  String titleDonation(String appName) {
    return 'Apoya a $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return '¿Te gusta $appName?';
  }

  @override
  String get feedbackYes => '¡Sí!';

  @override
  String get feedbackNo => 'La verdad, no';

  @override
  String get feedbackLater => 'Preguntarme más tarde';

  @override
  String get feedbackNegativeTitle => 'Lo sentimos.';

  @override
  String get feedbackNegativeBody =>
      '¿Nos cuentas qué está fallando? Leemos todos los mensajes.';

  @override
  String get feedbackSend => 'Enviar comentarios';

  @override
  String get feedbackDecline => 'No, gracias';

  @override
  String get tripPlanningUnavailable =>
      'La planificación de viajes no está disponible en esta región.';

  @override
  String get deepLinkOtherRegion =>
      'Este enlace es de otra región. Cambia de región para abrirlo.';

  @override
  String get dataUpdated => 'Actualizado';

  @override
  String get bookmarksEtaNow => 'Ahora';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'en $minutes minutos',
      one: 'en $minutes minuto',
      zero: 'ahora',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => 'A tiempo';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min de retraso',
      one: '$minutes min de retraso',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min antes',
      one: '$minutes min antes',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => 'Programado';

  @override
  String get bookmarksStatusCanceled => 'Cancelado';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Ruta $route hacia $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Ruta $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Cargando salidas';

  @override
  String get bookmarksNoDepartures => 'No hay próximas salidas';

  @override
  String get bookmarksDeparturesError => 'No se pudieron cargar las salidas';

  @override
  String get bookmarksDeparturesStale =>
      'No se pudo actualizar. Se muestran horarios anteriores.';

  @override
  String get bookmarksUpdated => 'Salidas actualizadas';

  @override
  String get bookmarksSortTooltip => 'Ordenar marcadores';

  @override
  String get bookmarksSortByGroup => 'Ordenar por grupo';

  @override
  String get bookmarksSortByDistance => 'Ordenar por distancia';

  @override
  String get bookmarksManageTooltip => 'Editar marcadores y grupos';

  @override
  String get bookmarksRefreshTooltip => 'Actualizar salidas';

  @override
  String get bookmarksEmptyTitle => 'Aún no hay marcadores';

  @override
  String get bookmarksEmptyBody =>
      'Abre una parada y toca su botón de marcador para guardarla aquí. Desde una salida también puedes guardar solo esa ruta en la parada.';

  @override
  String get bookmarksFindStops => 'Buscar paradas en el mapa';

  @override
  String get bookmarksUngrouped => 'Sin grupo';

  @override
  String get bookmarksGroupExpanded => 'expandido';

  @override
  String get bookmarksGroupCollapsed => 'contraído';

  @override
  String get bookmarksGroupToggleHint =>
      'Muestra u oculta los marcadores de este grupo';

  @override
  String bookmarksActionsFor(String name) {
    return 'Acciones para $name';
  }

  @override
  String get bookmarksActionEdit => 'Editar';

  @override
  String get bookmarksActionPin => 'Fijar arriba';

  @override
  String get bookmarksActionUnpin => 'Dejar de fijar';

  @override
  String get bookmarksActionMove => 'Mover a un grupo';

  @override
  String get bookmarksActionDelete => 'Eliminar';

  @override
  String get bookmarksPinned => 'Fijado';

  @override
  String bookmarksDeleted(String name) {
    return '$name eliminado';
  }

  @override
  String get bookmarksUndo => 'Deshacer';

  @override
  String get bookmarksMoveTitle => 'Mover a un grupo';

  @override
  String get bookmarksNoGroup => 'Sin grupo';

  @override
  String bookmarksMoved(String group) {
    return 'Movido a $group';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name, $details';
  }

  @override
  String get bookmarksEditorNameLabel => 'Nombre del marcador';

  @override
  String get bookmarksEditorNameRequired =>
      'Introduce un nombre para este marcador.';

  @override
  String get bookmarksEditorDuplicate =>
      'Ya tienes un marcador con este nombre para esta parada y ruta. Cambia el nombre para guardar otro.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Marcador de parada: muestra las próximas salidas de todas las rutas en $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Marcador de viaje: muestra las próximas salidas de $route en $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'Solo $route';
  }

  @override
  String get bookmarksEditorGroup => 'Grupo';

  @override
  String get bookmarksEditorNewGroup => 'Nuevo grupo…';

  @override
  String get bookmarksEditorNewGroupTitle => 'Nuevo grupo';

  @override
  String get bookmarksEditorGroupName => 'Nombre del grupo';

  @override
  String get bookmarksEditorSave => 'Guardar';

  @override
  String get bookmarksEditorSaved => 'Marcador guardado';

  @override
  String get bookmarksEditorDelete => 'Eliminar marcador';

  @override
  String get bookmarksEditorDeleteTitle => '¿Eliminar este marcador?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '“$name” se eliminará de tus marcadores.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Elige una región antes de añadir marcadores.';

  @override
  String get bookmarksManageGroupsHeader => 'Grupos';

  @override
  String get bookmarksManageBookmarksHeader => 'Marcadores';

  @override
  String get bookmarksManageAddGroup => 'Añadir grupo';

  @override
  String get bookmarksManageRenameGroup => 'Cambiar nombre del grupo';

  @override
  String get bookmarksManageDeleteGroup => 'Eliminar grupo';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'Los marcadores de “$name” quedarán sin grupo.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Subir $name';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Bajar $name';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Reordenar $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, posición $position de $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'Aún no hay marcadores ni grupos que gestionar.';

  @override
  String get bookmarksManageUngrouped => 'Marcadores sin grupo';

  @override
  String get recentsEmptyTitle => 'No hay paradas recientes';

  @override
  String get recentsEmptyBody =>
      'Las paradas que consultes aparecen aquí, las más recientes primero.';

  @override
  String get recentsFindStops => 'Buscar paradas en el mapa';

  @override
  String get recentsClearAll => 'Borrar todo';

  @override
  String get recentsClearTitle => '¿Borrar paradas recientes?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Se eliminarán las $count paradas recientes. Tus marcadores no se ven afectados.',
      one:
          'Se eliminará $count parada reciente. Tus marcadores no se ven afectados.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Quitar $name de las paradas recientes';
  }

  @override
  String recentsRemoved(String name) {
    return '$name quitada';
  }

  @override
  String get recentsSectionEmpty => 'Las paradas que consultes aparecen aquí.';

  @override
  String get alarmsSectionTitle => 'Alarmas';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos antes de la salida',
      one: '$minutes minuto antes de la salida',
    );
    return '$_temp0, a las $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Alarma para $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'Eliminar alarma para $title';
  }

  @override
  String get alarmsDeleted => 'Alarma eliminada';

  @override
  String get alarmsDeleteFailed =>
      'No se pudo eliminar la alarma. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get alarmsOpen => 'Abre el viaje';

  @override
  String get alertsEmptyTitle => 'No hay alertas de servicio';

  @override
  String get alertsEmptyBody =>
      'No hay alertas de servicio activas en este momento.';

  @override
  String get alertsRegionNote =>
      'Incluye alertas de tus paradas en marcadores, recientes y cercanas.';

  @override
  String get alertsMarkAllRead => 'Marcar todo como leído';

  @override
  String get alertsAllRead => 'Todas las alertas marcadas como leídas';

  @override
  String get alertsUnread => 'Sin leer';

  @override
  String get alertsSeverityInfo => 'Información';

  @override
  String get alertsSeverityWarning => 'Advertencia';

  @override
  String get alertsSeveritySevere => 'Grave';

  @override
  String get alertsSeverityUnknown => 'Alerta de servicio';

  @override
  String get alertsNoTitle => 'Alerta de servicio';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Sin leer. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertas sin leer',
      one: '$count alerta sin leer',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertas más',
      one: '$count alerta más',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Periodo activo';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start a $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'Desde $start';
  }

  @override
  String get alertsDetailAffects => 'Afecta a';

  @override
  String get alertsDetailRoutes => 'Rutas';

  @override
  String get alertsDetailStops => 'Paradas';

  @override
  String get alertsDetailAgencies => 'Agencias';

  @override
  String get alertsDetailLearnMore => 'Más información';

  @override
  String get alertsDetailNoDetails =>
      'No hay detalles adicionales disponibles.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Emitida $date';
  }

  @override
  String get alertsCouldNotOpen => 'No se pudo abrir ese enlace.';

  @override
  String get agenciesEmptyTitle => 'No hay agencias';

  @override
  String get agenciesEmptyBody =>
      'Esta región no incluye ninguna agencia de transporte.';

  @override
  String get agenciesWebsite => 'Sitio web';

  @override
  String agenciesPhone(String phone) {
    return 'Llamar al $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'Enviar correo a $email';
  }

  @override
  String get agenciesFares => 'Información de tarifas';

  @override
  String get agenciesDisclaimer => 'Aviso legal';

  @override
  String get agenciesShowOnMap => 'Mostrar cobertura en el mapa';

  @override
  String get searchFieldLabel => 'Buscar';

  @override
  String get searchFieldHint => 'Ruta, número de parada, dirección o vehículo';

  @override
  String get searchClear => 'Borrar búsqueda';

  @override
  String get searchScopeLabel => 'Buscar';

  @override
  String get searchScopeAll => 'Todo';

  @override
  String get searchScopeStops => 'Paradas';

  @override
  String get searchScopeRoutes => 'Rutas';

  @override
  String get searchScopePlaces => 'Lugares';

  @override
  String get searchQuickHeader => 'Buscar';

  @override
  String searchQuickRoute(String query) {
    return 'Ruta: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Número de parada: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Dirección: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Vehículo: $query';
  }

  @override
  String get searchRecentStopsHeader => 'Paradas recientes';

  @override
  String get searchBookmarksHeader => 'Marcadores';

  @override
  String get searchRecentSearchesHeader => 'Búsquedas recientes';

  @override
  String get searchRecentPlacesHeader => 'Lugares recientes';

  @override
  String get searchPlacesHeader => 'Lugares';

  @override
  String get searchClearRecent => 'Borrar búsquedas recientes';

  @override
  String get searchClearRecentConfirm =>
      '¿Borrar tus búsquedas y lugares recientes?';

  @override
  String get searchClearAction => 'Borrar';

  @override
  String get searchRecentCleared => 'Búsquedas recientes borradas';

  @override
  String get searchPlacesLoading => 'Buscando lugares';

  @override
  String get searchPlacesNone => 'No se encontraron lugares';

  @override
  String get searchPlacesError =>
      'No se pudo buscar lugares. Revisa tu conexión.';

  @override
  String get searchSearching => 'Buscando';

  @override
  String get searchNoResultsTitle => 'Sin resultados';

  @override
  String searchNoResultsBody(String query) {
    return 'No se encontraron resultados para “$query”.';
  }

  @override
  String get searchUnavailableNoRegion => 'Elige una región antes de buscar.';

  @override
  String get searchUnavailableAddress =>
      'La búsqueda de direcciones no está configurada en esta app.';

  @override
  String get searchUnavailableVehicle =>
      'La búsqueda de vehículos no está disponible en esta región.';

  @override
  String get searchEmptyTitle => 'Encuentra rutas, paradas y lugares';

  @override
  String get searchEmptyBody =>
      'Escribe el nombre de una ruta, un número de parada, una dirección o un ID de vehículo.';

  @override
  String get searchDismissMessage => 'Descartar';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count resultados para “$query”',
      one: '$count resultado para “$query”',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'Rutas';

  @override
  String get searchResultsStops => 'Paradas';

  @override
  String get searchResultsVehicles => 'Vehículos';

  @override
  String get searchResultsPlaces => 'Lugares';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Ruta $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Vehículo $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'El vehículo $id no está realizando ningún viaje en este momento.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Cargando vehículo $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'Activa la ubicación para ver las salidas de las paradas cercanas.';

  @override
  String get searchNearbyLocationButton => 'Usar mi ubicación';

  @override
  String get searchNearbyLocationDenied =>
      'El acceso a la ubicación está desactivado. Actívalo en los ajustes del dispositivo para ver las paradas cercanas.';

  @override
  String get searchNearbyLocationServicesOff =>
      'Los servicios de ubicación están desactivados. Actívalos para ver las paradas cercanas.';

  @override
  String get searchNearbyLocationUnavailable =>
      'Esta aplicación no usa tu ubicación, así que no puede mostrar las paradas cercanas.';

  @override
  String get searchNearbyEmpty => 'No hay paradas cercanas';

  @override
  String get searchNearbyEmptyBody =>
      'No hay paradas a una distancia que se pueda recorrer a pie.';

  @override
  String get searchNearbyMapCenter =>
      'Se muestran las paradas cercanas al centro del mapa.';

  @override
  String get searchNearbyNoDepartures => 'No hay salidas en la próxima hora';

  @override
  String get searchNearbyLoadingDepartures => 'Cargando salidas';

  @override
  String get searchNearbyUpdated => 'Salidas cercanas actualizadas';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas cercanas',
      one: '$count parada cercana',
      zero: 'No hay paradas cercanas',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Buscando tu ubicación…';

  @override
  String get searchNearbyRefresh => 'Actualizar';

  @override
  String searchNearbyDistance(String distance) {
    return 'A $distance';
  }

  @override
  String get searchNearbyOtherDirection => 'Otras paradas';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return 'Paradas $direction';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route hacia $headsign, $eta, $status. Desde $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'Desde $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Salidas cerca de ti';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get searchEtaNow => 'Ahora';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'en $minutes minutos',
      one: 'en $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => 'sale ahora';

  @override
  String get searchStatusOnTime => 'A tiempo';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min de retraso',
      one: '$minutes min de retraso',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min antes',
      one: '$minutes min antes',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => 'Programado';

  @override
  String get searchExplorePlanTrip => 'Planificar un viaje';

  @override
  String get searchExploreWeather => 'Clima';

  @override
  String get searchExploreAgencies => 'Agencias';

  @override
  String get searchPlaceAddress => 'Dirección';

  @override
  String get searchPlaceCoordinates => 'Coordenadas';

  @override
  String get searchPlaceDistance => 'Distancia';

  @override
  String get searchPlaceDirectionsTo => 'Cómo llegar hasta aquí';

  @override
  String get searchPlaceDirectionsFrom => 'Cómo llegar desde aquí';

  @override
  String get searchPlaceNearbyStops => 'Paradas cercanas';

  @override
  String get searchPlaceShare => 'Compartir';

  @override
  String get searchPlaceOpenInMaps => 'Abrir en la app de mapas';

  @override
  String get searchPlaceRemovePin => 'Quitar marcador';

  @override
  String get searchPlaceOpenFailed => 'No se pudo abrir una app de mapas.';

  @override
  String get searchPlaceShareFailed => 'No se pudo compartir este lugar.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Lugar: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Clima: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Muestra el pronóstico';

  @override
  String get searchWeatherClear => 'Despejado';

  @override
  String get searchWeatherPartlyCloudy => 'Parcialmente nublado';

  @override
  String get searchWeatherCloudy => 'Nublado';

  @override
  String get searchWeatherRain => 'Lluvia';

  @override
  String get searchWeatherSleet => 'Aguanieve';

  @override
  String get searchWeatherSnow => 'Nieve';

  @override
  String get searchWeatherWindy => 'Ventoso';

  @override
  String get searchWeatherFog => 'Niebla';

  @override
  String get searchWeatherUnknown => 'Condiciones desconocidas';

  @override
  String searchWeatherDegreesF(int value) {
    return '$value °F';
  }

  @override
  String searchWeatherDegreesC(int value) {
    return '$value °C';
  }

  @override
  String searchWeatherSpokenF(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value grados Fahrenheit',
      one: '$value grado Fahrenheit',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value grados Celsius',
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
    return '$value %';
  }

  @override
  String get searchWeatherFeelsLike => 'Sensación térmica';

  @override
  String get searchWeatherWind => 'Viento';

  @override
  String get searchWeatherPrecip => 'Probabilidad de lluvia';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'Máx. $high · Mín. $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'Máxima de $high, mínima de $low, durante las próximas 24 horas';
  }

  @override
  String get searchWeatherHourly => 'Próximas 24 horas';

  @override
  String get searchWeatherNow => 'Ahora';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, $precip de probabilidad de lluvia';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Temperaturas en $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'grados Fahrenheit (°F)';

  @override
  String get searchWeatherCelsius => 'grados Celsius (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Pronóstico de las $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'El clima no está disponible para esta región.';

  @override
  String get searchWeatherSummaryLabel => 'Hoy';

  @override
  String get bookmarksSectionEmpty =>
      'Las paradas guardadas en marcadores aparecen aquí.';

  @override
  String get coreDirectionNameN => 'Norte';

  @override
  String get coreDirectionNameNE => 'Noreste';

  @override
  String get coreDirectionNameE => 'Este';

  @override
  String get coreDirectionNameSE => 'Sureste';

  @override
  String get coreDirectionNameS => 'Sur';

  @override
  String get coreDirectionNameSW => 'Suroeste';

  @override
  String get coreDirectionNameW => 'Oeste';

  @override
  String get coreDirectionNameNW => 'Noroeste';

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
  String get coreDirectionBoundN => 'Hacia el norte';

  @override
  String get coreDirectionBoundNE => 'Hacia el noreste';

  @override
  String get coreDirectionBoundE => 'Hacia el este';

  @override
  String get coreDirectionBoundSE => 'Hacia el sureste';

  @override
  String get coreDirectionBoundS => 'Hacia el sur';

  @override
  String get coreDirectionBoundSW => 'Hacia el suroeste';

  @override
  String get coreDirectionBoundW => 'Hacia el oeste';

  @override
  String get coreDirectionBoundNW => 'Hacia el noroeste';

  @override
  String get coreRouteTypeLightRail => 'Tranvía';

  @override
  String get coreRouteTypeSubway => 'Metro';

  @override
  String get coreRouteTypeRail => 'Tren';

  @override
  String get coreRouteTypeBus => 'Autobús';

  @override
  String get coreRouteTypeFerry => 'Transbordador';

  @override
  String get coreRouteTypeCableCar => 'Teleférico';

  @override
  String get coreRouteTypeGondola => 'Góndola';

  @override
  String get coreRouteTypeFunicular => 'Funicular';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Parada n.º $code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Parada: \'$code\'';
  }

  @override
  String coreStopId(String code) {
    return 'ID de parada: $code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return 'Rutas: $routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rutas: $routes, y $count más',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return 'Buscar en $region';
  }

  @override
  String get coreNow => 'AHORA';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get coreOneMinute => 'Un minuto';

  @override
  String get coreOneMinuteAgo => 'Hace un minuto';

  @override
  String coreMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '$minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get coreJustNow => 'Ahora mismo';

  @override
  String coreSecondsAgo(int seconds) {
    return 'hace $seconds s';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String coreHoursAgo(int hours) {
    return 'hace $hours h';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'hace $days días',
      one: 'hace $days día',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return 'Actualizado: $ago';
  }

  @override
  String get coreScheduledNotRealTime => 'Programado/no en tiempo real';

  @override
  String coreArrivedMinAgo(int minutes) {
    return 'Llegó hace $minutes min';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return 'Salió hace $minutes min';
  }

  @override
  String get coreArrivingNow => 'Llegando ahora';

  @override
  String get coreDepartingNow => 'Saliendo ahora';

  @override
  String coreArrivesInMin(int minutes) {
    return 'Llega en $minutes min';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return 'Sale en $minutes min';
  }

  @override
  String coreArrivedLate(int minutes) {
    return 'llegó $minutes min tarde';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return 'llegó $minutes min antes';
  }

  @override
  String get coreArrivedOnTime => 'llegó a tiempo';

  @override
  String coreDepartedLate(int minutes) {
    return 'salió $minutes min tarde';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return 'salió $minutes min antes';
  }

  @override
  String get coreDepartedOnTime => 'salió a tiempo';

  @override
  String coreArrivesLate(int minutes) {
    return 'llega $minutes min tarde';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return 'llega $minutes min antes';
  }

  @override
  String get coreArrivesOnTime => 'llega a tiempo';

  @override
  String coreDepartsLate(int minutes) {
    return 'sale $minutes min tarde';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return 'sale $minutes min antes';
  }

  @override
  String get coreDepartsOnTime => 'sale a tiempo';

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
      other: '$minutes minutos',
      one: '$minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsNow => 'ahora';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes min';
  }

  @override
  String get arrivalsCanceled => 'cancelado';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'cada $minutes min desde las $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'cada $minutes min hasta las $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'Hacia el norte';

  @override
  String get arrivalsDirectionBoundNE => 'Hacia el noreste';

  @override
  String get arrivalsDirectionBoundE => 'Hacia el este';

  @override
  String get arrivalsDirectionBoundSE => 'Hacia el sureste';

  @override
  String get arrivalsDirectionBoundS => 'Hacia el sur';

  @override
  String get arrivalsDirectionBoundSW => 'Hacia el suroeste';

  @override
  String get arrivalsDirectionBoundW => 'Hacia el oeste';

  @override
  String get arrivalsDirectionBoundNW => 'Hacia el noroeste';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'Hacia $code';
  }

  @override
  String get arrivalsRefresh => 'Actualizar llegadas';

  @override
  String get arrivalsRetry => 'Reintentar';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'No hay llegadas en los próximos $minutes minutos',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound =>
      'Parada no encontrada o servicio no disponible';

  @override
  String get arrivalsNetworkError =>
      'No se pudo conectar con el servidor de transporte. Revisa tu conexión.';

  @override
  String get arrivalsLoadError => 'No se pudieron cargar las llegadas.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'No se pudo actualizar. Se muestran los resultados de las $time';
  }

  @override
  String get arrivalsArrivingNow => 'llegando ahora';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'llega en $minutes minutos',
      one: 'llega en $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'en tiempo real';

  @override
  String get arrivalsRowTapHint => 'mostrar detalles';

  @override
  String arrivalsAtTime(String time) {
    return 'a las $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos de retraso',
      one: '$minutes minuto de retraso',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos antes de la hora',
      one: '$minutes minuto antes de la hora',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'cada $minutes minutos desde las $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'cada $minutes minutos hasta las $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'hora programada';

  @override
  String get arrivalsLoading => 'Cargando llegadas';

  @override
  String get arrivalsRefreshing => 'Actualizando llegadas';

  @override
  String get arrivalsUpdated => 'Llegadas actualizadas';

  @override
  String get tripPlannerOriginLabel => 'Desde';

  @override
  String get tripPlannerDestinationLabel => 'Hasta';

  @override
  String get tripPlannerChooseOrigin => 'Elegir punto de partida';

  @override
  String get tripPlannerChooseDestination => 'Elegir destino';

  @override
  String get tripPlannerCurrentLocation => 'Ubicación actual';

  @override
  String get tripPlannerSwapEndpoints =>
      'Intercambiar punto de partida y destino';

  @override
  String get tripPlannerPlanTrip => 'Planificar viaje';

  @override
  String get tripPlannerPlanningTrip => 'Planificando tu viaje';

  @override
  String get tripPlannerOptions => 'Opciones de viaje';

  @override
  String get tripPlannerLeaveNow => 'Salir ahora';

  @override
  String get tripPlannerDepartAt => 'Salir a las';

  @override
  String get tripPlannerArriveBy => 'Llegar antes de las';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Cambiar hora, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Transporte público';

  @override
  String get tripPlannerModeWalk => 'A pie';

  @override
  String get tripPlannerModeBike => 'Bicicleta';

  @override
  String get tripPlannerModeCar => 'Coche';

  @override
  String get tripPlannerModeBikeRental => 'Solo bici compartida';

  @override
  String get tripPlannerModeTransitBikeRental => 'Transporte + bici compartida';

  @override
  String get tripPlannerWheelchairAccessible => 'Accesible en silla de ruedas';

  @override
  String get tripPlannerWalkQuarterMile => '0,25 mi';

  @override
  String get tripPlannerWalkHalfMile => '0,5 mi';

  @override
  String get tripPlannerWalkOneMile => '1 mi';

  @override
  String get tripPlannerWalkTwoMiles => '2 mi';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'Caminar hasta $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'No se encontraron viajes';

  @override
  String get tripPlannerRetry => 'Reintentar';

  @override
  String get tripPlannerRealTime => 'Tiempo real';

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
      other: '$count transbordos',
      one: '$count transbordo',
      zero: 'Sin transbordos',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return '$distance a pie';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Sale a las $time de $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'A tiempo';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '$minutes min de retraso';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '$minutes min antes';
  }

  @override
  String get tripPlannerStatusScheduled => 'Programado';

  @override
  String get tripPlannerLegBus => 'Autobús';

  @override
  String get tripPlannerLegTram => 'Tranvía';

  @override
  String get tripPlannerLegSubway => 'Metro';

  @override
  String get tripPlannerLegRail => 'Tren';

  @override
  String get tripPlannerLegFerry => 'Transbordador';

  @override
  String get tripPlannerLegCableCar => 'Teleférico';

  @override
  String get tripPlannerLegGondola => 'Góndola';

  @override
  String get tripPlannerLegFunicular => 'Funicular';

  @override
  String get tripPlannerLegAirplane => 'Avión';

  @override
  String get tripPlannerLegTrolleybus => 'Trolebús';

  @override
  String get tripPlannerLegMonorail => 'Monorriel';

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
    return '$duration a pie';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return '$duration en bicicleta';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return '$duration en bicicleta de alquiler';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return '$duration en coche';
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
  String get tripPlannerThen => 'luego';

  @override
  String get tripPlannerOpenItineraryHint => 'mostrar detalles del viaje';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos',
      one: '$minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours horas',
      one: '$hours hora',
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
      other: '$value pies',
      one: '$value pie',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value millas',
      one: '$value milla',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value metros',
      one: '$value metro',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value kilómetros',
      one: '$value kilómetro',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return 'de $start a $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'en tiempo real, a tiempo';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'en tiempo real, $minutes minutos de retraso',
      one: 'en tiempo real, $minutes minuto de retraso',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'en tiempo real, $minutes minutos antes de la hora',
      one: 'en tiempo real, $minutes minuto antes de la hora',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'hora programada';

  @override
  String get tripPlannerResultsHeading => 'Viajes sugeridos';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viajes encontrados',
      one: '$count viaje encontrado',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lugares encontrados',
      one: '$count lugar encontrado',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'Mapa del viaje. Las indicaciones de abajo describen el mismo viaje.';

  @override
  String get tripPlannerTripDetails => 'Detalles del viaje';

  @override
  String get tripPlannerMapLabel => 'Mapa del viaje';

  @override
  String get tripPlannerStart => 'Inicio';

  @override
  String get tripPlannerDestination => 'Destino';

  @override
  String get tripPlannerUnnamedPlace => 'Ubicación sin nombre';

  @override
  String get tripPlannerRentalBike => 'Bicicleta de alquiler';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Camina hasta $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Ve en bicicleta hasta $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Ve en bicicleta de alquiler hasta $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Conduce hasta $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Viaja en $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Viaja en $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Viaja en $mode hacia $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Viaja en $mode $route hacia $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Bájate en $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Llegada a $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas',
      one: '$count parada',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count paradas',
      one: 'Mostrar $count parada',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ocultar $count paradas',
      one: 'Ocultar $count parada',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pasos',
      one: '$count paso',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count pasos',
      one: 'Mostrar $count paso',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ocultar $count pasos',
      one: 'Ocultar $count paso',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, unos $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Inicia el recorrido';

  @override
  String get tripPlannerDirectionHardLeft => 'Gira bruscamente a la izquierda';

  @override
  String get tripPlannerDirectionLeft => 'Gira a la izquierda';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'Mantente a la izquierda';

  @override
  String get tripPlannerDirectionContinue => 'Continúa';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Mantente a la derecha';

  @override
  String get tripPlannerDirectionRight => 'Gira a la derecha';

  @override
  String get tripPlannerDirectionHardRight => 'Gira bruscamente a la derecha';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Entra en la rotonda en sentido horario';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Entra en la rotonda en sentido antihorario';

  @override
  String get tripPlannerDirectionElevator => 'Toma el ascensor';

  @override
  String get tripPlannerDirectionUturnLeft =>
      'Haz un cambio de sentido hacia la izquierda';

  @override
  String get tripPlannerDirectionUturnRight =>
      'Haz un cambio de sentido hacia la derecha';

  @override
  String get tripPlannerDirectionEnterStation => 'Entra en la estación';

  @override
  String get tripPlannerDirectionExitStation => 'Sal de la estación';

  @override
  String get tripPlannerDirectionFollowSigns => 'Sigue las señales';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Camina por $street durante $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction en $street, camina $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Buscar un lugar';

  @override
  String get tripPlannerSearchNoResults => 'No se encontraron lugares';

  @override
  String get tripPlannerSearchError =>
      'No se pudo buscar lugares. Inténtalo de nuevo.';

  @override
  String get tripPlannerUseCurrentLocation => 'Usar ubicación actual';

  @override
  String get tripPlannerLocationUnavailable =>
      'No se pudo obtener tu ubicación.';

  @override
  String get tripPlannerClearSearch => 'Borrar búsqueda';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Selecciona el origen y el destino.';

  @override
  String get tripPlannerErrorNetwork =>
      'No se pudo conectar con el planificador de viajes. Revisa tu conexión.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'El servidor devolvió una respuesta no válida';

  @override
  String get tripPlannerErrorUnknown => 'Ocurrió un error desconocido.';

  @override
  String get tripPlannerPlannerSystemError =>
      'No pudimos planificar tu viaje en este momento. Inténtalo de nuevo.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'La planificación de viajes no está disponible temporalmente. Inténtalo de nuevo en breve.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'Esta ubicación aún no es compatible.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'No hay ninguna ruta disponible para este viaje.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'No hay opciones de transporte público disponibles en este momento.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'Esto tardó más de lo esperado. Inténtalo de nuevo.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'Algo salió mal con la solicitud. Inténtalo de nuevo.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'No pudimos encontrar el punto de partida.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'No pudimos encontrar el destino.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'No pudimos encontrar ni el punto de partida ni el destino.';

  @override
  String get tripPlannerPlannerTooClose =>
      'El punto de partida y el destino están demasiado cerca.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'Esta ruta no es accesible con la opción seleccionada.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'El punto de partida no está claro. Intenta ser más específico.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'El destino no está claro. Intenta ser más específico.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Ambas ubicaciones necesitan más detalle. Intenta precisarlas.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'Faltan algunas opciones de ruta.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'Las opciones de ruta seleccionadas no funcionan juntas.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Elige una preferencia de ruta.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Ajusta las preferencias de ruta.';
}
