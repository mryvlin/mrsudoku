# mrsudoku

A complete, production-ready Sudoku game as a Flutter app - runnable as an
Android app and as a web app (Flutter Web). Fully offline, no cloud
dependency, localized in German and English. Supports five board layouts -
Classic (a single 9x9 grid), Samurai (five overlapping grids), Twin (two
overlapping grids), Gattai-8 (eight grids, also known as Harakiri), and Sohei
(four grids in a ring) - at four difficulty levels each.

## Architecture

The core UI (grid, number entry, number pad) is built with plain Flutter
widgets instead of a pure Flame-canvas solution - for a grid-based puzzle
this is more robust, more accessible (screen reader, touch targets, layout),
and easier to maintain. Flame is used specifically where it adds real value:
the win animation, where every digit of the solved board flies outward from
its cell, spinning and growing (`lib/ui/widgets/win_celebration.dart`).

**Board layouts are a shape, not a special case.** `PuzzleShape`
(`lib/models/puzzle_shape.dart`) generalizes "a 9x9 grid with 3x3 boxes" into
a set of active `(row, col)` cells plus a list of `Unit`s (row/column/box
groups of 9 cells that must each hold 1-9 exactly once) in one shared
coordinate space. A cell can belong to more than the usual 3 units - a cell
in a box shared between two grids (every non-classic layout is built from
overlapping 9x9 grids sharing a corner box, in various arrangements) belongs
to two row units and two column units (one pair per grid it's part of) plus
the shared box unit. `Solver`, `Validator`, `Candidates`, `HintEngine`, and
`Generator` all read this structure from `PuzzleShape` instead of assuming a
fixed 9x9 layout, so Samurai, Twin, Gattai-8 and Sohei aren't separate
implementations - they're just different `PuzzleShape`s (built from
different lists of grid origins) selected via the `BoardLayout` enum
(`lib/models/board_layout.dart`). `PuzzleShape.linkedUnitPairs` (every pair of
distinct units sharing 2+ cells, precomputed once) is what lets the
pointing-pair/box-line-reduction rule and the X-Wing/Swordfish fish
techniques generalize correctly across a shared box between grids, instead of
only working within a single classic 9x9 grid.

**Riverpod** (`flutter_riverpod`, the modern `Notifier`/`NotifierProvider`
API) is used for state management: it lets game logic be tested
independently of Flutter widgets (see `test/logic/game_controller_test.dart`,
which drives the controller through a `ProviderContainer` with no widget
tree at all), dependencies (persistence, sound, leaderboard) are cleanly
injected rather than referenced globally, and reactive updates to the board,
timer, and settings work without manual `setState` juggling.

**Localization** uses Flutter's standard ARB/`gen-l10n` toolchain
(`flutter_localizations`, `intl`, `lib/l10n/*.arb`), defaulting to the OS
locale (German otherwise) with an in-app override in Settings. The solving
logic stays presentation-agnostic: `HintEngine` returns structured data
(technique, position, which unit forced it) with no text at all, and
`ui/hint_text.dart` composes the localized explanation from it - keeping
`lib/logic/` free of Flutter/localization imports, consistent with the rest
of that layer.

### Project structure

```
lib/
  models/     Pure Dart, no Flutter imports: Cell, Board (shape-parameterized
              so it works with any PuzzleShape), PuzzleShape/Unit/UnitKind
              (the generalized row/column/box constraint system), BoardLayout
              (classic/samurai/twin/gattai8/sohei), Difficulty (per-layout
              clue counts via clueCountFor, plus the hint-technique cap per
              difficulty), Settings, GameState (board, solution, layout,
              undo/redo, auto-solve-singles toggle, etc.), LeaderboardEntry (now
              layout-aware). Immutable, JSON-serializable for persistence.
  logic/      Pure Dart: Solver (backtracking + uniqueness check, shape-
              aware), Generator (produces puzzles with a unique solution for
              any BoardLayout, retrying a hole layout that comes out harder
              than the difficulty allows), HintEngine (Naked/Hidden Single,
              Naked/Pointing Pair, Box-Line Reduction, Hidden Pair, Naked
              Triple, X-Wing, XY-Wing, Swordfish - shape-agnostic via
              PuzzleShape's units and linked-unit pairs - basis for hints and
              difficulty rating), Candidates, Validator (rule checking),
              GameController (Riverpod Notifier with the entire game state
              machine: input, hints, auto-solve-singles cascade, puzzle
              prewarming for the next game), SettingsController,
              LeaderboardController, and the saved-game provider that backs
              Home's resume offer.
  services/   Persistence (SharedPreferences) for game state, settings and
              the leaderboard (grouped by difficulty and board layout),
              PuzzleGenerationService (runs the generator in an isolate via
              compute() so puzzle generation doesn't block the UI, layout-
              aware), SoundService.
  l10n/       ARB source strings (`app_de.arb`, `app_en.arb`) and the
              generated `AppLocalizations` (see l10n.yaml).
  ui/         Flutter widgets: screens (Home - with a board-layout picker,
              Game, Settings) and reusable widgets (shape-agnostic Sudoku
              board, drawn by a single CustomPainter - cells, notes and the
              thick outline along box and grid edges - number pad, toolbar incl. the auto-solve
              toggle, leaderboard card grouped by difficulty and layout, win
              animation), plus small UI-layer helpers that localize model
              enums (difficulty names, board layout names, highlight color
              names, hint explanations) without pulling Flutter into
              models/ or logic/.
test/
  logic/      Unit tests: Solver, Validator, Generator (uniqueness and
              reproducibility per difficulty and per board layout, including
              a shared test helper for the non-classic layouts), HintEngine
              (every implemented technique through Swordfish, difficulty
              rating), GameController.
  models/     Unit tests: Difficulty, GameState, PuzzleShape (shape geometry:
              bounding box, unit counts, shared-cell unit membership),
              Settings.
  services/   Unit tests: LeaderboardService (ranking, per-difficulty-and-
              layout cap).
  ui/         Unit tests for the localized hint-explanation composer and the
              difficulty/highlight-color/board-layout label helpers.
  widgets/    Widget tests for core UI interactions: entering a number,
              entering a note, undo, the settings screen, the home screen
              (including the double-tap guard and the layout picker), the
              game screen (including the auto-solve toggle), and the board's
              hint-focused peer highlighting - through the real
              GameScreen/SettingsScreen/HomeScreen/SudokuBoardWidget UI.
```

## Features

- Five board layouts, all built from overlapping 9x9 grids that each share a
  corner box with a neighbor: **Classic** (one grid), **Samurai** (five
  grids in a cross, the four corner grids each sharing a box with the
  center grid), **Twin** (two grids sharing one box), **Gattai-8** (eight
  grids in a 3-2-3 "Harakiri" arrangement, two middle grids bridging the
  gaps in a top row of three and a bottom row of three), and **Sohei** (four
  grids in a ring, each sharing a box with its two ring-neighbors but with a
  genuine hole - no fifth grid - at the center). Picked from the Home screen
  alongside the difficulty.
- 9x9-per-grid Sudoku with cell notes (pencil marks) and status
  (given/entered). A note can only be added if it's still a legal
  candidate for the cell; a wrong number entry never erases existing
  notes (its own or a peer's) - only a confirmed-correct entry does.
- Puzzle generator with a guaranteed unique solution, four difficulty
  levels (Easy/Medium/Hard/Expert) per board layout, controlled via clue
  count and required solving technique, each tuned separately per layout.
  The next likely puzzle (same difficulty and layout) is generated
  speculatively in the background while the current game is played, so
  starting another round at the same settings is instant.
- Solver/hint engine covering Naked/Hidden Single, Naked Pair, Pointing
  Pair, Box-Line Reduction, Hidden Pair, Naked Triple, X-Wing, XY-Wing and
  Swordfish. Hints are tiered, so you only see as much as you ask for. A
  panel above the toolbar walks through three stages: a nudge that tints the
  area where the next step is, the technique with the cells that form it
  marked, and the answer, which is only applied (and a hint spent) once you
  take it. The first two stages are free, even with no hints left, and you
  can go back or cancel at any stage; a hint is dropped if you change the
  board while it is showing.
  - When the next logical move is only a reasoning step - a naked pair,
    X-Wing and the like - the hint is an elimination: the candidates it
    rules out are drawn struck through, and taking it crosses them out of
    your notes instead of placing a number. Fish and wings also draw their
    structure: the base and cover lines of an X-Wing or Swordfish, and the
    pivot-to-pincer links of an XY-Wing (with dashed lines to the cells
    that lose a candidate).
  - Hints respect your notes, so every hint moves on from the last one, and a
    single close to the selected cell is preferred. A setting can restrict
    hints to the selected cell.
  - A wrong entry, or notes that have lost a cell's true digit, get their own
    hint ("Mistake found" / "Check your notes") instead of blocking hints.
  - An info button opens a technique guide with a schematic of the pattern
    and the rule in plain words; a hint style setting (Beginner / Standard /
    Minimal) controls how much is explained by default.
  - The win dialog shows how many hints were used. Number of hints per game
    is configurable (default 5).
- Optional auto-solve: a toggle that automatically fills in any cell left
  with exactly one candidate after every move, one cell at a time. It
  respects your pencil marks: digits you've crossed out of a cell's notes
  count as eliminated, and removing a note re-runs it, so a cell you've
  narrowed down to one digit gets filled in. Cells without notes use their
  legal candidates.
- Cell selection via tap/click (tapping the already-selected cell
  deselects it), number pad (1-9 + erase), works with touch and mouse
  alike.
- Notes mode including one-click "auto-notes" (fills in all legal
  candidates automatically).
- Highlighting of row/column/box and matching numbers (can be turned off),
  with a selectable accent color (red/orange/green/blue/purple/teal).
- Error display (can be turned off) and mistake counter with a configurable
  limit.
- Undo/redo, timer (pausable).
- Robust autosave: the game in progress is saved after nearly every move,
  flushed immediately when leaving the game screen (back button/gesture) or
  when the app is backgrounded/closed, and offered for resume on the next
  launch - or the player can start a new game instead, replacing the save.
- Local leaderboard: the fastest completion times are tracked and shown on
  the Home screen, grouped by difficulty and board layout.
- Win detection with an exploding-digit animation (Flame): every digit
  flies outward from its cell, also on zoomed multi-grid boards.
- Dark/light mode and language (German/English) each optionally follow the
  system; a settings screen covers all of the above.

## Build

Prerequisite: [Flutter SDK](https://docs.flutter.dev/get-started/install)
(stable channel; developed and tested with Flutter 3.47.2 / Dart 3.13.2).

```bash
flutter pub get

# Android (APK)
flutter build apk

# Web
flutter build web
```

`flutter pub get` also regenerates `lib/l10n/app_localizations*.dart` from
the ARB files (`generate: true` in `pubspec.yaml`); run `flutter gen-l10n`
directly after editing an ARB file if you want the generated code refreshed
without a full `pub get`.

For local development/debugging:

```bash
flutter run -d chrome   # Web
flutter run             # connected Android device/emulator
```

## Tests

```bash
flutter test
```

Covers: Solver (randomized fill, uniqueness check), Generator (uniqueness
and reproducibility per difficulty level and per board layout), Validator
(row/column/box conflicts, solved-state detection), PuzzleShape (bounding
box, unit counts, shared-cell unit membership for every non-classic
layout), HintEngine (every implemented technique through Swordfish,
difficulty rating, and the stepwise hint ladder: soundness of every
elimination, convergence, use of the player's notes), GameController (input,
notes and their legality/preservation rules, undo/redo, hints including
elimination hints, auto-solve-singles
(including its note handling), auto-notes, autosave/resume, puzzle prewarming, leaderboard recording),
LeaderboardService (ranking and
per-difficulty-and-layout cap), Settings/GameState (defaults, JSON
round-trips), the localized hint-text and label helpers, and widget tests
for number entry, note entry, undo, the settings screen, the home screen
(including its board-layout picker), and the board's hint-focused
highlighting - through the real
GameScreen/SettingsScreen/HomeScreen/SudokuBoardWidget UI.

## Known limitations

- **Android SDK licenses in this development environment**: The Android SDK
  itself is at the version Flutter 3.47.2 expects, but `flutter doctor`
  reports outstanding license agreements; `flutter build apk` may fail here
  until they're accepted (`flutter doctor --android-licenses`). The code
  itself is platform-independent and has been successfully built/tested for
  web.
- **Intel Mac warning**: Flutter has announced it will stop supporting
  Intel-based Macs for Android/iOS builds in the future (`flutter doctor`
  shows a corresponding warning). This is irrelevant for web builds.
- **Puzzle generation on web**: `compute()` doesn't use a real OS thread on
  Flutter Web (web isolates/workers are limited), but instead runs
  asynchronously on the same thread. This is a bigger deal for the larger
  multi-grid layouts than it was for classic puzzles alone: a bigger shared
  constraint system makes every uniqueness check costlier, and generation
  time can spike non-linearly below a clue-count threshold found
  empirically during development - up to ~90s on some Samurai seeds even
  after a solver search upgrade. `Difficulty.clueCountFor` keeps each
  layout's targets a comfortable margin above its own cliff: found around
  110-115 clues for Samurai (369 active cells), around 171 for Gattai-8 (576
  active cells, the largest layout), and somewhere below 85 for Sohei (288
  active cells; a run at 75 didn't finish in testing). Twin's much smaller
  shared constraint system (153 active cells) hasn't shown the same cliff
  down to far lower clue counts. None of this is true multithreading like
  on Android, so a slow generation still runs on the same thread as the UI,
  just without blocking it noticeably in practice.
- **Difficulty rating**: The hint engine implements a substantial set of
  solving techniques (Naked/Hidden Single through Swordfish and XY-Wing; see
  Features above), and Easy/Medium/Hard puzzles are always solvable using
  only techniques at or below their rated difficulty. Expert is
  deliberately left open-ended: `Difficulty.expert.maxAllowedTechniqueRank`
  equals `SolvingTechnique.backtracking`'s rank, so an Expert puzzle may
  still come out requiring a technique beyond the ones implemented (or
  outright guessing); `HintEngine.rateDifficulty` reports `backtracking` in
  that case, and the hint button falls back to directly revealing the cell
  instead of teaching a technique. In practice this now happens for a
  smaller fraction of Expert puzzles than before XY-Wing/Swordfish were
  added, but it's still possible by design - Expert's actual difficulty is
  controlled primarily via clue count, not a fully closed technique
  taxonomy.
- **Sound**: No custom audio assets are shipped. The sound toggle in
  settings controls system clicks (`SystemSound.play`) and haptic feedback.
  `lib/services/sound_service.dart` is deliberately encapsulated so that
  real sound effects (e.g. via `audioplayers`/`flame_audio`) can be added
  later without touching call sites elsewhere in the code.
- **Undo/redo history is not persisted**: Only the current game state
  (board, timer, mistakes, hints) is saved; the undo/redo stacks are reset
  after an app restart to keep the save size small.
- **Leaderboard is local-only**: Times are stored on-device
  (`shared_preferences`), grouped by difficulty and board layout and capped
  at the 10 fastest per group; there's no cross-device sync or global
  ranking.

## License

Copyright (C) 2026 Michael Ryvlin

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version. See [LICENSE](LICENSE) for the full text.
