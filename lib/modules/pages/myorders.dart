import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/modules/pages/order.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../../Layout/shopcubit/shopcubit.dart';
import '../../shared/components/components.dart';
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
                      height: 100,
                      child: InkWell(
                        onTap: () async {
                          cubit.Myorder(cubit.myorders[index]['order_ref']);
                          cubit.isloading = false;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
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
                                            Image.network('https://www.happyeater.com/images/default-food-image.jpg',fit: BoxFit.cover),
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
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('#${cubit.myorders[index]['order_ref']}',style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff8d8d8d),
                                            fontSize: 12
                                          ),),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(3),
                                              color: Color(0xffecfdf5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('${cubit.myorders[index]['status']}',style: TextStyle(color: Color(0xFF34d399),
                                                fontSize: 12,fontWeight: FontWeight.bold,),),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    height(5),
                                    Text(
                                      '${cubit.myorders[index]['store']['name']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Color(0xFF000000),
                                          fontSize: 15),
                                    ),
                                    height(5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${DateFormat('dd/MM/yyyy').format(DateTime.parse(cubit.myorders[index]['created_at']))}'),
                                        Text("${cubit.myorders[index]['total']} درهم ",style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:Color(0xff696b6e),
                                            fontSize:11.8
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
                    child: Text('ليس لديك أي طلبات حتى الآن. جرب أحد مطاعمنا الرائعة ',style: TextStyle(color:Color(0xFF6b7280),fontSize: 16,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),
                  ),
                  height(50),




                ],
              ),):Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator())
                ],
              ),
            );
          },

      )

    );
  }

  double getTotal(List products) {
    var total = 0.0;
    products.forEach((element){
      // print(element);
       total = total + double.parse(element['price']) * element['quantity'];
      for(var i = 0 ;i<element['attributes'].length;i++){
        total = total + double.parse(element['attributes'][i]['price']);
      }

    });

    return total + 5;
  }
}
