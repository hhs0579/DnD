import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../utils/colors.dart'; // Add this import

class AuctionUploadPage extends StatefulWidget {
  const AuctionUploadPage({super.key});

  @override
  _AuctionUploadPageState createState() => _AuctionUploadPageState();
}

class _AuctionUploadPageState extends State<AuctionUploadPage> {
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  XFile? _image;
  final ImagePicker picker = ImagePicker();

  Future<void> uploadImage() async {
    if (_image != null) {
      setState(() {
        isLoading = true;
      });
      File originalFile = File(_image!.path);
      File compressedFile = await compressImage(originalFile);

      Reference reference =
          storage.ref().child("auctionItems/${basename(compressedFile.path)}");
      UploadTask uploadTask = reference.putFile(compressedFile);
      await uploadTask.whenComplete(() async {
        if (!mounted) return;

        TaskSnapshot taskSnapshot = await uploadTask;
        imageURL = await taskSnapshot.ref.getDownloadURL();
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<File> compressImage(File file) async {
    final img.Image? image = img.decodeImage(file.readAsBytesSync());
    final img.Image compressedImage = img.copyResize(image!, width: 500);

    final Uint8List compressedList =
        Uint8List.fromList(img.encodeJpg(compressedImage, quality: 80));

    final String path = file.path;
    final File compressedFile = File(path)..writeAsBytesSync(compressedList);

    return compressedFile;
  }

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  String? itemName;
  int? startingPrice;
  String? imageURL;
  bool get isSubmitEnabled {
    return itemName != null && itemName!.isNotEmpty && _image != null;
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? SizedBox(
            width: 300,
            height: 300,
            child: Image.file(File(_image!.path)),
          )
        : Container(
            width: 300,
            height: 300,
            color: Colors.black,
            child: Icon(
              Icons.camera_alt_outlined,
              color: ColorList.select,
              size: 60,
            ),
          );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.camera);
          },
          child: const Text("카메라"),
        ),
        const SizedBox(width: 30),
        ElevatedButton(
          onPressed: () {
            getImage(ImageSource.gallery);
          },
          child: const Text("갤러리"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Container(
            child: const Text('판매',
                style: TextStyle(
                    fontFamily: 'oldd',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white)),
          )),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          itemName = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '아이템명',
                        hintStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorList.select),
                        ),
                      ),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        int? parsedValue = int.tryParse(value);
                        if (parsedValue != null &&
                            (parsedValue % 10 == 0) &&
                            parsedValue <= 10000) {
                          setState(() {
                            startingPrice = parsedValue;
                          });
                        } else {
                          // 유효하지 않은 값에 대한 처리 (예: 경고 메시지 표시)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('시작가는 10의 배수이어야 합니다.'),
                            ),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        hintText: '시작가',
                        hintStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorList.select),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30, width: double.infinity),
                        _buildPhotoArea(),
                        const SizedBox(height: 20),
                        _buildButton(),
                      ],
                    ),
                    // AuctionUploadPage
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: isSubmitEnabled &&
                    !isLoading &&
                    (startingPrice != null && startingPrice! % 10 == 0)
                ? () async {
                    if (isLoading) return;
                    setState(() {
                      isLoading = true; // 작업 시작 전에 로딩 상태를 true로 설정
                    });
                    await uploadImage();
                    final user = auth.currentUser;
                    if (user != null && itemName != null && imageURL != null) {
                      DocumentSnapshot userDoc = await firestore
                          .collection('users')
                          .doc(user.uid)
                          .get();
                      Map<String, dynamic>? userData =
                          userDoc.data() as Map<String, dynamic>?;

                      if (userData != null) {
                        String? nickname = userData['nickname'];
                        String? discordId = userData['discordId'];

                        await firestore.collection('items').add({
                          'itemName': itemName,
                          'startingPrice': startingPrice ?? 0,
                          'imageURL': imageURL,
                          'owner': user.displayName,
                          'nickname': nickname,
                          'discordId': discordId,
                          'ownerUid': user.uid,
                        });

                        Navigator.pop(context);
                        setState(() {
                          isLoading = false; // 작업이 끝나면 로딩 상태를 false로 설정
                        });
                      } else {
                        // 사용자 문서가 없거나 정보가 없는 경우 처리
                      }
                    }
                  }
                : null,
            child: isLoading
                ? const CircularProgressIndicator()
                : Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    height: 60,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorList.select),
                    child: const Text(
                      '업로드',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
