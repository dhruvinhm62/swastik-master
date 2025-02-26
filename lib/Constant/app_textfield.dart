import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swastik/Constant/app_color.dart';

class AppTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelTextName;
  final String? hintTextName;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;
  final int? minLine;
  final int? maxLine;
  final int? maxLength;
  final bool? isReadOnly;
  final bool? autoFocus;
  final Widget? suffix;
  final Widget? leading;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputs;

  const AppTextfield(
      {super.key,
      this.inputs,
      this.controller,
      this.labelTextName,
      this.keyBoardType,
      this.textInputAction,
      this.minLine,
      this.maxLine,
      this.isReadOnly,
      this.suffix,
      this.onTap,
      this.leading,
      this.hintTextName,
      this.autoFocus,
      this.onChanged,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      onChanged: onChanged,
      autofocus: autoFocus ?? false,
      readOnly: isReadOnly ?? false,
      minLines: minLine ?? 1,
      maxLines: maxLine ?? 1,
      controller: controller,
      inputFormatters: inputs,
      keyboardType: keyBoardType ?? TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.done,
      maxLength: maxLength,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: suffix,
        prefixIcon: leading,
        hintText: hintTextName,
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
        label: labelTextName == null ? const SizedBox() : Text(labelTextName!),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(5.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(5.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(5.r),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(5.r),
        ),
      ),
    );
  }
}
