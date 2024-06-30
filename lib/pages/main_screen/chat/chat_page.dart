import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/res/utils.dart';
import 'package:tdlib/td_api.dart' as td;

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.chatId});
  final int chatId;

  @override
  Widget build(BuildContext context) {
    final chatFuture = Utils.client!.send(td.GetChat(chatId: chatId));
    return FutureBuilder<td.TdObject>(
        future: chatFuture,
        builder: (context, snapshot) {
          if (snapshot.data is td.Chat) {
            final td.Chat chat = snapshot.data as td.Chat;
            String? photoPath;
            Future<bool>? isDownloaded;
            if (chat.photo != null) {
              photoPath = chat.photo!.small.local.path;
              final photoId = chat.photo!.small.id;
              isDownloaded = Utils.client!.send(td.DownloadFile(
                fileId: photoId,
                synchronous: true,
                limit: 0,
                offset: 0,
                priority: 32,
              ));
            }
            return Scaffold(
              appBar: AppBar(
                title: Text('Chat ${chat.title} Page'),
                actions: [
                  FutureBuilder<bool?>(
                      future: isDownloaded,
                      builder: (context, snapshot) {
                        return (snapshot.data == true ||
                                (chat.photo?.small.local
                                        .isDownloadingCompleted ??
                                    false))
                            ? Image.file(File(photoPath!))
                            : Container(color: Colors.amber);
                      }),
                ],
              ),
              body: Column(
                children: [
                  Text('no data'),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
