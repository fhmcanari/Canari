import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopapp/shared/bloc_observer.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/remote/cachehelper.dart';
import 'Layout/HomeLayout/home_page.dart';
import 'modules/pages/splash_screen.dart';
import 'modules/pages/update.dart';
import 'shared/network/remote/dio_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<bool> checkupdate() async {
  final info = await PackageInfo.fromPlatform();
  String appVersion = info.buildNumber;
  printFullText(appVersion);
  RemoteConfig remoteConfig = RemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 60),
      minimumFetchInterval: Duration(seconds: 1)));
  await remoteConfig.fetchAndActivate();
  String remoteConfigVersion = remoteConfig.getString('appVersion');
  printFullText(remoteConfigVersion);
  if (remoteConfigVersion.compareTo(appVersion) == 1)
    return true;
  else
    return false;
}

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: AppColor),
            height(5),
            Text(
              '! معذرة ',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            height(20),
            Text('حدث خطأ ما. أعد المحاولة من فضلك'),
          ],
        ),
      ));
  DioHelper.init();
  Cachehelper.init();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  @override
  void initState() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'CanariApp',
        theme: ThemeData(
          fontFamily: 'Almarai',
          appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.white,
          )),
        ),
        debugShowCheckedModeBanner: false,
        home: InializeWidget());
  }
}

class InializeWidget extends StatefulWidget {
  const InializeWidget({Key key}) : super(key: key);

  @override
  State<InializeWidget> createState() => _InializeWidgetState();
}

class _InializeWidgetState extends State<InializeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: checkupdate(),
      builder: (BuildContext context, snapshot) {
        return snapshot.data == true ? Update() : SplashScreen();
      },
    ));
  }
}
