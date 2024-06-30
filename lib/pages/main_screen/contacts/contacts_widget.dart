import 'dart:developer';
import 'dart:io';
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
              log('error while creating group ${_.message}');
            }
          });
        },
        child: Text(Provider.of<Chats>(context).chats.totalCount.toString()));
  }

  Widget chatList(BuildContext context) {
    td.Chats chats = Provider.of<Chats>(context).chats;
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
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
                  return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('home/chat', arguments: chatId);
                      },
                      child: chatTile(chatResponse));
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

  Widget chatTile(td.Chat chat) {
    late String? subtitle;
    if (chat.lastMessage?.content is td.MessageText) {
      subtitle = (chat.lastMessage!.content as td.MessageText).text.text;
    } else {
      subtitle = chat.lastMessage?.content.runtimeType.toString();
    }
    late final Future<td.TdObject> downloadFile;
    if (chat.photo != null) {
      downloadFile = Utils.client!.send(td.DownloadFile(
        fileId: chat.photo!.small.id,
        priority: 32,
        limit: 0,
        offset: 0,
        synchronous: true,
      ));
    } else {
      downloadFile = Future.error(Exception('no photo'));
    }
    return FutureBuilder<td.TdObject>(
        future: downloadFile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return ListTile(
              leading: CircularProgressIndicator(),
              title: Text(chat.title),
              subtitle: Text(
                subtitle ?? 'no messages',
                maxLines: 3,
              ),
            );
          } else if ((snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasError) ||
              snapshot.data is td.TdError ||
              !snapshot.hasData) {
            if (snapshot.data is td.TdError)
              log((snapshot.data as td.TdError).message);
            return ListTile(
              leading: null,
              title: Text(chat.title),
              subtitle: Text(
                subtitle ?? 'no messages',
                maxLines: 3,
              ),
            );
          } else {
            log(snapshot.data.runtimeType.toString());
            return ListTile(
              leading: Image.file(File(chat.photo!.small.local.path)),
              title: Text(chat.title),
              subtitle: Text(
                subtitle ?? 'no messages',
                maxLines: 3,
              ),
            );
          }
        });
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    chatAdd(context),
                    chatList(context),
                  ],
                ),
              );
            }),
          );
        } else {
          return Text(snapshot.connectionState.toString());
        }
      },
    );
  }
}
