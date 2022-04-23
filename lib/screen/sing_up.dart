import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'singIn_screens.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

const String MIN_DATETIME = '2019-05-15 20:10:55';
const String MAX_DATETIME = '2019-07-01 12:30:40';
const String INIT_DATETIME = '2019-05-16 09:00:58';
const String DATE_FORMAT = 'yyyy-MM-dd,H时:m分';

class _SignUpScreenState extends State<SignUpScreen> {
  int? index = 0;
  DateTime? pickedDate;
  int? isRadioButton = 0;
  bool selected = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: Get.height * 0.1),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: ColorUtils.kTint,
                      )),
                ),

                SizedBox(
                  height: Get.height * 0.2,
                  width: Get.width * 0.37,
                  child: Image.asset('asset/images/logo.png'),
                ),
                SizedBox( )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign up below to get a free 7-day trial. Choose a payment method below that will automatically start after your free trial ends.',
                    textAlign: TextAlign.center,
                    style: FontTextStyle.kWhite16W300Roboto,
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Container(
                      height: Get.height * 0.07,
                      width: Get.width * 0.9,
                      decoration: index == 1
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ColorUtils.kTint)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: ColorUtils.kTint)),
                      child: Center(
                          child: Text(
                        '\$50 / Monthly',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: index == 1 ? Colors.black : ColorUtils.kTint,
                            fontSize: Get.height*0.023),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Container(
                      height: Get.height * 0.07,
                      width: Get.width * 0.9,
                      decoration: index == 2
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ColorUtils.kTint)
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: ColorUtils.kTint)),
                      child: Center(
                          child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.009,
                          ),
                          Text(
                            '\$200 / Yearly',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: index == 2
                                    ? Colors.black
                                    : ColorUtils.kTint,
                                fontSize: Get.height*0.023),
                          ),
                          Text(
                            'Save \$400 a year',
                            style: TextStyle(
                                color: index == 2
                                    ? Colors.black
                                    : ColorUtils.kTint,
                                fontSize: Get.height*0.015),
                          ),
                        ],
                      )),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'First name',
                          style: FontTextStyle.kGreyBoldRoboto,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.05,
                      ),
                      Expanded(
                          child: Text('Last name',
                              style: FontTextStyle.kGreyBoldRoboto)),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: textField(
                        readOnly: false,
                        text: 'First Name',
                        controller: fName,
                        validation: (value) {
                          if (value!.trim().isEmpty) {
                            return 'This field is required';
                          } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
                            return 'please enter valid name';
                          }
                          return null;
                        },
                      )),
                      SizedBox(
                        width: Get.width * 0.05,
                      ),
                      Expanded(
                          child: textField(
                        readOnly: false,
                        text: 'Last Name',
                        controller: lName,
                        validation: (value) {
                          if (value!.trim().isEmpty) {
                            return 'This field is required';
                          } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
                            return 'please enter valid name';
                          }
                          return null;
                        },
                      )),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Text(
                    'Email address',
                    style: FontTextStyle.kGreyBoldRoboto,
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  textField(
                    readOnly: false,
                    text: 'abc@gmail.com',
                    controller: email,
                    validation: (email) {
                      if (isEmailValid(email!))
                        return null;
                      else
                        return 'Enter a valid email address';
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Text(
                    'Date of Birth',
                    style: FontTextStyle.kGreyBoldRoboto,
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          theme: DatePickerTheme(
                              backgroundColor: ColorUtils.kBlack,
                              cancelStyle: FontTextStyle.kTine16W400Roboto,
                              doneStyle: FontTextStyle.kTine16W400Roboto,
                              itemStyle: FontTextStyle.kWhite16W300Roboto),
                          showTitleActions: true,
                          minTime: DateTime(2000, 1, 1),
                          maxTime: DateTime(2025, 12, 30),
                          onChanged: (date) {
                            print('change $date');
                          },
                          onConfirm: (date) {
                            setState(() {
                              pickedDate = date;
                            });
                            print('confirm $date');
                          },
                          currentTime: DateTime.now(),
                        );
                      },
                      child: Container(
                          height: Get.height * .06,
                          width: Get.width * 0.99,
                          decoration: BoxDecoration(
                              color: Color(0xff363636),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              pickedDate == null
                                  ? 'December 19,2022'
                                  : '${DateFormat.yMMMMd().format(pickedDate!)}',
                              style: pickedDate == null
                                  ?
                              TextStyle(fontSize: Get.height*0.02,fontWeight: FontWeight.w500)
                                  : TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white,fontSize: Get.height*0.018),
                            ),
                          ))),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Text(
                    'Username',
                    style: FontTextStyle.kGreyBoldRoboto,
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
                    height: Get.height * 0.01,
                  ),
                  Text(
                    'Password',
                    style: FontTextStyle.kGreyBoldRoboto,
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  TextFormField(
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: Get.height*0.018),

                      obscureText: selected ? false : true,
                      controller: pass,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: Get.height*0.02,fontWeight: FontWeight.w500),
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
                    height: Get.height * 0.01,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: FontTextStyle.kGreyBoldRoboto,
                            ),
                            SizedBox(
                              height: Get.height * .02,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isRadioButton = 1;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      isRadioButton == 1
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 6,
                                                    color: ColorUtils.kTint),
                                              ))
                                          : Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 1,
                                                    color: ColorUtils.kTint),
                                              ),
                                            ),
                                      SizedBox(
                                        width: Get.width * .02,
                                      ),
                                      Text(
                                        'Male',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: Get.height*0.016
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * .05,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isRadioButton = 2;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      isRadioButton == 2
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 6,
                                                    color: ColorUtils.kTint),
                                              ))
                                          : Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 1,
                                                    color: ColorUtils.kTint),
                                              ),
                                            ),
                                      SizedBox(
                                        width: Get.width * .02,
                                      ),
                                      Text(
                                        'Female',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: Get.height*0.016
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * .02,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weight',
                              style: FontTextStyle.kGreyBoldRoboto,
                            ),
                            SizedBox(
                              height: Get.height * .01,
                            ),
                            Container(
                              width: Get.width * 0.46,
                              height: Get.height * .05,
                              decoration: BoxDecoration(
                                  color: Color(0xff363636),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('204',
                                        style:
                                            FontTextStyle.kWhite17W400Roboto),
                                    Text(
                                      'lbs',
                                      style: FontTextStyle.kGreyBoldRoboto,
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * .03,
                  ),
                  Container(
                    width: Get.width,
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'By creating an account you agree to our',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.height*0.016,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Roboto'),
                            textAlign: TextAlign.center,
                          ),
                          InkWell(
                            child: Text(
                              ' Privacy Policy ',
                              style:TextStyle(
                                color: ColorUtils.kTint,
                                fontSize: Get.height * 0.018,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text('and', style: FontTextStyle.kWhite16W300Roboto),
                          InkWell(
                            child: Text(' Terms of Use.',
                                style: FontTextStyle.kTine16W400Roboto,
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: Get.height * .03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(SingInScreen());
                      },
                      child: Container(
                        height: Get.height * 0.06,
                        width: Get.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorUtils.kTint),
                        child: Center(
                            child: Text(
                          'Start 7-Day Free Trial',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: Get.height*0.02),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
          ]),
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
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: Get.height*0.018),

      validator: validation!,
      readOnly: readOnly!,
      onTap: () {},
      controller: controller,
      decoration: InputDecoration(
          hintText: text,
          hintStyle: TextStyle(fontSize: Get.height*0.02,fontWeight: FontWeight.w500),
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

  Widget customRadioButton(String? text, Decoration? decoration) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: isRadioButton == 2
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 5, color: ColorUtils.kTint),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1, color: ColorUtils.kTint),
                ),
        ),
        SizedBox(
          width: Get.width * .02,
        ),
        Text(
          text!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  bool isPasswordValid(String password) => password.length <= 8;
  bool isEmailValid(String email) {
    Pattern? pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
