import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Constant/app_snackbar.dart';
import 'package:swastik/Constant/app_textfield.dart';
import 'package:swastik/Controllers/category_controller.dart';
import 'package:swastik/Controllers/items_controller.dart';
import 'package:swastik/Model/category_model.dart';
import 'package:swastik/Model/item_model.dart';

class AddItem extends StatefulWidget {
  final bool isUpdate;
  final ItemModel? itemModel;
  final CategoryModel? categoryModel;
  const AddItem({super.key, required this.isUpdate, this.itemModel, this.categoryModel});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  ItemController itemController = Get.find<ItemController>();

  @override
  void dispose() {
    itemController.itemName.clear();
    itemController.itemDescription.clear();
    itemController.itemPrice.clear();
    itemController.selectedCategoryForFrom = null;
    super.dispose();
  }

  @override
  void initState() {
    if (widget.isUpdate) {
      itemController.selectedCategoryForFrom = widget.categoryModel;
      itemController.itemName.text = widget.itemModel?.name ?? "";
      itemController.itemDescription.text = widget.itemModel?.description ?? "";
      itemController.itemPrice.text = widget.itemModel?.price ?? "";
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
          "${widget.isUpdate ? "Edit" : "Add"} Item",
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
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: GetBuilder<CategoryController>(builder: (controller) {
                        return AppTextfield(
                          onTap: () async {
                            await selectCategoryDialog(context, controller);
                          },
                          labelTextName: "Category",
                          hintTextName: itemController.selectedCategoryForFrom?.name ?? "Select category",
                          minLine: 1,
                          maxLine: 3,
                          isReadOnly: true,
                          suffix: const Icon(Icons.arrow_drop_down),
                        );
                      }),
                    ),
                    AppTextfield(
                      controller: itemController.itemName,
                      labelTextName: "Name",
                      hintTextName: "Enter item name",
                      minLine: 1,
                      maxLine: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: AppTextfield(
                        controller: itemController.itemDescription,
                        labelTextName: "Description",
                        minLine: 1,
                        hintTextName: "Enter description",
                        maxLine: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: AppTextfield(
                        maxLength: 5,
                        controller: itemController.itemPrice,
                        labelTextName: "Price",
                        hintTextName: "Enter item price",
                        minLine: 1,
                        maxLine: 1,
                        keyBoardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GetBuilder<ItemController>(
        builder: (controller) {
          return controller.loader
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: const CircularProgressIndicator(),
                  ),
                )
              : GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if (controller.itemName.text.isEmpty) {
                      AppSnackbar.errorSnackbar(context, "Please add item name");
                    } else {
                      if (widget.isUpdate) {
                        await controller.updateItem(widget.itemModel?.id ?? "").then(
                          (value) {
                            if (value) {
                              if (!context.mounted) return;
                              AppSnackbar.snackbar(context, "Item details updated.");
                              Get.back();
                            } else {
                              if (!context.mounted) return;
                              AppSnackbar.errorSnackbar(context, "Something went wrong please try again!");
                            }
                          },
                        );
                      } else {
                        await controller.addItem().then(
                          (value) async {
                            if (value) {
                              controller.itemPrice.clear();
                              controller.itemDescription.clear();
                              controller.itemName.clear();
                              controller.selectedCategoryForFrom = null;
                              setState(() {});
                              if (!context.mounted) return;
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (c1) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 15.w, top: 15.h, bottom: 5.h),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(c1);
                                                  Get.back();
                                                },
                                                child: const Icon(Icons.cancel_outlined),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Item Added",
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "Would you like to add another item now?",
                                              style: TextStyle(fontSize: 17.sp),
                                            ),
                                          ),
                                          GestureDetector(
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
                                                  "Add Item",
                                                  style: TextStyle(color: AppColors.whiteColor, fontSize: 20.sp),
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
                              AppSnackbar.errorSnackbar(context, "Something went wrong please try again!");
                            }
                          },
                        );
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Center(
                      child: Text(
                        widget.isUpdate ? "Update Item" : "Add Item",
                        style: TextStyle(color: AppColors.whiteColor, fontSize: 20.sp),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Future<dynamic> selectCategoryDialog(BuildContext context, CategoryController controller) async {
    return await showDialog(
      context: context,
      builder: (c1) {
        return GetBuilder<ItemController>(
          builder: (itemController) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 550.h),
                child: Column(
                  children: [
                    AppBar(
                      title: const Text("Categories"),
                      centerTitle: true,
                      leading: const SizedBox(),
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(right: 15.w),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(c1);
                            },
                            child: const Icon(Icons.cancel_outlined),
                          ),
                        )
                      ],
                    ),
                    AppBar(
                      centerTitle: false,
                      leadingWidth: double.infinity,
                      leading: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: AppTextfield(
                          onChanged: (p0) => itemController.update(),
                          leading: const Icon(Icons.search),
                          controller: itemController.searchController,
                          hintTextName: "Search Category",
                        ),
                      ),
                    ),
                    AppBar(toolbarHeight: 10.h),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          int index = 0;

                          index = controller.categories.indexWhere(
                            (element) => element.name
                                .toString()
                                .trim()
                                .toLowerCase()
                                .contains(itemController.searchController.text.toString().trim().toLowerCase()),
                          );

                          return index < 0 || controller.categories.isEmpty
                              ? const Center(child: Text("Category not found!"))
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: controller.categories.length,
                                  itemBuilder: (context, index) {
                                    return controller.categories[index].name
                                                .toString()
                                                .trim()
                                                .toLowerCase()
                                                .contains(itemController.searchController.text.toString().trim().toLowerCase()) ||
                                            itemController.searchController.text.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10.w).copyWith(bottom: 10.h),
                                            child: ListTile(
                                              onTap: () {
                                                itemController.updateSelectedCategoryForForm(controller.categories[index]);
                                                Navigator.pop(c1);
                                                setState(() {});
                                              },
                                              tileColor: AppColors.primaryColor.withOpacity(0.12),
                                              title: Text("${controller.categories[index].name}"),
                                            ),
                                          )
                                        : const SizedBox();
                                  },
                                );
                        },
                      ),
                    ),
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
