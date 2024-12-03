import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class StatsPage extends StatefulWidget {
  final Map<String, int> checkCounts;  // 날짜별 체크된 항목 수를 전달받음

  const StatsPage({super.key, required this.checkCounts});

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 체크된 항목 수에 따라 색상 변경
  Color _getColorBasedOnCheckCount(int count) {
    if (count == 0) return Colors.grey[200]!;
    if (count == 1) return Colors.lightGreen[200]!;
    if (count == 2) return Colors.green[400]!;
    return Colors.green[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: Center(child: Text('${day.day}')),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: Text(
              _selectedDay != null
                  ? '선택된 날짜: ${DateFormat('yyyy-MM-dd').format(_selectedDay!)}'
                  : '날짜를 선택하세요',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}