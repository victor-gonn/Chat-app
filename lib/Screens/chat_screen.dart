
import 'dart:io';

import 'package:chat_online/Components/chat_messenger.dart';
import 'package:chat_online/Components/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final GoogleSignIn googleSingIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late User? _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
    });
  }

  Future _getUser() async {
    if(_currentUser != null) return _currentUser;
    try {
      final GoogleSignInAccount? googleSignInAccount = 
      await googleSingIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication = 
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

        final UserCredential userCredential = 
        await FirebaseAuth.instance.signInWithCredential(credential);

        final User? user = userCredential.user;

        return user;



    } catch(error){
      return error;

    }
  }

  void _sendMessage ({String? text, File? imgFile}) async { 
    final User? user = await _getUser();

    if(user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possivel fazer o login'),
        backgroundColor: Colors.red,));
    }

    Map<String, dynamic> data = {
      "uid": user!.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
    };

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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Olá'),
        elevation: 0,
        
      ),
      body: Column(
        children: [
          Expanded(child: 
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>> (
            stream: FirebaseFirestore.instance.collection('messages').snapshots(), 
          builder: (context, snapshot)
          {
            switch(snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator()
              );
              default:
              if(snapshot.data == null) {
                debugPrint('snapshot error ${snapshot.error}');
                return Text('snapShot erro');
                

              }
              List<DocumentSnapshot> documents = snapshot.requireData.docs.reversed.toList();
              return ListView.builder(
              itemCount: documents.length,
              reverse: true,
              itemBuilder: (context, index){
                return ChatMessenger(documents[index].data() as Map<Object?, dynamic>)

                ;
              },);
            }
          })),
          TextComposer(sendMessage: _sendMessage),
        ],
      ),
    );
  }
}