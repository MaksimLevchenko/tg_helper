import 'package:flutter/material.dart';
import 'package:tdlib/td_api.dart' hide Text;

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final chatsCache = <Chat>[];

  Stream<Chat> fetchChatsList() {
    throw UnimplementedError();
  }

  Widget chatListWidget() {
    return StreamBuilder<Chat>(
      stream: fetchChatsList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          chatsCache.add(snapshot.data!);
          return ListView.builder(
            itemCount: chatsCache.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(chatsCache[index].title),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching chats'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return chatListWidget();
  }
}
