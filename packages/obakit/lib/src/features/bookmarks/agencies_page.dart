import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/polling.dart';
import '../../widgets/heading.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../map/map_coordinator.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import '../../widgets/link_opener.dart';

/// The transit agencies of the current region (agencies with coverage joined
/// with the agency details): name, website, phone, email, fare information
/// and disclaimer. Phone and email open the dialer and mail app; with a map
/// around, "Show coverage on the map" centres it on the agency's area.
class AgenciesPage extends StatefulWidget {
  const AgenciesPage({super.key, this.urlOpener});

  /// Overrides the [ObaLinkOpenerScope] opener for this page.
  final ObaUrlOpener? urlOpener;

  @override
  State<AgenciesPage> createState() => _AgenciesPageState();
}

class _AgenciesPageState extends State<AgenciesPage> {
  Future<List<({Agency agency, AgencyWithCoverage? coverage})>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<List<({Agency agency, AgencyWithCoverage? coverage})>> _load() async {
    final client = ObaScope.of(context).core.restClient;
    if (client == null) throw const ObaNoRegionException();
    final response = await client.agencies.withCoverage();
    final list =
        [
          for (final c in response.list)
            if (response.references.agency(c.agencyId) case final a?)
              (agency: a, coverage: c as AgencyWithCoverage?),
        ]..sort(
          (a, b) => a.agency.name.toLowerCase().compareTo(
            b.agency.name.toLowerCase(),
          ),
        );
    return list;
  }

  void _retry() => setState(() => _future = _load());

  Future<void> _open(Uri uri) =>
      obaOpenLink(context, uri, opener: widget.urlOpener);

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        return ObaSheetPage(
          title: l10n.titleAgencies,
          slivers: [
            if (snapshot.hasError)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ObaErrorState(error: snapshot.error, onRetry: _retry),
              )
            else if (data == null)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: ObaLoadingState(),
              )
            else if (data.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ObaEmptyState(
                  icon: Icons.business_outlined,
                  title: l10n.agenciesEmptyTitle,
                  message: l10n.agenciesEmptyBody,
                ),
              )
            else
              SliverList.builder(
                itemCount: data.length,
                itemBuilder: (context, i) => _AgencyCard(
                  agency: data[i].agency,
                  coverage: data[i].coverage,
                  onOpen: _open,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AgencyCard extends StatelessWidget {
  const _AgencyCard({
    required this.agency,
    required this.coverage,
    required this.onOpen,
  });

  final Agency agency;
  final AgencyWithCoverage? coverage;
  final Future<void> Function(Uri) onOpen;

  Uri? _web(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return null;
    final withScheme = uri.hasScheme
        ? uri
        : Uri.tryParse('https://${raw.trim()}');
    return withScheme != null && isWebUri(withScheme) ? withScheme : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final site = _web(agency.url);
    final fares = _web(agency.fareUrl);
    final phone = agency.phone?.trim();
    final email = agency.email?.trim();
    final map = ObaMapCoordinator.maybeOf(context);
    final c = coverage;

    Widget action(IconData icon, String label, Uri uri) => TextButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: TextButton.styleFrom(
        alignment: AlignmentDirectional.centerStart,
        minimumSize: const Size(48, 48),
      ),
      onPressed: () => onOpen(uri),
    );

    return Card(
      margin: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ObaHeading(obaBidiIsolate(context, agency.name)),
            if (site != null) action(Icons.public, l10n.agenciesWebsite, site),
            if (phone != null && phone.isNotEmpty)
              action(
                Icons.phone_outlined,
                l10n.agenciesPhone(phone),
                Uri(
                  scheme: 'tel',
                  path: phone.replaceAll(RegExp(r'[^0-9+*#,;]'), ''),
                ),
              ),
            if (email != null && email.isNotEmpty)
              action(
                Icons.mail_outline,
                l10n.agenciesEmail(email),
                Uri(scheme: 'mailto', path: email),
              ),
            if (fares != null)
              action(Icons.payments_outlined, l10n.agenciesFares, fares),
            if (map != null && c != null)
              TextButton.icon(
                icon: const Icon(Icons.map_outlined),
                label: Text(l10n.agenciesShowOnMap),
                style: TextButton.styleFrom(
                  alignment: AlignmentDirectional.centerStart,
                  minimumSize: const Size(48, 48),
                ),
                onPressed: () => map.fitBounds(
                  RegionRect(
                    minLat: c.lat - c.latSpan / 2,
                    maxLat: c.lat + c.latSpan / 2,
                    minLon: c.lon - c.lonSpan / 2,
                    maxLon: c.lon + c.lonSpan / 2,
                  ),
                ),
              ),
            if (agency.disclaimer != null &&
                agency.disclaimer!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l10n.agenciesDisclaimer, style: theme.textTheme.labelLarge),
              Text(agency.disclaimer!.trim(), style: theme.textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
