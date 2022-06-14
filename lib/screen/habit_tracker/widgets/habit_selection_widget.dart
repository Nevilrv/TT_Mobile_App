import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';

Padding commonSelectionButton({
  String? name,
  List? habitList,
  Function()? onTap,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: Get.width * .06, vertical: Get.height * .015),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * .065,
        width: Get.width,
        decoration: habitList!.contains(name)
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(Get.height * .05),
                gradient: LinearGradient(
                    colors: ColorUtilsGradient.kTintGradient,
                    begin: Alignment.center,
                    end: Alignment.center))
            : BoxDecoration(
                borderRadius: BorderRadius.circular(Get.height * .05),
                border: Border.all(color: ColorUtils.kTint),
                color: ColorUtils.kBlack),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              habitList.contains(name)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 10, height: 10),
                        Text(
                          name!,
                          style: habitList.contains(name)
                              ? FontTextStyle.kBlack20BoldRoboto
                              : FontTextStyle.kTint20BoldRoboto,
                        ),
                        CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.done,
                              size: 12.5,
                              color: ColorUtils.kTint,
                            ))
                      ],
                    )
                  : Center(
                      child: Text(
                        name!,
                        style: habitList.contains(name)
                            ? FontTextStyle.kBlack20BoldRoboto
                            : FontTextStyle.kTint20BoldRoboto,
                      ),
                    ),
            ]),
      ),
    ),
  );
}
