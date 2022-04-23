import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title: Text('My Profile', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: InkWell(
              onTap: () {},
              child: Text('Edit', style: FontTextStyle.kTine16W400Roboto),
            ),
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 70,
        ),
        Center(
          child: CircleAvatar(
            radius: 80,
            backgroundColor: Color(0xff363636),
            child: ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(120),
                    border: Border.all(color: Colors.white, width: 4),
                    color: Color(0xff363636),
                    image: DecorationImage(
                      image: AssetImage('asset/images/pick.png'),
                      fit: BoxFit.fill,
                    )),
              ),
            ),
          ),
        ),
        SizedBox(
          height: Get.height * .01,
        ),
        Text(
          'ShreddedLee',
          style: FontTextStyle.kWhite24BoldRoboto,
        ),
      ]),
    );
  }
}
