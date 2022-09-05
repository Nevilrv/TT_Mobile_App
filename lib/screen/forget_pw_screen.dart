import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/reset_pw_screen.dart';
import '../utils/ColorUtils.dart';

import '../utils/font_styles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();

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
                  padding: EdgeInsets.only(left: Get.width * 0.2),
                  child: Text(
                    'Forgot Your Password?',
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
              height: Get.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Forgot your password? Don’t worry about it. Simply put in the email address you used to register and we’ll send you a reset link.',
                textAlign: TextAlign.center,
                style: FontTextStyle.kWhite16W300Roboto,
              ),
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            Text(
              'Email address',
              style: FontTextStyle.kGrey18BoldRoboto,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            textField(
              readOnly: false,
              text: 'user@user.com',
              controller: email,
              validation: (email) {
                if (isEmailValid(email!))
                  return null;
                else
                  return 'Enter a valid email address';
              },
            ),
            SizedBox(
              height: Get.height * 0.06,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: GestureDetector(
                onTap: () {
                  Get.to(ResetPasswordScreen());
                },
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
                    'Get Reset Link',
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

  bool isEmailValid(String email) {
    Pattern? pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  Widget textField(
      {TextEditingController? controller,
      bool? readOnly,
      String? text,
      String? Function(String?)? validation}) {
    return TextFormField(
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: Get.height * 0.018),
      validator: validation!,
      readOnly: readOnly!,
      keyboardType: TextInputType.emailAddress,
      onTap: () {},
      controller: controller,
      decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(
              color: ColorUtils.kHintTextGray,
              fontSize: Get.height * 0.02,
              fontWeight: FontWeight.w500),
          filled: true,
          contentPadding: EdgeInsets.all(10),
          fillColor: Color(0xff363636),
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
          )),
    );
  }
}
