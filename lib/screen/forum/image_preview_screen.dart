import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File? image;
  const ImagePreviewScreen({Key? key, this.image}) : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectivityCheckViewModel.startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
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
              ),
              body: Image.file(
                widget.image!,
                width: Get.width,
                height: Get.height,
                fit: BoxFit.contain,
              ))
          : ConnectionCheckScreen();
    });
  }
}
