import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedDay = "월";

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
      _selectedDay = day;
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
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildDateButton(String day) {
    bool isSelected = _selectedDay == day;
    return InkWell(
      onTap: () => _selectDay(day),
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
