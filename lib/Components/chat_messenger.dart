import 'package:flutter/material.dart';

class ChatMessenger extends StatelessWidget {
  const ChatMessenger(this.data, {super.key});

  

  final Map<Object?, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10, horizontal: 10
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              data['senderPhotoUrl'] ?? 'got null'
            ),
          ),
          Expanded(child: 
          Column(
            children: [
              data['imgUrl'] != null ?
              Image.network(data['imgUrl'])
              : Text(data['text'],
              style: TextStyle(
                fontSize: 16
              ),
              ),
              Text(data['senderName'] ?? 'got null sender name',
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500
              ),)
            ],
          ))
        ],
      ),

    );
  }
}