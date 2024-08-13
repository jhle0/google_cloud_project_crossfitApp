import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_cloud_project/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<User?> _signInWithGoogle() async {
    try {
      print('Attempting Google Sign-In...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('Google Sign-In successful: $googleUser');

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        print('Google Auth successful: $googleAuth');

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        print('Firebase Sign-In successful: $userCredential');

        return userCredential.user;
      }
    } catch (error) {
      print('Google Sign-In error: $error');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            User? user = await _signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
              );
            }
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
