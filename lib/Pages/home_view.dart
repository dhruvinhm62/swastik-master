import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Constant/app_snackbar.dart';
import 'package:swastik/Constant/app_textfield.dart';
import 'package:swastik/Controllers/category_controller.dart';
import 'package:swastik/Controllers/items_controller.dart';
import 'package:swastik/Model/item_model.dart';
import 'package:swastik/Pages/add_category.dart';
import 'package:swastik/Pages/add_details.dart';
import 'package:swastik/Pages/add_item.dart';
import 'package:swastik/Pages/all_category.dart';
import 'package:swastik/Pages/party_list.dart';
import 'package:swastik/Pages/selection_mode.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CategoryController categoryController = Get.find<CategoryController>();
  ItemController itemController = Get.find<ItemController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => initData());
    super.initState();
  }

  Future<void> initData() async {
    itemController.updateLoader(true);
    await categoryController.fetchCategories();
    await itemController.fetchItems();
    itemController.updateLoader(false);
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
          surfaceTintColor: Colors.transparent,
          actions: [
            GetBuilder<ItemController>(
              builder: (iController) {
                return PopupMenuButton(
                  iconColor: AppColors.whiteColor,
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 300))
                            .then(
                          (value) {
                            itemController.clearSelectedCategory();
                            return Get.to(
                              () => const AddCategory(isUpdate: false),
                              transition: Transition.rightToLeft,
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.category_outlined),
                          SizedBox(width: 10.w),
                          const Text("Add Category"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 300))
                            .then(
                          (value) {
                            itemController.clearSelectedCategory();
                            return Get.to(
                              () => const AddItem(
                                isUpdate: false,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.inventory),
                          SizedBox(width: 10.w),
                          const Text("Add Items"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 300))
                            .then(
                          (value) {
                            itemController.clearSelectedCategory();
                            return Get.to(
                              () => const AllCategoryScreen(),
                              transition: Transition.rightToLeft,
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.menu),
                          SizedBox(width: 10.w),
                          const Text("All Categories"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 300))
                            .then(
                          (value) {
                            itemController.clearSelectedCategory();
                            return Get.to(
                              () => const PartyListScreen(),
                              transition: Transition.rightToLeft,
                            );
                          },
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.people_alt_outlined),
                          SizedBox(width: 10.w),
                          const Text("Party List"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          const Icon(Icons.cancel_outlined),
                          SizedBox(width: 10.w),
                          const Text("Close"),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          ],
          backgroundColor: AppColors.primaryColor,
          title: Row(
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
                    return controller.fetchDataLoader
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SingleChildScrollView(
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  controller.selectedCategory
                                                          ?.name ??
                                                      categoryController
                                                          .categoriesAll
                                                          .first
                                                          .name ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize: 17.sp),
                                                ),
                                                const Icon(
                                                    Icons.arrow_drop_down),
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 15.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        itemCount: controller.items.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                          onLongPress: () {
                                            controller
                                                .changeToSelectionMode(true);

                                            controller.addSelectedItems(
                                                controller.items[index]);

                                            Get.to(
                                              () => const SelectionMode(
                                                isUpdate: false,
                                              ),
                                              transition: Transition.fadeIn,
                                            );
                                          },
                                          onTap: () {
                                            if (controller.isSelectionMode) {
                                              if (controller.selectedItems.any(
                                                  (ItemModel ele) =>
                                                      ele.id ==
                                                      controller
                                                          .items[index].id)) {
                                                controller.removeSelectedItems(
                                                    controller.items[index]);
                                              } else {
                                                controller.addSelectedItems(
                                                    controller.items[index]);
                                              }
                                            }
                                          },
                                          child: Slidable(
                                            endActionPane: ActionPane(
                                              extentRatio: 0.4,
                                              motion: const ScrollMotion(),
                                              children: [
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SlidableAction(
                                                  onPressed: (context) async {
                                                    await Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    100))
                                                        .then(
                                                      (value) => Get.to(
                                                        () => AddItem(
                                                          isUpdate: true,
                                                          itemModel: controller
                                                              .items[index],
                                                          categoryModel:
                                                              categoryController
                                                                  .categories
                                                                  .where(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        controller
                                                                            .items[index]
                                                                            .categoryId,
                                                                  )
                                                                  .first,
                                                        ),
                                                        transition: Transition
                                                            .rightToLeft,
                                                      ),
                                                    );
                                                  },
                                                  backgroundColor:
                                                      AppColors.primaryColor,
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  padding: EdgeInsets.all(15.h),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SlidableAction(
                                                  onPressed: (context) async {
                                                    await deleteItem(context,
                                                        index, controller);
                                                  },
                                                  backgroundColor: AppColors
                                                      .primaryColor
                                                      .withOpacity(0.6),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  padding: EdgeInsets.all(15.h),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                              ],
                                            ),
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
                                                    padding:
                                                        EdgeInsets.all(10.h),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
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
                                                                                FontWeight.w500,
                                                                            fontSize:
                                                                                15.sp,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            maxLines:
                                                                                1,
                                                                            controller.items[index].name ??
                                                                                "",
                                                                            style:
                                                                                TextStyle(
                                                                              overflow: TextOverflow.ellipsis,
                                                                              fontSize: 15.sp,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    controller
                                                                            .items[index]
                                                                            .price!
                                                                            .isEmpty
                                                                        ? const SizedBox()
                                                                        : Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Price : ",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 15.sp,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "${controller.items[index].price}",
                                                                                style: TextStyle(
                                                                                  fontSize: 15.sp,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                    controller
                                                                            .items[index]
                                                                            .description!
                                                                            .isEmpty
                                                                        ? const SizedBox()
                                                                        : Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Description : ",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 15.sp,
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: ReadMoreText(
                                                                                  "${controller.items[index].description} ",
                                                                                  style: TextStyle(fontSize: 15.sp),
                                                                                  trimMode: TrimMode.Line,
                                                                                  trimLines: 1,
                                                                                  colorClickableText: Colors.pink,
                                                                                  trimCollapsedText: 'Show more',
                                                                                  trimExpandedText: 'Show less',
                                                                                  lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                                                  moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.h,
                                                            vertical: 5.h),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .primaryColor
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        bottom: Radius.circular(
                                                            4.r),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Category : ",
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.sp,
                                                            color: AppColors
                                                                .blackColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          (controller
                                                                  .items[index]
                                                                  .categoryName ??
                                                              ""),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .blackColor,
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
                                      ),
                                SizedBox(height: 100.h)
                              ],
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
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
