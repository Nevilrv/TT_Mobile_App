import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/edit_profile_request_model.dart';
import 'package:tcm/model/response_model/edit_profile_response_model.dart';
import 'package:tcm/preference_manager/prefrence_store.dart';
import 'package:tcm/screen/edit_password.dart';
import 'package:tcm/screen/profile_view_screen.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/edit_profile_viewModel.dart';
import 'package:dio/dio.dart' as dio;

import '../model/response_model/user_detail_response_model.dart';
import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  Data? userDetails;
  final File? image;

  EditProfilePage({
    Key? key,
    required this.userDetails,
    this.image,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

const String MIN_DATETIME = '2019-05-15 20:10:55';
const String MAX_DATETIME = '2019-07-01 12:30:40';
const String INIT_DATETIME = '2019-05-16 09:00:58';
const String DATE_FORMAT = 'yyyy-MM-dd,H时:m分';

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  ImagePicker? picker = ImagePicker();

  final _formKeyEditProfile = GlobalKey<FormState>();
  int? index = 2;
  DateTime? pickedDate;
  DateTime? prefDOB;
  int? isRadioButton = 1;
  bool selected = false;
  TextEditingController? email;
  TextEditingController? userName;
  TextEditingController? fName;
  TextEditingController? lName;
  TextEditingController? weight;

  EditProfileViewModel _editProfileViewModel = Get.put(EditProfileViewModel());

  bool loader = false;
  String? emailValidate;

  bool isEmailEmpty = false;
  bool isNotValidEmail = false;

  bool isPassEmpty = false;
  bool isUserNameEmpty = false;
  bool isNotValidPass = false;
  bool isNotValidUserName = false;

  String? msg;

  Future pickImage() async {
    final pickedFile = await picker!.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);

      if (_image != null) {}
    });
  }

  initState() {
    super.initState();
    email = TextEditingController(text: PreferenceManager.getEmail());
    userName = TextEditingController(text: PreferenceManager.getUserName());
    fName = TextEditingController(text: PreferenceManager.getFirstName());
    lName = TextEditingController(text: PreferenceManager.getLastName());
    weight = TextEditingController(text: PreferenceManager.getWeight());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileViewModel>(builder: (controller) {
      if (controller.apiResponse.status == Status.LOADING) {
        return Center(
          child: CircularProgressIndicator(color: ColorUtils.kTint),
        );
      }
      prefDOB = DateTime.parse(PreferenceManager.getDOB());
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
          title: Text('My Profile', style: FontTextStyle.kWhite16BoldRoboto),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: [
            SizedBox(
              height: Get.height * .02,
            ),
            Center(
              child: Stack(
                children: [
                  widget.image == null
                      ? CircleAvatar(
                          radius: 80,
                          backgroundColor: Color(0xff363636),
                          child: ClipRRect(
                            child: Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120),
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                color: Color(0xff363636),
                              ),
                              child: PreferenceManager.getProfilePic() == ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(120),
                                      child: Image.asset(
                                        AppImages.logo,
                                        scale: 2,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(120),
                                      child: Image.network(
                                        PreferenceManager.getProfilePic(),
                                        fit: BoxFit.fill,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: ColorUtils.kTint,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 80,
                          backgroundColor: Color(0xff363636),
                          child: ClipRRect(
                            child: Container(
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(120),
                                  border:
                                      Border.all(color: Colors.white, width: 4),
                                  color: Color(0xff363636),
                                  image: DecorationImage(
                                    image: FileImage(widget.image!),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                        ),
                  Positioned(
                    top: 110,
                    left: 90,
                    child: FlatButton(
                      onPressed: () async {
                        pickImage().then((value) => Get.to(ProfileSizer(
                              image: _image,
                              id: PreferenceManager.getUId(),
                            )));
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: ColorUtils.kTint,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.add,
                            color: ColorUtils.kBlack,
                            size: Get.height * .045,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * .01,
            ),
            Text(
              '${PreferenceManager.getUserName() ?? widget.userDetails!.name}',
              style: FontTextStyle.kWhite24BoldRoboto,
            ),
            Form(
              key: _formKeyEditProfile,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          )),
                          SizedBox(
                            width: Get.width * 0.05,
                          ),
                          Expanded(
                              child: textField(
                            readOnly: false,
                            text: 'Last Name',
                            controller: lName,
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
                            // validator: (email) {
                            //   if (isEmailValid(email!)) {
                            //     return '';
                            //   }
                            // },
                            // onTap: () {
                            //   setState(() {
                            //     isNotValidEmail = false;
                            //   });
                            // },
                            keyboardType: TextInputType.emailAddress,
                            // initialValue: PreferenceManager.getEmail(),

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
                                borderRadius: BorderRadius.circular(8),
                                // borderSide: BorderSide.none
                                borderSide: !isEmailEmpty && !isNotValidEmail
                                    ? BorderSide.none
                                    : BorderSide(color: Colors.red, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  // borderSide: BorderSide.none
                                  borderSide: !isEmailEmpty && !isNotValidEmail
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: Colors.red, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  // borderSide: BorderSide.none
                                  borderSide: !isEmailEmpty && !isNotValidEmail
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: Colors.red, width: 2)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                          isNotValidEmail
                              ? Text('\t\t\tPlease enter valid Email',
                                  style: TextStyle(
                                      fontSize: 12, color: ColorUtils.kRed))
                              : SizedBox(),
                        ],
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
                              minTime: DateTime(1980, 1, 1),
                              maxTime: DateTime(2025, 12, 30),
                              onConfirm: (date) {
                                setState(() {
                                  pickedDate = date;
                                });
                              },
                              currentTime: prefDOB,
                            );
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: 48,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: Color(0xff363636),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  pickedDate == null
                                      ? '${DateFormat.yMMMMd().format(prefDOB!)}'
                                      : '${DateFormat.yMMMMd().format(pickedDate!)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: Get.height * 0.018),
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
                            // validator: (value) {
                            //   if (!RegExp('[a-zA-Z]').hasMatch(value!)) {
                            //     setState(() {
                            //       isNotValidUserName = true;
                            //     });
                            //     return '';
                            //   }
                            // },
                            onTap: () {
                              setState(() {
                                isNotValidUserName = false;
                              });
                            },
                            // initialValue: PreferenceManager.getUserName(),
                            keyboardType: TextInputType.text,
                            controller: userName,
                            decoration: InputDecoration(
                              hintText: 'Edit your Username',
                              hintStyle: TextStyle(
                                  color: ColorUtils.kHintTextGray,
                                  fontSize: Get.height * 0.02,
                                  fontWeight: FontWeight.w500),
                              filled: true,
                              errorStyle: TextStyle(fontSize: 0),
                              contentPadding: EdgeInsets.all(10),
                              fillColor: Color(0xff363636),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                // borderSide: BorderSide.none
                                borderSide: !isNotValidUserName
                                    ? BorderSide.none
                                    : BorderSide(color: Colors.red, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  // borderSide: BorderSide.none
                                  borderSide: !isNotValidUserName
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: Colors.red, width: 2)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  // borderSide: BorderSide.none
                                  borderSide: !isNotValidUserName
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: Colors.red, width: 2)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                          isNotValidUserName
                              ? Text('\t\t\tPlease enter valid Username',
                                  style: TextStyle(
                                      fontSize: 12, color: ColorUtils.kRed))
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weight',
                            style: FontTextStyle.kGreyBoldRoboto,
                          ),
                          SizedBox(
                            height: Get.height * .01,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 40,
                                width: Get.height * .18,
                                child: TextFormField(
                                  onTap: () {},
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: Get.height * 0.018),
                                  controller: weight,
                                  // initialValue: PreferenceManager.getWeight(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    hintStyle: TextStyle(
                                        color: ColorUtils.kHintTextGray,
                                        fontSize: Get.height * 0.02,
                                        fontWeight: FontWeight.w500),
                                    hintText: 'Weight',
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: Get.height * .01,
                                        horizontal: Get.height * .011),
                                    fillColor: Color(0xff363636),
                                    suffixIcon: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('lbs',
                                            textAlign: TextAlign.center,
                                            style:
                                                FontTextStyle.kGreyBoldRoboto),
                                      ],
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * .03,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(EditPasswordPage());

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
                                borderRadius: BorderRadius.circular(50),
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
                      SizedBox(
                        height: Get.height * .03,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                        child: GestureDetector(
                          onTap: () async {
                            if (_formKeyEditProfile.currentState!.validate()) {
                              EditProfileRequestModel _request =
                                  EditProfileRequestModel();

                              _request.userId = PreferenceManager.getUId();
                              _request.fname = fName!.text.isEmpty
                                  ? PreferenceManager.getFirstName()
                                  : fName!.text;
                              _request.lname = lName!.text.isEmpty
                                  ? PreferenceManager.getLastName()
                                  : lName!.text;
                              _request.email = email!.text.isEmpty
                                  ? PreferenceManager.getEmail()
                                  : email!.text;
                              _request.username = userName!.text.isEmpty
                                  ? PreferenceManager.getUserName()
                                  : userName!.text;
                              _request.birthday = pickedDate == null
                                  ? PreferenceManager.getDOB()
                                  : pickedDate.toString();
                              _request.weight = weight!.text.isEmpty
                                  ? PreferenceManager.getWeight()
                                  : weight!.text;

                              await controller.editProfileViewModel(_request);

                              if (controller.apiResponse.status ==
                                  Status.COMPLETE) {
                                EditProfileResponseModel response =
                                    controller.apiResponse.data;

                                if (response.data != null ||
                                    response.data != []) {
                                  if (response.success == true &&
                                      response.data != null) {
                                    Get.showSnackbar(GetSnackBar(
                                      message: '${response.msg}',
                                      duration: Duration(seconds: 1),
                                    ));

                                    PreferenceManager.setEmail(
                                        response.data![0].email!);
                                    PreferenceManager.setFirstName(
                                        response.data![0].fname!);
                                    PreferenceManager.setLastName(
                                        response.data![0].lname!);
                                    PreferenceManager.setPassword(
                                        response.data![0].password!);
                                    PreferenceManager.setUserName(
                                        response.data![0].username!);
                                    PreferenceManager.setUId(
                                        response.data![0].id!);
                                    PreferenceManager.setWeight(
                                        response.data![0].weight!);
                                    PreferenceManager.setDOB(
                                        response.data![0].birthday!.toString());

                                    PreferenceManager.isSetLogin(true);

                                    if (widget.image != null) {
                                      Map<String, dynamic> data = {
                                        'user_id': PreferenceManager.getUId(),
                                        'profile_pic':
                                            await dio.MultipartFile.fromFile(
                                                widget.image!.path),
                                      };

                                      Map<String, String> header = {
                                        'content-type': 'application/json'
                                      };

                                      dio.FormData formData =
                                          dio.FormData.fromMap(data);

                                      dio.Response result = await dio.Dio().post(
                                          'https://tcm.sataware.dev//json/data_user_profile.php',
                                          data: formData,
                                          options:
                                              dio.Options(headers: header));
                                      Map<String, dynamic> dataa = result.data;

                                      PreferenceManager.setProfilePic(
                                          dataa['data'][0]['profile_pic']);
                                    }
                                    Get.off(ProfileViewScreen(
                                      userDetails: null,
                                    ));
                                  } else {
                                    Get.showSnackbar(GetSnackBar(
                                      message: response.msg,
                                      duration: Duration(seconds: 2),
                                    ));
                                  }
                                }
                              } else {
                                CircularProgressIndicator(
                                  color: ColorUtils.kTint,
                                );
                              }
                            } else {
                              CircularProgressIndicator(
                                color: ColorUtils.kTint,
                              );
                            }
                          },
                          child: Container(
                            height: Get.height * 0.06,
                            width: Get.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ColorUtils.kTint),
                            child: Center(
                                child: Text(
                              'Update Profile',
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

class ProfileSizer extends StatefulWidget {
  final File? image;
  final String? id;

  const ProfileSizer({
    Key? key,
    this.image,
    this.id,
  }) : super(key: key);

  @override
  _ProfileSizerState createState() => _ProfileSizerState();
}

class _ProfileSizerState extends State<ProfileSizer> {
  EditProfileViewModel _editProfileViewModel = Get.put(EditProfileViewModel());

  final cropKey = GlobalKey<CropState>();
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onTap: () {
                    Get.back();
                  },
                  child: Text('Skip', style: FontTextStyle.kTine16W400Roboto),
                ),
              ),
            ],
          ),
          Expanded(
            child: Crop.file(widget.image!, key: cropKey),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
            child: GestureDetector(
              onTap: () {
                _cropImage().then((value) => Get.off(EditProfilePage(
                      userDetails: null,
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
  }
}
