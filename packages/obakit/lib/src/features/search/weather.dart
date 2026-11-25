import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/application.dart';
import '../../app/scope.dart';
import '../bookmarks/visibility.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';

/// One weather service per application, created on first use and cached
/// with it (the forecast is shared by the map button and the page).
final Expando<WeatherService> _services = Expando('obaWeatherService');

/// The application's weather service (forecast cached for 15 minutes).
WeatherService obaWeatherService(ObaApplication app) =>
    _services[app] ??= WeatherService(obaco: () => app.core.obacoClient);

/// Formats forecast values in the locale's units (°F and mph for US
/// locales), converting from the forecast's own units.
class WeatherFormat {
  WeatherFormat(this.context, WeatherForecast forecast)
    : source = WeatherUnits.ofSource(forecast.units),
      display = _displayUnits(context),
      l10n = context.obaL10n;

  final BuildContext context;
  final WeatherUnits source;
  final WeatherUnits display;
  final ObaLocalizations l10n;

  static WeatherUnits _displayUnits(BuildContext context) =>
      obaWeatherUnits(context);

  int _temp(double v) => convertTemperature(
    v,
    from: source.temperature,
    to: display.temperature,
  ).round();

  bool get _fahrenheit => display.temperature == TemperatureUnit.fahrenheit;

  /// "71°F".
  String temperature(double v) => _fahrenheit
      ? l10n.searchWeatherDegreesF(_temp(v))
      : l10n.searchWeatherDegreesC(_temp(v));

  /// "71 degrees Fahrenheit".
  String temperatureSpoken(double v) => _fahrenheit
      ? l10n.searchWeatherSpokenF(_temp(v))
      : l10n.searchWeatherSpokenC(_temp(v));

  String get unitName =>
      _fahrenheit ? l10n.searchWeatherFahrenheit : l10n.searchWeatherCelsius;

  String wind(double v) {
    final value = convertSpeed(
      v,
      from: source.speed,
      to: display.speed,
    ).round();
    return switch (display.speed) {
      SpeedUnit.milesPerHour => l10n.searchWeatherMph(value),
      SpeedUnit.kilometersPerHour => l10n.searchWeatherKmh(value),
      SpeedUnit.metersPerSecond => l10n.searchWeatherMps(value),
    };
  }

  String percent(double probability) =>
      l10n.searchWeatherPercent((probability * 100).round());

  String condition(String iconKey) => weatherConditionText(l10n, iconKey);

  /// The hour, in the locale's style ("3 PM", "15").
  String hour(DateTime time) {
    final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    return DateFormat.j(locale).format(time.toLocal());
  }

  String time(DateTime time) {
    final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    return DateFormat.jm(locale).format(time.toLocal());
  }
}

/// The localized name of an Obaco condition icon ("Partly cloudy").
String weatherConditionText(ObaLocalizations l10n, String iconKey) =>
    switch (WeatherCondition.fromIconKey(iconKey)) {
      WeatherCondition.clear => l10n.searchWeatherClear,
      WeatherCondition.partlyCloudy => l10n.searchWeatherPartlyCloudy,
      WeatherCondition.cloudy => l10n.searchWeatherCloudy,
      WeatherCondition.rain => l10n.searchWeatherRain,
      WeatherCondition.sleet => l10n.searchWeatherSleet,
      WeatherCondition.snow => l10n.searchWeatherSnow,
      WeatherCondition.wind => l10n.searchWeatherWindy,
      WeatherCondition.fog => l10n.searchWeatherFog,
      WeatherCondition.unknown => l10n.searchWeatherUnknown,
    };

/// The Material icon for an Obaco condition icon key.
IconData weatherIconData(String iconKey) {
  final night = isNightWeatherIcon(iconKey);
  return switch (WeatherCondition.fromIconKey(iconKey)) {
    WeatherCondition.clear => night ? Icons.nightlight_round : Icons.wb_sunny,
    WeatherCondition.partlyCloudy =>
      night ? Icons.nights_stay : Icons.filter_drama,
    WeatherCondition.cloudy => Icons.cloud,
    WeatherCondition.rain => Icons.water_drop,
    WeatherCondition.sleet => Icons.grain,
    WeatherCondition.snow => Icons.ac_unit,
    WeatherCondition.wind => Icons.air,
    WeatherCondition.fog => Icons.foggy,
    WeatherCondition.unknown => Icons.cloud,
  };
}

/// A weather condition icon with its text alternative.
class ObaWeatherIcon extends StatelessWidget {
  const ObaWeatherIcon(
    this.iconKey, {
    super.key,
    this.size,
    this.excludeFromSemantics = false,
  });

  final String iconKey;
  final double? size;

  /// When the surrounding text already says the condition.
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      weatherIconData(iconKey),
      size: size,
      color: Theme.of(context).colorScheme.primary,
      semanticLabel: excludeFromSemantics
          ? null
          : weatherConditionText(context.obaL10n, iconKey),
    );
    return excludeFromSemantics ? ExcludeSemantics(child: icon) : icon;
  }
}

mixin _WeatherServiceListening<T extends StatefulWidget> on State<T> {
  ObaApplication? _app;
  WeatherService? service;
  Listenable? _clients;

  void attachWeather() {
    final app = ObaScope.of(context);
    if (identical(app, _app)) return;
    detachWeather();
    _app = app;
    service = obaWeatherService(app)..addListener(_changed);
    _clients = ObaListenableAdapter(app.core.clientsListenable)
      ..addListener(_regionChanged);
    service!.load();
  }

  void detachWeather() {
    service?.removeListener(_changed);
    _clients?.removeListener(_regionChanged);
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  void _regionChanged() {
    service?.load();
    _changed();
  }
}

/// The map's weather button: current temperature and condition icon. Hidden
/// when the region has no weather server or the forecast can't be loaded.
/// Tapping opens [WeatherRoute].
class ObaWeatherButton extends StatefulWidget {
  const ObaWeatherButton({super.key, this.onPressed});

  /// Defaults to pushing [WeatherRoute].
  final VoidCallback? onPressed;

  @override
  State<ObaWeatherButton> createState() => _ObaWeatherButtonState();
}

class _ObaWeatherButtonState extends State<ObaWeatherButton>
    with _WeatherServiceListening, ObaVisibilityAware {
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    attachWeather();
  }

  /// Re-checks the forecast every 5 minutes, only while the button is on
  /// screen and the app is in the foreground; coming back, it reloads at
  /// once if the forecast went stale meanwhile.
  @override
  void onVisibilityChanged(bool visible) {
    if (visible) {
      _timer ??= Timer.periodic(const Duration(minutes: 5), (_) {
        service?.load();
      });
      // Returns the cached forecast while it is fresh.
      service?.load();
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    detachWeather();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forecast = service?.forecast;
    if (forecast == null) return const SizedBox.shrink();
    final l10n = context.obaL10n;
    final format = WeatherFormat(context, forecast);
    final current = forecast.currentForecast;
    final scheme = Theme.of(context).colorScheme;
    final label = l10n.searchWeatherButtonLabel(
      format.temperatureSpoken(current.temperature),
      format.condition(current.iconName),
    );
    void open() => widget.onPressed != null
        ? widget.onPressed!()
        : ObaNavigator.of(context).push(const WeatherRoute());
    return Semantics(
      button: true,
      label: label,
      hint: l10n.searchWeatherButtonHint,
      excludeSemantics: true,
      onTap: open,
      child: Material(
        color: scheme.surface,
        elevation: 3,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: open,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 14, 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ObaWeatherIcon(current.iconName, excludeFromSemantics: true),
                  const SizedBox(width: 6),
                  Text(
                    format.temperature(current.temperature),
                    style: Theme.of(context).textTheme.titleSmall
                        ?.copyWith(color: scheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The region's forecast (iOS `WeatherDetailPopup`): condition, current and
/// feels-like temperature, high and low over the next 24 hours, wind,
/// chance of rain, the day's summary, and an hourly list. Units follow the
/// locale and are named on the page.
///
/// Embeddable: needs only an `ObaScope`.
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with _WeatherServiceListening {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    attachWeather();
  }

  @override
  void dispose() {
    detachWeather();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final s = service!;
    final forecast = s.forecast;
    final List<Widget> slivers;
    if (!s.isAvailable) {
      slivers = [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ObaEmptyState(
            icon: Icons.cloud_off_outlined,
            title: l10n.searchWeatherUnavailable,
          ),
        ),
      ];
    } else if (forecast == null) {
      slivers = [
        SliverFillRemaining(
          hasScrollBody: false,
          child: s.error != null && !s.isLoading
              ? ObaErrorState(
                  error: s.error,
                  onRetry: () => s.load(force: true),
                )
              : const ObaLoadingState(),
        ),
      ];
    } else {
      slivers = _forecast(context, forecast);
    }
    return ObaSheetPage(title: l10n.titleWeather, slivers: slivers);
  }

  List<Widget> _forecast(BuildContext context, WeatherForecast forecast) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final format = WeatherFormat(context, forecast);
    final current = forecast.currentForecast;
    final upcoming = upcomingHourly(forecast.hourlyForecasts, now: clock.now());
    final highLow = weatherHighLow(upcoming);
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final header = MergeSemantics(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ObaWeatherIcon(
              current.iconName,
              size: 56,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    format.temperature(current.temperature),
                    style: theme.textTheme.displaySmall,
                    semanticsLabel: format.temperatureSpoken(
                      current.temperature,
                    ),
                  ),
                  Text(
                    format.condition(current.iconName),
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(forecast.regionName, style: muted),
                  if (highLow != null)
                    Text(
                      l10n.searchWeatherHighLow(
                        format.temperature(highLow.high),
                        format.temperature(highLow.low),
                      ),
                      style: theme.textTheme.bodyLarge,
                      semanticsLabel: l10n.searchWeatherHighLowSpoken(
                        format.temperatureSpoken(highLow.high),
                        format.temperatureSpoken(highLow.low),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget stat(IconData icon, String label, String value, {String? spoken}) =>
        MergeSemantics(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 104),
            child: Card.filled(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Icon(icon, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(label, style: theme.textTheme.labelMedium),
                    Text(
                      value,
                      style: theme.textTheme.titleMedium,
                      semanticsLabel: spoken,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

    return [
      SliverToBoxAdapter(child: header),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
          child: Text(
            l10n.searchWeatherUnitsNote(format.unitName),
            style: muted,
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              stat(
                Icons.thermostat,
                l10n.searchWeatherFeelsLike,
                format.temperature(current.temperatureFeelsLike),
                spoken: format.temperatureSpoken(current.temperatureFeelsLike),
              ),
              stat(
                Icons.air,
                l10n.searchWeatherWind,
                format.wind(current.windSpeed),
              ),
              stat(
                Icons.umbrella,
                l10n.searchWeatherPrecip,
                format.percent(current.precipProbability),
              ),
            ],
          ),
        ),
      ),
      if (forecast.todaySummary.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: ObaSectionHeader(title: l10n.searchWeatherSummaryLabel),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Text(
              forecast.todaySummary,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
      if (upcoming.isNotEmpty) ...[
        SliverToBoxAdapter(
          child: ObaSectionHeader(title: l10n.searchWeatherHourly),
        ),
        SliverList.builder(
          itemCount: upcoming.length,
          itemBuilder: (context, i) =>
              _HourRow(hour: upcoming[i], isNow: i == 0, format: format),
        ),
      ],
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.searchWeatherUpdated(format.time(forecast.retrievedAt)),
                style: muted,
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

class _HourRow extends StatelessWidget {
  const _HourRow({
    required this.hour,
    required this.isNow,
    required this.format,
  });

  final HourlyForecast hour;
  final bool isNow;
  final WeatherFormat format;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.obaL10n;
    final time = isNow ? l10n.searchWeatherNow : format.hour(hour.time);
    final precip = format.percent(hour.precipProbability);
    return Semantics(
      container: true,
      label: l10n.searchWeatherHourLabel(
        time,
        format.temperatureSpoken(hour.temperature),
        format.condition(hour.iconName),
        precip,
      ),
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 6),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  time,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isNow ? FontWeight.w700 : null,
                  ),
                ),
              ),
              ObaWeatherIcon(hour.iconName, excludeFromSemantics: true),
              Text(
                format.temperature(hour.temperature),
                style: theme.textTheme.titleMedium,
              ),
              Text(
                '${format.condition(hour.iconName)} · $precip',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
