import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/frame.dart';
import '../../widgets/heading.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../navigation/sheet_detents.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import '../../widgets/link_opener.dart';

/// A survey prompt for a stop page or the map. Put it in a feed or at the
/// top of a stop page; it shows nothing unless `SurveyService.shouldShowSurvey`
/// is true and there is a survey for [stop] (or for the map when [stop] is
/// null).
///
/// The card shows the survey's first ("hero") question inline: radio
/// choices, checkboxes, free text, or, for an external survey, a button that
/// opens the survey's link. "Next" sends the hero answer, then opens
/// [ObaSurveyRoute] with the remaining questions. "Not now" asks again in
/// three days (`SurveyService.postpone`); the dismiss button never asks
/// again for this survey.
///
/// It needs only an `ObaScope`. It starts a survey fetch itself (the
/// service rate-limits it).
class ObaSurveyCard extends StatefulWidget {
  const ObaSurveyCard({super.key, this.stop, this.onFinished});

  /// The stop being shown, for stop-targeted surveys and the answer's
  /// location. Null for the map.
  final Stop? stop;

  /// Called after the rider answered, postponed or dismissed.
  final VoidCallback? onFinished;

  @override
  State<ObaSurveyCard> createState() => _ObaSurveyCardState();
}

class _ObaSurveyCardState extends State<ObaSurveyCard> {
  Survey? _survey;
  bool _finished = false;
  bool _thanks = false;
  bool _busy = false;
  String? _error;
  Object? _answer;
  bool _fetchStarted = false;

  SurveyService get _service => ObaScope.of(context).core.surveys;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchStarted) {
      _fetchStarted = true;
      // The fetch notifies the service's listeners at once (another card
      // already on screen, say), so never start it mid-build.
      obaRunWhenSafe(() {
        if (mounted) _service.fetchSurveys();
      });
    }
  }

  void _pick() {
    if (_survey != null || _finished) return;
    final core = ObaScope.of(context).core;
    if (!core.surveys.shouldShowSurvey() ||
        !core.prompts.canShowInlineCards()) {
      return;
    }
    final stop = widget.stop;
    final survey = stop == null
        ? core.surveys.surveyForMap()
        : core.surveys.surveyForStop(stop.id, stop.routeIds);
    if (survey == null) return;
    _survey = survey;
    core.prompts.noteShown(PromptKind.surveyPrompt);
  }

  void _finish({bool thanks = false}) {
    setState(() {
      _finished = true;
      _thanks = thanks;
    });
    if (thanks) obaAnnounce(context, context.obaL10n.surveyThanks);
    widget.onFinished?.call();
  }

  Future<void> _next(Survey survey) async {
    final core = ObaScope.of(context).core;
    final hero = surveyQuestionsInOrder(survey).first;
    final answer = _answer;
    if (answer == null || answer == '' || answer is Set && answer.isEmpty) {
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final stop = widget.stop;
    try {
      final response = await core.surveys.submitHeroQuestion(
        survey: survey,
        answer: SurveyService.answerFor(hero, surveyAnswerText(hero, answer)),
        stopId: stop?.id,
        stopLocation: stop?.coordinate,
      );
      if (!mounted) return;
      core.surveys.markCompleted(survey);
      core.prompts.noteSurveyEngaged();
      final remaining = survey.questions.length > 1;
      if (remaining) {
        setState(() => _busy = false);
        _finish();
        await ObaNavigator.of(context).push(
          ObaSurveyRoute(
            survey: survey,
            heroResponseId: response.id,
            stopId: stop?.id,
          ),
        );
      } else {
        _finish(thanks: true);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = context.obaL10n.surveyFailed;
      });
    }
  }

  Future<void> _openExternal(Survey survey) async {
    final core = ObaScope.of(context).core;
    final url = core.surveys.externalSurveyUrl(survey, stop: widget.stop);
    final ok = url != null && await ObaLinkOpenerScope.of(context).open(url);
    if (!mounted) return;
    if (ok) {
      core.surveys.markCompleted(survey);
      core.prompts.noteSurveyEngaged();
      _finish();
    } else {
      setState(() => _error = context.obaL10n.surveyExternalError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final core = ObaScope.of(context).core;
    return ListenableBuilder(
      listenable: core.surveys.listenable,
      builder: (context, _) {
        _pick();
        final survey = _survey;
        if (_thanks) return _Thanks(text: context.obaL10n.surveyThanks);
        if (survey == null || _finished) return const SizedBox.shrink();
        return _card(context, survey);
      },
    );
  }

  Widget _card(BuildContext context, Survey survey) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final core = ObaScope.of(context).core;
    final hero = surveyQuestionsInOrder(survey).first;
    final content = hero.content;
    final external = content.type == QuestionType.externalSurvey;
    final single = survey.questions.length == 1;
    final answered =
        _answer != null &&
        _answer != '' &&
        !(_answer is Set && (_answer! as Set).isEmpty);
    final prompt = content.labelText.isEmpty
        ? l10n.surveyDefaultPrompt
        : content.labelText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 4, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ObaHeading(l10n.surveyCardTitle),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: l10n.surveyDismiss,
                    onPressed: () {
                      core.surveys.markCompleted(survey);
                      _finish();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12, bottom: 4),
                child: Text(prompt, style: theme.textTheme.bodyLarge),
              ),
              if (!external && content.type != QuestionType.label)
                SurveyQuestionField(
                  question: hero,
                  value: _answer,
                  onChanged: (v) => setState(() => _answer = v),
                ),
              if (_error != null)
                Semantics(
                  liveRegion: true,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8, end: 12),
                    child: Text(
                      _error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, end: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () {
                              core.surveys.postpone(survey);
                              _finish();
                            },
                      child: Text(l10n.surveyNotNow),
                    ),
                    if (external)
                      FilledButton(
                        onPressed: () => _openExternal(survey),
                        child: Text(surveyExternalButtonLabel(l10n, content)),
                      )
                    else if (content.type == QuestionType.label)
                      FilledButton(
                        onPressed: () {
                          core.surveys.markCompleted(survey);
                          _finish();
                          ObaNavigator.of(context).push(
                            ObaSurveyRoute(
                              survey: survey,
                              stopId: widget.stop?.id,
                            ),
                          );
                        },
                        child: Text(l10n.surveyTake),
                      )
                    else
                      FilledButton(
                        onPressed: answered && !_busy
                            ? () => _next(survey)
                            : null,
                        child: Text(
                          _busy
                              ? l10n.surveySubmitting
                              : single
                              ? l10n.surveySubmit
                              : l10n.surveyNext,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thanks extends StatelessWidget {
  const _Thanks({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    ),
  );
}

/// The survey's questions in position order; the first is the hero question.
List<SurveyQuestion> surveyQuestionsInOrder(Survey survey) {
  final indexed = survey.questions.indexed.toList()
    ..sort((a, b) {
      final byPosition = a.$2.position.compareTo(b.$2.position);
      return byPosition != 0 ? byPosition : a.$1.compareTo(b.$1);
    });
  return [for (final (_, q) in indexed) q];
}

/// The localized label of an external survey's button.
String surveyExternalButtonLabel(ObaLocalizations l10n, QuestionContent c) =>
    switch (c.externalSurveyButtonKey) {
      'learn_more' => l10n.surveyLearnMore,
      'share_feedback' => l10n.surveyShareFeedback,
      'sign_up' => l10n.surveySignUp,
      _ => l10n.surveyOpenSurvey,
    };

/// The wire text of an answer: a string for radio and text questions, a JSON
/// array for checkboxes (a `Set<String>` value).
String surveyAnswerText(SurveyQuestion q, Object value) {
  if (value is Set) {
    final options = q.content.options ?? const [];
    final chosen = [
      for (final o in options)
        if (value.contains(o)) o,
    ];
    return SurveyService.formatCheckboxAnswer(chosen);
  }
  return '$value';
}

/// One survey question's input: radio rows, checkbox rows or a text field.
/// [value] is a `String` (radio, text) or a `Set<String>` (checkbox).
class SurveyQuestionField extends StatelessWidget {
  const SurveyQuestionField({
    super.key,
    required this.question,
    required this.value,
    required this.onChanged,
  });

  final SurveyQuestion question;
  final Object? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = question.content.options ?? const <String>[];
    switch (question.content.type) {
      case QuestionType.radio:
        return RadioGroup<String>(
          groupValue: value is String ? value as String : null,
          onChanged: onChanged,
          child: Column(
            children: [
              for (final o in options)
                RadioListTile<String>(
                  value: o,
                  title: Text(o),
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        );
      case QuestionType.checkbox:
        final chosen = value is Set ? value! as Set : const <String>{};
        return Column(
          children: [
            for (final o in options)
              CheckboxListTile(
                value: chosen.contains(o),
                title: Text(o),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (on) {
                  final next = {...chosen.cast<String>()};
                  if (on == true) {
                    next.add(o);
                  } else {
                    next.remove(o);
                  }
                  onChanged(next);
                },
              ),
          ],
        );
      case QuestionType.text:
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: TextField(
            minLines: 2,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: context.obaL10n.surveyTextHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: onChanged,
          ),
        );
      case QuestionType.label || QuestionType.externalSurvey:
        return const SizedBox.shrink();
    }
  }
}

/// Opens [ObaSurveyPage].
class ObaSurveyRoute extends ObaCustomRoute {
  const ObaSurveyRoute({
    required this.survey,
    this.heroResponseId,
    this.stopId,
  });

  final Survey survey;

  /// The response created by the card's hero question. When null the page
  /// asks every question.
  final String? heroResponseId;
  final String? stopId;

  @override
  String get id => 'survey-${survey.id}';

  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;

  @override
  Widget build(BuildContext context) => ObaSurveyPage(
    survey: survey,
    heroResponseId: heroResponseId,
    stopId: stopId,
  );
}

/// The questions after the hero question (or all of them when
/// [heroResponseId] is null), with a submit button.
class ObaSurveyPage extends StatefulWidget {
  const ObaSurveyPage({
    super.key,
    required this.survey,
    this.heroResponseId,
    this.stopId,
  });

  final Survey survey;
  final String? heroResponseId;
  final String? stopId;

  @override
  State<ObaSurveyPage> createState() => _ObaSurveyPageState();
}

class _ObaSurveyPageState extends State<ObaSurveyPage> {
  final Map<int, Object?> _answers = {};
  bool _busy = false;
  bool _showRequired = false;
  String? _error;

  List<SurveyQuestion> get _questions {
    final all = surveyQuestionsInOrder(widget.survey);
    return widget.heroResponseId == null ? all : all.skip(1).toList();
  }

  static bool _isEmpty(Object? v) =>
      v == null || v == '' || v is Set && v.isEmpty;

  Future<void> _submit() async {
    final l10n = context.obaL10n;
    final core = ObaScope.of(context).core;
    final answerable = [
      for (final q in _questions)
        if (q.content.type != QuestionType.label &&
            q.content.type != QuestionType.externalSurvey)
          q,
    ];
    if (answerable.any((q) => q.required && _isEmpty(_answers[q.id]))) {
      setState(() {
        _showRequired = true;
        _error = l10n.surveyIncomplete;
      });
      obaAnnounce(context, l10n.surveyIncomplete);
      return;
    }
    final answers = [
      for (final q in answerable)
        if (!_isEmpty(_answers[q.id]))
          SurveyService.answerFor(q, surveyAnswerText(q, _answers[q.id]!)),
    ];
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      var responseId = widget.heroResponseId;
      if (responseId == null) {
        // No hero response yet: the first answer creates the response.
        if (answers.isEmpty) {
          if (mounted) ObaNavigator.of(context).pop();
          return;
        }
        final response = await core.surveys.submitHeroQuestion(
          survey: widget.survey,
          answer: answers.first,
          stopId: widget.stopId,
        );
        responseId = response.id;
        answers.removeAt(0);
      }
      if (answers.isNotEmpty) {
        await core.surveys.submitAdditionalQuestions(
          responseId: responseId,
          answers: answers,
        );
      }
      if (!mounted) return;
      core.surveys.markCompleted(widget.survey);
      core.prompts.noteSurveyEngaged();
      obaAnnounce(context, l10n.surveyThanks);
      ObaNavigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l10n.surveyFailed;
      });
      obaAnnounce(context, l10n.surveyFailed);
    }
  }

  Future<void> _openExternal(QuestionContent content) async {
    final core = ObaScope.of(context).core;
    final url = core.surveys.externalSurveyUrl(widget.survey);
    final ok = url != null && await ObaLinkOpenerScope.of(context).open(url);
    if (!mounted) return;
    if (ok) {
      core.surveys.markCompleted(widget.survey);
      ObaNavigator.of(context).pop();
    } else {
      setState(() => _error = context.obaL10n.surveyExternalError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final description = widget.survey.study.description;
    return ObaSheetPage(
      title: widget.survey.name.isEmpty
          ? l10n.surveyQuestionsTitle
          : widget.survey.name,
      slivers: [
        SliverList.list(
          children: [
            if (description != null && description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(description, style: theme.textTheme.bodyLarge),
              ),
            for (final q in _questions) _question(context, q),
            if (_error != null)
              Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: _busy ? null : _submit,
                child: Text(_busy ? l10n.surveySubmitting : l10n.surveySubmit),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _question(BuildContext context, SurveyQuestion q) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final c = q.content;
    final missing = _showRequired && q.required && _isEmpty(_answers[q.id]);
    final label = q.required && c.type != QuestionType.label
        ? '${c.labelText} (${l10n.surveyRequired})'
        : c.labelText;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: c.type == QuestionType.label
                ? theme.textTheme.bodyLarge
                : theme.textTheme.titleSmall,
          ),
          if (c.type == QuestionType.externalSurvey)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: FilledButton.tonal(
                onPressed: () => _openExternal(c),
                child: Text(surveyExternalButtonLabel(l10n, c)),
              ),
            )
          else
            SurveyQuestionField(
              question: q,
              value: _answers[q.id],
              onChanged: (v) => setState(() => _answers[q.id] = v),
            ),
          if (missing)
            Text(
              l10n.surveyRequired,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
