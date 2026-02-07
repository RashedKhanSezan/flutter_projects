import 'package:chatting_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (context, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No masseges found'),
          );
        }
        if (chatSnapshot.hasError) {
          return Center(
            child: Text('Something went wrong...'),
          );
        }

        final loadedMessages = chatSnapshot.data!.docs;

        return ListView.builder(
          padding: EdgeInsets.only(left: 13, right: 13, bottom: 28),
          itemCount: loadedMessages.length,
          reverse: true,
          itemBuilder: (context, index) {
            final chatMessages = loadedMessages[index].data();
            // return Text(chatMessages['userMessage']);
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currentMessageUserId = chatMessages['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;

            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                  message: chatMessages['userMessage'],
                  isMe: authenticatedUser.uid == currentMessageUserId);
            } else {
              return MessageBubble.first(
                  userImage: chatMessages['userImage'],
                  username: chatMessages['userName'],
                  message: chatMessages['userMessage'],
                  isMe: authenticatedUser.uid == currentMessageUserId);
            }
          },
        );
      },
    );
  }
}
