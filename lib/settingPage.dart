import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {  // 클래스 이름을 'SettingPage'로 변경
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('탄소중립포인트 녹색생활실천: https://www.cpoint.or.kr/netzero/index.do'),
            SizedBox(height: 8),
            Text('탄소중립 실천포털: https://www.gihoo.or.kr/main'),
          ],
        ),
      ),
    );
  }
}

