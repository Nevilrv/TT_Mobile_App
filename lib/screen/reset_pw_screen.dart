import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool selected = false;
  TextEditingController newPass = TextEditingController();
  TextEditingController rePass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    'Reset Password',
                    style: FontTextStyle.kWhite17BoldRoboto,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.1,
            ),
            Center(
              child: SizedBox(
                height: Get.height * 0.2,
                width: Get.width * 0.37,
                child: Image.asset('asset/images/logo.png'),
              ),
            ),
            SizedBox(
              height: Get.height * 0.06,
            ),
            Text(
              'New Password',
              style: FontTextStyle.kGrey18BoldRoboto,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            TextFormField(
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Get.height * 0.018),
                obscureText: selected ? false : true,
                controller: newPass,
                decoration: InputDecoration(
                  hintText: 'Enter new Password',
                  hintStyle: TextStyle(
                      color: ColorUtils.kHintTextGray,
                      fontSize: Get.height * 0.02,
                      fontWeight: FontWeight.w500),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Color(0xff363636),
                  suffixIcon: IconButton(
                    icon: Icon(
                      selected == false
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: selected ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        selected = !selected;
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (password) {
                  if (password!.isEmpty) {
                    return 'Please enter password';
                  } else if (!isPasswordValid(password)) {
                    return 'Enter a valid password';
                  }
                  return null;
                }),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Text(
              'Confirm Password',
              style: FontTextStyle.kGrey18BoldRoboto,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            TextFormField(
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Get.height * 0.018),
                obscureText: selected ? false : true,
                controller: rePass,
                decoration: InputDecoration(
                  hintText: 'Enter Confirm Password',
                  hintStyle: TextStyle(
                      color: ColorUtils.kHintTextGray,
                      fontSize: Get.height * 0.02,
                      fontWeight: FontWeight.w500),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                  fillColor: Color(0xff363636),
                  suffixIcon: IconButton(
                    icon: Icon(
                      selected == false
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: selected ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        selected = !selected;
                      });
                    },
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (password) {
                  if (password!.isEmpty) {
                    return 'Please enter password';
                  } else if (!isPasswordValid(password)) {
                    return 'Enter a valid password';
                  }
                  return null;
                }),
            SizedBox(
              height: Get.height * 0.08,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: Get.height * 0.06,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        colors: ColorUtilsGradient.kTintGradient,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: ColorUtils.kTint),
                  child: Center(
                      child: Text(
                    'Reset Password',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: Get.height * 0.02),
                  )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  bool isPasswordValid(String password) => password.length <= 8;
}
