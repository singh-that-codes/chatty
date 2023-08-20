import 'package:chatty/common/routes/pages.dart';
import 'package:chatty/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  await Global.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context,child)=>GetMaterialApp
      (
        debugShowCheckedModeBanner: false,
        title: 'Chit-Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
      ),
      initialRoute: AppPages.INITIAL ,
      getPages: AppPages.routes,
      ),
    );
  }
}



