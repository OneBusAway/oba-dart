import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'bookmark_actions.dart';
import 'name_dialog.dart';

/// Add, rename, delete and reorder groups, and reorder or move bookmarks.
/// Every reorder works by drag handle and by move up / down buttons (and as
/// screen-reader actions). Changes save as they are made.
class ManageBookmarksPage extends StatelessWidget {
  const ManageBookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ObaScope.of(context).core.userData;
    final l10n = context.obaL10n;
    return ListenableBuilder(
      listenable: store.listenable,
      builder: (context, _) {
        final groups = store.bookmarkGroups;
        final ungrouped = store.bookmarksInGroup(null);
        final empty = groups.isEmpty && ungrouped.isEmpty;
        return ObaSheetPage(
          title: l10n.titleManageBookmarks,
          actions: [
            IconButton(
              icon: const Icon(Icons.create_new_folder_outlined),
              tooltip: l10n.bookmarksManageAddGroup,
              onPressed: () => _editGroup(context, null),
            ),
          ],
          slivers: [
            if (empty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: ObaEmptyState(
                  icon: Icons.bookmark_outline,
                  title: l10n.bookmarksEmptyTitle,
                  message: l10n.bookmarksManageEmpty,
                  action: FilledButton.tonal(
                    onPressed: () => _editGroup(context, null),
                    child: Text(l10n.bookmarksManageAddGroup),
                  ),
                ),
              )
            else ...[
              if (groups.isNotEmpty) ...[
                _Header(l10n.bookmarksManageGroupsHeader),
                SliverReorderableList(
                  itemCount: groups.length,
                  onReorderItem: (o, n) => _moveGroup(context, groups, o, n),
                  itemBuilder: (context, i) => _ReorderTile(
                    key: ValueKey('group-${groups[i].id}'),
                    index: i,
                    count: groups.length,
                    name: groups[i].name,
                    onMove: (delta) =>
                        _moveGroup(context, groups, i, i + delta),
                    extra: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: l10n.bookmarksManageRenameGroup,
                        onPressed: () => _editGroup(context, groups[i]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: l10n.bookmarksManageDeleteGroup,
                        onPressed: () => _deleteGroup(context, groups[i]),
                      ),
                    ],
                  ),
                ),
              ],
              if (ungrouped.isNotEmpty)
                ..._bookmarkSection(
                  context,
                  l10n.bookmarksManageUngrouped,
                  null,
                  ungrouped,
                ),
              for (final g in groups)
                if (store.bookmarksInGroup(g.id) case final list
                    when list.isNotEmpty)
                  ..._bookmarkSection(context, g.name, g.id, list),
            ],
          ],
        );
      },
    );
  }

  List<Widget> _bookmarkSection(
    BuildContext context,
    String title,
    String? groupId,
    List<Bookmark> list,
  ) {
    final store = ObaScope.of(context).core.userData;
    final l10n = context.obaL10n;
    void move(int o, int n) {
      if (n == o) return;
      store.moveBookmark(groupId, o, n);
      obaAnnounce(
        context,
        l10n.bookmarksManageMoved(list[o].name, n + 1, list.length),
      );
    }

    return [
      _Header(title),
      SliverReorderableList(
        itemCount: list.length,
        onReorderItem: move,
        itemBuilder: (context, i) => _ReorderTile(
          key: ValueKey('bookmark-${list[i].id}'),
          index: i,
          count: list.length,
          name: list[i].name,
          onMove: (delta) => move(i, i + delta),
          extra: [
            IconButton(
              icon: const Icon(Icons.folder_outlined),
              tooltip: l10n.bookmarksActionMove,
              onPressed: () => BookmarkActions.moveToGroup(context, list[i]),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.bookmarksActionDelete,
              onPressed: () => BookmarkActions.delete(context, list[i]),
            ),
          ],
        ),
      ),
    ];
  }

  void _moveGroup(
    BuildContext context,
    List<BookmarkGroup> groups,
    int o,
    int n,
  ) {
    if (n == o) return;
    final l10n = context.obaL10n;
    ObaScope.of(context).core.userData.moveGroup(o, n);
    obaAnnounce(
      context,
      l10n.bookmarksManageMoved(groups[o].name, n + 1, groups.length),
    );
  }

  Future<void> _editGroup(BuildContext context, BookmarkGroup? group) async {
    final l10n = context.obaL10n;
    final store = ObaScope.of(context).core.userData;
    final name = await showGroupNameDialog(
      context,
      title: group == null
          ? l10n.bookmarksEditorNewGroupTitle
          : l10n.bookmarksManageRenameGroup,
      initialName: group?.name,
    );
    if (name == null) return;
    if (group == null) {
      store.addGroup(name);
    } else {
      store.renameGroup(group.id, name);
    }
  }

  Future<void> _deleteGroup(BuildContext context, BookmarkGroup group) async {
    final l10n = context.obaL10n;
    final store = ObaScope.of(context).core.userData;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.bookmarksManageDeleteGroup),
        content: Text(l10n.bookmarksManageDeleteGroupBody(group.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.bookmarksActionDelete),
          ),
        ],
      ),
    );
    if (ok == true) store.deleteGroup(group.id);
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
      child: Semantics(
        container: true,
        header: true,
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
    ),
  );
}

/// A row of a reorderable list: drag handle, name, move up / down buttons
/// and extra actions. The same moves are screen-reader custom actions.
class _ReorderTile extends StatelessWidget {
  const _ReorderTile({
    super.key,
    required this.index,
    required this.count,
    required this.name,
    required this.onMove,
    this.extra = const [],
  });

  final int index;
  final int count;
  final String name;

  /// Moves by -1 or +1.
  final ValueChanged<int> onMove;
  final List<Widget> extra;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return Semantics(
      customSemanticsActions: {
        if (index > 0)
          CustomSemanticsAction(label: l10n.bookmarksManageMoveUp(name)): () =>
              onMove(-1),
        if (index < count - 1)
          CustomSemanticsAction(
            label: l10n.bookmarksManageMoveDown(name),
          ): () =>
              onMove(1),
      },
      child: Card(
        margin: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.drag_handle,
                        semanticLabel: l10n.bookmarksManageReorder(name),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    tooltip: l10n.bookmarksManageMoveUp(name),
                    onPressed: index > 0 ? () => onMove(-1) : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    tooltip: l10n.bookmarksManageMoveDown(name),
                    onPressed: index < count - 1 ? () => onMove(1) : null,
                  ),
                  ...extra,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
