import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopapp/shared/bloc_observer.dart';
import 'package:shopapp/shared/network/remote/cachehelper.dart';
import 'modules/pages/splash_screen.dart';
import 'shared/network/remote/dio_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity/connectivity.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  Cachehelper.init();
  await Firebase.initializeApp();
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
  Future<void>_updateConnectionStatus(ConnectivityResult result)async{
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
        home:_connectivityResult.name == 'none'?Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('conect to ${_connectivityResult.name}')
          ],
        ):SplashScreen()
    );
  }


}
