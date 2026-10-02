import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mrsudoku/l10n/app_localizations.dart';
import 'package:mrsudoku/logic/providers.dart';
import 'package:mrsudoku/models/settings.dart';
import 'package:mrsudoku/ui/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('tapping a highlight color swatch updates the setting', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(container.read(settingsControllerProvider).highlightColor, HighlightColor.red);

    final l10n = AppLocalizations.of(tester.element(find.byType(SettingsScreen)))!;
    // The list is lazily built and the hint settings pushed the swatches
    // below the default test viewport, so scroll them into view first.
    await tester.scrollUntilVisible(find.byTooltip(l10n.highlightColorBlue), 200);
    await tester.ensureVisible(find.byTooltip(l10n.highlightColorBlue));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(l10n.highlightColorBlue));
    await tester.pump();

    expect(container.read(settingsControllerProvider).highlightColor, HighlightColor.blue);
  });

  testWidgets('the hint style and selected-cell-only settings can be changed', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pump();
    final l10n = AppLocalizations.of(tester.element(find.byType(SettingsScreen)))!;
    expect(container.read(settingsControllerProvider).hintStyle, HintStyle.standard);

    await tester.scrollUntilVisible(find.text(l10n.hintStyleBeginner), 200);
    await tester.ensureVisible(find.text(l10n.hintStyleBeginner));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.hintStyleBeginner));
    await tester.pump();
    expect(container.read(settingsControllerProvider).hintStyle, HintStyle.beginner);

    await tester.ensureVisible(find.text(l10n.hintSelectedOnlyTitle));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.hintSelectedOnlyTitle));
    await tester.pump();
    expect(container.read(settingsControllerProvider).hintSelectedCellOnly, isTrue);
  });
}
