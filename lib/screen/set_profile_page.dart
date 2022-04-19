import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'dart:async';
import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'package:image_picker/image_picker.dart';

import 'experience_level.dart';

class SetProfilePage extends StatefulWidget {
  final File? image;
  const SetProfilePage({Key? key, this.image}) : super(key: key);

  @override
  _SetProfilePageState createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  File? _image;
  ImagePicker? picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker!.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);

      print('fkmbjfglkvm bkjlg${_image}');
      if (_image != null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.kBlack,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: ColorUtils.kTint,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.01),
                  child: Text('Profile Photo',
                      style: FontTextStyle.kWhite17BoldRoboto),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.01),
                  child: InkWell(
                    onTap: () {},
                    child: Text('Skip', style: FontTextStyle.kTine16W400Roboto),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.06,
            ),
            Center(
                child: Text(
              'Add a profile photo',
              style: FontTextStyle.kWhite24BoldRoboto,
            )),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.1, vertical: Get.height * 0.03),
              child: Text(
                  'This photo will be used inside this app and also on the forums site.',
                  textAlign: TextAlign.center,
                  style: FontTextStyle.kWhite17BoldRoboto),
            ),
            SizedBox(
              height: Get.height * 0.08,
            ),
            Center(
              child: Stack(
                children: [
                  widget.image == null
                      ? CircleAvatar(
                          radius: 120,
                          backgroundColor: Color(0xff363636),
                          child: ClipRRect(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(120),
                                  border: Border.all(color: Colors.grey),
                                  color: Color(0xff363636),
                                  image: DecorationImage(
                                    image:
                                        AssetImage('asset/images/profile.png'),
                                  )),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 120,
                          backgroundColor: Color(0xff363636),
                          child: ClipRRect(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(120),
                                  border: Border.all(color: Colors.grey),
                                  color: Color(0xff363636),
                                  image: DecorationImage(
                                    image: FileImage(widget.image!),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                        ),
                  Positioned(
                    top: 180,
                    left: 160,
                    child: FlatButton(
                      onPressed: () async {
                        pickImage().then((value) => Get.to(ProfileSizer(
                              image: _image,
                            )));
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: ColorUtils.kTint,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                  color: Color(0xff363636),
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.26,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: GestureDetector(
                onTap: () {
                  Get.to(ExperienceLevelPage());
                },
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorUtils.kTint),
                  child: Center(
                      child: Text(
                    'Next',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 17),
                  )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ProfileSizer extends StatefulWidget {
  final File? image;
  const ProfileSizer({Key? key, this.image}) : super(key: key);

  @override
  _ProfileSizerState createState() => _ProfileSizerState();
}

class _ProfileSizerState extends State<ProfileSizer> {
  final cropKey = GlobalKey<CropState>();
  File? image;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.kBlack,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(
              height: Get.height * 0.01,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: ColorUtils.kTint,
                    )),
                Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.22),
                  child: Text(
                    'Position and Size',
                    style: FontTextStyle.kWhite17BoldRoboto,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.01),
                  child: InkWell(
                    onTap: () {},
                    child: Text('Skip', style: FontTextStyle.kTine16W400Roboto),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Crop.file(widget.image!, key: cropKey),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: GestureDetector(
                onTap: () {
                  _cropImage().then((value) => Get.to(SetProfilePage(
                        image: image,
                      )));
                },
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorUtils.kTint),
                  child: Center(
                      child: Text(
                    'Next',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 17),
                  )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }
    final sample = await ImageCrop.sampleImage(
      file: widget.image!,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );
    image = file;
    sample.delete();
    debugPrint('image======${image}');
  }
}
