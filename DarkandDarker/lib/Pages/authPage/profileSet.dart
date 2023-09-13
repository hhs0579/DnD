import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkanddarker/Pages/mainPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class ProfileSetPage extends StatefulWidget {
  const ProfileSetPage({super.key});

  @override
  State<ProfileSetPage> createState() => _ProfileSetPageState();
}

class _ProfileSetPageState extends State<ProfileSetPage> {
  final TextEditingController nicknameController = TextEditingController();

  final TextEditingController characterNameController = TextEditingController();

  final TextEditingController discordIdController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? nicknameErrorText;
  String? characterNameErrorText;
  String? discordIdErrorText;
  final FocusNode nicknameFocusNode = FocusNode();
  final FocusNode characterNameFocusNode = FocusNode();
  final FocusNode discordIdFocusNode = FocusNode();
  // 디스코드 아이디에는 # 또는 _가 포함되어야 함
  bool isValidDiscordId(String value) {
    // 문자열 길이가 4자리 이상인지 확인
    if (value.length < 4) {
      return false;
    }

    // # 또는 _ 가 있는지 확인
    bool containsHash = value.contains('#');
    bool containsUnderscore = value.contains('_');

    // # 또는 _ 가 있고, 나머지가 숫자+알파벳인 경우
    if ((containsHash || containsUnderscore) &&
        value
            .replaceAll(RegExp(r'[_#]'), '')
            .split('')
            .every((element) => element.contains(RegExp(r'[\d\w]')))) {
      return true;
    }

    // 오직 숫자만 포함하는 경우
    if (value.split('').every((element) => element.contains(RegExp(r'\d')))) {
      return true;
    }

    return false;
  }

  // 캐릭터 이름은 영문과 숫자 허용
  bool isValidCharacterName(String value) {
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);
  }

  // 닉네임은 특수 문자를 포함하지 않고, 9글자 미만
  bool isValidNickname(String value) {
    return RegExp(r'^[\w\u3131-\u314e\u314f-\u3163\uac00-\ud7a3]+$')
            .hasMatch(value) &&
        value.length <= 8;
  }

  void validateInputs() {
    setState(() {
      if (!isValidNickname(nicknameController.text)) {
        nicknameErrorText = "올바른 닉네임을 입력해주세요.";
      } else {
        nicknameErrorText = null;
      }

      if (!isValidCharacterName(characterNameController.text)) {
        characterNameErrorText = "올바른 캐릭터 이름을 입력해주세요.";
      } else {
        characterNameErrorText = null;
      }

      if (!isValidDiscordId(discordIdController.text)) {
        discordIdErrorText = "올바른 Discord ID를 입력해주세요.";
      } else {
        discordIdErrorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorList.primary,
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/long.png',
                      scale: 2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '필수 정보 입력',
                      style: TextStyle(
                          fontFamily: 'oldd',
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: nicknameController,
                        focusNode: nicknameFocusNode,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'oldd',
                            fontSize: 18),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            characterNameFocusNode.requestFocus(),
                        decoration: InputDecoration(
                          hintText: '닉네임',
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'oldd',
                              fontSize: 18),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorText: nicknameErrorText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: characterNameController,
                        focusNode: characterNameFocusNode,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'oldd',
                            fontSize: 18),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            discordIdFocusNode.requestFocus(),
                        decoration: InputDecoration(
                          hintText: '캐릭터 이름',
                          hintStyle: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'oldd',
                              fontSize: 18),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorText: characterNameErrorText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'oldd',
                            fontSize: 18),
                        controller: discordIdController,
                        focusNode: discordIdFocusNode,
                        decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorText: discordIdErrorText,
                            hintText: 'Discord ID',
                            hintStyle: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'oldd',
                                fontSize: 18)),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  height: 50,
                  width: width * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ColorList.select),
                    onPressed: () async {
                      String nickname = nicknameController.text;
                      String characterName = characterNameController.text;
                      String discordId = discordIdController.text;
                      validateInputs();
                      if (isValidNickname(nickname) &&
                          isValidCharacterName(characterName) &&
                          isValidDiscordId(discordId)) {
                        User? user = _auth.currentUser;
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                          );
                          await _firestore
                              .collection('users')
                              .doc(user.uid)
                              .set({
                            'nickname': nickname,
                            'characterName': characterName,
                            'discordId': discordId,
                          }, SetOptions(merge: true));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('입력한 정보를 다시 확인해주세요.'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      '완료',
                      style: TextStyle(fontFamily: 'oldd', fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
