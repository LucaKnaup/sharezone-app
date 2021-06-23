import 'package:analytics/analytics.dart';
import 'package:sharezone_common/helper_functions.dart';

class GroupOnboardingAnalytics {
  final Analytics _analytics;

  GroupOnboardingAnalytics(this._analytics);

  void logSkippedGroupOnboarding() {
    _analytics.log(GroupOnboardingEvent("skipped"));
  }

  void logFinishedGroupOnboarding() {
    _analytics.log(GroupOnboardingEvent("finished"));
  }

  void logTurnOffNotifications() {
    _analytics.log(GroupOnboardingEvent("turn_off_notifications"));
  }

  void logShareSharecode() {
    _analytics.log(GroupOnboardingShareEvent("sharecode"));
  }

  void logShareQrCode() {
    _analytics.log(GroupOnboardingShareEvent("qr_code"));
  }

  void logShareLink() {
    _analytics.log(GroupOnboardingShareEvent("link"));
  }
}

class GroupOnboardingEvent extends AnalyticsEvent {
  GroupOnboardingEvent(String name)
      : assert(isNotEmptyOrNull(name)),
        super("group_onboarding$name");
}

class GroupOnboardingShareEvent extends AnalyticsEvent {
  GroupOnboardingShareEvent(String name)
      : assert(isNotEmptyOrNull(name)),
        super("group_onboarding_share_$name");
}
