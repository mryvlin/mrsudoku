import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/hint_engine.dart';
import '../../models/settings.dart';
import '../hint_text.dart';
import 'technique_guide.dart';

/// The panel that walks the player through a hint, shown between the board
/// and the toolbar while a hint is active. Replaces a one-line banner so
/// there is room for a title, the stage text, the rule behind the technique
/// and navigation - and so it stays readable on a large multi-grid board.
///
/// Stateless: the Game screen owns which [stage] is showing and what the
/// buttons do. The stages are 1 (nudge at the area), 2 (the technique and
/// its evidence cells) and 3 (the answer, with the button that applies it).
class HintPanel extends StatelessWidget {
  final HintStep step;
  final int stage;
  final HintStyle style;

  /// Whether the "why does this work?" rule is open (only matters for the
  /// non-beginner styles; beginner always shows it from stage 2).
  final bool whyExpanded;
  final int hintsRemaining;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onCancel;
  final VoidCallback onApply;
  final VoidCallback onToggleWhy;

  const HintPanel({
    super.key,
    required this.step,
    required this.stage,
    required this.style,
    required this.whyExpanded,
    required this.hintsRemaining,
    required this.onBack,
    required this.onNext,
    required this.onCancel,
    required this.onApply,
    required this.onToggleWhy,
  });

  String _applyLabel(AppLocalizations l10n) => switch (step.kind) {
        HintKind.place => l10n.hintPlace,
        HintKind.eliminate => l10n.hintApplyEliminations,
        HintKind.fixValue => l10n.hintRemoveNumber,
        HintKind.fixNotes => l10n.hintResetNotes,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final topic = guideTopicOf(step);
    final isLast = stage >= 3;

    final title = stage == 1 || !step.hasStages ? l10n.hintPanelTitle : describeHintTitle(step, l10n);
    // The minimal style names the technique and leaves it at that - but a
    // mistake hint has nothing else to say, so it always gets its sentence.
    final text = switch (stage) {
      1 => describeHintNudge(step, l10n),
      2 => style == HintStyle.minimal && topic != null ? null : describeHintExplanation(step, l10n),
      _ => describeHint(step, l10n),
    };
    final canExplain = topic != null && stage >= 2;
    final showWhy = canExplain && (style == HintStyle.beginner || whyExpanded);

    return Card(
      key: const ValueKey('hint-panel'),
      margin: EdgeInsets.zero,
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, size: 20, color: theme.colorScheme.onSecondaryContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSecondaryContainer),
                  ),
                ),
                if (topic != null && stage >= 2)
                  IconButton(
                    key: const ValueKey('hint-guide'),
                    tooltip: l10n.hintGuideTooltip,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.info_outline, size: 20),
                    onPressed: () => showTechniqueGuide(context, topic),
                  ),
                if (step.hasStages)
                  Text(l10n.hintStageLabel(stage, 3), style: theme.textTheme.labelSmall),
              ],
            ),
            if (text != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSecondaryContainer)),
              ),
            if (showWhy)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  guideBody(topic, l10n),
                  key: const ValueKey('hint-why-text'),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSecondaryContainer),
                ),
              ),
            const SizedBox(height: 4),
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                if (canExplain && style != HintStyle.beginner)
                  TextButton(
                    key: const ValueKey('hint-why'),
                    onPressed: onToggleWhy,
                    child: Text(l10n.hintWhy),
                  ),
                if (stage > 1 && step.hasStages)
                  TextButton(key: const ValueKey('hint-back'), onPressed: onBack, child: Text(l10n.hintBack)),
                TextButton(key: const ValueKey('hint-cancel'), onPressed: onCancel, child: Text(l10n.hintCancel)),
                if (isLast)
                  FilledButton(
                    key: const ValueKey('hint-next'),
                    onPressed: hintsRemaining > 0 ? onApply : null,
                    child: Text(hintsRemaining > 0 ? _applyLabel(l10n) : l10n.hintNoHintsLeft),
                  )
                else
                  FilledButton(
                    key: const ValueKey('hint-next'),
                    onPressed: onNext,
                    child: Text(stage == 1 ? l10n.hintMore : l10n.hintShowAnswer),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
