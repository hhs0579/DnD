import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkanddarker/Pages/authPage/login.dart';
import 'package:darkanddarker/Pages/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Pages/authPage/profileSet.dart';
import 'firebase_options.dart';

FirebaseAuth auth = FirebaseAuth.instance;
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void main() async {
  await initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Colors.orange,
                  textTheme: const TextTheme(
                      bodyLarge: TextStyle(fontFamily: 'oldd'))),
              // ... 이전 코드
              // ... 이전 코드
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ); // 로딩 화면
                  } else {
                    if (snapshot.hasData && snapshot.data != null) {
                      // Firestore에서 필드 값들을 체크
                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(snapshot.data!.uid)
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (userSnapshot.hasData &&
                              userSnapshot.data!.data() != null) {
                            var data = userSnapshot.data!.data()
                                as Map<String, dynamic>;
                            if (data.containsKey('characterName') &&
                                data.containsKey('discordId') &&
                                data.containsKey('email') &&
                                data.containsKey('nickname') &&
                                data.containsKey('uid')) {
                              return const MainPage(); // 모든 필드가 채워져 있다면 홈 페이지로
                            } else {
                              return const ProfileSetPage(); // 프로필 설정 페이지로
                            }
                          } else {
                            return const LoginPage(); // 문서가 없으면 로그인 페이지로
                          }
                        },
                      );
                    } else {
                      return const LoginPage(); // 로그인 안한 상태면 로그인 페이지로
                    }
                  }
                },
              ),
              // ... 이후 코드

              // ... 이후 코드
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
