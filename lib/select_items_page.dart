import 'package:flutter/material.dart';

class SelectItemsPage extends StatelessWidget {
  const SelectItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {'emoji': '💡', 'text': '사용하지 않는 전등 끄기'},
      {'emoji': '🛍️', 'text': '재사용 가능한 장바구니 사용하기'},
      {'emoji': '🚶‍♂️', 'text': '가까운 거리는 걷거나 자전거 타기'},
      {'emoji': '☕', 'text': '일회용 컵 대신 텀블러나 개인 컵 사용하기'},
      {'emoji': '♻️', 'text': '쓰레기 분리수거 철저히 하기'},
      {'emoji': '🍱', 'text': '남은 음식은 다음 식사에 재활용하기'},
      {'emoji': '🧼', 'text': '친환경 인증 세제나 비누 사용하기'},
      {'emoji': '🧾', 'text': '전자영수증 받기'},
      {'emoji': '🤝', 'text': '중고품 거래나 나눔 실천하기'},
      {'emoji': '📧', 'text': '종이낭비 줄이기(이메일, 전자문서 사용)'},
      {'emoji': '🛠️', 'text': '재활용품으로 DIY 소품 만들기'},
      {'emoji': '💧', 'text': '세탁 시 냉수 사용하고 건조기는 최소화하기'},
      {'emoji': '🌡️', 'text': '실내 온도 적정 유지(난방, 냉방 절약)'},
      {'emoji': '🚰', 'text': '수돗물 아껴쓰기(샤워시간 단축)'},
      {'emoji': '🍏', 'text': '계절 식품, 지역 농산물 구매하기'},
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
              Navigator.pop(context, items[index]);
            },
          );
        },
      ),
    );
  }
}
