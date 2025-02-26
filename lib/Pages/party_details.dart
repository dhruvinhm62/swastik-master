import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Constant/app_snackbar.dart';
import 'package:swastik/Controllers/items_controller.dart';
import 'package:swastik/Model/estimate_model.dart';
import 'package:swastik/Pages/pdf_view.dart';

class PartyDetails extends StatefulWidget {
  const PartyDetails({super.key, required this.estimateModel});
  final EstimateModel estimateModel;
  @override
  State<PartyDetails> createState() => _PartyDetailsState();
}

class _PartyDetailsState extends State<PartyDetails> {
  ItemController itemController = Get.find<ItemController>();

  EstimateModel? estimateModel;
  @override
  void initState() {
    estimateModel = widget.estimateModel;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await itemController.setEstimateData(widget.estimateModel);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      itemController.clearValues();
    });
    super.dispose();
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
          "Party Details",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.h, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4.r),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name : ",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: AppColors.blackColor,
                                ),
                              ),
                              Text(
                                (estimateModel?.name ?? ""),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.h)
                              .copyWith(bottom: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  children: [
                                    Text(
                                      "Date : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    Text(
                                      estimateModel?.date ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Event : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        estimateModel?.eventName ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Event address : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      estimateModel?.eventAddress ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Resident address : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        estimateModel?.residentAddress ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Reference : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      estimateModel?.reference ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Morning : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          Text(
                                            estimateModel?.morningDish ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 8,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Time : ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                            Text(
                                              estimateModel?.morningTime ?? "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Afternoon : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          estimateModel?.afternoonDish ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Time : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          estimateModel?.afternoonTime ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Evening : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          Text(
                                            estimateModel?.eveningDish ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Time : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          Text(
                                            estimateModel?.eveningTime ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 10,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Mo : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          estimateModel?.mobileNumber ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Mo : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          estimateModel
                                                  ?.alternateMobileNumber ??
                                              "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  children: [
                                    Text(
                                      "Dish Price : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    Text(
                                      estimateModel?.dishPrice ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: Row(
                                  children: [
                                    Text(
                                      "રસોઈ માટે મંડપ : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    Text(
                                      estimateModel?.porch ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "વોશબેસીન હાથ ધોવા : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    estimateModel?.washbasin ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  children: [
                                    Text(
                                      "કાઉન્ટર ટેબલ ૩ ફૂટ : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    Text(
                                      estimateModel?.counter3 ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "કાઉન્ટર ટેબલ ૧ ફૂટ : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  Text(
                                    estimateModel?.counter1 ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "ચોકડી માટે પતરાં : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                        Text(
                                          estimateModel?.letters ?? "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: Row(
                                  children: [
                                    Text(
                                      "ઇલે. પોઈન્ટ ૧૫ એમ. : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                    Text(
                                      estimateModel?.elePoint ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                      ),
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.h, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4.r),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selected Item",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GetBuilder<ItemController>(builder: (itemController) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.h)
                                .copyWith(bottom: 10.h),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 5.h),
                              itemCount: itemController.selectedItems.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(5.h),
                                  child: Row(
                                    children: [
                                      Text(
                                        "• ",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        itemController
                                                .selectedItems[index].name ??
                                            "",
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                    child: GetBuilder<ItemController>(
                      builder: (controller) {
                        return GestureDetector(
                          onTap: () async {
                            Get.to(
                              () => const PdfView(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: Container(
                            height: 55.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: Text(
                                "Generate PDF",
                                style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 20.sp),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
