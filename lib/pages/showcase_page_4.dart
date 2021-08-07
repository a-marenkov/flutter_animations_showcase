import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations_showcase/pages/common/showcase_config.dart';

import 'common/showcase_scaffold.dart';

/// Showcase of custom [AnimatedCircleClip]
class ShowcaseAnimatedCircleClip extends StatefulWidget {
  const ShowcaseAnimatedCircleClip({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseAnimatedCircleClipState createState() =>
      _ShowcaseAnimatedCircleClipState();
}

class _ShowcaseAnimatedCircleClipState
    extends State<ShowcaseAnimatedCircleClip> {
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
      title: widget.runtimeType.toString(),
      onRun: onRun,
      child: Center(
        child: AnimatedCircleClip(
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

/// Animates visibility of the [child] by applying circle clip (aka crop)
/// transition
class AnimatedCircleClip extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final Duration duration;
  final Curve curve;

  const AnimatedCircleClip({
    Key? key,
    required this.child,
    required this.isVisible,
    required this.duration,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _AnimatedCircleClipState createState() => _AnimatedCircleClipState();
}

class _AnimatedCircleClipState extends State<AnimatedCircleClip>
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
  void didUpdateWidget(covariant AnimatedCircleClip oldWidget) {
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
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return ClipPath(
            clipper: _CircleClipper(animation.value),
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Clips circular path with radius of shortest side multiplied by [factor]
class _CircleClipper extends CustomClipper<Path> {
  final double factor;

  _CircleClipper(this.factor);

  @override
  Path getClip(Size size) {
    final path = Path();

    final center = size.center(Offset.zero);
    final r = size.shortestSide * factor;

    path.addRRect(
      RRect.fromLTRBR(
        center.dx - r,
        center.dy - r,
        center.dx + r,
        center.dy + r,
        Radius.circular(r),
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    if (oldClipper.runtimeType != _CircleClipper) {
      return true;
    }
    final typedOldClipper = oldClipper as _CircleClipper;
    return typedOldClipper.factor != factor;
  }
}

/// Circle clip transition
class CircleClipTransition extends AnimatedWidget {
  final Widget child;

  CircleClipTransition({
    required this.child,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final factor = listenable as Animation<double>;
    return ClipPath(
      clipper: _CircleClipper(factor.value),
      child: child,
    );
  }
}
