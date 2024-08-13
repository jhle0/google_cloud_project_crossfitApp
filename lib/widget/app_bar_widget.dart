import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_cloud_project/screen/login_screen.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const BaseAppBar({super.key, this.height = kToolbarHeight});

  @override
  Widget build(BuildContext context) {
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 13.0),
                    Text(
                      '(User)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  'Welcome User',
                  style: TextStyle(
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
                        // BuildContext의 유효성을 확인
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
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
