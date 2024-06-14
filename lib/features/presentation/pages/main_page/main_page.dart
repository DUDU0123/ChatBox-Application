import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  });
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          // web view
          return webScreenLayout;
        }
        // mobile view
        return mobileScreenLayout;
      },
    );
  }
}
