import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, snapshotUser) {
        if (snapshotUser.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshotChat) {
            if (snapshotChat.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = snapshotChat.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) => MessageBubble(
                key: ValueKey(chatDocs[index].documentID),
                message: chatDocs[index]['text'],
                isMe: chatDocs[index]['userId'] == snapshotUser.data.uid,
                userName: chatDocs[index]['username'],
                userImageUrl: chatDocs[index]['image_url'],
              ),
            );
          },
        );
      },
    );
  }
}
