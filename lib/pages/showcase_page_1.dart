import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animations_showcase/pages/common/showcase_config.dart';

import '../strings.dart';
import 'common/showcase_scaffold.dart';

/// Showcase of [AnimatedContainer] usage
class ShowcaseAnimatedContainer extends StatefulWidget {
  const ShowcaseAnimatedContainer({
    Key? key,
  }) : super(key: key);

  @override
  _ShowcaseAnimatedContainerState createState() =>
      _ShowcaseAnimatedContainerState();
}

class _ShowcaseAnimatedContainerState extends State<ShowcaseAnimatedContainer> {
  bool value = true;

  void toggle() {
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
      onRun: toggle,
      child: Center(
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeIn,
          width: value ? 100 : 90,
          height: value ? 100 : 90,
          decoration: BoxDecoration(
            color: value ? Colors.greenAccent : Colors.grey.shade300,
            boxShadow: value
                ? [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: Offset(3.0, 3.0),
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                    ),
                  ]
                : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value ? Strings.on : Strings.off,
              style: Theme.of(context).accentTextTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }
}
