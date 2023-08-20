import 'package:chatty/common/values/values.dart';
import 'package:chatty/pages/frame/welcome/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});
  Widget _buildPageHeadTitle(String title) {
    return Container(
      margin: EdgeInsets.only(top: 350),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryElementText,
          fontFamily: "Monsterrat",fontWeight: FontWeight.bold,fontSize: 45.sp
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryElement ,
      body: Container(
        child: _buildPageHeadTitle(controller.title)
      ),

    );
  }
}