import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import 'common/showcase_scaffold.dart';
import 'showcase_page_5.dart';

/// Showcase of [Bouncy] usage
class ShowcaseAnimatedBouncy extends StatefulWidget {
  const ShowcaseAnimatedBouncy({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseAnimatedBouncyState createState() => _ShowcaseAnimatedBouncyState();
}

class _ShowcaseAnimatedBouncyState extends State<ShowcaseAnimatedBouncy> {
  @override
  Widget build(BuildContext context) {
    return ShowcaseScaffold(
      title: widget.runtimeType.toString(),
      onRun: null,
      child: Center(
        child: Bouncy(
          child: ColoredCircle(
            size: 128,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}

class Bouncy extends StatefulWidget {
  final Widget child;

  const Bouncy({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _BouncyState createState() => _BouncyState();
}

class _BouncyState extends State<Bouncy> with SingleTickerProviderStateMixin {
  late final controller = AnimationController.unbounded(
    vsync: this,
  );

  final tween = Tween<Offset>(
    begin: Offset.zero,
    end: Offset.zero,
  );

  late final Animation<Offset> animation = tween.animate(controller);

  var offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    animation.addListener(() {
      setState(() {
        offset = animation.value;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: GestureDetector(
        onPanUpdate: (update) {
          controller.stop();
          setState(() {
            offset = offset.translate(
              update.delta.dx,
              update.delta.dy,
            );
          });
        },
        onPanEnd: (update) {
          tween.begin = offset;
          controller.animateWith(
            SpringSimulation(
              _springDescription(),
              0.0,
              1.0,
              (tween.begin! - tween.end!).distance / 128,
              tolerance: _kFlingTolerance,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

SpringDescription _springDescription() => SpringDescription.withDampingRatio(
      mass: 1,
      stiffness: Stiffness.medium,
      ratio: DampingRatio.highBouncy,
    );

const Tolerance _kFlingTolerance = Tolerance(
  velocity: double.infinity,
  distance: 0.00001,
);

class DampingRatio {
  static const highBouncy = 0.15;
  static const mediumBouncy = 0.5;
  static const lowBouncy = 0.75;
  static const noBouncy = 1.0;
}

class Stiffness {
  static const veryHigh = 10000.0;
  static const high = 5000.0;
  static const medium = 1500.0;
  static const low = 200.0;
  static const veryLow = 50.0;
}
