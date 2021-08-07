import 'package:flutter/widgets.dart';

/// Creates [ShowcaseConfigData] and provides it through [ShowcaseConfig]
class ShowcaseScope extends StatefulWidget {
  final Widget child;

  const ShowcaseScope({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _ShowcaseScopeState createState() => _ShowcaseScopeState();
}

class _ShowcaseScopeState extends State<ShowcaseScope> {
  late ShowcaseConfigData data;

  @override
  void initState() {
    super.initState();
    data = ShowcaseConfigData._();
  }

  @override
  void dispose() {
    data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowcaseConfig._(
      data: data,
      child: widget.child,
    );
  }
}

/// Provides [ShowcaseConfigData] with [InheritedNotifier]
class ShowcaseConfig extends InheritedNotifier {
  final Widget child;
  final ShowcaseConfigData data;

  ShowcaseConfig._({
    required this.child,
    required this.data,
  }) : super(child: child, notifier: data);

  static ShowcaseConfigData? of(BuildContext context, {bool listen = true}) {
    ShowcaseConfigData? notifier;
    if (listen) {
      notifier =
          context.dependOnInheritedWidgetOfExactType<ShowcaseConfig>()?.data;
    } else {
      final element =
          context.getElementForInheritedWidgetOfExactType<ShowcaseConfig>();
      final widget = element?.widget as ShowcaseConfig?;
      notifier = widget?.data;
    }
    return notifier;
  }
}

/// Config for animations
class ShowcaseConfigData extends ChangeNotifier {
  static const defaultDuration = Duration(milliseconds: 400);
  static const maxMillis = 4000;
  static const minMillis = 0;

  ShowcaseConfigData._();

  Duration _duration = defaultDuration;

  Duration get duration => _duration;

  set duration(Duration value) {
    final millis = value.inMilliseconds.clamp(minMillis, maxMillis);
    if (duration.inMilliseconds != millis) {
      _duration = Duration(milliseconds: millis);
      notifyListeners();
    }
  }
}
