import 'dart:async';
import 'dart:io';

import 'package:flutter_tg_helper/app_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdlib/td_client.dart';
import 'package:tdlib/td_api.dart' as td;
import 'package:device_info_plus/device_info_plus.dart';

class Utils {
  static String getPlatform() {
    return 'Android';
  }

  static String getApiHash() {
    return TgApi.apiHash;
  }

  static int getApiId() {
    return TgApi.apiId;
  }

  static Client? client;
  static StreamSubscription<td.TdObject>? _clientStreamSubscription;

  static td.TdObject? authorizationState;
  static td.TdObject? lastEvent;
  static td.TdObject? connectionState;

  static late Directory appDocDir;

  static String systemLanguageCode() {
    return Platform.localeName;
  }

  static Future<void> _onAuthorizationUpdate() async {
    if (authorizationState is td.AuthorizationStateWaitTdlibParameters) {
      late final String deviceModel;
      late final String deviceSystemVersion;
      if (Platform.isAndroid) {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        deviceModel = deviceInfo.model;
        deviceSystemVersion = deviceInfo.version.release;
      } else {
        deviceModel = 'Unknown';
        deviceSystemVersion = 'Unknown';
      }
      client!.send(
        td.SetTdlibParameters(
          apiId: getApiId(),
          apiHash: getApiHash(),
          systemLanguageCode: systemLanguageCode(),
          deviceModel: deviceModel,
          systemVersion: deviceSystemVersion,
          applicationVersion: '0.1',
          useMessageDatabase: true,
          useSecretChats: false,
          useFileDatabase: false,
          useChatInfoDatabase: true,
          useTestDc: true,
          databaseDirectory: appDocDir.path,
          filesDirectory: appDocDir.path,
          databaseEncryptionKey: '',
        ),
      );
    }
  }

  static void sendNumber(String phoneNumber) {
    client!.send(td.SetAuthenticationPhoneNumber(phoneNumber: phoneNumber));
  }

  static Future<bool> initialize() async {
    if (client != null) {
      false;
    }

    appDocDir = await getApplicationDocumentsDirectory();

    client = Client.create();
    _clientStreamSubscription?.cancel();
    _clientStreamSubscription =
        client!.updates.asBroadcastStream().listen((event) {
      lastEvent = event;
      if (event is td.UpdateAuthorizationState) {
        authorizationState = event.authorizationState;
        _onAuthorizationUpdate();
      } else if (event is td.UpdateConnectionState) {
        connectionState = event.state;
      }
    });
    await client!.initialize();

    return true;
  }
}
