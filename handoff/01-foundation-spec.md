# Batch 0 — Foundation (theme · tokens · fonts · routing · structure)

Build this first. No screens yet — just the scaffolding every screen references.
Ask Claude Code to comment WHY it makes each choice.

---

## 1. Packages (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1     # Instrument Serif (display) + Geist (UI)
  go_router: ^14.0.0       # named routing (or use Navigator 1.0 if you prefer to learn that first)
  video_player: ^2.9.1     # splash background video
  flutter_svg: ^2.0.10     # icons (outline set, stroke ~1.6–1.9)
```
> Learning note: `google_fonts` fetches fonts at runtime by default. For a shippable app,
> bundle them instead (download the .ttf, declare under `fonts:` in pubspec). Ask Claude
> Code to show both approaches.

Declare assets:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/splash.mp4
    - assets/saas-logo.jpg
```

---

## 2. Color tokens — EXACT hex (computed from the design's OKLCH)

Put these in `lib/theme/app_colors.dart` as two token sets, switched by theme.

### Light
| Token        | Hex        | Use |
|--------------|------------|-----|
| bg           | `#FCFCFC`  | screen background |
| surface      | `#FFFFFF`  | cards, inputs |
| surface2     | `#F0F0F0`  | chips, icon chips, subtle fills |
| ink          | `#000000`  | primary text, black hero cards, primary action fill |
| ink2         | `#525252`  | secondary text |
| ink3         | `#868686`  | tertiary text, icons |
| line         | `#E4E4E4`  | borders / dividers |
| accent       | `#000000`  | primary action fill |
| accentSoft   | `#EBEBEB`  | avatar / badge tint |

### Dark
| Token        | Hex        |
|--------------|------------|
| bg           | `#000000`  |
| surface      | `#090909`  |
| surface2     | `#222222`  |
| ink          | `#FFFFFF`  |
| ink2         | `#A4A4A4`  |
| ink3         | `#747474`  |
| line         | `#242424`  |
| accent       | `#2E2E2E`  |
| accentSoft   | `#333333`  |

### Status (both themes)
| Token    | Hex        | Use |
|----------|------------|-----|
| ok       | `#4B7453`  | success toast check |
| warn     | `#AC844A`  | warnings |
| info     | `#506E94`  | info |
| danger   | `#E54B4F`  | notification dots, errors |
| approve  | `#3AA460`  | Approved status badge |
| deny     | `#DB4241`  | Rejected status badge, Deny action |

Flutter `Color`: `#RRGGBB` → `Color(0xFFRRGGBB)` (prepend `FF` alpha). e.g.
`static const ink2 = Color(0xFF525252);`

Suggested shape:
```dart
class AppColors {
  final Color bg, surface, surface2, ink, ink2, ink3, line, accent, accentSoft;
  const AppColors({required this.bg, /* ... */});
  static const light = AppColors(bg: Color(0xFFFCFCFC), /* ... */);
  static const dark  = AppColors(bg: Color(0xFF000000), /* ... */);
}
// status colors are theme-independent -> a separate const class
```
Expose the active set through an `InheritedWidget`/`Theme extension` so widgets read
`context` tokens rather than importing constants directly. Ask Claude Code to explain
`ThemeExtension<T>` — it's the idiomatic way to carry custom tokens.

---

## 3. Typography

- **Display / headings:** Instrument Serif (regular 400). Titles ~27px, card titles 26–30px,
  stat values ~25px.
- **Body / UI:** Geist (400 / 500 / 600). Sizes 10–15px.

```dart
final display = GoogleFonts.instrumentSerif(fontSize: 27, height: 1.05);
final body    = GoogleFonts.geist(fontSize: 13, fontWeight: FontWeight.w500);
```
Build a small `AppText` helper or a `TextTheme` so sizes/weights are named, not scattered.
Common weights seen in the design: 400 (body), 500 (labels, meta), 600 (emphasis).
Common uppercase caption: `font 500 11px`, `letter-spacing .06–.18em`, color `ink3`.

> `letter-spacing: .14em` at 11px ≈ Flutter `letterSpacing: 1.54` (em × fontSize).

---

## 4. Shape & elevation
- Radii: cards **14–16**, hero/summary cards **18**, icon chips **10–12**, pills **999**,
  phone frame 38 (only for the prototype frame — a real app is edge-to-edge), bottom sheets **28** (top corners only).
- **No `BoxShadow`** anywhere except a subtle top shadow on the bottom nav
  (`BoxShadow(color: black12, blurRange..., offset: Offset(0,-1))`).
- **1px borders** in `line` on almost every card/input:
  `Border.all(color: tokens.line, width: 1)`.

## 5. Spacing
- Screen padding: **20** horizontal.
- Gaps: **10–14** between items. Prefer `Column`/`Wrap`/`GridView` with a fixed `gap`
  (use `SizedBox`/`spacing:` on `Wrap`/`Column spacing` in newer Flutter) over ad-hoc margins.

---

## 6. Routing & folder structure

Routes (from FLUTTER_CONTEXT.md §4):
`/splash /login /home /notifications /announcements /team /profile/:id /leave
/attendance /punch /documents /approvals /approvals/:ref /account /settings /help`

Start at `/splash`, auto-advance to `/login`, then `/home`.

Suggested structure:
```
lib/
  main.dart
  app.dart                 // MaterialApp.router + theme wiring
  theme/
    app_colors.dart
    app_text.dart
    app_theme.dart         // ThemeData light/dark + ThemeExtension
    theme_controller.dart  // ChangeNotifier: light/dark toggle
  routing/
    app_router.dart        // go_router config
  state/
    role_controller.dart   // employee | lead | hr gating
  models/                  // plain data classes (Batch-by-batch)
  widgets/                 // shared widgets (Batch 4+)
  screens/                 // one folder per screen (Batch 1+)
```

## 7. Controllers (simple state to start)
- `ThemeController extends ChangeNotifier` — holds `ThemeMode`, `toggle()`. Default: follow device.
- `RoleController extends ChangeNotifier` — `employee | lead | hr`; gates Approvals + lead summaries.

Use `ChangeNotifier` + `ListenableBuilder` (or `provider`) — simplest thing that teaches
Flutter state cleanly. You can graduate to Riverpod/Bloc later; don't start there.

---

## Definition of done for Batch 0
- App builds and runs to a blank `/home` placeholder.
- Light/dark toggle flips all tokens.
- Instrument Serif + Geist render (put a test `Text` on the placeholder to confirm).
- You can explain: `ThemeData` vs `ThemeExtension`, `Color(0xFF...)`, how routing resolves,
  and what a `ChangeNotifier` does.
