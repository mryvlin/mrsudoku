import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Settings screen title and the gear icon's tooltip.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// Generic 'resume' word, used both as the pause-toggle tooltip and inside resumeButtonLabel.
  ///
  /// In de, this message translates to:
  /// **'Fortsetzen'**
  String get resume;

  /// Dismiss action on the hint explanation banner.
  ///
  /// In de, this message translates to:
  /// **'Verstanden'**
  String get hintDismiss;

  /// Home screen button offering to continue a saved game.
  ///
  /// In de, this message translates to:
  /// **'Fortsetzen - {difficulty} ({time})'**
  String resumeButtonLabel(String difficulty, String time);

  /// Heading above the board layout selector on the Home screen.
  ///
  /// In de, this message translates to:
  /// **'Spielmodus'**
  String get gameModeLabel;

  /// Heading above the difficulty selector on the Home screen.
  ///
  /// In de, this message translates to:
  /// **'Schwierigkeit'**
  String get difficultyLevelLabel;

  /// Tooltip for the pause button while the game is running.
  ///
  /// In de, this message translates to:
  /// **'Pausieren'**
  String get pause;

  /// Game screen AppBar title.
  ///
  /// In de, this message translates to:
  /// **'Sudoku - {difficulty}'**
  String gameTitle(String difficulty);

  /// Title of the dialog shown when the puzzle is solved.
  ///
  /// In de, this message translates to:
  /// **'Geschafft! 🎉'**
  String get wonTitle;

  /// Body of the win dialog.
  ///
  /// In de, this message translates to:
  /// **'Du hast das Rätsel in {time} gelöst.'**
  String wonMessage(String time);

  /// Title of the dialog shown when the mistake limit is reached.
  ///
  /// In de, this message translates to:
  /// **'Game Over'**
  String get gameOverTitle;

  /// Body of the game-over dialog.
  ///
  /// In de, this message translates to:
  /// **'Du hast das Fehlerlimit erreicht.'**
  String get gameOverMessage;

  /// Button on the win/game-over dialogs that returns to the Home screen.
  ///
  /// In de, this message translates to:
  /// **'Zum Menü'**
  String get backToMenu;

  /// Label shown on the paused-game overlay.
  ///
  /// In de, this message translates to:
  /// **'Pausiert'**
  String get paused;

  /// Settings switch title.
  ///
  /// In de, this message translates to:
  /// **'Fehlerlimit aktiv'**
  String get errorLimitTitle;

  /// Settings switch subtitle.
  ///
  /// In de, this message translates to:
  /// **'Spiel endet nach zu vielen Fehlern'**
  String get errorLimitSubtitle;

  /// Label above the max-mistakes slider.
  ///
  /// In de, this message translates to:
  /// **'Maximale Fehler'**
  String get maxMistakesTitle;

  /// Label above the max-hints slider.
  ///
  /// In de, this message translates to:
  /// **'Maximale Hinweise'**
  String get maxHintsTitle;

  /// Settings switch title.
  ///
  /// In de, this message translates to:
  /// **'Falsche Zahlen anzeigen'**
  String get showErrorsTitle;

  /// Settings switch subtitle.
  ///
  /// In de, this message translates to:
  /// **'Markiert falsch eingetragene Zahlen farblich'**
  String get showErrorsSubtitle;

  /// Settings switch title.
  ///
  /// In de, this message translates to:
  /// **'Hervorhebungen'**
  String get highlightsTitle;

  /// Settings switch subtitle.
  ///
  /// In de, this message translates to:
  /// **'Zeile/Spalte/Box und gleiche Zahlen farblich markieren'**
  String get highlightsSubtitle;

  /// Title above the highlight-color swatch picker.
  ///
  /// In de, this message translates to:
  /// **'Hervorhebungsfarbe'**
  String get highlightColorTitle;

  /// Settings switch title.
  ///
  /// In de, this message translates to:
  /// **'Sound'**
  String get soundTitle;

  /// Settings switch subtitle.
  ///
  /// In de, this message translates to:
  /// **'Feedback-Töne und Vibration bei Eingaben'**
  String get soundSubtitle;

  /// Heading above the theme radio group.
  ///
  /// In de, this message translates to:
  /// **'Design'**
  String get designHeading;

  /// Theme option: follow the OS setting.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Theme option: always light.
  ///
  /// In de, this message translates to:
  /// **'Hell'**
  String get themeLight;

  /// Theme option: always dark.
  ///
  /// In de, this message translates to:
  /// **'Dunkel'**
  String get themeDark;

  /// Heading above the language radio group.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get languageHeading;

  /// Language option: follow the OS setting.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// Language option: always German.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// Language option: always English.
  ///
  /// In de, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Highlight color name.
  ///
  /// In de, this message translates to:
  /// **'Rot'**
  String get highlightColorRed;

  /// Highlight color name.
  ///
  /// In de, this message translates to:
  /// **'Orange'**
  String get highlightColorOrange;

  /// Highlight color name.
  ///
  /// In de, this message translates to:
  /// **'Grün'**
  String get highlightColorGreen;

  /// Highlight color name.
  ///
  /// In de, this message translates to:
  /// **'Blau'**
  String get highlightColorBlue;

  /// Highlight color name.
  ///
  /// In de, this message translates to:
  /// **'Lila'**
  String get highlightColorPurple;

  /// Highlight color name.
  ///
  /// In de, this message translates to:
  /// **'Türkis'**
  String get highlightColorTeal;

  /// Difficulty level name.
  ///
  /// In de, this message translates to:
  /// **'Einfach'**
  String get difficultyEasy;

  /// Difficulty level name.
  ///
  /// In de, this message translates to:
  /// **'Mittel'**
  String get difficultyMedium;

  /// Difficulty level name.
  ///
  /// In de, this message translates to:
  /// **'Schwer'**
  String get difficultyHard;

  /// Difficulty level name.
  ///
  /// In de, this message translates to:
  /// **'Experte'**
  String get difficultyExpert;

  /// Board layout name: a single 9x9 grid.
  ///
  /// In de, this message translates to:
  /// **'Klassisch'**
  String get boardLayoutClassic;

  /// Board layout name: five overlapping 9x9 grids in a cross.
  ///
  /// In de, this message translates to:
  /// **'Samurai'**
  String get boardLayoutSamurai;

  /// Board layout name: two overlapping 9x9 grids sharing one box.
  ///
  /// In de, this message translates to:
  /// **'Zwilling'**
  String get boardLayoutTwin;

  /// Board layout name: eight overlapping 9x9 grids in a 3-2-3 arrangement.
  ///
  /// In de, this message translates to:
  /// **'Gattai-8'**
  String get boardLayoutGattai8;

  /// Board layout name: four overlapping 9x9 grids in a ring, with a hole in the center.
  ///
  /// In de, this message translates to:
  /// **'Sohei'**
  String get boardLayoutSohei;

  /// Toolbar button label.
  ///
  /// In de, this message translates to:
  /// **'Rückgängig'**
  String get undoLabel;

  /// Toolbar button label.
  ///
  /// In de, this message translates to:
  /// **'Wiederholen'**
  String get redoLabel;

  /// Toolbar button label (notes-mode toggle).
  ///
  /// In de, this message translates to:
  /// **'Notizen'**
  String get notesLabel;

  /// Toolbar button label (auto-fill notes).
  ///
  /// In de, this message translates to:
  /// **'Auto-Notizen'**
  String get autoNotesLabel;

  /// Toolbar button label (toggle: auto-fill cells with only one legal candidate).
  ///
  /// In de, this message translates to:
  /// **'Auto-Lösen'**
  String get autoSolveLabel;

  /// Toolbar button label showing remaining hints.
  ///
  /// In de, this message translates to:
  /// **'Hinweis ({count})'**
  String hintLabel(int count);

  /// Heading of the best-times card on the Home screen.
  ///
  /// In de, this message translates to:
  /// **'Bestenliste'**
  String get leaderboardTitle;

  /// Hint explanation for a naked single.
  ///
  /// In de, this message translates to:
  /// **'Zeile {row}, Spalte {col} hat nur einen möglichen Kandidaten: {value}.'**
  String hintNakedSingle(int row, int col, int value);

  /// Hint explanation for a hidden single. {unit} is one of unitRow/unitColumn/unitBox, already formatted.
  ///
  /// In de, this message translates to:
  /// **'In {unit} kann die {value} nur noch in Zeile {row}, Spalte {col} stehen.'**
  String hintHiddenSingle(String unit, int value, int row, int col);

  /// A row, by 1-based index, used inside hintHiddenSingle.
  ///
  /// In de, this message translates to:
  /// **'Zeile {n}'**
  String unitRow(int n);

  /// A column, by 1-based index, used inside hintHiddenSingle.
  ///
  /// In de, this message translates to:
  /// **'Spalte {n}'**
  String unitColumn(int n);

  /// A 3x3 box, by 1-based index, used inside hintHiddenSingle.
  ///
  /// In de, this message translates to:
  /// **'Box {n}'**
  String unitBox(int n);

  /// Lead-in sentence prepended to the base hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Nach Ausschluss durch ein Paar-Muster (Naked Pair / Pointing Pair / Box-Line Reduction):'**
  String get leadInPairElimination;

  /// Lead-in sentence prepended to the base hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Nach Ausschluss durch ein verstecktes Paar:'**
  String get leadInHiddenPair;

  /// Lead-in sentence prepended to the base hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Nach Ausschluss durch ein Kandidaten-Trio:'**
  String get leadInNakedTriple;

  /// Lead-in sentence prepended to the base hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Nach Ausschluss durch ein X-Wing-Muster:'**
  String get leadInXWing;

  /// Lead-in sentence prepended to the base hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Nach Ausschluss durch ein XY-Wing-Muster:'**
  String get leadInXYWing;

  /// Lead-in sentence prepended to the base hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Nach Ausschluss durch ein Swordfish-Muster:'**
  String get leadInSwordfish;

  /// Solving technique name shown before the hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Naked Single'**
  String get techniqueNakedSingle;

  /// Solving technique name shown before the hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Hidden Single'**
  String get techniqueHiddenSingle;

  /// Solving technique name shown before the hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Kandidaten-Ausschluss (Naked Pair / Pointing Pair / Box-Line Reduction)'**
  String get techniquePairElimination;

  /// Solving technique name shown before the hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Verstecktes Paar (Hidden Pair)'**
  String get techniqueHiddenPair;

  /// Solving technique name shown before the hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Kandidaten-Trio (Naked Triple)'**
  String get techniqueNakedTriple;

  /// Solving technique name shown before the hint explanation.
  ///
  /// In de, this message translates to:
  /// **'X-Wing'**
  String get techniqueXWing;

  /// Solving technique name shown before the hint explanation.
  ///
  /// In de, this message translates to:
  /// **'XY-Wing'**
  String get techniqueXYWing;

  /// Solving technique name shown before the hint explanation.
  ///
  /// In de, this message translates to:
  /// **'Swordfish'**
  String get techniqueSwordfish;

  /// Solving technique name for the direct-reveal fallback hint.
  ///
  /// In de, this message translates to:
  /// **'Rückwärtssuche (Ausprobieren)'**
  String get techniqueBacktracking;

  /// Hint message shown when no logical technique applies and the solution is revealed directly.
  ///
  /// In de, this message translates to:
  /// **'Keine einfache Logik-Regel greift hier - die Lösung für diese Zelle wird direkt verraten.'**
  String get hintDirectReveal;

  /// Stage 1 hint text when the next step places a number.
  ///
  /// In de, this message translates to:
  /// **'Im markierten Bereich lässt sich eine Zahl eintragen.'**
  String get hintNudgePlace;

  /// Stage 1 hint text when the next step only crosses out candidates.
  ///
  /// In de, this message translates to:
  /// **'Im markierten Bereich lässt sich ein Kandidat ausschließen.'**
  String get hintNudgeEliminate;

  /// Hint banner button: go to the next, more detailed hint stage.
  ///
  /// In de, this message translates to:
  /// **'Mehr Hilfe'**
  String get hintMore;

  /// Hint banner button: reveal the answer of the hint.
  ///
  /// In de, this message translates to:
  /// **'Antwort zeigen'**
  String get hintShowAnswer;

  /// Hint banner button: dismiss the hint without using it.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get hintCancel;

  /// Hint banner button: place the hinted number (spends a hint).
  ///
  /// In de, this message translates to:
  /// **'Zahl eintragen'**
  String get hintPlace;

  /// Hint banner button: cross the hinted candidates out of the notes (spends a hint).
  ///
  /// In de, this message translates to:
  /// **'Notizen anpassen'**
  String get hintApplyEliminations;

  /// Stage 2 explanation of a naked single (does not name the digit).
  ///
  /// In de, this message translates to:
  /// **'Naked Single: Die markierte Zelle hat nur noch einen Kandidaten.'**
  String get hintExplainNakedSingle;

  /// Stage 2 explanation of a hidden single. {unit} is already formatted (unitRow/unitColumn/unitBox).
  ///
  /// In de, this message translates to:
  /// **'Hidden Single: In {unit} passt eine Ziffer nur noch in eine Zelle - die markierte.'**
  String hintExplainHiddenSingle(String unit);

  /// Stage 2 explanation of a naked pair. {digits} is a formatted list such as "4, 7".
  ///
  /// In de, this message translates to:
  /// **'Naked Pair: Die markierten Zellen können zusammen nur {digits} enthalten, daher kommen diese Ziffern in den übrigen Zellen ihrer Einheit nicht vor.'**
  String hintExplainNakedPair(String digits);

  /// Stage 2 explanation of a pointing pair / box-line reduction. {digits} is a single digit.
  ///
  /// In de, this message translates to:
  /// **'Pointing Pair / Box-Line: In dieser Einheit kann die {digits} nur in den markierten Zellen stehen, daher kommt sie in der kreuzenden Einheit sonst nirgends vor.'**
  String hintExplainPointing(String digits);

  /// Stage 2 explanation of a hidden pair. {digits} is a formatted list.
  ///
  /// In de, this message translates to:
  /// **'Hidden Pair: Die Ziffern {digits} können nur in den markierten Zellen stehen, alle anderen Kandidaten dieser Zellen entfallen.'**
  String hintExplainHiddenPair(String digits);

  /// Stage 2 explanation of a naked triple. {digits} is a formatted list.
  ///
  /// In de, this message translates to:
  /// **'Naked Triple: Die markierten Zellen enthalten zusammen nur {digits}, daher kommen diese Ziffern in den übrigen Zellen ihrer Einheit nicht vor.'**
  String hintExplainNakedTriple(String digits);

  /// Stage 2 explanation of an X-Wing. {digits} is a single digit.
  ///
  /// In de, this message translates to:
  /// **'X-Wing: Die {digits} steckt in zwei Linien in den markierten Zellen fest, daher entfällt sie im Rest der Linien, die sie kreuzen.'**
  String hintExplainXWing(String digits);

  /// Stage 2 explanation of a Swordfish. {digits} is a single digit.
  ///
  /// In de, this message translates to:
  /// **'Swordfish: Die {digits} steckt in drei Linien in den markierten Zellen fest, daher entfällt sie im Rest der Linien, die sie kreuzen.'**
  String hintExplainSwordfish(String digits);

  /// Stage 2 explanation of an XY-Wing. {digits} is the digit that can be removed.
  ///
  /// In de, this message translates to:
  /// **'XY-Wing: Die markierten Zellen erzwingen die {digits} in einer der beiden äußeren Zellen, daher kann sie in keiner Zelle stehen, die beide sieht.'**
  String hintExplainXYWing(String digits);

  /// Stage 3 text of an elimination hint. {count} is the number of cells that lose a candidate.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{Streiche den durchgestrichenen Kandidaten in der markierten Zelle.} other{Streiche die durchgestrichenen Kandidaten in den {count} markierten Zellen.}}'**
  String hintAnswerEliminations(int count);

  /// Settings: how much a hint explains.
  ///
  /// In de, this message translates to:
  /// **'Hinweis-Stil'**
  String get hintStyleTitle;

  /// Settings: hint style option.
  ///
  /// In de, this message translates to:
  /// **'Einsteiger'**
  String get hintStyleBeginner;

  /// Settings: description of the beginner hint style.
  ///
  /// In de, this message translates to:
  /// **'Erklärt immer, warum eine Technik funktioniert.'**
  String get hintStyleBeginnerDesc;

  /// Settings: hint style option.
  ///
  /// In de, this message translates to:
  /// **'Standard'**
  String get hintStyleStandard;

  /// Settings: description of the standard hint style.
  ///
  /// In de, this message translates to:
  /// **'Die Erklärung ist einen Tipp entfernt.'**
  String get hintStyleStandardDesc;

  /// Settings: hint style option.
  ///
  /// In de, this message translates to:
  /// **'Minimal'**
  String get hintStyleMinimal;

  /// Settings: description of the minimal hint style.
  ///
  /// In de, this message translates to:
  /// **'Nennt nur die Technik, ohne sie zu erklären.'**
  String get hintStyleMinimalDesc;

  /// Settings: toggle title.
  ///
  /// In de, this message translates to:
  /// **'Hinweis für die gewählte Zelle'**
  String get hintSelectedOnlyTitle;

  /// Settings: toggle subtitle.
  ///
  /// In de, this message translates to:
  /// **'Ist eine Zelle gewählt, gibt es nur Hinweise zu dieser Zelle.'**
  String get hintSelectedOnlySubtitle;

  /// Title of the hint panel before a technique is named.
  ///
  /// In de, this message translates to:
  /// **'Hinweis'**
  String get hintPanelTitle;

  /// Hint panel: which stage of the hint is showing.
  ///
  /// In de, this message translates to:
  /// **'Schritt {stage} von {total}'**
  String hintStageLabel(int stage, int total);

  /// Hint panel button: go back one stage.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get hintBack;

  /// Hint panel button: show the rule behind the technique.
  ///
  /// In de, this message translates to:
  /// **'Warum funktioniert das?'**
  String get hintWhy;

  /// Hint panel: shown instead of the apply button when no hint charges remain.
  ///
  /// In de, this message translates to:
  /// **'Keine Hinweise mehr'**
  String get hintNoHintsLeft;

  /// Snackbar when selected-cell-only mode finds nothing for the selected cell.
  ///
  /// In de, this message translates to:
  /// **'Kein direkter Hinweis für diese Zelle. Wähle sie ab für einen allgemeinen Hinweis.'**
  String get hintNoneForCell;

  /// Tooltip of the hint panel's info button.
  ///
  /// In de, this message translates to:
  /// **'Technik-Erklärung'**
  String get hintGuideTooltip;

  /// Technique guide dialog button.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get guideClose;

  /// Technique guide: legend under the diagram.
  ///
  /// In de, this message translates to:
  /// **'Gelb: die Zellen, die das Muster bilden. Rot: ausgeschlossen bzw. entfernt.'**
  String get guideLegend;

  /// Hint panel title for a wrong-entry hint.
  ///
  /// In de, this message translates to:
  /// **'Fehler gefunden'**
  String get hintTitleMistake;

  /// Hint panel title for a wrong-notes hint.
  ///
  /// In de, this message translates to:
  /// **'Notizen prüfen'**
  String get hintTitleNotes;

  /// Technique name.
  ///
  /// In de, this message translates to:
  /// **'Naked Pair'**
  String get techniqueNakedPair;

  /// Technique name.
  ///
  /// In de, this message translates to:
  /// **'Pointing Pair / Box-Line Reduction'**
  String get techniquePointing;

  /// Stage 1 text of a mistake hint.
  ///
  /// In de, this message translates to:
  /// **'Auf dem Brett stimmt etwas nicht.'**
  String get hintNudgeFix;

  /// Stage 2 text of a wrong-entry hint.
  ///
  /// In de, this message translates to:
  /// **'Die markierte Zahl ist falsch.'**
  String get hintExplainWrongValue;

  /// Stage 2 text of a wrong-notes hint.
  ///
  /// In de, this message translates to:
  /// **'In den Notizen der markierten Zelle fehlt die richtige Ziffer.'**
  String get hintExplainWrongNotes;

  /// Stage 3 text of a wrong-entry hint.
  ///
  /// In de, this message translates to:
  /// **'Entferne die markierte Zahl.'**
  String get hintAnswerWrongValue;

  /// Stage 3 text of a wrong-notes hint.
  ///
  /// In de, this message translates to:
  /// **'Setze die Notizen der markierten Zelle auf ihre möglichen Kandidaten zurück.'**
  String get hintAnswerWrongNotes;

  /// Hint panel apply button for a wrong-entry hint (spends a hint).
  ///
  /// In de, this message translates to:
  /// **'Zahl entfernen'**
  String get hintRemoveNumber;

  /// Hint panel apply button for a wrong-notes hint (spends a hint).
  ///
  /// In de, this message translates to:
  /// **'Notizen zurücksetzen'**
  String get hintResetNotes;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Eine Zelle ist ein Naked Single, wenn durch ihre Zeile, Spalte und Box schon alle Ziffern bis auf eine ausgeschlossen sind. Die übrige Ziffer muss dort hin.'**
  String get guideNakedSingle;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Eine Ziffer ist ein Hidden Single in einer Einheit (Zeile, Spalte oder Box), wenn nur noch eine Zelle dieser Einheit sie aufnehmen kann. Auch wenn diese Zelle weitere Kandidaten hat, muss die Ziffer dort hin.'**
  String get guideHiddenSingle;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Können zwei Zellen einer Einheit nur dieselben zwei Ziffern enthalten, gehören diese Ziffern in genau diese Zellen, in der einen oder anderen Reihenfolge. Daher entfallen sie in allen anderen Zellen dieser Einheit.'**
  String get guideNakedPair;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Liegen alle verbleibenden Plätze einer Ziffer in einer Einheit auf einer Linie, die sie mit einer anderen Einheit teilt (etwa Box und Zeile), muss die Ziffer auf diese Linie. Daher entfällt sie im Rest der anderen Einheit.'**
  String get guidePointing;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Können zwei Ziffern nur in dieselben zwei Zellen einer Einheit, müssen genau diese Ziffern in diesen Zellen stehen. Alle anderen Kandidaten in diesen beiden Zellen entfallen.'**
  String get guideHiddenPair;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Enthalten drei Zellen einer Einheit zusammen nur drei Ziffern, gehören diese Ziffern in diese Zellen. Sie entfallen in allen anderen Zellen der Einheit.'**
  String get guideNakedTriple;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Kann eine Ziffer in zwei Zeilen nur in dieselben zwei Spalten, landet sie in zwei gegenüberliegenden Ecken eines Rechtecks. Daher entfällt sie im Rest dieser beiden Spalten (und ebenso mit vertauschten Zeilen und Spalten).'**
  String get guideXWing;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Eine Zelle mit den Kandidaten A und B sieht zwei Zellen mit A+C und B+C. Wie auch immer die erste Zelle ausgeht, C landet in einer der beiden anderen. Daher entfällt C in jeder Zelle, die beide sieht.'**
  String get guideXYWing;

  /// Technique guide text.
  ///
  /// In de, this message translates to:
  /// **'Wie ein X-Wing, aber über drei Zeilen und drei Spalten: Steckt eine Ziffer in drei Zeilen in denselben drei Spalten fest, entfällt sie im Rest dieser Spalten (und ebenso mit vertauschten Zeilen und Spalten).'**
  String get guideSwordfish;

  /// Line in the win dialog showing how many hints were used.
  ///
  /// In de, this message translates to:
  /// **'Genutzte Hinweise: {count}'**
  String wonHintsUsed(int count);

  /// Technique guide: extra legend line for diagrams that draw lines.
  ///
  /// In de, this message translates to:
  /// **'Linien: die beteiligten Zeilen und Spalten (rechteckiges Muster) bzw. die Zellen, die einander sehen (Wing); gestrichelt: sieht ebenfalls.'**
  String get guideLegendLines;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
