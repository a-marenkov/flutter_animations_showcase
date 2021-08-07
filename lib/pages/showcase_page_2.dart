import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations_showcase/pages/common/showcase_config.dart';

import 'common/showcase_scaffold.dart';

/// Showcase of [TweenAnimationBuilder] usage
class ShowcaseTweenAnimationBuilder extends StatefulWidget {
  const ShowcaseTweenAnimationBuilder({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseTweenAnimationBuilderState createState() =>
      _ShowcaseTweenAnimationBuilderState();
}

class _ShowcaseTweenAnimationBuilderState
    extends State<ShowcaseTweenAnimationBuilder> {
  bool value = false;
  bool hasRun = false;

  void toggle() {
    setState(() {
      value = !value;
      hasRun = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = ShowcaseConfig.of(context)?.duration ??
        ShowcaseConfigData.defaultDuration;

    return ShowcaseScaffold(
      title: widget.runtimeType.toString(),
      onRun: toggle,
      child: Center(
        child: TweenAnimationBuilder(
          duration: duration,
          curve: Curves.easeIn,
          tween: hasRun
              ? Tween<double>(
                  begin: value ? 0.0 : pi,
                  end: value ? pi : 0.0,
                )
              : Tween<double>(begin: 0.0, end: 0.0),
          builder: (BuildContext context, double value, Widget? child) {
            return Transform.rotate(
              angle: value,
              child: child,
            );
          },
          child: const Icon(
            Icons.arrow_upward_rounded,
            size: 56.0,
          ),
        ),
      ),
    );
  }
}
