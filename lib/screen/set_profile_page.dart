import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'package:tcm/preference_manager/prefrence_store.dart';
import 'package:tcm/utils/images.dart';
import 'dart:async';
import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'experience_level.dart';

class SetProfilePage extends StatefulWidget {
  final String? id;
  final String? id1;
  String? fname;
  String? lname;
  final String? email;
  final String? pass;
  final String? userName;
  final String? gender;
  final String? phone;
  String? dob;
  String? weight;
  final File? image;
  SetProfilePage(
      {Key? key,
      this.image,
      this.id1,
      this.id,
      this.fname,
      this.lname,
      this.email,
      this.pass,
      this.userName,
      this.gender,
      this.phone,
      this.dob,
      this.weight})
      : super(key: key);

  @override
  _SetProfilePageState createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  File? _image;
  ImagePicker? picker = ImagePicker();
  bool loader = false;

  Future pickImage() async {
    final pickedFile = await picker!.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);

      if (_image != null) {}
    });
  }

  String? data;
  @override
  void initState() {
    super.initState();

    if (widget.fname!.isEmpty) {
      widget.fname = 'john';
    }
    if (widget.lname!.isEmpty) {
      widget.lname = 'doe';
    }
    print('date');

    if (widget.dob!.isEmpty) {
      print('date');
      widget.dob = '2000-1-1 00:00:00.000';
    }
    if (widget.weight!.isEmpty) {
      widget.weight = '100';
    }
    print('name---- ======== ${widget.fname}');
    print('name---- ======== ${widget.lname}');
    print('name---- ======== ${widget.email}');
    print('name---- ======== ${widget.pass}');
    print('name---- ======== ${widget.userName}');
    print('name---- ======== ${widget.gender}');
    print('name---- ======== ${widget.phone}');
    print('dob---- ======== ${widget.dob}');
    print('name---- ======== ${widget.weight}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title: Text('Profile Photo', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.5),
            child: TextButton(
                onPressed: () async {
                  Get.to(ExperienceLevelPage(
                      skippedImage: AppImages.logo,
                      fname: widget.fname,
                      lname: widget.lname,
                      email: widget.email,
                      pass: widget.pass,
                      userName: widget.userName,
                      gender: widget.gender,
                      phone: widget.phone,
                      weight: widget.weight,
                      dob: widget.dob ?? '2000-1-1 00:00:00.000'));
                  PreferenceManager.setProfilePic('');
                },
                child: Text(
                  'Skip',
                  style: FontTextStyle.kTine16W400Roboto,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                    image: AssetImage(AppIcons.profile),
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
                        pickImage().then((value) => Get.off(ProfileSizer(
                              image: _image,
                              id: widget.id,
                              fname: widget.fname,
                              lname: widget.lname,
                              email: widget.email,
                              pass: widget.pass,
                              userName: widget.userName,
                              gender: widget.gender,
                              phone: widget.phone,
                              weight: widget.weight,
                              dob: widget.dob ?? '2000-1-1 00:00:00.000',
                            )));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: ColorUtils.kTint,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.add,
                            color: ColorUtils.kBlack,
                            size: Get.height * .06,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.1,
            ),
            loader == true
                ? Center(
                    child: CircularProgressIndicator(
                    color: ColorUtils.kTint,
                  ))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: GestureDetector(
                      onTap: () {
                        if (widget.image == "https://tcm.sataware.dev" ||
                            widget.image == null) {
                          Get.showSnackbar(GetSnackBar(
                            message: 'please select image',
                            duration: Duration(seconds: 1),
                          ));
                        } else {
                          print("sent name==${widget.fname}");
                          print("sent name==${widget.lname}");
                          Get.to(ExperienceLevelPage(
                            fname: widget.fname,
                            lname: widget.lname,
                            email: widget.email,
                            pass: widget.pass,
                            userName: widget.userName,
                            gender: widget.gender,
                            phone: widget.phone,
                            weight: widget.weight,
                            dob: widget.dob!.isEmpty
                                ? '2000-1-1 00:00:00.000'
                                : widget.dob,
                            image: widget.image,
                          ));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        alignment: Alignment.center,
                        height: Get.height * 0.06,
                        width: Get.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorUtils.kTint),
                        child: Text(
                          'Next',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: Get.height * 0.02),
                        ),
                      ),
                    ),
                    // child: GestureDetector(
                    //   onTap: () async {
                    //     setState(() {
                    //       loader = true;
                    //     });
                    //     if (widget.image == "https://tcm.sataware.dev" ||
                    //         widget.image == null) {
                    //       Get.showSnackbar(GetSnackBar(
                    //         message: 'please select image',
                    //         duration: Duration(seconds: 1),
                    //       ));
                    //     } else {
                    //       Map<String, dynamic> data = {
                    //         'user_id': widget.id1,
                    //         'profile_pic': await dio.MultipartFile.fromFile(
                    //             widget.image!.path),
                    //       };
                    //
                    //       Map<String, String> header = {
                    //         'content-type': 'application/json'
                    //       };
                    //
                    //       dio.FormData formData = dio.FormData.fromMap(data);
                    //
                    //       dio.Response result = await dio.Dio().post(
                    //           'https://tcm.sataware.dev//json/data_user_profile.php',
                    //           data: formData,
                    //           options: dio.Options(headers: header));
                    //
                    //       if (result.data['success'] == true) {
                    //         Get.showSnackbar(GetSnackBar(
                    //           message: 'Add Profile Successfully',
                    //           duration: Duration(seconds: 1),
                    //         ));
                    //
                    //         Get.off(ExperienceLevelPage());
                    //       } else {
                    //         Center(
                    //             child: CircularProgressIndicator(
                    //           color: ColorUtils.kTint,
                    //         ));
                    //       }
                    //     }
                    //     // print('IMAGE UPLOAD ${widget.image!.path}');
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.only(bottom: 15),
                    //     alignment: Alignment.center,
                    //     height: Get.height * 0.06,
                    //     width: Get.width * 0.9,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(50),
                    //         color: ColorUtils.kTint),
                    //     child: Text(
                    //       'Next',
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           color: Colors.black,
                    //           fontSize: Get.height * 0.02),
                    //     ),
                    //   ),
                    // ),
                  ),
          ]),
        ),
      ),
    );
  }

  // Future<String> uploadImage(File file) async {
  //   String fileName = file.path.split('/').last;
  //   FormData formData = FormData.fromMap({
  //     "file": await MultipartFile.fromFile(file.path, filename: fileName),
  //   });
  //   response = await dio.post("/info", data: formData);
  //   return response.data['id'];
  // }
}

class ProfileSizer extends StatefulWidget {
  final File? image;
  final String? id;

  final String? fname;
  final String? lname;
  final String? email;
  final String? pass;
  final String? userName;
  final String? gender;
  final String? phone;
  final String? dob;
  final String? weight;

  const ProfileSizer(
      {Key? key,
      this.image,
      this.id,
      this.fname,
      this.lname,
      this.email,
      this.pass,
      this.userName,
      this.gender,
      this.phone,
      this.dob,
      this.weight})
      : super(key: key);

  @override
  _ProfileSizerState createState() => _ProfileSizerState();
}

class _ProfileSizerState extends State<ProfileSizer> {
  final cropKey = GlobalKey<CropState>();
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title:
            Text('Position and Size', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Get.off(SetProfilePage(
                  image: image,
                  fname: widget.fname,
                  lname: widget.lname,
                  email: widget.email,
                  pass: widget.pass,
                  userName: widget.userName,
                  gender: widget.gender,
                  phone: widget.phone,
                  weight: widget.weight,
                  dob: widget.dob ?? '2000-1-1 00:00:00.000',
                ));
              },
              child: Text(
                'Skip',
                style: FontTextStyle.kTine16W400Roboto,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: Get.height * 0.01,
          ),
          Expanded(
            child: Crop.file(widget.image!, key: cropKey),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: GestureDetector(
              onTap: () {
                print('id====++${widget.id}');
                _cropImage().then((value) => Get.off(SetProfilePage(
                      image: image,
                      fname: widget.fname,
                      lname: widget.lname,
                      email: widget.email,
                      pass: widget.pass,
                      userName: widget.userName,
                      gender: widget.gender,
                      phone: widget.phone,
                      weight: widget.weight,
                      dob: widget.dob ?? '2000-1-1 00:00:00.000',
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
    debugPrint('image======${image!.path}');
  }
}
