import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'select_items_page.dart'; // SelectedItemsDatabase 사용을 위해 필요

class StatsPage extends StatefulWidget {
  final Map<String, int> checkCounts; // main.dart에서 기존대로 checkCounts를 받는다.

  const StatsPage({super.key, required this.checkCounts});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Color _getColorBasedOnCheckCount(int count) {
    if (count == 0) return Colors.grey[200]!;
    if (count == 1) return Colors.lightGreen[200]!;
    if (count == 2) return Colors.green[400]!;
    return Colors.green[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: SelectedItemsDatabase.itemsChangeNotifier,
      builder: (context, _, __) {
        int selectedCheckCount = 0;
        double carbonReduction = 0.0;

        if (_selectedDay != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay!);
          selectedCheckCount = widget.checkCounts[formattedDate] ?? 0;

          // 선택된 날짜의 아이템 중 checked == true인 항목만 탄소발자국 합산
          List<Map<String, dynamic>> itemsForDay = SelectedItemsDatabase.itemsPerDate[formattedDate] ?? [];
          for (var item in itemsForDay) {
            if (item['checked'] == true) {
              carbonReduction += (item['carbonReduction'] as double? ?? 0.0);
            }
          }
        }

        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2100),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(day);
                        int checkCount = widget.checkCounts[formattedDate] ?? 0;
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _getColorBasedOnCheckCount(checkCount),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                      todayBuilder: (context, day, focusedDay) {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(day);
                        int checkCount = widget.checkCounts[formattedDate] ?? 0;
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _getColorBasedOnCheckCount(checkCount),
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              if (_selectedDay != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    child: Card(
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '오늘의 탄소발자국 절감량',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${carbonReduction.toStringAsFixed(2)} kg CO₂',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '체크된 항목: $selectedCheckCount개',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (_selectedDay == null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    child: Card(
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          '날짜를 선택하면\n탄소발자국 절감을 볼 수 있습니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          backgroundColor: Colors.grey[100],
        );
      },
    );
  }
}
