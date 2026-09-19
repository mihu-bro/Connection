import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Soft floating orbs + subtle gradient for romantic depth.
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        return Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: Stack(
            children: [
              // Soft rose orb — top left
              Positioned(
                top: -80 + (t * 40),
                left: -60 + (t * 30),
                child: _Orb(
                  size: 220,
                  color: AppTheme.rose.withValues(alpha: 0.09),
                ),
              ),
              // Soft purple orb — bottom right
              Positioned(
                bottom: -100 + ((1 - t) * 50),
                right: -80 + ((1 - t) * 40),
                child: _Orb(
                  size: 280,
                  color: const Color(0xFF7B5CFF).withValues(alpha: 0.07),
                ),
              ),
              // Tiny accent
              Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                right: 40 + (t * 20),
                child: _Orb(
                  size: 90,
                  color: AppTheme.blush.withValues(alpha: 0.05),
                ),
              ),
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.6,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }
}

/// Gentle pulse for online / heart indicators.
class PulseDot extends StatefulWidget {
  final Color color;
  final double size;
  const PulseDot({super.key, this.color = AppTheme.online, this.size = 10});

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = Curves.easeInOut.transform(_ctrl.value);
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size * (1 + t * 1.4),
              height: widget.size * (1 + t * 1.4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withValues(alpha: 0.25 * (1 - t)),
              ),
            ),
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}