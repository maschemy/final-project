import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';  // 로그인 페이지로 이동

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Firebase 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Routine',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),  // 앱 실행 시 로그인 페이지로 이동
    );
  }
}