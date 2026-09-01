import 'dart:async';
import 'dart:math' as math;

import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schooly/core/constants/imagess.dart';
import 'package:schooly/features/STUDENT/student_user/presentation/view_models/user_cubit.dart';
import 'package:schooly/features/TEACHER/user/presentation/view_models/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.82,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _floatAnimation = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _controller.repeat(reverse: true);
    _controller.forward();
    _startAppFlow();
  }

  Future<void> _startAppFlow() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final roleId = prefs.getInt('role_id');

    if (!mounted) return;

    if (token == null || token.isEmpty || roleId == null) {
      _goToLogin();
      return;
    }

    if (roleId == 2) {
      final userCubit = context.read<UserCubit>();
      await userCubit.loadUser();
      if (!mounted) return;

      if (userCubit.currentUser != null) {
        _goToHome();
        return;
      }
    } else if (roleId == 3) {
      final teacherCubit = context.read<UserCubitt>();
      await teacherCubit.loadUser();
      if (!mounted) return;

      if (teacherCubit.currentUser != null) {
        Navigator.pushReplacementNamed(context, '/teacher_home');
        return;
      }
    }

    _goToLogin();
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimateGradient(
        primaryColors: const [
          Color(0xFF061B3A),
          Color(0xFF0F4C81),
          Color(0xFF1D4ED8),
        ],
        secondaryColors: const [
          Color(0xFF7DD3FC),
          Color(0xFF2563EB),
          Color(0xFF0F172A),
        ],
        duration: const Duration(seconds: 6),
        curve: Curves.easeInOutSine,
        animateAlignments: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.transparent,
                      Colors.blueAccent.withOpacity(0.14),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 60,
                      spreadRadius: 18,
                      color: Colors.lightBlue.withOpacity(0.25),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              left: -70,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade200.withOpacity(0.18),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, _) {
                  return ClipPath(
                    clipper: _WaveClipper(
                      phase: _controller.value * (2 * math.pi),
                    ),
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.08),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _floatAnimation.value),
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: math.min(size.width * 0.74, 320),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.28),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade900.withOpacity(0.25),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.28),
                            width: 1,
                          ),
                        ),
                        child: Image.asset(logo, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'مدرسة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'القمة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFDBF4FF),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: 120,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFDDEEFF),
                              Color(0xFF7DD3FC),
                              Color(0xFF60A5FA),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double phase;

  const _WaveClipper({required this.phase});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);

    final amplitude = 34.0;
    final segments = 30;
    final step = size.width / segments;

    for (int i = 0; i <= segments; i++) {
      final x = i * step;
      final y =
          size.height * 0.72 +
          math.sin((x / size.width) * math.pi * 2 + phase) * amplitude;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) =>
      oldClipper.phase != phase;
}
