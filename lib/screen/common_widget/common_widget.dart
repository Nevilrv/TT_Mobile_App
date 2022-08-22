import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';

Padding commonNavigationButton({Function()? onTap, String? name}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.height * .02),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          height: Get.height * .065,
          width: Get.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                colors: ColorUtilsGradient.kTintGradient,
              ),
              borderRadius: BorderRadius.circular(6)),
          child: Text(
            name!,
            style: FontTextStyle.kBlack16BoldRoboto,
          )),
    ),
  );
}

Html htmlToText({String? data}) {
  return Html(
    data: data,
    style: {
      "p": Style(
          textAlign: TextAlign.justify,
          color: Colors.white,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "ol": Style(
          textAlign: TextAlign.justify,
          color: Colors.white,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "ul": Style(
          textAlign: TextAlign.justify,
          color: Colors.white,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "li": Style(
          textAlign: TextAlign.justify,
          color: Colors.white,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "strong": Style(
        textAlign: TextAlign.justify,
        color: Colors.white,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        fontFamily: 'Roboto',
      ),
      "a": Style(
        textAlign: TextAlign.justify,
        color: Colors.white,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        fontFamily: 'Roboto',
      ),
    },
  );
}

Html htmlToTextGrey({String? data}) {
  return Html(
    data: data,
    style: {
      "p": Style(
          textAlign: TextAlign.justify,
          color: ColorUtils.kLightGray,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "ol": Style(
          textAlign: TextAlign.justify,
          color: ColorUtils.kLightGray,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "ul": Style(
          textAlign: TextAlign.justify,
          color: ColorUtils.kLightGray,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "li": Style(
          textAlign: TextAlign.justify,
          color: ColorUtils.kLightGray,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
    },
  );
}

Html htmlToTextGreyVidDesc({String? data}) {
  return Html(
    data: data,
    style: {
      "p": Style(
          textAlign: TextAlign.justify,
          color: ColorUtils.kLightGray,
          fontSize: FontSize.small,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto',
          textOverflow: TextOverflow.clip,
          maxLines: 1),
      "ol": Style(
          textAlign: TextAlign.justify,
          color: ColorUtils.kLightGray,
          fontSize: FontSize.small,
          fontWeight: FontWeight.w300,
          textOverflow: TextOverflow.clip,
          fontFamily: 'Roboto',
          maxLines: 1),
      "ul": Style(
          textAlign: TextAlign.justify,
          color: ColorUtils.kLightGray,
          fontSize: FontSize.small,
          fontWeight: FontWeight.w300,
          textOverflow: TextOverflow.clip,
          fontFamily: 'Roboto',
          maxLines: 1),
      "li": Style(
        textAlign: TextAlign.justify,
        color: ColorUtils.kLightGray,
        fontSize: FontSize.small,
        fontWeight: FontWeight.w300,
        textOverflow: TextOverflow.clip,
        fontFamily: 'Roboto',
        maxLines: 1,
      ),
    },
  );
}

Html htmlToTextGoalSelected({String? data}) {
  return Html(
    data: data,
    style: {
      "p": Style(
        textAlign: TextAlign.justify,
        color: Colors.black,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        fontFamily: 'Roboto',
        textOverflow: TextOverflow.clip,
      ),
      "ol": Style(
        textAlign: TextAlign.justify,
        color: Colors.black,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        textOverflow: TextOverflow.clip,
        fontFamily: 'Roboto',
      ),
      "ul": Style(
        textAlign: TextAlign.justify,
        color: Colors.black,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        textOverflow: TextOverflow.clip,
        fontFamily: 'Roboto',
      ),
      "li": Style(
        textAlign: TextAlign.justify,
        color: Colors.black,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        textOverflow: TextOverflow.clip,
        fontFamily: 'Roboto',
      ),
      "strong": Style(
        textAlign: TextAlign.justify,
        color: Colors.black,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        textOverflow: TextOverflow.clip,
        fontFamily: 'Roboto',
      ),
    },
  );
}

ClipRRect noDataLottie() {
  return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Lottie.asset(AppImages.noData));
}

Html htmlToTextGoalUnselected({String? data}) {
  return Html(
    data: data,
    style: {
      "p": Style(
        textAlign: TextAlign.justify,
        color: Colors.white,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        fontFamily: 'Roboto',
      ),
      "ol": Style(
          textAlign: TextAlign.justify,
          color: Colors.white,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "ul": Style(
          textAlign: TextAlign.justify,
          color: Colors.white,
          fontSize: FontSize.medium,
          fontWeight: FontWeight.w300,
          fontFamily: 'Roboto'),
      "li": Style(
        textAlign: TextAlign.justify,
        color: Colors.white,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        fontFamily: 'Roboto',
      ),
      "strong": Style(
        textAlign: TextAlign.justify,
        color: Colors.white,
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w300,
        textOverflow: TextOverflow.clip,
        fontFamily: 'Roboto',
      ),
    },
  );
}
