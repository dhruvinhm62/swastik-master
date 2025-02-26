import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Constant/app_snackbar.dart';
import 'package:swastik/Controllers/category_controller.dart';
import 'package:swastik/Pages/add_category.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
    super.initState();
  }

  Future<void> initData() async {
    categoryController.updateLoader(true);
    await categoryController.fetchCategories();
    categoryController.updateLoader(false);
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
          "All Categories",
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          return controller.fetchDataLoader
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.categories.isEmpty
                  ? Center(
                      child: Text(
                        "No categories found!",
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
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 15.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 20.h),
                            itemCount: controller.categories.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.4,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) async {
                                        await Future.delayed(const Duration(
                                                milliseconds: 100))
                                            .then(
                                          (value) => Get.to(
                                            () => AddCategory(
                                              isUpdate: true,
                                              categoryModel:
                                                  controller.categories[index],
                                            ),
                                            transition: Transition.rightToLeft,
                                          ),
                                        );
                                      },
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      borderRadius: BorderRadius.circular(5.r),
                                      padding: EdgeInsets.all(15.h),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) async {
                                        await deleteCategory(
                                            context, index, controller);
                                      },
                                      backgroundColor: AppColors.primaryColor
                                          .withOpacity(0.6),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      borderRadius: BorderRadius.circular(5.r),
                                      padding: EdgeInsets.all(15.h),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    border: Border.all(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15.h),
                                    child: Text(
                                      controller.categories[index].name ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        controller.deleteLoader
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
    );
  }

  Future<void> deleteCategory(
      BuildContext context, int index, CategoryController controller) async {
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
                      "Delete Category",
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
                        "Are you sure you want to delete this category? Please note that deleting this category will also automatically remove all related items.",
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
                                  controller.categories[index].name ?? "";

                              Navigator.pop(c1);
                              await categoryController
                                  .deleteCategory(
                                      controller.categories[index].id ?? "")
                                  .then(
                                (value) {
                                  if (value) {
                                    if (!context.mounted) return;
                                    AppSnackbar.snackbar(
                                        context, "$name category deleted.");
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
