# Batch 1 — Splash screen

Route `/splash`. A full-screen looping **video** background with a dark gradient, a scan-line
overlay, the logo, a tagline, three animated loading dots, a version label, and a black
fade-in/fade-out cover. Auto-advances to `/login` after ~2.9s.

Reference render: `SAAS People.dc.html` → the "01 · Splash" frame. Frame `412 × 892`.
Background base color behind the video: **`#08090C`**.

---

## Layer stack (bottom → top), all inside a `Stack`

The screen root is a `Scaffold` with `backgroundColor: Color(0xFF08090C)`, body is a `Stack`
that fills the screen (`Positioned.fill` / `fit: StackFit.expand`).

1. **Video** — `assets/splash.mp4`, looping, muted, autoplay.
   - `BoxFit.cover`, blurred `blur(2px)`, scaled `1.06`.
   - Flutter: `VideoPlayer` inside `FittedBox(fit: BoxFit.cover)` sized to the controller's
     `value.size`; wrap in `ImageFiltered(imageFilter: ImageFilter.blur(sigmaX:2,sigmaY:2))`
     and `Transform.scale(scale: 1.06)`.
   - Controller: `..setLooping(true) ..setVolume(0) ..initialize().then((_){ play(); setState })`.

2. **Gradient overlay** — `Positioned.fill`, a `DecoratedBox` with:
   `LinearGradient(begin: topCenter-ish (168°), colors: [rgba(8,9,12,.30), rgba(8,9,12,.62)@58%, rgba(8,9,12,.88)])`.
   - 168° ≈ begin `Alignment(-0.4,-1.0)` → end `Alignment(0.4,1.0)` (tune to match).
   - Colors: `Color(0x4D08090C)` (.30), `Color(0x9E08090C)` (.62) at stop `0.58`, `Color(0xE008090C)` (.88).

3. **Scan-line texture** — subtle diagonal repeating lines, `opacity .5`.
   - `background: repeating-linear-gradient(146deg, rgba(16,20,28,.022) 0–1px, transparent 1–5px)`.
   - Cheapest Flutter route: skip it, or use a tiny tiled `CustomPaint`. It's barely visible
     — ship without it first, add later if you want the exact texture. (Good learning task:
     draw it with `CustomPainter`.)

4. **Center content** — a `Column(mainAxisSize: min, mainAxisAlignment: center)`:
   - **Logo**: `assets/saas-logo.jpg`, `104 × 104`, `borderRadius 16`, `BoxFit.cover`,
     1px inset white ring `rgba(255,255,255,.16)` (use a `Container` border or `boxShadow`
     spread 1 with that color). Fade-up in over `.6s`.
   - `SizedBox(height: 12)`
   - **Tagline**: text `EMPOWERING OUR PEOPLE` — Geist 500, 11px, `letterSpacing .18em`
     (≈ 1.98), `color: rgba(255,255,255,.72)`, uppercase, centered. Fade-up `.7s`, delay `.1s`.

5. **Loading dots** — `Positioned(bottom: 96)`, centered `Row(gap: 7)` of three
   `6×6` circles. First `rgba(255,255,255,.9)`, other two `rgba(255,255,255,.4)`.
   Each pulses: opacity `.25 → 1 → .25` + `translateY 0 → -3 → 0`, `1.1s` loop,
   staggered delays `0 / .18s / .36s`.
   - Flutter: one `AnimationController(duration: 1100ms)..repeat()`; drive each dot with a
     `Tween` + phase offset via `Interval` or a `sin`-based value. Great intro to
     `AnimationController` + `AnimatedBuilder`.

6. **Version label** — `Positioned(bottom: 44)`, centered. `SAAS Properties · v1.0.0`
   — Geist 400, 11px, `rgba(255,255,255,.55)`.

7. **Enter cover** — a full black (`#08090C`) rect that fades OUT over `.6s` on mount
   (reveal animation). Optional polish; do it with a `TweenAnimationBuilder` opacity 1→0.

8. **Leave cover** — at ~2.5s a black rect fades IN over `.4s`, then at ~2.9s navigate to
   `/login`. In Flutter, just run a `Timer`/`Future.delayed`: fade a cover in, then
   `context.go('/login')`. Keep timings: cover-in at **2500ms**, navigate at **2900ms**.

---

## Animations summary (from the prototype)
| Element        | Animation | Duration / delay |
|----------------|-----------|------------------|
| Logo           | fade + slide-up 10px | .6s |
| Tagline        | fade + slide-up 10px | .7s, delay .1s |
| Each dot       | opacity .25↔1 + translateY 0↔-3 | 1.1s loop; delays 0 / .18 / .36 |
| Enter cover    | opacity 1→0 | .6s on mount |
| Leave cover    | opacity 0→1 | .4s, starts at 2.5s |
| Navigate       | → /login | at 2.9s |

`fadeUp` keyframe = `opacity 0→1` + `translateY 10px→0`.

---

## Widgets you'll learn here
- `StatefulWidget` + `initState`/`dispose` (video controller + timers + animation controller).
- `VideoPlayer` + `VideoPlayerController.asset`.
- `Stack` / `Positioned` / `Positioned.fill`.
- `AnimationController`, `Tween`, `AnimatedBuilder`, `TweenAnimationBuilder`, `Interval`.
- `ImageFiltered` + `ImageFilter.blur`, `Transform.scale`.
- `Timer` / `Future.delayed` + safe navigation (guard with `if (mounted)`).

## Ask Claude Code
- "Why `dispose()` the controllers, and what breaks if I don't?"
- "One `AnimationController` for all three dots vs three — which and why?"
- "How do I guarantee the video is initialized before the first frame shows?"
- "Should splash timing use `Timer`, `Future.delayed`, or the animation's `status` listener?"

## Definition of done
- Video plays, blurred + covered by the gradient; text is legible (≥ the tagline contrast).
- Logo + tagline fade up; three dots pulse in sequence.
- After ~2.9s it navigates to `/login` on its own.
- No controller-leak warnings on hot reload / dispose.
