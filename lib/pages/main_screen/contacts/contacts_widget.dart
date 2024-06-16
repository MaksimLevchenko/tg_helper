import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/models/chats.dart';
import 'package:flutter_tg_helper/res/utils.dart';
import 'package:provider/provider.dart';
import 'package:tdlib/td_api.dart' as td;

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  Widget chatAdd(BuildContext context) {
    return TextButton(
        onPressed: () {
          Utils.client!
              .send(td.CreateNewBasicGroupChat(
                  title: 'lol ${Random().nextInt(100)} chat',
                  messageAutoDeleteTime: 0,
                  userIds: const []))
              .then((_) {
            if (_ is td.TdError) {
              log(_.message);
            }
          });
        },
        child: Text(Provider.of<Chats>(context).chats.totalCount.toString()));
  }

  Widget chatList(BuildContext context) {
    td.Chats chats = Provider.of<Chats>(context).chats;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chats.chatIds.length,
      itemBuilder: (context, index) {
        final chatId = chats.chatIds[index];
        Future<td.TdObject> chatInfoResponse =
            Utils.client!.send(td.GetChat(chatId: chatId));
        return FutureBuilder<td.TdObject>(
            future: chatInfoResponse,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              } else {
                late final td.TdObject chatResponse;
                chatResponse = snapshot.data!;
                if (chatResponse is td.Chat) {
                  return ListTile(
                    title: Text('Chat ${chatResponse.title}'),
                  );
                } else if (chatResponse is td.TdError) {
                  return ListTile(
                    title: Text('Error: ${chatResponse.message}'),
                  );
                } else {
                  return ListTile(
                    title: Text('Error: ${snapshot.data.runtimeType}'),
                  );
                }
              }
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chats = Chats.create();
    return FutureBuilder<Chats>(
      future: chats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListenableProvider(
            create: (context) => snapshot.data!,
            child: Builder(builder: (context) {
              return chatList(context);
            }),
          );
        } else {
          return Text(snapshot.connectionState.toString());
        }
      },
    );
  }
}
