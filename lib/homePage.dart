import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showAdditionalButtons = false; // 추가 버튼 표시 여부

  void _toggleAdditionalButtons() {
    setState(() {
      _showAdditionalButtons = !_showAdditionalButtons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Stack을 전체 화면으로 확장
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Center(
            child: const Text(
              'Home Page Content',
              style: TextStyle(fontSize: 24),
            ),
          ),
          // 첫 번째 추가 버튼 (AI를 활용한 항목 추가하기)
          if (_showAdditionalButtons)
            Positioned(
              bottom: 80,
              right: 16, // 기본 패딩을 고려하여 16으로 설정
              child: _buildCustomButton(
                icon: const Text(
                  'AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                label: 'AI를 활용한 항목 추가하기',
                color: Colors.lightGreen,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('AI 항목 추가하기 버튼 눌림')),
                  );
                },
              ),
            ),
          // 두 번째 추가 버튼 (직접 항목 추가하기)
          if (_showAdditionalButtons)
            Positioned(
              bottom: 140,
              right: 16,
              child: _buildCustomButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                label: '직접 항목 추가하기',
                color: Colors.lightGreen,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('직접 항목 추가하기 버튼 눌림')),
                  );
                },
              ),
            ),
          // 메인 플로팅 버튼 (+ 버튼)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _toggleAdditionalButtons,
              child: Icon(_showAdditionalButtons ? Icons.close : Icons.add),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  // 커스텀 버튼 위젯 생성
  Widget _buildCustomButton({
    required Widget icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
