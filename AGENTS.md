# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Project

Color Spot (package name `color_spot`) — a Flutter "find the odd color" kids' game. 100 levels; each level shows an N×N grid of one Crayola color with a single tile shifted in HSL lightness, and the player must tap the odd tile before time runs out. Targets kids learning color names, with a bilingual learning feature (a secondary language shown under color names).

## Commands

```bash
flutter test                                  # run all tests
flutter test test/game_controller_test.dart   # run one test file
flutter test --plain-name "revive"            # run tests matching a name
flutter analyze                               # lint (flutter_lints defaults)
flutter run -d chrome                         # run the app (web enabled; iOS/Android also configured)
```

No codegen, no build_runner, no flutter gen-l10n — localization is hand-rolled (see below).

## Architecture

State management is plain `ChangeNotifier` + constructor injection — no Provider/Riverpod/bloc. Services are passed down explicitly from `main.dart` → `HomeScreen` → `GameScreen`.

The core loop lives in two pure-logic files, deliberately free of widget code so they're testable without plugins:

- `lib/logic/game_controller.dart` — the game state machine (`GamePhase`: playing → levelCleared/failFeedback → reviveOffer → gameOver/victory). Owns the countdown ticker and phase timers. Persists best level through the abstract `BestLevelStore` interface (implemented by `StorageService` over shared_preferences). Tests use `fake_async` to drive its timers.
- `lib/logic/level_generator.dart` — difficulty curve (`configFor`: grid size 2→9, color delta and time limit shrink over 100 levels) and board generation. Draws Crayola colors from a shuffled deck so no color repeats before the full palette is seen; shifts lightness in whichever direction stays visible for near-white/near-black crayons. Injectable `Random` for deterministic tests.

`_GameScreenState._onGameStateChanged` is the bridge between the state machine and navigation/dialogs: it listens on the controller and reacts to reviveOffer (revive dialog → ad), gameOver, and victory phases, guarded by `_handlingPhase` against re-entry.

**Ads**: `lib/services/ad_service.dart` defines the abstract `AdService` boundary; only `MockAdService` (fake 3-second ad) exists so far. A real google_mobile_ads implementation should swap in without touching game logic. The revive is one-per-run and requires watching the rewarded ad to completion.

## Localization (hand-rolled, two layers)

1. **UI strings** — `lib/l10n/app_strings.dart`: one `AppStrings` const per language, `supportedLanguages` lists all 23 (native names, `rtl` flag for Arabic). Adding a UI string means adding a field to `AppStrings` and a value in every language's instance.
2. **Color names** — `lib/data/color_name_translations.dart`: maps language code → official English Crayola name → localized name. Translation policy (documented in the file header): the few wrapper-verified official Spanish/French names are used as-is; everything else is our own translation, with fanciful names translated loosely to stay fun for kids. `CrayolaColor.nameIn(lang)` falls back to English.

`SettingsService` holds primary + optional secondary language (secondary must differ from primary). RTL is applied app-wide via a `Directionality` wrapper around the Navigator in `main.dart`, not per-screen.

`lib/data/crayola_colors.dart` is the official current 120-crayon box (Bluetiful in, retired colors out). Black and White are intentionally slightly off pure so the level generator can shift lightness in either direction — don't "fix" them to 0x000000/0xFFFFFF. `test/crayola_colors_test.dart` enforces the count and translation completeness.
