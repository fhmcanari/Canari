
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shopapp/shared/components/constants.dart';

import '../../Layout/HomeLayout/home_page.dart';
import '../../shared/network/remote/cachehelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  AnimationController controller;
  double latitud = Cachehelper.getData(key: "latitude");
  double longitud = Cachehelper.getData(key: "longitude");
  String MyLocation = Cachehelper.getData(key: "myLocation");
  @override
  void initState() {
    controller = AnimationController(vsync: this,duration: Duration(seconds:3));
    controller.addStatusListener((status)async {
      if (status==AnimationStatus.completed) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context)=>
                MyHomePage(
                  latitude: latitude,
                  longitude: longitude,
                  myLocation: myLocation,
                )), (route) => false);
        controller.reset();
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    return Scaffold(
        body:Stack(
          alignment: Alignment.center,
          children: <Widget>[
           Container(
             height: double.infinity,
             width: double.infinity,
             color: AppColor,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Lottie.asset('assets/nnn.json',
                     height: 200,
                     repeat: false,
                     controller: controller,
                     onLoaded:(LottieComposition){
                       controller.forward();
                       setState(() {

                       });
                     }),
                  //    height(50),
                  // CircularProgressIndicator(
                  //   color: Colors.white,
                  // ),
               ],
             ),
           )
          ],
        )
    );
  }
}
