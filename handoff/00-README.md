# SAAS People — Flutter Handoff (batch / learning workflow)

This folder lets you build the app **one screen at a time with Claude Code** while
actually learning Flutter — instead of generating the whole UI at once.

## Files
- `01-foundation-spec.md` — **Batch 0.** Theme, color tokens (exact hex), fonts,
  routing, folder structure. Build this FIRST; everything else depends on it.
- `02-splash-spec.md` — **Batch 1.** The Splash screen, spec'd exactly.
- `LEARNING_NOTES.md` — the questions to ask at each batch so you learn deliberately.
- `assets/` — real assets (splash video, logo). Copy into your Flutter `assets/`.
- `FLUTTER_CONTEXT.md` (project root) — the full app map. Keep it as background; feed
  Claude Code the per-screen spec, not the whole thing.

## How to run each batch with Claude Code
1. Open your Flutter project in Claude Code.
2. For Batch 0: paste `01-foundation-spec.md` and say
   *"Build only the theme, tokens, fonts, and routing scaffold described here.
   Add comments explaining WHY, not just what. Don't build any screens yet."*
3. **Read every line it writes.** Ask it to explain anything unfamiliar before moving on.
4. `flutter run`, confirm it builds.
5. For Batch 1: paste `02-splash-spec.md` + remind it the foundation already exists.
   *"Build only the Splash screen using the existing theme/tokens. Explain your widget choices."*
6. Compare to the reference render, note gaps, ask follow-ups.
7. Only advance to the next screen once you understand the last one.

## Batch order (easy → hard)
0. Foundation (theme, tokens, fonts, routing, folders)
1. Splash
2. SSO Login
3. Home + bottom nav
4. `ListLayoutScreen` (reusable — powers Team, Leave, Documents, Approvals)
5. Detail screens (Profile, Request Detail, Attendance, Punch Clock)
6. Announcements, Notifications, Account, Settings, Help

## Reference render
The source of truth for pixel comparison is `SAAS People.dc.html` (project root),
frame `412 × 892`. Open it, switch **View → gallery** to see every screen side by side.

## Pixel-perfect rules
- Logical frame is **412 × 892** (a common Android reference). Test on a device/emulator
  near that size; use `MediaQuery`/`LayoutBuilder`, never hard-coded screen sizes.
- All sizes below are in **logical px = Flutter's dp**. Copy them verbatim.
- Colors are **exact sRGB hex** computed from the design's OKLCH tokens — use as-is.
- **No shadows** anywhere except a subtle top shadow on the bottom nav.
- Almost every card/input has a **1px border** in the `line` color.
