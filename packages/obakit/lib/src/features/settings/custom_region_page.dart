import 'dart:async';

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import '../map/map_coordinator.dart';

/// The form that adds or edits a custom region: name, OneBusAway server URL
/// (checked live against the server), optional sidecar and trip planner
/// URLs, and the service area (centre and span, which can be filled from
/// the current map view when a map is present).
///
/// [prefill] comes from an add-region deep link; [editRegionId] edits an
/// existing custom region.
class CustomRegionPage extends StatefulWidget {
  const CustomRegionPage({super.key, this.prefill, this.editRegionId});

  final AddRegionData? prefill;
  final int? editRegionId;

  /// How long to wait after typing before the server is checked.
  static const checkDebounce = Duration(milliseconds: 600);

  @override
  State<CustomRegionPage> createState() => _CustomRegionPageState();
}

class _CustomRegionPageState extends State<CustomRegionPage> {
  late final Map<String, TextEditingController> _c;
  Timer? _debounce;
  bool _submitted = false;
  bool _saving = false;
  bool _checking = false;
  ServerCheck? _check;
  Uri? _checkedUrl;
  int _checkGeneration = 0;
  ObaServerValidator? _validator;
  String _contactEmail = '';

  static const _keys = [
    'name',
    'oba',
    'sidecar',
    'otp',
    'otpGraphql',
    'lat',
    'lon',
    'latSpan',
    'lonSpan',
  ];

  @override
  void initState() {
    super.initState();
    _c = {for (final k in _keys) k: TextEditingController()};
  }

  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _initialised = true;
    final core = ObaScope.of(context).core;
    _validator = ObaServerValidator(
      apiKey: core.config.apiKey,
      httpClient: core.httpClient,
    );
    var draft = const CustomRegionDraft();
    final editId = widget.editRegionId;
    final existing = editId == null ? null : core.regions.find(editId);
    final prefill = widget.prefill;
    if (existing != null) {
      draft = CustomRegionDraft.fromRegion(existing);
    } else if (prefill != null) {
      draft = CustomRegionDraft(
        name: prefill.name,
        obaUrl: prefill.obaUrl.toString(),
        sidecarUrl: prefill.sidecarUrl?.toString() ?? '',
        otpUrl: prefill.otpUrl?.toString() ?? '',
        otpGraphqlUrl: prefill.otpGraphqlUrl?.toString() ?? '',
      );
    }
    _contactEmail = existing?.contactEmail ?? '';
    _write(draft);
    if (draft.obaUrlError() == null) _scheduleCheck(immediately: true);
  }

  void _write(CustomRegionDraft d) {
    _c['name']!.text = d.name;
    _c['oba']!.text = d.obaUrl;
    _c['sidecar']!.text = d.sidecarUrl;
    _c['otp']!.text = d.otpUrl;
    _c['otpGraphql']!.text = d.otpGraphqlUrl;
    _c['lat']!.text = d.latitude;
    _c['lon']!.text = d.longitude;
    _c['latSpan']!.text = d.latSpan;
    _c['lonSpan']!.text = d.lonSpan;
  }

  CustomRegionDraft get _draft => CustomRegionDraft(
    name: _c['name']!.text,
    obaUrl: _c['oba']!.text,
    sidecarUrl: _c['sidecar']!.text,
    otpUrl: _c['otp']!.text,
    otpGraphqlUrl: _c['otpGraphql']!.text,
    latitude: _c['lat']!.text,
    longitude: _c['lon']!.text,
    latSpan: _c['latSpan']!.text,
    lonSpan: _c['lonSpan']!.text,
    contactEmail: _contactEmail,
  );

  @override
  void dispose() {
    _debounce?.cancel();
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onServerUrlChanged() {
    _debounce?.cancel();
    _checkGeneration++;
    setState(() {
      _check = null;
      _checking = false;
      _checkedUrl = null;
    });
    if (_draft.obaUrlError() == null) _scheduleCheck();
  }

  void _scheduleCheck({bool immediately = false}) {
    _debounce?.cancel();
    if (immediately) {
      unawaited(_runCheck());
    } else {
      _debounce = Timer(CustomRegionPage.checkDebounce, _runCheck);
    }
  }

  Future<ServerCheck?> _runCheck() async {
    final url = CustomRegionDraft.parseHttpUrl(_c['oba']!.text);
    final validator = _validator;
    if (url == null || validator == null) return null;
    final generation = ++_checkGeneration;
    if (mounted) setState(() => _checking = true);
    final result = await validator.check(url);
    if (!mounted || generation != _checkGeneration) return null;
    setState(() {
      _checking = false;
      _check = result;
      _checkedUrl = url;
    });
    obaAnnounce(context, _serverMessage(result));
    return result;
  }

  String _serverMessage(ServerCheck c) {
    final l10n = context.obaL10n;
    return switch (c) {
      ServerCheck.valid => l10n.customRegionServerOk,
      ServerCheck.unreachable => l10n.customRegionServerUnreachable,
      ServerCheck.notOneBusAway => l10n.customRegionServerNotOba,
    };
  }

  String? _error(CustomRegionFieldError? e) {
    if (e == null) return null;
    final l10n = context.obaL10n;
    if (e == CustomRegionFieldError.required && !_submitted) return null;
    return switch (e) {
      CustomRegionFieldError.required => l10n.customRegionErrorRequired,
      CustomRegionFieldError.invalidUrl => l10n.customRegionErrorUrl,
      CustomRegionFieldError.invalidNumber => l10n.customRegionErrorNumber,
      CustomRegionFieldError.outOfRange => l10n.customRegionErrorRange,
    };
  }

  void _useMapArea() {
    final bounds = ObaMapCoordinator.maybeOf(context)?.visibleBounds;
    if (bounds == null) return;
    final center = bounds.center;
    setState(() {
      _c['lat']!.text = center.lat.toStringAsFixed(5);
      _c['lon']!.text = center.lon.toStringAsFixed(5);
      _c['latSpan']!.text = (bounds.maxLat - bounds.minLat).toStringAsFixed(5);
      _c['lonSpan']!.text = (bounds.maxLon - bounds.minLon).toStringAsFixed(5);
    });
  }

  int _newRegionId(RegionsService regions) {
    var id = 1000 + DateTime.now().millisecondsSinceEpoch % 100000;
    while (regions.find(id) != null) {
      id++;
    }
    return id;
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    final draft = _draft;
    if (!draft.isValid) return;
    setState(() => _saving = true);
    final url = CustomRegionDraft.parseHttpUrl(draft.obaUrl)!;
    var check = _check;
    if (check == null || _checkedUrl != url) {
      _debounce?.cancel();
      check = await _runCheck();
    }
    if (!mounted) return;
    if (check != ServerCheck.valid) {
      setState(() => _saving = false);
      return;
    }
    final core = ObaScope.of(context).core;
    final regions = core.regions;
    final editId = widget.editRegionId;
    final region = draft.toRegion(id: editId ?? _newRegionId(regions));
    regions.addCustomRegion(region);
    if (editId == null) {
      regions.automaticallySelectRegion = false;
      regions.setCurrentRegion(region);
    }
    obaAnnounce(context, context.obaL10n.customRegionSaved(region.regionName));
    ObaNavigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final draft = _draft;
    final hasMap = ObaMapCoordinator.maybeOf(context)?.visibleBounds != null;

    Widget field(
      String key,
      String label, {
      String? error,
      String? helper,
      TextInputType? keyboard,
      VoidCallback? onChanged,
    }) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: TextField(
        controller: _c[key],
        keyboardType: keyboard,
        autocorrect: false,
        onChanged: (_) => onChanged == null ? setState(() {}) : onChanged(),
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          helperMaxLines: 3,
          errorText: error,
          errorMaxLines: 3,
          border: const OutlineInputBorder(),
        ),
      ),
    );

    const numeric = TextInputType.numberWithOptions(
      decimal: true,
      signed: true,
    );
    final serverStatus = _checking
        ? (Icons.hourglass_empty, l10n.customRegionChecking, null)
        : switch (_check) {
            ServerCheck.valid => (
              Icons.check_circle_outline,
              l10n.customRegionServerOk,
              null,
            ),
            ServerCheck.unreachable => (
              Icons.error_outline,
              l10n.customRegionServerUnreachable,
              theme.colorScheme.error,
            ),
            ServerCheck.notOneBusAway => (
              Icons.error_outline,
              l10n.customRegionServerNotOba,
              theme.colorScheme.error,
            ),
            null => null,
          };

    return ObaSheetPage(
      title: widget.editRegionId == null
          ? l10n.titleCustomRegion
          : l10n.customRegionEditTitle,
      slivers: [
        SliverList.list(
          children: [
            field(
              'name',
              l10n.customRegionName,
              error: _error(draft.nameError()),
            ),
            field(
              'oba',
              l10n.customRegionObaUrl,
              error: _error(draft.obaUrlError()),
              helper: l10n.customRegionObaUrlHelp,
              keyboard: TextInputType.url,
              onChanged: _onServerUrlChanged,
            ),
            if (serverStatus != null)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
                child: Semantics(
                  liveRegion: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExcludeSemantics(
                        child: Icon(serverStatus.$1, color: serverStatus.$3),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          serverStatus.$2,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: serverStatus.$3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            field(
              'sidecar',
              l10n.customRegionSidecar,
              error: _error(
                CustomRegionDraft.optionalUrlError(draft.sidecarUrl),
              ),
              keyboard: TextInputType.url,
            ),
            field(
              'otp',
              l10n.customRegionOtp,
              error: _error(CustomRegionDraft.optionalUrlError(draft.otpUrl)),
              keyboard: TextInputType.url,
            ),
            field(
              'otpGraphql',
              l10n.customRegionOtpGraphql,
              error: _error(
                CustomRegionDraft.optionalUrlError(draft.otpGraphqlUrl),
              ),
              keyboard: TextInputType.url,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
              child: Semantics(
                container: true,
                header: true,
                child: Text(
                  l10n.customRegionServiceArea,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 2, 16, 0),
              child: Text(
                l10n.customRegionServiceAreaHelp,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            field(
              'lat',
              l10n.customRegionLatitude,
              error: _error(draft.latitudeError()),
              keyboard: numeric,
            ),
            field(
              'lon',
              l10n.customRegionLongitude,
              error: _error(draft.longitudeError()),
              keyboard: numeric,
            ),
            field(
              'latSpan',
              l10n.customRegionLatSpan,
              error: _error(draft.latSpanError()),
              keyboard: numeric,
            ),
            field(
              'lonSpan',
              l10n.customRegionLonSpan,
              error: _error(draft.lonSpanError()),
              keyboard: numeric,
            ),
            if (hasMap)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: _useMapArea,
                    icon: const Icon(Icons.map_outlined),
                    label: Text(l10n.customRegionUseMap),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => ObaNavigator.of(context).pop(),
                    child: Text(l10n.commonCancel),
                  ),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(l10n.customRegionSave),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
