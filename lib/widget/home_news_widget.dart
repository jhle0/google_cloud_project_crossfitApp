import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crossfit News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        NewsItem(
          source: 'Crossfit Games',
          title: 'Tia-Clair Toomey Wins 7th Fittest Woman on Earth Title',
          time: '8h',
          image: AssetImage('assets/크로스핏뉴스.jpeg'),
          articleUrl:
              'https://www.ohmynews.com/NWS_Web/View/at_pg.aspx?CNTN_CD=A0002919557',
        ),
        SizedBox(height: 16),
        NewsItem(
          source: 'Crossfit Updates',
          title: 'James Sprague Wins 2024 CrossFit Games Men’s Division',
          time: '8h',
          image: AssetImage('assets/크로스핏뉴스.jpeg'),
          articleUrl: 'https://www.example.com/article2',
        ),
        SizedBox(height: 16),
        NewsItem(
          source: 'Crossfit News',
          title: 'YETI Sponsors 2024 CrossFit Games Broadcast on ESPN',
          time: '8h',
          image: AssetImage('assets/크로스핏뉴스.jpeg'), // 이미지 assets 사용
          articleUrl: 'https://www.example.com/article3', // 실제 URL로 변경
        ),
      ],
    );
  }
}

class NewsItem extends StatelessWidget {
  final String source;
  final String title;
  final String time;
  final AssetImage image;
  final String articleUrl;

  const NewsItem({
    super.key,
    required this.source,
    required this.title,
    required this.time,
    required this.image,
    required this.articleUrl,
  });

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // URL을 Uri 객체로 변환
    if (await canLaunchUrl(uri)) {
      // Uri 객체 전달
      await launchUrl(uri); // Uri 객체 전달
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(articleUrl);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  source,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image(
            image: image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
