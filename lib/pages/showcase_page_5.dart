import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations_showcase/pages/common/showcase_config.dart';

import 'common/showcase_scaffold.dart';

/// Showcase of custom [AnimatedPulse]
class ShowcaseAnimatedPulse extends StatelessWidget {
  const ShowcaseAnimatedPulse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration = ShowcaseConfig.of(context)?.duration ??
        ShowcaseConfigData.defaultDuration;

    return ShowcaseScaffold(
      title: ShowcaseTitle.of(context),
      onRun: null,
      child: Center(
        child: AnimatedPulse(
          size: 36,
          color: Colors.red,
          duration: duration,
        ),
      ),
    );
  }
}

/// A circle filled with [color] and diameter of [size]
class ColoredCircle extends StatelessWidget {
  final double size;
  final Color color;

  const ColoredCircle({
    required this.size,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ColoredBox(
        color: color,
        child: SizedBox(
          width: size,
          height: size,
        ),
      ),
    );
  }
}

class AnimatedPulse extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;

  const AnimatedPulse({
    required this.color,
    required this.size,
    required this.duration,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PulseState();
}

class _PulseState extends State<AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );

  late final coreScaleUpAnimation = CurvedAnimation(
    parent: controller,
    curve: Interval(0.0, 0.3, curve: Curves.easeIn),
  ).drive(Tween(begin: 1.0, end: 1.25));

  late final coreScaleDownAnimation = CurvedAnimation(
    parent: controller,
    curve: Interval(0.7, 1.0, curve: Curves.easeIn),
  ).drive(Tween(begin: 1.0, end: 1.0 / 1.25));

  late final outerScaleUpAnimation = Tween(
    begin: 1.0,
    end: 2.5,
  ).animate(controller);

  late final outerFadeAnimation = Tween(
    begin: 1.0,
    end: 0.0,
  ).animate(controller);

  @override
  void initState() {
    super.initState();
    controller.repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.duration = widget.duration;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: outerScaleUpAnimation,
          child: FadeTransition(
            opacity: outerFadeAnimation,
            child: ColoredCircle(
              size: widget.size,
              color: widget.color,
            ),
          ),
        ),
        ScaleTransition(
          scale: coreScaleUpAnimation,
          child: ScaleTransition(
            scale: coreScaleDownAnimation,
            child: ColoredCircle(
              size: widget.size,
              color: widget.color,
            ),
          ),
        ),
      ],
    );
  }
}

/// Combines [first] and [next] into one animation with value
/// equal to multiplication of animations values
class MultiplyAnimation extends CompoundAnimation<double> {
  MultiplyAnimation(
    Animation<double> first,
    Animation<double> next,
  ) : super(first: first, next: next);

  @override
  double get value => first.value * next.value;
}
