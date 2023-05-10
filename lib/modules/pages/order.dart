import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Layout/HomeLayout/home_page.dart';
import 'dart:ui' as ui;
import '../../shared/network/remote/cachehelper.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Order extends StatefulWidget {
  final Map order;
  final String route;

   Order({Key key, this.order, this.route}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {


  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage();
    super.initState();
  }
  double latitud = Cachehelper.getData(key: "latitude");
  double longitud = Cachehelper.getData(key: "longitude");
  String MyLocation = Cachehelper.getData(key: "myLocation");
  String img = 'assets/play.jpg';
  String msg = "تم الطلب!  جاري موافقة عليه";
  int activeIndex = 0;

  @override
  Widget build(BuildContext context){

    FirebaseMessaging.onMessage.listen((message){
      Map<String, dynamic> jsonMap = jsonDecode(message.data['payload']);
      if(int.tryParse(widget.order['data']['order_ref'])==int.tryParse(jsonMap['order_ref'])){

        if(jsonMap['driver']!=null){
          setState(() {
            widget.order['data']['driver'] = jsonMap['driver'];

          });
        }

        if(jsonMap["fulfillment_status"] == "accepted"){
          setState(() {
            widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
            widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
            msg = 'المطعم يحضر طلبك';
            img = "assets/Canari.png";
            activeIndex = 1;
          });
        }

        if(jsonMap["fulfillment_status"] == "ready"){
          setState(() {
            jsonMap['prospective_fulfillment_time'] = widget.order['data']['prospective_fulfillment_time'];
            jsonMap['prospective_delivery_time'] = widget.order['data']['prospective_delivery_time'];
            msg = 'طلبك جاهز للاستلام الآن';
            img = 'assets/delivery_guy.gif';
            activeIndex = 2;
          });
        }

        if(jsonMap["delivery_status"] == "pickup"){
          setState(() {
            widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
            widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
            msg = 'جاري توصيل طلبك';
            img = 'assets/delivery_guy.gif';
            activeIndex = 2;
          });

        }

        if(jsonMap["delivery_status"] == "delivered"){
          setState(() {
            widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
            widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
            widget.order['data']["delivery_status"] = jsonMap['delivery_status'];
            msg = 'تم توصيل طلبيتك';
            img = 'assets/sucsses.gif';
            activeIndex = 3;
          });

        }

        if(jsonMap["delivery_status"] == "returned"){
          setState(() {
            widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
            widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
            msg = 'تم رفض طلبيتك';
            img = 'assets/cancel.png';

          });

        }

        if(jsonMap["confirmation_status"] == "cancelled"){
          setState(() {
            widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
            widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
            msg = 'تم إلغاء طلبيتك';
            img = 'assets/cancel.png';

          });

        }

        if(jsonMap["fulfillment_status"] == "non-accepted"){
          setState(() {
            widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
            widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
            msg = 'تم إلغاء طلبيتك';
            img = 'assets/cancel.png';
          });

        }

      }
    });

    if(widget.order['data']["fulfillment_status"] == "accepted"){
      setState(() {
        msg = 'المطعم يحضر طلبك';
        img = "assets/Canari.png";
        activeIndex = 1;
      });
    }

    if(widget.order['data']["fulfillment_status"] == "ready"){
      setState(() {
        msg = 'طلبك جاهز للاستلام الآن';
        img = 'assets/delivery_guy.gif';
        activeIndex = 2;
      });
    }

    if(widget.order['data']["delivery_status"] == "pickup"){
      setState(() {
        msg = 'جاري توصيل طلبك';
        img = 'assets/delivery_guy.gif';
        activeIndex = 2;
      });
    }

    if(widget.order['data']["delivery_status"] == "delivered"){
      setState(() {
        msg = 'تم توصيل طلبيتك';
        img = 'assets/sucsses.gif';
        activeIndex = 3;
      });
    }

    if(widget.order['data']["delivery_status"] == "returned"){
      setState(() {
        msg = 'تم إلغاء طلبيتك';
        img = 'assets/cancel.png';

      });
    }

    if(widget.order['data']["confirmation_status"] == "cancelled"){
      setState(() {
        msg = 'تم إلغاء طلبيتك';
        img = 'assets/cancel.png';

      });
    }

    if(widget.order['data']["fulfillment_status"] == "non-accepted"){
      setState(() {
        msg = 'تم إلغاء طلبيتك';
        img = 'assets/cancel.png';

      });
    }


// Future<void>firebaseMessagingBackgroundHandler(RemoteMessage message,)async{
//   if (message.data!=null) {
//      Map<String, dynamic> jsonMap = jsonDecode(message.data['payload']);
//      printFullText('notification :${jsonMap.toString()}');
//
//     if(int.tryParse(widget.order['data']['order_ref'])==int.tryParse(jsonMap['order_ref'])){
//       if(jsonMap['driver']!=null){
//         setState(() {
//           widget.order['data']['driver'] = jsonMap['driver'];
//         });
//       }
//
//       if(jsonMap["fulfillment_status"] == "accepted"){
//         setState(() {
//           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
//           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
//           msg = 'المطعم يحضر طلبك';
//           img = "assets/Canari.png";
//         });
//       }
//
//       if(jsonMap["fulfillment_status"] == "ready"){
//         setState(() {
//           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
//           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
//           msg = 'طلبك جاهز للاستلام الآن';
//           img = "assets/Canari.png";
//         });
//       }
//
//       if(jsonMap["delivery_status"] == "pickup"){
//         setState(() {
//           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
//           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
//           msg = 'جاري توصيل طلبك';
//           img = 'assets/delivery_guy.gif';
//         });
//       }
//
//       if(jsonMap["delivery_status"] == "delivered"){
//         setState(() {
//           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
//           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
//           widget.order['data']["delivery_status"] = jsonMap['delivery_status'];
//           msg = 'تم توصيل طلبيتك';
//           img = 'assets/sucsses.gif';
//
//         });
//
//       }
//
//       if(jsonMap["delivery_status"] == "returned"){
//         setState(() {
//           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
//           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
//           widget.order['data']["delivery_status"] = jsonMap['delivery_status'];
//           msg = 'تم رفض طلبيتك';
//           img = 'assets/cancel.png';
//
//         });
//
//       }
//
//       if(jsonMap["confirmation_status"] == "cancelled"){
//         setState(() {
//           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
//           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
//           widget.order['data']["delivery_status"] = jsonMap['delivery_status'];
//           msg = 'تم إلغاء طلبيتك';
//           img = 'assets/cancel.png';
//
//         });
//
//       }
//
//       if(jsonMap["fulfillment_status"] == "non-accepted"){
//         setState(() {
//           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
//           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
//           widget.order['data']["delivery_status"] = jsonMap['delivery_status'];
//           msg = 'تم إلغاء طلبيتك';
//           img = 'assets/cancel.png';
//
//         });
//
//       }
//
//     }
//
//
//
//
//
//
//   }}



FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
  if (message.data!=null){
    Map<String, dynamic> jsonMap = jsonDecode(message.data['payload']);
    printFullText('notification :${jsonMap.toString()}');
     if(int.tryParse(widget.order['data']['order_ref'])==int.tryParse(jsonMap['order_ref'])){

       if(jsonMap['driver']!=null){
         setState((){
           widget.order['data']['driver'] = jsonMap['driver'];
         });
       }

       if(jsonMap["fulfillment_status"] == "accepted"){
         setState(() {
           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
           msg = 'المطعم يحضر طلبك';
           img = "assets/Canari.png";
           activeIndex = 1;
         });
       }

       if(jsonMap["fulfillment_status"] == "ready"){
         setState(() {
           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
           msg = 'طلبك جاهز للاستلام الآن';
           img = 'assets/delivery_guy.gif';
           activeIndex = 2;
         });
       }

       if(jsonMap["delivery_status"] == "pickup"){
         setState(() {
           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
           msg = 'جاري توصيل طلبك';
           img = 'assets/delivery_guy.gif';
           activeIndex = 2;
         });

       }

       if(jsonMap["delivery_status"] == "delivered"){
         setState(() {
           widget.order['data']['prospective_fulfillment_time'] = jsonMap['prospective_fulfillment_time'];
           widget.order['data']['prospective_delivery_time'] = jsonMap['prospective_delivery_time'];
           widget.order['data']["delivery_status"] = jsonMap['delivery_status'];
           msg = 'تم توصيل طلبيتك';
           img = 'assets/sucsses.gif';
           activeIndex = 3;
         });

       }



       if(jsonMap["delivery_status"] == "returned"){
         setState(() {
           widget.order['data']["delivery_status"] = jsonMap['delivery_status'];
           msg = 'تم رفض طلبيتك';
           img = 'assets/cancelled.png';
         });

       }

       if(jsonMap["confirmation_status"] == "cancelled"){
         setState(() {
           msg = 'تم إلغاء طلبيتك';
           img = 'assets/cancelled.png';

         });

       }

       if(jsonMap["fulfillment_status"] == "non-accepted"){
         setState(() {
           msg = 'تم إلغاء طلبيتك';
           img = 'assets/cancelled.png';

         });

       }

     }
  }
});

    return WillPopScope(
      onWillPop: ()async{
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
          latitude: latitud,
          longitude: longitud,
          myLocation: MyLocation,
        )), (route) => false);
        return true;
      },
      child: Directionality(
          textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * 0.3,
                  child:Image.asset(
                    img,
                   fit: widget.order['data']["confirmation_status"] == "cancelled" || widget.order['data']["delivery_status"] == "returned" || widget.order['data']["fulfillment_status"] == "non-accepted"?null:BoxFit.cover,
                  ),
              ),
              Positioned(
                  left:15,
                  top:40,
                  child: CircleAvatar(
                    maxRadius: 20,
                    backgroundColor: Colors.white,
                      child: IconButton(onPressed: (){
                        setState(() {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                          latitude: latitud,
                          longitude: longitud,
                          myLocation: MyLocation,
                          )), (route) => false);
                        });
                      }, icon: Icon(Icons.close,color: Colors.black,)))),
              Positioned(
                  child:
                  DraggableScrollableSheet(
                    initialChildSize: .4,
                    minChildSize: .4,
                    maxChildSize: .9,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0),
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)
                            ),
                            boxShadow:[
                              BoxShadow(
                                  blurRadius: 4,
                                  offset: Offset(0, 3),
                                  spreadRadius: 2,
                                  color: Colors.grey[350]
                              )
                            ]
                        ),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          children: [
                            widget.order['data']["confirmation_status"] == "cancelled" || widget.order['data']["delivery_status"] == "returned" || widget.order['data']["fulfillment_status"] == "non-accepted"?Padding(
                              padding: const EdgeInsets.only(left: 20,top: 0,right: 20),
                              child: Text('تم إلغاء طلبيتك',style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),),
                            ):
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20,top: 0,right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.order['data']["delivery_status"] == "delivered" ?Text('تم توصيل طلبيتك',style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),):height(0),
                                    widget.order['data']["delivery_status"] != "delivered"? Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Text('الوصول المتوقع',style: TextStyle(fontSize: 15),),
                                        height(10),
                                        widget.order['data']['prospective_fulfillment_time']!=''?
                                        Directionality(
                                          textDirection: ui.TextDirection.ltr,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text('${DateFormat('HH:mm').format(DateTime.parse(widget.order['data']['prospective_fulfillment_time']))} PM  -',
                                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                                              width(5),
                                              Text('${DateFormat('HH:mm').format(DateTime.parse(widget.order['data']['prospective_delivery_time']))} PM ',
                                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        ): Text('',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                                      ],
                                    ):height(0),
                                  ],
                                ),
                              ),
                            ),
                            height(20),
                            widget.order['data']["confirmation_status"] == "cancelled" || widget.order['data']["delivery_status"] == "returned" || widget.order['data']["fulfillment_status"] == "non-accepted"?height(0):
                            Column(
                             children: [
                               AnotherStepper(
                                 stepperList: [
                                   Stepper(
                                       title: 'تم الطلب',
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                       icon:Icons.fastfood,
                                       containerColor: AppColor
                                   ),
                                   activeIndex>=1?
                                   Stepper(
                                       title: 'جاري تحضير',
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                       icon:FontAwesomeIcons.bowlFood,
                                       containerColor: AppColor
                                   ):
                                   Stepper(
                                     title: 'جاري تحضير',
                                     fontWeight: FontWeight.bold,
                                     color: Colors.grey,
                                     icon:FontAwesomeIcons.bowlFood,
                                     containerColor:Colors.grey.shade300,
                                   ),
                                   activeIndex>=2?
                                   Stepper(
                                       title: "استلام الطلب",
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                       icon:Icons.delivery_dining,
                                       containerColor: AppColor
                                   ):
                                   Stepper(
                                       title: "استلام الطلب",
                                       fontWeight: FontWeight.bold,
                                       color: Colors.grey,
                                       icon:Icons.delivery_dining,
                                       containerColor: Colors.grey.shade300
                                   ),
                                   activeIndex>=3?
                                   Stepper(
                                       title: "تم التوصيل",
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                       icon:Icons.check,
                                       containerColor: AppColor
                                   ):
                                   Stepper(
                                       title: "تم التوصيل",
                                       fontWeight: FontWeight.bold,
                                       color: Colors.grey,
                                       icon:Icons.check,
                                       containerColor: Colors.grey.shade300
                                   ),
                                 ],
                                 stepperDirection: Axis.horizontal,
                                 iconWidth: 40,
                                 iconHeight: 40,
                                 activeBarColor: ui.Color(0xFFfb133a),
                                 inActiveBarColor: Colors.grey.shade300,
                                 inverted: true,
                                 verticalGap: 40,
                                 activeIndex: activeIndex,
                                 barThickness: 6,
                               ),
                               height(20),
                               widget.order['data']['driver']==null? devider():height(0),
                               widget.order['data']['driver']!=null? devider():height(0),
                               widget.order['data']['driver']==null ? height(0):widget.order['data']["delivery_status"] != "delivered"?
                               Container(
                                 height: 150,
                                 width: double.infinity,
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Container(
                                       height: 100,
                                       width: double.infinity,
                                       child: Padding(
                                         padding: const EdgeInsets.only(left: 15,right: 15),
                                         child: Row(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                                 Text('${widget.order['data']['driver']['name']}',style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 19
                                                 ),),
                                                 height(3),
                                                 Text('هو بطل التسليم الخاص بك لهذا اليوم',style: TextStyle(
                                                     fontWeight: FontWeight.w500,
                                                     fontSize: 13,
                                                     color: Color(0xff302f2f)
                                                 ),),
                                               ],
                                             ),
                                             Container(
                                               decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.circular(6),
                                                   boxShadow: [
                                                     BoxShadow(
                                                         color: Colors.grey[300],
                                                         spreadRadius: 1,
                                                         blurRadius: 5,
                                                         offset: Offset(2, 2)
                                                     )
                                                   ]
                                               ),
                                               height: 60,
                                               width: 65,
                                               child: ClipRRect(
                                                   borderRadius: BorderRadius.circular(6),
                                                   child: Image.asset("assets/rider.png",fit: BoxFit.cover,)
                                               ),
                                             )
                                           ],
                                         ),
                                       ),
                                     ),
                                     Container(
                                       height: 0.5,
                                       width: double.infinity,
                                       color: Colors.black38,
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 15,right: 15,top: 11),
                                       child: GestureDetector(
                                         onTap: (){
                                           showModalBottomSheet(
                                               context: context, builder: (context){
                                             return Column(
                                               crossAxisAlignment: CrossAxisAlignment.end,
                                               mainAxisAlignment: MainAxisAlignment.end,
                                               children: [
                                                 Container(
                                                   height: 250,
                                                   width: double.infinity,
                                                   child: Image.asset("assets/rider.png",fit: BoxFit.cover,),
                                                 ),
                                                 height(10),
                                                 Padding(
                                                   padding: EdgeInsets.only(left: 15,right: 15,top: 10),
                                                   child: Text('تواصل مع مندوب توصيل',style: TextStyle(
                                                       fontWeight: FontWeight.bold,
                                                       fontSize: 19
                                                   ),),
                                                 ),
                                                 height(5),
                                                 Padding(
                                                   padding: EdgeInsets.only(left: 15,right: 15,top: 10),
                                                   child: Text('${widget.order['data']['driver']['name']}',style: TextStyle(
                                                     fontWeight: FontWeight.w500,
                                                     fontSize: 17,
                                                   ),),
                                                 ),
                                                 height(15),
                                                 Padding(
                                                   padding:EdgeInsets.only(left: 15,right: 15,top: 10),
                                                   child: Text('على الطريق. لضمان سلامتهم ، قد لا يجيبون على الفور',style: TextStyle(
                                                     fontWeight: FontWeight.w400,
                                                     fontSize: 15,
                                                   ),),
                                                 ),
                                                 Spacer(),
                                                 Padding(
                                                   padding: EdgeInsets.only(left: 15,right: 15,top: 5),
                                                   child: InkWell(
                                                     onTap:(){
                                                       launch("tel://${widget.order['data']['driver']['phone']}");
                                                     },
                                                     child: Container(
                                                       decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(5),
                                                         color: AppColor,
                                                       ),
                                                       height: 55,
                                                       width: double.infinity,

                                                       child: Row(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         crossAxisAlignment: CrossAxisAlignment.center,
                                                         children: [
                                                           Icon(Icons.phone,color: Colors.white,),
                                                           width(7),
                                                           Text('اتصل',style: TextStyle(
                                                               fontWeight: FontWeight.bold,
                                                               color: Colors.white,
                                                               fontSize: 17
                                                           ),),
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 )
                                               ],
                                             );
                                           });
                                         },
                                         child: Row(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Text('تواصل معه',style: TextStyle(
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.w500
                                             ),),
                                             Icon(Icons.arrow_forward_ios_rounded)
                                           ],
                                         ),
                                       ),
                                     )
                                   ],
                                 ),

                               ):height(0),
                               widget.order['data']['driver'] !=null? widget.order['data']["delivery_status"] != "delivered"? devider():height(0):height(0),
                               widget.order['data']['driver'] !=null?widget.order['data']["delivery_status"] != "delivered"?height(30):height(20):height(0),

                             ],
                           ),
                            widget.order['data']["confirmation_status"] == "cancelled" || widget.order['data']["delivery_status"] == "returned" || widget.order['data']["fulfillment_status"] == "non-accepted"?devider():height(0),
                            Container(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Padding(
                                   padding:  EdgeInsets.only(left: 20,right: 20,top:widget.order['data']['driver'] !=null? 0:20),
                                   child: Text('توصيل إلى ',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black87,fontSize: 16)),
                                 ),

                                 Padding(
                                   padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                                   child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(Icons.location_on,color: AppColor,size: 32,),
                                       Expanded(
                                         child: Container(
                                           width: double.infinity,
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             mainAxisAlignment: MainAxisAlignment.start,
                                             children: [
                                               Text('شقة',style: TextStyle(
                                                   color: Colors.grey[700],
                                                   fontWeight: FontWeight.w600,
                                                   fontSize: 13),),
                                               height(5),
                                               Row(
                                                 children: [
                                                   Expanded(child:Text(
                                                      "${widget.order['data']['delivery_address']['label']}",
                                                     textAlign: TextAlign.start,
                                                     overflow: TextOverflow.ellipsis,
                                                     maxLines: 2,
                                                     style: TextStyle(
                                                         color: Colors.black,
                                                         fontWeight: FontWeight.bold,
                                                         fontSize: 15),
                                                   ),),
                                                   SizedBox(
                                                     width: 2,
                                                   ),
                                                 ],
                                               ),

                                             ],
                                           ),
                                         ),
                                       ),

                                       SizedBox(
                                         width: 2,
                                       ),

                                     ],
                                   ),
                                 ),




                               ],
                             ),
                           ),
                            height(20),
                            devider(),
                            height(30),

                            Container(
                              child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Text('طلبك من ',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black87,fontSize: 17)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${widget.order['data']['store']['name']}',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)),
                                              Image.network("${widget.order['data']['store']['logo']}",height: 55,),
                                            ],
                                          ),
                                        ),
                                       height(15),
                                      ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context,index){
                                            return Padding(
                                              padding: const EdgeInsets.only(left: 20,),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 5,right: 5),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 2),
                                                          child: Text('x${widget.order['data']['products'][index]['quantity']}',style:TextStyle(fontSize: 13.5,fontWeight: FontWeight.bold,color: AppColor),),
                                                        ),
                                                        width(10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text('${widget.order['data']['products'][index]['name']}',style: TextStyle(fontSize: 15.5,fontWeight: FontWeight.bold),),
                                                              Text(
                                                                '',
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontSize: 12.5,
                                                                    color: Color.fromARGB(255, 78, 78, 78), fontWeight: FontWeight.normal),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        width(15),
                                                        Text('${widget.order['data']['products'][index]['price']} درهم ',style: TextStyle(fontSize: 13.5,fontWeight: FontWeight.bold),),

                                                      ],
                                                    ),
                                                  ),
                                                  height(5),
                                                  ListView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                      itemBuilder:(
                                                          context,atributindex){
                                                        return Padding(
                                                          padding: const EdgeInsets.only(bottom: 25,top: 10),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 35),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text('${widget.order['data']['products'][index]['attributes'][atributindex]['name']}')
                                                                      ],
                                                                    ),
                                                                    Text('${widget.order['data']['products'][index]['attributes'][atributindex]['price']} درهم ',style: TextStyle(fontSize: 13.5,fontWeight: FontWeight.normal),),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      itemCount: widget.order['data']['products'][index]['attributes'].length,)
                                                ],
                                              ),
                                            );
                                          }, separatorBuilder: (context,index){
                                            return SizedBox(height: 5,);
                                      }, itemCount:widget.order['data']['products'].length)

                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            height(20),
                            devider(),
                            height(30),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20),
                                    child:Text('بيانات الدفع',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w500)),
                                  ),

                                  height(10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('وسيلة دفع '),
                                        width(5),
                                        Text('الدفع عند الاستلام',style: TextStyle(fontSize: 15.5,fontWeight: FontWeight.w400),)
                                      ],
                                    ),
                                  ),
                                  height(10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('ثمن توصيل'),
                                        width(5),
                                        Text('${widget.order['data']['delivery_price']} درهم ',style: TextStyle(fontSize: 15.5,fontWeight: FontWeight.w400),),                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            height(10),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('المجموع',style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold)),
                                  Text('${widget.order['data']['total']} درهم ',style: TextStyle(fontSize: 15.5,fontWeight: FontWeight.w400),),
                                ],
                              ),
                            ),
                            height(20),
                            devider(),
                            height(30),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20,right: 20),
                                        child:Text('دعم',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w500)),
                                      ),
                                     height(5),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 20,right: 20),
                                     child:  Text('طلب #${widget.order['data']['order_ref']}'),
                                     ),
                                      height(5),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: CircleAvatar(
                                      child: TextButton(
                                        onPressed: () async => await launch(
                                            "https://wa.me/+212619157091?text=رقم طلب : *${widget.order['data']['order_ref']}* \n مشكلتي : "),
                                        child: Image.asset('assets/what.png'),
                                      ),
                                      backgroundColor: Colors.grey[50],
                                      maxRadius: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height(10),


                          ],
                        ),
                      );
                    },
                  )
                  )
            ],
          )
        ),
      ),
    );
  }

  Container devider() {
    return Container(
                        height: 8,
                        color: Colors.grey[100],
                        width: double.infinity,
                      );
  }


  StepperData Stepper({String title,Color color,Color containerColor,FontWeight fontWeight,IconData icon}){
    return StepperData(
        title: StepperText(title,textStyle: TextStyle(
          color:color,
          fontSize: 12.5,
          fontWeight: fontWeight
        ),),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration:  BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child:Icon(icon, color: Colors.white),
        ));
  }
}
