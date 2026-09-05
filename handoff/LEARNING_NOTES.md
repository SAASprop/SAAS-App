# Learning notes — how to get the most out of each batch

You're building this to *learn Flutter*, not just to ship. Use this loop every batch.

## The loop
1. **Read the spec** for the batch (foundation first, then one screen).
2. **Prompt Claude Code** to build ONLY that batch, using what already exists, and to
   **comment the WHY**. Never let it jump ahead to other screens.
3. **Read every file** it produced, top to bottom. Highlight anything you can't explain.
4. **Ask** the "questions to ask" below until you can explain each highlight in your own words.
5. **Run & compare** against the `.dc.html` reference at 412×892. Note visual gaps.
6. **Refactor with it** — ask it to show an alternative approach to one piece, so you see
   trade-offs, not just one answer.
7. Advance only when you understand the batch.

## Golden prompts (reuse these)
- "Explain this file line by line as if I'm new to Flutter."
- "What would break if I removed this widget / this `dispose` / this `const`?"
- "Show me a simpler and a more idiomatic version of this, and say when each is better."
- "Which parts of this are Flutter fundamentals vs specific to this app?"
- "Point me at the official docs for the 3 most important widgets you used here."

## Fundamentals to nail (roughly in order)
- **Batch 0:** `StatelessWidget` vs `StatefulWidget`; the widget tree; `BuildContext`;
  `ThemeData` + `ThemeExtension`; `Color(0xFF…)`; how routing resolves; `ChangeNotifier`.
- **Batch 1 (Splash):** lifecycle (`initState`/`dispose`), `AnimationController`, `Stack`,
  async init, `mounted` guards, `Timer`.
- **Batch 3 (Home):** `GridView`/`Wrap`, tap handling (`InkWell`/`GestureDetector`),
  navigation between routes, passing data.
- **Batch 4 (ListLayout):** constructor params & required/named args, generics on model
  lists, `StatefulWidget` holding filter/search state, `ListView.builder`, conditional
  rendering (loading/empty/error), bottom sheets.

## Red flags — stop and ask if you see these
- A screen hard-codes a color hex inline instead of reading a theme token.
- A widget rebuilds on every frame when it doesn't need to (missing `const`).
- Controllers created but never disposed.
- Fixed pixel screen sizes instead of `MediaQuery`/`LayoutBuilder`/`Expanded`.
- The same UI copy-pasted 4× instead of a reusable widget (esp. list items — that's what
  `ListLayoutScreen` in Batch 4 is for).

## Pixel-perfect checklist (per screen)
- [ ] Colors match the token hex (Batch 0 table), not eyeballed.
- [ ] Font family/size/weight/letter-spacing per the spec.
- [ ] Radii and 1px `line` borders present.
- [ ] No stray shadows (only the bottom nav has one).
- [ ] Spacing: 20 screen padding, 10–14 gaps.
- [ ] Side-by-side screenshot vs the `.dc.html` frame looks identical at 412 wide.

## Progress tracker
- [ ] Batch 0 — Foundation
- [ ] Batch 1 — Splash
- [ ] Batch 2 — SSO Login
- [ ] Batch 3 — Home + bottom nav
- [ ] Batch 4 — ListLayoutScreen (Team / Leave / Documents / Approvals)
- [ ] Batch 5 — Detail screens (Profile, Request Detail, Attendance, Punch Clock)
- [ ] Batch 6 — Announcements, Notifications, Account, Settings, Help

When you're ready for the next screen's spec, ask me and I'll generate it the same way
(exact values pulled from the source) so you keep the batch rhythm.
