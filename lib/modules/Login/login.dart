import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/shared/network/remote/cachehelper.dart';

import '../../Layout/shopcubit/shopcubit.dart';
import '../../otp/getOtp.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../Register/register.dart';
import '../pages/order.dart';

class Login extends StatefulWidget {
  final TextEditingController FirstNameController;
  final TextEditingController LastNameController;
  final TextEditingController EmailController;
  final TextEditingController PasswordController;
  const Login({ Key key, this.FirstNameController, this.LastNameController, this.EmailController, this.PasswordController }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String uid;
  var fbm = FirebaseMessaging.instance;
  String fcmtoken='';
  MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_FROM_STATE;
  Future SignInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthcredential)
  async {
    try {
      final authcredential = await FirebaseAuth.instance.signInWithCredential(phoneAuthcredential);

      setState(() {
        isloading = false;
      });
      if (authcredential.user != null) {
           print(authcredential.user.uid);
           uid = authcredential.user.uid;
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isloading = false;
      });
      print("error is ${e.message}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return
      BlocProvider(
      create: (context)=>ShopCubit(),
        child:BlocConsumer<ShopCubit,ShopStates>(
           listener: (context,state){
             if(state is MyorderSucessfulState){
               navigateTo(context, Order(order: state.order,));
             }
           },
          builder: (context,state){
             return Scaffold(
               backgroundColor: Colors.white,
               appBar: AppBar(
                 backgroundColor: Colors.white,
                 elevation: 0,
               ),
               body:Center(
                 child: SingleChildScrollView(
                   child: Form(
                     key: fromkey,
                     child: Center(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text('Sign In to Canari',style: TextStyle(
                               fontSize: 22,
                               fontWeight: FontWeight.bold
                           ),),
                           SizedBox(height: 20,),
                           Padding(
                             padding: const EdgeInsets.only(left: 20, right: 20),
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Expanded(
                                   child: Container(
                                     height: 60,
                                     decoration: BoxDecoration(
                                         borderRadius:
                                         BorderRadius.circular(4),
                                         border: Border.all(
                                             color: Color(0xFFf37021),
                                             width: 2)),
                                     child: CountryListPick(
                                         theme: CountryTheme(
                                           initialSelection:
                                           'Choisir un pays',
                                           labelColor: Color(0xFFf37021),
                                           alphabetTextColor:
                                           Color(0xFFf37021),
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
                                           Color(0xFFf37021),
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
                                       keyboardType: TextInputType.number,
                                       hintText: 'Number',
                                       valid: 'Number',
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
                           SizedBox(height: 20,),
                           Padding(
                             padding: const EdgeInsets.only(left: 20, right: 20),
                             child: GestureDetector(
                               onTap: () async {
                                 if (fromkey.currentState.validate()) {
                                   fromkey.currentState.save();
                                   setState(() {
                                     isloading = false;
                                   });
                                   try {
                                     final authcredential =
                                     await FirebaseAuth.instance.signInAnonymously();
                                     setState(() {
                                       isloading = false;
                                     });
                                     if (authcredential.user != null) {
                                       authcredential.user.updateDisplayName('${phoneNumber}');
                                       uid = authcredential.user.uid;
                                       fbm.getToken().then((token){
                                         print(token);
                                         fcmtoken = token;
                                         ShopCubit.get(context).LoginApi(
                                           {
                                             "phone":"${phoneNumber}",
                                             "uid":"${uid}"
                                           }
                                         );
                                         Cachehelper.sharedPreferences.setString("fcmtoken",token).then((value) {
                                           print('token fcm is saved');
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


                               },
                               child: Container(
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(5),
                                     color: AppColor

                                 ),
                                 child: Center(
                                     child: isloading ? Text('Next',
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
                           SizedBox(height: 5,),
                           Row(
                             crossAxisAlignment:  CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('You Don\'t have an account ?'),
                               TextButton(onPressed: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context){
                                   return Register();
                                 }));
                               }, child: Text('Register',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16),))
                             ],
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               )
             );
          },
        )

      );
  }

}