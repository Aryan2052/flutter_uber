import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    await FirebaseFirestore.instance.collection('test').doc('test').get();
    print('Firebase connection successful');
  } catch (e) {
    print('Firebase connection failed: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home', // HomePage is now the initial screen
      routes: {
        '/home': (context) => IntroPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
