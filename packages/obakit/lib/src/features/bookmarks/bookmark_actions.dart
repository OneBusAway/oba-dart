import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../widgets/states.dart';

/// The actions a bookmark offers: edit, pin, move to a group, delete (with
/// undo). Shared by the bookmarks list, the home section and the manage
/// screen. All state changes go through `UserDataStore`.
abstract final class BookmarkActions {
  static UserDataStore _store(BuildContext context) =>
      ObaScope.of(context).core.userData;

  static void edit(BuildContext context, Bookmark bookmark) {
    ObaNavigator.of(context)
        .push<void>(BookmarkEditorRoute(bookmark: bookmark));
  }

  static void togglePin(BuildContext context, Bookmark bookmark) {
    _store(context).setPinned(bookmark.id, !bookmark.isPinned);
  }

  /// Deletes [bookmark] and offers to undo it in a snackbar.
  static void delete(BuildContext context, Bookmark bookmark) {
    final store = _store(context);
    final l10n = context.obaL10n;
    final groupId = bookmark.groupId;
    final index = store
        .bookmarksInGroup(groupId)
        .indexWhere((b) => b.id == bookmark.id);
    store.deleteBookmark(bookmark.id);
    final message = l10n.bookmarksDeleted(bookmark.name);
    // Like obaNotify, plus an Undo action.
    obaAnnounce(context, message);
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: l10n.bookmarksUndo,
            onPressed: () => store.addBookmark(
              bookmark,
              groupId: groupId,
              index: index < 0 ? null : index,
            ),
          ),
        ),
      );
  }

  /// Asks which group [bookmark] should be in, then moves it.
  static Future<void> moveToGroup(
    BuildContext context,
    Bookmark bookmark,
  ) async {
    final store = _store(context);
    final l10n = context.obaL10n;
    final groups = store.bookmarkGroups;
    final choice = await showDialog<_GroupChoice>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.bookmarksMoveTitle),
        children: [
          RadioGroup<String?>(
            groupValue: bookmark.groupId,
            onChanged: (value) =>
                Navigator.of(context).pop(_GroupChoice(value)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String?>(
                  value: null,
                  title: Text(l10n.bookmarksNoGroup),
                ),
                for (final g in groups)
                  RadioListTile<String?>(value: g.id, title: Text(g.name)),
              ],
            ),
          ),
        ],
      ),
    );
    if (choice == null || choice.groupId == bookmark.groupId) return;
    store.addBookmark(bookmark, groupId: choice.groupId);
    if (context.mounted) {
      obaAnnounce(
        context,
        l10n.bookmarksMoved(
          store.findGroup(choice.groupId)?.name ?? l10n.bookmarksNoGroup,
        ),
      );
    }
  }

  /// Screen-reader equivalents of the menu, for a card's merged semantics.
  static Map<CustomSemanticsAction, VoidCallback> semanticActions(
    BuildContext context,
    Bookmark bookmark, {
    bool allowDelete = true,
  }) {
    final l10n = context.obaL10n;
    return {
      CustomSemanticsAction(label: l10n.bookmarksActionEdit): () =>
          edit(context, bookmark),
      CustomSemanticsAction(
        label: bookmark.isPinned
            ? l10n.bookmarksActionUnpin
            : l10n.bookmarksActionPin,
      ): () =>
          togglePin(context, bookmark),
      CustomSemanticsAction(label: l10n.bookmarksActionMove): () =>
          moveToGroup(context, bookmark),
      if (allowDelete)
        CustomSemanticsAction(label: l10n.bookmarksActionDelete): () =>
            delete(context, bookmark),
    };
  }
}

class _GroupChoice {
  const _GroupChoice(this.groupId);
  final String? groupId;
}

/// The "⋮" menu of a bookmark card.
class BookmarkMenuButton extends StatelessWidget {
  const BookmarkMenuButton({
    super.key,
    required this.bookmark,
    this.allowDelete = true,
  });

  final Bookmark bookmark;
  final bool allowDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return PopupMenuButton<String>(
      tooltip: l10n.bookmarksActionsFor(bookmark.name),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            BookmarkActions.edit(context, bookmark);
          case 'pin':
            BookmarkActions.togglePin(context, bookmark);
          case 'move':
            BookmarkActions.moveToGroup(context, bookmark);
          case 'delete':
            BookmarkActions.delete(context, bookmark);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: _MenuRow(Icons.edit_outlined, l10n.bookmarksActionEdit),
        ),
        PopupMenuItem(
          value: 'pin',
          child: _MenuRow(
            bookmark.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            bookmark.isPinned
                ? l10n.bookmarksActionUnpin
                : l10n.bookmarksActionPin,
          ),
        ),
        PopupMenuItem(
          value: 'move',
          child: _MenuRow(Icons.folder_outlined, l10n.bookmarksActionMove),
        ),
        if (allowDelete)
          PopupMenuItem(
            value: 'delete',
            child: _MenuRow(Icons.delete_outline, l10n.bookmarksActionDelete),
          ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      ExcludeSemantics(child: Icon(icon)),
      const SizedBox(width: 12),
      Flexible(child: Text(label)),
    ],
  );
}
