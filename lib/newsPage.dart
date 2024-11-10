import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final String clientId = '9SHAFCPf78pwvOjDbu2S'; // 네이버 API 클라이언트 ID
  final String clientSecret = '2MC5ZiZOez'; // 네이버 API 시크릿 키
  List<dynamic> newsList = [];
  final String keyword = "친환경"; // 고정된 키워드 '탄소중립'

  // 뉴스 데이터를 가져오는 함수
  Future<void> fetchNews() async {
    final response = await http.get(
      Uri.parse('https://openapi.naver.com/v1/search/news.json?query=$keyword'),
      headers: {
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        newsList = json.decode(response.body)['items'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  // 웹 브라우저에서 URL 열기
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews(); // 앱 시작 시 '탄소중립' 키워드로 뉴스 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('탄소중립 관련 뉴스'),
      ),
      body: newsList.isNotEmpty
          ? ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          final newsItem = newsList[index];
          return ListTile(
            title: Text(newsItem['title'].toString().replaceAll(RegExp(r'<[^>]*>'), '')),
            subtitle: Text(newsItem['description'].toString().replaceAll(RegExp(r'<[^>]*>'), '')),
            onTap: () => _launchURL(newsItem['link']),
          );
        },
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
