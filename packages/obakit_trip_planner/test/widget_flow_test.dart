import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

import 'support/fixtures.dart';

Future<void> _pump(
  WidgetTester tester, {
  required TripPlanService service,
  FakeTripPlaceSearch? search,
  CurrentLocationProvider? currentLocation,
  TripPlace? origin,
  TripPlace? destination,
  ThemeData? theme,
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: Scaffold(
        body: TripPlannerView(
          service: service,
          placeSearch: search ?? FakeTripPlaceSearch(),
          mapConfig: testMapConfig(),
          currentLocation: currentLocation,
          initialOrigin: origin,
          initialDestination: destination,
          distanceUnits: DistanceUnits.imperial,
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('form → results → detail', (tester) async {
    final handle = tester.ensureSemantics();
    final search = FakeTripPlaceSearch();
    final service = FakeTripPlanService(result: sdPlan());
    await _pump(
      tester,
      service: service,
      search: search,
      currentLocation: () async => here,
    );

    // The empty origin is filled with the current location.
    expect(find.bySemanticsLabel('From: Current Location'), findsOneWidget);
    expect(find.bySemanticsLabel('To: Choose destination'), findsOneWidget);

    // Pick the destination through the host's search.
    await tester.tap(find.bySemanticsLabel('To: Choose destination'));
    await tester.pumpAndSettle();
    expect(find.text('Use current location'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'horton');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(search.queries, ['horton']);
    expect(search.nears.single, here);
    await tester.tap(find.text('Horton Plaza'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('To: Horton Plaza'), findsOneWidget);

    // Plan.
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    final request = service.requests.single;
    expect(request.origin, here.coordinate);
    expect(request.destination, downtown.coordinate);
    expect(find.byType(ItineraryCard), findsWidgets);
    expect(
      find.bySemanticsLabel(
        RegExp(
          r'^9:04 AM to 9:46 AM, 41 minutes\. '
          r'Walk \d+ minutes?, then Tram Blue, \d+ minutes',
        ),
      ),
      findsOneWidget,
    );
    expect(find.text('Blue'), findsWidgets);

    // Open the first itinerary.
    await tester.tap(find.byType(ItineraryCard).first);
    await tester.pumpAndSettle();
    expect(find.text('Trip details'), findsOneWidget);
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'^Map of the trip\. The directions below')),
      findsOneWidget,
    );
    expect(find.text('Take Tram Blue toward San Ysidro'), findsOneWidget);
    expect(
      find.text('Departs 9:09 AM from UCSD Central Campus Station'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(find.text('Show 12 stops'), 100);
    await tester.tap(find.text('Show 12 stops'));
    await tester.pumpAndSettle();
    expect(find.text('Hide 12 stops'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Arrive at Horton Plaza'), 100);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Trip details'), findsNothing);
    expect(find.byType(ItineraryCard), findsWidgets);
    handle.dispose();
  });

  testWidgets('the detail page outlives the planner that opened it', (
    tester,
  ) async {
    // A host (the obakit sheet) can pop the planner while its detail
    // route is still on the navigator; the detail must not reach back into
    // the planner's deactivated context when it rebuilds.
    final navKey = GlobalKey<NavigatorState>();
    final scale = ValueNotifier(1.0);
    late Route<void> plannerRoute;
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ValueListenableBuilder<double>(
        valueListenable: scale,
        builder: (context, s, _) => MaterialApp(
          navigatorKey: navKey,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(s)),
            child: child!,
          ),
          home: const Scaffold(body: Text('host')),
        ),
      ),
    );
    plannerRoute = MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        body: TripPlannerView(
          service: FakeTripPlanService(result: sdPlan()),
          placeSearch: FakeTripPlaceSearch(),
          mapConfig: testMapConfig(),
          initialOrigin: here,
          initialDestination: downtown,
        ),
      ),
    );
    navKey.currentState!.push(plannerRoute);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    await tester.tap(find.byType(ItineraryCard).first);
    await tester.pumpAndSettle();
    expect(find.text('Trip details'), findsOneWidget);
    navKey.currentState!.removeRoute(plannerRoute);
    await tester.pumpAndSettle();
    scale.value = 1.5; // rebuilds the detail route
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Trip details'), findsOneWidget);
  });

  testWidgets('shows a spinner while loading', (tester) async {
    final service = FakeTripPlanService();
    await _pump(tester, service: service, origin: ucsd, destination: downtown);
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    service.complete(stPlan());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ItineraryCard), findsWidgets);
  });

  testWidgets('network errors offer a retry', (tester) async {
    final service = FakeTripPlanService()
      ..error = const OtpNetworkException('offline');
    await _pump(tester, service: service, origin: ucsd, destination: downtown);
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    expect(
      find.text("Couldn't reach the trip planner. Check your connection."),
      findsOneWidget,
    );

    service
      ..error = null
      ..result = sdPlan();
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(find.byType(ItineraryCard), findsWidgets);
  });

  testWidgets('a planner "no route" answer has no retry', (tester) async {
    final service = FakeTripPlanService()
      ..error = const OtpPlannerException(PlannerErrorCode.pathNotFound, 'no');
    await _pump(tester, service: service, origin: ucsd, destination: downtown);
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    expect(find.text('No route is available for this trip.'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('planning without a destination explains why', (tester) async {
    final service = FakeTripPlanService(result: sdPlan());
    await _pump(tester, service: service, origin: ucsd);
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    expect(
      find.text('Please select both origin and destination locations.'),
      findsOneWidget,
    );
    expect(service.requests, isEmpty);
  });

  testWidgets('an empty plan says no trips were found', (tester) async {
    final service = FakeTripPlanService(
      result: parseRestPlanResponse(
        fixtureJson('rest/otp_response_empty.json'),
      ),
    );
    await _pump(tester, service: service, origin: ucsd, destination: downtown);
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    expect(find.text('No trips found'), findsOneWidget);
  });

  testWidgets('swap, mode, time and option controls drive the request', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final service = FakeTripPlanService(result: sdPlan());
    await _pump(tester, service: service, origin: ucsd, destination: downtown);

    await tester.tap(find.byTooltip('Swap starting point and destination'));
    await tester.pump();
    expect(find.bySemanticsLabel('From: Horton Plaza'), findsOneWidget);
    expect(find.bySemanticsLabel('To: Geisel Library'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Bike'));
    await tester.tap(find.widgetWithText(FilterChip, 'Wheelchair accessible'));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Arrive by'));
    await tester.pump();
    expect(find.byIcon(Icons.schedule), findsOneWidget);

    await tester.tap(find.text('Walk up to 1 mile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('0.5 mile').last);
    await tester.pumpAndSettle();
    expect(find.text('Walk up to 0.5 mile'), findsOneWidget);

    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    final request = service.requests.single;
    expect(request.origin, downtown.coordinate);
    expect(request.transportModes, [TransportMode.bike, TransportMode.walk]);
    expect(request.wheelchairAccessible, isTrue);
    expect(request.arriveBy, isTrue);
    expect(request.maxWalkDistance, 805);
    handle.dispose();
  });

  testWidgets('dark theme and 2x text render without overflow', (tester) async {
    final service = FakeTripPlanService(result: stPlan());
    await _pump(
      tester,
      service: service,
      origin: ucsd,
      destination: downtown,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      textScale: 2,
    );
    await tester.tap(find.text('Plan trip'));
    await tester.pump();
    await tester.scrollUntilVisible(find.text('Suggested trips'), 200);
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pump();
    expect(find.byType(ItineraryCard), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byType(ItineraryCard).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ItineraryCard).first);
    await tester.pumpAndSettle();
    expect(
      find.text('Take Tram 1 Line toward Lynnwood City Center'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('a host-owned controller is not disposed by the view', (
    tester,
  ) async {
    final controller = TripPlannerController(
      service: FakeTripPlanService(result: sdPlan()),
      origin: ucsd,
      destination: downtown,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TripPlannerView(
            controller: controller,
            placeSearch: FakeTripPlaceSearch(),
            mapConfig: testMapConfig(),
          ),
        ),
      ),
    );
    await controller.plan();
    await tester.pump();
    expect(find.byType(ItineraryCard), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    // Still usable after the view is gone.
    controller.setMode(TransportMode.walk);
    expect(controller.state.mode, TransportMode.walk);
  });

  testWidgets('place search shows errors and empty results', (tester) async {
    final search = FakeTripPlaceSearch();
    await tester.pumpWidget(
      MaterialApp(
        home: TripPlaceSearchPage(search: search, title: 'To'),
      ),
    );
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.text('No places found'), findsOneWidget);

    search.error = StateError('geocoder down');
    await tester.enterText(find.byType(TextField), 'geisel');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.text("Couldn't search for places. Try again."), findsOneWidget);
  });

  testWidgets('place search debounces keystrokes', (tester) async {
    final search = FakeTripPlaceSearch();
    await tester.pumpWidget(
      MaterialApp(
        home: TripPlaceSearchPage(search: search, title: 'To'),
      ),
    );
    await tester.enterText(find.byType(TextField), 'h');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'ho');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'hor');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(search.queries, ['hor']);
  });
}
