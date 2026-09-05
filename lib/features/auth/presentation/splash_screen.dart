import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';

// --- Spec values, named so the timeline reads like the design doc -----------

/// Base colour behind the video.
const _base = Color(0xFF08090C);

const _videoAsset = 'assets/splash.mp4';
const _posterAsset = 'assets/splash_poster.jpg';
const _logoAsset = 'assets/saas-logo.jpg';

/// Logo fades up over .6s; the tagline over .7s starting .1s later. Both are
/// driven by one 800ms controller and sliced with [Interval] (see initState).
const _introDuration = Duration(milliseconds: 800);
const _dotCycle = Duration(milliseconds: 1100);
const _enterCoverDuration = Duration(milliseconds: 600);
const _leaveCoverDuration = Duration(milliseconds: 400);

/// The black cover starts fading in at 2.5s; we navigate at 2.9s, by which
/// point it is fully opaque and the route change is invisible.
const _leaveCoverAt = Duration(milliseconds: 2500);
const _navigateAt = Duration(milliseconds: 2900);

/// `/splash` — video background, logo, tagline, pulsing dots, then `/login`.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// StatefulWidget because this screen owns things that live across rebuilds and
// must be torn down: a video controller, two animation controllers, two timers.
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _videoReady = false;

  late final AnimationController _intro;
  late final AnimationController _dots;
  late final Animation<double> _logoIn;
  late final Animation<double> _taglineIn;

  Timer? _coverTimer;
  Timer? _navTimer;
  bool _leaving = false;

  @override
  void initState() {
    super.initState();

    // ONE controller for the intro, sliced into two overlapping windows.
    // Two controllers would work, but then the fades could drift apart;
    // sharing a timeline keeps the .1s offset exact by construction.
    _intro = AnimationController(vsync: this, duration: _introDuration)
      ..forward();

    // Logo: 0 -> .6s of an .8s timeline = 0.000 -> 0.750
    _logoIn = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0, 0.75, curve: Curves.easeOut),
    );

    // Tagline: .1s -> .8s of an .8s timeline = 0.125 -> 1.000
    _taglineIn = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.125, 1, curve: Curves.easeOut),
    );

    // ONE controller for all three dots too. Each dot reads the same clock at
    // a phase offset, so they can never fall out of sync — which is exactly
    // what three independent 1.1s controllers would eventually do.
    _dots = AnimationController(vsync: this, duration: _dotCycle)..repeat();

    _initVideo();

    _coverTimer = Timer(_leaveCoverAt, () {
      if (mounted) setState(() => _leaving = true);
    });

    // `mounted` guard: if this screen is gone before 2.9s, the State is dead
    // and touching its context would throw.
    _navTimer = Timer(_navigateAt, () {
      if (mounted) context.go(Routes.login);
    });
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.asset(_videoAsset);
    _controller = controller;
    try {
      // Nothing renders until initialize() completes — until then the poster
      // frame covers the gap, so the splash never flashes bare #08090C.
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();
      if (!mounted) return;
      setState(() => _videoReady = true);
    } catch (_) {
      // Platforms with no video_player implementation (Windows desktop) land
      // here. The poster stays up and the splash still reads correctly.
    }
  }

  @override
  void dispose() {
    // Every one of these outlives the widget if not torn down: the timers
    // would fire into a dead State, and the controllers would keep ticking
    // (and the video decoding) for the life of the process.
    _coverTimer?.cancel();
    _navTimer?.cancel();
    _intro.dispose();
    _dots.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _base,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1 — poster + video, blurred and scaled past the edges.
          _Background(controller: _videoReady ? _controller : null),

          // 2 — darkening gradient so text stays legible over any video frame.
          const _GradientOverlay(),

          // 3 — barely-there diagonal scan lines.
          const _ScanLines(),

          // 4 — logo + tagline.
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FadeUp(
                  animation: _logoIn,
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadii.cardLarge),
                      // Painted over the image, giving the 1px inset ring.
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                      image: const DecorationImage(
                        image: AssetImage(_logoAsset),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _FadeUp(
                  animation: _taglineIn,
                  child: Text(
                    'EMPOWERING OUR PEOPLE',
                    textAlign: TextAlign.center,
                    style: AppTypography.geist(
                      size: 11,
                      weight: FontWeight.w500,
                      letterSpacing: AppTypography.emToPx(0.18, 11),
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 5 — three staggered pulsing dots.
          Positioned(
            left: 0,
            right: 0,
            bottom: 96,
            child: _LoadingDots(controller: _dots),
          ),

          // 6 — version label.
          Positioned(
            left: 0,
            right: 0,
            bottom: 44,
            child: Text(
              'SAAS Properties · v1.0.0',
              textAlign: TextAlign.center,
              style: AppTypography.geist(
                size: 11,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
          ),

          // 7 — enter cover: opaque on mount, fades out to reveal the screen.
          // TweenAnimationBuilder animates once on first build, so this needs
          // no controller of its own.
          IgnorePointer(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1, end: 0),
              duration: _enterCoverDuration,
              builder: (context, value, child) =>
                  ColoredBox(color: _base.withValues(alpha: value)),
            ),
          ),

          // 8 — leave cover: fades in at 2.5s so the jump to /login at 2.9s
          // happens behind black.
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _leaving ? 1 : 0,
              duration: _leaveCoverDuration,
              child: const ColoredBox(color: _base),
            ),
          ),
        ],
      ),
    );
  }
}

/// Poster image with the video painted over it once ready, both blurred 2px
/// and scaled 1.06 so the blur has no soft edge at the screen border.
class _Background extends StatelessWidget {
  const _Background({required this.controller});

  final VideoPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    final video = controller;

    return ClipRect(
      child: Transform.scale(
        scale: 1.06,
        child: ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Image(image: AssetImage(_posterAsset), fit: BoxFit.cover),
              if (video != null && video.value.isInitialized)
                // BoxFit.cover on a video means sizing a box to the video's own
                // dimensions and letting FittedBox scale it up. VideoPlayer on
                // its own always fills the box it is given, distorting it.
                FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: video.value.size.width,
                    height: video.value.size.height,
                    child: VideoPlayer(video),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    // 168 degrees in CSS is roughly this begin/end pair: mostly top-to-bottom,
    // tilted right. Alphas are the design's .30 / .62 / .88 written as hex
    // bytes: 0x4D / 0x9E / 0xE0.
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.4, -1),
          end: Alignment(0.4, 1),
          stops: [0, 0.58, 1],
          colors: [Color(0x4D08090C), Color(0x9E08090C), Color(0xE008090C)],
        ),
      ),
    );
  }
}

class _ScanLines extends StatelessWidget {
  const _ScanLines();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Opacity(
        opacity: 0.5,
        child: CustomPaint(painter: _ScanLinePainter()),
      ),
    );
  }
}

/// The design's `repeating-linear-gradient(146deg, ...)` texture.
///
/// Flutter has no repeating gradient, so we draw it: rotate the canvas to the
/// gradient's angle and stroke 1px lines every 5px.
class _ScanLinePainter extends CustomPainter {
  const _ScanLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF10141C).withValues(alpha: 0.022)
      ..strokeWidth = 1;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(146 * math.pi / 180);

    // Overdraw past the corners: after rotating, the visible area is wider
    // than the screen in canvas space.
    final extent = size.longestSide;
    for (var y = -extent; y <= extent; y += 5) {
      canvas.drawLine(Offset(-extent, y), Offset(extent, y), paint);
    }
    canvas.restore();
  }

  // Nothing here depends on changing state, so it never needs repainting.
  @override
  bool shouldRepaint(_ScanLinePainter oldDelegate) => false;
}

/// The design's `fadeUp` keyframe: opacity 0 to 1 while sliding up 10px.
class _FadeUp extends StatelessWidget {
  const _FadeUp({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      // `child` is built once and handed to the builder, not rebuilt 60x a
      // second — the whole reason AnimatedBuilder takes a child argument.
      child: child,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.controller});

  final AnimationController controller;

  /// Spec delays 0 / .18s / .36s, as fractions of the 1.1s cycle.
  static const _phases = [0.0, 0.18 / 1.1, 0.36 / 1.1];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 7,
      children: [
        for (var i = 0; i < 3; i++)
          _Dot(
            controller: controller,
            phase: _phases[i],
            baseOpacity: i == 0 ? 0.9 : 0.4,
          ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.controller,
    required this.phase,
    required this.baseOpacity,
  });

  final AnimationController controller;

  /// How far this dot lags the shared clock, as a fraction of one cycle.
  final double phase;

  /// The dot's own tint, before the pulse is applied on top.
  final double baseOpacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Dart's % on doubles always returns a positive result, so this wraps
        // cleanly even when controller.value is behind the phase offset.
        final t = (controller.value - phase) % 1.0;

        // 0 -> 1 -> 0 across the cycle, eased at the turns.
        final wave = t < 0.5 ? t / 0.5 : (1 - t) / 0.5;
        final eased = Curves.easeInOut.transform(wave);

        return Transform.translate(
          offset: Offset(0, -3 * eased),
          child: Opacity(
            opacity: 0.25 + 0.75 * eased,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: baseOpacity),
              ),
            ),
          ),
        );
      },
    );
  }
}
