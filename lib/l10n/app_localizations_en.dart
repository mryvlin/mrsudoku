// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get resume => 'Resume';

  @override
  String get hintDismiss => 'Got it';

  @override
  String resumeButtonLabel(String difficulty, String time) {
    return 'Resume - $difficulty ($time)';
  }

  @override
  String get gameModeLabel => 'Game mode';

  @override
  String get difficultyLevelLabel => 'Difficulty';

  @override
  String get pause => 'Pause';

  @override
  String gameTitle(String difficulty) {
    return 'Sudoku - $difficulty';
  }

  @override
  String get wonTitle => 'Solved! 🎉';

  @override
  String wonMessage(String time) {
    return 'You solved the puzzle in $time.';
  }

  @override
  String get gameOverTitle => 'Game Over';

  @override
  String get gameOverMessage => 'You reached the mistake limit.';

  @override
  String get backToMenu => 'Back to Menu';

  @override
  String get paused => 'Paused';

  @override
  String get errorLimitTitle => 'Mistake limit active';

  @override
  String get errorLimitSubtitle => 'Game ends after too many mistakes';

  @override
  String get maxMistakesTitle => 'Maximum mistakes';

  @override
  String get maxHintsTitle => 'Maximum hints';

  @override
  String get showErrorsTitle => 'Show wrong numbers';

  @override
  String get showErrorsSubtitle => 'Marks incorrectly entered numbers in color';

  @override
  String get highlightsTitle => 'Highlights';

  @override
  String get highlightsSubtitle =>
      'Color-highlight the row/column/box and matching numbers';

  @override
  String get highlightColorTitle => 'Highlight color';

  @override
  String get soundTitle => 'Sound';

  @override
  String get soundSubtitle => 'Feedback tones and vibration on input';

  @override
  String get designHeading => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageHeading => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  @override
  String get highlightColorRed => 'Red';

  @override
  String get highlightColorOrange => 'Orange';

  @override
  String get highlightColorGreen => 'Green';

  @override
  String get highlightColorBlue => 'Blue';

  @override
  String get highlightColorPurple => 'Purple';

  @override
  String get highlightColorTeal => 'Teal';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get boardLayoutClassic => 'Classic';

  @override
  String get boardLayoutSamurai => 'Samurai';

  @override
  String get boardLayoutTwin => 'Twin';

  @override
  String get boardLayoutGattai8 => 'Gattai-8';

  @override
  String get boardLayoutSohei => 'Sohei';

  @override
  String get undoLabel => 'Undo';

  @override
  String get redoLabel => 'Redo';

  @override
  String get notesLabel => 'Notes';

  @override
  String get autoNotesLabel => 'Auto-Notes';

  @override
  String get autoSolveLabel => 'Auto-Solve';

  @override
  String hintLabel(int count) {
    return 'Hint ($count)';
  }

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String hintNakedSingle(int row, int col, int value) {
    return 'Row $row, column $col has only one possible candidate: $value.';
  }

  @override
  String hintHiddenSingle(String unit, int value, int row, int col) {
    return 'In $unit, $value can only go in row $row, column $col.';
  }

  @override
  String unitRow(int n) {
    return 'row $n';
  }

  @override
  String unitColumn(int n) {
    return 'column $n';
  }

  @override
  String unitBox(int n) {
    return 'box $n';
  }

  @override
  String get leadInPairElimination =>
      'After elimination via a pair pattern (naked pair / pointing pair / box-line reduction):';

  @override
  String get leadInHiddenPair => 'After elimination via a hidden pair:';

  @override
  String get leadInNakedTriple => 'After elimination via a candidate triple:';

  @override
  String get leadInXWing => 'After elimination via an X-Wing pattern:';

  @override
  String get leadInXYWing => 'After elimination via an XY-Wing pattern:';

  @override
  String get leadInSwordfish => 'After elimination via a Swordfish pattern:';

  @override
  String get techniqueNakedSingle => 'Naked Single';

  @override
  String get techniqueHiddenSingle => 'Hidden Single';

  @override
  String get techniquePairElimination =>
      'Candidate elimination (naked pair / pointing pair / box-line reduction)';

  @override
  String get techniqueHiddenPair => 'Hidden pair';

  @override
  String get techniqueNakedTriple => 'Naked triple';

  @override
  String get techniqueXWing => 'X-Wing';

  @override
  String get techniqueXYWing => 'XY-Wing';

  @override
  String get techniqueSwordfish => 'Swordfish';

  @override
  String get techniqueBacktracking => 'Backtracking (trial and error)';

  @override
  String get hintDirectReveal =>
      'No simple logical rule applies here - the solution for this cell is revealed directly.';

  @override
  String get hintNudgePlace =>
      'There\'s a number to place in the highlighted area.';

  @override
  String get hintNudgeEliminate =>
      'A candidate can be crossed out in the highlighted area.';

  @override
  String get hintMore => 'More help';

  @override
  String get hintShowAnswer => 'Show answer';

  @override
  String get hintCancel => 'Cancel';

  @override
  String get hintPlace => 'Place number';

  @override
  String get hintApplyEliminations => 'Update notes';

  @override
  String get hintExplainNakedSingle =>
      'Naked Single: the marked cell has only one candidate left.';

  @override
  String hintExplainHiddenSingle(String unit) {
    return 'Hidden Single: in $unit, one digit fits in only one cell - the marked one.';
  }

  @override
  String hintExplainNakedPair(String digits) {
    return 'Naked Pair: the marked cells can only hold $digits between them, so those digits can\'t appear in the other cells of their unit.';
  }

  @override
  String hintExplainPointing(String digits) {
    return 'Pointing Pair / Box-Line: in this unit, $digits can only go in the marked cells, so it can\'t appear anywhere else in the unit they cross.';
  }

  @override
  String hintExplainHiddenPair(String digits) {
    return 'Hidden Pair: $digits can only go in the marked cells, so every other candidate in those cells can be removed.';
  }

  @override
  String hintExplainNakedTriple(String digits) {
    return 'Naked Triple: the marked cells hold only $digits between them, so those digits can\'t appear in the other cells of their unit.';
  }

  @override
  String hintExplainXWing(String digits) {
    return 'X-Wing: $digits is confined to the marked cells in two lines, so it can be removed from the rest of the lines they cross.';
  }

  @override
  String hintExplainSwordfish(String digits) {
    return 'Swordfish: $digits is confined to the marked cells in three lines, so it can be removed from the rest of the lines they cross.';
  }

  @override
  String hintExplainXYWing(String digits) {
    return 'XY-Wing: the marked cells force $digits into one of the two outer cells, so it can\'t appear in any cell that sees both of them.';
  }

  @override
  String hintAnswerEliminations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cross out the struck candidates in the $count marked cells.',
      one: 'Cross out the struck candidate in the marked cell.',
    );
    return '$_temp0';
  }

  @override
  String get hintStyleTitle => 'Hint style';

  @override
  String get hintStyleBeginner => 'Beginner';

  @override
  String get hintStyleBeginnerDesc => 'Always explains why a technique works.';

  @override
  String get hintStyleStandard => 'Standard';

  @override
  String get hintStyleStandardDesc => 'The explanation is one tap away.';

  @override
  String get hintStyleMinimal => 'Minimal';

  @override
  String get hintStyleMinimalDesc =>
      'Only names the technique, without explaining it.';

  @override
  String get hintSelectedOnlyTitle => 'Hint for the selected cell';

  @override
  String get hintSelectedOnlySubtitle =>
      'With a cell selected, only give hints about that cell.';

  @override
  String get hintPanelTitle => 'Hint';

  @override
  String hintStageLabel(int stage, int total) {
    return 'Step $stage of $total';
  }

  @override
  String get hintBack => 'Back';

  @override
  String get hintWhy => 'Why does this work?';

  @override
  String get hintNoHintsLeft => 'No hints left';

  @override
  String get hintNoneForCell =>
      'No direct hint for this cell. Deselect it for a general hint.';

  @override
  String get hintGuideTooltip => 'Technique guide';

  @override
  String get guideClose => 'Close';

  @override
  String get guideLegend =>
      'Amber: the cells that form the pattern. Red: ruled out or removed.';

  @override
  String get hintTitleMistake => 'Mistake found';

  @override
  String get hintTitleNotes => 'Check your notes';

  @override
  String get techniqueNakedPair => 'Naked Pair';

  @override
  String get techniquePointing => 'Pointing Pair / Box-Line Reduction';

  @override
  String get hintNudgeFix => 'Something on the board isn\'t right.';

  @override
  String get hintExplainWrongValue => 'The marked number is wrong.';

  @override
  String get hintExplainWrongNotes =>
      'The notes in the marked cell are missing the right digit.';

  @override
  String get hintAnswerWrongValue => 'Remove the marked number.';

  @override
  String get hintAnswerWrongNotes =>
      'Reset the notes of the marked cell to its possible candidates.';

  @override
  String get hintRemoveNumber => 'Remove number';

  @override
  String get hintResetNotes => 'Reset notes';

  @override
  String get guideNakedSingle =>
      'A cell is a naked single when every digit but one is already ruled out by its row, column and box. The one digit left has to go there.';

  @override
  String get guideHiddenSingle =>
      'A digit is a hidden single in a unit (row, column or box) when only one cell in that unit can still take it. Even if that cell has other candidates, the digit has to go there.';

  @override
  String get guideNakedPair =>
      'When two cells in a unit can only hold the same two digits, those digits have to go in those two cells, in one order or the other. So they can be removed from every other cell in that unit.';

  @override
  String get guidePointing =>
      'When all the remaining spots for a digit in one unit lie on a line shared with another unit (a box and a row, say), the digit has to go on that line. So it can be removed from the rest of the other unit.';

  @override
  String get guideHiddenPair =>
      'When two digits can only go in the same two cells of a unit, those cells have to hold exactly those digits. Every other candidate in those two cells can be removed.';

  @override
  String get guideNakedTriple =>
      'When three cells in a unit hold only three digits between them, those digits belong to those cells. They can be removed from every other cell in that unit.';

  @override
  String get guideXWing =>
      'When a digit can only go in the same two columns in two different rows, it ends up in two opposite corners of a rectangle. So it can be removed from the rest of those two columns (and the same works with rows and columns swapped).';

  @override
  String get guideXYWing =>
      'A cell with candidates A and B sees two cells holding A+C and B+C. Whichever way the first cell turns out, C lands in one of the other two. So C can be removed from any cell that sees both of them.';

  @override
  String get guideSwordfish =>
      'Like an X-Wing, but across three rows and three columns: if a digit in three rows is confined to the same three columns, it can be removed from the rest of those columns (and likewise with rows and columns swapped).';

  @override
  String wonHintsUsed(int count) {
    return 'Hints used: $count';
  }

  @override
  String get guideLegendLines =>
      'Lines: the rows and columns involved (rectangle patterns) or the cells that see each other (wings); dashed: also sees it.';
}
