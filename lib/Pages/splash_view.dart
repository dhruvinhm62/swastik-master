import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swastik/Constant/app_color.dart';
import 'package:swastik/Pages/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  _onInit() {
    Future.delayed(const Duration(milliseconds: 1800), () {
      Get.offAll(
        () => const HomeView(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 1200),
      );
    });
  }

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
