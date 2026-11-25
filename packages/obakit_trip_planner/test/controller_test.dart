import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

import 'support/fixtures.dart';

void main() {
  late FakeTripPlanService service;
  late TripPlannerController controller;
  late List<TripPlannerStatus> statuses;

  setUp(() {
    service = FakeTripPlanService();
    controller = TripPlannerController(service: service);
    statuses = [];
    controller.addListener(() => statuses.add(controller.state.status));
  });

  tearDown(() => controller.dispose());

  test('starts idle with OTPKit defaults', () {
    final state = controller.state;
    expect(state.status, TripPlannerStatus.idle);
    expect(state.mode, TransportMode.transit);
    expect(state.timeOption, TripTimeOption.leaveNow);
    expect(state.maxWalkDistance, WalkingDistance.oneMile);
    expect(state.wheelchairAccessible, isFalse);
    expect(state.canPlan, isFalse);
  });

  test('rental modes are hidden unless the service supports them', () {
    final modes = [
      TransportMode.transit,
      TransportMode.bikeRental,
      TransportMode.transitBikeRental,
    ];
    final rest = TripPlannerController(service: service, enabledModes: modes);
    expect(rest.availableModes, [TransportMode.transit]);
    final graphql = TripPlannerController(
      service: FakeTripPlanService(supportsVehicleRental: true),
      enabledModes: modes,
      initialMode: TransportMode.bikeRental,
    );
    expect(graphql.availableModes, modes);
    expect(graphql.state.mode, TransportMode.bikeRental);
  });

  test('planning without endpoints is an error, not a request', () async {
    controller.setOrigin(ucsd);
    await controller.plan();
    expect(controller.state.status, TripPlannerStatus.error);
    expect(controller.state.error, isA<MissingTripEndpointsError>());
    expect(service.requests, isEmpty);
  });

  test('loading → loaded builds the request from the form', () async {
    final now = DateTime(2026, 11, 25, 8, 30);
    await withClock(Clock.fixed(now), () async {
      controller
        ..setOrigin(ucsd)
        ..setDestination(downtown)
        ..setMode(TransportMode.bike)
        ..setWheelchairAccessible(true)
        ..setMaxWalkDistance(WalkingDistance.halfMile);
      statuses.clear();

      final future = controller.plan();
      expect(controller.state.status, TripPlannerStatus.loading);
      final request = service.requests.single;
      expect(request.origin, ucsd.coordinate);
      expect(request.destination, downtown.coordinate);
      expect(request.dateTime, now);
      expect(request.transportModes, [TransportMode.bike, TransportMode.walk]);
      expect(request.wheelchairAccessible, isTrue);
      expect(request.maxWalkDistance, 805);
      expect(request.arriveBy, isFalse);

      service.complete(sdPlan());
      await future;
      expect(statuses, [TripPlannerStatus.loading, TripPlannerStatus.loaded]);
      expect(controller.state.itineraries, hasLength(6));
    });
  });

  test('arrive-by sends the chosen time with arriveBy', () async {
    controller
      ..setOrigin(ucsd)
      ..setDestination(downtown)
      ..setTimeOption(TripTimeOption.arriveBy)
      ..setDateTime(DateTime(2026, 12, 1, 17, 45));
    expect(controller.state.timeOption, TripTimeOption.arriveBy);
    service.result = sdPlan();
    await controller.plan();
    final request = service.requests.single;
    expect(request.arriveBy, isTrue);
    expect(request.dateTime, DateTime(2026, 12, 1, 17, 45));
  });

  test('choosing a time while leaving now switches to depart-at', () {
    controller.setDateTime(DateTime(2026, 12, 1, 7));
    expect(controller.state.timeOption, TripTimeOption.departAt);
  });

  test('depart-at without a time defaults to now, to the minute', () {
    withClock(Clock.fixed(DateTime(2026, 11, 25, 8, 30, 42)), () {
      controller.setTimeOption(TripTimeOption.departAt);
    });
    expect(controller.state.dateTime, DateTime(2026, 11, 25, 8, 30));
  });

  test('errors land in state and reach onError', () async {
    final errors = <Object>[];
    final c = TripPlannerController(
      service: service,
      origin: ucsd,
      destination: downtown,
      onError: (e, _) => errors.add(e),
    );
    final future = c.plan();
    service.fail(const OtpNetworkException('offline'));
    await future;
    expect(c.state.status, TripPlannerStatus.error);
    expect(c.state.error, isA<OtpNetworkException>());
    expect(errors.single, isA<OtpNetworkException>());
  });

  test('editing an input clears results and drops the request in flight', () {
    fakeAsync((async) {
      controller
        ..setOrigin(ucsd)
        ..setDestination(downtown);
      controller.plan();
      expect(controller.state.isLoading, isTrue);

      controller.swapEndpoints();
      expect(controller.state.status, TripPlannerStatus.idle);
      expect(controller.state.origin, downtown);
      expect(controller.state.destination, ucsd);

      service.complete(sdPlan());
      async.flushMicrotasks();
      expect(controller.state.status, TripPlannerStatus.idle);
      expect(controller.state.plan, isNull);
    });
  });

  test('a newer plan wins over an older one that finishes later', () {
    fakeAsync((async) {
      controller
        ..setOrigin(ucsd)
        ..setDestination(downtown);
      controller.plan();
      controller.plan();
      expect(service.pendingCount, 2);

      service.complete(stPlan(), index: 1);
      async.flushMicrotasks();
      expect(controller.state.plan!.source, OtpApiFlavor.graphql);

      service.complete(sdPlan(), index: 0);
      async.flushMicrotasks();
      expect(controller.state.plan!.source, OtpApiFlavor.graphql);
    });
  });

  test('results arriving after dispose are ignored', () {
    fakeAsync((async) {
      final c = TripPlannerController(
        service: service,
        origin: ucsd,
        destination: downtown,
      );
      c.plan();
      c.dispose();
      service.complete(sdPlan());
      async.flushMicrotasks();
    });
  });

  test('selecting an itinerary does not clear results', () async {
    controller
      ..setOrigin(ucsd)
      ..setDestination(downtown);
    service.result = sdPlan();
    await controller.plan();
    controller.selectItinerary(2);
    expect(controller.state.selectedIndex, 2);
    expect(
      controller.state.itineraries,
      hasLength(sdPlan().itineraries.length),
    );
    expect(controller.state.status, TripPlannerStatus.loaded);
    controller.selectItinerary(null);
    expect(controller.state.selectedIndex, isNull);
  });

  test('setOriginIfEmpty never overwrites a chosen origin', () {
    controller.setOrigin(ucsd);
    controller.setOriginIfEmpty(here);
    expect(controller.state.origin, ucsd);
    controller.setOrigin(null);
    controller.setOriginIfEmpty(here);
    expect(controller.state.origin, here);
  });

  test('reset clears endpoints and time but keeps mode and options', () {
    controller
      ..setOrigin(ucsd)
      ..setDestination(downtown)
      ..setMode(TransportMode.walk)
      ..setWheelchairAccessible(true)
      ..setTimeOption(TripTimeOption.arriveBy)
      ..reset();
    final state = controller.state;
    expect(state.origin, isNull);
    expect(state.destination, isNull);
    expect(state.timeOption, TripTimeOption.leaveNow);
    expect(state.dateTime, isNull);
    expect(state.mode, TransportMode.walk);
    expect(state.wheelchairAccessible, isTrue);
  });
}
