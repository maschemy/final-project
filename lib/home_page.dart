import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'select_items_page.dart';

class HomePage extends StatefulWidget {
  final Map<String, int> checkCounts; // 날짜별 체크된 항목 수를 전달받음

  const HomePage({super.key, required this.checkCounts});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final Map<String, List<Item>> _itemsPerDate = {};

  // 선택된 항목을 가져옵니다.
  void _updateCheckCount() {
    int checkedCount = 0;
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // 현재 날짜의 체크된 항목 수 계산
    List<Item> currentItems = _itemsPerDate[formattedDate] ?? [];
    for (var item in currentItems) {
      if (item.checked) {
        checkedCount++;
      }
    }
    // 체크된 항목 수 업데이트
    setState(() {
      widget.checkCounts[formattedDate] = checkedCount;
    });
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
        final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
        final itemList = _itemsPerDate[formattedDate] ?? [];
        if (itemList.length < 7) {
          itemList.add(Item(
            emoji: selectedItem['emoji'],
            text: selectedItem['text'],
            checked: false,
          ));
          _itemsPerDate[formattedDate] = itemList;
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
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    List<Item> currentItems = _itemsPerDate[formattedDate] ?? [];

    return Scaffold(
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
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '☀️',
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '오늘의 루틴',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(child: _buildTable(currentItems)),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _addItemFromSelectPage,
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
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
                height: 50,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 25)),
                    const SizedBox(width: 8),
                    Text(
                      item.text,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Checkbox(
                  value: item.checked,
                  onChanged: (value) {
                    _toggleCheck(item);
                  },
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      currentItems.removeAt(i);
                      if (currentItems.isEmpty) {
                        final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
                        _itemsPerDate.remove(formattedDate);
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
                height: 50,
                alignment: Alignment.center,
                child: const SizedBox(),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: const SizedBox(),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: const SizedBox(),
              ),
            ],
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(tableRows.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.5),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              );
            }),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Table(
              border: TableBorder.all(
                color: Colors.grey,
                width: 2,
                borderRadius: BorderRadius.circular(8),
              ),
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FixedColumnWidth(50),
                2: FixedColumnWidth(50),
              },
              children: tableRows.map((row) {
                return TableRow(
                  children: row.children.map((cell) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: cell,
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
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
