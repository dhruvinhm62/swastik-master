import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Constant/app_snackbar.dart';
import 'package:swastik/Controllers/items_controller.dart';
import 'package:swastik/Pages/add_details.dart';
import 'package:swastik/Pages/party_details.dart';

class PartyListScreen extends StatefulWidget {
  const PartyListScreen({super.key});

  @override
  State<PartyListScreen> createState() => _PartyListScreenState();
}

class _PartyListScreenState extends State<PartyListScreen> {
  ItemController itemController = Get.find<ItemController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
    super.initState();
  }

  Future<void> initData() async {
    itemController.updatePartyDataLoader(true);
    await itemController.fetchEstimate();
    itemController.updatePartyDataLoader(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.whiteColor,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Party List",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Scrollbar(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              Positioned(
                top: 220.h,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.3,
                  child: Center(
                    child: Image.asset("assets/images/logo.png"),
                  ),
                ),
              ),
              GetBuilder<ItemController>(
                builder: (controller) {
                  return controller.partyDataLoader
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : controller.estimateList.isEmpty
                          ? Center(
                              child: Text(
                                "No party details found!",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                SingleChildScrollView(
                                  child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 15.h),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 20.h),
                                    itemCount: controller.estimateList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Slidable(
                                        endActionPane: ActionPane(
                                          extentRatio: 0.4,
                                          motion: const ScrollMotion(),
                                          children: [
                                            SizedBox(width: 10.w),
                                            SlidableAction(
                                              onPressed: (context) async {
                                                await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 180))
                                                    .then(
                                                  (value) => Get.to(
                                                    () => AddDetails(
                                                      isUpdate: true,
                                                      model: controller
                                                          .estimateList[index],
                                                    ),
                                                    transition:
                                                        Transition.rightToLeft,
                                                  ),
                                                );
                                              },
                                              backgroundColor:
                                                  AppColors.primaryColor,
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              padding: EdgeInsets.all(15.h),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            SlidableAction(
                                              onPressed: (context) async {
                                                await deletePartyDetails(
                                                    context, index, controller);
                                              },
                                              backgroundColor: AppColors
                                                  .primaryColor
                                                  .withOpacity(0.6),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              padding: EdgeInsets.all(15.h),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                          ],
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              () => PartyDetails(
                                                estimateModel: controller
                                                    .estimateList[index],
                                              ),
                                              transition:
                                                  Transition.rightToLeft,
                                            );
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              border: Border.all(
                                                color: AppColors.primaryColor
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.only(
                                                      bottom: 10.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .primaryColor
                                                        .withOpacity(0.15),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    10.h,
                                                                vertical: 8.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .primaryColor
                                                              .withOpacity(0.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    4.r),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Name : ",
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15.sp,
                                                                color: AppColors
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                            Text(
                                                              (controller
                                                                      .estimateList[
                                                                          index]
                                                                      .name ??
                                                                  ""),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .blackColor,
                                                                fontSize: 15.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        9.h)
                                                            .copyWith(top: 9.h),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Date : ",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15.sp,
                                                              ),
                                                            ),
                                                            Text(
                                                              controller
                                                                      .estimateList[
                                                                          index]
                                                                      .date ??
                                                                  "",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    9.h),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8.h),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Event : ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      controller
                                                                              .estimateList[index]
                                                                              .eventName ??
                                                                          "",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            15.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Event address : ",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15.sp,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    controller
                                                                            .estimateList[index]
                                                                            .eventAddress ??
                                                                        "",
                                                                    maxLines: 2,
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                controller.partyDeleteLoader
                                    ? Container(
                                        color: Colors.black26,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deletePartyDetails(
      BuildContext context, int index, ItemController controller) async {
    await Future.delayed(const Duration(milliseconds: 100)).then(
      (value) async {
        if (!context.mounted) return;
        return await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c1) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: 15.w, top: 15.h, bottom: 5.h),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(c1);
                          },
                          child: const Icon(Icons.cancel_outlined),
                        ),
                      ),
                    ),
                    Text(
                      "Delete Party Details",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 15.h),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Are you sure you want to delete this details?",
                        style: TextStyle(fontSize: 17.sp),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(c1);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16.w),
                              height: 55.h,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Center(
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 20.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              String name =
                                  controller.estimateList[index].name ?? "";

                              Navigator.pop(c1);
                              await controller
                                  .deleteEstimate(
                                      controller.estimateList[index].id ?? "")
                                  .then(
                                (value) {
                                  if (value) {
                                    if (!context.mounted) return;
                                    AppSnackbar.snackbar(
                                        context, "$name details deleted.");
                                  } else {
                                    if (!context.mounted) return;
                                    AppSnackbar.errorSnackbar(context,
                                        "Something went wrong please try again!");
                                  }
                                },
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 16.w),
                              height: 55.h,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Center(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 20.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h)
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
