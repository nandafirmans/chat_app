import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userName;
  final String userImageUrl;

  const MessageBubble({
    Key key,
    @required this.message,
    @required this.isMe,
    @required this.userName,
    @required this.userImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageColor = isMe
        ? Theme.of(context).textTheme.bodyText1.color
        : Theme.of(context).accentTextTheme.bodyText1.color;
    final messageBubbleWidth = 150.0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: !isMe ? Radius.circular(2) : Radius.circular(14),
                  bottomRight: isMe ? Radius.circular(2) : Radius.circular(14),
                ),
              ),
              width: messageBubbleWidth,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 4),
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: messageColor,
                        ),
                      )),
                  Text(
                    message,
                    style: TextStyle(
                      color: messageColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : (messageBubbleWidth - 20),
          right: isMe ? (messageBubbleWidth - 20) : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImageUrl),
          ),
        )
      ],
    );
  }
}
