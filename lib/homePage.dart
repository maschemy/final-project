import 'package:flutter/material.dart';
import 'newsPage.dart';
import 'statPage.dart';
import 'settingPage.dart';  // SettingPage 추가
import 'loginPage.dart';    // LoginPage 추가

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;  // 현재 선택된 인덱스를 추적
  final List<Widget> _screens = [
    const RoutinePage(),  // 하루별 루틴 화면
    const NewsPage(),
    const StatsPage(),
    const SettingPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;  // 탭이 변경되면 선택된 인덱스를 갱신
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Routine"),
        backgroundColor: Colors.green,
        actions: [
          // 로그아웃 버튼 추가
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 로그아웃 처리 후 로그인 화면으로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],  // 현재 선택된 화면을 표시
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,  // 탭 클릭 시 화면 전환
        backgroundColor: Colors.black, // 네비게이션 바 배경을 검정색으로 설정
        selectedItemColor: Colors.green, // 선택된 아이템 색상
        unselectedItemColor: Colors.black, // 선택되지 않은 아이템 색상
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '루틴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: '뉴스',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  String _selectedDay = "월";  // 기본 선택된 요일은 '월요일'

  final Map<String, Widget> _dayContent = {
    "월": const Center(child: Text('월요일 루틴')),
    "화": const Center(child: Text('화요일 루틴')),
    "수": const Center(child: Text('수요일 루틴')),
    "목": const Center(child: Text('목요일 루틴')),
    "금": const Center(child: Text('금요일 루틴')),
    "토": const Center(child: Text('토요일 루틴')),
    "일": const Center(child: Text('일요일 루틴')),
  };

  void _selectDay(String day) {
    setState(() {
      _selectedDay = day;  // 선택된 요일을 갱신
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDateButton("월"),
                _buildDateButton("화"),
                _buildDateButton("수"),
                _buildDateButton("목"),
                _buildDateButton("금"),
                _buildDateButton("토"),
                _buildDateButton("일"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _dayContent[_selectedDay] ?? const Center(child: Text('루틴 없음')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},  // 버튼 클릭 시 동작 정의
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildDateButton(String day) {
    bool isSelected = _selectedDay == day;  // 선택된 요일 여부
    return InkWell(
      onTap: () => _selectDay(day),  // 탭 클릭 시 해당 요일로 변경
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                day,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.arrow_drop_up, color: Colors.red, size: 16),
        ],
      ),
    );
  }
}


