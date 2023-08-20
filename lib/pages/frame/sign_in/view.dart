
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/sign_in/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

Widget _buildLogo(){
  return Container(
    margin: EdgeInsets.only(top:100.h,bottom:80.h),
    child: const Text(
      "Chit-Chat",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 34
      )
    ),
  );
}
Widget _buildThirdPartyLogin(String loginType, String logo){
  return Container(
    width: 295.w,
    height: 44.h,
    padding: EdgeInsets.all(10.h),
    margin: EdgeInsets.only(bottom: 15.h),
    decoration: BoxDecoration(
      color: AppColors.primaryBackground,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 1),
        )
      ]
    ),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.only(left:40.h,right:30.w),
          child: Image.asset('assets/icons/$logo.png'),
        ),
        Container(
          child: Text(
            "Sign in with $loginType",
            style: const TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 14
            )
          ), 
        ),
      ],
    )
  );
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarySecondaryBackground,
      body: Center(
        child: Column(
          children: [
            _buildLogo(),
            _buildThirdPartyLogin("Google","google"),
            _buildThirdPartyLogin("Facebook","facebook"),
            _buildThirdPartyLogin("Apple","apple"),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 2.h,
                      color: AppColors.primarySecondaryElementText,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "or"
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 2.h,
                      color: AppColors.primarySecondaryElementText,
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}