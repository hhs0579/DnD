import 'package:darkanddarker/utils/colors.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: drawer(context),
      backgroundColor: ColorList.primary,
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
              child: SizedBox(
                  width: width * 0.5,
                  child: Image.asset('assets/images/long.png')))),
      body: Container(
        child: const Text(
          '공지사항',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
