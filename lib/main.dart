import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/animated_background.dart';
import 'core/widgets/glass.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.voidBlack,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Firebase + Hive init will go here later

  runApp(const ProviderScope(child: ConnectionApp()));
}

class ConnectionApp extends StatelessWidget {
  const ConnectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connection',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashGate(),
    );
  }
}

/// Soft entry — heart pulse then fade into app.
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const PlaceholderHome(),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Soft glowing heart
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.roseGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.roseGlow,
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.08, 1.08),
                    duration: 900.ms,
                    curve: Curves.easeInOut,
                  ),

              const SizedBox(height: 28),

              Text(
                'Connection',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.15, end: 0, curve: Curves.easeOut),

              const SizedBox(height: 8),

              Text(
                'a private world for two',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textMuted,
                      letterSpacing: 0.8,
                    ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

/// Temporary home while we build real screens.
class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Connection',
                  style: Theme.of(context).textTheme.headlineMedium,
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideX(begin: -0.05, end: 0),
                const SizedBox(height: 6),
                Text(
                  'Foundation ready. Screens coming next.',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 100.ms),
                const SizedBox(height: 40),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppTheme.roseGradient,
                        ),
                        child: const Icon(Icons.favorite_rounded,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Clean Architecture',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Glass • Animations • Offline-first',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0),
                const Spacer(),
                RoseButton(
                  label: 'Continue Building',
                  icon: Icons.auto_awesome_rounded,
                  onPressed: () {},
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 350.ms)
                    .slideY(begin: 0.15, end: 0),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}