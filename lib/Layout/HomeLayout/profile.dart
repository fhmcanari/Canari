import 'dart:convert';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
bool isloading = true;
String phoneNumber;
String phoneCode = '+212';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var fbm = FirebaseMessaging.instance;
  String fcmtoken='';
  final GlobalKey<FormState> fromkey = GlobalKey<FormState>();
  var FirstnameController = TextEditingController();
  var LastnameController = TextEditingController();
  var PhoneController = TextEditingController();
  bool islogin = false;
  bool isupdate = false;
  bool iswebview = false;
  String url;
  final _key = UniqueKey();
  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    print(fcmtoken);
    String firstname = Cachehelper.getData(key: "first_name");
    String lastname = Cachehelper.getData(key: "last_name");
    String phone = Cachehelper.getData(key: "phone");


    return BlocProvider(
      create: (context)=>ShopCubit(),
      child:
      BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){},
        builder: (context,state){
          print(phone);
          FirstnameController.text = firstname;
          LastnameController.text = lastname;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
              ),
              backgroundColor: Colors.white,

              body: firstname != null && isupdate==false?
              Padding(
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
              ):
              iswebview == false ?
              SingleChildScrollView(
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
                                    if(isupdate){
                                      if (fromkey.currentState.validate()) {
                                        fromkey.currentState.save();
                                        setState(() {
                                          isloading = false;
                                        });
                                        print({
                                          "first_name":FirstnameController.text,
                                          "last_name":LastnameController.text,
                                          "phone":"${phone}",
                                        });
                                        ShopCubit.get(context).UpdateProfile({
                                          "first_name":FirstnameController.text,
                                          "last_name":LastnameController.text,
                                          "phone":"${phone}",
                                        }).then((value){
                                          setState(() {});
                                          isupdate = false;
                                          isloading = true;
                                        });
                                      }

                                    }

                                    else{
                                      if (fromkey.currentState.validate()) {
                                        fromkey.currentState.save();
                                        setState(() {
                                          iswebview=true;
                                        });
                                      }
                                      if(iswebview){
                                        if (fromkey.currentState.validate()) {
                                          fromkey.currentState.save();
                                          var phone = phoneNumber.replaceFirst('+', '');
                                          url = "https://canariapp.com/otp?phoneNumber=${phone}";
                                        }
                                      }
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
              ):
              Stack(
                children: <Widget>[
                  WebView(
                    key: _key,
                    initialUrl:'${url}',
                    zoomEnabled: false,
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels:<JavascriptChannel>{
                      JavascriptChannel(
                        name: 'messageHandler',
                        onMessageReceived: (JavascriptMessage message) async {
                          Map<String, dynamic> data = jsonDecode(message.message);
                          print(data);
                          if(data['action']=='CHANGE_NUMBER'){
                            iswebview = false;
                            setState(() {

                            });
                          }
                          if(data['action'] == 'OTP_SUCCESS'){
                           if(islogin){
                           final authcredential = await FirebaseAuth.instance.signInAnonymously();
                           if(authcredential.user!=null){
                            fbm.getToken().then((token)async{
                              fcmtoken = token;
                              await DioHelper.postData(
                                data:{
                                  "phone": "${phoneNumber}",
                                  "uid": "${data['payload']['uid']}",
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
                           }

                           else{
                             try {
                               final authcredential = await FirebaseAuth.instance.signInAnonymously();
                               setState(() {
                                 isloading = false;
                               });
                               if(authcredential.user!=null){
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
                                           msg: "لديك حساب قم تسجيل الدخول",
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
                             } on FirebaseAuthException catch (e) {
                               setState(() {
                                 isloading = false;
                               });
                               print("error is ${e.message}");
                             }
                           }
                         }
                        },)},
                    onPageFinished: (finish){
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),

                  isLoading ?Center(child: CircularProgressIndicator(color: Colors.red,backgroundColor:Color(0xFFFFCDD2)))
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
