import 'package:obakit/obakit.dart';

/// CARTO's basemaps: muted street maps that let stop pins and route lines
/// stand out, with a matching dark style. They need no API key and serve
/// `@2x` tiles (the `{r}` placeholder), so the SDK requests sharp tiles on
/// high-density screens.
///
/// CARTO's free basemap use has limits and conditions
/// (https://carto.com/basemaps); fine for a sample app. A production app
/// should pick a provider and plan, or host its own tiles.
const cartoVoyager = ObaTileSource(
  urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
  subdomains: ['a', 'b', 'c', 'd'],
  attribution: 'OpenStreetMap contributors, CARTO',
  attributionUrl: 'https://carto.com/attributions',
  maxNativeZoom: 20,
);

/// The dark companion to [cartoVoyager].
const cartoDarkMatter = ObaTileSource(
  urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
  subdomains: ['a', 'b', 'c', 'd'],
  attribution: 'OpenStreetMap contributors, CARTO',
  attributionUrl: 'https://carto.com/attributions',
  maxNativeZoom: 20,
);
