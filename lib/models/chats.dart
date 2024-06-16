import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/res/utils.dart';
import 'package:tdlib/td_api.dart' as td;

class Chats extends ChangeNotifier {
  Chats._create(td.Chats chats) {
    Utils.client!.updates.listen(_onUpdate);
    _chats = chats;
    notifyListeners();
  }

  static Future<Chats> create() async {
    final chatsFuture = Utils.client!.send(const td.GetChats(limit: 100));
    td.TdObject? result = await chatsFuture;
    switch (result.runtimeType) {
      case const (td.TdError):
        log((result as td.TdError).message);
        const chats = td.Chats(
          chatIds: [],
          totalCount: 0,
        );
        return Chats._create(chats);
      case const (td.Chats):
        log((result as td.Chats).totalCount.toString());
        final chats = result as td.Chats;
        return Chats._create(chats);
      default:
        log(result.runtimeType.toString());
        const chats = td.Chats(
          chatIds: [],
          totalCount: 0,
        );
        return Chats._create(chats);
    }
  }

  void _onUpdate(td.TdObject update) {
    if (update is td.TdError) {
      log('Chat error ${update.message}');
      return;
    } else if (update is td.UpdateNewChat) {
      Utils.client!.send(const td.GetChats(limit: 100)).then((value) {
        chats = value as td.Chats;
      });
    }
  }

  late td.Chats _chats;

  td.Chats get chats => _chats;
  set chats(td.Chats value) {
    _chats = value;
    notifyListeners();
  }
}
