import 'package:flutter/material.dart';
import 'package:google_cloud_project/widget/exercise_category_widget.dart';

class WorkoutCategoryScreen extends StatelessWidget {
  const WorkoutCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 29),
      // backgroundColor: Colors.red,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10, // 상태바 높이만큼 패딩 추가
                  left: 20.0,
                  right: 30.0,
                  bottom: 0,
                ),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '기본동작',
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: Color.fromARGB(255, 227, 227, 227),
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextSpan(
                        text: ' 코칭',
                        style: TextStyle(
                          color: Color.fromARGB(255, 99, 180, 254),
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 25,
                ),
                child: Text(
                  '9 Basic Movements from the Level 1 Course',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const ExerciseCategory(
                title: '스쿼트',
                exercises: [
                  {'name': '   에어 \n    스쿼트', 'image': 'assets/back-squat.jpg'},
                  {
                    'name': '    프런트 \n   스쿼트',
                    'image': 'assets/body-squat.jpg'
                  },
                  {'name': '  오버헤드 \n  스쿼트', 'image': 'assets/front-squat.jpg'},
                ],
              ),
              const ExerciseCategory(
                title: '프레스',
                exercises: [
                  {'name': '   숄더 \n    프레스', 'image': 'assets/back-squat.jpg'},
                  {'name': '   푸쉬 \n    프레스', 'image': 'assets/pull-up.jpg'},
                  {
                    'name': '    저크 \n    프레스',
                    'image': 'assets/back-squat.jpg'
                  },
                ],
              ),
              const ExerciseCategory(
                title: '데드 리프트',
                exercises: [
                  {'name': '   데드\n    리프트', 'image': 'assets/back-squat.jpg'},
                  {'name': '스모 \n 데드리프트', 'image': 'assets/back-squat.jpg'},
                ],
              ),
              const ExerciseCategory(
                title: '클린',
                exercises: [
                  {'name': '  메디신볼 \n클린', 'image': 'assets/back-squat.jpg'},
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
