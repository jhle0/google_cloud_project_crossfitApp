import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_cloud_project/screen/basic_airsquat_screen.dart';
import 'package:google_cloud_project/screen/basic_deadlift_screen.dart';
import 'package:google_cloud_project/screen/basic_frontsquat_screen.dart';
import 'package:google_cloud_project/screen/basic_jerk_press_screen.dart';
import 'package:google_cloud_project/screen/basic_medicine_ball_screen.dart';
import 'package:google_cloud_project/screen/basic_overhead_squats_screen.dart';
import 'package:google_cloud_project/screen/basic_push_press_screen.dart';
import 'package:google_cloud_project/screen/basic_shoulder_press_screen.dart';
import 'package:google_cloud_project/screen/basic_sumo_deadlift_screen.dart';

class ExerciseCategory extends StatelessWidget {
  final String title;
  final List<Map<String, String>> exercises;

  const ExerciseCategory({
    super.key,
    required this.title,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 20.0,
            right: 0.0,
            bottom: 0,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 227, 227, 227),
                  fontSize: 15,
                ),
              ),
              const Icon(
                Icons.arrow_right,
                color: Color.fromARGB(255, 227, 227, 227),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (exercises[index]['name'] == '   에어 \n    스쿼트') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AirSquatPage(),
                      ),
                    );
                  } else if (exercises[index]['name'] == '    프런트 \n   스쿼트') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FrontSquatPage(),
                      ),
                    );
                  } else if (exercises[index]['name'] == '  오버헤드 \n  스쿼트') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OverheadSquatsPage(),
                      ),
                    );
                  } else if (exercises[index]['name'] == '   숄더 \n    프레스') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShoulderPressPage(),
                      ),
                    );
                  } else if (exercises[index]['name'] == '   푸쉬 \n    프레스') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PushPressPage(),
                      ),
                    );
                  } else if (exercises[index]['name'] == '    저크 \n    프레스') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JerkPressPage(),
                      ),
                    );
                  } else if (exercises[index]['name'] == '   데드\n    리프트') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DeadliftPage(),
                      ),
                    );
                  } else if (exercises[index]['name'] == '스모 \n 데드리프트') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SumoDeadliftPage(),
                      ),
                    );
                  } else if (exercises[index]['name'] == '  메디신볼 \n클린') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MedicineBallPage(),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 20.0,
                    right: 0,
                    bottom: 0,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                exercises[index]['image']!, // 이미지 경로 사용
                                fit: BoxFit.cover,
                              ),
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  color: Colors.black.withOpacity(
                                      0), // 블러 처리된 배경을 위해 투명한 색상 사용
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          exercises[index]['name']!, // 운동 이름 사용
                          style: const TextStyle(
                            color: Color.fromARGB(255, 227, 227, 227),
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
