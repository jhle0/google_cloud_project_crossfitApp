// import 'package:flutter/material.dart';
// import 'package:google_cloud_project/screen/home_screen.dart';
// import 'package:google_cloud_project/screen/wod_screen.dart';
// import 'package:google_cloud_project/screen/workout_history_screen.dart';
// import 'package:google_cloud_project/screen/workout_screen.dart';
// import 'package:google_cloud_project/widget/app_bar_widget.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const App());
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         fontFamily: 'Oswald',
//       ),
//       home: const MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   MainScreenState createState() => MainScreenState();
// }

// class MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   static const List<Widget> _pages = <Widget>[
//     HomeScreen(),
//     WorkoutCategoryScreen(),
//     WodScreen(),
//     WorkoutHistoryScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       appBar: const BaseAppBar(
//         height: 100,
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Theme(
//         data: Theme.of(context).copyWith(
//           canvasColor: const Color.fromARGB(255, 23, 23, 27),
//         ),
//         child: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: '홈',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.directions_run),
//               label: '기본동작',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.checklist),
//               label: 'WOD',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.bar_chart),
//               label: '활동',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: const Color.fromARGB(255, 99, 180, 254),
//           unselectedItemColor: Colors.white,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_cloud_project/screen/home_screen.dart';
import 'package:google_cloud_project/screen/start_select_gender_screen.dart';
import 'package:google_cloud_project/screen/wod_screen.dart';
import 'package:google_cloud_project/screen/workout_history_screen.dart';
import 'package:google_cloud_project/screen/workout_screen.dart';
import 'package:google_cloud_project/service/login_screen.dart';
import 'package:google_cloud_project/widget/app_bar_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Oswald',
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginScreen()
          : const SelectGenderScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    WorkoutCategoryScreen(),
    WodScreen(),
    WorkoutHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        height: 100,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color.fromARGB(255, 23, 23, 27),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_run),
              label: '기본동작',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist),
              label: 'WOD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: '활동',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 99, 180, 254),
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
