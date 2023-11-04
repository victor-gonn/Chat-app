

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  const TextComposer( {super.key, this.sendMessage,  });

    

   final Function({String text, File imgFile})? sendMessage;


  @override
  State<TextComposer> createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final GoogleSignIn googleSingIn = GoogleSignIn();

  void _GetUser() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = 
      await googleSingIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication = 
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);



    } catch(error){

    }
  }
  

final TextEditingController _controller = TextEditingController();  

bool _isComposing = false;



void _reset() {
  _controller.clear();
                setState(() {
                  _isComposing = false;
                });
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(children: [
        IconButton(onPressed: () async {
           final XFile? imgXFile =await ImagePicker().pickImage(source: ImageSource.camera);
           if (imgXFile == null) return;
            final imgFile = File(imgXFile.path);
           widget.sendMessage!(imgFile: imgFile);

        }, 
        icon: Icon(Icons.photo_camera)),
        Expanded(
          child: TextField(
            controller: _controller,
              decoration: InputDecoration.collapsed(hintText: 'Enviar mensagem'),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMessage!(text: text, );
                _reset();
                
              } ,
              ),
        ),
        IconButton(onPressed: _isComposing ? () {
    widget.sendMessage!(text: _controller.text);
    _reset();
        } : null,
         icon: Icon(Icons.send))
      ]),
    );
  }
}
