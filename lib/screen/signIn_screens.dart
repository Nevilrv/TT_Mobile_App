import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/sign_in_request_model.dart';
import 'package:tcm/model/response_model/sign_in_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/sign_up.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/sign_in_viewModel.dart';

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'forget_pw_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool selected = false;
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();

  final _formKeyLogIn = GlobalKey<FormState>();
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  SignInViewModel _signInViewModel = Get.put(SignInViewModel());
  @override
  void initState() {
    _connectivityCheckViewModel.startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool loader = false;

    return GetBuilder<SignInViewModel>(
      builder: (controller) {
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
                    backgroundColor: ColorUtils.kBlack,
                    leading: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_sharp,
                          color: ColorUtils.kTint,
                        )),
                    centerTitle: true,
                    title: Text(
                      'Login',
                      style: FontTextStyle.kWhite17BoldRoboto,
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Form(
                      key: _formKeyLogIn,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                'Email',
                                style: FontTextStyle.kGrey18BoldRoboto,
                              ),
                              SizedBox(
                                height: Get.height * 0.01,
                              ),
                              textField(
                                readOnly: false,
                                text: 'user@user.com',
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                validation: (email) {
                                  if (isEmailValid(email!))
                                    return null;
                                  else
                                    return 'Enter a valid email address';
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
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: Get.height * 0.018),
                                  controller: pass,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
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
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 2),
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
                              // GetBuilder<SignInViewModel>(builder: (controller) {
                              //   if (controller.apiResponse.status == Status.LOADING) {
                              //     return Center(
                              //       child: CircularProgressIndicator(
                              //           color: ColorUtils.kTint),
                              //     );
                              //   }
                              //   return Padding(
                              //     padding:
                              //         EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                              //     child: GestureDetector(
                              //       onTap: () async {
                              //         if (_formKey.currentState!.validate()) {
                              //           SignInRequestModel _request =
                              //               SignInRequestModel();
                              //           _request.email = email.text;
                              //           _request.password = pass.text;
                              //
                              //           await _signInViewModel.signInViewModel(_request);
                              //           if (_signInViewModel.apiResponse.status ==
                              //               Status.COMPLETE) {
                              //             SignInResponseModel response =
                              //                 _signInViewModel.apiResponse.data;
                              //             if (response.success == true) {
                              //               PreferenceManager.setEmail(
                              //                   response.data![0].email!);
                              //               PreferenceManager.setPassword(
                              //                   response.data![0].password!);
                              //               PreferenceManager.setName(
                              //                   response.data![0].username!);
                              //               PreferenceManager.setUId(
                              //                   response.data![0].id!);
                              //               PreferenceManager.setPhoneNumber(
                              //                   response.data![0].phone!);
                              //               PreferenceManager.setUserType(
                              //                   response.data![0].gender!);
                              //               PreferenceManager.isSetLogin(true);
                              //               Get.showSnackbar(GetSnackBar(
                              //                 message: 'Login Successfully',
                              //                 duration: Duration(seconds: 2),
                              //               ));
                              //
                              //               print(
                              //                   'EMAIL ${PreferenceManager.getEmail()}');
                              //               Get.to(HomeScreen());
                              //             } else {
                              //               SizedBox();
                              //             }
                              //           } else {}
                              //         }
                              //       },
                              //       child: Container(
                              //         height: Get.height * 0.06,
                              //         width: Get.width * 0.9,
                              //         decoration: BoxDecoration(
                              //             borderRadius: BorderRadius.circular(50),
                              //             color: ColorUtils.kTint),
                              //         child: Center(
                              //             child: Text(
                              //           'Sign In',
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.bold,
                              //               color: Colors.black,
                              //               fontSize: Get.height * 0.02),
                              //         )),
                              //       ),
                              //     ),
                              //   );
                              // }),
                              loader == true
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      color: ColorUtils.kTint,
                                    ))
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.05),
                                      child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            loader = true;
                                          });
                                          if (_formKeyLogIn.currentState!
                                              .validate()) {
                                            SignInRequestModel _request =
                                                SignInRequestModel();
                                            _request.email = email.text.trim();
                                            _request.password =
                                                pass.text.trim();

                                            await controller
                                                .signInViewModel(_request);

                                            if (controller.apiResponse.status ==
                                                Status.COMPLETE) {
                                              SignInResponseModel response =
                                                  controller.apiResponse.data;

                                              setState(() {
                                                loader = false;
                                              });

                                              if (response.success == true &&
                                                  response.data != null) {
                                                PreferenceManager.setEmail(
                                                    response.data![0].email!);
                                                PreferenceManager.setPassword(
                                                    response
                                                        .data![0].password!);
                                                PreferenceManager.setUserName(
                                                    response
                                                        .data![0].username!);
                                                PreferenceManager.setFirstName(
                                                    response.data![0].fname!);
                                                PreferenceManager.setLastName(
                                                    response.data![0].lname!);
                                                PreferenceManager.setWeight(
                                                    response.data![0].weight!);
                                                PreferenceManager.setUId(
                                                    response.data![0].id!);
                                                PreferenceManager.setDOB(
                                                    response.data![0].birthday!
                                                        .toString());
                                                PreferenceManager.setProfilePic(
                                                    response.data![0]
                                                            .profilePic ??
                                                        '');

                                                PreferenceManager
                                                    .setPhoneNumber(response
                                                        .data![0].phone!);
                                                PreferenceManager.setUserType(
                                                    response.data![0].gender!);
                                                PreferenceManager.isSetLogin(
                                                    true);
                                                Get.showSnackbar(GetSnackBar(
                                                  message: 'Login Successfully',
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));

                                                Get.offAll(HomeScreen(
                                                  id: response.data![0].id!,
                                                ));
                                              } else if (response.msg == null ||
                                                  response.msg == "" &&
                                                      response.data == null ||
                                                  response.data == "") {
                                                setState(() {
                                                  loader = false;
                                                });
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
                                                    'Please enter valid Email or Password',
                                                duration: Duration(seconds: 2),
                                              ));
                                            }
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
                                            'Sign In',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: Get.height * 0.02),
                                          )),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: Get.height * 0.017,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Not a member?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: Get.height * 0.018),
                                  ),
                                  InkWell(
                                    child: Text(
                                      ' Sign Up',
                                      style: TextStyle(
                                        color: ColorUtils.kTint,
                                        fontSize: Get.height * 0.022,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(SignUpScreen());
                                    },
                                  )
                                ],
                              )
                            ]),
                      ),
                    ),
                  ),
                )
              : ConnectionCheckScreen(),
        );
      },
    );
  }

  Widget textField(
      {TextEditingController? controller,
      bool? readOnly,
      String? text,
      TextInputType? keyboardType,
      String? Function(String?)? validation}) {
    return TextFormField(
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: Get.height * 0.018),
      keyboardType: keyboardType,
      validator: validation!,
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

  bool isEmailValid(String email) {
    Pattern? pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }
}
