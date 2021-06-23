import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:user/user.dart';
import 'package:sharezone/util/api/user_api.dart';

class NotificationTokenAdder {
  final NotificationTokenAdderApi _api;

  NotificationTokenAdder(this._api);

  Future<void> addTokenToUserIfNotExisting() async {
    List<String> existingTokens;
    final token = await _api.getFCMToken();
    if (token != null && token.isNotEmpty) {
      try {
        existingTokens = await _api.getUserTokensFromDatabase() ?? [];
      } on Exception {
        existingTokens = [];
      }
      if (!existingTokens.contains(token)) {
        await _api.tryAddTokenToDatabase(token);
        return;
      }
    }
    return;
  }
}

class NotificationTokenAdderApi {
  final UserGateway _userApi;
  final FirebaseMessaging _firebaseMessaging;

  NotificationTokenAdderApi(this._userApi, this._firebaseMessaging);

  Future<String> getFCMToken() {
    return _firebaseMessaging.getToken();
  }

  Future<void> tryAddTokenToDatabase(String token) async {
    try {
      await _userApi.addNotificationToken(token);
    } on Exception catch (e) {
      print("Could not add NotificationToken to User. Error: $e");
    }
    return;
  }

  Future<List<String>> getUserTokensFromDatabase() async {
    AppUser user = await _userApi.userStream.first;
    return user?.notificationTokens?.toList() ?? [];
  }
}
