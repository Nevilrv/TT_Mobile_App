// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tcm/model/response_model/workout_response_model/user_workouts_date_response_model.dart';
// import 'package:tcm/repo/workout_repo/user_workouts_date_repo.dart';
// import 'package:tcm/utils/ColorUtils.dart';
// import 'package:tcm/utils/font_styles.dart';
// import 'package:tcm/utils/shimmer_loading.dart';
// import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';
//
// import 'workout_home_new.dart';
//
// class bottomSheet extends StatefulWidget {
//   const bottomSheet({Key? key}) : super(key: key);
//
//   @override
//   _bottomSheetState createState() => _bottomSheetState();
// }
//
// class _bottomSheetState extends State<bottomSheet> {
//   UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
//       Get.put(UserWorkoutsDateViewModel());
//   var dateNew = "2022-10-17";
//   String title = "New Demo";
//
//   @override
//   Widget build(BuildContext context) {
//     print('Date ???? ${dateNew.split(" ").first}');
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           Get.bottomSheet(
//             Container(
//               padding: const EdgeInsets.all(8),
//               height: Get.height * .55,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(9.5),
//                   color: ColorUtils.kBlack),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   SizedBox(height: Get.width * .1),
//                   Center(
//                     // child: Text('${event!.programData![0].workoutTitle}',
//                     child: Text('$title',
//                         style: FontTextStyle.kWhite20BoldRoboto
//                             .copyWith(fontSize: Get.height * .024),
//                         textAlign: TextAlign.center),
//                   ),
//                   SizedBox(height: Get.width * 0.02),
//                   Divider(
//                     color: ColorUtils.kTint,
//                   ),
//                   FutureBuilder(
//                     future: UserWorkoutsDateRepo().userWorkoutsDateRepo(
//                         userId: "20", date: dateNew.split(" ").first),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<UserWorkoutsDateResponseModel> snapshot) {
//                       if (snapshot.hasData) {
//                         try {
//                           _userWorkoutsDateViewModel.withOutWarmupExercisesList
//                               .clear();
//                           _userWorkoutsDateViewModel.withWarmupExercisesList
//                               .clear();
//                           _userWorkoutsDateViewModel.superSetList.clear();
//                           _userWorkoutsDateViewModel.superSetsRound = "";
//                           _userWorkoutsDateViewModel.userProgramDatesId = "";
//                           _userWorkoutsDateViewModel.restTime = "";
//                           snapshot.data!.data!.selectedWarmup!
//                               .forEach((element) {
//                             _userWorkoutsDateViewModel.withWarmupExercisesList
//                                 .add(element);
//                           });
//                           snapshot.data!.data!.exercisesIds!.forEach((element) {
//                             _userWorkoutsDateViewModel.withWarmupExercisesList
//                                 .add(element);
//                             _userWorkoutsDateViewModel
//                                 .withOutWarmupExercisesList
//                                 .add(element);
//                           });
//                           snapshot.data!.data!.supersetExercisesIds!
//                               .forEach((element) {
//                             _userWorkoutsDateViewModel.superSetList
//                                 .add(element);
//                           });
//                           _userWorkoutsDateViewModel.superSetsRound =
//                               snapshot.data!.data!.round;
//                           _userWorkoutsDateViewModel.userProgramDatesId =
//                               snapshot.data!.data!.userProgramDatesId!;
//                           _userWorkoutsDateViewModel.restTime =
//                               snapshot.data!.data!.restTime!;
//                         } catch (e) {}
//
//                         print(
//                             'withWarmupExercises >>> ${_userWorkoutsDateViewModel.withWarmupExercisesList}');
//                         print(
//                             'withOutWarmupList >>> ${_userWorkoutsDateViewModel.withOutWarmupExercisesList}');
//                         print(
//                             'superSetList >>> ${_userWorkoutsDateViewModel.superSetList}');
//                         print(
//                             'supersetRound >>> ${_userWorkoutsDateViewModel.superSetsRound}');
//                         print(
//                             'supersetRound >>> ${_userWorkoutsDateViewModel.userProgramDatesId}');
//                         print(
//                             'supersetRound >>> ${_userWorkoutsDateViewModel.restTime}');
//                         return snapshot.data!.data!.exercisesIds!.isEmpty ||
//                                 snapshot.data!.data!.exercisesIds == []
//                             ? TextButton(
//                                 onPressed: null,
//                                 child: Text(
//                                   "This workout is not Available",
//                                   style: FontTextStyle.kTint24W400Roboto,
//                                 ))
//                             : TextButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => WorkoutHomeNew(
//                                         workoutId: snapshot
//                                             .data!.data!.workoutId
//                                             .toString(),
//                                         exerciseId: snapshot
//                                             .data!.data!.exercisesIds![0]
//                                             .toString(),
//                                         // exeData:
//                                         //     snapshotExercise.data!.data!,
//                                         // data: snapshotWorkOut.data!.data!,
//                                         // date: dateNew.split(' ').first,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   'Start Workout',
//                                   style: FontTextStyle.kTint24W400Roboto,
//                                 ));
//                       } else if (snapshot.hasError) {
//                         print('HAS error');
//                         _userWorkoutsDateViewModel.withOutWarmupExercisesList
//                             .clear();
//                         _userWorkoutsDateViewModel.withWarmupExercisesList
//                             .clear();
//                         _userWorkoutsDateViewModel.superSetList.clear();
//                         _userWorkoutsDateViewModel.superSetsRound = "";
//                         _userWorkoutsDateViewModel.userProgramDatesId = "";
//                         _userWorkoutsDateViewModel.restTime = "";
//                         return TextButton(
//                             onPressed: null,
//                             child: Text(
//                               "This workout is not Available",
//                               style: FontTextStyle.kTint24W400Roboto,
//                             ));
//                       } else {
//                         return shimmerLoading();
//                       }
//                     },
//                   ),
//                   Divider(
//                     color: ColorUtils.kTint,
//                   ),
//                   TextButton(
//                       onPressed: null,
//                       child: Text(
//                         'View Workout',
//                         style: FontTextStyle.kTint24W400Roboto,
//                       )),
//                   Divider(
//                     color: ColorUtils.kTint,
//                   ),
//                   TextButton(
//                       onPressed: null,
//                       child: Text(
//                         'Edit Workout',
//                         style: FontTextStyle.kTint24W400Roboto,
//                       )),
//                   InkWell(
//                     onTap: () {
//                       print('Cancel');
//
//                       Get.back();
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: Get.height * .075,
//                       width: Get.width,
//                       decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(5)),
//                       child: Text(
//                         'Cancel',
//                         style: FontTextStyle.kTint24W400Roboto
//                             .copyWith(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             backgroundColor: ColorUtils.kBottomSheetGray,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           );
//         },
//         child: Container(
//           height: 100,
//           width: 450,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }
