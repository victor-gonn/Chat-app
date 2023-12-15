import 'package:flutter/material.dart';

class ChatMessenger extends StatelessWidget {
  const ChatMessenger(this.data, this.mine, {super.key});

  

  final Map<Object?, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10, horizontal: 10
      ),
      child: Row(
        children: [
          !mine ?
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                data['senderPhotoUrl'] ?? 'got null'
              ),
            ),
          ) : Container(),
          Expanded(child: 
          Column(
            crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            
            children: [
              data['imgUrl'] != null ?
              Image.network(data['imgUrl'], width: 250,)
              : Text(data['text'],
              textAlign: mine ? TextAlign.end : TextAlign.start,
              style: TextStyle(
                fontSize: 16
              ),
              ),
              Text(data['senderName'] ?? 'got null sender name',
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500
              ),)
            ],
          )
          ), 
          mine ?
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                data['senderPhotoUrl'] ?? 'got null'
              ),
            ),
          ) : Container()
        ],
      ),

    );
  }
}