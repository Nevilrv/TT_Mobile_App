import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_share/social_share.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forums_response_model.dart';
import 'package:tcm/screen/forum/add_forum_screen.dart';
import 'package:tcm/screen/forum/comment_screen.dart';
import 'package:tcm/screen/forum/forum_detail_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/images.dart';

import '../../api_services/api_response.dart';
import '../../utils/font_styles.dart';
import '../../viewModel/forum_viewModel/forum_viewmodel.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

enum Menu { HotPosts, PopularPosts }

class _ForumScreenState extends State<ForumScreen> {
  String _selectedMenu = '';

  ForumViewModel forumViewModel = Get.put(ForumViewModel());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forumViewModel.getAllForumsViewModel();
  }

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
        title: Text('Forums', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorUtils.kSaperatedGray,
                  borderRadius: BorderRadius.circular(10)),
              height: Get.height * 0.05,
              width: Get.width,
              child: TextField(
                  style: FontTextStyle.kWhite16W300Roboto,
                  decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: FontTextStyle.kLightGray16W300Roboto,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorUtils.kTint,
                        size: Get.height * 0.03,
                      ),
                      suffixIcon: PopupMenuButton<Menu>(
                          color: ColorUtils.kBlack,
                          icon: Image.asset(
                            AppImages.filter,
                            fit: BoxFit.contain,
                            color: ColorUtils.kTint,
                            height: Get.height * 0.03,
                            width: Get.height * 0.03,
                          ),
                          // Callback that sets the selected popup menu item.
                          onSelected: (Menu item) {
                            setState(() {
                              _selectedMenu = item.name;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<Menu>>[
                                PopupMenuItem<Menu>(
                                  value: Menu.HotPosts,
                                  child: Text(
                                    'Hot Posts',
                                    style: FontTextStyle.kWhite16W300Roboto,
                                  ),
                                ),
                                PopupMenuItem<Menu>(
                                  value: Menu.PopularPosts,
                                  child: Text(
                                    'Popular Posts',
                                    style: FontTextStyle.kWhite16W300Roboto,
                                  ),
                                ),
                              ]))),
            ),
          ),
          Divider(
            color: ColorUtils.kTint,
            height: Get.height * .03,
            thickness: 1,
          ),
          GetBuilder<ForumViewModel>(
            builder: (controller) {
              if (controller.getAllForumsApiResponse.status == Status.LOADING) {
                return Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(
                    color: ColorUtils.kTint,
                  ),
                ));
              }
              if (controller.getAllForumsApiResponse.status == Status.ERROR) {
                return Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Server Error',
                    style: FontTextStyle.kTine16W400Roboto,
                  ),
                ));
              }

              GetAllForumsResponseModel response =
                  controller.getAllForumsApiResponse.data;
              if (response.data!.isEmpty) {
                return Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'No data found',
                    style: FontTextStyle.kTine16W400Roboto,
                  ),
                ));
              }
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.height * 0.02,
                      vertical: Get.height * 0.02),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: response.data!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                                color:
                                    ColorUtils.kSaperatedGray.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(7)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.height * 0.013,
                                  vertical: Get.height * 0.013),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  boxHeader(response: response, index: index),
                                  SizedBox(height: Get.height * 0.02),
                                  boxBody(response: response, index: index),
                                  SizedBox(height: Get.height * 0.02),
                                  boxFooter(response: response, index: index),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.to(AddForumScreen());
        },
        child: CircleAvatar(
          backgroundColor: ColorUtils.kTint,
          radius: Get.height * 0.03,
          child: Icon(
            Icons.add,
            color: ColorUtils.kBlack,
            size: Get.height * 0.04,
          ),
        ),
      ),
    );
  }

  Widget boxBody({GetAllForumsResponseModel? response, int? index}) {
    return GestureDetector(
      onTap: () {
        Get.to(ForumDetailScreen(
          response: response!.data![index!],
        ));
      },
      child: Container(
        color: Colors.transparent,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${response!.data![index!].tagTitle}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: FontTextStyle.kTine17BoldRoboto.copyWith(
                fontSize: Get.height * 0.0185,
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Text(
              '${response.data![index].postTitle!.replaceFirst(response.data![index].postTitle![0], response.data![index].postTitle![0].toUpperCase())}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: FontTextStyle.kWhite17W400Roboto.copyWith(
                fontSize: Get.height * 0.0185,
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Text(
              '${response.data![index].postDescription}',
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: FontTextStyle.kLightGray16W300Roboto,
            ),
          ],
        ),
      ),
    );
  }

  Row boxHeader({GetAllForumsResponseModel? response, int? index}) {
    return Row(
      children: [
        Container(
          height: Get.height * 0.06,
          width: Get.height * 0.06,
          decoration: BoxDecoration(
              color: ColorUtils.kBlack,
              shape: BoxShape.circle,
              border: Border.all(color: ColorUtils.kTint),
              image: DecorationImage(
                  image: NetworkImage(
                      'https://static.toiimg.com/photo/msid-92046640/92046640.jpg'),
                  fit: BoxFit.cover)),
        ),
        SizedBox(
          width: Get.width * 0.03,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amit Shah ',
              style: FontTextStyle.kWhite17W400Roboto,
            ),
            SizedBox(
              height: Get.height * 0.002,
            ),
            Row(
              children: [
                Text(
                  'Posted By Amit Shah',
                  style: FontTextStyle.kLightGray16W300Roboto
                      .copyWith(fontSize: Get.height * 0.015),
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Icon(
                  Icons.circle,
                  size: Get.height * 0.007,
                  color: ColorUtils.kLightGray,
                ),
                SizedBox(
                  width: Get.width * 0.01,
                ),
                response!.data![index!].postDate!.isEmpty
                    ? SizedBox()
                    : Text(
                        '${response.data![index].postDate} ',
                        style: FontTextStyle.kLightGray16W300Roboto
                            .copyWith(fontSize: Get.height * 0.018),
                      ),
              ],
            ),
          ],
        )
      ],
    );
  }

  bool isLike = false;
  bool isUnLike = false;
  Padding boxFooter({GetAllForumsResponseModel? response, int? index}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLike = !isLike;
                  });
                },
                child: isLike == false
                    ? Image.asset(
                        AppImages.arrowUpBorder,
                        color: ColorUtils.kTint,
                        height: Get.height * 0.022,
                        width: Get.height * 0.022,
                      )
                    : Image.asset(
                        AppImages.arrowUp,
                        color: ColorUtils.kTint,
                        height: Get.height * 0.022,
                        width: Get.height * 0.022,
                      ),
              ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              Text(
                '2.3k',
                style: FontTextStyle.kWhite17W400Roboto.copyWith(
                  fontSize: Get.height * 0.0185,
                ),
              ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isUnLike = !isUnLike;
                  });
                },
                child: isUnLike == false
                    ? Image.asset(
                        AppImages.arrowDownBorder,
                        color: ColorUtils.kTint,
                        height: Get.height * 0.022,
                        width: Get.height * 0.022,
                      )
                    : Image.asset(
                        AppImages.arrowDown,
                        color: ColorUtils.kTint,
                        height: Get.height * 0.022,
                        width: Get.height * 0.022,
                      ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              await forumViewModel.getAllCommentsViewModel(
                postId: response!.data![index!].postId,
              );
              Get.to(CommentScreen(
                postId: response.data![index].postId,
              ));
            },
            child: Row(
              children: [
                Image.asset(
                  AppImages.comment,
                  color: ColorUtils.kTint,
                  height: Get.height * 0.022,
                  width: Get.height * 0.022,
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Text(
                  '2.3k',
                  style: FontTextStyle.kWhite17W400Roboto.copyWith(
                    fontSize: Get.height * 0.0185,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              SocialShare.shareOptions(
                "5 Ways to Torch Your Core in Every Workout \n At the core of every movement is just that: your core. And while lots of times &ldquo;core&rdquo; and &ldquo;abs&rdquo; become synonymous, it&rsquo;s not 100% correct to use them interchangeably. Your rectus abdominus, transverse abdominus and obliques do comprise your midsection, but those aren&rsquo;t the only muscles involved. Your back, hips and glutes also provide that stable base you need for stepping forward and backward, jumping side-to-side or turning all about. So to get a serious core workout you need to work them all.</p><p>&ldquo;Core strength and stability not only enhances physical and athletic performance, but also helps maintain and correct posture and form, and prevent injury,&rdquo; says Andia Winslow, a Daily Burn Audio Workouts trainer. &ldquo;Those who have an awareness of their core and ability to engage it properly also have enhanced proprioception &mdash; or a sense of the positions of their extremities, without actually seeing them.&rdquo;",
              ).then((data) {
                print(data);
              });
            },
            child: Row(
              children: [
                Image.asset(
                  AppImages.share,
                  color: ColorUtils.kTint,
                  height: Get.height * 0.022,
                  width: Get.height * 0.022,
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Text(
                  'Share',
                  style: FontTextStyle.kWhite17W400Roboto.copyWith(
                    fontSize: Get.height * 0.0185,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
