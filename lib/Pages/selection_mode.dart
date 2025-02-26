import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Constant/app_snackbar.dart';
import 'package:swastik/Constant/app_textfield.dart';
import 'package:swastik/Controllers/category_controller.dart';
import 'package:swastik/Controllers/items_controller.dart';
import 'package:swastik/Model/item_model.dart';
import 'package:swastik/Pages/add_details.dart';

class SelectionMode extends StatefulWidget {
  const SelectionMode({super.key, required this.isUpdate});
  final bool isUpdate;

  @override
  State<SelectionMode> createState() => _SelectionModeState();
}

class _SelectionModeState extends State<SelectionMode> {
  CategoryController categoryController = Get.find<CategoryController>();
  ItemController itemController = Get.find<ItemController>();

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        itemController.changeToSelectionMode(false);

        if (!widget.isUpdate) {
          itemController.clearValues();
          itemController.clearSelectedCategory();
        }
      },
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      onRefresh: () async {
        await categoryController.fetchCategories();
        await itemController.fetchItems();
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          leadingWidth: widget.isUpdate ? 56.w : 0,
          surfaceTintColor: Colors.transparent,
          leading: widget.isUpdate
              ? IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.whiteColor,
                  ),
                )
              : const SizedBox(),
          actions: [
            widget.isUpdate
                ? const SizedBox()
                : GetBuilder<ItemController>(
                    builder: (iController) {
                      return GestureDetector(
                        onTap: () {
                          iController.clearValues();
                          iController.changeToSelectionMode(false);
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.r)),
                          ),
                          child: const Text(
                            "Cancel Selection",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    },
                  )
          ],
          backgroundColor: AppColors.primaryColor,
          centerTitle: widget.isUpdate,
          title: widget.isUpdate
              ? const Text(
                  "Select Items",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Row(
                  children: [
                    const Icon(
                      CupertinoIcons.home,
                      color: AppColors.whiteColor,
                    ),
                    SizedBox(width: 10.w),
                    const Text(
                      "Home",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Category",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ).paddingOnly(top: 15.h, left: 16.w),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 16.w),
                            child: GetBuilder<CategoryController>(
                              builder: (categoryController) {
                                return GestureDetector(
                                  onTap: () async {
                                    await selectCategoryDialog(
                                            context, categoryController)
                                        .then(
                                      (value) =>
                                          itemController.filterItemList(),
                                    );
                                  },
                                  child: Container(
                                    height: 55.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withOpacity(0.2),
                                      border: Border.all(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.7),
                                          width: 0.7),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.selectedCategory?.name ??
                                                categoryController
                                                    .categoriesAll.first.name ??
                                                "",
                                            style: TextStyle(fontSize: 17.sp),
                                          ),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Text(
                            "Items",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ).paddingOnly(left: 16.w, bottom: 15.h),
                          controller.items.isEmpty
                              ? SizedBox(
                                  height: 500.h,
                                  child: Center(
                                    child: Text(
                                      "No items found!",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 15.h),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  itemCount: controller.items.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      if (controller.selectedItems.any(
                                          (ItemModel ele) =>
                                              ele.id ==
                                              controller.items[index].id)) {
                                        controller.removeSelectedItems(
                                            controller.items[index]);
                                      } else {
                                        controller.addSelectedItems(
                                            controller.items[index]);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                        border: Border.all(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(10.h),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "Name : ",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        15.sp,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    maxLines: 1,
                                                                    controller
                                                                            .items[index]
                                                                            .name ??
                                                                        "",
                                                                    style:
                                                                        TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          15.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            controller
                                                                    .items[
                                                                        index]
                                                                    .price!
                                                                    .isEmpty
                                                                ? const SizedBox()
                                                                : Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Price : ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              15.sp,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "${controller.items[index].price}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15.sp,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            controller
                                                                    .items[
                                                                        index]
                                                                    .description!
                                                                    .isEmpty
                                                                ? const SizedBox()
                                                                : Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Description : ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              15.sp,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            ReadMoreText(
                                                                          "${controller.items[index].description} ",
                                                                          style:
                                                                              TextStyle(fontSize: 15.sp),
                                                                          trimMode:
                                                                              TrimMode.Line,
                                                                          trimLines:
                                                                              1,
                                                                          colorClickableText:
                                                                              Colors.pink,
                                                                          trimCollapsedText:
                                                                              'Show more',
                                                                          trimExpandedText:
                                                                              'Show less',
                                                                          lessStyle: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600),
                                                                          moreStyle: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (controller
                                                              .selectedItems
                                                              .any((ItemModel
                                                                      ele) =>
                                                                  ele.id ==
                                                                  controller
                                                                      .items[
                                                                          index]
                                                                      .id)) {
                                                            controller
                                                                .removeSelectedItems(
                                                                    controller
                                                                            .items[
                                                                        index]);
                                                          } else {
                                                            controller
                                                                .addSelectedItems(
                                                                    controller
                                                                            .items[
                                                                        index]);
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 35.h,
                                                          width: 35.h,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .primaryColor),
                                                              color: AppColors
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.5),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4.r))),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    1.8.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppColors
                                                                      .primaryColor),
                                                              color: AppColors
                                                                  .backgroundColor,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4.r)),
                                                            ),
                                                            child: controller
                                                                    .selectedItems
                                                                    .any((ItemModel
                                                                            ele) =>
                                                                        ele.id ==
                                                                        controller
                                                                            .items[index]
                                                                            .id)
                                                                ? const Icon(
                                                                    CupertinoIcons
                                                                        .check_mark,
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                  )
                                                                : const SizedBox(),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.h,
                                                vertical: 5.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(4.r),
                                              ),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Category : ",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp,
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                                Text(
                                                  (controller.items[index]
                                                          .categoryName ??
                                                      ""),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 150.h)
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: GetBuilder<ItemController>(
          builder: (controller) {
            return Container(
              color: AppColors.backgroundColor,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();

                  if (widget.isUpdate) {
                    Get.back();
                  } else {
                    if (controller.selectedItems.isEmpty) {
                      AppSnackbar.errorSnackbar(
                          context, "Please select item first.");
                    } else {
                      Get.to(
                        () => const AddDetails(isUpdate: false),
                        transition: Transition.rightToLeft,
                      );
                    }
                  }
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Center(
                    child: Text(
                      widget.isUpdate ? "Save" : "Add Details",
                      style: TextStyle(
                          color: AppColors.whiteColor, fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> selectCategoryDialog(
      BuildContext context, CategoryController controller) async {
    return await showDialog(
      context: context,
      builder: (c1) {
        return GetBuilder<ItemController>(
          builder: (itemController) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
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

                          index = controller.categoriesAll.indexWhere(
                            (element) => element.name
                                .toString()
                                .trim()
                                .toLowerCase()
                                .contains(itemController.searchController.text
                                    .toString()
                                    .trim()
                                    .toLowerCase()),
                          );

                          return index < 0 || controller.categoriesAll.isEmpty
                              ? const Center(child: Text("Category not found!"))
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: controller.categoriesAll.length,
                                  itemBuilder: (context, index) {
                                    return controller.categoriesAll[index].name
                                                .toString()
                                                .trim()
                                                .toLowerCase()
                                                .contains(itemController
                                                    .searchController.text
                                                    .toString()
                                                    .trim()
                                                    .toLowerCase()) ||
                                            itemController
                                                .searchController.text.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w)
                                                .copyWith(bottom: 10.h),
                                            child: ListTile(
                                              onTap: () {
                                                itemController
                                                    .updateSelectedCategory(
                                                        controller
                                                                .categoriesAll[
                                                            index]);
                                                Navigator.pop(c1);
                                                setState(() {});
                                              },
                                              tileColor: AppColors.primaryColor
                                                  .withOpacity(0.12),
                                              title: Text(
                                                  "${controller.categoriesAll[index].name}"),
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

  Future<void> deleteItem(
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
                      "Delete Item",
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
                        "Are you sure you want to delete this item?",
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
                              String name = controller.items[index].name ?? "";

                              Navigator.pop(c1);
                              await itemController
                                  .deleteItem(controller.items[index].id ?? "")
                                  .then(
                                (value) {
                                  if (value) {
                                    if (!context.mounted) return;
                                    AppSnackbar.snackbar(
                                        context, "$name item deleted.");
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
