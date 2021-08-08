import 'package:flutter/material.dart';
import 'package:flutter_animations_showcase/pages/showcase_page_7.dart';

import '../strings.dart';
import 'common/showcase_config.dart';
import 'showcase_page_1.dart';
import 'showcase_page_2.dart';
import 'showcase_page_3.dart';
import 'showcase_page_4.dart';
import 'showcase_page_5.dart';
import 'showcase_page_6.dart';

/// Main page with list of showcases
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  /// all showcases
  static const showcases = <String, Widget>{
    'AnimatedContainer': ShowcaseAnimatedContainer(),
    'TweenAnimationBuilder': ShowcaseTweenAnimationBuilder(),
    'AnimatedVisibility': ShowcaseAnimatedVisibility(),
    'AnimatedCircleClip': ShowcaseAnimatedCircleClip(),
    'AnimatedPulse': ShowcaseAnimatedPulse(),
    'AnimatedHeroStatsGraph': ShowcaseAnimatedHeroStatsGraph(),
    'AnimatedBouncy': ShowcaseAnimatedBouncy(),
  };

  Widget build(BuildContext context) {
    final entries = showcases.entries.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appTitle),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: showcases.length,
                itemBuilder: (context, index) {
                  final showcase = entries[index];
                  return _HomeListItem(
                    index: index,
                    title: showcase.key,
                    addDivider: index < showcases.length - 1,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => showcase.value),
                      );
                    },
                  );
                },
              ),
            ),
            _DurationSetter(),
          ],
        ),
      ),
    );
  }
}

/// [HomePage] list item
class _HomeListItem extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback? onTap;
  final bool addDivider;

  const _HomeListItem({
    Key? key,
    required this.index,
    required this.title,
    required this.onTap,
    this.addDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(12.0),
          leading: Chip(
            label: Text(
              (index + 1).toString(),
              style: theme.accentTextTheme.button,
            ),
            backgroundColor: theme.primaryColor,
          ),
          trailing: Icon(Icons.navigate_next),
          title: Text(
            title,
            style: theme.textTheme.subtitle1,
          ),
          onTap: onTap,
        ),
        if (addDivider) Divider(indent: 64.0, height: 1.5, thickness: 1.5),
      ],
    );
  }
}

class _DurationSetter extends StatelessWidget {
  const _DurationSetter();

  @override
  Widget build(BuildContext context) {
    final config = ShowcaseConfig.of(context);
    if (config == null) return const SizedBox.shrink();
    return Card(
      color: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Strings.durationMs(config.duration.inMilliseconds)),
            Slider(
              min: ShowcaseConfigData.minMillis.toDouble(),
              max: ShowcaseConfigData.maxMillis.toDouble(),
              value: config.duration.inMilliseconds.toDouble(),
              onChanged: (double value) {
                config.duration = Duration(milliseconds: value.toInt());
              },
            ),
          ],
        ),
      ),
    );
  }
}
