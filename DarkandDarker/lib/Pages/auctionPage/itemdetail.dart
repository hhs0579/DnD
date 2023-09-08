import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/colors.dart';

class ItemDetailPage extends StatefulWidget {
  final DocumentSnapshot item;

  const ItemDetailPage({super.key, required this.item});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchUserInfo(String uid) async {
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(uid).get();
    return userSnapshot.data()! as Map<String, dynamic>;
  }

  bool isOwner = false;

  Widget buildBidList() {
    return StreamBuilder(
      stream: firestore
          .collection('items')
          .doc(widget.item.id)
          .collection('bids')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            String uid = data['bidderUid'];

            return FutureBuilder<Map<String, dynamic>>(
              future: fetchUserInfo(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(title: Text("Loading..."));
                }

                if (snapshot.hasError) {
                  return ListTile(title: Text("Error: ${snapshot.error}"));
                }

                Map<String, dynamic> userData = snapshot.data!;
                return ListTile(
                  title: Text(
                    "입찰액: ${data['bidAmount']}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Discord ID: ${userData['discordId']}",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> deleteItemWithBids(String itemId) async {
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    // 아이템 문서를 가져옵니다
    DocumentSnapshot itemSnapshot =
        await firestore.collection('items').doc(itemId).get();

    // 아이템 문서에서 imageUrl 필드 값을 가져옵니다
    Map<String, dynamic>? data = itemSnapshot.data() as Map<String, dynamic>?;
    String? imageUrl = data?['imageUrl'];

    if (imageUrl != null) {
      // imageUrl의 값을 사용하여 Storage 내의 파일 참조를 얻습니다
      Reference imageRef = storage.refFromURL(imageUrl);

      // 해당 이미지를 Storage에서 삭제합니다
      await imageRef.delete();
    }

    // 아이템에 연결된 'bids' 하위 컬렉션을 가져옵니다
    QuerySnapshot bidSnapshot = await firestore
        .collection('items')
        .doc(itemId)
        .collection('bids')
        .get();

    // 모든 'bids' 문서를 삭제합니다
    for (var doc in bidSnapshot.docs) {
      await firestore
          .collection('items')
          .doc(itemId)
          .collection('bids')
          .doc(doc.id)
          .delete();
    }

    // 아이템을 삭제합니다
    await firestore.collection('items').doc(itemId).delete();
  }

  int? newBid;
  DateTime? lastBidTime; // 마지막으로 입찰한 시간
  bool canBid = true; // 입찰 가능한지 여부
  @override
  TextEditingController bidController = TextEditingController();
  @override
  void initState() {
    super.initState();
    newBid = newBid = widget.item['startingPrice']?.toInt(); // 초기 입찰액을 설정
    bidController.text = '$newBid'; // 초기 입찰액을 텍스트 필드에 표시
    isOwner = (auth.currentUser?.uid == widget.item['ownerUid']);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: ColorList.primary,
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: isOwner
              ? [
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      // Firestore에서 아이템 삭제
                      await deleteItemWithBids(widget.item.id);
                      Navigator.pop(context);
                    },
                  )
                ]
              : [],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("아이템 명: ${widget.item['itemName']}",
                  style: const TextStyle(
                      fontFamily: 'oldd',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white)),
              StreamBuilder<DocumentSnapshot>(
                stream: firestore
                    .collection('items')
                    .doc(widget.item.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic>? data =
                        snapshot.data?.data() as Map<String, dynamic>?;
                    int? currentBid = data?['currentBid'] as int?;
                    return Text("최고 입찰가: ${currentBid ?? 'None'}",
                        style: const TextStyle(
                            fontFamily: 'oldd',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white));
                  }
                  return const Text("Loading...");
                },
              ),
              Text("시작가: ${widget.item['startingPrice']}",
                  style: const TextStyle(
                      fontFamily: 'oldd',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white)),
              Text("닉네임: ${widget.item['nickname']}",
                  style: const TextStyle(
                      fontFamily: 'oldd',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white)),
              Container(
                margin: const EdgeInsets.only(top: 40, bottom: 40),
                width: width,
                height: height * 0.6,
                child: widget.item['imageURL'] != null
                    ? Image.network(widget.item['imageURL'])
                    : Container(),
              ),
              if (user!.uid != widget.item['ownerUid']) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (newBid != null &&
                            newBid! > widget.item['startingPrice']) {
                          newBid = newBid! - 10;
                          bidController.text = '$newBid'; // 텍스트 필드 업데이트
                          setState(() {}); // 상태 갱신
                        }
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: width * 0.2,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        controller: bidController,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: ColorList.select), // 여기에서 원하는 색상을 선택
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          newBid = int.tryParse(value);
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (newBid != null) {
                          newBid = newBid! + 10;
                          bidController.text = '$newBid'; // 텍스트 필드 업데이트
                          setState(() {}); // 상태 갱신
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    if (newBid != null &&
                        newBid! >= widget.item['startingPrice'] &&
                        newBid! % 10 == 0) {
                      await firestore
                          .collection('items')
                          .doc(widget.item.id)
                          .collection('bids')
                          .add({
                        'bidAmount': newBid,
                        'bidderUid': user.uid,
                        // 이부분을 적절한 값으로 설정해야합니다.
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      DocumentSnapshot itemSnapshot = await firestore
                          .collection('items')
                          .doc(widget.item.id)
                          .get();
                      Map<String, dynamic>? data =
                          itemSnapshot.data() as Map<String, dynamic>?;
                      int? currentBid = data?['currentBid'] as int?;

                      // 새로운 입찰가가 현재 입찰가보다 높을 경우에만 업데이트
                      if (currentBid == null || newBid! > currentBid) {
                        await firestore
                            .collection('items')
                            .doc(widget.item.id)
                            .update({
                          'currentBid': newBid,
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("유효한 금액을 입력하세요 (10원 단위), 초기 입찰액 이상"),
                        ),
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ColorList.select,
                    ),
                    child: const Text(
                      '입찰하기',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
              if (user.uid == widget.item['ownerUid']) ...[
                const Text(
                  "입찰내역",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 300,
                  child: buildBidList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
