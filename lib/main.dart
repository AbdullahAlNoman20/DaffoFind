import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_one/pages/Home.dart';
import 'package:flutter_app_one/pages/Register.dart';
import 'package:flutter_app_one/pages/login.dart';
import 'package:flutter_app_one/pages/LostPage.dart';
import 'package:flutter_app_one/pages/FindPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAiWPhEE7fzkQ4VcjHRby2fG-Z6wvuY82o",
            authDomain: "daffofind.firebaseapp.com",
            projectId: "daffofind",
            storageBucket: "daffofind.firebasestorage.app",
            messagingSenderId: "386169160609",
            appId: "1:386169160609:web:124b9861cf0841aff501e0"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/register': (context) => Register(),
        '/home': (context) => Home(),
        '/lost': (context) => LostPage(),
        '/found': (context) => FindPage(),
      },
    );
  }
}
