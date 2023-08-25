import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkanddarker/Pages/authPage/profileSet.dart';
import 'package:darkanddarker/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:darkanddarker/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

User? user = auth.currentUser;

Future<UserCredential> signInWithGoogle(BuildContext context) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Navigate to Home Page if successful
  if (userCredential.user != null) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const ProfileSetPage()));
    await firestore.collection('users').doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid, 'email': userCredential.user!.email});
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('구글 로그인 실패')),
    );
  }

  return userCredential;
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorList.primary,
      body: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: width * 0.5,
                child: Image.asset('assets/images/mainlogo.png')),
            InkWell(
              onTap: () {
                signInWithGoogle(context);
              },
              child: Container(
                alignment: Alignment.center,
                width: width * 0.85,
                height: 50,
                decoration: BoxDecoration(
                    color: ColorList.select,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Google Login',
                  style: TextStyle(
                      fontFamily: 'old',
                      color: ColorList.primary,
                      fontSize: 25),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
