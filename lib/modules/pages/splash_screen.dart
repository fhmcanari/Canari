
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shopapp/modules/pages/serviceIosoff.dart';
import 'package:shopapp/modules/pages/serviceOff.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'dart:io';
import '../../Layout/HomeLayout/home_page.dart';
import '../../shared/network/remote/cachehelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  AnimationController controller;
  bool ServiceStatus = true;
  bool statusServiceIos = false;
  String ServicetimingStart =null;
  double latitud = Cachehelper.getData(key: "latitude");
  double longitud = Cachehelper.getData(key: "longitude");
  String MyLocation = Cachehelper.getData(key: "myLocation");
  Future<bool>serviceStatus() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    bool remoteConfigVersion = remoteConfig.getBool('serviceStatus');

    setState(() {
      ServiceStatus = remoteConfigVersion;
    });

    return remoteConfigVersion;

  }

  Future<bool>ServiceIosStatus() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    bool remoteConfigStatus = remoteConfig.getBool('statusServiceIos');
     if(remoteConfigStatus == false){
       setState(() {
         ServicetimingStart = remoteConfig.getString('ServicetimingStart');
         print(remoteConfig.getString('ServicetimingStart'));
       });
     }
    setState(() {
      statusServiceIos = remoteConfigStatus;
    });

    return remoteConfigStatus;

  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceStatus();
      ServiceIosStatus();
    });
    controller = AnimationController(vsync: this,duration: Duration(seconds:3));
    controller.addStatusListener((status)async {
      if (status==AnimationStatus.completed){
        if(Platform.isIOS){
          if(ServiceStatus){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=>
                    MyHomePage(
                      latitude: latitude,
                      longitude: longitude,
                      myLocation: myLocation,
                    )), (route) => false);
          }else{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=>ServiceOff()), (route) => false);
          }
        }
        else if(Platform.isAndroid){
          if(statusServiceIos){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=>
                    MyHomePage(
                      latitude: latitude,
                      longitude: longitude,
                      myLocation: myLocation,
                    )), (route) => false);
          }else{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=>ServiceIosOff(ServicetimingStart: ServicetimingStart,)), (route) => false);
          }

        }

        controller.reset();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print('Status :${ServiceStatus}');
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
