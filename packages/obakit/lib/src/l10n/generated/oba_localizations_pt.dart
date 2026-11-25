// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class ObaLocalizationsPt extends ObaLocalizations {
  ObaLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonDone => 'OK';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonNotNow => 'Agora não';

  @override
  String get commonSeeAll => 'Ver tudo';

  @override
  String get commonLoading => 'Carregando';

  @override
  String get commonErrorTitle => 'Algo deu errado';

  @override
  String get commonEmptyTitle => 'Ainda não há nada aqui';

  @override
  String get commonComingSoon => 'Em breve';

  @override
  String get commonComingSoonBody => 'Esta tela ainda não está disponível.';

  @override
  String get commonOffline =>
      'Parece que você está offline. Verifique sua conexão e tente novamente.';

  @override
  String get commonServerError =>
      'O servidor não respondeu como esperado. Tente novamente em instantes.';

  @override
  String get sheetLabel => 'Painel';

  @override
  String get sheetExpand => 'Expandir painel';

  @override
  String get sheetCollapse => 'Recolher painel';

  @override
  String get sheetHandleHint =>
      'Arraste ou toque duas vezes para redimensionar o painel';

  @override
  String get homeTabHome => 'Início';

  @override
  String get homeTabRecent => 'Recentes';

  @override
  String get homeTabBookmarks => 'Favoritos';

  @override
  String get homeSearchPlaceholder => 'Buscar paradas, linhas, lugares';

  @override
  String get homeSearchLabel => 'Buscar';

  @override
  String get homeSectionNearby => 'Perto de você';

  @override
  String get homeSectionRecent => 'Paradas recentes';

  @override
  String get homeSectionBookmarks => 'Favoritos';

  @override
  String get homeSectionAlerts => 'Alertas';

  @override
  String get homeSectionExplore => 'Explorar';

  @override
  String get homeSectionMore => 'Ajustes e mais';

  @override
  String get mapLabel => 'Mapa';

  @override
  String get mapZoomInForStops => 'Aproxime o mapa para ver as paradas';

  @override
  String get mapLocationDenied =>
      'O acesso à localização está desativado. Toque para permitir.';

  @override
  String get mapLocationServicesOff =>
      'Os serviços de localização estão desativados';

  @override
  String get mapRecenter => 'Mostrar minha localização';

  @override
  String get mapSettingsButton => 'Configurações do mapa';

  @override
  String get mapStopsListButton => 'Paradas no mapa';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas no mapa',
      one: '$count parada no mapa',
      zero: 'Nenhuma parada no mapa',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'Sua localização';

  @override
  String get mapDroppedPin => 'Pino colocado';

  @override
  String get mapVehicle => 'Veículo';

  @override
  String get mapSelectedStop => 'Selecionada';

  @override
  String get mapBookmarkedStop => 'Nos favoritos';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, parada: $routeType';
  }

  @override
  String get mapStopMarkerHint => 'Abre as partidas da parada';

  @override
  String mapAttribution(String attribution) {
    return 'Dados do mapa: $attribution';
  }

  @override
  String get mapTypeTitle => 'Tipo de mapa';

  @override
  String get mapTypeStandard => 'Padrão';

  @override
  String get mapTypeSatellite => 'Satélite';

  @override
  String get mapTypeHybrid => 'Híbrido';

  @override
  String get mapShowScale => 'Mostrar escala';

  @override
  String get mapShowHeading => 'Mostrar direção';

  @override
  String get mapShowStopLabels => 'Mostrar rótulos das paradas';

  @override
  String mapPlaceAt(String lat, String lon) {
    return 'Local em $lat, $lon';
  }

  @override
  String get directionN => 'Sentido norte';

  @override
  String get directionNE => 'Sentido nordeste';

  @override
  String get directionE => 'Sentido leste';

  @override
  String get directionSE => 'Sentido sudeste';

  @override
  String get directionS => 'Sentido sul';

  @override
  String get directionSW => 'Sentido sudoeste';

  @override
  String get directionW => 'Sentido oeste';

  @override
  String get directionNW => 'Sentido noroeste';

  @override
  String get routeTypeBus => 'Ônibus';

  @override
  String get routeTypeLightRail => 'VLT';

  @override
  String get routeTypeSubway => 'Metrô';

  @override
  String get routeTypeRail => 'Trem';

  @override
  String get routeTypeFerry => 'Balsa';

  @override
  String get routeTypeCableCar => 'Bondinho';

  @override
  String get routeTypeGondola => 'Gôndola';

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
    return 'Linhas $routes';
  }

  @override
  String get stopPageRefresh => 'Atualizar';

  @override
  String get stopPageRefreshed => 'Partidas atualizadas';

  @override
  String get stopPageBookmark => 'Favoritar parada';

  @override
  String get stopPageBookmarked => 'Nos favoritos. Editar favorito';

  @override
  String get stopPageMoreActions => 'Mais ações da parada';

  @override
  String get stopPageSchedules => 'Horários';

  @override
  String get stopPageServiceAlerts => 'Alertas de serviço';

  @override
  String get stopPageNearbyStops => 'Paradas próximas';

  @override
  String get stopPageWalkingDirections => 'Itinerário a pé';

  @override
  String get stopPageBikeDirections => 'Itinerário de bicicleta';

  @override
  String get stopPagePlanTripFrom => 'Planejar uma viagem a partir daqui';

  @override
  String get stopPagePlanTripTo => 'Planejar uma viagem até aqui';

  @override
  String get stopPageShareStop => 'Compartilhar parada';

  @override
  String get stopPageReportProblem => 'Relatar um problema';

  @override
  String get stopPageFilterRoutes => 'Filtrar linhas';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas ocultas',
      one: '$count linha oculta',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'Por horário';

  @override
  String get stopPageModeRoute => 'Por linha';

  @override
  String get stopPageDepartureTypes => 'Tipos de partida';

  @override
  String get stopPageFilterAll => 'Todas as partidas';

  @override
  String get stopPageFilterRealtime => 'Somente em tempo real';

  @override
  String get stopPageFilterScheduled => 'Somente programadas';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count partidas anteriores',
      one: 'Mostrar $count partida anterior',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Ocultar partidas anteriores';

  @override
  String get stopPageLoadMore => 'Carregar mais partidas';

  @override
  String stopPageWindow(int minutes) {
    return 'Mostrando os próximos $minutes minutos';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Atualizado $ago';
  }

  @override
  String get stopPageStaleTitle => 'Não foi possível atualizar as partidas';

  @override
  String get stopPageStaleBody => 'Estes horários podem estar desatualizados.';

  @override
  String get stopPageEmptyTitle => 'Nenhuma partida futura';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'Nada parte nos próximos $minutes minutos.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Todas as linhas com partidas aqui estão ocultas.';

  @override
  String get stopPageShowAllRoutes => 'Mostrar todas as linhas';

  @override
  String get stopPageEmptyFilter =>
      'Nenhuma partida corresponde ao filtro de tipo de partida.';

  @override
  String get stopPageShowAllTypes => 'Mostrar todas as partidas';

  @override
  String get stopPageMissingTitle => 'Parada não encontrada';

  @override
  String get stopPageMissingBody =>
      'Esta parada pode ter sido removida ou renumerada.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes min a pé';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes min de bicicleta';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos a pé',
      one: '$minutes minuto a pé',
    );
    return '$_temp0, $distance. Abre o itinerário.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos de bicicleta',
      one: '$minutes minuto de bicicleta',
    );
    return '$_temp0, $distance. Abre o itinerário.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '$minutes min a pé até esta parada. As partidas acima saem antes.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '$minutes min de bicicleta até esta parada. As partidas acima saem antes.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Serviço de $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertas de serviço',
      one: '$count alerta de serviço',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count não lidos',
      one: '$count não lido',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Não lido';

  @override
  String get stopPageAlertImportant => 'Importante';

  @override
  String get stopPageDirectionsChooser => 'Abrir itinerário em';

  @override
  String get stopPageAppleMaps => 'Apple Maps';

  @override
  String get stopPageGoogleMaps => 'Google Maps';

  @override
  String get stopPageCannotOpen => 'Não foi possível abrir esse link.';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Conexão a partir da linha $route $headsign, chegada às $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Partidas';

  @override
  String get stopRowNow => 'AGORA';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return 'há $minutes min';
  }

  @override
  String get stopRowOnTime => 'no horário';

  @override
  String stopRowLate(int minutes) {
    return '$minutes min de atraso';
  }

  @override
  String stopRowEarly(int minutes) {
    return '$minutes min adiantado';
  }

  @override
  String get stopRowScheduled => 'programado';

  @override
  String get stopRowCanceled => 'cancelado';

  @override
  String get stopRowOccupancyEmpty => 'Vazio';

  @override
  String get stopRowOccupancyManySeats => 'Muitos assentos disponíveis';

  @override
  String get stopRowOccupancyFewSeats => 'Poucos assentos disponíveis';

  @override
  String get stopRowOccupancyStanding => 'Somente em pé';

  @override
  String get stopRowOccupancyCrushed => 'Muito lotado';

  @override
  String get stopRowOccupancyFull => 'Cheio';

  @override
  String get stopRowOccupancyNotAccepting => 'Não está aceitando passageiros';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'chega em $minutes minutos',
      one: 'chega em $minutes minuto',
      zero: 'chegando agora',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'parte em $minutes minutos',
      one: 'parte em $minutes minuto',
      zero: 'partindo agora',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'chegou há $minutes minutos',
      one: 'chegou há $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'partiu há $minutes minutos',
      one: 'partiu há $minutes minuto',
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
    return 'Linha $route para $headsign, $eta, às $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'acompanhamento ao vivo, $status';
  }

  @override
  String get stopRowA11yScheduledOnly =>
      'apenas horário programado, sem dados em tempo real';

  @override
  String get stopRowA11yTransfer => 'sua viagem de conexão';

  @override
  String get stopRowA11yMissed =>
      'provavelmente você vai perder, sai antes que você consiga chegar a pé';

  @override
  String get stopRowA11yAlarm => 'lembrete criado';

  @override
  String stopRowActions(String route) {
    return 'Mais ações para a linha $route';
  }

  @override
  String get stopRowShowTrip => 'Ver detalhes da viagem';

  @override
  String get stopRowAddAlarm => 'Adicionar lembrete';

  @override
  String get stopRowRemoveAlarm => 'Remover lembrete';

  @override
  String get stopRowBookmarkTrip => 'Favoritar esta viagem';

  @override
  String get stopRowShareTrip => 'Compartilhar viagem';

  @override
  String get stopRowRouteSchedule => 'Horário da linha';

  @override
  String get stopRowRouteStops => 'Paradas desta linha';

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
      other: '$count partidas',
      one: '$count partida',
    );
    return 'Linha $route para $headsigns, $_temp0, próxima $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Lembrar-me antes da partida';

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
      other: 'Lembrete definido para $minutes minutos antes',
      one: 'Lembrete definido para $minutes minuto antes',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Lembrete removido';

  @override
  String get stopAlarmFailed => 'Não foi possível atualizar o lembrete.';

  @override
  String get stopAlarmPermissionDenied =>
      'As notificações estão desativadas para este app.';

  @override
  String get stopFilterTitle => 'Filtrar linhas';

  @override
  String get stopFilterSort => 'Ordenar partidas';

  @override
  String get stopFilterRoutesHeader => 'Linhas exibidas nesta parada';

  @override
  String get stopFilterShowAll => 'Mostrar todas as linhas';

  @override
  String get stopTripArrivingAtYourStop => 'Chegando à sua parada';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'A $count paradas',
      one: 'A $count parada',
      zero: 'Na sua parada',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return 'A $distance';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'Em $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Posição atualizada $ago';
  }

  @override
  String get stopTripNoPosition =>
      'Sem posição em tempo real para este veículo';

  @override
  String stopTripStartsAs(String trip) {
    return 'Começa como $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Continua como $trip';
  }

  @override
  String get stopTripStopsHeader => 'Paradas';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas passadas',
      one: '$count parada passada',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas antes da sua parada',
      one: '$count parada antes da sua parada',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'Sua parada';

  @override
  String get stopTripBoarding => 'Embarcando';

  @override
  String get stopTripVehicleHere => 'O veículo está aqui';

  @override
  String get stopTripTerminal => 'Última parada';

  @override
  String get stopTripPassed => 'Passada';

  @override
  String get stopTripRouteStops => 'Todas as paradas desta linha';

  @override
  String get stopTripReport => 'Relatar um problema com esta viagem';

  @override
  String get stopTripGhostBus => 'Relatar ônibus fantasma';

  @override
  String get stopTripCanceled => 'Esta viagem foi cancelada';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Veículo da linha $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'A cada $minutes min';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Linha $route';
  }

  @override
  String get stopRouteStopsDirection => 'Sentido';

  @override
  String stopRouteStopsToward(String name) {
    return 'Para $name';
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
  String get stopRouteStopsEmpty =>
      'Nenhuma parada encontrada para esta linha.';

  @override
  String get stopSchedPrevDay => 'Dia anterior';

  @override
  String get stopSchedNextDay => 'Dia seguinte';

  @override
  String stopSchedPickDate(String date) {
    return 'Escolher data, $date';
  }

  @override
  String get stopSchedRoute => 'Linha';

  @override
  String get stopSchedDirection => 'Sentido';

  @override
  String get stopSchedStop => 'Parada';

  @override
  String get stopSchedEmpty => 'Não há serviço programado neste dia.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'A cada $minutes min, de $start a $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'Para $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count partidas',
      one: '$count partida',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour: $times';
  }

  @override
  String get stopSchedNotSupported =>
      'Os horários não estão disponíveis nesta região.';

  @override
  String get stopSchedViewList => 'Lista';

  @override
  String get stopSchedViewGrid => 'Grade';

  @override
  String get stopSchedNoDeparture => 'Sem partida';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (sua parada)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, viagem $trip: $time';
  }

  @override
  String get stopReportProblemHeader => 'Qual parece ser o problema?';

  @override
  String get stopReportStopNameWrong => 'O nome da parada está errado';

  @override
  String get stopReportStopNumberWrong => 'O número da parada está errado';

  @override
  String get stopReportStopLocationWrong => 'A parada está no lugar errado';

  @override
  String get stopReportRouteMissing => 'Falta uma linha ou viagem';

  @override
  String get stopReportOther => 'Outro motivo';

  @override
  String get stopReportNeverCame => 'O veículo nunca chegou';

  @override
  String get stopReportCameEarly => 'Chegou adiantado';

  @override
  String get stopReportCameLate => 'Chegou atrasado';

  @override
  String get stopReportWrongHeadsign => 'O destino indicado estava errado';

  @override
  String get stopReportNotStopHere => 'Não parou aqui';

  @override
  String get stopReportComment => 'Comentários adicionais (opcional)';

  @override
  String get stopReportShareLocation => 'Compartilhar minha localização';

  @override
  String get stopReportShareLocationHelp =>
      'Compartilhar sua localização pode ajudar sua agência de transporte a corrigir este problema.';

  @override
  String get stopReportOnVehicle => 'Estou neste veículo';

  @override
  String get stopReportVehicleId => 'Número do veículo (opcional)';

  @override
  String get stopReportSend => 'Enviar relato';

  @override
  String get stopReportSending => 'Enviando relato';

  @override
  String get stopReportSent => 'Obrigado! Seu relato foi enviado.';

  @override
  String get stopReportFailed =>
      'Não foi possível enviar o relato. Tente novamente.';

  @override
  String get stopReportChooseProblem => 'Escolha um problema primeiro.';

  @override
  String stopReportAbout(String name) {
    return 'Relatando: $name';
  }

  @override
  String get stopGhostTitle => 'Relatar ônibus fantasma';

  @override
  String get stopGhostExplain =>
      'Um ônibus fantasma é aquele que o app mostrou, mas que nunca chegou.';

  @override
  String get stopGhostWait =>
      'Quanto tempo você esperou após o horário programado?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get stopGhostWaitThirtyPlus => 'Mais de 30 min';

  @override
  String get stopCardEmpty => 'Nenhuma partida em breve';

  @override
  String get titleSearch => 'Buscar';

  @override
  String get titleSearchResults => 'Resultados';

  @override
  String get titleNearbyStops => 'Paradas próximas';

  @override
  String get titleRecentStops => 'Paradas recentes';

  @override
  String get titleBookmarks => 'Favoritos';

  @override
  String get titleStop => 'Parada';

  @override
  String get titleTrip => 'Viagem';

  @override
  String get titleRouteStops => 'Linha';

  @override
  String get titleStopSchedule => 'Horário';

  @override
  String get titleRouteSchedule => 'Horário da linha';

  @override
  String get titleAlerts => 'Alertas';

  @override
  String get titleAlertDetail => 'Alerta';

  @override
  String get titleAgencies => 'Agências';

  @override
  String get titleRegionPicker => 'Regiões';

  @override
  String get titleCustomRegion => 'Região personalizada';

  @override
  String get titleSettings => 'Ajustes';

  @override
  String get titleMapSettings => 'Configurações do mapa';

  @override
  String get titleMore => 'Mais';

  @override
  String get titleTripPlanner => 'Planejar uma viagem';

  @override
  String get titlePlace => 'Lugar';

  @override
  String get titleReportStopProblem => 'Relatar um problema';

  @override
  String get titleReportTripProblem => 'Relatar um problema';

  @override
  String get titleBookmarkEditor => 'Favorito';

  @override
  String get titleManageBookmarks => 'Editar favoritos';

  @override
  String get titleCredits => 'Créditos';

  @override
  String get titleWeather => 'Clima';

  @override
  String get titleStopsOnMap => 'Paradas no mapa';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Bem-vindo ao $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Chegadas em tempo real de ônibus, trens e balsas perto de você.';

  @override
  String get onboardingLocationTitle => 'Encontre paradas perto de você';

  @override
  String get onboardingLocationBody =>
      'Permita o acesso à localização para ver as paradas próximas e escolher sua região automaticamente.';

  @override
  String get onboardingAllowLocation => 'Permitir acesso à localização';

  @override
  String get onboardingRegionTitle => 'Escolha sua região';

  @override
  String get onboardingRegionBody =>
      'Escolha a área cujo transporte você quer ver.';

  @override
  String get settingsSectionMap => 'Mapa';

  @override
  String get settingsMapTypeRow => 'Tipo de mapa e camadas';

  @override
  String get settingsMapTypeHelp => 'Escolha a aparência do mapa.';

  @override
  String get settingsHeadingHelp =>
      'Mostra no mapa a direção para a qual você está voltado.';

  @override
  String get settingsStopLabelsHelp =>
      'Mostra os nomes das linhas ao lado das paradas no mapa.';

  @override
  String get settingsWalkingDirections => 'Itinerário a pé';

  @override
  String get settingsWalkingDirectionsHelp =>
      'O app que abre quando você pede o itinerário a pé até uma parada.';

  @override
  String get settingsDirectionsAsk => 'Perguntar sempre';

  @override
  String get settingsDirectionsAppleMaps => 'Apple Maps';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Maps';

  @override
  String get settingsSectionDepartures => 'Partidas';

  @override
  String get settingsDepartureFilter => 'Mostrar partidas';

  @override
  String get settingsDepartureFilterHelp =>
      'Escolha se as páginas de parada listam todas as partidas ou somente as que têm dados em tempo real ou programados.';

  @override
  String get settingsFilterAll => 'Todas as partidas';

  @override
  String get settingsFilterRealtime => 'Somente em tempo real';

  @override
  String get settingsFilterScheduled => 'Somente programadas';

  @override
  String get settingsRegionTimeZone =>
      'Mostrar horários no fuso horário da região';

  @override
  String get settingsRegionTimeZoneHelp =>
      'Os horários usam o fuso horário da região de transporte, com um aviso quando for diferente do seu dispositivo.';

  @override
  String get settingsSectionAccessibility => 'Acessibilidade';

  @override
  String get settingsReducedColors => 'Reduzir cores nas páginas de parada';

  @override
  String get settingsReducedColorsHelp =>
      'Mostra os emblemas das linhas em um único estilo neutro.';

  @override
  String get settingsCompactMode => 'Páginas de parada e viagem compactas';

  @override
  String get settingsCompactModeHelp =>
      'Reduz o espaçamento para caber mais na tela.';

  @override
  String get settingsSectionWalking => 'Velocidade de caminhada';

  @override
  String get settingsWalkingSpeed => 'Velocidade de caminhada';

  @override
  String get settingsWalkingSpeedHelp =>
      'Usada para estimar o tempo a pé e os horários de chegada.';

  @override
  String get settingsSpeedSlow => 'Lenta';

  @override
  String get settingsSpeedAverage => 'Média';

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
      'Usa uma velocidade de deslocamento maior nas estimativas de tempo a pé, nos horários de chegada e na página de parada.';

  @override
  String get settingsSectionSurveys => 'Pesquisas';

  @override
  String get settingsSurveysEnabled => 'Mostrar pesquisas';

  @override
  String get settingsSurveysAlways => 'Sempre mostrar pesquisas nas paradas';

  @override
  String get settingsSectionPrivacy => 'Privacidade';

  @override
  String get settingsAnalytics => 'Enviar dados de uso aos desenvolvedores';

  @override
  String get settingsAnalyticsHelp =>
      'Ajuda os desenvolvedores a saber quais recursos são usados.';

  @override
  String get settingsSectionDebug => 'Depuração';

  @override
  String get settingsDebugMode => 'Modo de depuração';

  @override
  String get settingsDebugAlwaysFeedback =>
      'Sempre mostrar a solicitação de feedback';

  @override
  String get settingsDebugResetFeedback =>
      'Redefinir o estado da solicitação de feedback';

  @override
  String get settingsDebugResetDonation =>
      'Redefinir o estado do cartão de doação';

  @override
  String get settingsDebugResetDone => 'Redefinido';

  @override
  String get settingsSectionTripPlanner => 'Planejador de viagens';

  @override
  String get settingsHomeCustomizeMap => 'Personalizar mapa';

  @override
  String get moreHeaderSupport => 'Este app é feito e mantido por voluntários.';

  @override
  String get moreSectionDonate => 'Seja um apoiador';

  @override
  String moreDonate(String appName) {
    return 'Doar para o $appName';
  }

  @override
  String get moreManageDonations => 'Gerenciar doações';

  @override
  String get moreSectionUpdates => 'Novidades e alertas';

  @override
  String get moreAlerts => 'Alertas';

  @override
  String get moreSectionLocation => 'Minha localização';

  @override
  String get moreRegion => 'Região';

  @override
  String get moreRegionNone => 'Não selecionada';

  @override
  String get morePayFare => 'Pagar minha passagem';

  @override
  String get moreAgencies => 'Agências';

  @override
  String get moreSectionAbout => 'Sobre este app';

  @override
  String moreRateApp(String appName) {
    return 'Avaliar o $appName';
  }

  @override
  String get moreContactUs => 'Fale conosco';

  @override
  String get morePrivacy => 'Política de privacidade';

  @override
  String get moreCredits => 'Créditos';

  @override
  String moreVersion(String appName, String version) {
    return '$appName versão $version';
  }

  @override
  String get moreSectionHelpOut => 'Ajude a melhorar o app';

  @override
  String get moreTranslate => 'Ajude a traduzir o app';

  @override
  String get moreDevelop => 'Ajude a corrigir bugs e criar novos recursos';

  @override
  String get moreSectionContact => 'Contato e ajuda';

  @override
  String get moreTutorials => 'Tutoriais';

  @override
  String get moreCallAgency => 'Ligar para a agência';

  @override
  String get moreTextAgency => 'Enviar mensagem à agência';

  @override
  String get moreSectionResources => 'Links úteis';

  @override
  String get moreContactTitle => 'Fale conosco';

  @override
  String get moreContactDevelopers => 'Sugestão de recurso ou relato de bug';

  @override
  String get moreContactAgency => 'Problema com veículo ou horário';

  @override
  String moreEmailSubject(String appName) {
    return 'Feedback sobre o $appName';
  }

  @override
  String get moreEmailAgencySubject => 'Feedback de um passageiro';

  @override
  String get moreEmailIntro =>
      'Como podemos ajudar? Digite sua resposta abaixo:';

  @override
  String get moreEmailDebugIntro =>
      'As informações a seguir são fornecidas para fins de solução de problemas. Se você não se sentir à vontade para compartilhar alguma delas, pode removê-la, mas isso pode afetar nossa capacidade de ajudar.';

  @override
  String get moreDebugAppVersion => 'Versão do app';

  @override
  String get moreDebugOs => 'Sistema operacional';

  @override
  String get moreDebugLocale => 'Idioma';

  @override
  String get moreDebugBookmarks => 'Quantidade de favoritos';

  @override
  String get moreDebugLocationPermission => 'Permissão de localização';

  @override
  String get moreDebugRegion => 'Região';

  @override
  String get moreDebugRegionId => 'ID da região';

  @override
  String get moreDebugApiUrl => 'URL base da API';

  @override
  String get moreDebugUserId => 'ID de usuário';

  @override
  String get moreCantEmailTitle => 'Não foi possível abrir seu app de e-mail';

  @override
  String moreCantEmailBody(String email) {
    return 'Para falar conosco, envie um e-mail para $email. Copie as informações de depuração e cole na mensagem para nos ajudar a resolver o problema.';
  }

  @override
  String get moreCopyEmail => 'Copiar endereço de e-mail';

  @override
  String get moreCopyDebug => 'Copiar informações de depuração';

  @override
  String get moreCopied => 'Copiado para a área de transferência';

  @override
  String get moreFareContinue => 'Continuar';

  @override
  String get moreFareDontShowAgain => 'Continuar e não mostrar novamente';

  @override
  String get moreCantOpenLink => 'Não foi possível abrir esse link.';

  @override
  String get regionPickerAutomatic => 'Escolher a região automaticamente';

  @override
  String get regionPickerAutomaticHelp =>
      'Muda para a região que contém sua localização. Se você escolher uma região manualmente, isso é desativado.';

  @override
  String get regionPickerShowExperimental => 'Mostrar regiões experimentais';

  @override
  String get regionPickerShowInactive => 'Mostrar regiões inativas';

  @override
  String get regionPickerRegionsSection => 'Regiões';

  @override
  String get regionPickerCustomSection => 'Regiões personalizadas';

  @override
  String get regionPickerCurrent => 'Região atual';

  @override
  String get regionPickerExperimentalTag => 'Experimental';

  @override
  String get regionPickerInactiveTag => 'Inativa';

  @override
  String get regionPickerCustomTag => 'Personalizada';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Adicionar região personalizada';

  @override
  String get regionPickerRefresh => 'Atualizar regiões';

  @override
  String get regionPickerRefreshed => 'Regiões atualizadas';

  @override
  String get regionPickerRefreshFailed =>
      'Não foi possível atualizar a lista de regiões. Mostrando a lista salva.';

  @override
  String regionPickerSelected(String name) {
    return '$name selecionada';
  }

  @override
  String regionPickerEdit(String name) {
    return 'Editar $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'Apagar $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'Apagar $name?';
  }

  @override
  String get regionPickerDeleteBody =>
      'Esta região personalizada será removida deste dispositivo.';

  @override
  String get regionPickerDeleteConfirm => 'Apagar';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Escolha outra região antes de apagar esta.';

  @override
  String get regionPickerEmpty => 'Nenhuma região disponível';

  @override
  String get regionPickerEmptyBody =>
      'Ative as regiões experimentais ou inativas, ou adicione uma região personalizada.';

  @override
  String get regionPickerTripPlanner => 'Planejador de viagens nesta região';

  @override
  String get customRegionEditTitle => 'Editar região personalizada';

  @override
  String get customRegionName => 'Nome';

  @override
  String get customRegionObaUrl => 'URL do servidor OneBusAway';

  @override
  String get customRegionObaUrlHelp =>
      'O endereço do servidor, por exemplo https://oba.example.com/';

  @override
  String get customRegionSidecar => 'URL do servidor Sidecar (opcional)';

  @override
  String get customRegionOtp => 'URL do planejador de viagens (opcional)';

  @override
  String get customRegionOtpGraphql =>
      'URL GraphQL do planejador de viagens (opcional)';

  @override
  String get customRegionServiceArea => 'Área de serviço';

  @override
  String get customRegionServiceAreaHelp =>
      'A área que esta região cobre: um ponto central e até onde ela se estende.';

  @override
  String get customRegionLatitude => 'Latitude do centro';

  @override
  String get customRegionLongitude => 'Longitude do centro';

  @override
  String get customRegionLatSpan => 'Extensão de latitude (graus)';

  @override
  String get customRegionLonSpan => 'Extensão de longitude (graus)';

  @override
  String get customRegionUseMap => 'Usar a área atual do mapa';

  @override
  String get customRegionSave => 'Salvar';

  @override
  String get customRegionErrorRequired => 'Este campo é obrigatório';

  @override
  String get customRegionErrorUrl =>
      'Digite um endereço da web que comece com http:// ou https://';

  @override
  String get customRegionErrorNumber => 'Digite um número';

  @override
  String get customRegionErrorRange => 'Este número está fora do intervalo';

  @override
  String get customRegionChecking => 'Verificando o servidor';

  @override
  String get customRegionServerOk => 'O servidor respondeu';

  @override
  String get customRegionServerUnreachable =>
      'Não foi possível conectar a este servidor';

  @override
  String get customRegionServerNotOba =>
      'Este servidor não respondeu como o OneBusAway';

  @override
  String customRegionSaved(String name) {
    return '$name salva';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'O OneBusAway é um software de transporte público gratuito e de código aberto, criado por voluntários e apoiado pela Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'Licença';

  @override
  String get creditsMapData => 'Dados do mapa';

  @override
  String get creditsLicenses => 'Licenças de código aberto';

  @override
  String get creditsLicensesHelp =>
      'As bibliotecas com as quais este app foi criado.';

  @override
  String get creditsLicensesLoading => 'Carregando licenças';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count licenças',
      one: '$count licença',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Disponível em dezenas de regiões de transporte em todo o mundo.';

  @override
  String get onboardingBenefitNearbyTitle => 'Ver paradas próximas';

  @override
  String get onboardingBenefitNearbyBody =>
      'Ônibus e trens perto de você, ordenados por distância.';

  @override
  String get onboardingBenefitMapTitle => 'Centralizar o mapa em você';

  @override
  String get onboardingBenefitMapBody =>
      'Abra direto no seu entorno, sem precisar buscar.';

  @override
  String onboardingLocationFootnote(String appName) {
    return 'O $appName só usa sua localização enquanto o app está aberto. Você pode mudar isso a qualquer momento nos ajustes do dispositivo.';
  }

  @override
  String get onboardingLocationDenied =>
      'O acesso à localização está desativado. Você ainda pode escolher sua região manualmente.';

  @override
  String get onboardingRegionDetected => 'Detectada perto de você';

  @override
  String onboardingRegionUse(String name) {
    return 'Usar $name';
  }

  @override
  String get onboardingRegionOthers => 'Ou escolha outra região';

  @override
  String get onboardingRegionEmpty =>
      'Nenhuma região disponível no momento. Verifique sua conexão e tente novamente.';

  @override
  String get surveyCardTitle => 'Ajude a melhorar o transporte';

  @override
  String get surveyDefaultPrompt =>
      'Responda a uma breve pesquisa para ajudar a melhorar o transporte.';

  @override
  String get surveyTake => 'Responder pesquisa';

  @override
  String get surveyNotNow => 'Agora não';

  @override
  String get surveyDismiss => 'Dispensar pesquisa';

  @override
  String get surveyNext => 'Avançar';

  @override
  String get surveySubmit => 'Enviar pesquisa';

  @override
  String get surveySubmitting => 'Enviando';

  @override
  String get surveyQuestionsTitle => 'Pesquisa';

  @override
  String get surveyTextHint => 'Digite sua resposta';

  @override
  String get surveyRequired => 'Obrigatório';

  @override
  String get surveyIncomplete =>
      'Responda todas as perguntas obrigatórias antes de enviar.';

  @override
  String get surveyFailed =>
      'Não foi possível enviar suas respostas. Tente novamente.';

  @override
  String get surveyThanks => 'Obrigado pelo seu feedback.';

  @override
  String get surveyOpenSurvey => 'Abrir pesquisa';

  @override
  String get surveyLearnMore => 'Saiba mais';

  @override
  String get surveyShareFeedback => 'Compartilhar feedback';

  @override
  String get surveySignUp => 'Cadastrar-se';

  @override
  String get surveyExternalError =>
      'Não foi possível abrir o link desta pesquisa. Tente novamente mais tarde.';

  @override
  String donationTitle(String appName) {
    return 'O $appName precisa da sua ajuda';
  }

  @override
  String get donationBody =>
      'Este app é criado com trabalho voluntário e precisamos da sua ajuda para financiar o desenvolvimento futuro.';

  @override
  String get donationLearnMore => 'Saiba mais';

  @override
  String get donationDonate => 'Doar agora';

  @override
  String get donationRemindLater => 'Lembrar mais tarde';

  @override
  String get donationDismiss => 'Não, obrigado';

  @override
  String get donationHeader => 'Veja por que precisamos da sua ajuda';

  @override
  String donationExplanation(String appName) {
    return 'Temos grandes planos para melhorar o $appName, mas não conseguimos fazer isso sem a sua ajuda. Este app é criado com trabalho voluntário e precisamos da sua ajuda para financiar o desenvolvimento futuro.\n\nComo projeto fundamental da Open Transit Software Foundation, uma organização sem fins lucrativos, sua doação é dedutível de impostos nos Estados Unidos.';
  }

  @override
  String get donationDonateWebsite => 'Doar no nosso site';

  @override
  String titleDonation(String appName) {
    return 'Apoie o $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'Está gostando do $appName?';
  }

  @override
  String get feedbackYes => 'Sim!';

  @override
  String get feedbackNo => 'Nem tanto';

  @override
  String get feedbackLater => 'Perguntar mais tarde';

  @override
  String get feedbackNegativeTitle => 'Sentimos muito.';

  @override
  String get feedbackNegativeBody =>
      'Pode nos contar o que está errado? Lemos todas as mensagens.';

  @override
  String get feedbackSend => 'Enviar feedback';

  @override
  String get feedbackDecline => 'Não, obrigado';

  @override
  String get tripPlanningUnavailable =>
      'O planejamento de viagens não está disponível nesta região.';

  @override
  String get deepLinkOtherRegion =>
      'Este link é de outra região. Mude de região para abri-lo.';

  @override
  String get dataUpdated => 'Atualizado';

  @override
  String get bookmarksEtaNow => 'Agora';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'em $minutes minutos',
      one: 'em $minutes minuto',
      zero: 'agora',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => 'No horário';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min de atraso',
      one: '$minutes min de atraso',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min adiantado',
      one: '$minutes min adiantado',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => 'Programado';

  @override
  String get bookmarksStatusCanceled => 'Cancelado';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Linha $route para $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Linha $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Carregando partidas';

  @override
  String get bookmarksNoDepartures => 'Nenhuma partida futura';

  @override
  String get bookmarksDeparturesError =>
      'Não foi possível carregar as partidas';

  @override
  String get bookmarksDeparturesStale =>
      'Não foi possível atualizar. Mostrando horários anteriores.';

  @override
  String get bookmarksUpdated => 'Partidas atualizadas';

  @override
  String get bookmarksSortTooltip => 'Ordenar favoritos';

  @override
  String get bookmarksSortByGroup => 'Ordenar por grupo';

  @override
  String get bookmarksSortByDistance => 'Ordenar por distância';

  @override
  String get bookmarksManageTooltip => 'Editar favoritos e grupos';

  @override
  String get bookmarksRefreshTooltip => 'Atualizar partidas';

  @override
  String get bookmarksEmptyTitle => 'Ainda não há favoritos';

  @override
  String get bookmarksEmptyBody =>
      'Abra uma parada e toque no botão de favorito para salvá-la aqui. A partir de uma partida, você também pode favoritar só aquela linha na parada.';

  @override
  String get bookmarksFindStops => 'Encontrar paradas no mapa';

  @override
  String get bookmarksUngrouped => 'Sem grupo';

  @override
  String get bookmarksGroupExpanded => 'expandido';

  @override
  String get bookmarksGroupCollapsed => 'recolhido';

  @override
  String get bookmarksGroupToggleHint =>
      'Mostra ou oculta os favoritos deste grupo';

  @override
  String bookmarksActionsFor(String name) {
    return 'Ações para $name';
  }

  @override
  String get bookmarksActionEdit => 'Editar';

  @override
  String get bookmarksActionPin => 'Fixar no topo';

  @override
  String get bookmarksActionUnpin => 'Desafixar';

  @override
  String get bookmarksActionMove => 'Mover para um grupo';

  @override
  String get bookmarksActionDelete => 'Apagar';

  @override
  String get bookmarksPinned => 'Fixado';

  @override
  String bookmarksDeleted(String name) {
    return '$name apagado';
  }

  @override
  String get bookmarksUndo => 'Desfazer';

  @override
  String get bookmarksMoveTitle => 'Mover para um grupo';

  @override
  String get bookmarksNoGroup => 'Sem grupo';

  @override
  String bookmarksMoved(String group) {
    return 'Movido para $group';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name, $details';
  }

  @override
  String get bookmarksEditorNameLabel => 'Nome do favorito';

  @override
  String get bookmarksEditorNameRequired =>
      'Digite um nome para este favorito.';

  @override
  String get bookmarksEditorDuplicate =>
      'Você já tem um favorito com este nome para esta parada e linha. Mude o nome para salvar outro.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Favorito de parada: mostra as próximas partidas de todas as linhas em $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Favorito de viagem: mostra as próximas partidas da linha $route em $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'Somente $route';
  }

  @override
  String get bookmarksEditorGroup => 'Grupo';

  @override
  String get bookmarksEditorNewGroup => 'Novo grupo…';

  @override
  String get bookmarksEditorNewGroupTitle => 'Novo grupo';

  @override
  String get bookmarksEditorGroupName => 'Nome do grupo';

  @override
  String get bookmarksEditorSave => 'Salvar';

  @override
  String get bookmarksEditorSaved => 'Favorito salvo';

  @override
  String get bookmarksEditorDelete => 'Apagar favorito';

  @override
  String get bookmarksEditorDeleteTitle => 'Apagar este favorito?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '“$name” será removido dos seus favoritos.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Escolha uma região antes de adicionar favoritos.';

  @override
  String get bookmarksManageGroupsHeader => 'Grupos';

  @override
  String get bookmarksManageBookmarksHeader => 'Favoritos';

  @override
  String get bookmarksManageAddGroup => 'Adicionar grupo';

  @override
  String get bookmarksManageRenameGroup => 'Renomear grupo';

  @override
  String get bookmarksManageDeleteGroup => 'Apagar grupo';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'Os favoritos de “$name” ficarão sem grupo.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Mover $name para cima';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Mover $name para baixo';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Reordenar $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, posição $position de $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'Ainda não há favoritos nem grupos para gerenciar.';

  @override
  String get bookmarksManageUngrouped => 'Favoritos sem grupo';

  @override
  String get recentsEmptyTitle => 'Nenhuma parada recente';

  @override
  String get recentsEmptyBody =>
      'As paradas que você consultar aparecem aqui, as mais recentes primeiro.';

  @override
  String get recentsFindStops => 'Encontrar paradas no mapa';

  @override
  String get recentsClearAll => 'Limpar tudo';

  @override
  String get recentsClearTitle => 'Limpar paradas recentes?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Isso remove todas as $count paradas recentes. Seus favoritos não são afetados.',
      one:
          'Isso remove $count parada recente. Seus favoritos não são afetados.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Remover $name das paradas recentes';
  }

  @override
  String recentsRemoved(String name) {
    return '$name removida';
  }

  @override
  String get recentsSectionEmpty =>
      'As paradas que você consultar aparecem aqui.';

  @override
  String get alarmsSectionTitle => 'Lembretes';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos antes da partida',
      one: '$minutes minuto antes da partida',
    );
    return '$_temp0, às $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Lembrete para $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'Apagar lembrete para $title';
  }

  @override
  String get alarmsDeleted => 'Lembrete apagado';

  @override
  String get alarmsDeleteFailed =>
      'Não foi possível apagar o lembrete. Verifique sua conexão e tente novamente.';

  @override
  String get alarmsOpen => 'Abre a viagem';

  @override
  String get alertsEmptyTitle => 'Nenhum alerta de serviço';

  @override
  String get alertsEmptyBody => 'Não há alertas de serviço ativos no momento.';

  @override
  String get alertsRegionNote =>
      'Inclui alertas das suas paradas favoritas, recentes e próximas.';

  @override
  String get alertsMarkAllRead => 'Marcar tudo como lido';

  @override
  String get alertsAllRead => 'Todos os alertas marcados como lidos';

  @override
  String get alertsUnread => 'Não lido';

  @override
  String get alertsSeverityInfo => 'Informação';

  @override
  String get alertsSeverityWarning => 'Aviso';

  @override
  String get alertsSeveritySevere => 'Grave';

  @override
  String get alertsSeverityUnknown => 'Alerta de serviço';

  @override
  String get alertsNoTitle => 'Alerta de serviço';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Não lido. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertas não lidos',
      one: '$count alerta não lido',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mais $count alertas',
      one: 'mais $count alerta',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Período ativo';

  @override
  String alertsDetailRange(String start, String end) {
    return '$start a $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'A partir de $start';
  }

  @override
  String get alertsDetailAffects => 'Afeta';

  @override
  String get alertsDetailRoutes => 'Linhas';

  @override
  String get alertsDetailStops => 'Paradas';

  @override
  String get alertsDetailAgencies => 'Agências';

  @override
  String get alertsDetailLearnMore => 'Saiba mais';

  @override
  String get alertsDetailNoDetails => 'Nenhum detalhe adicional disponível.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Emitido em $date';
  }

  @override
  String get alertsCouldNotOpen => 'Não foi possível abrir esse link.';

  @override
  String get agenciesEmptyTitle => 'Nenhuma agência';

  @override
  String get agenciesEmptyBody =>
      'Esta região não listou nenhuma agência de transporte.';

  @override
  String get agenciesWebsite => 'Site';

  @override
  String agenciesPhone(String phone) {
    return 'Ligar para $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'Enviar e-mail para $email';
  }

  @override
  String get agenciesFares => 'Informações de tarifas';

  @override
  String get agenciesDisclaimer => 'Aviso legal';

  @override
  String get agenciesShowOnMap => 'Mostrar cobertura no mapa';

  @override
  String get searchFieldLabel => 'Buscar';

  @override
  String get searchFieldHint => 'Linha, número da parada, endereço ou veículo';

  @override
  String get searchClear => 'Limpar busca';

  @override
  String get searchScopeLabel => 'Buscar';

  @override
  String get searchScopeAll => 'Tudo';

  @override
  String get searchScopeStops => 'Paradas';

  @override
  String get searchScopeRoutes => 'Linhas';

  @override
  String get searchScopePlaces => 'Lugares';

  @override
  String get searchQuickHeader => 'Buscar';

  @override
  String searchQuickRoute(String query) {
    return 'Linha: $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Número da parada: $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Endereço: $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Veículo: $query';
  }

  @override
  String get searchRecentStopsHeader => 'Paradas recentes';

  @override
  String get searchBookmarksHeader => 'Favoritos';

  @override
  String get searchRecentSearchesHeader => 'Buscas recentes';

  @override
  String get searchRecentPlacesHeader => 'Lugares recentes';

  @override
  String get searchPlacesHeader => 'Lugares';

  @override
  String get searchClearRecent => 'Limpar buscas recentes';

  @override
  String get searchClearRecentConfirm =>
      'Limpar suas buscas e lugares recentes?';

  @override
  String get searchClearAction => 'Limpar';

  @override
  String get searchRecentCleared => 'Buscas recentes limpas';

  @override
  String get searchPlacesLoading => 'Buscando lugares';

  @override
  String get searchPlacesNone => 'Nenhum lugar encontrado';

  @override
  String get searchPlacesError =>
      'Não foi possível buscar lugares. Verifique sua conexão.';

  @override
  String get searchSearching => 'Buscando';

  @override
  String get searchNoResultsTitle => 'Nenhum resultado';

  @override
  String searchNoResultsBody(String query) {
    return 'Nenhum resultado encontrado para “$query”.';
  }

  @override
  String get searchUnavailableNoRegion => 'Escolha uma região antes de buscar.';

  @override
  String get searchUnavailableAddress =>
      'A busca de endereços não está configurada neste app.';

  @override
  String get searchUnavailableVehicle =>
      'A busca de veículos não está disponível nesta região.';

  @override
  String get searchEmptyTitle => 'Encontre linhas, paradas e lugares';

  @override
  String get searchEmptyBody =>
      'Digite o nome de uma linha, um número de parada, um endereço ou um ID de veículo.';

  @override
  String get searchDismissMessage => 'Ignorar';

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
  String get searchResultsRoutes => 'Linhas';

  @override
  String get searchResultsStops => 'Paradas';

  @override
  String get searchResultsVehicles => 'Veículos';

  @override
  String get searchResultsPlaces => 'Lugares';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Linha $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Veículo $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'O veículo $id não está em nenhuma viagem no momento.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Carregando veículo $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'Ative a localização para ver as partidas das paradas próximas.';

  @override
  String get searchNearbyLocationButton => 'Usar minha localização';

  @override
  String get searchNearbyLocationDenied =>
      'O acesso à localização está desativado. Ative-o nos ajustes do dispositivo para ver as paradas próximas.';

  @override
  String get searchNearbyLocationServicesOff =>
      'Os serviços de localização estão desativados. Ative-os para ver as paradas próximas.';

  @override
  String get searchNearbyLocationUnavailable =>
      'Este app não usa sua localização, por isso não pode mostrar as paradas próximas.';

  @override
  String get searchNearbyEmpty => 'Nenhuma parada próxima';

  @override
  String get searchNearbyEmptyBody =>
      'Não há paradas a uma distância que se possa percorrer a pé.';

  @override
  String get searchNearbyMapCenter =>
      'Mostrando as paradas perto do centro do mapa.';

  @override
  String get searchNearbyNoDepartures => 'Nenhuma partida na próxima hora';

  @override
  String get searchNearbyLoadingDepartures => 'Carregando partidas';

  @override
  String get searchNearbyUpdated => 'Partidas próximas atualizadas';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paradas próximas',
      one: '$count parada próxima',
      zero: 'Nenhuma parada próxima',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Localizando você…';

  @override
  String get searchNearbyRefresh => 'Atualizar';

  @override
  String searchNearbyDistance(String distance) {
    return 'A $distance';
  }

  @override
  String get searchNearbyOtherDirection => 'Outras paradas';

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
    return '$route para $headsign, $eta, $status. Partindo de $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'De $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Partidas perto de você';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get searchEtaNow => 'Agora';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'em $minutes minutos',
      one: 'em $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => 'partindo agora';

  @override
  String get searchStatusOnTime => 'No horário';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min de atraso',
      one: '$minutes min de atraso',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min adiantado',
      one: '$minutes min adiantado',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => 'Programado';

  @override
  String get searchExplorePlanTrip => 'Planejar uma viagem';

  @override
  String get searchExploreWeather => 'Clima';

  @override
  String get searchExploreAgencies => 'Agências';

  @override
  String get searchPlaceAddress => 'Endereço';

  @override
  String get searchPlaceCoordinates => 'Coordenadas';

  @override
  String get searchPlaceDistance => 'Distância';

  @override
  String get searchPlaceDirectionsTo => 'Como chegar aqui';

  @override
  String get searchPlaceDirectionsFrom => 'Como sair daqui';

  @override
  String get searchPlaceNearbyStops => 'Paradas próximas';

  @override
  String get searchPlaceShare => 'Compartilhar';

  @override
  String get searchPlaceOpenInMaps => 'Abrir no app de mapas';

  @override
  String get searchPlaceRemovePin => 'Remover pino';

  @override
  String get searchPlaceOpenFailed => 'Não foi possível abrir um app de mapas.';

  @override
  String get searchPlaceShareFailed =>
      'Não foi possível compartilhar este lugar.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Lugar: $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Clima: $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Mostra a previsão do tempo';

  @override
  String get searchWeatherClear => 'Céu limpo';

  @override
  String get searchWeatherPartlyCloudy => 'Parcialmente nublado';

  @override
  String get searchWeatherCloudy => 'Nublado';

  @override
  String get searchWeatherRain => 'Chuva';

  @override
  String get searchWeatherSleet => 'Chuva com neve';

  @override
  String get searchWeatherSnow => 'Neve';

  @override
  String get searchWeatherWindy => 'Ventoso';

  @override
  String get searchWeatherFog => 'Neblina';

  @override
  String get searchWeatherUnknown => 'Condições desconhecidas';

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
      other: '$value graus Fahrenheit',
      one: '$value grau Fahrenheit',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value graus Celsius',
      one: '$value grau Celsius',
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
  String get searchWeatherFeelsLike => 'Sensação térmica';

  @override
  String get searchWeatherWind => 'Vento';

  @override
  String get searchWeatherPrecip => 'Chance de chuva';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'Máx. $high · Mín. $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'Máxima de $high, mínima de $low, nas próximas 24 horas';
  }

  @override
  String get searchWeatherHourly => 'Próximas 24 horas';

  @override
  String get searchWeatherNow => 'Agora';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time: $temperature, $condition, $precip de chance de chuva';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Temperaturas em $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'graus Fahrenheit (°F)';

  @override
  String get searchWeatherCelsius => 'graus Celsius (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Previsão das $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'A previsão do tempo não está disponível para esta região.';

  @override
  String get searchWeatherSummaryLabel => 'Hoje';

  @override
  String get bookmarksSectionEmpty => 'As paradas favoritas aparecem aqui.';

  @override
  String get coreDirectionNameN => 'Norte';

  @override
  String get coreDirectionNameNE => 'Nordeste';

  @override
  String get coreDirectionNameE => 'Leste';

  @override
  String get coreDirectionNameSE => 'Sudeste';

  @override
  String get coreDirectionNameS => 'Sul';

  @override
  String get coreDirectionNameSW => 'Sudoeste';

  @override
  String get coreDirectionNameW => 'Oeste';

  @override
  String get coreDirectionNameNW => 'Noroeste';

  @override
  String get coreDirectionAbbrN => 'N';

  @override
  String get coreDirectionAbbrNE => 'NE';

  @override
  String get coreDirectionAbbrE => 'L';

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
  String get coreDirectionBoundN => 'Sentido norte';

  @override
  String get coreDirectionBoundNE => 'Sentido NE';

  @override
  String get coreDirectionBoundE => 'Sentido leste';

  @override
  String get coreDirectionBoundSE => 'Sentido SE';

  @override
  String get coreDirectionBoundS => 'Sentido sul';

  @override
  String get coreDirectionBoundSW => 'Sentido SO';

  @override
  String get coreDirectionBoundW => 'Sentido oeste';

  @override
  String get coreDirectionBoundNW => 'Sentido NO';

  @override
  String get coreRouteTypeLightRail => 'VLT';

  @override
  String get coreRouteTypeSubway => 'Metrô';

  @override
  String get coreRouteTypeRail => 'Trem';

  @override
  String get coreRouteTypeBus => 'Ônibus';

  @override
  String get coreRouteTypeFerry => 'Balsa';

  @override
  String get coreRouteTypeCableCar => 'Bondinho';

  @override
  String get coreRouteTypeGondola => 'Gôndola';

  @override
  String get coreRouteTypeFunicular => 'Funicular';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Parada nº $code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Parada: \'$code\'';
  }

  @override
  String coreStopId(String code) {
    return 'ID da parada: $code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return 'Linhas: $routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Linhas: $routes e mais $count',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return 'Buscar em $region';
  }

  @override
  String get coreNow => 'AGORA';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get coreOneMinute => 'Um minuto';

  @override
  String get coreOneMinuteAgo => 'Há um minuto';

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
  String get coreJustNow => 'Agora mesmo';

  @override
  String coreSecondsAgo(int seconds) {
    return 'há $seconds s';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return 'há $minutes min';
  }

  @override
  String coreHoursAgo(int hours) {
    return 'há $hours h';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'há $days dias',
      one: 'há $days dia',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return 'Atualizado: $ago';
  }

  @override
  String get coreScheduledNotRealTime => 'Programado/sem tempo real';

  @override
  String coreArrivedMinAgo(int minutes) {
    return 'Chegou há $minutes min';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return 'Partiu há $minutes min';
  }

  @override
  String get coreArrivingNow => 'Chegando agora';

  @override
  String get coreDepartingNow => 'Partindo agora';

  @override
  String coreArrivesInMin(int minutes) {
    return 'Chega em $minutes min';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return 'Parte em $minutes min';
  }

  @override
  String coreArrivedLate(int minutes) {
    return 'chegou $minutes min atrasado';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return 'chegou $minutes min adiantado';
  }

  @override
  String get coreArrivedOnTime => 'chegou no horário';

  @override
  String coreDepartedLate(int minutes) {
    return 'partiu $minutes min atrasado';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return 'partiu $minutes min adiantado';
  }

  @override
  String get coreDepartedOnTime => 'partiu no horário';

  @override
  String coreArrivesLate(int minutes) {
    return 'chega $minutes min atrasado';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return 'chega $minutes min adiantado';
  }

  @override
  String get coreArrivesOnTime => 'chega no horário';

  @override
  String coreDepartsLate(int minutes) {
    return 'parte $minutes min atrasado';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return 'parte $minutes min adiantado';
  }

  @override
  String get coreDepartsOnTime => 'parte no horário';

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
  String get arrivalsNow => 'agora';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes min';
  }

  @override
  String get arrivalsCanceled => 'cancelado';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'a cada $minutes min a partir das $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'a cada $minutes min até as $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'Sentido norte';

  @override
  String get arrivalsDirectionBoundNE => 'Sentido nordeste';

  @override
  String get arrivalsDirectionBoundE => 'Sentido leste';

  @override
  String get arrivalsDirectionBoundSE => 'Sentido sudeste';

  @override
  String get arrivalsDirectionBoundS => 'Sentido sul';

  @override
  String get arrivalsDirectionBoundSW => 'Sentido sudoeste';

  @override
  String get arrivalsDirectionBoundW => 'Sentido oeste';

  @override
  String get arrivalsDirectionBoundNW => 'Sentido noroeste';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'Sentido $code';
  }

  @override
  String get arrivalsRefresh => 'Atualizar chegadas';

  @override
  String get arrivalsRetry => 'Tentar novamente';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Nenhuma chegada nos próximos $minutes minutos',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound =>
      'Parada não encontrada ou serviço indisponível';

  @override
  String get arrivalsNetworkError =>
      'Não foi possível conectar ao servidor de transporte. Verifique sua conexão.';

  @override
  String get arrivalsLoadError => 'Não foi possível carregar as chegadas.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'Não foi possível atualizar. Mostrando resultados de $time';
  }

  @override
  String get arrivalsArrivingNow => 'chegando agora';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'chega em $minutes minutos',
      one: 'chega em $minutes minuto',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'em tempo real';

  @override
  String get arrivalsRowTapHint => 'mostrar detalhes';

  @override
  String arrivalsAtTime(String time) {
    return 'às $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos de atraso',
      one: '$minutes minuto de atraso',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutos adiantado',
      one: '$minutes minuto adiantado',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'a cada $minutes minutos a partir das $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'a cada $minutes minutos até as $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'horário programado';

  @override
  String get arrivalsLoading => 'Carregando chegadas';

  @override
  String get arrivalsRefreshing => 'Atualizando chegadas';

  @override
  String get arrivalsUpdated => 'Chegadas atualizadas';

  @override
  String get tripPlannerOriginLabel => 'De';

  @override
  String get tripPlannerDestinationLabel => 'Para';

  @override
  String get tripPlannerChooseOrigin => 'Escolher ponto de partida';

  @override
  String get tripPlannerChooseDestination => 'Escolher destino';

  @override
  String get tripPlannerCurrentLocation => 'Localização atual';

  @override
  String get tripPlannerSwapEndpoints => 'Trocar ponto de partida e destino';

  @override
  String get tripPlannerPlanTrip => 'Planejar viagem';

  @override
  String get tripPlannerPlanningTrip => 'Planejando sua viagem';

  @override
  String get tripPlannerOptions => 'Opções de viagem';

  @override
  String get tripPlannerLeaveNow => 'Sair agora';

  @override
  String get tripPlannerDepartAt => 'Sair às';

  @override
  String get tripPlannerArriveBy => 'Chegar até às';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Alterar horário, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Transporte público';

  @override
  String get tripPlannerModeWalk => 'A pé';

  @override
  String get tripPlannerModeBike => 'Bicicleta';

  @override
  String get tripPlannerModeCar => 'Carro';

  @override
  String get tripPlannerModeBikeRental => 'Somente bicicleta compartilhada';

  @override
  String get tripPlannerModeTransitBikeRental =>
      'Transporte + bicicleta compartilhada';

  @override
  String get tripPlannerWheelchairAccessible =>
      'Acessível para cadeira de rodas';

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
    return 'Caminhar até $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'Nenhuma viagem encontrada';

  @override
  String get tripPlannerRetry => 'Tentar novamente';

  @override
  String get tripPlannerRealTime => 'Tempo real';

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
      other: '$count conexões',
      one: '$count conexão',
      zero: 'Sem conexões',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return '$distance a pé';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Parte às $time de $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'No horário';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '$minutes min de atraso';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '$minutes min adiantado';
  }

  @override
  String get tripPlannerStatusScheduled => 'Programado';

  @override
  String get tripPlannerLegBus => 'Ônibus';

  @override
  String get tripPlannerLegTram => 'Bonde';

  @override
  String get tripPlannerLegSubway => 'Metrô';

  @override
  String get tripPlannerLegRail => 'Trem';

  @override
  String get tripPlannerLegFerry => 'Balsa';

  @override
  String get tripPlannerLegCableCar => 'Bondinho';

  @override
  String get tripPlannerLegGondola => 'Gôndola';

  @override
  String get tripPlannerLegFunicular => 'Funicular';

  @override
  String get tripPlannerLegAirplane => 'Avião';

  @override
  String get tripPlannerLegTrolleybus => 'Trólebus';

  @override
  String get tripPlannerLegMonorail => 'Monotrilho';

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
    return '$duration a pé';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return '$duration de bicicleta';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return '$duration de bicicleta de aluguel';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return '$duration de carro';
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
  String get tripPlannerThen => 'depois';

  @override
  String get tripPlannerOpenItineraryHint => 'mostrar detalhes da viagem';

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
      other: '$value pés',
      one: '$value pé',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value milhas',
      one: '$value milha',
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
      other: '$value quilômetros',
      one: '$value quilômetro',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return 'das $start às $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'em tempo real, no horário';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'em tempo real, $minutes minutos de atraso',
      one: 'em tempo real, $minutes minuto de atraso',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'em tempo real, $minutes minutos adiantado',
      one: 'em tempo real, $minutes minuto adiantado',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'horário programado';

  @override
  String get tripPlannerResultsHeading => 'Viagens sugeridas';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viagens encontradas',
      one: '$count viagem encontrada',
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
      'Mapa da viagem. As instruções abaixo descrevem a mesma viagem.';

  @override
  String get tripPlannerTripDetails => 'Detalhes da viagem';

  @override
  String get tripPlannerMapLabel => 'Mapa da viagem';

  @override
  String get tripPlannerStart => 'Início';

  @override
  String get tripPlannerDestination => 'Destino';

  @override
  String get tripPlannerUnnamedPlace => 'Local sem nome';

  @override
  String get tripPlannerRentalBike => 'Bicicleta de aluguel';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Caminhe até $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Pedale até $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Pedale de bicicleta de aluguel até $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Dirija até $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Embarque em $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Embarque em $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Embarque em $mode sentido $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Embarque em $mode $route sentido $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Desça em $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Chegada em $place';
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
      other: '$count passos',
      one: '$count passo',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count passos',
      one: 'Mostrar $count passo',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ocultar $count passos',
      one: 'Ocultar $count passo',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, cerca de $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Inicie o trajeto';

  @override
  String get tripPlannerDirectionHardLeft => 'Vire acentuadamente à esquerda';

  @override
  String get tripPlannerDirectionLeft => 'Vire à esquerda';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'Mantenha-se à esquerda';

  @override
  String get tripPlannerDirectionContinue => 'Continue';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Mantenha-se à direita';

  @override
  String get tripPlannerDirectionRight => 'Vire à direita';

  @override
  String get tripPlannerDirectionHardRight => 'Vire acentuadamente à direita';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Entre na rotatória no sentido horário';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Entre na rotatória no sentido anti-horário';

  @override
  String get tripPlannerDirectionElevator => 'Pegue o elevador';

  @override
  String get tripPlannerDirectionUturnLeft => 'Faça um retorno pela esquerda';

  @override
  String get tripPlannerDirectionUturnRight => 'Faça um retorno pela direita';

  @override
  String get tripPlannerDirectionEnterStation => 'Entre na estação';

  @override
  String get tripPlannerDirectionExitStation => 'Saia da estação';

  @override
  String get tripPlannerDirectionFollowSigns => 'Siga a sinalização';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Caminhe por $street por $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction em $street e caminhe $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Buscar um lugar';

  @override
  String get tripPlannerSearchNoResults => 'Nenhum lugar encontrado';

  @override
  String get tripPlannerSearchError =>
      'Não foi possível buscar lugares. Tente novamente.';

  @override
  String get tripPlannerUseCurrentLocation => 'Usar localização atual';

  @override
  String get tripPlannerLocationUnavailable =>
      'Não foi possível obter sua localização.';

  @override
  String get tripPlannerClearSearch => 'Limpar busca';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Selecione o local de origem e o de destino.';

  @override
  String get tripPlannerErrorNetwork =>
      'Não foi possível conectar ao planejador de viagens. Verifique sua conexão.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'O servidor retornou uma resposta inválida';

  @override
  String get tripPlannerErrorUnknown => 'Ocorreu um erro desconhecido.';

  @override
  String get tripPlannerPlannerSystemError =>
      'Não conseguimos planejar sua viagem agora. Tente novamente.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'O planejamento de viagens está temporariamente indisponível. Tente novamente em breve.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'Este local ainda não é compatível.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'Nenhuma rota disponível para esta viagem.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'Nenhuma opção de transporte público disponível no momento.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'Isso demorou mais do que o esperado. Tente novamente.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'Algo deu errado com a solicitação. Tente novamente.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'Não conseguimos encontrar o ponto de partida.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'Não conseguimos encontrar o destino.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'Não conseguimos encontrar nem o ponto de partida nem o destino.';

  @override
  String get tripPlannerPlannerTooClose =>
      'O ponto de partida e o destino estão muito próximos.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'Esta rota não é acessível com a opção selecionada.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'O ponto de partida não está claro. Tente ser mais específico.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'O destino não está claro. Tente ser mais específico.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Os dois locais precisam de mais detalhes. Tente refiná-los.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'Faltam algumas opções de rota.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'As opções de rota selecionadas não funcionam em conjunto.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Escolha uma preferência de rota.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Ajuste as preferências de rota.';
}
