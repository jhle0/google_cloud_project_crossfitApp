// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_cloud_project/service/login_screen.dart';

// class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final double height;

//   const BaseAppBar({super.key, this.height = kToolbarHeight});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color.fromARGB(255, 23, 23, 27),
//       height: height + MediaQuery.of(context).padding.top,
//       child: Padding(
//         padding: EdgeInsets.only(
//           top: MediaQuery.of(context).padding.top,
//           left: 20.0,
//           right: 20.0,
//           bottom: 5.0,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.person,
//                         color: Colors.black,
//                       ),
//                     ),
//                     SizedBox(width: 13.0),
//                     Text(
//                       '(User)',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10.0),
//                 Text(
//                   'Welcome User',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: IconButton(
//                     icon: const Icon(Icons.logout, color: Colors.white),
//                     onPressed: () async {
//                       await FirebaseAuth.instance.signOut();
//                       await GoogleSignIn().signOut();

//                       // 로그아웃 후 로그인 화면으로 이동
//                       if (context.mounted) {
//                         // BuildContext의 유효성을 확인
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LoginScreen(),
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(height);
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_cloud_project/service/login_screen.dart';
import 'package:google_cloud_project/screen/user_detail_screen.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const BaseAppBar({super.key, this.height = kToolbarHeight});

  Future<Map<String, String?>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          return {
            'name': doc.data()?['name'] as String?,
            'photoUrl': doc.data()?['photoUrl'] as String?,
          };
        } else {
          print("Document does not exist");
          return {'name': 'User', 'photoUrl': null};
        }
      } catch (e) {
        print("Error fetching user data: $e");
        return {'name': 'User', 'photoUrl': null};
      }
    }
    return {'name': 'User', 'photoUrl': null};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: const Color.fromARGB(255, 23, 23, 27),
            height: height + MediaQuery.of(context).padding.top,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            color: const Color.fromARGB(255, 23, 23, 27),
            height: height + MediaQuery.of(context).padding.top,
            child: const Center(
              child: Text(
                'Error loading user data',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Container(
            color: const Color.fromARGB(255, 23, 23, 27),
            height: height + MediaQuery.of(context).padding.top,
            child: const Center(
              child: Text(
                'User data not found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final userName = snapshot.data!['name'] ?? 'User';
        final photoUrl = snapshot.data!['photoUrl'];

        return Container(
          color: const Color.fromARGB(255, 23, 23, 27),
          height: height + MediaQuery.of(context).padding.top,
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 20.0,
              right: 20.0,
              bottom: 5.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserDetailScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: photoUrl != null
                                ? NetworkImage(photoUrl)
                                : null,
                            child: photoUrl == null
                                ? const Icon(Icons.person, color: Colors.black)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 13.0),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Welcome $userName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          await GoogleSignIn().signOut();

                          // 로그아웃 후 로그인 화면으로 이동
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
