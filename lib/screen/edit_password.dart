import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/edit_pass_request_model.dart';
import 'package:tcm/model/response_model/edit_pass_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/profile_view_screen.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/edit_pass_viewModel.dart';
import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';

class EditPasswordPage extends StatefulWidget {
  EditPasswordPage({Key? key}) : super(key: key);

  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _formKeyEditPassword = GlobalKey<FormState>();

  TextEditingController currentPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmNewPass = TextEditingController();

  bool isCurrentPassEmpty = false;
  bool isCurrentNotValidPass = false;
  bool isNewPassEmpty = false;
  bool isNewPassNotValid = false;
  bool isConfirmPassEmpty = false;
  bool isConfirmPassNotValid = false;
  bool selected = false;
  bool selectedNew = false;
  bool selectedCNew = false;
  String? msg;

  EditPassViewModel _editPassViewModel = Get.put(EditPassViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  @override
  void initState() {
    _connectivityCheckViewModel.startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool loader = false;

    return GetBuilder<EditPassViewModel>(builder: (controller) {
      if (controller.apiResponse.status == Status.LOADING) {
        return Center(
          child: CircularProgressIndicator(color: ColorUtils.kTint),
        );
      }
      return GetBuilder<ConnectivityCheckViewModel>(
        builder: (control) => control.isOnline
            ? Scaffold(
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
                  title: Text('Update Password',
                      style: FontTextStyle.kWhite16BoldRoboto),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Column(children: [
                    Form(
                      key: _formKeyEditPassword,
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.03,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Password',
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
                                          controller: currentPass,
                                          onTap: () {
                                            setState(() {
                                              isCurrentNotValidPass = false;
                                              isCurrentPassEmpty = false;
                                            });
                                          },
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: ColorUtils.kHintTextGray,
                                                fontSize: Get.height * 0.02,
                                                fontWeight: FontWeight.w500),
                                            hintText: 'Current Password',
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
                                              borderSide: !isCurrentPassEmpty &&
                                                      !isCurrentNotValidPass
                                                  ? BorderSide.none
                                                  : BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: !isCurrentPassEmpty &&
                                                        !isCurrentNotValidPass
                                                    ? BorderSide.none
                                                    : BorderSide(
                                                        color: Colors.red,
                                                        width: 2)),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: !isCurrentPassEmpty &&
                                                        !isCurrentNotValidPass
                                                    ? BorderSide.none
                                                    : BorderSide(
                                                        color: Colors.red,
                                                        width: 2)),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        BorderSide.none),
                                          ),
                                          validator: (password) {
                                            if (password!.isEmpty) {
                                              setState(() {
                                                isCurrentPassEmpty = true;
                                              });
                                              return '';
                                            } else if (!isPasswordValid(
                                                password)) {
                                              setState(() {
                                                isCurrentNotValidPass = true;
                                              });
                                              return '';
                                            }
                                            return null;
                                          }),
                                      isCurrentPassEmpty
                                          ? Text(
                                              '   Please enter your Current Password',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: ColorUtils.kRed))
                                          : SizedBox(),
                                      isCurrentNotValidPass
                                          ? Text(
                                              '   Please enter valid Current Password',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: ColorUtils.kRed))
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'New Password',
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
                                          obscureText:
                                              selectedNew ? false : true,
                                          controller: newPass,
                                          onTap: () {
                                            setState(() {
                                              isNewPassNotValid = false;
                                              isNewPassEmpty = false;
                                            });
                                          },
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: ColorUtils.kHintTextGray,
                                                fontSize: Get.height * 0.02,
                                                fontWeight: FontWeight.w500),
                                            hintText: 'New Password',
                                            filled: true,
                                            errorStyle: TextStyle(fontSize: 0),
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: Color(0xff363636),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                selectedNew == false
                                                    ? Icons.remove_red_eye
                                                    : Icons
                                                        .remove_red_eye_outlined,
                                                color: selectedNew
                                                    ? Colors.black
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedNew = !selectedNew;
                                                });
                                              },
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: !isNewPassEmpty &&
                                                      !isNewPassNotValid
                                                  ? BorderSide.none
                                                  : BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: !isNewPassEmpty &&
                                                        !isNewPassNotValid
                                                    ? BorderSide.none
                                                    : BorderSide(
                                                        color: Colors.red,
                                                        width: 2)),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: !isNewPassEmpty &&
                                                        !isNewPassNotValid
                                                    ? BorderSide.none
                                                    : BorderSide(
                                                        color: Colors.red,
                                                        width: 2)),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        BorderSide.none),
                                          ),
                                          validator: (password) {
                                            if (password!.isEmpty) {
                                              setState(() {
                                                isNewPassEmpty = true;
                                              });
                                              return '';
                                            } else if (!isPasswordValid(
                                                password)) {
                                              setState(() {
                                                isNewPassNotValid = true;
                                              });
                                              return '';
                                            }
                                            return null;
                                          }),
                                      isNewPassEmpty
                                          ? Text(
                                              '   Please enter your New Password',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: ColorUtils.kRed))
                                          : SizedBox(),
                                      isNewPassNotValid
                                          ? Text(
                                              '   Please enter valid New Password',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: ColorUtils.kRed))
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Confirm New Password',
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
                                          obscureText:
                                              selectedCNew ? false : true,
                                          controller: confirmNewPass,
                                          onTap: () {
                                            setState(() {
                                              isConfirmPassNotValid = false;
                                              isConfirmPassEmpty = false;
                                            });
                                          },
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: ColorUtils.kHintTextGray,
                                                fontSize: Get.height * 0.02,
                                                fontWeight: FontWeight.w500),
                                            hintText: 'Confirm New Password',
                                            filled: true,
                                            errorStyle: TextStyle(fontSize: 0),
                                            contentPadding: EdgeInsets.all(10),
                                            fillColor: Color(0xff363636),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                selectedCNew == false
                                                    ? Icons.remove_red_eye
                                                    : Icons
                                                        .remove_red_eye_outlined,
                                                color: selectedCNew
                                                    ? Colors.black
                                                    : Colors.grey,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  selectedCNew = !selectedCNew;
                                                });
                                              },
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: !isConfirmPassEmpty &&
                                                      !isConfirmPassNotValid
                                                  ? BorderSide.none
                                                  : BorderSide(
                                                      color: Colors.red,
                                                      width: 2),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: !isConfirmPassEmpty &&
                                                        !isConfirmPassNotValid
                                                    ? BorderSide.none
                                                    : BorderSide(
                                                        color: Colors.red,
                                                        width: 2)),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: !isConfirmPassEmpty &&
                                                        !isConfirmPassNotValid
                                                    ? BorderSide.none
                                                    : BorderSide(
                                                        color: Colors.red,
                                                        width: 2)),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide:
                                                        BorderSide.none),
                                          ),
                                          validator: (password) {
                                            if (password!.isEmpty) {
                                              setState(() {
                                                isConfirmPassEmpty = true;
                                              });
                                              return '';
                                            } else if (!isPasswordValid(
                                                password)) {
                                              setState(() {
                                                isConfirmPassNotValid = true;
                                              });
                                              return '';
                                            }
                                            return null;
                                          }),
                                      isConfirmPassEmpty
                                          ? Text(
                                              '   Please enter your Confirm New Password',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: ColorUtils.kRed))
                                          : SizedBox(),
                                      isConfirmPassNotValid
                                          ? Text(
                                              '   Please enter valid Confirm New Password',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: ColorUtils.kRed))
                                          : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.05,
                                    vertical: Get.height * 0.1),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      loader = true;
                                    });
                                    if (_formKeyEditPassword.currentState!
                                        .validate()) {
                                      EditPassRequestModel _request =
                                          EditPassRequestModel();
                                      _request.userId =
                                          PreferenceManager.getUId();
                                      _request.currentPassword =
                                          currentPass.text.trim();
                                      _request.newPassword =
                                          newPass.text.trim();
                                      _request.confirmPassword =
                                          confirmNewPass.text.trim();

                                      await controller
                                          .editPassViewModel(_request);

                                      log('=====_signInViewModel.apiResponse.status===========${controller.apiResponse.status}');
                                      if (controller.apiResponse.status ==
                                          Status.COMPLETE) {
                                        EditPassResponseModel response =
                                            controller.apiResponse.data;
                                        log('================$loader');
                                        setState(() {
                                          loader = false;
                                        });
                                        log("============ res complete ${response.msg}");
                                        if (response.success == true &&
                                            response.msg != null) {
                                          log("============ res complete 123456 ${response.msg}");

                                          if (response.msg ==
                                              'New password and Confirm password  is not match!') {
                                            isConfirmPassNotValid = true;
                                            isNewPassNotValid = true;
                                            Get.showSnackbar(GetSnackBar(
                                              message: '${response.msg}',
                                              duration: Duration(seconds: 2),
                                            ));
                                          } else if (response.msg ==
                                              'Current password is wrong!') {
                                            isCurrentNotValidPass = true;
                                            Get.showSnackbar(GetSnackBar(
                                              message: '${response.msg}',
                                              duration: Duration(seconds: 2),
                                            ));
                                          } else {
                                            Get.showSnackbar(GetSnackBar(
                                              message: '${response.msg}',
                                              duration: Duration(seconds: 2),
                                            ));

                                            Get.off(ProfileViewScreen(
                                              userDetails: null,
                                            ));
                                          }
                                        } else if (response.msg == null ||
                                            response.msg == "") {
                                          setState(() {
                                            loader = false;
                                          });
                                          log("============ res null ${response.msg}");

                                          SizedBox();
                                        }
                                      } else if (controller
                                              .apiResponse.status ==
                                          Status.ERROR) {
                                        setState(() {
                                          loader = false;
                                        });
                                        Get.showSnackbar(GetSnackBar(
                                          message:
                                              'Please enter valid Password',
                                          duration: Duration(seconds: 2),
                                        ));
                                      }
                                    }
                                    //
                                    // Get.to(ProfileViewScreen(
                                    //   userDetails: null,
                                    // ));

                                    // if (_formKeyEditProfile.currentState!.validate()) {
                                    //   Get.to(SetProfilePage(
                                    //     fname: fName.text,
                                    //     lname: lName.text,
                                    //     email: email.text.trim(),
                                    //     pass: pass.text.trim(),
                                    //     userName: userName.text,
                                    //     gender: isRadioButton == 1 ? 'Male' : 'Female',
                                    //     phone: '9638527410',
                                    //     weight: weight.text,
                                    //     dob: pickedDate.toString(),
                                    //   ));
                                    // } else {
                                    //   Get.showSnackbar(GetSnackBar(
                                    //     message: 'Please check your credentials',
                                    //     duration: Duration(seconds: 1),
                                    //   ));
                                    // }
                                  },
                                  child: Container(
                                    height: Get.height * 0.06,
                                    width: Get.width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.0, 1.0],
                                        colors:
                                            ColorUtilsGradient.kTintGradient,
                                      ),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Update Password',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: Get.height * 0.02),
                                    )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                      ]),
                    ),
                  ]),
                ),
              )
            : ConnectionCheckScreen(),
      );
    });
  }

  Widget textField(
      {TextEditingController? controller,
      String? initialValue,
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
      initialValue: initialValue,
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

  bool isPasswordValid(String password) => password.length <= 8;
  bool isEmailValid(String email) {
    Pattern? pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
