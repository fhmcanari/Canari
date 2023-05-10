import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/modules/pages/order.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'dart:ui' as ui;
import '../../Layout/shopcubit/shopcubit.dart';
import '../../shared/components/components.dart';
import '../../shared/network/remote/cachehelper.dart';
import 'checkout_page.dart';
class Myorder extends StatefulWidget {
  const Myorder({Key key}) : super(key: key);

  @override
  State<Myorder> createState() => _MyorderState();
}

class _MyorderState extends State<Myorder> with TickerProviderStateMixin{

  AnimationController controller;
  @override
  Widget build(BuildContext context) {
    Future<void>firebaseMessagingBackgroundHandler(RemoteMessage message,)async{
      if (message.notification!=null) {
       printFullText(message.notification.body);
      }
    }

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message){
      if (message.notification!=null) {
        printFullText(message.notification.body);
      }


    },);
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..Myorders(),
      child: BlocConsumer<ShopCubit,ShopStates>(
          listener: (context,state){
           if(state is MyorderSucessfulState){
             navigateTo(context,Order(
               order:state.order,
             ));
           }
          },
          builder: (context,state){
            String device_id = Cachehelper.getData(key:"deviceId");
            var cubit = ShopCubit.get(context);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar:
              AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Text(
                  'طلباتي',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              body:cubit.isload ?cubit.myorders.length>0?ListView.builder(
                physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cubit.myorders.length,
                  itemBuilder: (context,index){

                return Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: InkWell(
                        radius: 10,
                        borderRadius:BorderRadius.circular(5),
                        onTap: () async {
                          cubit.Myorder(cubit.myorders[index]['order_ref']);
                          cubit.isloading = false;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child:CachedNetworkImage(
                                        imageUrl: '${cubit.myorders[index]['store']['logo']}',
                                        placeholder: (context, url) =>
                                  Image.asset('assets/placeholder.png',fit: BoxFit.cover,),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        imageBuilder: (context, imageProvider){
                                          return Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        }
                                    ),

                                    ),
                              ),
                              width(15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    height(15),
                                    Text(
                                      '${cubit.myorders[index]['store']['name']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000000),
                                          fontSize: 15.5),
                                    ),
                                    height(5),
                                    ListView.builder(
                                      itemCount:cubit.myorders[index]['products'].length,
                                        shrinkWrap: true,
                                        itemBuilder: (context,prodIndex){
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 2),
                                            child: Text('x${cubit.myorders[index]['products'][prodIndex]['quantity']}',style:TextStyle(fontSize: 13.5,fontWeight: FontWeight.w300,color:Colors.grey),),
                                          ),
                                          width(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text('${cubit.myorders[index]['products'][prodIndex]['name']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color:Colors.grey),),
                                              ],
                                            ),
                                          ),
                                          width(15),

                                        ],
                                      );
                                    }),
                                    height(8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${cubit.myorders[index]['total']} درهم',style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),),

                                        cubit.myorders[index]['status']=='delivered'? height(0):Text(status(cubit.myorders[index]['status']),style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Color(0xff10a37f),
                                        ),),
                                       



                                      ],
                                    ),
                                    height(9),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );

              }):Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(Icons.fastfood_outlined,size: 120,color: Color(0xFF6b7280)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 20),
                    child: Text('ليس لديك أي طلبات حتى الآن. جرب أحد مطاعمنا الرائعة',style: TextStyle(color:Color(0xFF6b7280),fontSize: 16,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),
                  ),
                  height(50),




                ],
              ),):Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator(color: AppColor,))
                ],
              ),
            );
          },

      )

    );
  }
  status(String status) {
    if (status == 'pending') {
      return 'قيد الانتظار';
    }
    if (status == 'confirmation on process') {
      return 'جاري التأكيد';
    }
    if(status == 'on process'){
      return 'المطعم يحضر طلبك';
    }
    if(status == 'ready'){
      return 'طلبك جاهز للاستلام الآن';
    }
    if(status == 'delivery process'){
      return 'جاري توصيل طلبك';
    }
    if(status == 'delivered'){
      return 'تم توصيل طلبيتك';
    }
    if(status == 'non-accepted'){
      return 'تم رفض طلبيتك';
    }else{
      return 'تم إلغاء طلبيتك';
    }

  }

}
