import 'package:flutter/material.dart';

class SelectItemsPage extends StatelessWidget {
  const SelectItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 미리 정의된 항목 목록
    final List<Map<String, String>> items = [
      {'emoji': '🌱', 'text': '식물 돌보기'},
      {'emoji': '🏃‍♂️', 'text': '운동하기'},
      {'emoji': '📚', 'text': '책 읽기'},
      {'emoji': '🍏', 'text': '건강한 식사'},
      {'emoji': '💻', 'text': '코딩하기'},
      {'emoji': '🎨', 'text': '그림 그리기'},
      {'emoji': '🧘‍♀️', 'text': '명상하기'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("항목 선택")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(items[index]['emoji']!),
            title: Text(items[index]['text']!),
            onTap: () {
              // 항목을 선택했을 때 HomePage로 해당 항목을 전달
              Navigator.pop(context, items[index]);
            },
          );
        },
      ),
    );
  }
}

