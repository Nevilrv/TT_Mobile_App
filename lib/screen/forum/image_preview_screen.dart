import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/utils/ColorUtils.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File? image;
  const ImagePreviewScreen({Key? key, this.image}) : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
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
        ),
        body: Image.file(
          widget.image!,
          width: Get.width,
          height: Get.height,
          fit: BoxFit.contain,
        ));
  }
}
