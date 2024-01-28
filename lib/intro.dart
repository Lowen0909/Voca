import 'package:flutter/material.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'menu.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen.navigate(
      name: 'assets/voca_!!.riv', // flr動畫檔路徑
      next: (context)=>MenuPage(), // 動畫結束後轉換頁面
      until: () => Future.delayed(Duration(seconds: 2)), //等待3秒
      startAnimation: 'star', // 動畫名稱
    );
  }
}