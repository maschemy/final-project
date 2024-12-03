
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'SelectitemsPage.dart';  // 추가된 SelectItemsPage import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final Map<String, List<Item>> _itemsPerDate = {};
  final Map<String, int> _checkCounts = {};  // 날짜별 체크된 항목
  // 선택된 항목을 가져옵니다.
  void _updateCheckCount() {
    int checkedCount = 0;
    List<Item> currentItems = _itemsPerDate[_selectedDate.toString()] ?? [];
    for (var item in currentItems) {
      if (item.checked) {
        checkedCount++;
      }
    }
    _checkCounts[_selectedDate.toString()] = checkedCount;
  }
  void _addItemFromSelectPage() async {
    final selectedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectItemsPage(),
      ),
    );

    if (selectedItem != null) {
      setState(() {
        final itemList = _itemsPerDate[_selectedDate.toString()] ?? [];
        if (itemList.length < 7) {
          itemList.add(Item(emoji: selectedItem['emoji'], text: selectedItem['text'], checked: false));
          _itemsPerDate[_selectedDate.toString()] = itemList;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('항목은 최대 7개까지 추가할 수 있습니다.')),
          );
        }
      });
    }
  }

  List<DateTime> _getCurrentWeekDates() {
    DateTime today = _selectedDate;
    int currentWeekday = today.weekday;
    DateTime firstDayOfWeek = today.subtract(Duration(days: currentWeekday - 1));
    return List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));
  }

  void _toggleCheck(Item item) {
    setState(() {
      item.checked = !item.checked;
      _updateCheckCount();
    });
  }
  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = _getCurrentWeekDates();
    String currentMonthYear = DateFormat('yyyy년 M월').format(_selectedDate);
    List<Item> currentItems = _itemsPerDate[_selectedDate.toString()] ?? [];
    _updateCheckCount();  // 체크된 항목 수 업데이트
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정 관리'),
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
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _addItemFromSelectPage,
              child: const Icon(Icons.add),
              backgroundColor: Colors.green,
            ),
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
              Container(
                height: 60,
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      currentItems.removeAt(i);
                      if (currentItems.isEmpty) {
                        _itemsPerDate.remove(_selectedDate.toString());
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        tableRows.add(
          TableRow(
            children: [
              Container(
                height: 60,
                alignment: Alignment.center,
                child: const SizedBox(),
              ),
              Container(
                height: 60,
                alignment: Alignment.center,
                child: const SizedBox(),
              ),
              Container(
                height: 60,
                alignment: Alignment.center,
                child: const SizedBox(),
              ),
              Container(
                height: 60,
                alignment: Alignment.center,
                child: const SizedBox(),
              ),
            ],
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Table(
        border: TableBorder.all(
          color: Colors.grey,
          width: 2,
          borderRadius: BorderRadius.circular(8),
        ),
        columnWidths: const {
          0: FixedColumnWidth(60),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(60),
          3: FixedColumnWidth(60),
        },
        children: tableRows,
      ),
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
