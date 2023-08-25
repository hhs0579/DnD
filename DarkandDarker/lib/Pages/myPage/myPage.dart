import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkanddarker/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../drawer.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> _deleteAccount(BuildContext context) async {
  // 현재 사용자 가져오기
  User? user = _auth.currentUser;

  // Firestore에서 사용자 데이터 삭제
  if (user != null) {
    await _firestore.collection('users').doc(user.uid).delete();
  }

  // Firebase Authentication에서 사용자 삭제

  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const MyApp()));
  await user?.delete().catchError((error) {
    print("An error occurred while deleting the account: $error");
  });
}

void _showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: ColorList.primary,
      title: const Text(
        '계정을 삭제하시겠습니까?',
        style: TextStyle(color: Colors.red),
      ),
      content: const Text(
        '이 작업은 되돌릴 수 없습니다.',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                '아니오',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteAccount(context);
              },
              child: const Text(
                '예',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorList.primary,
      key: scaffoldKey,
      endDrawer: drawer(context),
      appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.menu, // 이 아이콘을 당신이 원하는 아이콘으로 변경 가능
                color: Colors.white, // 이곳에서 아이콘 색상을 변경
              ),
              onPressed: () {
                scaffoldKey.currentState?.openEndDrawer(); // endDrawer를 엽니다.
              },
            ),
          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Container(
            child: const Text('My Page',
                style: TextStyle(
                    fontFamily: 'oldd',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white)),
          )),
      body: user != null
          ? StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                Map<String, dynamic>? data =
                    snapshot.data?.data() as Map<String, dynamic>?;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset('assets/images/all.png'),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: Text("Email: ${data?['email'] ?? 'N/A'}",
                                style: const TextStyle(
                                    fontFamily: 'oldd',
                                    fontSize: 18,
                                    color: Colors.white)),
                          ),
                          ListTile(
                            title: Text("닉네임: ${data?['nickname'] ?? 'N/A'}",
                                style: const TextStyle(
                                    fontFamily: 'oldd',
                                    fontSize: 18,
                                    color: Colors.white)),
                          ),
                          ListTile(
                            title: Text(
                                "캐릭터 명: ${data?['characterName'] ?? 'N/A'}",
                                style: const TextStyle(
                                    fontFamily: 'oldd',
                                    fontSize: 18,
                                    color: Colors.white)),
                          ),
                          ListTile(
                            title: Text(
                                "Discord ID: ${data?['discordId'] ?? 'N/A'}",
                                style: const TextStyle(
                                    fontFamily: 'oldd',
                                    fontSize: 18,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: width * 0.9,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: ColorList.select),
                          child: const Text(
                            '수정하기',
                            style: TextStyle(
                                fontFamily: 'oldd',
                                color: Color(0xff0b14bf),
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            _showDeleteAccountDialog(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: width * 0.9,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: ColorList.select),
                            child: const Text(
                              '탈퇴하기',
                              style: TextStyle(
                                  fontFamily: 'oldd',
                                  color: Color(0xffce1424),
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  ],
                );
              },
            )
          : const Center(
              child: Text(
                "You are not logged in",
                style: TextStyle(color: Colors.red, fontSize: 30),
              ),
            ),
    );
  }
}
