import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Constant/app_snackbar.dart';
import 'package:swastik/Constant/app_textfield.dart';
import 'package:swastik/Controllers/items_controller.dart';
import 'package:swastik/Model/estimate_model.dart';
import 'package:swastik/Pages/pdf_view.dart';
import 'package:swastik/Pages/selection_mode.dart';

class AddDetails extends StatefulWidget {
  const AddDetails({super.key, required this.isUpdate, this.model});
  final bool isUpdate;
  final EstimateModel? model;
  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  ItemController itemController = Get.find<ItemController>();
  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isUpdate == true) {
        itemController.clearValues();
      }
    });
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isUpdate == true) {
        await itemController.setEstimateData(widget.model!);
      }
    });
    super.initState();
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.isUpdate
                        ? Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: GetBuilder<ItemController>(
                              builder: (controller) {
                                return GestureDetector(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();

                                    controller.changeToSelectionMode(true);

                                    Get.to(
                                      () => const SelectionMode(isUpdate: true),
                                      transition: Transition.fadeIn,
                                    );
                                  },
                                  child: Container(
                                    height: 55.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Update Items",
                                          style: TextStyle(
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.sp),
                                        ),
                                        SizedBox(width: 5.w),
                                        const RotatedBox(
                                          quarterTurns: 2,
                                          child: Icon(
                                            Icons.keyboard_backspace_outlined,
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        "Party's details :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: AppTextfield(
                        controller: itemController.name,
                        labelTextName: "Name",
                        hintTextName: "Enter name",
                        minLine: 1,
                        maxLine: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: AppTextfield(
                        isReadOnly: true,
                        onTap: () async {
                          await showDatePicker(
                            initialDate: itemController.selectedDate,
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          ).then(
                            (value) => itemController.updateDate(
                              value!,
                            ),
                          );
                        },
                        controller: itemController.date,
                        labelTextName: "Date",
                        hintTextName: "Select date",
                        minLine: 1,
                        maxLine: 3,
                      ),
                    ),
                    AppTextfield(
                      controller: itemController.event,
                      labelTextName: "Event Name",
                      hintTextName: "Enter event name",
                      minLine: 1,
                      maxLine: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: AppTextfield(
                        controller: itemController.eventAddress,
                        labelTextName: "Event Address",
                        hintTextName: "Enter event address",
                        minLine: 1,
                        maxLine: 3,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextfield(
                            keyBoardType: TextInputType.number,
                            controller: itemController.morningDish,
                            labelTextName: "Morning",
                            hintTextName: "Enter dish count",
                            minLine: 1,
                            maxLine: 3,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: AppTextfield(
                            isReadOnly: true,
                            onTap: () async {
                              await showTimePicker(
                                context: context,
                                initialTime: itemController.morningTime1,
                              ).then(
                                (value) {
                                  final localizations =
                                      MaterialLocalizations.of(context);
                                  final formattedTimeOfDay =
                                      localizations.formatTimeOfDay(value!);
                                  return itemController
                                      .updateMorning(formattedTimeOfDay);
                                },
                              );
                            },
                            controller: itemController.morningTime,
                            labelTextName: "Morning",
                            hintTextName: "Enter time",
                            minLine: 1,
                            maxLine: 3,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppTextfield(
                              keyBoardType: TextInputType.number,
                              controller: itemController.afternoonDish,
                              labelTextName: "Afternoon",
                              hintTextName: "Enter dish count",
                              minLine: 1,
                              maxLine: 3,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: AppTextfield(
                              isReadOnly: true,
                              onTap: () async {
                                await showTimePicker(
                                  context: context,
                                  initialTime: itemController.afternoonTime1,
                                ).then(
                                  (value) {
                                    final localizations =
                                        MaterialLocalizations.of(context);
                                    final formattedTimeOfDay =
                                        localizations.formatTimeOfDay(value!);
                                    return itemController
                                        .updateAfternoon(formattedTimeOfDay);
                                  },
                                );
                              },
                              controller: itemController.afternoonTime,
                              labelTextName: "Afternoon",
                              hintTextName: "Enter time",
                              minLine: 1,
                              maxLine: 3,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextfield(
                            controller: itemController.eveningDish,
                            labelTextName: "Evening",
                            keyBoardType: TextInputType.number,
                            hintTextName: "Enter dish count",
                            minLine: 1,
                            maxLine: 3,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: AppTextfield(
                            isReadOnly: true,
                            onTap: () async {
                              await showTimePicker(
                                context: context,
                                initialTime: itemController.eveningTime1,
                              ).then(
                                (value) {
                                  final localizations =
                                      MaterialLocalizations.of(context);
                                  final formattedTimeOfDay =
                                      localizations.formatTimeOfDay(value!);
                                  return itemController
                                      .updateEvening(formattedTimeOfDay);
                                },
                              );
                            },
                            controller: itemController.eveningTime,
                            labelTextName: "Evening",
                            hintTextName: "Enter time",
                            minLine: 1,
                            maxLine: 3,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: AppTextfield(
                        controller: itemController.homeAddress,
                        labelTextName: "Resident Address",
                        hintTextName: "Enter resident address",
                        minLine: 1,
                        maxLine: 3,
                      ),
                    ),
                    AppTextfield(
                      controller: itemController.dishPrice,
                      labelTextName: "Dish Price",
                      inputs: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                      keyBoardType: TextInputType.number,
                      hintTextName: "Enter dish price",
                      minLine: 1,
                      maxLine: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: AppTextfield(
                        controller: itemController.reference,
                        labelTextName: "Reference",
                        hintTextName: "Enter reference",
                        minLine: 1,
                        maxLine: 3,
                      ),
                    ),
                    AppTextfield(
                      controller: itemController.mobileNumber,
                      labelTextName: "Mobile no",
                      hintTextName: "Enter mobile number",
                      maxLength: 10,
                      keyBoardType: TextInputType.number,
                      minLine: 1,
                      maxLine: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: AppTextfield(
                        controller: itemController.alternateMobileNumber,
                        labelTextName: "Mobile no",
                        hintTextName: "Enter mobile number",
                        maxLength: 10,
                        minLine: 1,
                        keyBoardType: TextInputType.number,
                        maxLine: 3,
                      ),
                    ),
                    Text(
                      "પાર્ટીએ મંગાવવાની યાદી",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: AppTextfield(
                        inputs: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        controller: itemController.porch,
                        labelTextName: "મંડપ",
                        keyBoardType: TextInputType.number,
                        hintTextName: "રસોઈ માટે મંડપ",
                        minLine: 1,
                        maxLine: 3,
                      ),
                    ),
                    AppTextfield(
                      controller: itemController.washbasin,
                      labelTextName: "વોશબેસીન",
                      hintTextName: "વોશબેસીન હાથ ધોવા",
                      keyBoardType: TextInputType.number,
                      minLine: 1,
                      maxLine: 3,
                      inputs: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: AppTextfield(
                        controller: itemController.counter3,
                        labelTextName: "કાઉન્ટર",
                        hintTextName: "કાઉન્ટર ટેબલ ૩ ફૂટ",
                        keyBoardType: TextInputType.number,
                        minLine: 1,
                        maxLine: 3,
                        inputs: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                    AppTextfield(
                      controller: itemController.counter1,
                      labelTextName: "કાઉન્ટર",
                      hintTextName: "કાઉન્ટર ટેબલ ૧ ફૂટ",
                      keyBoardType: TextInputType.number,
                      minLine: 1,
                      maxLine: 3,
                      inputs: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: AppTextfield(
                        controller: itemController.letters,
                        keyBoardType: TextInputType.number,
                        labelTextName: "પતરાં",
                        hintTextName: "ચોકડી માટે પતરાં",
                        minLine: 1,
                        maxLine: 3,
                        inputs: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                    AppTextfield(
                      controller: itemController.elePoint,
                      keyBoardType: TextInputType.number,
                      labelTextName: "ઇલે. પોઈન્ટ",
                      hintTextName: "ઇલે. પોઈન્ટ ૧૫ એમ.",
                      minLine: 1,
                      maxLine: 3,
                      inputs: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 15.h),
                      child: GetBuilder<ItemController>(
                        builder: (controller) {
                          return GestureDetector(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (controller.name.text.isEmpty) {
                                AppSnackbar.errorSnackbar(
                                    context, "Please enter name");
                              } else {
                                if (controller.selectionModeId != null) {
                                  controller.updateEstimate(
                                      controller.selectionModeId ?? "");
                                } else {
                                  controller.addEstimate();
                                }

                                await Get.to(
                                  () => const PdfView(),
                                  transition: Transition.rightToLeft,
                                )?.then(
                                  (value) async {
                                    if (controller.selectionModeId != null) {
                                      await controller.fetchEstimate();
                                    }
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 55.h,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Center(
                                child: Text(
                                  !widget.isUpdate
                                      ? "Generate PDF"
                                      : "Update & Generate PDF",
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 20.sp),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    !widget.isUpdate
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: GetBuilder<ItemController>(
                              builder: (controller) {
                                return GestureDetector(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    if (controller.name.text.isEmpty) {
                                      AppSnackbar.errorSnackbar(
                                          context, "Please enter name");
                                    } else {
                                      await controller
                                          .updateEstimate(
                                              controller.selectionModeId ?? "")
                                          .then(
                                        (value) async {
                                          await controller.fetchEstimate();
                                          if (value) {
                                            if (!context.mounted) return;
                                            AppSnackbar.snackbar(
                                                context, "Details updated.");
                                            Get.back();
                                          } else {
                                            if (!context.mounted) return;
                                            AppSnackbar.errorSnackbar(context,
                                                "Something went wrong please try again!");
                                          }
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: 55.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Update",
                                        style: TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 20.sp),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
