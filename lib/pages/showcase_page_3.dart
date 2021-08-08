import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations_showcase/pages/common/showcase_config.dart';

import 'common/showcase_scaffold.dart';

/// Showcase of custom [AnimatedVisibility]
class ShowcaseAnimatedVisibility extends StatefulWidget {
  const ShowcaseAnimatedVisibility({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcasePage1State createState() => _ShowcasePage1State();
}

class _ShowcasePage1State extends State<ShowcaseAnimatedVisibility> {
  bool value = true;

  void onRun() {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = ShowcaseConfig.of(context)?.duration ??
        ShowcaseConfigData.defaultDuration;

    return ShowcaseScaffold(
      title: ShowcaseTitle.of(context),
      onRun: onRun,
      child: Center(
        child: AnimatedVisibility(
          duration: duration,
          curve: Curves.easeIn,
          isVisible: value,
          child: FloatingActionButton(
            child: Icon(Icons.flutter_dash),
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

/// Animates visibility of the [child] by applying scale and fade transition
class AnimatedVisibility extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final Curve curve;

  const AnimatedVisibility({
    Key? key,
    required this.child,
    required this.isVisible,
    required this.duration,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _AnimatedVisibilityState createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: widget.duration,
    value: widget.isVisible ? 1.0 : 0.0,
    vsync: this,
  );

  late final animation = CurvedAnimation(
    curve: widget.curve,
    parent: controller,
  );

  @override
  void didUpdateWidget(covariant AnimatedVisibility oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.duration = widget.duration;
    animation.curve = widget.curve;
    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isVisible,
      child: ScaleTransition(
        scale: animation,
        child: FadeTransition(
          opacity: animation,
          child: widget.child,
        ),
      ),
    );
  }
}
