// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'oba_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class ObaLocalizationsFr extends ObaLocalizations {
  ObaLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonBack => 'Retour';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonDone => 'OK';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonNotNow => 'Plus tard';

  @override
  String get commonSeeAll => 'Tout afficher';

  @override
  String get commonLoading => 'Chargement';

  @override
  String get commonErrorTitle => 'Une erreur s’est produite';

  @override
  String get commonEmptyTitle => 'Rien pour l’instant';

  @override
  String get commonComingSoon => 'Bientôt disponible';

  @override
  String get commonComingSoonBody => 'Cet écran n’est pas encore disponible.';

  @override
  String get commonOffline =>
      'Vous semblez être hors ligne. Vérifiez votre connexion et réessayez.';

  @override
  String get commonServerError =>
      'Le serveur n’a pas répondu comme prévu. Réessayez dans un instant.';

  @override
  String get sheetLabel => 'Panneau';

  @override
  String get sheetExpand => 'Développer le panneau';

  @override
  String get sheetCollapse => 'Réduire le panneau';

  @override
  String get sheetHandleHint =>
      'Faites glisser ou touchez deux fois pour redimensionner le panneau';

  @override
  String get homeTabHome => 'Accueil';

  @override
  String get homeTabRecent => 'Récents';

  @override
  String get homeTabBookmarks => 'Favoris';

  @override
  String get homeSearchPlaceholder => 'Rechercher arrêts, lignes, lieux';

  @override
  String get homeSearchLabel => 'Rechercher';

  @override
  String get homeSectionNearby => 'À proximité';

  @override
  String get homeSectionRecent => 'Arrêts récents';

  @override
  String get homeSectionBookmarks => 'Favoris';

  @override
  String get homeSectionAlerts => 'Alertes';

  @override
  String get homeSectionExplore => 'Explorer';

  @override
  String get homeSectionMore => 'Réglages et plus';

  @override
  String get mapLabel => 'Carte';

  @override
  String get mapZoomInForStops => 'Zoomez pour voir les arrêts';

  @override
  String get mapLocationDenied =>
      'L’accès à la position est désactivé. Touchez pour l’autoriser.';

  @override
  String get mapLocationServicesOff =>
      'Les services de localisation sont désactivés';

  @override
  String get mapRecenter => 'Afficher ma position';

  @override
  String get mapSettingsButton => 'Réglages de la carte';

  @override
  String get mapStopsListButton => 'Arrêts sur la carte';

  @override
  String mapVisibleStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arrêts sur la carte',
      one: '$count arrêt sur la carte',
      zero: 'Aucun arrêt sur la carte',
    );
    return '$_temp0';
  }

  @override
  String get mapCurrentLocation => 'Votre position';

  @override
  String get mapDroppedPin => 'Repère placé';

  @override
  String get mapVehicle => 'Véhicule';

  @override
  String get mapSelectedStop => 'Sélectionné';

  @override
  String get mapBookmarkedStop => 'Dans les favoris';

  @override
  String mapStopMarkerLabel(String name, String routeType) {
    return '$name, arrêt de $routeType';
  }

  @override
  String get mapStopMarkerHint => 'Ouvre les départs de l’arrêt';

  @override
  String mapAttribution(String attribution) {
    return 'Données cartographiques : $attribution';
  }

  @override
  String get mapTypeTitle => 'Type de carte';

  @override
  String get mapTypeStandard => 'Standard';

  @override
  String get mapTypeSatellite => 'Satellite';

  @override
  String get mapTypeHybrid => 'Hybride';

  @override
  String get mapShowScale => 'Afficher l’échelle';

  @override
  String get mapShowHeading => 'Afficher le cap';

  @override
  String get mapShowStopLabels => 'Afficher les noms des arrêts';

  @override
  String mapPlaceAt(String lat, String lon) {
    return 'Position : $lat, $lon';
  }

  @override
  String get directionN => 'Direction nord';

  @override
  String get directionNE => 'Direction nord-est';

  @override
  String get directionE => 'Direction est';

  @override
  String get directionSE => 'Direction sud-est';

  @override
  String get directionS => 'Direction sud';

  @override
  String get directionSW => 'Direction sud-ouest';

  @override
  String get directionW => 'Direction ouest';

  @override
  String get directionNW => 'Direction nord-ouest';

  @override
  String get routeTypeBus => 'Bus';

  @override
  String get routeTypeLightRail => 'Tramway';

  @override
  String get routeTypeSubway => 'Métro';

  @override
  String get routeTypeRail => 'Train';

  @override
  String get routeTypeFerry => 'Ferry';

  @override
  String get routeTypeCableCar => 'Tramway à câble';

  @override
  String get routeTypeGondola => 'Télécabine';

  @override
  String get routeTypeFunicular => 'Funiculaire';

  @override
  String get routeTypeUnknown => 'Transport';

  @override
  String stopCode(String code) {
    return 'Arrêt $code';
  }

  @override
  String stopRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String stopRoutes(String routes) {
    return 'Lignes $routes';
  }

  @override
  String get stopPageRefresh => 'Actualiser';

  @override
  String get stopPageRefreshed => 'Départs mis à jour';

  @override
  String get stopPageBookmark => 'Ajouter l’arrêt aux favoris';

  @override
  String get stopPageBookmarked => 'Ajouté aux favoris. Modifier le favori';

  @override
  String get stopPageMoreActions => 'Autres actions pour l’arrêt';

  @override
  String get stopPageSchedules => 'Horaires';

  @override
  String get stopPageServiceAlerts => 'Alertes de service';

  @override
  String get stopPageNearbyStops => 'Arrêts à proximité';

  @override
  String get stopPageWalkingDirections => 'Itinéraire à pied';

  @override
  String get stopPageBikeDirections => 'Itinéraire à vélo';

  @override
  String get stopPagePlanTripFrom => 'Planifier un trajet depuis ici';

  @override
  String get stopPagePlanTripTo => 'Planifier un trajet vers ici';

  @override
  String get stopPageShareStop => 'Partager l’arrêt';

  @override
  String get stopPageReportProblem => 'Signaler un problème';

  @override
  String get stopPageFilterRoutes => 'Filtrer les lignes';

  @override
  String stopPageRoutesHidden(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes masquées',
      one: '$count ligne masquée',
    );
    return '$_temp0';
  }

  @override
  String get stopPageModeTime => 'Par heure';

  @override
  String get stopPageModeRoute => 'Par ligne';

  @override
  String get stopPageDepartureTypes => 'Types de départs';

  @override
  String get stopPageFilterAll => 'Tous les départs';

  @override
  String get stopPageFilterRealtime => 'Temps réel uniquement';

  @override
  String get stopPageFilterScheduled => 'Horaires théoriques uniquement';

  @override
  String stopPageEarlier(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Afficher $count départs passés',
      one: 'Afficher $count départ passé',
    );
    return '$_temp0';
  }

  @override
  String get stopPageHideEarlier => 'Masquer les départs passés';

  @override
  String get stopPageLoadMore => 'Charger plus de départs';

  @override
  String stopPageWindow(int minutes) {
    return 'Prochaines $minutes minutes affichées';
  }

  @override
  String stopPageUpdated(String ago) {
    return 'Mis à jour $ago';
  }

  @override
  String get stopPageStaleTitle => 'Impossible d’actualiser les départs';

  @override
  String get stopPageStaleBody => 'Ces horaires peuvent être périmés.';

  @override
  String get stopPageEmptyTitle => 'Aucun départ à venir';

  @override
  String stopPageEmptyBody(int minutes) {
    return 'Aucun départ dans les $minutes prochaines minutes.';
  }

  @override
  String get stopPageEmptyHiddenRoutes =>
      'Toutes les lignes desservant cet arrêt sont masquées.';

  @override
  String get stopPageShowAllRoutes => 'Afficher toutes les lignes';

  @override
  String get stopPageEmptyFilter =>
      'Aucun départ ne correspond au filtre de type de départ.';

  @override
  String get stopPageShowAllTypes => 'Afficher tous les départs';

  @override
  String get stopPageMissingTitle => 'Arrêt introuvable';

  @override
  String get stopPageMissingBody =>
      'Cet arrêt a peut-être été supprimé ou renuméroté.';

  @override
  String stopPageWalkTime(int minutes) {
    return '$minutes min à pied';
  }

  @override
  String stopPageBikeTime(int minutes) {
    return '$minutes min à vélo';
  }

  @override
  String stopPageWalkTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes à pied',
      one: '$minutes minute à pied',
    );
    return '$_temp0, $distance. Ouvre l’itinéraire.';
  }

  @override
  String stopPageBikeTimeLabel(int minutes, String distance) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes à vélo',
      one: '$minutes minute à vélo',
    );
    return '$_temp0, $distance. Ouvre l’itinéraire.';
  }

  @override
  String stopPageWalkDivider(int minutes) {
    return '$minutes min à pied jusqu’à cet arrêt. Les départs ci-dessus partent trop tôt.';
  }

  @override
  String stopPageBikeDivider(int minutes) {
    return '$minutes min à vélo jusqu’à cet arrêt. Les départs ci-dessus partent trop tôt.';
  }

  @override
  String stopPageAgencies(String names) {
    return 'Service assuré par $names';
  }

  @override
  String stopPageAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertes de service',
      one: '$count alerte de service',
    );
    return '$_temp0';
  }

  @override
  String stopPageAlertsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count non lues',
      one: '$count non lue',
    );
    return '$_temp0';
  }

  @override
  String get stopPageAlertUnread => 'Non lue';

  @override
  String get stopPageAlertImportant => 'Important';

  @override
  String get stopPageDirectionsChooser => 'Ouvrir l’itinéraire dans';

  @override
  String get stopPageAppleMaps => 'Plans';

  @override
  String get stopPageGoogleMaps => 'Google Maps';

  @override
  String get stopPageCannotOpen => 'Impossible d’ouvrir ce lien.';

  @override
  String stopPageTransfer(String route, String headsign, String time) {
    return 'Correspondance depuis $route $headsign, arrivée $time';
  }

  @override
  String get stopPageDeparturesHeader => 'Départs';

  @override
  String get stopRowNow => 'MAINTENANT';

  @override
  String stopRowMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String stopRowMinutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String get stopRowOnTime => 'à l’heure';

  @override
  String stopRowLate(int minutes) {
    return '$minutes min de retard';
  }

  @override
  String stopRowEarly(int minutes) {
    return '$minutes min d’avance';
  }

  @override
  String get stopRowScheduled => 'prévu';

  @override
  String get stopRowCanceled => 'annulé';

  @override
  String get stopRowOccupancyEmpty => 'Vide';

  @override
  String get stopRowOccupancyManySeats => 'Beaucoup de places assises';

  @override
  String get stopRowOccupancyFewSeats => 'Peu de places assises';

  @override
  String get stopRowOccupancyStanding => 'Places debout uniquement';

  @override
  String get stopRowOccupancyCrushed => 'Très chargé';

  @override
  String get stopRowOccupancyFull => 'Complet';

  @override
  String get stopRowOccupancyNotAccepting => 'Ne prend plus de passagers';

  @override
  String stopRowA11yArrives(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arrive dans $minutes minutes',
      one: 'arrive dans $minutes minute',
      zero: 'arrive maintenant',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparts(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'part dans $minutes minutes',
      one: 'part dans $minutes minute',
      zero: 'part maintenant',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yArrived(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arrivé il y a $minutes minutes',
      one: 'arrivé il y a $minutes minute',
    );
    return '$_temp0';
  }

  @override
  String stopRowA11yDeparted(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'parti il y a $minutes minutes',
      one: 'parti il y a $minutes minute',
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
    return 'Ligne $route vers $headsign, $eta, à $time, $status';
  }

  @override
  String stopRowA11yLive(String status) {
    return 'suivi en direct, $status';
  }

  @override
  String get stopRowA11yScheduledOnly =>
      'horaire théorique uniquement, sans données en direct';

  @override
  String get stopRowA11yTransfer => 'votre trajet de correspondance';

  @override
  String get stopRowA11yMissed =>
      'probablement manqué, il part avant que vous puissiez y aller à pied';

  @override
  String get stopRowA11yAlarm => 'rappel activé';

  @override
  String stopRowActions(String route) {
    return 'Autres actions pour la ligne $route';
  }

  @override
  String get stopRowShowTrip => 'Afficher les détails du trajet';

  @override
  String get stopRowAddAlarm => 'Ajouter un rappel';

  @override
  String get stopRowRemoveAlarm => 'Supprimer le rappel';

  @override
  String get stopRowBookmarkTrip => 'Ajouter ce trajet aux favoris';

  @override
  String get stopRowShareTrip => 'Partager le trajet';

  @override
  String get stopRowRouteSchedule => 'Horaires de la ligne';

  @override
  String get stopRowRouteStops => 'Arrêts de cette ligne';

  @override
  String stopRouteGroupNext(String times) {
    return 'Prochains : $times';
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
      other: '$count départs',
      one: '$count départ',
    );
    return 'Ligne $route vers $headsigns, $_temp0, prochain $eta';
  }

  @override
  String get stopAlarmPickerTitle => 'Me rappeler avant le départ';

  @override
  String stopAlarmLeadTime(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes avant',
      one: '$minutes minute avant',
    );
    return '$_temp0';
  }

  @override
  String stopAlarmSet(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Rappel défini $minutes minutes avant',
      one: 'Rappel défini $minutes minute avant',
    );
    return '$_temp0';
  }

  @override
  String get stopAlarmRemoved => 'Rappel supprimé';

  @override
  String get stopAlarmFailed => 'Impossible de mettre à jour le rappel.';

  @override
  String get stopAlarmPermissionDenied =>
      'Les notifications sont désactivées pour cette app.';

  @override
  String get stopFilterTitle => 'Filtrer les lignes';

  @override
  String get stopFilterSort => 'Trier les départs';

  @override
  String get stopFilterRoutesHeader => 'Lignes affichées à cet arrêt';

  @override
  String get stopFilterShowAll => 'Afficher toutes les lignes';

  @override
  String get stopTripArrivingAtYourStop => 'Arrive à votre arrêt';

  @override
  String stopTripStopsAway(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'À $count arrêts',
      one: 'À $count arrêt',
      zero: 'À votre arrêt',
    );
    return '$_temp0';
  }

  @override
  String stopTripDistanceAway(String distance) {
    return 'À $distance';
  }

  @override
  String stopTripAtStop(String stop) {
    return 'À $stop';
  }

  @override
  String stopTripPositionUpdated(String ago) {
    return 'Position mise à jour $ago';
  }

  @override
  String get stopTripNoPosition =>
      'Aucune position en temps réel pour ce véhicule';

  @override
  String stopTripStartsAs(String trip) {
    return 'Commence en tant que $trip';
  }

  @override
  String stopTripContinuesAs(String trip) {
    return 'Continue en tant que $trip';
  }

  @override
  String get stopTripStopsHeader => 'Arrêts';

  @override
  String stopTripRunPassed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arrêts desservis',
      one: '$count arrêt desservi',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunApproaching(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arrêts avant votre arrêt',
      one: '$count arrêt avant votre arrêt',
    );
    return '$_temp0';
  }

  @override
  String stopTripRunRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get stopTripYourStop => 'Votre arrêt';

  @override
  String get stopTripBoarding => 'Montée en cours';

  @override
  String get stopTripVehicleHere => 'Le véhicule est ici';

  @override
  String get stopTripTerminal => 'Terminus';

  @override
  String get stopTripPassed => 'Desservi';

  @override
  String get stopTripRouteStops => 'Tous les arrêts de cette ligne';

  @override
  String get stopTripReport => 'Signaler un problème avec ce trajet';

  @override
  String get stopTripGhostBus => 'Signaler un bus fantôme';

  @override
  String get stopTripCanceled => 'Ce trajet est annulé';

  @override
  String stopTripVehicleLabel(String route) {
    return 'Véhicule de la ligne $route';
  }

  @override
  String stopTripFrequency(int minutes) {
    return 'Toutes les $minutes min';
  }

  @override
  String stopRouteStopsTitle(String route) {
    return 'Ligne $route';
  }

  @override
  String get stopRouteStopsDirection => 'Direction';

  @override
  String stopRouteStopsToward(String name) {
    return 'Vers $name';
  }

  @override
  String stopRouteStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arrêts',
      one: '$count arrêt',
    );
    return '$_temp0';
  }

  @override
  String get stopRouteStopsEmpty => 'Aucun arrêt trouvé pour cette ligne.';

  @override
  String get stopSchedPrevDay => 'Jour précédent';

  @override
  String get stopSchedNextDay => 'Jour suivant';

  @override
  String stopSchedPickDate(String date) {
    return 'Choisir la date, $date';
  }

  @override
  String get stopSchedRoute => 'Ligne';

  @override
  String get stopSchedDirection => 'Direction';

  @override
  String get stopSchedStop => 'Arrêt';

  @override
  String get stopSchedEmpty => 'Aucun service prévu ce jour-là.';

  @override
  String stopSchedEvery(int minutes, String start, String end) {
    return 'Toutes les $minutes min de $start à $end';
  }

  @override
  String stopSchedTo(String headsign) {
    return 'Vers $headsign';
  }

  @override
  String stopSchedDepartures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count départs',
      one: '$count départ',
    );
    return '$_temp0';
  }

  @override
  String stopSchedHour(String hour, String times) {
    return '$hour h : $times';
  }

  @override
  String get stopSchedNotSupported =>
      'Les horaires ne sont pas disponibles dans cette région.';

  @override
  String get stopSchedViewList => 'Liste';

  @override
  String get stopSchedViewGrid => 'Grille';

  @override
  String get stopSchedNoDeparture => 'Aucun départ';

  @override
  String stopSchedYourStop(String stop) {
    return '$stop (votre arrêt)';
  }

  @override
  String stopSchedCell(String stop, int trip, String time) {
    return '$stop, trajet $trip : $time';
  }

  @override
  String get stopReportProblemHeader => 'Quel est le problème ?';

  @override
  String get stopReportStopNameWrong => 'Le nom de l’arrêt est incorrect';

  @override
  String get stopReportStopNumberWrong => 'Le numéro de l’arrêt est incorrect';

  @override
  String get stopReportStopLocationWrong => 'L’arrêt n’est pas au bon endroit';

  @override
  String get stopReportRouteMissing => 'Une ligne ou un trajet est manquant';

  @override
  String get stopReportOther => 'Autre chose';

  @override
  String get stopReportNeverCame => 'Le véhicule n’est jamais passé';

  @override
  String get stopReportCameEarly => 'Il est passé en avance';

  @override
  String get stopReportCameLate => 'Il est passé en retard';

  @override
  String get stopReportWrongHeadsign =>
      'La destination affichée était incorrecte';

  @override
  String get stopReportNotStopHere => 'Il ne s’est pas arrêté ici';

  @override
  String get stopReportComment => 'Commentaires supplémentaires (facultatif)';

  @override
  String get stopReportShareLocation => 'Partager ma position';

  @override
  String get stopReportShareLocationHelp =>
      'Partager votre position peut aider votre agence de transport à résoudre ce problème.';

  @override
  String get stopReportOnVehicle => 'Je suis dans ce véhicule';

  @override
  String get stopReportVehicleId => 'Numéro du véhicule (facultatif)';

  @override
  String get stopReportSend => 'Envoyer le signalement';

  @override
  String get stopReportSending => 'Envoi du signalement';

  @override
  String get stopReportSent => 'Merci ! Votre signalement a été envoyé.';

  @override
  String get stopReportFailed =>
      'Impossible d’envoyer le signalement. Veuillez réessayer.';

  @override
  String get stopReportChooseProblem => 'Choisissez d’abord un problème.';

  @override
  String stopReportAbout(String name) {
    return 'Signalement : $name';
  }

  @override
  String get stopGhostTitle => 'Signaler un bus fantôme';

  @override
  String get stopGhostExplain =>
      'Un bus fantôme est un bus affiché par l’app mais qui n’est jamais passé.';

  @override
  String get stopGhostWait =>
      'Combien de temps avez-vous attendu après l’heure prévue ?';

  @override
  String stopGhostWaitMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get stopGhostWaitThirtyPlus => '30+ min';

  @override
  String get stopCardEmpty => 'Aucun départ prochain';

  @override
  String get titleSearch => 'Recherche';

  @override
  String get titleSearchResults => 'Résultats';

  @override
  String get titleNearbyStops => 'Arrêts à proximité';

  @override
  String get titleRecentStops => 'Arrêts récents';

  @override
  String get titleBookmarks => 'Favoris';

  @override
  String get titleStop => 'Arrêt';

  @override
  String get titleTrip => 'Trajet';

  @override
  String get titleRouteStops => 'Ligne';

  @override
  String get titleStopSchedule => 'Horaires';

  @override
  String get titleRouteSchedule => 'Horaires de la ligne';

  @override
  String get titleAlerts => 'Alertes';

  @override
  String get titleAlertDetail => 'Alerte';

  @override
  String get titleAgencies => 'Agences';

  @override
  String get titleRegionPicker => 'Régions';

  @override
  String get titleCustomRegion => 'Région personnalisée';

  @override
  String get titleSettings => 'Réglages';

  @override
  String get titleMapSettings => 'Réglages de la carte';

  @override
  String get titleMore => 'Plus';

  @override
  String get titleTripPlanner => 'Planifier un trajet';

  @override
  String get titlePlace => 'Lieu';

  @override
  String get titleReportStopProblem => 'Signaler un problème';

  @override
  String get titleReportTripProblem => 'Signaler un problème';

  @override
  String get titleBookmarkEditor => 'Favori';

  @override
  String get titleManageBookmarks => 'Modifier les favoris';

  @override
  String get titleCredits => 'Crédits';

  @override
  String get titleWeather => 'Météo';

  @override
  String get titleStopsOnMap => 'Arrêts sur la carte';

  @override
  String onboardingWelcomeTitle(String appName) {
    return 'Bienvenue dans $appName';
  }

  @override
  String get onboardingWelcomeBody =>
      'Les arrivées en temps réel des bus, trains et ferrys près de chez vous.';

  @override
  String get onboardingLocationTitle => 'Trouvez les arrêts près de vous';

  @override
  String get onboardingLocationBody =>
      'Autorisez l’accès à la position pour voir les arrêts à proximité et choisir votre région automatiquement.';

  @override
  String get onboardingAllowLocation => 'Autoriser l’accès à la position';

  @override
  String get onboardingRegionTitle => 'Choisissez votre région';

  @override
  String get onboardingRegionBody =>
      'Choisissez la zone dont vous voulez voir les transports.';

  @override
  String get settingsSectionMap => 'Carte';

  @override
  String get settingsMapTypeRow => 'Type de carte et couches';

  @override
  String get settingsMapTypeHelp => 'Choisissez l’apparence de la carte.';

  @override
  String get settingsHeadingHelp =>
      'Indique sur la carte la direction dans laquelle vous regardez.';

  @override
  String get settingsStopLabelsHelp =>
      'Affiche le nom des lignes à côté des arrêts sur la carte.';

  @override
  String get settingsWalkingDirections => 'Itinéraire à pied';

  @override
  String get settingsWalkingDirectionsHelp =>
      'L’app qui s’ouvre quand vous demandez un itinéraire à pied vers un arrêt.';

  @override
  String get settingsDirectionsAsk => 'Demander à chaque fois';

  @override
  String get settingsDirectionsAppleMaps => 'Plans';

  @override
  String get settingsDirectionsGoogleMaps => 'Google Maps';

  @override
  String get settingsSectionDepartures => 'Départs';

  @override
  String get settingsDepartureFilter => 'Afficher les départs';

  @override
  String get settingsDepartureFilterHelp =>
      'Choisissez si les pages d’arrêt listent tous les départs ou seulement ceux avec des données en temps réel ou théoriques.';

  @override
  String get settingsFilterAll => 'Tous les départs';

  @override
  String get settingsFilterRealtime => 'Temps réel uniquement';

  @override
  String get settingsFilterScheduled => 'Horaires théoriques uniquement';

  @override
  String get settingsRegionTimeZone =>
      'Afficher les heures dans le fuseau horaire de la région';

  @override
  String get settingsRegionTimeZoneHelp =>
      'Les heures utilisent le fuseau horaire de la région de transport, avec une note lorsqu’il diffère de celui de votre appareil.';

  @override
  String get settingsSectionAccessibility => 'Accessibilité';

  @override
  String get settingsReducedColors =>
      'Réduire les couleurs sur les pages d’arrêt';

  @override
  String get settingsReducedColorsHelp =>
      'Affiche les pastilles de ligne dans un style neutre unique.';

  @override
  String get settingsCompactMode => 'Pages d’arrêt et de trajet compactes';

  @override
  String get settingsCompactModeHelp =>
      'Resserre les espacements pour afficher plus de contenu à l’écran.';

  @override
  String get settingsSectionWalking => 'Vitesse de marche';

  @override
  String get settingsWalkingSpeed => 'Vitesse de marche';

  @override
  String get settingsWalkingSpeedHelp =>
      'Utilisée pour estimer les temps de marche et les heures d’arrivée.';

  @override
  String get settingsSpeedSlow => 'Lente';

  @override
  String get settingsSpeedAverage => 'Moyenne';

  @override
  String get settingsSpeedFast => 'Rapide';

  @override
  String settingsSpeedCustom(String speed) {
    return 'Personnalisée ($speed m/s)';
  }

  @override
  String get settingsSectionBike => 'Mode vélo';

  @override
  String get settingsBikeMode => 'Mode vélo';

  @override
  String get settingsBikeModeHelp =>
      'Utilise une vitesse de déplacement plus élevée pour les estimations de temps de trajet, les heures d’arrivée et la page d’arrêt.';

  @override
  String get settingsSectionSurveys => 'Sondages';

  @override
  String get settingsSurveysEnabled => 'Afficher les sondages';

  @override
  String get settingsSurveysAlways =>
      'Toujours afficher les sondages aux arrêts';

  @override
  String get settingsSectionPrivacy => 'Confidentialité';

  @override
  String get settingsAnalytics =>
      'Envoyer les données d’utilisation aux développeurs';

  @override
  String get settingsAnalyticsHelp =>
      'Aide les développeurs à savoir quelles fonctionnalités sont utilisées.';

  @override
  String get settingsSectionDebug => 'Débogage';

  @override
  String get settingsDebugMode => 'Mode débogage';

  @override
  String get settingsDebugAlwaysFeedback =>
      'Toujours afficher l’invite de commentaires';

  @override
  String get settingsDebugResetFeedback =>
      'Réinitialiser l’état de l’invite de commentaires';

  @override
  String get settingsDebugResetDonation =>
      'Réinitialiser l’état de la carte de dons';

  @override
  String get settingsDebugResetDone => 'Réinitialisé';

  @override
  String get settingsSectionTripPlanner => 'Planificateur de trajet';

  @override
  String get settingsHomeCustomizeMap => 'Personnaliser la carte';

  @override
  String get moreHeaderSupport =>
      'Cette app est créée et soutenue par des bénévoles.';

  @override
  String get moreSectionDonate => 'Devenir un soutien';

  @override
  String moreDonate(String appName) {
    return 'Faire un don à $appName';
  }

  @override
  String get moreManageDonations => 'Gérer les dons';

  @override
  String get moreSectionUpdates => 'Mises à jour et alertes';

  @override
  String get moreAlerts => 'Alertes';

  @override
  String get moreSectionLocation => 'Ma position';

  @override
  String get moreRegion => 'Région';

  @override
  String get moreRegionNone => 'Non sélectionnée';

  @override
  String get morePayFare => 'Payer mon titre de transport';

  @override
  String get moreAgencies => 'Agences';

  @override
  String get moreSectionAbout => 'À propos de cette app';

  @override
  String moreRateApp(String appName) {
    return 'Noter $appName';
  }

  @override
  String get moreContactUs => 'Nous contacter';

  @override
  String get morePrivacy => 'Politique de confidentialité';

  @override
  String get moreCredits => 'Crédits';

  @override
  String moreVersion(String appName, String version) {
    return '$appName version $version';
  }

  @override
  String get moreSectionHelpOut => 'Aidez à améliorer l’app';

  @override
  String get moreTranslate => 'Aidez à traduire l’app';

  @override
  String get moreDevelop =>
      'Aidez à corriger des bugs et à créer de nouvelles fonctionnalités';

  @override
  String get moreSectionContact => 'Contact et aide';

  @override
  String get moreTutorials => 'Tutoriels';

  @override
  String get moreCallAgency => 'Appeler l’agence';

  @override
  String get moreTextAgency => 'Écrire à l’agence';

  @override
  String get moreSectionResources => 'Ressources';

  @override
  String get moreContactTitle => 'Nous contacter';

  @override
  String get moreContactDevelopers => 'Suggestion ou signalement de bug';

  @override
  String get moreContactAgency => 'Problème de véhicule ou d’horaires';

  @override
  String moreEmailSubject(String appName) {
    return 'Commentaires sur $appName';
  }

  @override
  String get moreEmailAgencySubject =>
      'Commentaires d’un usager des transports';

  @override
  String get moreEmailIntro =>
      'Comment pouvons-nous vous aider ? Saisissez votre message ci-dessous :';

  @override
  String get moreEmailDebugIntro =>
      'Les informations suivantes sont fournies à des fins de dépannage. Si vous ne souhaitez pas en partager une partie, vous pouvez la supprimer, mais cela pourrait limiter notre capacité à vous aider.';

  @override
  String get moreDebugAppVersion => 'Version de l’app';

  @override
  String get moreDebugOs => 'Système d’exploitation';

  @override
  String get moreDebugLocale => 'Langue';

  @override
  String get moreDebugBookmarks => 'Nombre de favoris';

  @override
  String get moreDebugLocationPermission => 'Autorisation de localisation';

  @override
  String get moreDebugRegion => 'Région';

  @override
  String get moreDebugRegionId => 'ID de la région';

  @override
  String get moreDebugApiUrl => 'URL de base de l’API';

  @override
  String get moreDebugUserId => 'ID utilisateur';

  @override
  String get moreCantEmailTitle =>
      'Impossible d’ouvrir votre app de messagerie';

  @override
  String moreCantEmailBody(String email) {
    return 'Pour nous contacter, envoyez un e-mail à $email. Copiez les infos de débogage et collez-les dans votre message pour nous aider à résoudre le problème.';
  }

  @override
  String get moreCopyEmail => 'Copier l’adresse e-mail';

  @override
  String get moreCopyDebug => 'Copier les infos de débogage';

  @override
  String get moreCopied => 'Copié dans le presse-papiers';

  @override
  String get moreFareContinue => 'Continuer';

  @override
  String get moreFareDontShowAgain => 'Continuer et ne plus afficher';

  @override
  String get moreCantOpenLink => 'Impossible d’ouvrir ce lien.';

  @override
  String get regionPickerAutomatic => 'Choisir la région automatiquement';

  @override
  String get regionPickerAutomaticHelp =>
      'Bascule vers la région où vous vous trouvez. Choisir vous-même une région désactive cette option.';

  @override
  String get regionPickerShowExperimental =>
      'Afficher les régions expérimentales';

  @override
  String get regionPickerShowInactive => 'Afficher les régions inactives';

  @override
  String get regionPickerRegionsSection => 'Régions';

  @override
  String get regionPickerCustomSection => 'Régions personnalisées';

  @override
  String get regionPickerCurrent => 'Région actuelle';

  @override
  String get regionPickerExperimentalTag => 'Expérimentale';

  @override
  String get regionPickerInactiveTag => 'Inactive';

  @override
  String get regionPickerCustomTag => 'Personnalisée';

  @override
  String regionPickerRowLabel(String name, String details) {
    return '$name, $details';
  }

  @override
  String get regionPickerAdd => 'Ajouter une région personnalisée';

  @override
  String get regionPickerRefresh => 'Actualiser les régions';

  @override
  String get regionPickerRefreshed => 'Régions mises à jour';

  @override
  String get regionPickerRefreshFailed =>
      'Impossible de mettre à jour la liste des régions. Affichage de la liste enregistrée.';

  @override
  String regionPickerSelected(String name) {
    return '$name sélectionnée';
  }

  @override
  String regionPickerEdit(String name) {
    return 'Modifier $name';
  }

  @override
  String regionPickerDelete(String name) {
    return 'Supprimer $name';
  }

  @override
  String regionPickerDeleteTitle(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get regionPickerDeleteBody =>
      'Cette région personnalisée sera supprimée de cet appareil.';

  @override
  String get regionPickerDeleteConfirm => 'Supprimer';

  @override
  String get regionPickerCantDeleteCurrent =>
      'Choisissez une autre région avant de supprimer celle-ci.';

  @override
  String get regionPickerEmpty => 'Aucune région disponible';

  @override
  String get regionPickerEmptyBody =>
      'Activez les régions expérimentales ou inactives, ou ajoutez une région personnalisée.';

  @override
  String get regionPickerTripPlanner =>
      'Planificateur de trajet dans cette région';

  @override
  String get customRegionEditTitle => 'Modifier la région personnalisée';

  @override
  String get customRegionName => 'Nom';

  @override
  String get customRegionObaUrl => 'URL du serveur OneBusAway';

  @override
  String get customRegionObaUrlHelp =>
      'L’adresse du serveur, par exemple https://oba.example.com/';

  @override
  String get customRegionSidecar => 'URL du serveur Sidecar (facultatif)';

  @override
  String get customRegionOtp => 'URL du planificateur de trajet (facultatif)';

  @override
  String get customRegionOtpGraphql =>
      'URL GraphQL du planificateur de trajet (facultatif)';

  @override
  String get customRegionServiceArea => 'Zone de service';

  @override
  String get customRegionServiceAreaHelp =>
      'La zone couverte par cette région : un point central et son étendue.';

  @override
  String get customRegionLatitude => 'Latitude du centre';

  @override
  String get customRegionLongitude => 'Longitude du centre';

  @override
  String get customRegionLatSpan => 'Étendue en latitude (degrés)';

  @override
  String get customRegionLonSpan => 'Étendue en longitude (degrés)';

  @override
  String get customRegionUseMap => 'Utiliser la zone actuelle de la carte';

  @override
  String get customRegionSave => 'Enregistrer';

  @override
  String get customRegionErrorRequired => 'Ce champ est obligatoire';

  @override
  String get customRegionErrorUrl =>
      'Saisissez une adresse web commençant par http:// ou https://';

  @override
  String get customRegionErrorNumber => 'Saisissez un nombre';

  @override
  String get customRegionErrorRange => 'Ce nombre est hors limites';

  @override
  String get customRegionChecking => 'Vérification du serveur';

  @override
  String get customRegionServerOk => 'Le serveur a répondu';

  @override
  String get customRegionServerUnreachable =>
      'Impossible de joindre ce serveur';

  @override
  String get customRegionServerNotOba =>
      'Ce serveur n’a pas répondu comme OneBusAway';

  @override
  String customRegionSaved(String name) {
    return '$name enregistrée';
  }

  @override
  String get creditsAbout => 'OneBusAway';

  @override
  String get creditsAboutBody =>
      'OneBusAway est un logiciel de transport libre et open source, créé par des bénévoles et soutenu par l’Open Transit Software Foundation.';

  @override
  String get creditsLicenseTitle => 'Licence';

  @override
  String get creditsMapData => 'Données cartographiques';

  @override
  String get creditsLicenses => 'Licences open source';

  @override
  String get creditsLicensesHelp =>
      'Les bibliothèques avec lesquelles cette app est conçue.';

  @override
  String get creditsLicensesLoading => 'Chargement des licences';

  @override
  String creditsLicenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count licences',
      one: '$count licence',
    );
    return '$_temp0';
  }

  @override
  String get onboardingWelcomeFootnote =>
      'Disponible dans des dizaines de régions de transport dans le monde.';

  @override
  String get onboardingBenefitNearbyTitle => 'Voir les arrêts à proximité';

  @override
  String get onboardingBenefitNearbyBody =>
      'Les bus et trains autour de vous, classés par distance.';

  @override
  String get onboardingBenefitMapTitle => 'Centrer la carte sur vous';

  @override
  String get onboardingBenefitMapBody =>
      'Ouvrez directement la carte sur votre environnement, sans rechercher.';

  @override
  String onboardingLocationFootnote(String appName) {
    return '$appName n’utilise votre position que lorsque l’app est ouverte. Vous pouvez modifier ce réglage à tout moment dans les réglages de votre appareil.';
  }

  @override
  String get onboardingLocationDenied =>
      'L’accès à la position est désactivé. Vous pouvez quand même choisir votre région vous-même.';

  @override
  String get onboardingRegionDetected => 'Détectée près de chez vous';

  @override
  String onboardingRegionUse(String name) {
    return 'Utiliser $name';
  }

  @override
  String get onboardingRegionOthers => 'Ou choisissez une autre région';

  @override
  String get onboardingRegionEmpty =>
      'Aucune région n’est disponible pour le moment. Vérifiez votre connexion et réessayez.';

  @override
  String get surveyCardTitle => 'Aidez à améliorer les transports';

  @override
  String get surveyDefaultPrompt =>
      'Répondez à un court sondage pour aider à améliorer les transports.';

  @override
  String get surveyTake => 'Répondre au sondage';

  @override
  String get surveyNotNow => 'Plus tard';

  @override
  String get surveyDismiss => 'Ignorer le sondage';

  @override
  String get surveyNext => 'Suivant';

  @override
  String get surveySubmit => 'Envoyer le sondage';

  @override
  String get surveySubmitting => 'Envoi en cours';

  @override
  String get surveyQuestionsTitle => 'Sondage';

  @override
  String get surveyTextHint => 'Saisissez votre réponse';

  @override
  String get surveyRequired => 'Obligatoire';

  @override
  String get surveyIncomplete =>
      'Veuillez répondre à toutes les questions obligatoires avant d’envoyer.';

  @override
  String get surveyFailed =>
      'Vos réponses n’ont pas pu être envoyées. Veuillez réessayer.';

  @override
  String get surveyThanks => 'Merci pour vos commentaires.';

  @override
  String get surveyOpenSurvey => 'Ouvrir le sondage';

  @override
  String get surveyLearnMore => 'En savoir plus';

  @override
  String get surveyShareFeedback => 'Donner votre avis';

  @override
  String get surveySignUp => 'S’inscrire';

  @override
  String get surveyExternalError =>
      'Ce lien de sondage n’a pas pu être ouvert. Veuillez réessayer plus tard.';

  @override
  String donationTitle(String appName) {
    return '$appName a besoin de votre aide';
  }

  @override
  String get donationBody =>
      'Cette app est développée par des bénévoles, et nous avons besoin de votre aide pour financer son développement futur.';

  @override
  String get donationLearnMore => 'En savoir plus';

  @override
  String get donationDonate => 'Faire un don';

  @override
  String get donationRemindLater => 'Me le rappeler plus tard';

  @override
  String get donationDismiss => 'Non merci';

  @override
  String get donationHeader => 'Pourquoi nous avons besoin de votre aide';

  @override
  String donationExplanation(String appName) {
    return 'Nous avons de grands projets pour améliorer $appName, mais nous ne pouvons pas les réaliser sans votre aide. Cette app est développée par des bénévoles, et nous avons besoin de votre aide pour financer son développement futur.\n\nL’Open Transit Software Foundation, dont ce projet est un élément clé, est une organisation à but non lucratif ; votre don est déductible des impôts aux États-Unis.';
  }

  @override
  String get donationDonateWebsite => 'Faire un don sur notre site web';

  @override
  String titleDonation(String appName) {
    return 'Soutenir $appName';
  }

  @override
  String feedbackTitle(String appName) {
    return 'Vous aimez $appName ?';
  }

  @override
  String get feedbackYes => 'Oui !';

  @override
  String get feedbackNo => 'Pas vraiment';

  @override
  String get feedbackLater => 'Me demander plus tard';

  @override
  String get feedbackNegativeTitle => 'Désolés.';

  @override
  String get feedbackNegativeBody =>
      'Voulez-vous nous dire ce qui ne va pas ? Nous lisons tous les messages.';

  @override
  String get feedbackSend => 'Envoyer un commentaire';

  @override
  String get feedbackDecline => 'Non merci';

  @override
  String get tripPlanningUnavailable =>
      'La planification de trajet n’est pas disponible dans cette région.';

  @override
  String get deepLinkOtherRegion =>
      'Ce lien concerne une autre région. Changez de région pour l’ouvrir.';

  @override
  String get dataUpdated => 'Mis à jour';

  @override
  String get bookmarksEtaNow => 'Maintenant';

  @override
  String bookmarksEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String bookmarksEtaSemantic(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'dans $minutes minutes',
      one: 'dans $minutes minute',
      zero: 'maintenant',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusOnTime => 'À l’heure';

  @override
  String bookmarksStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min de retard',
      one: '$minutes min de retard',
    );
    return '$_temp0';
  }

  @override
  String bookmarksStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min d’avance',
      one: '$minutes min d’avance',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksStatusScheduled => 'Prévu';

  @override
  String get bookmarksStatusCanceled => 'Annulé';

  @override
  String bookmarksDepartureRoute(String route, String headsign) {
    return 'Ligne $route vers $headsign';
  }

  @override
  String bookmarksDepartureRouteOnly(String route) {
    return 'Ligne $route';
  }

  @override
  String bookmarksDepartureSemantics(String route, String eta, String status) {
    return '$route, $eta, $status';
  }

  @override
  String get bookmarksLoadingDepartures => 'Chargement des départs';

  @override
  String get bookmarksNoDepartures => 'Aucun départ à venir';

  @override
  String get bookmarksDeparturesError => 'Impossible de charger les départs';

  @override
  String get bookmarksDeparturesStale =>
      'Actualisation impossible. Affichage des horaires précédents.';

  @override
  String get bookmarksUpdated => 'Départs mis à jour';

  @override
  String get bookmarksSortTooltip => 'Trier les favoris';

  @override
  String get bookmarksSortByGroup => 'Trier par groupe';

  @override
  String get bookmarksSortByDistance => 'Trier par distance';

  @override
  String get bookmarksManageTooltip => 'Modifier les favoris et les groupes';

  @override
  String get bookmarksRefreshTooltip => 'Actualiser les départs';

  @override
  String get bookmarksEmptyTitle => 'Aucun favori pour l’instant';

  @override
  String get bookmarksEmptyBody =>
      'Ouvrez un arrêt et touchez son bouton favori pour l’enregistrer ici. Depuis un départ, vous pouvez aussi ajouter aux favoris uniquement cette ligne à l’arrêt.';

  @override
  String get bookmarksFindStops => 'Trouver des arrêts sur la carte';

  @override
  String get bookmarksUngrouped => 'Sans groupe';

  @override
  String get bookmarksGroupExpanded => 'développé';

  @override
  String get bookmarksGroupCollapsed => 'réduit';

  @override
  String get bookmarksGroupToggleHint =>
      'Affiche ou masque les favoris de ce groupe';

  @override
  String bookmarksActionsFor(String name) {
    return 'Actions pour $name';
  }

  @override
  String get bookmarksActionEdit => 'Modifier';

  @override
  String get bookmarksActionPin => 'Épingler en haut';

  @override
  String get bookmarksActionUnpin => 'Détacher';

  @override
  String get bookmarksActionMove => 'Déplacer vers un groupe';

  @override
  String get bookmarksActionDelete => 'Supprimer';

  @override
  String get bookmarksPinned => 'Épinglé';

  @override
  String bookmarksDeleted(String name) {
    return '$name supprimé';
  }

  @override
  String get bookmarksUndo => 'Annuler';

  @override
  String get bookmarksMoveTitle => 'Déplacer vers un groupe';

  @override
  String get bookmarksNoGroup => 'Aucun groupe';

  @override
  String bookmarksMoved(String group) {
    return 'Déplacé vers $group';
  }

  @override
  String bookmarksStopLine(String name, String details) {
    return '$name, $details';
  }

  @override
  String get bookmarksEditorNameLabel => 'Nom du favori';

  @override
  String get bookmarksEditorNameRequired => 'Saisissez un nom pour ce favori.';

  @override
  String get bookmarksEditorDuplicate =>
      'Vous avez déjà un favori portant ce nom pour cet arrêt et cette ligne. Changez le nom pour en enregistrer un autre.';

  @override
  String bookmarksEditorStopKind(String stop) {
    return 'Favori d’arrêt : affiche les prochains départs de toutes les lignes à $stop.';
  }

  @override
  String bookmarksEditorTripKind(String route, String stop) {
    return 'Favori de trajet : affiche les prochains départs de $route à $stop.';
  }

  @override
  String bookmarksEditorTripOnly(String route) {
    return 'Uniquement $route';
  }

  @override
  String get bookmarksEditorGroup => 'Groupe';

  @override
  String get bookmarksEditorNewGroup => 'Nouveau groupe…';

  @override
  String get bookmarksEditorNewGroupTitle => 'Nouveau groupe';

  @override
  String get bookmarksEditorGroupName => 'Nom du groupe';

  @override
  String get bookmarksEditorSave => 'Enregistrer';

  @override
  String get bookmarksEditorSaved => 'Favori enregistré';

  @override
  String get bookmarksEditorDelete => 'Supprimer le favori';

  @override
  String get bookmarksEditorDeleteTitle => 'Supprimer ce favori ?';

  @override
  String bookmarksEditorDeleteBody(String name) {
    return '« $name » sera retiré de vos favoris.';
  }

  @override
  String get bookmarksEditorNoRegion =>
      'Choisissez une région avant d’ajouter des favoris.';

  @override
  String get bookmarksManageGroupsHeader => 'Groupes';

  @override
  String get bookmarksManageBookmarksHeader => 'Favoris';

  @override
  String get bookmarksManageAddGroup => 'Ajouter un groupe';

  @override
  String get bookmarksManageRenameGroup => 'Renommer le groupe';

  @override
  String get bookmarksManageDeleteGroup => 'Supprimer le groupe';

  @override
  String bookmarksManageDeleteGroupBody(String name) {
    return 'Les favoris de « $name » n’auront plus de groupe.';
  }

  @override
  String bookmarksManageMoveUp(String name) {
    return 'Monter $name';
  }

  @override
  String bookmarksManageMoveDown(String name) {
    return 'Descendre $name';
  }

  @override
  String bookmarksManageReorder(String name) {
    return 'Réorganiser $name';
  }

  @override
  String bookmarksManageMoved(String name, int position, int count) {
    return '$name, position $position sur $count';
  }

  @override
  String get bookmarksManageEmpty =>
      'Il n’y a pas encore de favoris ni de groupes à gérer.';

  @override
  String get bookmarksManageUngrouped => 'Favoris sans groupe';

  @override
  String get recentsEmptyTitle => 'Aucun arrêt récent';

  @override
  String get recentsEmptyBody =>
      'Les arrêts que vous consultez apparaissent ici, les plus récents en premier.';

  @override
  String get recentsFindStops => 'Trouver des arrêts sur la carte';

  @override
  String get recentsClearAll => 'Tout effacer';

  @override
  String get recentsClearTitle => 'Effacer les arrêts récents ?';

  @override
  String recentsClearBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Cela supprime les $count arrêts récents. Vos favoris ne sont pas affectés.',
      one:
          'Cela supprime $count arrêt récent. Vos favoris ne sont pas affectés.',
    );
    return '$_temp0';
  }

  @override
  String recentsRemove(String name) {
    return 'Retirer $name des arrêts récents';
  }

  @override
  String recentsRemoved(String name) {
    return '$name retiré';
  }

  @override
  String get recentsSectionEmpty =>
      'Les arrêts que vous consultez apparaissent ici.';

  @override
  String get alarmsSectionTitle => 'Rappels';

  @override
  String alarmsRowDetails(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes avant le départ',
      one: '$minutes minute avant le départ',
    );
    return '$_temp0, à $time';
  }

  @override
  String alarmsRowLabel(String title, String details) {
    return 'Rappel pour $title, $details';
  }

  @override
  String alarmsDelete(String title) {
    return 'Supprimer le rappel pour $title';
  }

  @override
  String get alarmsDeleted => 'Rappel supprimé';

  @override
  String get alarmsDeleteFailed =>
      'Impossible de supprimer le rappel. Vérifiez votre connexion et réessayez.';

  @override
  String get alarmsOpen => 'Ouvre le trajet';

  @override
  String get alertsEmptyTitle => 'Aucune alerte de service';

  @override
  String get alertsEmptyBody =>
      'Il n’y a aucune alerte de service active pour le moment.';

  @override
  String get alertsRegionNote =>
      'Comprend les alertes de vos arrêts en favoris, récents et à proximité.';

  @override
  String get alertsMarkAllRead => 'Tout marquer comme lu';

  @override
  String get alertsAllRead => 'Toutes les alertes sont marquées comme lues';

  @override
  String get alertsUnread => 'Non lue';

  @override
  String get alertsSeverityInfo => 'Information';

  @override
  String get alertsSeverityWarning => 'Avertissement';

  @override
  String get alertsSeveritySevere => 'Grave';

  @override
  String get alertsSeverityUnknown => 'Alerte de service';

  @override
  String get alertsNoTitle => 'Alerte de service';

  @override
  String alertsRowLabel(String unread, String severity, String title) {
    return '$unread$severity. $title';
  }

  @override
  String get alertsUnreadPrefix => 'Non lue. ';

  @override
  String alertsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count alertes non lues',
      one: '$count alerte non lue',
    );
    return '$_temp0';
  }

  @override
  String alertsSectionMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count autres alertes',
      one: '$count autre alerte',
    );
    return '$_temp0';
  }

  @override
  String get alertsDetailActive => 'Période d’activité';

  @override
  String alertsDetailRange(String start, String end) {
    return 'Du $start au $end';
  }

  @override
  String alertsDetailFrom(String start) {
    return 'À partir du $start';
  }

  @override
  String get alertsDetailAffects => 'Concerne';

  @override
  String get alertsDetailRoutes => 'Lignes';

  @override
  String get alertsDetailStops => 'Arrêts';

  @override
  String get alertsDetailAgencies => 'Agences';

  @override
  String get alertsDetailLearnMore => 'En savoir plus';

  @override
  String get alertsDetailNoDetails => 'Aucun détail supplémentaire disponible.';

  @override
  String alertsDetailUpdated(String date) {
    return 'Publiée le $date';
  }

  @override
  String get alertsCouldNotOpen => 'Impossible d’ouvrir ce lien.';

  @override
  String get agenciesEmptyTitle => 'Aucune agence';

  @override
  String get agenciesEmptyBody =>
      'Cette région ne liste aucune agence de transport.';

  @override
  String get agenciesWebsite => 'Site web';

  @override
  String agenciesPhone(String phone) {
    return 'Appeler le $phone';
  }

  @override
  String agenciesEmail(String email) {
    return 'Écrire à $email';
  }

  @override
  String get agenciesFares => 'Informations sur les tarifs';

  @override
  String get agenciesDisclaimer => 'Avis de non-responsabilité';

  @override
  String get agenciesShowOnMap => 'Afficher la zone desservie sur la carte';

  @override
  String get searchFieldLabel => 'Rechercher';

  @override
  String get searchFieldHint => 'Ligne, numéro d’arrêt, adresse ou véhicule';

  @override
  String get searchClear => 'Effacer la recherche';

  @override
  String get searchScopeLabel => 'Rechercher parmi';

  @override
  String get searchScopeAll => 'Tout';

  @override
  String get searchScopeStops => 'Arrêts';

  @override
  String get searchScopeRoutes => 'Lignes';

  @override
  String get searchScopePlaces => 'Lieux';

  @override
  String get searchQuickHeader => 'Rechercher';

  @override
  String searchQuickRoute(String query) {
    return 'Ligne : $query';
  }

  @override
  String searchQuickStop(String query) {
    return 'Numéro d’arrêt : $query';
  }

  @override
  String searchQuickAddress(String query) {
    return 'Adresse : $query';
  }

  @override
  String searchQuickVehicle(String query) {
    return 'Véhicule : $query';
  }

  @override
  String get searchRecentStopsHeader => 'Arrêts récents';

  @override
  String get searchBookmarksHeader => 'Favoris';

  @override
  String get searchRecentSearchesHeader => 'Recherches récentes';

  @override
  String get searchRecentPlacesHeader => 'Lieux récents';

  @override
  String get searchPlacesHeader => 'Lieux';

  @override
  String get searchClearRecent => 'Effacer les recherches récentes';

  @override
  String get searchClearRecentConfirm =>
      'Effacer vos recherches et lieux récents ?';

  @override
  String get searchClearAction => 'Effacer';

  @override
  String get searchRecentCleared => 'Recherches récentes effacées';

  @override
  String get searchPlacesLoading => 'Recherche de lieux';

  @override
  String get searchPlacesNone => 'Aucun lieu trouvé';

  @override
  String get searchPlacesError =>
      'Impossible de rechercher des lieux. Vérifiez votre connexion.';

  @override
  String get searchSearching => 'Recherche en cours';

  @override
  String get searchNoResultsTitle => 'Aucun résultat';

  @override
  String searchNoResultsBody(String query) {
    return 'Aucun résultat trouvé pour « $query ».';
  }

  @override
  String get searchUnavailableNoRegion =>
      'Choisissez une région avant de rechercher.';

  @override
  String get searchUnavailableAddress =>
      'La recherche d’adresse n’est pas configurée dans cette app.';

  @override
  String get searchUnavailableVehicle =>
      'La recherche de véhicule n’est pas disponible dans cette région.';

  @override
  String get searchEmptyTitle => 'Trouvez des lignes, des arrêts et des lieux';

  @override
  String get searchEmptyBody =>
      'Saisissez le nom d’une ligne, un numéro d’arrêt, une adresse ou un identifiant de véhicule.';

  @override
  String get searchDismissMessage => 'Fermer';

  @override
  String searchResultsHeading(int count, String query) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats pour « $query »',
      one: '$count résultat pour « $query »',
    );
    return '$_temp0';
  }

  @override
  String get searchResultsRoutes => 'Lignes';

  @override
  String get searchResultsStops => 'Arrêts';

  @override
  String get searchResultsVehicles => 'Véhicules';

  @override
  String get searchResultsPlaces => 'Lieux';

  @override
  String searchRouteRowLabel(String name, String details) {
    return 'Ligne $name, $details';
  }

  @override
  String searchVehicleTitle(String id) {
    return 'Véhicule $id';
  }

  @override
  String searchVehicleNoTrip(String id) {
    return 'Le véhicule $id n’effectue aucun trajet pour le moment.';
  }

  @override
  String searchVehicleLoading(String id) {
    return 'Chargement du véhicule $id';
  }

  @override
  String get searchNearbyLocationPrompt =>
      'Activez la localisation pour voir les départs des arrêts près de chez vous.';

  @override
  String get searchNearbyLocationButton => 'Utiliser ma position';

  @override
  String get searchNearbyLocationDenied =>
      'L’accès à la position est désactivé. Activez-le dans les réglages de votre appareil pour voir les arrêts près de chez vous.';

  @override
  String get searchNearbyLocationServicesOff =>
      'Les services de localisation sont désactivés. Activez-les pour voir les arrêts près de chez vous.';

  @override
  String get searchNearbyLocationUnavailable =>
      'Cette application n\'utilise pas votre position et ne peut donc pas afficher les arrêts près de chez vous.';

  @override
  String get searchNearbyEmpty => 'Aucun arrêt à proximité';

  @override
  String get searchNearbyEmptyBody =>
      'Il n’y a aucun arrêt à distance de marche.';

  @override
  String get searchNearbyMapCenter => 'Arrêts proches du centre de la carte.';

  @override
  String get searchNearbyNoDepartures => 'Aucun départ dans l’heure qui vient';

  @override
  String get searchNearbyLoadingDepartures => 'Chargement des départs';

  @override
  String get searchNearbyUpdated => 'Départs à proximité mis à jour';

  @override
  String searchNearbyStopsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arrêts à proximité',
      one: '$count arrêt à proximité',
      zero: 'Aucun arrêt à proximité',
    );
    return '$_temp0';
  }

  @override
  String get searchNearbyLocating => 'Recherche de votre position…';

  @override
  String get searchNearbyRefresh => 'Actualiser';

  @override
  String searchNearbyDistance(String distance) {
    return 'À $distance';
  }

  @override
  String get searchNearbyOtherDirection => 'Autres arrêts';

  @override
  String searchNearbyDirectionHeader(String direction) {
    return 'Arrêts $direction';
  }

  @override
  String searchNearbyDepartureLabel(
    String route,
    String headsign,
    String eta,
    String status,
    String stop,
  ) {
    return '$route vers $headsign, $eta, $status. Depuis $stop';
  }

  @override
  String searchNearbyStopFrom(String stop) {
    return 'Depuis $stop';
  }

  @override
  String get searchNearbyCardTitle => 'Départs près de chez vous';

  @override
  String searchEtaMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get searchEtaNow => 'Maintenant';

  @override
  String searchEtaMinutesSpoken(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'dans $minutes minutes',
      one: 'dans $minutes minute',
    );
    return '$_temp0';
  }

  @override
  String get searchEtaNowSpoken => 'part maintenant';

  @override
  String get searchStatusOnTime => 'À l’heure';

  @override
  String searchStatusLate(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min de retard',
      one: '$minutes min de retard',
    );
    return '$_temp0';
  }

  @override
  String searchStatusEarly(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min d’avance',
      one: '$minutes min d’avance',
    );
    return '$_temp0';
  }

  @override
  String get searchStatusScheduled => 'Prévu';

  @override
  String get searchExplorePlanTrip => 'Planifier un trajet';

  @override
  String get searchExploreWeather => 'Météo';

  @override
  String get searchExploreAgencies => 'Agences';

  @override
  String get searchPlaceAddress => 'Adresse';

  @override
  String get searchPlaceCoordinates => 'Coordonnées';

  @override
  String get searchPlaceDistance => 'Distance';

  @override
  String get searchPlaceDirectionsTo => 'Itinéraire jusqu’ici';

  @override
  String get searchPlaceDirectionsFrom => 'Itinéraire depuis ici';

  @override
  String get searchPlaceNearbyStops => 'Arrêts à proximité';

  @override
  String get searchPlaceShare => 'Partager';

  @override
  String get searchPlaceOpenInMaps => 'Ouvrir dans une app de cartes';

  @override
  String get searchPlaceRemovePin => 'Supprimer le repère';

  @override
  String get searchPlaceOpenFailed => 'Impossible d’ouvrir une app de cartes.';

  @override
  String get searchPlaceShareFailed => 'Impossible de partager ce lieu.';

  @override
  String searchPlaceMarkerLabel(String name) {
    return 'Lieu : $name';
  }

  @override
  String searchWeatherButtonLabel(String temperature, String condition) {
    return 'Météo : $temperature, $condition';
  }

  @override
  String get searchWeatherButtonHint => 'Affiche les prévisions';

  @override
  String get searchWeatherClear => 'Dégagé';

  @override
  String get searchWeatherPartlyCloudy => 'Partiellement nuageux';

  @override
  String get searchWeatherCloudy => 'Nuageux';

  @override
  String get searchWeatherRain => 'Pluie';

  @override
  String get searchWeatherSleet => 'Pluie verglaçante';

  @override
  String get searchWeatherSnow => 'Neige';

  @override
  String get searchWeatherWindy => 'Venteux';

  @override
  String get searchWeatherFog => 'Brouillard';

  @override
  String get searchWeatherUnknown => 'Conditions inconnues';

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
      other: '$value degrés Fahrenheit',
      one: '$value degré Fahrenheit',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherSpokenC(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: '$value degrés Celsius',
      one: '$value degré Celsius',
    );
    return '$_temp0';
  }

  @override
  String searchWeatherMph(int value) {
    return '$value mi/h';
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
  String get searchWeatherFeelsLike => 'Ressenti';

  @override
  String get searchWeatherWind => 'Vent';

  @override
  String get searchWeatherPrecip => 'Risque de pluie';

  @override
  String searchWeatherHighLow(String high, String low) {
    return 'Max $high · Min $low';
  }

  @override
  String searchWeatherHighLowSpoken(String high, String low) {
    return 'Maximum $high, minimum $low, au cours des prochaines 24 heures';
  }

  @override
  String get searchWeatherHourly => 'Prochaines 24 heures';

  @override
  String get searchWeatherNow => 'Maintenant';

  @override
  String searchWeatherHourLabel(
    String time,
    String temperature,
    String condition,
    String precip,
  ) {
    return '$time : $temperature, $condition, $precip de risque de pluie';
  }

  @override
  String searchWeatherUnitsNote(String unit) {
    return 'Températures en $unit';
  }

  @override
  String get searchWeatherFahrenheit => 'degrés Fahrenheit (°F)';

  @override
  String get searchWeatherCelsius => 'degrés Celsius (°C)';

  @override
  String searchWeatherUpdated(String time) {
    return 'Prévisions de $time';
  }

  @override
  String get searchWeatherUnavailable =>
      'La météo n’est pas disponible pour cette région.';

  @override
  String get searchWeatherSummaryLabel => 'Aujourd’hui';

  @override
  String get bookmarksSectionEmpty => 'Les arrêts en favoris apparaissent ici.';

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
  String get coreDirectionNameSW => 'Sud-ouest';

  @override
  String get coreDirectionNameW => 'Ouest';

  @override
  String get coreDirectionNameNW => 'Nord-ouest';

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
  String get coreDirectionBoundN => 'Direction nord';

  @override
  String get coreDirectionBoundNE => 'Direction NE';

  @override
  String get coreDirectionBoundE => 'Direction est';

  @override
  String get coreDirectionBoundSE => 'Direction SE';

  @override
  String get coreDirectionBoundS => 'Direction sud';

  @override
  String get coreDirectionBoundSW => 'Direction SO';

  @override
  String get coreDirectionBoundW => 'Direction ouest';

  @override
  String get coreDirectionBoundNW => 'Direction NO';

  @override
  String get coreRouteTypeLightRail => 'Tramway';

  @override
  String get coreRouteTypeSubway => 'Métro';

  @override
  String get coreRouteTypeRail => 'Train';

  @override
  String get coreRouteTypeBus => 'Bus';

  @override
  String get coreRouteTypeFerry => 'Ferry';

  @override
  String get coreRouteTypeCableCar => 'Tramway à câble';

  @override
  String get coreRouteTypeGondola => 'Télécabine';

  @override
  String get coreRouteTypeFunicular => 'Funiculaire';

  @override
  String coreStopCodeNumeric(String code) {
    return 'Arrêt n° $code';
  }

  @override
  String coreStopCodeNonNumeric(String code) {
    return 'Arrêt : \'$code\'';
  }

  @override
  String coreStopId(String code) {
    return 'ID de l’arrêt : $code';
  }

  @override
  String coreRoutesLabel(String routes) {
    return 'Lignes : $routes';
  }

  @override
  String coreRoutesLabelPlusMore(String routes, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lignes : $routes, + $count autres',
    );
    return '$_temp0';
  }

  @override
  String coreMapRoutesOverflow(String routes) {
    return '$routes…';
  }

  @override
  String coreSearchPlaceholder(String region) {
    return 'Rechercher dans $region';
  }

  @override
  String get coreNow => 'MAINTENANT';

  @override
  String coreShortMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get coreOneMinute => 'Une minute';

  @override
  String get coreOneMinuteAgo => 'Il y a une minute';

  @override
  String coreMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
    );
    return '$_temp0';
  }

  @override
  String get coreJustNow => 'À l’instant';

  @override
  String coreSecondsAgo(int seconds) {
    return 'il y a $seconds s';
  }

  @override
  String coreMinutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String coreHoursAgo(int hours) {
    return 'il y a $hours h';
  }

  @override
  String coreDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'il y a $days jours',
      one: 'il y a $days jour',
    );
    return '$_temp0';
  }

  @override
  String coreUpdatedAt(String ago) {
    return 'Mis à jour : $ago';
  }

  @override
  String get coreScheduledNotRealTime => 'Horaire théorique, pas en temps réel';

  @override
  String coreArrivedMinAgo(int minutes) {
    return 'Arrivé il y a $minutes min';
  }

  @override
  String coreDepartedMinAgo(int minutes) {
    return 'Parti il y a $minutes min';
  }

  @override
  String get coreArrivingNow => 'Arrive maintenant';

  @override
  String get coreDepartingNow => 'Part maintenant';

  @override
  String coreArrivesInMin(int minutes) {
    return 'Arrive dans $minutes min';
  }

  @override
  String coreDepartsInMin(int minutes) {
    return 'Part dans $minutes min';
  }

  @override
  String coreArrivedLate(int minutes) {
    return 'arrivé avec $minutes min de retard';
  }

  @override
  String coreArrivedEarly(int minutes) {
    return 'arrivé avec $minutes min d’avance';
  }

  @override
  String get coreArrivedOnTime => 'arrivé à l’heure';

  @override
  String coreDepartedLate(int minutes) {
    return 'parti avec $minutes min de retard';
  }

  @override
  String coreDepartedEarly(int minutes) {
    return 'parti avec $minutes min d’avance';
  }

  @override
  String get coreDepartedOnTime => 'parti à l’heure';

  @override
  String coreArrivesLate(int minutes) {
    return 'arrive avec $minutes min de retard';
  }

  @override
  String coreArrivesEarly(int minutes) {
    return 'arrive avec $minutes min d’avance';
  }

  @override
  String get coreArrivesOnTime => 'arrive à l’heure';

  @override
  String coreDepartsLate(int minutes) {
    return 'part avec $minutes min de retard';
  }

  @override
  String coreDepartsEarly(int minutes) {
    return 'part avec $minutes min d’avance';
  }

  @override
  String get coreDepartsOnTime => 'part à l’heure';

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
      other: '$minutes minutes',
      one: '$minutes minute',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsNow => 'maintenant';

  @override
  String arrivalsMinutesCompact(int minutes) {
    return '$minutes min';
  }

  @override
  String get arrivalsCanceled => 'annulé';

  @override
  String arrivalsEveryMinutesFrom(int minutes, String time) {
    return 'toutes les $minutes min à partir de $time';
  }

  @override
  String arrivalsEveryMinutesUntil(int minutes, String time) {
    return 'toutes les $minutes min jusqu’à $time';
  }

  @override
  String get arrivalsDirectionBoundN => 'Direction nord';

  @override
  String get arrivalsDirectionBoundNE => 'Direction nord-est';

  @override
  String get arrivalsDirectionBoundE => 'Direction est';

  @override
  String get arrivalsDirectionBoundSE => 'Direction sud-est';

  @override
  String get arrivalsDirectionBoundS => 'Direction sud';

  @override
  String get arrivalsDirectionBoundSW => 'Direction sud-ouest';

  @override
  String get arrivalsDirectionBoundW => 'Direction ouest';

  @override
  String get arrivalsDirectionBoundNW => 'Direction nord-ouest';

  @override
  String arrivalsDirectionBoundOther(String code) {
    return 'Direction $code';
  }

  @override
  String get arrivalsRefresh => 'Actualiser les arrivées';

  @override
  String get arrivalsRetry => 'Réessayer';

  @override
  String arrivalsNoArrivals(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Aucune arrivée dans les $minutes prochaines minutes',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsStopNotFound =>
      'Arrêt introuvable ou service indisponible';

  @override
  String get arrivalsNetworkError =>
      'Impossible de joindre le serveur de transport. Vérifiez votre connexion.';

  @override
  String get arrivalsLoadError => 'Impossible de charger les arrivées.';

  @override
  String arrivalsStaleNotice(String time) {
    return 'Actualisation impossible. Affichage des résultats de $time';
  }

  @override
  String get arrivalsArrivingNow => 'arrive maintenant';

  @override
  String arrivalsArrivingInMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'arrive dans $minutes minutes',
      one: 'arrive dans $minutes minute',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsRealtime => 'en temps réel';

  @override
  String get arrivalsRowTapHint => 'afficher les détails';

  @override
  String arrivalsAtTime(String time) {
    return 'à $time';
  }

  @override
  String arrivalsMinutesLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes de retard',
      one: '$minutes minute de retard',
    );
    return '$_temp0';
  }

  @override
  String arrivalsMinutesEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes d’avance',
      one: '$minutes minute d’avance',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesFromSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'toutes les $minutes minutes à partir de $time',
    );
    return '$_temp0';
  }

  @override
  String arrivalsEveryMinutesUntilSemantics(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'toutes les $minutes minutes jusqu’à $time',
    );
    return '$_temp0';
  }

  @override
  String get arrivalsScheduledSemantics => 'horaire théorique';

  @override
  String get arrivalsLoading => 'Chargement des arrivées';

  @override
  String get arrivalsRefreshing => 'Actualisation des arrivées';

  @override
  String get arrivalsUpdated => 'Arrivées mises à jour';

  @override
  String get tripPlannerOriginLabel => 'De';

  @override
  String get tripPlannerDestinationLabel => 'À';

  @override
  String get tripPlannerChooseOrigin => 'Choisir le point de départ';

  @override
  String get tripPlannerChooseDestination => 'Choisir la destination';

  @override
  String get tripPlannerCurrentLocation => 'Position actuelle';

  @override
  String get tripPlannerSwapEndpoints => 'Inverser le départ et la destination';

  @override
  String get tripPlannerPlanTrip => 'Planifier le trajet';

  @override
  String get tripPlannerPlanningTrip => 'Planification de votre trajet';

  @override
  String get tripPlannerOptions => 'Options du trajet';

  @override
  String get tripPlannerLeaveNow => 'Partir maintenant';

  @override
  String get tripPlannerDepartAt => 'Partir à';

  @override
  String get tripPlannerArriveBy => 'Arriver avant';

  @override
  String tripPlannerChangeTime(String dateTime) {
    return 'Modifier l’heure, $dateTime';
  }

  @override
  String get tripPlannerModeTransit => 'Transports en commun';

  @override
  String get tripPlannerModeWalk => 'À pied';

  @override
  String get tripPlannerModeBike => 'Vélo';

  @override
  String get tripPlannerModeCar => 'Voiture';

  @override
  String get tripPlannerModeBikeRental => 'Vélo en libre-service uniquement';

  @override
  String get tripPlannerModeTransitBikeRental =>
      'Transports + vélo en libre-service';

  @override
  String get tripPlannerWheelchairAccessible =>
      'Accessible en fauteuil roulant';

  @override
  String get tripPlannerWalkQuarterMile => '0,25 mile';

  @override
  String get tripPlannerWalkHalfMile => '0,5 mile';

  @override
  String get tripPlannerWalkOneMile => '1 mile';

  @override
  String get tripPlannerWalkTwoMiles => '2 miles';

  @override
  String tripPlannerMaxWalk(String distance) {
    return 'Marcher jusqu’à $distance';
  }

  @override
  String get tripPlannerNoTripsFound => 'Aucun trajet trouvé';

  @override
  String get tripPlannerRetry => 'Réessayer';

  @override
  String get tripPlannerRealTime => 'Temps réel';

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
      other: '$count correspondances',
      one: '$count correspondance',
      zero: 'Aucune correspondance',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerWalkDistance(String distance) {
    return 'Marche : $distance';
  }

  @override
  String tripPlannerDepartsAt(String time, String place) {
    return 'Départ à $time de $place';
  }

  @override
  String get tripPlannerStatusOnTime => 'À l’heure';

  @override
  String tripPlannerStatusLate(int minutes) {
    return '$minutes min de retard';
  }

  @override
  String tripPlannerStatusEarly(int minutes) {
    return '$minutes min d’avance';
  }

  @override
  String get tripPlannerStatusScheduled => 'Prévu';

  @override
  String get tripPlannerLegBus => 'Bus';

  @override
  String get tripPlannerLegTram => 'Tramway';

  @override
  String get tripPlannerLegSubway => 'Métro';

  @override
  String get tripPlannerLegRail => 'Train';

  @override
  String get tripPlannerLegFerry => 'Ferry';

  @override
  String get tripPlannerLegCableCar => 'Tramway à câble';

  @override
  String get tripPlannerLegGondola => 'Télécabine';

  @override
  String get tripPlannerLegFunicular => 'Funiculaire';

  @override
  String get tripPlannerLegAirplane => 'Avion';

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
    return 'Marche pendant $duration';
  }

  @override
  String tripPlannerLegBikeSemantics(String duration) {
    return 'Vélo pendant $duration';
  }

  @override
  String tripPlannerLegRentalBikeSemantics(String duration) {
    return 'Vélo en libre-service pendant $duration';
  }

  @override
  String tripPlannerLegCarSemantics(String duration) {
    return 'Voiture pendant $duration';
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
  String get tripPlannerThen => 'puis';

  @override
  String get tripPlannerOpenItineraryHint => 'afficher les détails du trajet';

  @override
  String tripPlannerMinutesSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '$minutes minute',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHoursSemantics(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours heures',
      one: '$hours heure',
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
      other: '$value pieds',
      one: '$value pied',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMilesSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value miles',
      one: '$value mile',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerMetersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value mètres',
      one: '$value mètre',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerKilometersSemantics(num count, String value) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$value kilomètres',
      one: '$value kilomètre',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerTimeRangeSemantics(String start, String end) {
    return 'de $start à $end';
  }

  @override
  String get tripPlannerStatusOnTimeSemantics => 'en temps réel, à l’heure';

  @override
  String tripPlannerStatusLateSemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'en temps réel, $minutes minutes de retard',
      one: 'en temps réel, $minutes minute de retard',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStatusEarlySemantics(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'en temps réel, $minutes minutes d’avance',
      one: 'en temps réel, $minutes minute d’avance',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerStatusScheduledSemantics => 'horaire théorique';

  @override
  String get tripPlannerResultsHeading => 'Trajets suggérés';

  @override
  String tripPlannerTripsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trajets trouvés',
      one: '$count trajet trouvé',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerPlacesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lieux trouvés',
      one: '$count lieu trouvé',
    );
    return '$_temp0';
  }

  @override
  String get tripPlannerMapSemanticsLabel =>
      'Carte du trajet. Les indications ci-dessous décrivent le même trajet.';

  @override
  String get tripPlannerTripDetails => 'Détails du trajet';

  @override
  String get tripPlannerMapLabel => 'Carte du trajet';

  @override
  String get tripPlannerStart => 'Départ';

  @override
  String get tripPlannerDestination => 'Destination';

  @override
  String get tripPlannerUnnamedPlace => 'Lieu sans nom';

  @override
  String get tripPlannerRentalBike => 'Vélo en libre-service';

  @override
  String tripPlannerWalkTo(String place) {
    return 'Marcher jusqu’à $place';
  }

  @override
  String tripPlannerBikeTo(String place) {
    return 'Rouler à vélo jusqu’à $place';
  }

  @override
  String tripPlannerRideRentalBikeTo(String place) {
    return 'Rouler en vélo en libre-service jusqu’à $place';
  }

  @override
  String tripPlannerDriveTo(String place) {
    return 'Conduire jusqu’à $place';
  }

  @override
  String tripPlannerBoard(String mode) {
    return 'Prendre : $mode';
  }

  @override
  String tripPlannerBoardRoute(String mode, String route) {
    return 'Prendre : $mode $route';
  }

  @override
  String tripPlannerBoardHeadsign(String mode, String headsign) {
    return 'Prendre : $mode direction $headsign';
  }

  @override
  String tripPlannerBoardRouteHeadsign(
    String mode,
    String route,
    String headsign,
  ) {
    return 'Prendre : $mode $route direction $headsign';
  }

  @override
  String tripPlannerGetOffAt(String place) {
    return 'Descendre à $place';
  }

  @override
  String tripPlannerArriveAt(String place) {
    return 'Arriver à $place';
  }

  @override
  String tripPlannerStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arrêts',
      one: '$count arrêt',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Afficher $count arrêts',
      one: 'Afficher $count arrêt',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideStops(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Masquer $count arrêts',
      one: 'Masquer $count arrêt',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerStepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count étapes',
      one: '$count étape',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerShowSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Afficher $count étapes',
      one: 'Afficher $count étape',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerHideSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Masquer $count étapes',
      one: 'Masquer $count étape',
    );
    return '$_temp0';
  }

  @override
  String tripPlannerLegDistanceDuration(String distance, String duration) {
    return '$distance, environ $duration';
  }

  @override
  String get tripPlannerDirectionDepart => 'Partez';

  @override
  String get tripPlannerDirectionHardLeft => 'Tournez franchement à gauche';

  @override
  String get tripPlannerDirectionLeft => 'Tournez à gauche';

  @override
  String get tripPlannerDirectionSlightlyLeft => 'Tournez légèrement à gauche';

  @override
  String get tripPlannerDirectionContinue => 'Continuez';

  @override
  String get tripPlannerDirectionSlightlyRight => 'Tournez légèrement à droite';

  @override
  String get tripPlannerDirectionRight => 'Tournez à droite';

  @override
  String get tripPlannerDirectionHardRight => 'Tournez franchement à droite';

  @override
  String get tripPlannerDirectionCircleClockwise =>
      'Entrez dans le rond-point dans le sens horaire';

  @override
  String get tripPlannerDirectionCircleCounterclockwise =>
      'Entrez dans le rond-point dans le sens antihoraire';

  @override
  String get tripPlannerDirectionElevator => 'Prenez l’ascenseur';

  @override
  String get tripPlannerDirectionUturnLeft => 'Faites demi-tour par la gauche';

  @override
  String get tripPlannerDirectionUturnRight => 'Faites demi-tour par la droite';

  @override
  String get tripPlannerDirectionEnterStation => 'Entrez dans la station';

  @override
  String get tripPlannerDirectionExitStation => 'Sortez de la station';

  @override
  String get tripPlannerDirectionFollowSigns => 'Suivez les panneaux';

  @override
  String tripPlannerStepAlong(String street, String distance) {
    return 'Marchez le long de $street sur $distance.';
  }

  @override
  String tripPlannerStepTurn(String direction, String street, String distance) {
    return '$direction sur $street, marchez $distance.';
  }

  @override
  String get tripPlannerSearchHint => 'Rechercher un lieu';

  @override
  String get tripPlannerSearchNoResults => 'Aucun lieu trouvé';

  @override
  String get tripPlannerSearchError =>
      'Impossible de rechercher des lieux. Réessayez.';

  @override
  String get tripPlannerUseCurrentLocation => 'Utiliser la position actuelle';

  @override
  String get tripPlannerLocationUnavailable =>
      'Impossible d’obtenir votre position.';

  @override
  String get tripPlannerClearSearch => 'Effacer la recherche';

  @override
  String get tripPlannerErrorMissingEndpoints =>
      'Veuillez sélectionner le lieu de départ et la destination.';

  @override
  String get tripPlannerErrorNetwork =>
      'Impossible de joindre le planificateur de trajet. Vérifiez votre connexion.';

  @override
  String get tripPlannerErrorInvalidResponse =>
      'Le serveur a renvoyé une réponse invalide';

  @override
  String get tripPlannerErrorUnknown => 'Une erreur inconnue s’est produite.';

  @override
  String get tripPlannerPlannerSystemError =>
      'Nous n’avons pas pu planifier votre trajet pour le moment. Veuillez réessayer.';

  @override
  String get tripPlannerPlannerGraphUnavailable =>
      'La planification de trajet est temporairement indisponible. Réessayez dans un instant.';

  @override
  String get tripPlannerPlannerOutsideBounds =>
      'Ce lieu n’est pas encore pris en charge.';

  @override
  String get tripPlannerPlannerPathNotFound =>
      'Aucun itinéraire n’est disponible pour ce trajet.';

  @override
  String get tripPlannerPlannerNoTransitTimes =>
      'Aucune option de transport en commun n’est disponible pour le moment.';

  @override
  String get tripPlannerPlannerRequestTimeout =>
      'Cela a pris plus de temps que prévu. Veuillez réessayer.';

  @override
  String get tripPlannerPlannerBogusParameter =>
      'Un problème est survenu avec la requête. Veuillez réessayer.';

  @override
  String get tripPlannerPlannerGeocodeFromNotFound =>
      'Nous n’avons pas trouvé le lieu de départ.';

  @override
  String get tripPlannerPlannerGeocodeToNotFound =>
      'Nous n’avons pas trouvé la destination.';

  @override
  String get tripPlannerPlannerGeocodeFromToNotFound =>
      'Nous n’avons trouvé ni le point de départ ni la destination.';

  @override
  String get tripPlannerPlannerTooClose =>
      'Le départ et la destination sont trop proches.';

  @override
  String get tripPlannerPlannerLocationNotAccessible =>
      'Cet itinéraire n’est pas accessible avec l’option sélectionnée.';

  @override
  String get tripPlannerPlannerGeocodeFromAmbiguous =>
      'Le lieu de départ n’est pas clair. Essayez d’être plus précis.';

  @override
  String get tripPlannerPlannerGeocodeToAmbiguous =>
      'La destination n’est pas claire. Essayez d’être plus précis.';

  @override
  String get tripPlannerPlannerGeocodeFromToAmbiguous =>
      'Les deux lieux doivent être plus détaillés. Essayez de les préciser.';

  @override
  String get tripPlannerPlannerUnderspecifiedTriangle =>
      'Certaines options d’itinéraire sont manquantes.';

  @override
  String get tripPlannerPlannerTriangleNotAffine =>
      'Les options d’itinéraire sélectionnées sont incompatibles entre elles.';

  @override
  String get tripPlannerPlannerTriangleOptimizeTypeNotSet =>
      'Veuillez choisir une préférence d’itinéraire.';

  @override
  String get tripPlannerPlannerTriangleValuesNotSet =>
      'Veuillez ajuster les préférences d’itinéraire.';
}
