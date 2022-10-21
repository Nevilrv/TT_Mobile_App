import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/set_profile_page.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';

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
  int? index = 2;
  DateTime? pickedDate;
  int? isRadioButton = 1;
  bool selected = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController weight = TextEditingController();
  final _formKeySignUp = GlobalKey<FormState>();
  bool loader = false;
  String? emailValidate;

  bool isEmailEmpty = false;
  bool isNotValidEmail = false;

  bool isPassEmpty = false;
  bool isUserNameEmpty = false;
  bool isNotValidPass = false;
  bool isNotValidUserName = false;

  String? msg;
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  @override
  void initState() {
    _connectivityCheckViewModel.startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(
      builder: (control) => control.isOnline
          ? Scaffold(
              backgroundColor: ColorUtils.kBlack,
              // appBar: PreferredSize(
              //   preferredSize: Size.fromHeight(Get.height * 0.2),
              //   child: AppBar(
              //     elevation: 0,
              //     leading: IconButton(
              //         onPressed: () {
              //           Get.back();
              //         },
              //         icon: Icon(
              //           Icons.arrow_back_ios_sharp,
              //           color: ColorUtils.kTint,
              //         )),
              //     backgroundColor: ColorUtils.kBlack,
              //     centerTitle: true,
              //     flexibleSpace: Padding(
              //       padding: EdgeInsets.only(top: Get.height * .05),
              //       child: SizedBox(
              //         height: Get.height * 0.2,
              //         width: Get.width * 0.37,
              //         child: Image.asset('asset/images/logo.png',
              //             scale: 1.4, alignment: Alignment.topCenter),
              //       ),
              //     ),
              //   ),
              // ),
              body: loader == true
                  ? Center(
                      child: CircularProgressIndicator(
                      color: ColorUtils.kTint,
                    ))
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: _formKeySignUp,
                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: Get.height * .05, right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Icon(
                                          Icons.arrow_back_ios_sharp,
                                          color: ColorUtils.kTint,
                                          size: 20,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.2,
                                  width: Get.width * 0.37,
                                  child: Image.asset('asset/images/logo.png'),
                                ),
                                SizedBox(height: 40, width: 40)
                              ],
                            ),
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
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: [0.0, 1.0],
                                              colors: ColorUtilsGradient
                                                  .kTintGradient,
                                            ),
                                            color: ColorUtils.kTint)
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: ColorUtils.kTint)),
                                    child: Center(
                                        child: Text(
                                      '\$50 / Monthly',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: index == 1
                                              ? Colors.black
                                              : ColorUtils.kTint,
                                          fontSize: Get.height * 0.023),
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
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: [0.0, 1.0],
                                              colors: ColorUtilsGradient
                                                  .kTintGradient,
                                            ),
                                            color: ColorUtils.kTint)
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: ColorUtils.kTint)),
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
                                              fontSize: Get.height * 0.023),
                                        ),
                                        Text(
                                          'Save \$400 a year',
                                          style: TextStyle(
                                              color: index == 2
                                                  ? Colors.black
                                                  : ColorUtils.kTint,
                                              fontSize: Get.height * 0.015),
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
                                            style:
                                                FontTextStyle.kGreyBoldRoboto)),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: textField(
                                      readOnly: false,
                                      text: 'First Name',
                                      controller: fName,
                                      // validation: (value) {
                                      //   if (value!.trim().isEmpty) {
                                      //     return 'This field is required';
                                      //   } else if (!RegExp('[a-zA-Z]')
                                      //       .hasMatch(value)) {
                                      //     return 'please enter valid name';
                                      //   }
                                      //   return null;
                                      // },
                                    )),
                                    SizedBox(
                                      width: Get.width * 0.05,
                                    ),
                                    Expanded(
                                        child: textField(
                                      readOnly: false,
                                      text: 'Last Name',
                                      controller: lName,
                                      // validation: (value) {
                                      //   if (value!.trim().isEmpty) {
                                      //     return 'This field is required';
                                      //   } else if (!RegExp('[a-zA-Z]')
                                      //       .hasMatch(value)) {
                                      //     return 'please enter valid name';
                                      //   }
                                      //   return null;
                                      // },
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email address',
                                      style: FontTextStyle.kGreyBoldRoboto,
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.01,
                                    ),
                                    TextFormField(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: Get.height * 0.018),
                                      validator: (email) {
                                        if (isEmailValid(email!)) {
                                          return null;
                                        } else {
                                          setState(() {
                                            isEmailEmpty = true;
                                          });
                                          return '';
                                        }
                                      },
                                      onTap: () {
                                        setState(() {
                                          isEmailEmpty = false;
                                          isNotValidEmail = false;
                                        });
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      controller: email,
                                      decoration: InputDecoration(
                                        hintText: 'user@user.com',
                                        hintStyle: TextStyle(
                                            color: ColorUtils.kHintTextGray,
                                            fontSize: Get.height * 0.02,
                                            fontWeight: FontWeight.w500),
                                        filled: true,
                                        errorStyle: TextStyle(fontSize: 0),
                                        contentPadding: EdgeInsets.all(10),
                                        fillColor: Color(0xff363636),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // borderSide: BorderSide.none
                                          borderSide:
                                              !isEmailEmpty && !isNotValidEmail
                                                  ? BorderSide.none
                                                  : BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            // borderSide: BorderSide.none
                                            borderSide: !isEmailEmpty &&
                                                    !isNotValidEmail
                                                ? BorderSide.none
                                                : BorderSide(
                                                    color: Colors.red,
                                                    width: 2)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            // borderSide: BorderSide.none
                                            borderSide: !isEmailEmpty &&
                                                    !isNotValidEmail
                                                ? BorderSide.none
                                                : BorderSide(
                                                    color: Colors.red,
                                                    width: 2)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                    isEmailEmpty
                                        ? Text('   Please enter your email',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ColorUtils.kRed))
                                        : SizedBox(),
                                    isNotValidEmail
                                        ? Text('   Please enter valid Email',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ColorUtils.kRed))
                                        : SizedBox(),
                                  ],
                                ),

                                // textFieldWithValidation(
                                //   readOnly: false,
                                //   text: 'user@user.com',
                                //   controller: email,
                                //   keyboardType: TextInputType.emailAddress,
                                //   validation: (email) {
                                //     if (isEmailValid(email!)) {
                                //       setState(() {
                                //         isEmailEmpty = true;
                                //       });
                                //       return null;
                                //     } else {
                                //       setState(() {
                                //         isNotValidEmail = true;
                                //       });
                                //       return 'Enter a valid email address';
                                //     }
                                //   },
                                // ),
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
                                            cancelStyle:
                                                FontTextStyle.kTine16W400Roboto,
                                            doneStyle:
                                                FontTextStyle.kTine16W400Roboto,
                                            itemStyle: FontTextStyle
                                                .kWhite16W300Roboto),
                                        showTitleActions: true,
                                        minTime: DateTime(1980, 1, 1),
                                        maxTime: DateTime(2025, 12, 30),
                                        onChanged: (date) {
                                          print('change $date');
                                        },
                                        onConfirm: (date) {
                                          setState(() {
                                            pickedDate = date;
                                          });
                                          print('confirm $date');
                                          print('pickedDate $pickedDate');
                                        },
                                        currentTime: DateTime.utc(2000),
                                      );
                                    },
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: 48,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            color: Color(0xff363636),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            pickedDate == null
                                                ? '${DateFormat.yMMMMd().format(DateTime.utc(2000))}'
                                                : '${DateFormat.yMMMMd().format(pickedDate!)}',
                                            style: pickedDate == null
                                                ? TextStyle(
                                                    color: ColorUtils
                                                        .kHintTextGray,
                                                    fontSize: Get.height * 0.02,
                                                    fontWeight: FontWeight.w500)
                                                : TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize:
                                                        Get.height * 0.018),
                                          ),
                                        ))),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Username',
                                      style: FontTextStyle.kGreyBoldRoboto,
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.01,
                                    ),
                                    TextFormField(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: Get.height * .018),
                                      validator: (value) {
                                        if (value!.trim().isEmpty) {
                                          setState(() {
                                            isUserNameEmpty = true;
                                          });
                                          return '';
                                        } else if (!RegExp('[a-zA-Z]')
                                            .hasMatch(value)) {
                                          setState(() {
                                            isNotValidUserName = true;
                                          });
                                          return '';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        setState(() {
                                          isNotValidUserName = false;
                                          isUserNameEmpty = false;
                                        });
                                      },
                                      keyboardType: TextInputType.text,
                                      controller: userName,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your Username',
                                        hintStyle: TextStyle(
                                            color: ColorUtils.kHintTextGray,
                                            fontSize: Get.height * 0.02,
                                            fontWeight: FontWeight.w500),
                                        filled: true,
                                        errorStyle: TextStyle(fontSize: 0),
                                        contentPadding: EdgeInsets.all(10),
                                        fillColor: Color(0xff363636),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // borderSide: BorderSide.none
                                          borderSide: !isUserNameEmpty &&
                                                  !isNotValidUserName
                                              ? BorderSide.none
                                              : BorderSide(
                                                  color: Colors.red, width: 2),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            // borderSide: BorderSide.none
                                            borderSide: !isUserNameEmpty &&
                                                    !isNotValidUserName
                                                ? BorderSide.none
                                                : BorderSide(
                                                    color: Colors.red,
                                                    width: 2)),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            // borderSide: BorderSide.none
                                            borderSide: !isUserNameEmpty &&
                                                    !isNotValidUserName
                                                ? BorderSide.none
                                                : BorderSide(
                                                    color: Colors.red,
                                                    width: 2)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                    isUserNameEmpty
                                        ? Text('   Please enter your Username',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ColorUtils.kRed))
                                        : SizedBox(),
                                    isNotValidUserName
                                        ? Text('   Please enter valid Username',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ColorUtils.kRed))
                                        : SizedBox(),
                                  ],
                                ),

                                // textFieldWithValidation(
                                //   text: 'username',
                                //   controller: userName,
                                //   readOnly: false,
                                //   validation: (value) {
                                //     if (value!.trim().isEmpty) {
                                //       return 'This field is required';
                                //     } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
                                //       return 'please enter valid name';
                                //     }
                                //     return null;
                                //   },
                                // ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password',
                                      style: FontTextStyle.kGreyBoldRoboto,
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
                                        controller: pass,
                                        onTap: () {
                                          setState(() {
                                            isNotValidPass = false;
                                            isPassEmpty = false;
                                          });
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                              color: ColorUtils.kHintTextGray,
                                              fontSize: Get.height * 0.02,
                                              fontWeight: FontWeight.w500),
                                          hintText: 'Password',
                                          filled: true,
                                          errorStyle: TextStyle(fontSize: 0),
                                          contentPadding: EdgeInsets.all(10),
                                          fillColor: Color(0xff363636),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              selected == false
                                                  ? Icons.remove_red_eye
                                                  : Icons
                                                      .remove_red_eye_outlined,
                                              color: selected
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                selected = !selected;
                                              });
                                            },
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            // borderSide: BorderSide.none
                                            borderSide:
                                                !isPassEmpty && !isNotValidPass
                                                    ? BorderSide.none
                                                    : BorderSide(
                                                        color: Colors.red,
                                                        width: 2),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // borderSide: BorderSide.none
                                              borderSide: !isPassEmpty &&
                                                      !isNotValidPass
                                                  ? BorderSide.none
                                                  : BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // borderSide: BorderSide.none
                                              borderSide: !isPassEmpty &&
                                                      !isNotValidPass
                                                  ? BorderSide.none
                                                  : BorderSide(
                                                      color: Colors.red,
                                                      width: 2)),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide.none),
                                        ),
                                        validator: (password) {
                                          if (password!.isEmpty) {
                                            setState(() {
                                              isPassEmpty = true;
                                            });
                                            return '';
                                          } else if (!isPasswordValid(
                                              password)) {
                                            setState(() {
                                              isNotValidPass = true;
                                            });
                                            return '';
                                          }
                                          return null;
                                        }),
                                    isPassEmpty
                                        ? Text('   Please enter your Password',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ColorUtils.kRed))
                                        : SizedBox(),
                                    isNotValidPass
                                        ? Text('   Please enter valid Password',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: ColorUtils.kRed))
                                        : SizedBox(),
                                  ],
                                ),

                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Gender',
                                            style:
                                                FontTextStyle.kGreyBoldRoboto,
                                          ),
                                          SizedBox(
                                            height: Get.height * .025,
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
                                                            height: 20,
                                                            width: 20,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        5),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              border: Border.all(
                                                                  width: 5,
                                                                  color:
                                                                      ColorUtils
                                                                          .kTint),
                                                            ))
                                                        : Container(
                                                            height: 20,
                                                            width: 20,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color:
                                                                      ColorUtils
                                                                          .kTint),
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: Get.width * .02,
                                                    ),
                                                    Text(
                                                      'Male',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: Get.height *
                                                              0.016),
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
                                                            height: 20,
                                                            width: 20,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        5),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              border: Border.all(
                                                                  width: 5,
                                                                  color:
                                                                      ColorUtils
                                                                          .kTint),
                                                            ))
                                                        : Container(
                                                            height: 20,
                                                            width: 20,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color:
                                                                      ColorUtils
                                                                          .kTint),
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: Get.width * .02,
                                                    ),
                                                    Text(
                                                      'Female',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: Get.height *
                                                              0.016),
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Weight',
                                          style: FontTextStyle.kGreyBoldRoboto,
                                        ),
                                        SizedBox(
                                          height: Get.height * .01,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              width: Get.height * .18,
                                              child: TextFormField(
                                                // onTap: () {
                                                //   setState(() {
                                                //     isNotNumeric = false;
                                                //     isEmpty = false;
                                                //   });
                                                // },
                                                onTap: () {},
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize:
                                                        Get.height * 0.018),
                                                controller: weight,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  alignLabelWithHint: true,
                                                  hintStyle: TextStyle(
                                                      color: ColorUtils
                                                          .kHintTextGray,
                                                      fontSize:
                                                          Get.height * 0.02,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  hintText: 'Weight',
                                                  filled: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical:
                                                              Get.height * .01,
                                                          horizontal:
                                                              Get.height *
                                                                  .011),
                                                  fillColor: Color(0xff363636),
                                                  suffixIcon: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('lbs',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: FontTextStyle
                                                              .kGreyBoldRoboto),
                                                    ],
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          BorderSide.none
                                                      // !isEmpty && !isNotNumeric
                                                      //     ? BorderSide.none
                                                      //     : BorderSide(
                                                      //         color: Colors.red,
                                                      //         width: 2),
                                                      ),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      borderSide:
                                                          BorderSide.none
                                                      // !isEmpty && !isNotNumeric
                                                      //     ? BorderSide.none
                                                      //     : BorderSide(
                                                      //         color: Colors.red,
                                                      //         width: 2)
                                                      ),
                                                  // focusedErrorBorder:
                                                  //     OutlineInputBorder(
                                                  //   borderRadius:
                                                  //       BorderRadius.circular(8),
                                                  //   borderSide: BorderSide(
                                                  //       color: Colors.red, width: 2),
                                                  // ),
                                                  // errorBorder: OutlineInputBorder(
                                                  //   borderRadius:
                                                  //       BorderRadius.circular(8),
                                                  //   borderSide: BorderSide(
                                                  //       color: Colors.red, width: 2),
                                                  // ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: Get.height * .008,
                                            // ),
                                            // isEmpty
                                            //     ? Text(
                                            //         '   Please enter your weight',
                                            //         style: TextStyle(
                                            //             fontSize: 12,
                                            //             color: ColorUtils.kRed))
                                            //     : SizedBox(),
                                            // isNotNumeric
                                            //     ? Text(
                                            //         '   Please enter valid weight',
                                            //         style: TextStyle(
                                            //             fontSize: 12,
                                            //             color: ColorUtils.kRed))
                                            //     : SizedBox(),
                                          ],
                                        ),
                                      ],
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'By creating an account you agree to our',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Get.height * 0.016,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Roboto'),
                                          textAlign: TextAlign.center,
                                        ),
                                        InkWell(
                                          child: Text(
                                            ' Privacy Policy ',
                                            style: TextStyle(
                                              color: ColorUtils.kTint,
                                              fontSize: Get.height * 0.0175,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('and',
                                            style: FontTextStyle
                                                .kWhite16W300Roboto),
                                        InkWell(
                                          child: Text(' Terms of Use.',
                                              style: FontTextStyle
                                                  .kTine16W400Roboto,
                                              textAlign: TextAlign.center),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                                SizedBox(
                                  height: Get.height * .03,
                                ),
                                // GetBuilder<RegisterViewModel>(
                                //   builder: (controller) {
                                //     if (controller.apiResponse.status == Status.LOADING) {
                                //       return Center(
                                //           child: CircularProgressIndicator(
                                //         color: ColorUtils.kTint,
                                //       ));
                                //     }
                                //     return Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           horizontal: Get.width * 0.05),
                                //       child: GestureDetector(
                                //         onTap: () async {
                                //           if (_formKey.currentState!.validate()) {
                                //             RegisterRequestModel _request =
                                //                 RegisterRequestModel();
                                //
                                //             _request.fname = fName.text;
                                //             _request.lname = lName.text;
                                //             _request.email = email.text;
                                //             _request.password = pass.text;
                                //             _request.username = userName.text;
                                //             _request.gender =
                                //                 isRadioButton == 1 ? 'Male' : 'Female';
                                //             _request.phone = '9638527410';
                                //             _request.dob = pickedDate.toString();
                                //             _request.weight = '204';
                                //             _request.experienceLevel = 'intermidiate';
                                //
                                //             await _registerViewModel
                                //                 .registerViewModel(_request);
                                //
                                //             if (_registerViewModel.apiResponse.status ==
                                //                 Status.COMPLETE) {
                                //               RegisterResponseModel response =
                                //                   _registerViewModel.apiResponse.data;
                                //
                                //               if (response.success == true) {
                                //                 Get.showSnackbar(GetSnackBar(
                                //                   message: 'Register Done',
                                //                   duration: Duration(seconds: 2),
                                //                 ));
                                //
                                //                 Get.to(SetProfilePage());
                                //               }
                                //             }
                                //           }
                                //         },
                                //         child: Container(
                                //           height: Get.height * 0.06,
                                //           width: Get.width * 0.9,
                                //           decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.circular(50),
                                //               color: ColorUtils.kTint),
                                //           child: Center(
                                //               child: Text(
                                //             'Start 7-Day Free Trial',
                                //             style: TextStyle(
                                //                 fontWeight: FontWeight.bold,
                                //                 color: Colors.black,
                                //                 fontSize: Get.height * 0.02),
                                //           )),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // )

                                // GetBuilder<RegisterViewModel>(
                                //   builder: (controller) {
                                //     // if (controller.apiResponse.status ==
                                //     //     Status.LOADING) {
                                //     //   return Center(
                                //     //       child: CircularProgressIndicator(
                                //     //     color: ColorUtils.kTint,
                                //     //   ));
                                //     // }
                                //     return

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_formKeySignUp.currentState!
                                          .validate()) {
                                        Get.to(SetProfilePage(
                                          fname: fName.text,
                                          lname: lName.text,
                                          email: email.text.trim(),
                                          pass: pass.text.trim(),
                                          userName: userName.text,
                                          gender: isRadioButton == 1
                                              ? 'Male'
                                              : 'Female',
                                          phone: '9638527410',
                                          weight: weight.text,
                                          dob: pickedDate.toString(),
                                        ));
                                      } else {
                                        Get.showSnackbar(GetSnackBar(
                                          message:
                                              'Please check your credentials',
                                          duration: Duration(seconds: 1),
                                        ));
                                      }
                                    },
                                    child: Container(
                                      height: Get.height * 0.06,
                                      width: Get.width * 0.9,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.0, 1.0],
                                            colors: ColorUtilsGradient
                                                .kTintGradient,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: ColorUtils.kTint),
                                      child: Center(
                                          child: Text(
                                        'Start 7-Day Free Trial',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: Get.height * 0.02),
                                      )),
                                    ),
                                  ),
                                  // child: GestureDetector(
                                  //   onTap: () async {
                                  //     setState(() {
                                  //       loader = true;
                                  //     });
                                  //     if (_formKey.currentState!.validate()) {
                                  //       RegisterRequestModel _request =
                                  //           RegisterRequestModel();
                                  //
                                  //       _request.fname = fName.text;
                                  //       _request.lname = lName.text;
                                  //       _request.email = email.text.trim();
                                  //       _request.password = pass.text.trim();
                                  //       _request.username = userName.text;
                                  //       _request.gender =
                                  //           isRadioButton == 1 ? 'Male' : 'Female';
                                  //       _request.phone = '9638527410';
                                  //       _request.dob = pickedDate.toString();
                                  //       _request.weight = weight.text.trim();
                                  //       _request.experienceLevel = 'intermidiate';
                                  //
                                  //       await _registerViewModel
                                  //           .registerViewModel(_request);
                                  //
                                  //       if (_registerViewModel.apiResponse.status ==
                                  //           Status.COMPLETE) {
                                  //         RegisterResponseModel response =
                                  //             _registerViewModel.apiResponse.data;
                                  //
                                  //         if (response.data != null ||
                                  //             response.data != '') {
                                  //           Get.showSnackbar(GetSnackBar(
                                  //             message: 'Register Done',
                                  //             duration: Duration(seconds: 1),
                                  //           ));
                                  //
                                  //           if (response.success == true &&
                                  //               response.data != null) {
                                  //             PreferenceManager.setEmail(
                                  //                 response.data!.email!);
                                  //             PreferenceManager.setPassword(
                                  //                 response.data!.password!);
                                  //             PreferenceManager.setName(
                                  //                 response.data!.username!);
                                  //             PreferenceManager.setUId(
                                  //                 response.data!.id!);
                                  //             PreferenceManager.setWeight(
                                  //                 response.data!.weight!);
                                  //             PreferenceManager.setPhoneNumber(
                                  //                 response.data!.phone!);
                                  //             PreferenceManager.setUserType(
                                  //                 response.data!.gender!);
                                  //             PreferenceManager.isSetLogin(true);
                                  //
                                  //             print(
                                  //                 'response.data!.id!=========== ${response.data!.id!}');
                                  //             print(
                                  //                 'EMAIL ${PreferenceManager.getEmail()}');
                                  //             Get.to(SetProfilePage(
                                  //               id: response.data!.id,
                                  //             ));
                                  //           } else if (response.msg == null ||
                                  //               response.msg == "" &&
                                  //                   response.data == null ||
                                  //               response.data == "") {
                                  //             setState(() {
                                  //               loader = false;
                                  //             });
                                  //             SizedBox();
                                  //           }
                                  //           setState(() {
                                  //             loader = false;
                                  //           });
                                  //         }
                                  //       } else if (controller.apiResponse.status ==
                                  //           Status.ERROR) {
                                  //         setState(() {
                                  //           loader = false;
                                  //         });
                                  //         Get.showSnackbar(GetSnackBar(
                                  //           message:
                                  //               'Please check your credentials',
                                  //           duration: Duration(seconds: 1),
                                  //         ));
                                  //       } else {
                                  //         Get.showSnackbar(GetSnackBar(
                                  //           message: 'Email already exists',
                                  //           duration: Duration(seconds: 1),
                                  //         ));
                                  //         setState(() {
                                  //           loader = false;
                                  //         });
                                  //       }
                                  //     } else {
                                  //       setState(() {
                                  //         loader = false;
                                  //       });
                                  //       Get.showSnackbar(GetSnackBar(
                                  //         message: 'Please check your credentials',
                                  //         duration: Duration(seconds: 1),
                                  //       ));
                                  //     }
                                  //   },
                                  //   child: Container(
                                  //     height: Get.height * 0.06,
                                  //     width: Get.width * 0.9,
                                  //     decoration: BoxDecoration(
                                  //         borderRadius: BorderRadius.circular(50),
                                  //         color: ColorUtils.kTint),
                                  //     child: Center(
                                  //         child: Text(
                                  //       'Start 7-Day Free Trial',
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.bold,
                                  //           color: Colors.black,
                                  //           fontSize: Get.height * 0.02),
                                  //     )),
                                  //   ),
                                  // ),
                                  //   );
                                  // },
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                        ]),
                      ),
                    ),
            )
          : ConnectionCheckScreen(),
    );
  }
  //
  // Widget textFieldWithValidation(
  //     {TextEditingController? controller,
  //     bool? readOnly,
  //     String? text,
  //     TextInputType? keyboardType,
  //     String? Function(String?)? validation}) {
  //   if (keyboardType == null) {
  //     keyboardType = TextInputType.text;
  //   }
  //   return TextFormField(
  //     style: TextStyle(
  //         fontWeight: FontWeight.bold,
  //         color: Colors.white,
  //         fontSize: Get.height * 0.018),
  //     validator: validation!,
  //     keyboardType: keyboardType,
  //     readOnly: readOnly!,
  //     controller: controller,
  //     decoration: InputDecoration(
  //         hintText: text,
  //         hintStyle: TextStyle(
  //             color: ColorUtils.kHintTextGray,
  //             fontSize: Get.height * 0.02,
  //             fontWeight: FontWeight.w500),
  //         filled: true,
  //         contentPadding: EdgeInsets.all(10),
  //         fillColor: Color(0xff363636),
  //         focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             borderSide: BorderSide.none),
  //         enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             borderSide: BorderSide.none),
  //         focusedErrorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8),
  //           borderSide: BorderSide.none,
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(8),
  //           borderSide: BorderSide(color: Colors.red, width: 2),
  //         )),
  //   );
  // }

  Widget textField(
      {TextEditingController? controller,
      bool? readOnly,
      String? text,
      TextInputType? keyboardType}) {
    if (keyboardType == null) {
      keyboardType = TextInputType.text;
    }
    return TextFormField(
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: Get.height * 0.018),
      keyboardType: keyboardType,
      readOnly: readOnly!,
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
      ),
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

  bool isPasswordValid(String password) => password.length >= 8;
  bool isEmailValid(String email) {
    Pattern? pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
