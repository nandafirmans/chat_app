import 'package:chat_app/utilities/fcm_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _messageTextController = TextEditingController();
  var _messages = '';

  Future<void> _sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userData = await Firestore.instance.collection('users').document(user.uid).get();
    await Firestore.instance.collection('chat').add({
      'text': _messages,
      'timestamp': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'image_url': userData['image_url'],
    });
    await FcmHelper.sendNotification(
      title: userData['username'],
      body: _messages,
      to: '/topics/chat',
    );
    _messageTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _messageTextController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: 'Send a message...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _messages = value),
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _messages.isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
