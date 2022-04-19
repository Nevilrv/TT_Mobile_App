import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm_mobile_app/screen/set_profile_page.dart';

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'forget_pw_screen.dart';

class SingInScreen extends StatefulWidget {
  const SingInScreen({Key? key}) : super(key: key);

  @override
  _SingInScreenState createState() => _SingInScreenState();
}

class _SingInScreenState extends State<SingInScreen> {
  bool selected = false;
  TextEditingController pass = TextEditingController();
  TextEditingController userName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    padding: EdgeInsets.only(left: Get.width * 0.3),
                    child: Text(
                      'Login',
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
              Text(
                'Username',
                style: FontTextStyle.kGrey18BoldRoboto,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              textField(
                text: 'username',
                controller: userName,
                readOnly: false,
                validation: (value) {
                  if (value!.trim().isEmpty) {
                    return 'This field is required';
                  } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
                    return 'please enter valid name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Text(
                'Password',
                style: FontTextStyle.kGrey18BoldRoboto,
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              TextFormField(
                  obscureText: selected ? false : true,
                  controller: pass,
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                height: Get.height * 0.04,
              ),
              InkWell(
                onTap: () {
                  Get.to(ForgotPasswordScreen());
                },
                child: Text(
                  'Forgot your password?',
                  style: FontTextStyle.kTine17BoldRoboto,
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: GestureDetector(
                  onTap: () {
                    Get.to(SetProfilePage());
                  },
                  child: Container(
                    height: Get.height * 0.06,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ColorUtils.kTint),
                    child: Center(
                        child: Text(
                      'Sign In',
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
      ),
    );
  }

  Widget textField(
      {TextEditingController? controller,
      bool? readOnly,
      String? text,
      String? Function(String?)? validation}) {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      validator: validation!,
      readOnly: readOnly!,
      onTap: () {},
      controller: controller,
      decoration: InputDecoration(
          hintText: text,
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

  bool isPasswordValid(String password) => password.length <= 8;
}
