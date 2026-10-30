import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets/common.dart';

/// The frame shared by the three first-time setup steps (wireframes 01c to 01e):
/// logo, title, subtitle, the list of steps, and a white card for the step's form.
class SetupLayout extends StatelessWidget {
  static const steps = ['Master account', 'Tablet name', 'First employee'];

  final int step; // 1, 2, or 3
  final String subtitle;
  final Widget child;

  const SetupLayout({super.key, required this.step, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.panel,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              children: [
                const Logo(),
                const SizedBox(height: 26),
                const Text('Set up IMP', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.ink2),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 22,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var i = 1; i <= steps.length; i++)
                      Text(
                        '$i. ${steps[i - 1]}',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: i == step ? AppColors.ink : AppColors.ink2,
                          fontWeight: i == step ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 26),
                Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
