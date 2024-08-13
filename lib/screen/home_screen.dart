import 'package:flutter/material.dart';
import 'package:google_cloud_project/widget/home_daily_challenge_widget.dart';
import 'package:google_cloud_project/widget/home_news_widget.dart';
import 'package:google_cloud_project/widget/home_tr_tips_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 23, 27),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '홈',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            DailyChallengeWidget(),
            SizedBox(height: 70),
            NewsWidget(),
            SizedBox(height: 70),
            TrainingTipsWidget(),
          ],
        ),
      ),
    );
  }
}
