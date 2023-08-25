import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../drawer.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool showPageView = false;
  @override
  Widget build(BuildContext context) {
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
            child: const Text('맵/지도',
                style: TextStyle(
                    fontFamily: 'oldd',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white)),
          )),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(children: [
            TabBar(
              labelPadding: const EdgeInsets.only(right: 5, left: 5, top: 20),
              indicatorColor: ColorList.select,
              labelColor: ColorList.select,
              unselectedLabelColor: Colors.white,
              isScrollable: true,
              controller: _controller,
              indicatorPadding: const EdgeInsets.only(bottom: 10),
              tabs: [
                Container(
                  alignment: Alignment.topCenter,
                  width: width * 0.3,
                  height: 50,
                  child: const Text('잊성',
                      style: TextStyle(
                          fontFamily: 'oldd',
                          fontSize: 18,
                          color: Colors.white)),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: width * 0.3,
                  height: 50,
                  child: const Text('고던',
                      style: TextStyle(
                          fontFamily: 'oldd',
                          fontSize: 18,
                          color: Colors.white)),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: width * 0.3,
                  height: 50,
                  child: const Text('숲',
                      style: TextStyle(
                          fontFamily: 'oldd',
                          fontSize: 18,
                          color: Colors.white)),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.8,
              child: TabBarView(controller: _controller, children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showPageView = !showPageView;
                        });
                      },
                      child: const Text('일반 잊혀진 성',
                          style: TextStyle(
                              fontFamily: 'oldd',
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white)),
                    ),
                    if (showPageView)
                      Expanded(
                        child: PageView(
                          children: [
                            Image.asset('assets/images/normal1.jpeg'),
                            Image.asset('assets/images/normal2.jpeg'),
                            Image.asset('assets/images/normal3.jpeg')
                          ],
                        ),
                      ),
                  ],
                ),
                Column(
                  children: [Container()],
                ),
                Column(
                  children: [Container()],
                )
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
