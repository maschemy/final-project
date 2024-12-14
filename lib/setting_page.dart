
import 'package:flutter/material.dart';
import 'setting_file/privacy_policy_page.dart'; // 개인정보 처리방침 페이지
import 'setting_file/help_support_page.dart'; // 도움말 및 지원 페이지

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 언어 설정
            ListTile(
              title: const Text('언어 설정'),
              subtitle: const Text('앱의 기본 언어를 선택하세요'),
              leading: const Icon(Icons.language),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
            const Divider(),

            // 테마 선택
            ListTile(
              title: const Text('테마 설정'),
              subtitle: const Text('앱의 테마를 변경합니다'),
              leading: const Icon(Icons.color_lens),
              onTap: () {
                _showThemeDialog(context);
              },
            ),
            const Divider(),

            // 개인정보 처리방침
            ListTile(
              title: const Text('개인정보 처리방침'),
              leading: const Icon(Icons.lock),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage(),
                  ),
                );
              },
            ),
            const Divider(),

            // 도움말 및 지원
            ListTile(
              title: const Text('도움말 및 지원'),
              leading: const Icon(Icons.help),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 언어 선택 다이얼로그
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('언어 설정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('한국어'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, '한국어로 설정되었습니다.');
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Language set to English.');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 테마 선택 다이얼로그
  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('테마 설정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light Mode'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, '라이트 모드로 설정되었습니다.');
                },
              ),
              ListTile(
                title: const Text('Dark Mode'),
                onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, '다크 모드로 설정되었습니다.');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 스낵바 표시
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}