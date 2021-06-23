import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/groups/analytics/group_analytics.dart';

class IsGroupMeetingEnbaldedSwitch extends StatelessWidget {
  const IsGroupMeetingEnbaldedSwitch({
    Key key,
    @required this.isMeetingEnabled,
    @required this.onChanged,
  }) : super(key: key);

  final bool isMeetingEnabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      secondary: Icon(Icons.video_call),
      onChanged: (isMeetingEnabledNewValue) {
        _logAnalytics(context, isMeetingEnabledNewValue);
        onChanged(isMeetingEnabledNewValue);
      },
      value: isMeetingEnabled,
      title: Text("Videokonferenz-Raum aktivieren"),
    );
  }

  void _logAnalytics(BuildContext context, bool newValue) {
    final analytics = BlocProvider.of<GroupAnalytics>(context);
    if (newValue) {
      analytics.logEnableMeeting();
    } else {
      analytics.logDisbaleMeeting();
    }
  }
}
