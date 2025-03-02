import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Constant/app_snackbar.dart';
import 'package:swastik/Constant/app_textfield.dart';
import 'package:swastik/Controllers/category_controller.dart';
import 'package:swastik/Model/category_model.dart';
import 'package:swastik/Pages/add_item.dart';

class AddCategory extends StatefulWidget {
  final bool isUpdate;
  final CategoryModel? categoryModel;
  const AddCategory({super.key, required this.isUpdate, this.categoryModel});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  CategoryController categoryController = Get.find<CategoryController>();

  @override
  void dispose() {
    categoryController.categoryName.clear();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.isUpdate) {
      categoryController.categoryName.text = widget.categoryModel?.name ?? "";
    }
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
        title: Text(
          "${widget.isUpdate ? "Edit" : "Add"} Category",
          style: const TextStyle(
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: AppTextfield(
                controller: categoryController.categoryName,
                labelTextName: "Name",
                hintTextName: "Enter category name",
                minLine: 1,
                maxLine: 3,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<CategoryController>(
        builder: (controller) {
          return controller.loader
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: const CircularProgressIndicator(),
                  ),
                )
              : GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if (controller.categoryName.text.isEmpty) {
                      AppSnackbar.errorSnackbar(
                          context, "Please add category name");
                    } else {
                      if (widget.isUpdate) {
                        if (widget.categoryModel?.name
                                    .toString()
                                    .toLowerCase()
                                    .trim() !=
                                controller.categoryName.text
                                    .toString()
                                    .toLowerCase()
                                    .trim() &&
                            controller.categories.any((element) =>
                                element.name!.toLowerCase().toString().trim() ==
                                controller.categoryName.text
                                    .toString()
                                    .toLowerCase()
                                    .trim())) {
                          if (!context.mounted) return;
                          AppSnackbar.errorSnackbar(context,
                              "${controller.categoryName.text.trim()} category already exist");
                          return;
                        }

                        await controller
                            .updateCategory(widget.categoryModel?.id ?? "")
                            .then(
                          (value) {
                            if (value) {
                              if (!context.mounted) return;
                              AppSnackbar.snackbar(
                                  context, "Category name updated.");
                              Get.back();
                            } else {
                              if (!context.mounted) return;
                              AppSnackbar.errorSnackbar(context,
                                  "Something went wrong please try again!");
                            }
                          },
                        );
                      } else {
                        if (controller.categories.any((element) =>
                            element.name!.toLowerCase().toString().trim() ==
                            controller.categoryName.text
                                .toString()
                                .toLowerCase()
                                .trim())) {
                          if (!context.mounted) return;
                          AppSnackbar.errorSnackbar(context,
                              "${controller.categoryName.text.trim()} category already exist");
                          return;
                        }
                        await controller.addCategory().then(
                          (value) async {
                            if (value) {
                              controller.categoryName.clear();
                              if (!context.mounted) return;
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (c1) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: 15.w,
                                                  top: 15.h,
                                                  bottom: 5.h),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(c1);
                                                  Get.back();
                                                },
                                                child: const Icon(
                                                    Icons.cancel_outlined),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Category Added",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w,
                                                vertical: 15.h),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "Would you like to add items to this category now?",
                                              style: TextStyle(fontSize: 17.sp),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(c1);
                                              Get.back();
                                              Get.to(
                                                  () => const AddItem(
                                                        isUpdate: false,
                                                      ),
                                                  transition:
                                                      Transition.rightToLeft);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16.w),
                                              height: 55.h,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Add Items",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.whiteColor,
                                                      fontSize: 20.sp),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 15.h)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (!context.mounted) return;
                              AppSnackbar.errorSnackbar(context,
                                  "Something went wrong please try again!");
                            }
                          },
                        );
                      }
                    }
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Center(
                      child: Text(
                        widget.isUpdate ? "Update Category" : "Add Category",
                        style: TextStyle(
                            color: AppColors.whiteColor, fontSize: 20.sp),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
