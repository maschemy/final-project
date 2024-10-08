import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Routine',
      theme: ThemeData(
        primarySwatch: Colors.green, // 상단 앱바 색상 설정
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 네비게이션 바에서 선택한 인덱스에 따라 보여줄 화면 정의
  final List<Widget> _screens = [
    const HomePage(),
    const NewsPage(),
    const StatsPage(),
    const InfoPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Routine App'),
        backgroundColor: Colors.green, // 상단 앱바 색상
      ),
      body: IndexedStack(
        index: _currentIndex, // 선택된 탭에 해당하는 화면을 보여줌
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 네 개의 탭을 모두 고정하여 표시
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}

// 각 페이지별 화면 (예시로 간단하게 텍스트만 표시)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedDay = "월"; // 기본적으로 월요일이 선택됨

  // 요일에 따른 화면 데이터 설정
  final Map<String, Widget> _dayContent = {
    "월": const Center(child: Text('월요일 루틴')),
    "화": const Center(child: Text('화요일 루틴')),
    "수": const Center(child: Text('수요일 루틴')),
    "목": const Center(child: Text('목요일 루틴')),
    "금": const Center(child: Text('금요일 루틴')),
    "토": const Center(child: Text('토요일 루틴')),
    "일": const Center(child: Text('일요일 루틴')),
  };

  // 요일 선택 시 호출되는 함수
  void _selectDay(String day) {
    setState(() {
      _selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 상단 요일 선택 버튼
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
          // 선택된 요일에 맞는 컨텐츠를 표시
          Expanded(
            child: _dayContent[_selectedDay] ?? const Center(child: Text('루틴 없음')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 루틴 추가 기능
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 날짜 버튼 위젯
  Widget _buildDateButton(String day) {
    bool isSelected = _selectedDay == day; // 선택된 요일인지 확인

    return InkWell(
      onTap: () => _selectDay(day), // 버튼 클릭 시 요일 변경
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.grey, // 선택되면 빨간색, 아니면 회색
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
            const Icon(Icons.arrow_drop_up, color: Colors.red, size: 16), // 선택된 요일 밑에 화살표 표시
        ],
      ),
    );
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('News Page'),
    );
  }
}

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Stats Page'),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

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
            SizedBox(height: 8), // 링크 사이 간격 추가
            Text('탄소중립 실천포털: https://www.gihoo.or.kr/main'),
          ],
        ),
      ),
    );
  }
}

