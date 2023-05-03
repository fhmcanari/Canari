import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:mac_address/mac_address.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';

import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../otp/getOtp.dart';

import '../../shared/network/remote/cachehelper.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../pages/order.dart';

enum MobileVerificationState { SHOW_MOBILE_FROM_STATE, SHOW_OTP_FROM_STATE }

class Register extends StatefulWidget {
  final String routing;
  final TextEditingController NoteController;
  const Register({Key key, this.routing, this.NoteController})
      : super(key: key);
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var fbm = FirebaseMessaging.instance;
  final _key = UniqueKey();
  String urlwebview;
  String fcmtoken = '';
  bool isloading = true;
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FROM_STATE;
  final GlobalKey<FormState> otpkey = GlobalKey<FormState>();
  final GlobalKey<FormState> fromkey = GlobalKey<FormState>();
  var FirstnameController = TextEditingController();
  var LastnameController = TextEditingController();
  bool islogin = false;
  bool iswebView = false;
  bool isLoading = true;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String _platformVersion = 'Unknown';
  Future<void> initformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // platformVersion = await GetMac.macAddress;
    } on PlatformException {
      platformVersion = 'Failed to get Device MAC Address.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.release': build.version.release,
      'fingerprint': build.host,
      'id': build.id,
      'type': build.type,
      'device': build.device,
      'model': build.model,
      'hardware': build.hardware,
      'product': build.product,
      'brand': build.brand,
      'supported': build.supported32BitAbis
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
      'id': data.identifierForVendor
    };
  }

  @override
  void initState() {
    fbm.getToken().then((token) {
      print(token);
      fcmtoken = token;
    });
    initPlatformState();
    initformState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double latitud = Cachehelper.getData(key: "latitude");
    double longitud = Cachehelper.getData(key: "longitude");
    String MyLocation = Cachehelper.getData(key: "myLocation");
    String device_id = Cachehelper.getData(key: "deviceId");

    return BlocProvider(
      create: (context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if (state is MyorderSucessfulState) {
            navigateTo(context, Order(order: state.order));
          }
        },
        builder: (context, state) {
          String access_token = Cachehelper.getData(key: "fcmtoken");
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
              ),
              backgroundColor: Colors.white,
              body: iswebView == false
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                              image: AssetImage(
                            'assets/CANARY-.png',
                          )),
                          height(50),
                          Form(
                            key: fromkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text(
                                    'اهلا بك في كناري',
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Hind"),
                                  ),
                                ),
                                height(15),
                                islogin == false
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: buildTextFiled(
                                          controller: FirstnameController,
                                          keyboardType: TextInputType.name,
                                          hintText: 'الاسم الأول',
                                          valid: 'الاسم الأول',
                                        ),
                                      )
                                    : height(0),
                                islogin == false ? height(25) : height(0),
                                islogin == false
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: buildTextFiled(
                                          controller: LastnameController,
                                          valid: 'اسم العائلة',
                                          keyboardType: TextInputType.name,
                                          hintText: 'اسم العائلة',
                                        ),
                                      )
                                    : height(0),
                                height(25),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 57,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  color: Colors.grey[300],
                                                  width: 1.5)),
                                          child: CountryListPick(
                                              theme: CountryTheme(
                                                initialSelection:
                                                    'Choisir un pays',
                                                labelColor: AppColor,
                                                alphabetTextColor: AppColor,
                                                alphabetSelectedTextColor:
                                                    Colors.red,
                                                alphabetSelectedBackgroundColor:
                                                    Colors.grey[300],
                                                isShowFlag: false,
                                                isShowTitle: false,
                                                isShowCode: true,
                                                isDownIcon: false,
                                                showEnglishName: true,
                                              ),
                                              appBar: AppBar(
                                                backgroundColor: AppColor,
                                                title: Text(
                                                  'Choisir un pays',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              initialSelection: '+212',
                                              onChanged: (CountryCode code) {
                                                print(code.name);
                                                print(code.dialCode);
                                                phoneCode = code.dialCode;
                                              },
                                              useUiOverlay: false,
                                              useSafeArea: false),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: buildTextFiled(
                                            keyboardType: TextInputType.number,
                                            hintText: 'رقم الهاتف',
                                            valid: 'رقم الهاتف',
                                            onSaved: (number) {
                                              if (number.length == 9) {
                                                phoneNumber =
                                                    "${phoneCode}${number}";
                                              } else {
                                                final replaced =
                                                    number.replaceFirst(
                                                        RegExp('0'), '');
                                                phoneNumber =
                                                    "${phoneCode}${replaced}";
                                                print(phoneNumber);
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                                height(25),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (fromkey.currentState.validate()) {
                                        fromkey.currentState.save();
                                        setState(() {
                                          iswebView = true;
                                        });
                                      }
                                      if (iswebView) {
                                        if (fromkey.currentState.validate()) {
                                          fromkey.currentState.save();
                                          var phone =
                                              phoneNumber.replaceFirst('+', '');
                                          urlwebview =
                                              "https://canariapp.com/otp?phoneNumber=${phone}";
                                          print(urlwebview);
                                        }
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: AppColor),
                                      child: Center(
                                          child: isloading
                                              ? Text(
                                                  'التالي',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : CircularProgressIndicator(
                                                  color: Colors.white)),
                                      height: 58,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                height(6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    islogin == false
                                        ? Text('لدي حساب !')
                                        : Text('ليس لدي حساب !'),
                                    islogin == false
                                        ? TextButton(
                                            onPressed: () {
                                              setState(() {
                                                islogin = true;
                                              });
                                            },
                                            child: Text(
                                              'تسجيل الدخول',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ))
                                        : TextButton(
                                            onPressed: () {
                                              setState(() {
                                                islogin = false;
                                              });
                                            },
                                            child: Text(
                                              'إنشاء حساب',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: <Widget>[
                        WebView(
                          key: _key,
                          initialUrl: '${urlwebview}',
                          zoomEnabled: false,
                          javascriptMode: JavascriptMode.unrestricted,
                          javascriptChannels: <JavascriptChannel>{
                            JavascriptChannel(
                              name: 'messageHandler',
                              onMessageReceived:
                                  (JavascriptMessage message) async {
                                Map<String, dynamic> data =
                                    jsonDecode(message.message);
                                if (data['action'] == 'CHANGE_NUMBER') {
                                  iswebView = false;
                                  setState(() {});
                                }
                                if (data['action'] == 'OTP_SUCCESS') {
                                  if (islogin) {
                                    final authcredential = await FirebaseAuth
                                        .instance
                                        .signInAnonymously();
                                    if (authcredential.user != null) {
                                      fbm.getToken().then((token) async {
                                        fcmtoken = token;
                                        await DioHelper.postData(
                                          data: {
                                            "phone": "${phoneNumber}",
                                            "uid": "${data['payload']['uid']}",
                                            "device": {
                                              "token_firebase": "${fcmtoken}",
                                              "device_id": "z0f33s43p4",
                                              "device_name": "iphone",
                                              "ip_address": "192.168.1.1",
                                              "mac_address": "192.168.1.1"
                                            }
                                          },
                                          url:
                                              'https://www.api.canariapp.com/v1/client/login',
                                        ).then((value) {
                                          printFullText(value.data.toString());
                                          Cachehelper.sharedPreferences
                                              .setString(
                                                  "deviceId",
                                                  value.data['device_id']
                                                      .toString());
                                          Cachehelper.sharedPreferences
                                              .setString(
                                                  "token", value.data['token']);
                                          Cachehelper.sharedPreferences
                                              .setString(
                                                  "first_name",
                                                  value.data['client']
                                                      ['first_name']);
                                          Cachehelper.sharedPreferences
                                              .setString(
                                                  "last_name",
                                                  value.data['client']
                                                      ['last_name']);
                                          Cachehelper.sharedPreferences
                                              .setString(
                                                  "phone",
                                                  value.data['client']
                                                      ['phone']);
                                          setState(() {
                                            ShopCubit.get(context).CheckoutApi({
                                              "store_id": StoreId,
                                              "payment_method": 'CASH',
                                              "delivery_address": {
                                                "label": MyLocation,
                                                "latitude": latitud,
                                                "longitude": longitud
                                              },
                                              "type": "delivery",
                                              "note": {
                                                "allergy_info":
                                                    "${widget.NoteController.text}",
                                                "special_requirements":
                                                    "${widget.NoteController.text}"
                                              },
                                              "products": dataService.itemsCart,
                                              "device_id":
                                                  value.data['device_id']
                                            });
                                            isloading = true;
                                          });
                                        }).catchError((error) {
                                          setState(() {
                                            printFullText(error.toString());
                                            Fluttertoast.showToast(
                                                msg:
                                                    "ليس لديك حساب قم بانشاء واحد",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                webShowClose: false,
                                                backgroundColor: AppColor,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            iswebView = false;
                                          });
                                        });
                                      });
                                    }
                                  } else {
                                    try {
                                      final authcredential = await FirebaseAuth
                                          .instance
                                          .signInAnonymously();
                                      setState(() {
                                        isloading = false;
                                      });
                                      if (authcredential.user != null) {
                                        fbm.getToken().then((token) async {
                                          fcmtoken = token;
                                          await DioHelper.postData(
                                            data: {
                                              "first_name":
                                                  FirstnameController.text,
                                              "last_name":
                                                  LastnameController.text,
                                              "phone": "${phoneNumber}",
                                              "device": {
                                                "token_firebase": "${fcmtoken}",
                                                "device_id": "z0f33s43p4",
                                                "device_name": "iphone",
                                                "ip_address": "192.168.1.1",
                                                "mac_address": "192.168.1.1"
                                              }
                                            },
                                            url:
                                                'https://www.api.canariapp.com/v1/client/register',
                                          ).then((value) {
                                            Cachehelper.sharedPreferences
                                                .setString(
                                                    "deviceId",
                                                    value.data['device_id']
                                                        .toString());
                                            Cachehelper.sharedPreferences
                                                .setString("token",
                                                    value.data['token']);
                                            Cachehelper.sharedPreferences
                                                .setString(
                                                    "first_name",
                                                    value.data['client']
                                                        ['first_name']);
                                            Cachehelper.sharedPreferences
                                                .setString(
                                                    "last_name",
                                                    value.data['client']
                                                        ['last_name']);
                                            Cachehelper.sharedPreferences
                                                .setString(
                                                    "phone",
                                                    value.data['client']
                                                        ['phone']);
                                            ShopCubit.get(context).CheckoutApi({
                                              "store_id": StoreId,
                                              "payment_method": 'CASH',
                                              "delivery_address": {
                                                "label": MyLocation,
                                                "latitude": latitud,
                                                "longitude": longitud
                                              },
                                              "type": "delivery",
                                              "note": {
                                                "allergy_info":
                                                    "${widget.NoteController.text}",
                                                "special_requirements":
                                                    "${widget.NoteController.text}"
                                              },
                                              "products": dataService.itemsCart,
                                              "device_id": device_id
                                            });
                                            setState(() {
                                              isloading = true;
                                            });
                                          }).catchError((error) {
                                            setState(() {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "لديك حساب قم تسجيل الدخول",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  webShowClose: false,
                                                  backgroundColor: AppColor,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              isloading = true;
                                              islogin = true;
                                              iswebView = false;
                                            });
                                          });
                                        });
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                        isloading = false;
                                      });
                                      print("error is ${e.message}");
                                      Fluttertoast.showToast(
                                          msg: "${e.message}",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          webShowClose: false,
                                          backgroundColor: AppColor,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  }
                                }
                              },
                            )
                          },
                          onPageFinished: (finish) {
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                        isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Colors.red,
                                    backgroundColor: Color(0xFFFFCDD2)))
                            : Stack(),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildTextFiled(
    {String hintText,
    TextEditingController controller,
    Function ontap,
    String valid,
    Function onSaved,
    TextInputType keyboardType}) {
  return TextFormField(
    keyboardType: keyboardType,
    onSaved: onSaved,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '${valid} لا يجب أن تكون فارغة ';
      }
      return null;
    },
    onTap: ontap,
    controller: controller,
    decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 19.0, horizontal: 10),
        filled: true,
        hintText: '${hintText}',
        hintStyle: TextStyle(color: Color(0xFF7B919D), fontSize: 14)),
  );
}
