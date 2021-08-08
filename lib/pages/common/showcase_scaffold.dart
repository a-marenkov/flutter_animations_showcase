import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../strings.dart';

/// Generic page wrapper for animation showcase
class ShowcaseScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onRun;

  const ShowcaseScaffold({
    Key? key,
    required this.title,
    required this.child,
    required this.onRun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btnStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: child),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 64,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          child: Text(Strings.back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: btnStyle),
                    ),
                    if (onRun != null) ...[
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: ElevatedButton(
                            child: Text(Strings.run),
                            onPressed: onRun,
                            style: btnStyle),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provides showcase string title through [InheritedWidget]
class ShowcaseTitle extends InheritedWidget {
  final Widget child;
  final String title;

  ShowcaseTitle({
    required this.child,
    required this.title,
  }) : super(child: child);

  static String of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShowcaseTitle>()?.title ?? '';

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    if (oldWidget is ShowcaseTitle) {
      return oldWidget.title != title;
    }
    return true;
  }
}
