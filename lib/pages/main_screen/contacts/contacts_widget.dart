import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/res/utils.dart';
import 'package:tdlib/td_api.dart' as td;

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  Widget chatListButton() {
    return TextButton(
      onPressed: () => Utils.client!.send(td.LoadChats(limit: 20)),
      child: Text('foo'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return chatListButton();
  }
}
