import 'package:darkanddarker/Pages/auctionPage/auction.dart';
import 'package:darkanddarker/Pages/equipPage/equip.dart';
import 'package:darkanddarker/Pages/mapPage/map.dart';
import 'package:darkanddarker/Pages/myPage/myPage.dart';
import 'package:darkanddarker/Pages/partyPage/party.dart';
import 'package:darkanddarker/Pages/solutionPage/solution.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

drawer(BuildContext context) {
  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: const Color(0x00ff3232),
          content: SingleChildScrollView(
            child: ListBody(
              //List Body를 기준으로 Text 설정
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: const Text(
                      '로그아웃 하시겠습니까?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    '로그아웃',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.6,
    child: Drawer(
      backgroundColor: ColorList.primary,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, left: 20, bottom: 20),
            alignment: Alignment.topLeft,
            child: const Text(
              '메뉴',
              style: TextStyle(
                  fontFamily: 'oldd',
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white),
            ),
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => (const MyPage())));
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    // POINT
                    color: Colors.grey,
                    width: 1),
              )),
              child: const ListTile(
                title: Text('내 정보',
                    style: TextStyle(
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => (const AuctionPage())));
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    // POINT
                    color: Colors.grey,
                    width: 1),
              )),
              child: const ListTile(
                title: Text('경매장',
                    style: TextStyle(
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => (const PartyPage())));
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    // POINT
                    color: Colors.grey,
                    width: 1),
              )),
              child: const ListTile(
                title: Text('파티 찾기',
                    style: TextStyle(
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => (const EquipPage())));
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    // POINT
                    color: Colors.grey,
                    width: 1),
              )),
              child: const ListTile(
                title: Text('장비',
                    style: TextStyle(
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => (const MapPage())));
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    // POINT
                    color: Colors.grey,
                    width: 1),
              )),
              child: const ListTile(
                title: Text('맵/지도',
                    style: TextStyle(
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => (const SolutionPage())));
            },
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                    // POINT
                    color: Colors.grey,
                    width: 1),
              )),
              child: const ListTile(
                title: Text('공략',
                    style: TextStyle(
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
