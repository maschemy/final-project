import 'package:flutter/material.dart';
import 'newsPage.dart';
import 'statPage.dart';
import 'settingPage.dart'; // SettingPage 추가
import 'loginPage.dart'; // LoginPage 추가
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // 현재 선택된 인덱스를 추적
  bool _showAdditionalButtons = false;
  DateTime _selectedDate = DateTime.now();
  final Map<String, List<Item>> _itemsPerDate = {};
  final List<Map<String, String>> _predefinedItems = [
    {'emoji': '🌳', 'text': '나무 심기'},
    {'emoji': '🚴', 'text': '자전거 타기'},
    {'emoji': '💡', 'text': '전기 절약'},
    {'emoji': '🚿', 'text': '물 절약'},
    {'emoji': '🌞', 'text': '햇빛 사용'},
    {'emoji': '🛍️', 'text': '에코백 사용'},
    {'emoji': '🍃', 'text': '채식 식사'},
  ];

  final List<Widget> _screens = [
    const RoutinePage(),
    const NewsPage(),
    const StatsPage(),
    const SettingPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // 탭이 변경되면 선택된 인덱스를 갱신
    });
  }

  void _toggleAdditionalButtons() {
    setState(() {
      _showAdditionalButtons = !_showAdditionalButtons;
    });
  }

  List<DateTime> _getCurrentWeekDates() {
    DateTime today = _selectedDate;
    int currentWeekday = today.weekday;
    DateTime firstDayOfWeek = today.subtract(Duration(days: currentWeekday - 1));
    return List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  void _addPredefinedItem() async {
    List<Item> itemList = _itemsPerDate[_selectedDate.toString()] ?? [];

    if (itemList.length >= 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('항목은 최대 7개까지 추가할 수 있습니다.')),
      );
      return;
    }

    Map<String, String>? selectedItem = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('항목 선택'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _predefinedItems.length,
              itemBuilder: (context, index) {
                final item = _predefinedItems[index];
                return ListTile(
                  leading: Text(item['emoji']!, style: const TextStyle(fontSize: 24)),
                  title: Text(item['text']!),
                  onTap: () {
                    Navigator.of(context).pop(item);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedItem != null) {
      setState(() {
        final newItem = Item(
          emoji: selectedItem['emoji']!,
          text: selectedItem['text']!,
          checked: false,
        );
        itemList.add(newItem);
        _itemsPerDate[_selectedDate.toString()] = itemList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = _getCurrentWeekDates();
    String currentMonthYear = DateFormat('yyyy년 M월').format(_selectedDate);
    List<Item> currentItems = _itemsPerDate[_selectedDate.toString()] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Routine"),
        backgroundColor: Colors.green,
        actions: [
          // 로그아웃 버튼 추가
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentMonthYear,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity != null) {
                    if (details.primaryVelocity! < 0) {
                      setState(() {
                        _selectedDate = _selectedDate.add(const Duration(days: 7));
                      });
                    } else if (details.primaryVelocity! > 0) {
                      setState(() {
                        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekDates.map((date) {
                      bool isSelected = date.day == _selectedDate.day &&
                          date.month == _selectedDate.month &&
                          date.year == _selectedDate.year;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(
                                ['월', '화', '수', '목', '금', '토', '일'][date.weekday - 1],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildTable(currentItems)),
            ],
          ),
          if (_showAdditionalButtons)
            Positioned(
              bottom: 80,
              right: 16,
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
          if (_showAdditionalButtons)
            Positioned(
              bottom: 140,
              right: 16,
              child: _buildCustomButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                label: '직접 항목 추가하기',
                color: Colors.lightGreen,
                onTap: _addPredefinedItem,
              ),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _toggleAdditionalButtons,
              child: Icon(_showAdditionalButtons ? Icons.close : Icons.add),
              backgroundColor: Colors.green,
            ),
          ),
          _screens[_currentIndex]
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
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

  Widget _buildTable(List<Item> currentItems) {
    List<TableRow> tableRows = [];

    for (int i = 0; i < 7; i++) {
      if (i < currentItems.length) {
        final item = currentItems[i];
        tableRows.add(
          TableRow(
            children: [
              Container(
                height: 60,
                alignment: Alignment.center,
                child: Text(item.emoji, style: const TextStyle(fontSize: 32)),
              ),
              Container(
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  item.text,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Container(
                height: 60,
                alignment: Alignment.center,
                child: Checkbox(
                  value: item.checked,
                  onChanged: (value) {
                    setState(() {
                      item.checked = value ?? false;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        tableRows.add(
          const TableRow(
            children: [
              SizedBox(height: 60),
              SizedBox(height: 60),
              SizedBox(height: 60),
            ],
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        children: tableRows,
      ),
    );
  }

  Widget _buildCustomButton({
    required Widget icon,
    required String label,
    required Color color,
    required void Function() onTap,
  }) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      label: Text(label),
      icon: icon,
      backgroundColor: color,
    );
  }
}
class Item {
  String emoji;
  String text;
  bool checked;

  Item({
    required this.emoji,
    required this.text,
    required this.checked,
  });
}
// 수정된 RoutinePage 클래스 (빈 화면)
class RoutinePage extends StatelessWidget {
  const RoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // 빈 화면으로 변경
  }
}








