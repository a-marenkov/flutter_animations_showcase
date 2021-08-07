import 'package:flutter/material.dart';
import 'package:flutter_animations_showcase/pages/common/showcase_config.dart';

import 'pages/home_page.dart';
import 'strings.dart';

/// App entry point
void main() => runApp(App());

/// App's root widget
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShowcaseScope(
      child: MaterialApp(
        title: Strings.appTitle,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
