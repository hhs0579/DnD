import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkanddarker/Pages/auctionPage/upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/colors.dart';
import '../drawer.dart';
import 'itemdetail.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final picker = ImagePicker();
  final storage = FirebaseStorage.instance;

  String? itemName;
  int? startingPrice;
  String? imageURL;

  bool get isSubmitEnabled {
    return itemName != null && itemName!.isNotEmpty && imageURL != null;
  }

  Widget buildListTile(DocumentSnapshot item) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        ListTile(
          shape: Border.all(color: Colors.white),
          title: Text("아이템명: ${item['itemName']}",
              style: const TextStyle(color: Colors.white)),
          subtitle: StreamBuilder(
            stream: firestore
                .collection('items')
                .doc(item.id)
                .collection('bids')
                .orderBy('bidAmount', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Error',
                    style: TextStyle(color: Colors.white));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...',
                    style: TextStyle(color: Colors.white));
              }

              final bids = snapshot.data!.docs;
              int highestBid = item['startingPrice'];

              if (bids.isNotEmpty) {
                highestBid = bids.first['bidAmount'];
              }

              return Text(
                "시작가: ${item['startingPrice']} Gold - 최고 입찰가: $highestBid Gold",
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailPage(item: item),
              ),
            );
          },
        ),
      ],
    );
  }

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
            child: const Text('경매장',
                style: TextStyle(
                    fontFamily: 'oldd',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white)),
          )),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: width,
                height: height,
                child: StreamBuilder(
                  stream: firestore.collection('items').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final items = snapshot.data!.docs;

                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return buildListTile(
                              item); // 이제 각 항목에 대한 ListTile을 생성
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuctionUploadPage(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              height: 60,
              width: width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: ColorList.select,
              ),
              child: Text(
                '판매하기',
                style: TextStyle(
                    color: ColorList.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
