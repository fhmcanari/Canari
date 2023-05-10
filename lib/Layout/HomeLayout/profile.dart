import 'dart:async';
import 'dart:convert';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopapp/modules/pages/privacy.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/modules/Register/register.dart';
import 'package:shopapp/modules/pages/myorders.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/remote/cachehelper.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../shopcubit/shopcubit.dart';
import 'home_page.dart';
bool isloading = true;
String phoneNumber;
String phoneCode = '+212';
bool onEditing = true;

final GlobalKey<FormState> otpkey = GlobalKey<FormState>();
final GlobalKey<FormState> fromkey = GlobalKey<FormState>();
class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var fbm = FirebaseMessaging.instance;
  String code;
  String fcmtoken='';
  final GlobalKey<FormState> fromkey = GlobalKey<FormState>();
  var FirstnameController = TextEditingController();
  var LastnameController = TextEditingController();
  var PhoneController = TextEditingController();
  var otpController = TextEditingController();
  bool islogin = false;
  bool isupdate = false;
  bool iswebview = false;

  bool isLoading=true;
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
  Widget build(BuildContext context) {


    String firstname = Cachehelper.getData(key: "first_name");
    String lastname = Cachehelper.getData(key: "last_name");
    String phone = Cachehelper.getData(key: "phone");

    return BlocProvider(
      create: (context)=>ShopCubit(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){},
        builder: (context,state){

          FirstnameController.text = firstname;
          LastnameController.text = lastname;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Colors.white,

            body: firstname != null && isupdate==false?
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            maxRadius: 20.5,
                            backgroundColor: Colors.black,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text('${firstname[0].toUpperCase()}${lastname[0].toUpperCase()}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            ),
                          ),
                          width(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('${firstname} ${lastname}',style: TextStyle(fontSize: 16,color: Colors.black)),
                              Row(
                                children:[
                                  Image.asset('assets/Morocco.png',height: 17),
                                  width(5),
                                  Text('Morocco',style: TextStyle(fontSize: 12,color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      height(50),
                      GestureDetector(
                        onTap: (){
                          navigateTo(context, Myorder());
                        },
                        child: Container(
                          height: 20,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(Icons.fastfood),
                              width(10),
                              Text('طلباتي',style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          width: double.infinity,
                        ),
                      ),
                      height(30),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isupdate = true;
                          });
                        },
                        child: Container(
                          height: 20,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              width(10),
                              Text('تعديل الحساب',style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),

                      height(30),
                      GestureDetector(
                        onTap: (){
                          navigateTo(context, Privacy());
                        },
                        child: Row(
                          children: [
                            Icon(Icons.privacy_tip_outlined),
                            width(10),
                            Text('خصوصية',style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                      height(25),
                      GestureDetector(
                        onTap: (){
                        Cachehelper.removeData(key: 'token');
                        Cachehelper.removeData(key: 'first_name');
                        Cachehelper.removeData(key: 'last_name');
                        Cachehelper.removeData(key: 'phone');
                        Cachehelper.removeData(key: 'deviceId');
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                          latitude: latitude,
                          longitude: longitude,
                          myLocation: myLocation,
                        )), (route) => false);
                        },
                        child: Container(
                          height: 20,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              width(10),
                              Text('تسجيل خروج',style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          width: double.infinity,
                        ),
                      ),

                      height(25),
                    ],
                  ),
                ),
              ),
            ):
            iswebview == false ?
            Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/CANARY-.png',)),
                    height(50),
                    Form(
                      key: fromkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(isupdate==false?'اهلا بك في كناري':'تعديل الحساب',style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Hind"
                                ),),
                              ),
                              height(20),
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
                              isupdate==false?
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
                                        controller: PhoneController,
                                          keyboardType: TextInputType.number,
                                          hintText: 'رقم الهاتف',
                                          valid: 'رقم الهاتف',
                                          onSaved: (number) {
                                            if (number.length == 9) {
                                              phoneNumber = "${phoneCode}${number}";
                                            } else {
                                              final replaced = number.replaceFirst(RegExp('0'), '');
                                              phoneNumber = "${phoneCode}${replaced}";
                                            }
                                          }
                                      ),
                                    ),
                                  ],
                                ),
                              ):height(0),
                              isupdate==false?height(25):height(0),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: GestureDetector(
                                  onTap: ()  {
                                  if (fromkey.currentState.validate()) {
                                      fromkey.currentState.save();
                                      if(isupdate){

                                        ShopCubit.get(context).UpdateProfile({
                                          "first_name":FirstnameController.text,
                                          "last_name":LastnameController.text,
                                          "phone":"${phone}",
                                        }).then((value){
                                          setState(() {});
                                          isupdate = false;
                                          isLoading = false;
                                          Navigator.of(context).pop();
                                        });
                                      }else{
                                        verifyPhoneNumber(context);
                                        iswebview =true;
                                      }
                                      setState(() {

                                      });
                                  }

                                    },
                                  child:Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColor
                                    ),
                                    child: Center(
                                        child: isloading ? Text(isupdate==false?'التالي':'تعديل',
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
                          height(10),
                          isupdate==false?  Row(
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
                          ):height(0),
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
                    Text('انتضر قليلا ثم أدخل الرمز الذي أرسلناه لك للتو على رقمك', style: TextStyle(fontSize: 17.0,color: Colors.grey[500]),textAlign: TextAlign.center),
                    TextButton(onPressed: (){
                      iswebview = false;
                      setState(() {

                      });
                    }, child: Text('تغيير رقم',
                      style: TextStyle(
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
                      cursorColor: AppColor,
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
                                      iswebview = false;
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
                                    iswebview = false;
                                  });
                                });
                              });
                            }

                        }).catchError((e){
                          print(e.toString());
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
                            print('sign in successfully');
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
                                      iswebview = false;
                                    });
                                  });
                                });
                              }
                            }else{
                              print('Regester');
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
                                    iswebview = false;
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
                              color:code!=null?AppColor:Colors.grey[300]
                          ),
                          child: Center(
                              child: isLoading ? Text(isupdate==false?'تاكيد':'تعديل',
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
