import 'package:flutter/material.dart';

/// Overrides the [GlowingOverscrollIndicator] color used by descendant widgets.
///
/// For example it is used in the HomeworkPage, where it overrides the overscroll
/// color of the ListViews holding the homeworks.
class GlowingOverscrollColorChanger extends StatelessWidget {
  final Widget child;
  final Color color;

  const GlowingOverscrollColorChanger({Key key, this.child, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: SpecifiableOverscrollColorScrollBehavior(color),
      child: child,
    );
  }
}

class SpecifiableOverscrollColorScrollBehavior extends ScrollBehavior {
  final Color _overscrollColor;

  const SpecifiableOverscrollColorScrollBehavior(this._overscrollColor);

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return child;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      default:
        return GlowingOverscrollIndicator(
          child: child,
          axisDirection: axisDirection,
          color: _overscrollColor,
        );
    }
  }
}
