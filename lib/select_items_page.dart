import 'package:flutter/material.dart';

class SelectedItemsDatabase {
  static final Map<String, List<Map<String, dynamic>>> itemsPerDate = {};
  static ValueNotifier<int> itemsChangeNotifier = ValueNotifier<int>(0);
}

class SelectItemsPage extends StatelessWidget {
  const SelectItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'emoji': '💡', 'text': '불필요한 전등 끄기', 'carbonReduction': 0.05},
      {'emoji': '🛍️', 'text': '재사용 장바구니 사용', 'carbonReduction': 0.1},
      {'emoji': '🚶‍♂️', 'text': '가까운 거리 걷/자전거', 'carbonReduction': 0.2},
      {'emoji': '☕', 'text': '텀블러/개인컵 사용', 'carbonReduction': 0.05},
      {'emoji': '♻️', 'text': '분리수거 철저히', 'carbonReduction': 0.08},
      {'emoji': '🍱', 'text': '남은 음식 재활용', 'carbonReduction': 0.03},
      {'emoji': '🧼', 'text': '친환경 세제/비누', 'carbonReduction': 0.02},
      {'emoji': '🧾', 'text': '전자영수증 활용', 'carbonReduction': 0.01},
      {'emoji': '🤝', 'text': '중고 거래/나눔', 'carbonReduction': 0.05},
      {'emoji': '📧', 'text': '종이낭비 줄이기', 'carbonReduction': 0.04},
      {'emoji': '🛠️', 'text': '재활용품 DIY', 'carbonReduction': 0.03},
      {'emoji': '💧', 'text': '냉수세탁/건조기 최소화', 'carbonReduction': 0.06},
      {'emoji': '🌡️', 'text': '실내온도 적정 유지', 'carbonReduction': 0.07},
      {'emoji': '🚰', 'text': '수돗물 아끼기', 'carbonReduction': 0.04},
      {'emoji': '🍏', 'text': '계절/지역 식품 구매', 'carbonReduction': 0.05},
    ];

    final now = DateTime.now();
    final String formattedDate =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: const Text("항목 선택")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text(items[index]['emoji'].toString()),
            title: Text(items[index]['text'].toString()),
            onTap: () {
              SelectedItemsDatabase.itemsPerDate.putIfAbsent(formattedDate, () => []);
              final selectedItem = {
                ...items[index],
                'checked': false, // 처음 선택 시 기본 체크상태 false
              };
              SelectedItemsDatabase.itemsPerDate[formattedDate]!.add(selectedItem);
              SelectedItemsDatabase.itemsChangeNotifier.value++;
              Navigator.pop(context, selectedItem);
            },
          );
        },
      ),
    );
  }
}
