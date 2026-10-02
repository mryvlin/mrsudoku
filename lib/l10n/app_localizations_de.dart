// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get settings => 'Einstellungen';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get hintDismiss => 'Verstanden';

  @override
  String resumeButtonLabel(String difficulty, String time) {
    return 'Fortsetzen - $difficulty ($time)';
  }

  @override
  String get gameModeLabel => 'Spielmodus';

  @override
  String get difficultyLevelLabel => 'Schwierigkeit';

  @override
  String get pause => 'Pausieren';

  @override
  String gameTitle(String difficulty) {
    return 'Sudoku - $difficulty';
  }

  @override
  String get wonTitle => 'Geschafft! 🎉';

  @override
  String wonMessage(String time) {
    return 'Du hast das Rätsel in $time gelöst.';
  }

  @override
  String get gameOverTitle => 'Game Over';

  @override
  String get gameOverMessage => 'Du hast das Fehlerlimit erreicht.';

  @override
  String get backToMenu => 'Zum Menü';

  @override
  String get paused => 'Pausiert';

  @override
  String get errorLimitTitle => 'Fehlerlimit aktiv';

  @override
  String get errorLimitSubtitle => 'Spiel endet nach zu vielen Fehlern';

  @override
  String get maxMistakesTitle => 'Maximale Fehler';

  @override
  String get maxHintsTitle => 'Maximale Hinweise';

  @override
  String get showErrorsTitle => 'Falsche Zahlen anzeigen';

  @override
  String get showErrorsSubtitle =>
      'Markiert falsch eingetragene Zahlen farblich';

  @override
  String get highlightsTitle => 'Hervorhebungen';

  @override
  String get highlightsSubtitle =>
      'Zeile/Spalte/Box und gleiche Zahlen farblich markieren';

  @override
  String get highlightColorTitle => 'Hervorhebungsfarbe';

  @override
  String get soundTitle => 'Sound';

  @override
  String get soundSubtitle => 'Feedback-Töne und Vibration bei Eingaben';

  @override
  String get designHeading => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get languageHeading => 'Sprache';

  @override
  String get languageSystem => 'System';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  @override
  String get highlightColorRed => 'Rot';

  @override
  String get highlightColorOrange => 'Orange';

  @override
  String get highlightColorGreen => 'Grün';

  @override
  String get highlightColorBlue => 'Blau';

  @override
  String get highlightColorPurple => 'Lila';

  @override
  String get highlightColorTeal => 'Türkis';

  @override
  String get difficultyEasy => 'Einfach';

  @override
  String get difficultyMedium => 'Mittel';

  @override
  String get difficultyHard => 'Schwer';

  @override
  String get difficultyExpert => 'Experte';

  @override
  String get boardLayoutClassic => 'Klassisch';

  @override
  String get boardLayoutSamurai => 'Samurai';

  @override
  String get boardLayoutTwin => 'Zwilling';

  @override
  String get boardLayoutGattai8 => 'Gattai-8';

  @override
  String get boardLayoutSohei => 'Sohei';

  @override
  String get undoLabel => 'Rückgängig';

  @override
  String get redoLabel => 'Wiederholen';

  @override
  String get notesLabel => 'Notizen';

  @override
  String get autoNotesLabel => 'Auto-Notizen';

  @override
  String get autoSolveLabel => 'Auto-Lösen';

  @override
  String hintLabel(int count) {
    return 'Hinweis ($count)';
  }

  @override
  String get leaderboardTitle => 'Bestenliste';

  @override
  String hintNakedSingle(int row, int col, int value) {
    return 'Zeile $row, Spalte $col hat nur einen möglichen Kandidaten: $value.';
  }

  @override
  String hintHiddenSingle(String unit, int value, int row, int col) {
    return 'In $unit kann die $value nur noch in Zeile $row, Spalte $col stehen.';
  }

  @override
  String unitRow(int n) {
    return 'Zeile $n';
  }

  @override
  String unitColumn(int n) {
    return 'Spalte $n';
  }

  @override
  String unitBox(int n) {
    return 'Box $n';
  }

  @override
  String get leadInPairElimination =>
      'Nach Ausschluss durch ein Paar-Muster (Naked Pair / Pointing Pair / Box-Line Reduction):';

  @override
  String get leadInHiddenPair => 'Nach Ausschluss durch ein verstecktes Paar:';

  @override
  String get leadInNakedTriple => 'Nach Ausschluss durch ein Kandidaten-Trio:';

  @override
  String get leadInXWing => 'Nach Ausschluss durch ein X-Wing-Muster:';

  @override
  String get leadInXYWing => 'Nach Ausschluss durch ein XY-Wing-Muster:';

  @override
  String get leadInSwordfish => 'Nach Ausschluss durch ein Swordfish-Muster:';

  @override
  String get techniqueNakedSingle => 'Naked Single';

  @override
  String get techniqueHiddenSingle => 'Hidden Single';

  @override
  String get techniquePairElimination =>
      'Kandidaten-Ausschluss (Naked Pair / Pointing Pair / Box-Line Reduction)';

  @override
  String get techniqueHiddenPair => 'Verstecktes Paar (Hidden Pair)';

  @override
  String get techniqueNakedTriple => 'Kandidaten-Trio (Naked Triple)';

  @override
  String get techniqueXWing => 'X-Wing';

  @override
  String get techniqueXYWing => 'XY-Wing';

  @override
  String get techniqueSwordfish => 'Swordfish';

  @override
  String get techniqueBacktracking => 'Rückwärtssuche (Ausprobieren)';

  @override
  String get hintDirectReveal =>
      'Keine einfache Logik-Regel greift hier - die Lösung für diese Zelle wird direkt verraten.';

  @override
  String get hintNudgePlace =>
      'Im markierten Bereich lässt sich eine Zahl eintragen.';

  @override
  String get hintNudgeEliminate =>
      'Im markierten Bereich lässt sich ein Kandidat ausschließen.';

  @override
  String get hintMore => 'Mehr Hilfe';

  @override
  String get hintShowAnswer => 'Antwort zeigen';

  @override
  String get hintCancel => 'Abbrechen';

  @override
  String get hintPlace => 'Zahl eintragen';

  @override
  String get hintApplyEliminations => 'Notizen anpassen';

  @override
  String get hintExplainNakedSingle =>
      'Naked Single: Die markierte Zelle hat nur noch einen Kandidaten.';

  @override
  String hintExplainHiddenSingle(String unit) {
    return 'Hidden Single: In $unit passt eine Ziffer nur noch in eine Zelle - die markierte.';
  }

  @override
  String hintExplainNakedPair(String digits) {
    return 'Naked Pair: Die markierten Zellen können zusammen nur $digits enthalten, daher kommen diese Ziffern in den übrigen Zellen ihrer Einheit nicht vor.';
  }

  @override
  String hintExplainPointing(String digits) {
    return 'Pointing Pair / Box-Line: In dieser Einheit kann die $digits nur in den markierten Zellen stehen, daher kommt sie in der kreuzenden Einheit sonst nirgends vor.';
  }

  @override
  String hintExplainHiddenPair(String digits) {
    return 'Hidden Pair: Die Ziffern $digits können nur in den markierten Zellen stehen, alle anderen Kandidaten dieser Zellen entfallen.';
  }

  @override
  String hintExplainNakedTriple(String digits) {
    return 'Naked Triple: Die markierten Zellen enthalten zusammen nur $digits, daher kommen diese Ziffern in den übrigen Zellen ihrer Einheit nicht vor.';
  }

  @override
  String hintExplainXWing(String digits) {
    return 'X-Wing: Die $digits steckt in zwei Linien in den markierten Zellen fest, daher entfällt sie im Rest der Linien, die sie kreuzen.';
  }

  @override
  String hintExplainSwordfish(String digits) {
    return 'Swordfish: Die $digits steckt in drei Linien in den markierten Zellen fest, daher entfällt sie im Rest der Linien, die sie kreuzen.';
  }

  @override
  String hintExplainXYWing(String digits) {
    return 'XY-Wing: Die markierten Zellen erzwingen die $digits in einer der beiden äußeren Zellen, daher kann sie in keiner Zelle stehen, die beide sieht.';
  }

  @override
  String hintAnswerEliminations(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Streiche die durchgestrichenen Kandidaten in den $count markierten Zellen.',
      one: 'Streiche den durchgestrichenen Kandidaten in der markierten Zelle.',
    );
    return '$_temp0';
  }

  @override
  String get hintStyleTitle => 'Hinweis-Stil';

  @override
  String get hintStyleBeginner => 'Einsteiger';

  @override
  String get hintStyleBeginnerDesc =>
      'Erklärt immer, warum eine Technik funktioniert.';

  @override
  String get hintStyleStandard => 'Standard';

  @override
  String get hintStyleStandardDesc => 'Die Erklärung ist einen Tipp entfernt.';

  @override
  String get hintStyleMinimal => 'Minimal';

  @override
  String get hintStyleMinimalDesc =>
      'Nennt nur die Technik, ohne sie zu erklären.';

  @override
  String get hintSelectedOnlyTitle => 'Hinweis für die gewählte Zelle';

  @override
  String get hintSelectedOnlySubtitle =>
      'Ist eine Zelle gewählt, gibt es nur Hinweise zu dieser Zelle.';

  @override
  String get hintPanelTitle => 'Hinweis';

  @override
  String hintStageLabel(int stage, int total) {
    return 'Schritt $stage von $total';
  }

  @override
  String get hintBack => 'Zurück';

  @override
  String get hintWhy => 'Warum funktioniert das?';

  @override
  String get hintNoHintsLeft => 'Keine Hinweise mehr';

  @override
  String get hintNoneForCell =>
      'Kein direkter Hinweis für diese Zelle. Wähle sie ab für einen allgemeinen Hinweis.';

  @override
  String get hintGuideTooltip => 'Technik-Erklärung';

  @override
  String get guideClose => 'Schließen';

  @override
  String get guideLegend =>
      'Gelb: die Zellen, die das Muster bilden. Rot: ausgeschlossen bzw. entfernt.';

  @override
  String get hintTitleMistake => 'Fehler gefunden';

  @override
  String get hintTitleNotes => 'Notizen prüfen';

  @override
  String get techniqueNakedPair => 'Naked Pair';

  @override
  String get techniquePointing => 'Pointing Pair / Box-Line Reduction';

  @override
  String get hintNudgeFix => 'Auf dem Brett stimmt etwas nicht.';

  @override
  String get hintExplainWrongValue => 'Die markierte Zahl ist falsch.';

  @override
  String get hintExplainWrongNotes =>
      'In den Notizen der markierten Zelle fehlt die richtige Ziffer.';

  @override
  String get hintAnswerWrongValue => 'Entferne die markierte Zahl.';

  @override
  String get hintAnswerWrongNotes =>
      'Setze die Notizen der markierten Zelle auf ihre möglichen Kandidaten zurück.';

  @override
  String get hintRemoveNumber => 'Zahl entfernen';

  @override
  String get hintResetNotes => 'Notizen zurücksetzen';

  @override
  String get guideNakedSingle =>
      'Eine Zelle ist ein Naked Single, wenn durch ihre Zeile, Spalte und Box schon alle Ziffern bis auf eine ausgeschlossen sind. Die übrige Ziffer muss dort hin.';

  @override
  String get guideHiddenSingle =>
      'Eine Ziffer ist ein Hidden Single in einer Einheit (Zeile, Spalte oder Box), wenn nur noch eine Zelle dieser Einheit sie aufnehmen kann. Auch wenn diese Zelle weitere Kandidaten hat, muss die Ziffer dort hin.';

  @override
  String get guideNakedPair =>
      'Können zwei Zellen einer Einheit nur dieselben zwei Ziffern enthalten, gehören diese Ziffern in genau diese Zellen, in der einen oder anderen Reihenfolge. Daher entfallen sie in allen anderen Zellen dieser Einheit.';

  @override
  String get guidePointing =>
      'Liegen alle verbleibenden Plätze einer Ziffer in einer Einheit auf einer Linie, die sie mit einer anderen Einheit teilt (etwa Box und Zeile), muss die Ziffer auf diese Linie. Daher entfällt sie im Rest der anderen Einheit.';

  @override
  String get guideHiddenPair =>
      'Können zwei Ziffern nur in dieselben zwei Zellen einer Einheit, müssen genau diese Ziffern in diesen Zellen stehen. Alle anderen Kandidaten in diesen beiden Zellen entfallen.';

  @override
  String get guideNakedTriple =>
      'Enthalten drei Zellen einer Einheit zusammen nur drei Ziffern, gehören diese Ziffern in diese Zellen. Sie entfallen in allen anderen Zellen der Einheit.';

  @override
  String get guideXWing =>
      'Kann eine Ziffer in zwei Zeilen nur in dieselben zwei Spalten, landet sie in zwei gegenüberliegenden Ecken eines Rechtecks. Daher entfällt sie im Rest dieser beiden Spalten (und ebenso mit vertauschten Zeilen und Spalten).';

  @override
  String get guideXYWing =>
      'Eine Zelle mit den Kandidaten A und B sieht zwei Zellen mit A+C und B+C. Wie auch immer die erste Zelle ausgeht, C landet in einer der beiden anderen. Daher entfällt C in jeder Zelle, die beide sieht.';

  @override
  String get guideSwordfish =>
      'Wie ein X-Wing, aber über drei Zeilen und drei Spalten: Steckt eine Ziffer in drei Zeilen in denselben drei Spalten fest, entfällt sie im Rest dieser Spalten (und ebenso mit vertauschten Zeilen und Spalten).';

  @override
  String wonHintsUsed(int count) {
    return 'Genutzte Hinweise: $count';
  }
}
