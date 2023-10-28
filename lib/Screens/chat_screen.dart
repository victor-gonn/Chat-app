
import 'dart:io';

import 'package:chat_online/Components/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void _sendMessage ({String? text, File? imgFile}) async { 

    Map<String, dynamic> data = {};

    if (imgFile !=null) {
      UploadTask uploadTask = FirebaseStorage.instance.ref().child(
        DateTime.now().millisecondsSinceEpoch.toString()
      ).putFile(imgFile);

       TaskSnapshot taskSnapshot = await uploadTask;
       String url = await taskSnapshot.ref.getDownloadURL();
       data['imgurl'] = url;
      
    }

       if(text != null) data['text'] = text;

        FirebaseFirestore.instance.collection('messages').add(data);
      }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá'),
        elevation: 0,
        
      ),
      body: Column(
        children: [
          Expanded(child: 
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>> (stream: FirebaseFirestore.instance.collection('messages').snapshots(), 
          builder: (context, snapshot)
          {
            switch(snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator()
              );
              default:
              List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView.builder(
              itemCount: documents.length,
              reverse: true,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(documents[index]['text']),

                );
              },);
            }
          })),
          TextComposer(sendMessage: _sendMessage),
        ],
      ),
    );
  }
}