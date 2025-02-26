import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swastik/Constant/app_color.dart';

class AppSnackbar {
  static snackbar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        duration: const Duration(milliseconds: 1800),
        backgroundColor: AppColors.primaryColor,
        content: Text(
          title,
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }

  static errorSnackbar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 1800),
        content: Text(
          title,
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
