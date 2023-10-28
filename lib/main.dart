import 'package:chat_online/Screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
WidgetsFlutterBinding.ensureInitialized();


await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp( MyApp());
  FirebaseFirestore.instance.collection('contatos').snapshots().listen((dado) { 
    dado.docs.forEach((d) { 
      print(d.data());
    });
  });

  
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.amber,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
      ),
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

