import 'package:chatty/common/routes/names.dart';
import 'package:chatty/pages/frame/welcome/state.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController{
  WelcomeController();
  final title = "Chit-Chat";
  final state = WelcomeState();

  @override
  void onReady(){
    super.onReady();
    Future.delayed(
      Duration(seconds: 3), 
      ()=>Get.offAllNamed(AppRoutes.Message));
  }
}