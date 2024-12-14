import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도움말 및 지원',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '도움말 및 지원',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '문제가 있으신가요? 아래 연락처로 문의하세요:\n'
                  '이메일: E1I3@gmail.com\n'
                  '전화번호: 02-234-6789',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
