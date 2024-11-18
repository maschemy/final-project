import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isDarkMode = false;  // 다크 모드 상태
  bool _isNotificationsEnabled = true;  // 알림 설정 상태

  // 다크 모드 토글
  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  // 알림 설정 토글
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 다크 모드 스위치
            SwitchListTile(
              title: const Text('다크 모드'),
              subtitle: const Text('앱의 테마를 다크 모드로 변경'),
              value: _isDarkMode,
              onChanged: _toggleTheme,
              activeColor: Colors.green,
            ),
            const Divider(),

            // 알림 설정 스위치
            SwitchListTile(
              title: const Text('알림 설정'),
              subtitle: const Text('업데이트 및 알림을 받습니다'),
              value: _isNotificationsEnabled,
              onChanged: _toggleNotifications,
              activeColor: Colors.green,
            ),
            const Divider(),

            // 계정 관리
            ListTile(
              title: const Text('계정'),
              subtitle: const Text('계정 정보 관리'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                // 계정 관리 화면으로 이동할 수 있습니다.
              },
            ),
            const Divider(),

            // 개인정보 처리방침
            ListTile(
              title: const Text('개인정보 처리방침'),
              leading: const Icon(Icons.lock),
              onTap: () {
                // 개인정보 처리방침 페이지로 이동할 수 있습니다.
              },
            ),
            const Divider(),

            // 도움말 & 지원
            ListTile(
              title: const Text('도움말 및 지원'),
              leading: const Icon(Icons.help),
              onTap: () {
                // 도움말 페이지로 이동할 수 있습니다.
              },
            ),
          ],
        ),
      ),
    );
  }
}

