import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations_showcase/pages/common/showcase_config.dart';

import '../strings.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of custom [AnimatedHeroStatsGraph]
class ShowcaseAnimatedHeroStatsGraph extends StatefulWidget {
  const ShowcaseAnimatedHeroStatsGraph({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseAnimatedHeroStatsGraphState createState() =>
      _ShowcaseAnimatedHeroStatsGraphState();
}

class _ShowcaseAnimatedHeroStatsGraphState
    extends State<ShowcaseAnimatedHeroStatsGraph> {
  /// current values of sliders
  var strength = HeroStats.zero.strength;
  var agility = HeroStats.zero.agility;
  var intelligence = HeroStats.zero.intelligence;

  /// current hero stats
  var stats = HeroStats.zero;

  /// whether to update stats immediately
  var immediately = false;

  /// updates stats
  void updateStats() {
    stats = HeroStats(
      strength: strength,
      agility: agility,
      intelligence: intelligence,
    );
  }

  /// updates stats if necessary
  void shouldUpdateStats() {
    if (immediately) {
      updateStats();
    }
  }

  /// updates stats and runs animation
  void onRun() {
    setState(() {
      updateStats();
    });
  }

  /// sets [immediately] and if necessary updates stats and runs animation
  void onToggleImmediately() {
    setState(() {
      immediately = !immediately;
      shouldUpdateStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = ShowcaseConfig.of(context)?.duration ??
        ShowcaseConfigData.defaultDuration;

    return ShowcaseScaffold(
      title: widget.runtimeType.toString(),
      onRun: onRun,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AnimatedHeroStatsGraph(
              duration: duration,
              stats: stats,
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 8.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(Strings.runImmediately),
                    onTap: onToggleImmediately,
                    trailing: Checkbox(
                      value: immediately,
                      onChanged: (_) {
                        onToggleImmediately();
                      },
                    ),
                  ),
                  Text(Strings.strengthOf(strength.toStringAsFixed(0))),
                  Slider(
                    min: 0.0,
                    max: 100.0,
                    value: strength,
                    activeColor: Colors.red,
                    onChanged: (double value) {
                      setState(() {
                        strength = value;
                        shouldUpdateStats();
                      });
                    },
                  ),
                  Text(Strings.agilityOf(agility.toStringAsFixed(0))),
                  Slider(
                    min: 0.0,
                    max: 100.0,
                    value: agility,
                    activeColor: Colors.green,
                    onChanged: (double value) {
                      setState(() {
                        agility = value;
                        shouldUpdateStats();
                      });
                    },
                  ),
                  Text(Strings.intelligenceOf(intelligence.toStringAsFixed(0))),
                  Slider(
                    min: 0.0,
                    max: 100.0,
                    value: intelligence,
                    activeColor: Colors.blue,
                    onChanged: (double value) {
                      setState(() {
                        intelligence = value;
                        shouldUpdateStats();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// HeroStats model
class HeroStats {
  static const max = 100.0;
  static const zero = HeroStats(
    agility: 0.0,
    strength: 0.0,
    intelligence: 0.0,
  );

  final double strength;
  final double agility;
  final double intelligence;

  const HeroStats({
    required this.strength,
    required this.agility,
    required this.intelligence,
  });

  HeroStats operator +(HeroStats other) => HeroStats(
        strength: strength + other.strength,
        agility: agility + other.agility,
        intelligence: intelligence + other.intelligence,
      );

  HeroStats operator -(HeroStats other) => HeroStats(
        strength: strength - other.strength,
        agility: agility - other.agility,
        intelligence: intelligence - other.intelligence,
      );

  HeroStats operator *(double operand) => HeroStats(
        strength: strength * operand,
        agility: agility * operand,
        intelligence: intelligence * operand,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeroStats &&
          runtimeType == other.runtimeType &&
          strength == other.strength &&
          agility == other.agility &&
          intelligence == other.intelligence;

  @override
  int get hashCode =>
      strength.hashCode ^ agility.hashCode ^ intelligence.hashCode;

  /// convert to list of stats scale
  List<_HeroScale> get scales {
    return [
      _HeroScale(
        color: Colors.red,
        label: Strings.strength,
        angle: degreesToRadians(0),
        value: strength,
      ),
      _HeroScale(
        color: Colors.green,
        label: Strings.agility,
        angle: degreesToRadians(120),
        value: agility,
      ),
      _HeroScale(
        color: Colors.blue,
        label: Strings.intelligence,
        angle: degreesToRadians(240),
        value: intelligence,
      ),
    ];
  }
}

/// Hero stat scale model
class _HeroScale {
  final String label;
  final Color color;
  final double angle;
  final double value;

  _HeroScale({
    required this.label,
    required this.angle,
    required this.color,
    required this.value,
  });
}

/// Draws radial scale and fills with [HeroStats]
/// Animates on [HeroStats] changes
class AnimatedHeroStatsGraph extends StatefulWidget {
  final HeroStats stats;
  final Duration duration;
  final Curve curve;

  const AnimatedHeroStatsGraph({
    Key? key,
    required this.stats,
    required this.duration,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  _AnimatedHeroStatsGraphState createState() => _AnimatedHeroStatsGraphState();
}

class _AnimatedHeroStatsGraphState extends State<AnimatedHeroStatsGraph>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );

  late final curve = CurvedAnimation(
    curve: widget.curve,
    parent: controller,
  );

  final tween = Tween<HeroStats>(
    begin: HeroStats.zero,
    end: HeroStats.zero,
  );

  late final Animation<HeroStats> animation = tween.animate(curve);

  @override
  void initState() {
    super.initState();
    shouldRun(widget.stats);
  }

  @override
  void didUpdateWidget(covariant AnimatedHeroStatsGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.duration = widget.duration;
    curve.curve = widget.curve;
    shouldRun(widget.stats);
  }

  void shouldRun(HeroStats stats) {
    if (stats != tween.end) {
      controller.stop();
      tween.begin = animation.value;
      tween.end = stats;
      controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headline6 ?? TextStyle();
    final color = Theme.of(context).accentColor.withOpacity(0.3);

    return CustomPaint(
      painter: _HeroStatsGraphScalePainter(
        stats: HeroStats.zero,
        style: style,
      ),
      foregroundPainter: _HeroStatsGraphPainter(
        stats: animation,
        color: color,
        style: style,
      ),
    );
  }
}

double degreesToRadians(num degrees) => degrees * pi / 180.0;

class _HeroStatsGraphScalePainter extends CustomPainter {
  final TextStyle style;
  final HeroStats stats;

  late final scalePaint = Paint()
    ..strokeWidth = 1.0
    ..color = Colors.black;

  late final textPainter = TextPainter(
    text: TextSpan(text: '', style: style),
    textDirection: TextDirection.ltr,
  );

  _HeroStatsGraphScalePainter({
    required this.style,
    required this.stats,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    textPainter.layout();
    final labelHeight = textPainter.height;

    final radius = size.shortestSide / 2 - labelHeight;

    final scales = stats.scales;

    _drawScaleLines(canvas, center, scales, radius);
    _drawScaleMarks(canvas, center, scales, radius);
    _drawLabels(canvas, center, scales, radius, size.width);
  }

  void _drawScaleLines(
    Canvas canvas,
    Offset center,
    List<_HeroScale> scales,
    double radius,
  ) {
    for (final scale in scales) {
      canvas.drawLine(
        center,
        Offset(
          center.dx - radius * sin(scale.angle),
          center.dy - radius * cos(scale.angle),
        ),
        scalePaint,
      );
    }
  }

  void _drawScaleMarks(
    Canvas canvas,
    Offset center,
    List<_HeroScale> scales,
    double radius,
  ) {
    const shortMark = 2.0;
    const bigMark = 4.0;
    final marks = List.generate(10, (i) => i + 1);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    var currentAngle = 0.0;
    for (final scale in scales) {
      if (scale.angle != 0) {
        canvas.rotate(scale.angle - currentAngle);
        currentAngle = scale.angle;
      }
      for (final mark in marks) {
        final markSize = mark % 5 == 0 ? bigMark : shortMark;
        canvas.drawLine(
          Offset(-markSize, -radius / 10 * mark),
          Offset(markSize, -radius / 10 * mark),
          scalePaint,
        );
      }
    }
    canvas.restore();
  }

  void _drawLabels(
    Canvas canvas,
    Offset center,
    List<_HeroScale> scales,
    double radius,
    double width,
  ) {
    for (final scale in scales) {
      textPainter.text = TextSpan(
        text: scale.label,
        style: style.copyWith(color: scale.color),
      );
      textPainter.layout();
      final scaleTail = Offset(
        center.dx - radius * sin(scale.angle),
        center.dy - radius * cos(scale.angle),
      );

      final labelWidth = textPainter.width;
      final labelHeight = textPainter.height;
      final isCentered = scaleTail.dx == center.dx;
      final isAtLeft = scaleTail.dx < center.dx;

      final dx = isCentered
          ? scaleTail.dx - labelWidth / 2
          : (isAtLeft
              ? (scaleTail.dx - labelWidth).clamp(0.0, scaleTail.dx)
              : min(scaleTail.dx, width - labelWidth));

      final paintAbove = scaleTail.dy < center.dy;
      final dy = paintAbove ? scaleTail.dy - labelHeight : scaleTail.dy;
      textPainter.paint(
        canvas,
        Offset(dx, dy),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _HeroStatsGraphScalePainter) {
      return oldDelegate.style != style;
    }
    return true;
  }
}

class _HeroStatsGraphPainter extends CustomPainter {
  final Animation<HeroStats> stats;
  final Color color;
  final TextStyle style;

  late final statsPaint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  late final textPainter = TextPainter(
    text: TextSpan(text: '', style: style),
    textDirection: TextDirection.ltr,
  );

  _HeroStatsGraphPainter({
    required this.stats,
    required this.color,
    required this.style,
  }) : super(repaint: stats);

  @override
  void paint(Canvas canvas, Size size) {
    textPainter.layout();
    final labelHeight = textPainter.height;

    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - labelHeight;
    final scales = stats.value.scales;

    final path = Path();
    var isFirst = true;
    for (final scale in scales) {
      final value = scale.value / 100;
      final point = Offset(
        center.dx - radius * sin(scale.angle) * value,
        center.dy - radius * cos(scale.angle) * value,
      );
      if (isFirst) {
        isFirst = false;
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, statsPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is _HeroStatsGraphPainter) {
      return oldDelegate.style != style;
    }
    return true;
  }
}
