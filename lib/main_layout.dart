import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget? floatingActionButton;

  static const Color primaryColor = Color(0xff0d1321);
  static const Color backgroundColor = Color(0xfff0ebd8);
  static const Color editButton = Color(0xff3e5c76);
  static const Color deleteButton = Color(0xff0d1321);
  static const Color fab = Color(0xff748cab);

  static const Color textTitleColor = Color(0xff3e5c76);
  static const Color textSubtitleColor = Color(0xff748cab);
  static const Color inputFillColor = Color(0xff3e5c76);
  static const Color inputBorderColor = Color(0xff0d1321);
  static const Color labelColor = Color(0xff456882);

  final Widget child;
  final String title;
  final bool showAppBar;
  final List<Widget>? actions;

  const MainLayout({
    super.key,
    required this.child,
    this.title = '',
    this.showAppBar = true,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: showAppBar
          ? AppBar(
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              centerTitle: true,
              actions: actions,
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black26,
            )
          : null,
      body: SafeArea(child: child),
      floatingActionButton: floatingActionButton,
    );
  }
}
