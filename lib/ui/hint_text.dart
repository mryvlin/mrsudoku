import '../l10n/app_localizations.dart';
import '../logic/hint_engine.dart';
import '../models/board.dart';

/// Stage 1 of the tiered hint: only points at the highlighted area, saying
/// what kind of step is in it. Gives away neither the cell nor the digit.
String describeHintNudge(HintStep step, AppLocalizations l10n) => switch (step.kind) {
      HintKind.eliminate => l10n.hintNudgeEliminate,
      HintKind.place => l10n.hintNudgePlace,
      HintKind.fixValue || HintKind.fixNotes => l10n.hintNudgeFix,
    };

/// Stage 2: names the technique and what the marked cells show, still
/// without the answer a placement hint would give (the digit to place).
/// Elimination patterns do name their digits - they're what the pattern is
/// made of, and meaningless to see without them.
String describeHintExplanation(HintStep step, AppLocalizations l10n) {
  if (step.kind == HintKind.fixValue) return l10n.hintExplainWrongValue;
  if (step.kind == HintKind.fixNotes) return l10n.hintExplainWrongNotes;
  final pattern = step.pattern;
  if (pattern == null) {
    return step.singleKind == SingleKind.hidden
        ? l10n.hintExplainHiddenSingle(_unitLabel(step, l10n))
        : l10n.hintExplainNakedSingle;
  }
  final digits = (step.evidenceDigits.toList()..sort()).join(', ');
  return switch (pattern) {
    EliminationPattern.nakedPair => l10n.hintExplainNakedPair(digits),
    EliminationPattern.pointing => l10n.hintExplainPointing(digits),
    EliminationPattern.hiddenPair => l10n.hintExplainHiddenPair(digits),
    EliminationPattern.nakedTriple => l10n.hintExplainNakedTriple(digits),
    EliminationPattern.xWing => l10n.hintExplainXWing(digits),
    EliminationPattern.xyWing => l10n.hintExplainXYWing("${step.removals.first.$3}"),
    EliminationPattern.swordfish => l10n.hintExplainSwordfish(digits),
  };
}

/// Stage 3, the answer: the full explanation of a placement, or what to
/// cross out for an elimination step. Composed from a structured
/// [HintStep]; kept in the UI layer since `hint_engine.dart` is pure
/// solving logic with no text/localization concerns of its own.
String describeHint(HintStep step, AppLocalizations l10n) {
  if (step.technique == SolvingTechnique.backtracking) {
    return l10n.hintDirectReveal;
  }
  if (step.kind == HintKind.eliminate) {
    return l10n.hintAnswerEliminations(step.removalCells.length);
  }
  if (step.kind == HintKind.fixValue) return l10n.hintAnswerWrongValue;
  if (step.kind == HintKind.fixNotes) return l10n.hintAnswerWrongNotes;

  final base = step.singleKind == SingleKind.hidden
      ? l10n.hintHiddenSingle(_unitLabel(step, l10n), step.value, step.row + 1, step.col + 1)
      : l10n.hintNakedSingle(step.row + 1, step.col + 1, step.value);
  final leadIn = _leadIn(step.technique, l10n);
  final body = leadIn == null ? base : '$leadIn $base';
  return '${_techniqueLabel(step.technique, l10n)}: $body';
}

String _unitLabel(HintStep step, AppLocalizations l10n) {
  switch (step.hiddenUnit!) {
    case HintUnitType.row:
      return l10n.unitRow(step.row + 1);
    case HintUnitType.column:
      return l10n.unitColumn(step.col + 1);
    case HintUnitType.box:
      return l10n.unitBox(boxIndexOf(step.row, step.col) + 1);
  }
}

/// Short lead-in noting that a technique first had to narrow the candidates
/// down before the placed value became forced. Only meaningful for the
/// elimination-only tiers between naked/hidden single and backtracking.
String? _leadIn(SolvingTechnique technique, AppLocalizations l10n) {
  switch (technique) {
    case SolvingTechnique.pairElimination:
      return l10n.leadInPairElimination;
    case SolvingTechnique.hiddenPair:
      return l10n.leadInHiddenPair;
    case SolvingTechnique.nakedTriple:
      return l10n.leadInNakedTriple;
    case SolvingTechnique.xWing:
      return l10n.leadInXWing;
    case SolvingTechnique.xyWing:
      return l10n.leadInXYWing;
    case SolvingTechnique.swordfish:
      return l10n.leadInSwordfish;
    case SolvingTechnique.nakedSingle:
    case SolvingTechnique.hiddenSingle:
    case SolvingTechnique.backtracking:
      return null;
  }
}

String _techniqueLabel(SolvingTechnique technique, AppLocalizations l10n) {
  switch (technique) {
    case SolvingTechnique.nakedSingle:
      return l10n.techniqueNakedSingle;
    case SolvingTechnique.hiddenSingle:
      return l10n.techniqueHiddenSingle;
    case SolvingTechnique.pairElimination:
      return l10n.techniquePairElimination;
    case SolvingTechnique.hiddenPair:
      return l10n.techniqueHiddenPair;
    case SolvingTechnique.nakedTriple:
      return l10n.techniqueNakedTriple;
    case SolvingTechnique.xWing:
      return l10n.techniqueXWing;
    case SolvingTechnique.xyWing:
      return l10n.techniqueXYWing;
    case SolvingTechnique.swordfish:
      return l10n.techniqueSwordfish;
    case SolvingTechnique.backtracking:
      return l10n.techniqueBacktracking;
  }
}

/// The title of the hint panel once a hint is past its nudge: the technique
/// (or what kind of mistake) it is about.
String describeHintTitle(HintStep step, AppLocalizations l10n) {
  switch (step.kind) {
    case HintKind.fixValue:
      return l10n.hintTitleMistake;
    case HintKind.fixNotes:
      return l10n.hintTitleNotes;
    case HintKind.eliminate:
    case HintKind.place:
      final topic = guideTopicOf(step);
      return topic == null ? _techniqueLabel(step.technique, l10n) : guideTitle(topic, l10n);
  }
}

/// What the technique guide can explain. One per distinct pattern a player
/// can meet - finer than [SolvingTechnique], which lumps naked pairs and
/// pointing pairs together.
enum GuideTopic { nakedSingle, hiddenSingle, nakedPair, pointing, hiddenPair, nakedTriple, xWing, xyWing, swordfish }

/// The guide topic behind [step], or `null` for a mistake hint or the
/// direct-reveal fallback, which have no technique to explain.
GuideTopic? guideTopicOf(HintStep step) {
  if (step.kind == HintKind.fixValue || step.kind == HintKind.fixNotes) return null;
  if (step.technique == SolvingTechnique.backtracking) return null;
  final pattern = step.pattern;
  if (pattern == null) {
    return step.singleKind == SingleKind.hidden ? GuideTopic.hiddenSingle : GuideTopic.nakedSingle;
  }
  return switch (pattern) {
    EliminationPattern.nakedPair => GuideTopic.nakedPair,
    EliminationPattern.pointing => GuideTopic.pointing,
    EliminationPattern.hiddenPair => GuideTopic.hiddenPair,
    EliminationPattern.nakedTriple => GuideTopic.nakedTriple,
    EliminationPattern.xWing => GuideTopic.xWing,
    EliminationPattern.xyWing => GuideTopic.xyWing,
    EliminationPattern.swordfish => GuideTopic.swordfish,
  };
}

String guideTitle(GuideTopic topic, AppLocalizations l10n) => switch (topic) {
      GuideTopic.nakedSingle => l10n.techniqueNakedSingle,
      GuideTopic.hiddenSingle => l10n.techniqueHiddenSingle,
      GuideTopic.nakedPair => l10n.techniqueNakedPair,
      GuideTopic.pointing => l10n.techniquePointing,
      GuideTopic.hiddenPair => l10n.techniqueHiddenPair,
      GuideTopic.nakedTriple => l10n.techniqueNakedTriple,
      GuideTopic.xWing => l10n.techniqueXWing,
      GuideTopic.xyWing => l10n.techniqueXYWing,
      GuideTopic.swordfish => l10n.techniqueSwordfish,
    };

/// The rule behind a technique, in a few plain sentences - shown both as the
/// "why does this work?" line of a hint and in the technique guide.
String guideBody(GuideTopic topic, AppLocalizations l10n) => switch (topic) {
      GuideTopic.nakedSingle => l10n.guideNakedSingle,
      GuideTopic.hiddenSingle => l10n.guideHiddenSingle,
      GuideTopic.nakedPair => l10n.guideNakedPair,
      GuideTopic.pointing => l10n.guidePointing,
      GuideTopic.hiddenPair => l10n.guideHiddenPair,
      GuideTopic.nakedTriple => l10n.guideNakedTriple,
      GuideTopic.xWing => l10n.guideXWing,
      GuideTopic.xyWing => l10n.guideXYWing,
      GuideTopic.swordfish => l10n.guideSwordfish,
    };
