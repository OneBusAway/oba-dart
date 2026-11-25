import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'name_dialog.dart';

const String _newGroupValue = '\u0000new-group';
const String _noGroupValue = '\u0000no-group';

/// Creates a stop or trip bookmark, or edits one: name (prefilled), group
/// (with "New group…"), duplicate detection, save, cancel and delete.
class BookmarkEditorPage extends StatefulWidget {
  const BookmarkEditorPage({super.key, required this.route});

  final BookmarkEditorRoute route;

  @override
  State<BookmarkEditorPage> createState() => _BookmarkEditorPageState();
}

class _BookmarkEditorPageState extends State<BookmarkEditorPage> {
  final _name = TextEditingController();
  bool _initialized = false;
  String? _groupId;
  bool _tripOnly = true;
  String? _error;
  int _groupFieldReset = 0;

  Bookmark? get _existing => widget.route.bookmark;
  ArrivalAndDeparture? get _arrival => widget.route.arrival;
  bool get _isTrip =>
      _existing?.isTripBookmark ?? (_arrival != null && _tripOnly);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final existing = _existing;
    if (existing != null) {
      _name.text = existing.name;
      _groupId = existing.groupId;
    } else {
      _name.text = _defaultName();
    }
  }

  String _defaultName() {
    final a = _arrival;
    if (a != null && _tripOnly) {
      return a.routeAndHeadsign();
    }
    return widget.route.stop?.name ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  UserDataStore get _store => ObaScope.of(context).core.userData;

  Bookmark? _build() {
    final name = _name.text.trim();
    final existing = _existing;
    if (existing != null) return existing.copyWith(name: name);
    final region = ObaScope.of(context).core.currentRegion;
    final stop = widget.route.stop;
    if (region == null || stop == null) return null;
    final stored = StoredStop.fromStop(stop);
    final a = _arrival;
    return a != null && _tripOnly
        ? Bookmark.forTrip(
            name: name,
            regionId: region.id,
            stop: stored,
            arrival: a,
          )
        : Bookmark.forStop(name: name, regionId: region.id, stop: stored);
  }

  void _save() {
    final l10n = context.obaL10n;
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.bookmarksEditorNameRequired);
      return;
    }
    final bookmark = _build();
    if (bookmark == null) {
      setState(() => _error = l10n.bookmarksEditorNoRegion);
      return;
    }
    final store = _store;
    final duplicate = store.bookmarks.any(
      (b) => b.id != bookmark.id && b.isEquivalentTo(bookmark),
    );
    if (duplicate) {
      setState(() => _error = l10n.bookmarksEditorDuplicate);
      return;
    }
    if (_existing == null) {
      store.addBookmark(bookmark, groupId: _groupId);
    } else {
      store.updateBookmark(bookmark);
      if (_existing!.groupId != _groupId) {
        store.addBookmark(store.findBookmark(bookmark.id)!, groupId: _groupId);
      }
    }
    obaAnnounce(context, l10n.bookmarksEditorSaved);
    ObaNavigator.of(context).pop();
  }

  Future<void> _delete() async {
    final l10n = context.obaL10n;
    final existing = _existing!;
    final ok = await obaConfirm(
      context,
      title: l10n.bookmarksEditorDeleteTitle,
      message: l10n.bookmarksEditorDeleteBody(existing.name),
      confirmLabel: l10n.bookmarksActionDelete,
    );
    if (!ok || !mounted) return;
    _store.deleteBookmark(existing.id);
    ObaNavigator.of(context).pop();
  }

  Future<void> _newGroup() async {
    final name = await showGroupNameDialog(
      context,
      title: context.obaL10n.bookmarksEditorNewGroupTitle,
    );
    if (!mounted) return;
    if (name == null) {
      // Cancelled: the field still shows "New group…", which is not a
      // group. Rebuild it on the group the bookmark is really in.
      setState(() => _groupFieldReset++);
      return;
    }
    final group = _store.addGroup(name);
    setState(() => _groupId = group.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final stop = widget.route.stop;
    final existing = _existing;
    final stopName = existing?.stop.name ?? stop?.name ?? '';
    final routeName =
        existing?.routeShortName ??
        _arrival?.routeShortName ??
        _arrival?.routeId ??
        '';
    final groups = _store.bookmarkGroups;
    final groupValue = groups.any((g) => g.id == _groupId)
        ? _groupId!
        : _noGroupValue;
    return ObaSheetPage(
      title: l10n.titleBookmarkEditor,
      body: ListView(
        primary: true,
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _isTrip
                ? l10n.bookmarksEditorTripKind(routeName, stopName)
                : l10n.bookmarksEditorStopKind(stopName),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.bookmarksEditorNameLabel,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          if (existing == null && _arrival != null)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.bookmarksEditorTripOnly(routeName)),
              value: _tripOnly,
              onChanged: (v) => setState(() {
                _tripOnly = v;
                _name.text = _defaultName();
                _error = null;
              }),
            ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: groupValue,
            key: ValueKey(
              'group-$groupValue-${groups.length}-$_groupFieldReset',
            ),
            isExpanded: true,
            decoration: InputDecoration(
              labelText: l10n.bookmarksEditorGroup,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: _noGroupValue,
                child: Text(l10n.bookmarksNoGroup),
              ),
              for (final g in groups)
                DropdownMenuItem(value: g.id, child: Text(g.name)),
              DropdownMenuItem(
                value: _newGroupValue,
                child: Text(l10n.bookmarksEditorNewGroup),
              ),
            ],
            onChanged: (v) {
              if (v == _newGroupValue) {
                _newGroup();
              } else {
                setState(() => _groupId = v == _noGroupValue ? null : v);
              }
            },
          ),
          if (_error != null)
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: _save,
                child: Text(l10n.bookmarksEditorSave),
              ),
              OutlinedButton(
                onPressed: ObaNavigator.of(context).pop,
                child: Text(l10n.commonCancel),
              ),
              if (existing != null)
                TextButton(
                  onPressed: _delete,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  child: Text(l10n.bookmarksEditorDelete),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
