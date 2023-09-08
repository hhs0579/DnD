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
  bool showPageView2 = false;
  bool showPageView3 = false;
  bool showPageView4 = false;
  bool showPageView5 = false;
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
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: width * 0.3,
                height: 50,
                child: const Text('고던',
                    style: TextStyle(
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
              ),
              Container(
                alignment: Alignment.topCenter,
                width: width * 0.3,
                height: 50,
                child: const Text('숲',
                    style: TextStyle(
                        fontFamily: 'oldd', fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.8,
            child: TabBarView(controller: _controller, children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/heal.png',
                            scale: 2,
                          ),
                          const Text(
                            ': 회복신전',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/sacri.png',
                            scale: 2,
                          ),
                          const Text(
                            ': 부활신전',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/spawn.png',
                            scale: 2,
                          ),
                          const Text(
                            ': 스폰장소',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/boss.png',
                            scale: 2,
                          ),
                          const Text(
                            ': 보스 및 준보스',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                        SizedBox(
                          height: height * 0.7,
                          child: PageView(
                            children: [
                              Image.asset('assets/images/normal1.jpeg'),
                              Image.asset('assets/images/normal2.jpeg'),
                              Image.asset('assets/images/normal3.jpeg')
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showPageView2 = !showPageView2;
                          });
                        },
                        child: const Text('하이롤러 잊혀진 성',
                            style: TextStyle(
                                fontFamily: 'oldd',
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white)),
                      ),
                      if (showPageView2)
                        SizedBox(
                          height: height * 0.7,
                          child: PageView(
                            children: [
                              Image.asset('assets/images/hard1.jpeg'),
                              Image.asset('assets/images/hard2.jpeg'),
                              Image.asset('assets/images/hard3.jpeg')
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showPageView3 = !showPageView3;
                          });
                        },
                        child: const Text('지옥',
                            style: TextStyle(
                                fontFamily: 'oldd',
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white)),
                      ),
                      if (showPageView3)
                        SizedBox(
                          height: height * 0.7,
                          child: PageView(
                            children: [
                              Image.asset('assets/images/rich.png'),
                              Image.asset('assets/images/ghost.jpeg'),
                              Image.asset('assets/images/skel.jpeg')
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: height * 0.8,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/heal.png',
                                  scale: 2,
                                ),
                                const Text(
                                  ': 회복신전',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/ex.png',
                                  scale: 2,
                                ),
                                const Text(
                                  ': 고정 탈출구',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/spawn.png',
                                  scale: 2,
                                ),
                                const Text(
                                  ': 스폰장소',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/boss.png',
                                  scale: 2,
                                ),
                                const Text(
                                  ': 보스 및 준보스',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showPageView4 = !showPageView4;
                                });
                              },
                              child: const Text('고블린 동굴',
                                  style: TextStyle(
                                      fontFamily: 'oldd',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.white)),
                            ),
                            if (showPageView4)
                              SizedBox(
                                height: height * 0.5,
                                child: PageView(
                                  children: [
                                    Image.asset('assets/images/goblin.png'),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showPageView5 = !showPageView5;
                                });
                              },
                              child: const Text('하이롤러 고블린 동굴',
                                  style: TextStyle(
                                      fontFamily: 'oldd',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.white)),
                            ),
                            if (showPageView5)
                              SizedBox(
                                height: height * 0.5,
                                child: PageView(
                                  children: [
                                    Image.asset('assets/images/hardgobl.png'),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: height * 0.8,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/heal.png',
                                  scale: 2,
                                ),
                                const Text(
                                  ': 회복 신전',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/sacri.png',
                                  scale: 2,
                                ),
                                const Text(
                                  ': 부활 신전',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/spawn.png',
                                  scale: 2,
                                ),
                                const Text(
                                  ': 스폰장소',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  'assets/images/boss.png',
                                  scale: 2,
                                ),
                                const Text(
                                  ': 보스 및 준보스',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text('루인',
                                style: TextStyle(
                                    fontFamily: 'oldd',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white)),
                            SizedBox(
                              height: height * 0.5,
                              child: PageView(
                                children: [
                                  Image.asset('assets/images/ruin.png'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]),
          )
        ]),
      ),
    );
  }
}
