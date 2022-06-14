import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';

Padding listViewTab({
  required List<dynamic> getEventForDay(DateTime day),
  DateTime? selectedDay,
}) {
  return Padding(
    padding: EdgeInsets.only(top: Get.height * 0.03),
    child: SizedBox(
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 5,
          itemBuilder: (_, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: Get.height * .03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monday,April 14th',
                    style: FontTextStyle.kWhite16BoldRoboto,
                  ),
                  Divider(
                    color: ColorUtils.kTint,
                    height: Get.height * .03,
                    thickness: 1.5,
                  ),
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: getEventForDay(selectedDay!)
                        .map((event) => ListTile(
                              title: Text(
                                event['title'].toString(),
                                style: FontTextStyle.kWhite17BoldRoboto,
                              ),
                              subtitle: Text(
                                event['subtitle'].toString(),
                                style: FontTextStyle.kLightGray16W300Roboto,
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  openBottomSheet(event);
                                },
                                child: Icon(
                                  Icons.more_horiz_sharp,
                                  color: ColorUtils.kTint,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            );
          }),
    ),
  );
}

Tab tabbarCommonTab({IconData? icon, String? tabName}) {
  return Tab(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: Get.height * .02,
        ),
        SizedBox(width: Get.height * .006),
        Text(
          tabName!,
          style: TextStyle(fontSize: Get.height * .017),
        ),
      ],
    ),
  );
}

void openBottomSheet(Map<String, dynamic> event) {
  Get.bottomSheet(
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: Get.height * .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: Get.width * .1),
            Center(
              child: Text(event['subtitle'].toString(),
                  style: FontTextStyle.kLightGray22BoldRoboto),
            ),
            Divider(
              color: ColorUtils.kGray,
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  'View Workout',
                  style: FontTextStyle.kBlue22W500Roboto,
                )),
            Divider(
              color: ColorUtils.kGray,
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  'Edit Workout',
                  style: FontTextStyle.kBlue22W500Roboto,
                )),
            Divider(
              color: ColorUtils.kGray,
            ),
            TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith(
                        (states) => ColorUtils.kRed.withOpacity(.1))),
                child: Text(
                  'Delete Workout',
                  style: FontTextStyle.kBlue22W500Roboto
                      .copyWith(color: ColorUtils.kRed),
                )),
            InkWell(
              onTap: () {
                print('Cancel');
                Get.back();
              },
              child: Container(
                alignment: Alignment.center,
                height: Get.height * .075,
                width: Get.width,
                decoration: BoxDecoration(
                  color: ColorUtils.kWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Cancel',
                  style: FontTextStyle.kBlue22W500Roboto
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    backgroundColor: ColorUtils.kBottomSheetGray,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
