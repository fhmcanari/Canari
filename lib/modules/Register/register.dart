import 'dart:convert';
import 'dart:io';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  const Register({Key key, this.routing, this.NoteController}) : super(key: key);
  @override
  State<Register> createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  var fbm = FirebaseMessaging.instance;
  final _key = UniqueKey();
  String urlwebview;
  String fcmtoken='';
  bool isloading = true;
  MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_FROM_STATE;
  final GlobalKey<FormState> otpkey = GlobalKey<FormState>();
  final GlobalKey<FormState> fromkey = GlobalKey<FormState>();
  var FirstnameController = TextEditingController();
  var LastnameController = TextEditingController();
  bool islogin = false;
  bool iswebView = false;
  bool isLoading=true;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String _platformVersion = 'Unknown';
  Future<void> initformState() async {
    String platformVersion;


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
        'Error:':'Failed to get platform version.'
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
      'id':build.id,
      'type':build.type,
      'device':build.device,
      'model':build.model,
      'hardware':build.hardware,
      'product':build.product,
      'brand':build.brand,
      'supported':build.supported32BitAbis

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
      'id':data.identifierForVendor
    };
  }
  String phoneNumber, verificationId;
  String otp, authStatus = "";
  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
        });
      },
      verificationFailed: (authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });

      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }
  @override
  void initState() {
    fbm.getToken().then((token){
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
    String device_id = Cachehelper.getData(key:"deviceId");



    return BlocProvider(
        create: (context)=>ShopCubit(),
        child: BlocConsumer<ShopCubit,ShopStates>(
            listener: (context,state){

            if(state is MyorderSucessfulState){
              navigateTo(context, Order(order: state.order));
            }
            },
            builder: (context,state){
              String access_token = Cachehelper.getData(key: "fcmtoken");
              return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                  ),
                  backgroundColor: Colors.white,
                  body:iswebView==false? Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('assets/CANARY-.png')),
                             height(50),
                          Form(
                            key: fromkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Text('اهلا بك في كناري',style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Hind"
                                  ),),
                                ),
                                height(15),
                                islogin==false?Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: buildTextFiled(
                                    onEditingComplete: (){
                                      if (fromkey.currentState.validate()) {
                                        fromkey.currentState.save();
                                      }
                                    },
                                    controller: FirstnameController,
                                    keyboardType: TextInputType.name,
                                    hintText: 'الاسم الأول',
                                    valid: 'الاسم الأول',
                                  ),
                                ):height(0),
                                islogin==false? height(25):height(0),
                                islogin==false? Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: buildTextFiled(
                                    onEditingComplete: (){
                                      if (fromkey.currentState.validate()) {
                                        fromkey.currentState.save();
                                      }
                                    },
                                    controller: LastnameController,
                                    valid: 'اسم العائلة',
                                    keyboardType: TextInputType.name,
                                    hintText: 'اسم العائلة',
                                  ),
                                ):height(0),

                                height(25),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                alphabetTextColor:
                                                AppColor,
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
                                                backgroundColor:
                                                AppColor,
                                                title:
                                                Text('Choisir un pays',
                                                  style: TextStyle(color: Colors.white),),
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
                                      SizedBox(width: 5,),
                                      Expanded(
                                        flex: 3,
                                        child: buildTextFiled(
                                            onEditingComplete: (){
                                              if (fromkey.currentState.validate()) {
                                                fromkey.currentState.save();
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            hintText: 'رقم الهاتف',
                                            valid: 'رقم الهاتف',
                                            onSaved: (number) {
                                              if (number.length == 9) {
                                                phoneNumber = "${phoneCode}${number}";
                                              } else {
                                                final replaced = number.replaceFirst(
                                                    RegExp('0'), '');
                                                phoneNumber = "${phoneCode}${replaced}";
                                                print(phoneNumber);
                                              }
                                            }
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                height(25),


                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (fromkey.currentState.validate()) {
                                        fromkey.currentState.save();
                                        verifyPhoneNumber(context);
                                        iswebView=true;
                                        setState(() {

                                        });
                                      }


                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: AppColor
                                      ),
                                      child: Center(
                                          child: isloading ? Text('التالي',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ) : CircularProgressIndicator(color: Colors.white)),
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
                                    islogin==false? Text('لدي حساب !'):Text('ليس لدي حساب !'),
                                    islogin==false? TextButton(onPressed:(){
                                      setState(() {
                                        islogin = true;
                                      });
                                    },
                                        child: Text('تسجيل الدخول', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),)):
                                    TextButton(onPressed:(){
                                      setState(() {
                                        islogin = false;
                                      });
                                    },
                                        child: Text('إنشاء حساب', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 16),))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ):
                  Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'تَحَقّق',
                                style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          height(6),
                          Text('انتضر قليلا ثم أدخل الرمز الذي أرسلناه لك للتو على رقمك ', style: TextStyle(fontSize: 17.0,color: Colors.grey[500]),textAlign: TextAlign.center),
                          TextButton(onPressed: (){
                            iswebView = false;
                            setState(() {

                            });
                          }, child: Text('تغيير رقم',style: TextStyle(
                              color: AppColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.8
                          ),)),

                          VerificationCode(
                            fillColor: Colors.grey[100],
                            fullBorder: true,
                            underlineUnfocusedColor: Colors.grey[100],
                            textStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
                            keyboardType: TextInputType.number,
                            underlineColor: AppColor,
                            length: 6,
                            cursorColor: Colors.blue,
                            margin: const EdgeInsets.all(5),
                            onCompleted: (String value) {
                              setState(() async {
                                code = value;
                                isLoading = false;
                                await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code)).then((value){
                                  if(islogin){
                                    if(FirebaseAuth.instance.currentUser!=null){
                                      fbm.getToken().then((token)async{
                                        fcmtoken = token;
                                        await DioHelper.postData(
                                          data:{
                                            "phone": "${phoneNumber}",
                                            "uid": "${FirebaseAuth.instance.currentUser.uid}",
                                            "device":{
                                              "token_firebase":"${fcmtoken}",
                                              "device_id":"z0f33s43p4",
                                              "device_name":"iphone",
                                              "ip_address":"192.168.1.1",
                                              "mac_address":"192.168.1.1"
                                            }
                                          },
                                          url: 'https://www.api.canariapp.com/v1/client/login',
                                        ).then((value) {
                                          printFullText(value.data.toString());
                                          Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                          Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                          Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                          Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                          Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                          setState(() {
                                            ShopCubit.get(context).CheckoutApi({
                                              "store_id":StoreId,
                                              "payment_method":'CASH',
                                              "delivery_address":{
                                                "label":MyLocation,
                                                "latitude":latitud,
                                                "longitude":longitud
                                              },
                                              "type":"delivery",
                                              "note":{
                                                "allergy_info":"${widget.NoteController.text}",
                                                "special_requirements":"${widget.NoteController.text}"
                                              },
                                              "products":dataService.itemsCart,
                                              "device_id":value.data['device_id']
                                            });
                                            isloading = true;
                                          });
                                        }).catchError((error){
                                          setState(() {
                                            Fluttertoast.showToast(
                                                msg: "ليس لديك حساب قم بانشاء واحد",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                webShowClose:false,
                                                backgroundColor: AppColor,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                            isloading =true;
                                            islogin = false;
                                            iswebView = false;
                                          });
                                        });
                                      });
                                    }
                                  }else{
                                    fbm.getToken().then((token)async{
                                      fcmtoken = token;
                                      await DioHelper.postData(
                                        data:{
                                          "first_name":FirstnameController.text,
                                          "last_name":LastnameController.text,
                                          "phone":"${phoneNumber}",
                                          "device":{
                                            "token_firebase":"${fcmtoken}",
                                            "device_id":"z0f33s43p4",
                                            "device_name":"iphone",
                                            "ip_address":"192.168.1.1",
                                            "mac_address":"192.168.1.1"
                                          }
                                        },
                                        url: 'https://www.api.canariapp.com/v1/client/register',
                                      ).then((value) {
                                        Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                        Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                        Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                        Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                        Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                        setState(() {
                                          ShopCubit.get(context).CheckoutApi({
                                            "store_id":StoreId,
                                            "payment_method":'CASH',
                                            "delivery_address":{
                                              "label":MyLocation,
                                              "latitude":latitud,
                                              "longitude":longitud
                                            },
                                            "type":"delivery",
                                            "note":{
                                              "allergy_info":"${widget.NoteController.text}",
                                              "special_requirements":"${widget.NoteController.text}"
                                            },
                                            "products":dataService.itemsCart,
                                            "device_id":value.data['device_id']
                                          });
                                          isloading = true;
                                        });
                                      }).catchError((error){
                                        setState(() {
                                          Fluttertoast.showToast(
                                              msg: "لديك حساب قم بتسجيل دخول",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              webShowClose:false,
                                              backgroundColor: AppColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                          isloading =true;
                                          islogin = true;
                                          iswebView = false;
                                        });
                                      });
                                    });
                                  }

                                });

                              });
                            },
                            onEditing: (bool value) {
                              setState(() {
                                onEditing = value;

                              });
                              if (!onEditing) FocusScope.of(context).unfocus();
                            },
                          ),
                          height(10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('لم تتلق رمز؟ '),
                              TextButton(onPressed: (){
                                verifyPhoneNumber(context);
                              }, child: Text('إعادة إرسال',style: TextStyle(
                                  color: AppColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.8
                              ),)),

                            ],
                          ),
                          height(6),
                          GestureDetector(
                            onTap: (){
                              isLoading = false;
                              FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code)).then((value) async {
                                await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code)).then((value){
                                  if(islogin){
                                    if(FirebaseAuth.instance.currentUser!=null){
                                      fbm.getToken().then((token)async{
                                        fcmtoken = token;
                                        await DioHelper.postData(
                                          data:{
                                            "phone": "${phoneNumber}",
                                            "uid": "${FirebaseAuth.instance.currentUser.uid}",
                                            "device":{
                                              "token_firebase":"${fcmtoken}",
                                              "device_id":"z0f33s43p4",
                                              "device_name":"iphone",
                                              "ip_address":"192.168.1.1",
                                              "mac_address":"192.168.1.1"
                                            }
                                          },
                                          url: 'https://www.api.canariapp.com/v1/client/login',
                                        ).then((value) {
                                          printFullText(value.data.toString());
                                          Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                          Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                          Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                          Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                          Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                          setState(() {
                                            Navigator.of(context).pop();
                                          });
                                        }).catchError((error){
                                          setState(() {
                                            Fluttertoast.showToast(
                                                msg: "ليس لديك حساب قم بانشاء واحد",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                webShowClose:false,
                                                backgroundColor: AppColor,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                            );
                                            isloading =true;
                                            islogin = false;
                                            iswebView = false;
                                          });
                                        });
                                      });
                                    }
                                  }else{
                                    fbm.getToken().then((token)async{
                                      fcmtoken = token;
                                      await DioHelper.postData(
                                        data:{
                                          "first_name":FirstnameController.text,
                                          "last_name":LastnameController.text,
                                          "phone":"${phoneNumber}",
                                          "device":{
                                            "token_firebase":"${fcmtoken}",
                                            "device_id":"z0f33s43p4",
                                            "device_name":"iphone",
                                            "ip_address":"192.168.1.1",
                                            "mac_address":"192.168.1.1"
                                          }
                                        },
                                        url: 'https://www.api.canariapp.com/v1/client/register',
                                      ).then((value) {
                                        Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                        Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                        Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                        Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                        Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                      }).catchError((error){
                                        setState(() {
                                          Fluttertoast.showToast(
                                              msg: "لديك حساب قم بتسجيل دخو",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              webShowClose:false,
                                              backgroundColor: AppColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                          isloading =true;
                                          islogin = false;
                                          iswebView = false;
                                        });
                                      });
                                    });
                                  }

                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:code!=null?AppColor:Colors.grey[400]
                                ),
                                child: Center(
                                    child: isLoading ? Text('تاكيد',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ) : CircularProgressIndicator(color: Colors.white)),
                                height: 58,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ],
                      ),


                    ],
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
      Function onEditingComplete,
      TextInputType keyboardType}) {
  return TextFormField(
    onEditingComplete:onEditingComplete,
    keyboardType: keyboardType,
    onSaved: onSaved,
    validator: (value) {
      RegExp arabicRegex = RegExp(r'[\u0600-\u06FF]');
      if (value == null || value.isEmpty) {
        return '${valid} لا يجب أن تكون فارغة ';
      }
      if(arabicRegex.hasMatch(value)){
        return 'الرجاء إدخال ${hintText} بالفرنسية';
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
        contentPadding: EdgeInsets.symmetric(vertical: 19.0,horizontal: 10),
      filled: true,
        hintText: '${hintText}',
        hintStyle: TextStyle(color: Color(0xFF7B919D), fontSize: 14)),
  );
}
