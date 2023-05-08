import 'dart:collection';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopapp/Layout/HomeLayout/profile.dart';
import 'package:shopapp/Layout/HomeLayout/selectLocation.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/modules/pages/filters.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/widgets/categories.dart';
import 'package:shopapp/widgets/resturant.dart';
import 'package:shopapp/widgets/resturantGridl.dart';
import 'package:shopapp/widgets/resturantList.dart';
import '../../modules/pages/myorders.dart';
import '../../modules/pages/order.dart';
import '../../shared/network/remote/cachehelper.dart';
import '../../widgets/sliders.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

Future<void>firebaseMessagingBackgroundHandler(RemoteMessage message,)async{
  if (message.notification!=null) {
    print('${message.notification.body}');
  }
}

class MyHomePage extends StatefulWidget {
  final String myLocation;
  final double latitude;
  final double longitude;
  const MyHomePage({Key key, this.myLocation, this.latitude, this.longitude}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // final Connectivity _connectivity = Connectivity();
  // ConnectivityResult _connectivityResult = ConnectivityResult.none;
  //
  //
  // Future<void>_updateConnectionStatus(ConnectivityResult result)async{
  //   setState(() {
  //     _connectivityResult = result;
  //   });
  // }


  Future getPostion()async{
    bool services;
    services = await Geolocator.isLocationServiceEnabled();
    print(services);
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      return false;
    }
    return true;
  }




   HashSet selectFilters = new HashSet();

  var fbm = FirebaseMessaging.instance;
    
    String fcmtoken='';
   @override
  void initState(){
     FirebaseMessaging.instance.getInitialMessage();
     getPostion();
     _handleLocationPermission();
     fbm.getToken().then((token){
       print(token);
       fcmtoken = token;
     });
    super.initState();
  }
   
   bool islist = true;
   String text ='';
   Map json = {};
   var price;
   @override
  Widget build(BuildContext context) {

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // FirebaseMessaging.onMessage.listen((message){
    //   if(message.notification!=null){
    //     Map<String, dynamic> jsonMap = jsonDecode(message.data['payload']);
    //     json["data"] = jsonMap;
    //
    //     printFullText(json.toString());
    //     navigateTo(context,Order(
    //       order:json,
    //       route: 'myorders',
    //     ));
    //   }
    // },);
    //
    //

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification!=null){
        Map<String, dynamic> jsonMap = jsonDecode(message.data['payload']);
        json["data"] = jsonMap;

        printFullText(json.toString());
        navigateTo(context,Order(
          order:json,
          route: 'myorders',
        ));
      }
    });

     double latitud = Cachehelper.getData(key: "latitude");
     double longitud = Cachehelper.getData(key: "longitude");
     String MyLocation = Cachehelper.getData(key: "myLocation");


     final String formatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
     print(formatted);

    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..Myorders()
      ..getStoresData(latitude: latitud==null?27.149890:latitud,longitude: longitud==null?-13.199970:longitud)..getcategoriesData()..getSliders(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if(state is MyorderSucessfulState){
            navigateTo(context,Order(
              order:state.order,
              route: 'myorders',
            ));
          }
          if(state is GetFilterDataLoadingState){
            Navigator.pop(context);
            setState(() {
              navigateTo(context, Filters(selectCategories: selectFilters,text: text,));
            });
          }
        },
        builder: (context, state) {
          var cubit = ShopCubit.get(context);

          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              appBar:appbar(context,myLocation: MyLocation==null?'اختر موقع':MyLocation,icon: Icons.person,
                  onback: (){
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context)=>SelectLocation()), (route) => false);
                  },
                  ontap: (){
                navigateTo(context, Profile());
              },iconback: Icons.keyboard_arrow_down),
              backgroundColor: Colors.white,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton:cubit.isloading?cubit.myorders!=null && cubit.myorders.length>0 && cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                  .where((e)=>e['status']!='delivered' && e['status']!='non-accepted'&& e['status']!='failed').toList().length!=0?FloatingActionButton.extended(
                 extendedPadding: EdgeInsetsDirectional.only(start: 7.0, end: 7.0) ,
                  backgroundColor: Colors.white,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  onPressed: (){
                    if(cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                        .where((e)=>e['status']!='delivered' && e['status']!='non-accepted'&& e['status']!='failed').toList().length==1){
                   cubit.Myorder(cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                       .where((e)=>e['status']!='delivered' && e['status']!='non-accepted'&& e['status']!='failed').toList()[0]['order_ref']);
                   cubit.isload = false;
                    }else{
                     navigateTo(context, Myorder());
                    }
                  },
                  label: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                  .where((e)=>e['status']!='delivered' && e['status']!='non-accepted'&& e['status']!='failed').toList().length>0? Container(
                                  height: 35,width: 35,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color:Color.fromARGB(255, 253, 106, 95)),
                                  child:cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                      .where((e)=>e['status']!='delivered' && e['status']!='non-accepted'&& e['status']!='failed').toList().length==1?ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child:CachedNetworkImage(
                                          imageUrl: '${cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                              .where((e)=>e['status']!='delivered' && e['status']!='non-accepted'&& e['status']!='failed').toList()[0]['store']['logo']}',
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

                                  ):Center(
                                        child: Text('${cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                            .where((e)=>e['status']!='delivered' && e['status']!='failed').toList().length}',style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                  ),),
                                      )):height(0),
                              width(10),
                              Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  height(2),
                                   if(cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                       .where((e)=>e['status']!='delivered' && e['status']!='failed').toList().length==1)
                                   Text(status(cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                       .where((e)=>e['status']!='delivered' && e['status']!='failed').toList()[0]['status']),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 11.5,color:Color(0xFF25d366)),),
                                  cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                      .where((e)=>e['status']!='delivered' && e['status']!='failed').toList().length==1?height(2):height(8),
                                  cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                      .where((e)=>e['status']!='delivered' && e['status']!='failed').toList().length>0?Column(
                                    children: [
                                      cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                          .where((e)=>e['status']!='delivered' && e['status']!='failed').toList().length==1?Text('${cubit.myorders.where((element) => DateFormat('dd/MM/yyyy').format(DateTime.parse(element['created_at']))==DateFormat('dd/MM/yyyy').format(DateTime.now())).toList()
                                          .where((e)=>e['status']!='delivered' && e['status']!='failed').toList()[0]['store']['name']}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.5,color:Colors.black),)
                                          :Text('رؤية طلبات',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.5,color:Colors.black),),
                                    ],
                                  ):height(0),
                                ],
                              ),
                            ],),
                        ],
                      ),
                      width(155),
                      Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 15,),
                    ],
                  )
              ):height(0):height(0),

              body:SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SearchBarAndFilter(context),
                          width(7),
                          GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                  isScrollControlled:true,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return Filter(cubit, context);
                                  });
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color:Color.fromARGB(255, 250, 250, 250) ,
                                  borderRadius: BorderRadius.circular(7),
                                ),

                                child: Image.asset('assets/filter.png',color:Color.fromARGB(255, 68, 71, 71),)),
                          ),
                        ],
                      ),
                    ),
                    height(9),
                    Category(cubit: cubit,selectFilters:selectFilters),
                    height(5),
                    Sliders(cubit: cubit,selectFilters:selectFilters),
                     height(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        title(text: 'بالقرب مني',size: 16,color:Colors.black),
                      ],
                    ),
                    height(10),
                    Resturant(cubit: cubit),
                    if(cubit.stores.where((element) => element['delivery_price']==0).toList().length>0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        title(text: 'توصيل مجاني',size: 16,color:Colors.black),
                      ],
                    ),
                    height(10),
                    cubit.stores.where((element) => element['delivery_price']==0).toList().length>0? Resturant(cubit: cubit,status:"freedelivery"):height(0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: title(text: 'جميع المطاعم',size: 16,color:Colors.black),
                        ),
                        height(7),
                        
                        Padding(
                          padding: const EdgeInsets.only(right: 20,left: 20),
                          child: Container(
                            height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: Color.fromARGB(255, 230, 230, 230)
                            )
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 width(5),
                                GestureDetector(
                                  onTap: (){
                                     setState(() {
                                      islist = true;
                                     });
                                  },
                                  child: Container(
                                    child: Icon(Icons.monitor_rounded,size: 20,color:islist==false?Color.fromARGB(255, 230, 230, 230):Colors.red,)),
                                ),
                                width(10),
                                Container(
                                  height: 15,
                                  width: 0.4,
                                  color: Color.fromARGB(255, 184, 184, 184),
                                ),
                                width(10),
                                GestureDetector(
                                   onTap: (){
                                     setState(() {
                                      islist = false;
                                     });
                                  },
                                  child: Icon(Icons.list_rounded,size: 23,color:islist!=false?Color.fromARGB(255, 230, 230, 230):AppColor,),
                                ),
                                width(5),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                    height(10),
                  cubit.isloading?Column(
                     children: [
                       islist==false?
                       ListView.separated(

                           separatorBuilder: (context, index){
                             return Divider(
                               height: 2,
                             );
                           },
                           itemCount: cubit.stores.length,
                           reverse: true,
                           shrinkWrap:true,
                           physics: BouncingScrollPhysics(),
                           itemBuilder: (context, index) {
                             return Padding(
                               padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                               child: ResturantList(Restaurant:cubit.stores[index],id:cubit.stores[index]['id']),
                             );
                           }):ListView.builder(
                           reverse: true,
                           itemCount: cubit.stores.length,
                           shrinkWrap:true,
                           physics: BouncingScrollPhysics(),
                           itemBuilder: (context, index) {
                             return Padding(
                               padding: const EdgeInsets.only(left: 20,right: 20,bottom: 15),
                               child: ResturantGridl(Restaurant: cubit.stores[index],id:cubit.stores[index]['id'],size: 220.0),
                             );
                           }),
                     ],
                   ):
                  ListView.builder(
                    shrinkWrap: true,
                      itemCount: 5,

                      itemBuilder: (context,index){
                     return Padding(
                       padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
                       child: Container(
                         child: Row(
                           children: [
                             Padding(
                               padding: const EdgeInsets.only(left: 0,bottom: 0,right: 5),
                               child: Shimmer.fromColors(
                                 baseColor: Colors.grey[300],
                                 period: Duration(seconds: 2),
                                 highlightColor: Colors.grey[100],
                                 child: Container(
                                   width: 75,
                                   height: 75,
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(5),
                                       color: Colors.grey
                                   ),
                                 ),
                               ),
                             ),
                             Expanded(
                               child: Padding(
                                 padding:EdgeInsets.only(left: 12,right: 12),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Row(
                                       children: [
                                         Shimmer.fromColors(
                                           baseColor: Colors.grey[300],
                                           period: Duration(seconds: 2),
                                           highlightColor: Colors.grey[100],
                                           child: Container(
                                             child: Text(
                                               'Starbucks',
                                               style:TextStyle(
                                                   fontWeight: FontWeight.normal,
                                                   color: Color(0xFF000000),
                                                   fontSize: 15),
                                             ),
                                             color: Colors.grey,
                                           ),
                                         ),
                                       ],
                                     ),
                                     height(3),


                                     height(5),
                                     Shimmer.fromColors(
                                       baseColor: Colors.grey[300],
                                       period: Duration(seconds: 2),
                                       highlightColor: Colors.grey[100],
                                       child: Container(
                                         color: Colors.grey,
                                         child: Row(
                                           children: [
                                             Icon(Icons.star,color: Colors.yellow,size: 14,),
                                             width(5),
                                             Text(
                                                 '11 Excellent',
                                                 style: TextStyle(
                                                     fontSize:10.5,
                                                     color: Color.fromARGB(255, 68, 71, 71), fontWeight: FontWeight.w500)
                                             ),
                                             width(5),
                                             Container(
                                               height: 10,
                                               width: 1,
                                               color: Colors.black,
                                             ),
                                             width(5),
                                             Row(
                                               children: [
                                                 Icon(Icons.timer_outlined,color: Colors.black,size: 14,),
                                                 width(2.5),
                                                 Text(
                                                     '12 min',
                                                     style: TextStyle(
                                                         fontSize:10.5,
                                                         color: Color.fromARGB(255, 78, 78, 78), fontWeight: FontWeight.w500)
                                                 ),
                                                 width(5),
                                                 Container(
                                                   height: 10,
                                                   width: 1,
                                                   color: Colors.black,
                                                 ),
                                                 width(5),
                                                 Row(
                                                   children: [
                                                     Icon(Icons.delivery_dining_outlined,color: Colors.black,size: 14,),
                                                     width(5),
                                                     Text(
                                                         'Free Delivery',
                                                         style: TextStyle(
                                                             fontSize:10.5,
                                                             color: Color.fromARGB(255, 78, 78, 78), fontWeight: FontWeight.w500)
                                                     ),
                                                   ],
                                                 ),
                                               ],
                                             ),
                                           ],
                                         ),
                                       ),
                                     ),
                                     height(3),
                                     Shimmer.fromColors(
                                       baseColor: Colors.grey[300],
                                       period: Duration(seconds: 2),
                                       highlightColor: Colors.grey[100],
                                       child: Container(
                                         color: Colors.grey,
                                         child: Text(
                                           '25 % off entire menu',
                                           style:TextStyle(
                                               fontWeight: FontWeight.w400,
                                               color: Colors.red,
                                               fontSize: 11.8),
                                         ),
                                       ),
                                     ),
                                     // height(9),
                                   ],
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                     );
                  }),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  SafeArea Filter(ShopCubit cubit, BuildContext context) {
    return SafeArea(
                                        child: Scaffold(
                                          backgroundColor:Colors.white,
                                          bottomNavigationBar:
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10, right: 15, top: 15, bottom: 15),
                                              child: GestureDetector(
                                                onTap:(){
                                                   print(selectFilters);
                                                   text = "";
                                                   selectFilters.forEach((element) {
                                                     text = text + element + ',';
                                                   });
                                                   print(text);
                                                   setState(() {
                                                     cubit.FilterData(
                                                         longitude: longitude,
                                                         latitude: latitude,
                                                         text:text
                                                     );
                                                   });

                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Color(0xFFe9492d)),
                                                  width: double.infinity,
                                                  child: Center(
                                                      child: Text(
                                                        "فلتر",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                ),
                                              ),),
                                          ),
                                          appBar: AppBar(
                                            backgroundColor: Colors.white,
                                            automaticallyImplyLeading: false,
                                            toolbarHeight: 70,
                                            title: Padding(
                                              padding: const EdgeInsets.only(top: 30),
                                              child: Text('بحث و فلتر',style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 19),),
                                            ),
                                            centerTitle: true,
                                            elevation: 0,
                                            leading: Padding(
                                              padding: const EdgeInsets.only(top: 30),
                                              child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Icon(Icons.arrow_back,color: Colors.black,)),
                                            ),
                                          ),
                                          body:buildFilter(selectCategories:selectFilters,cubit: cubit),
                                        ));
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

  buildFilter({HashSet selectCategories,ShopCubit cubit}){
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Padding(
                                              padding: const EdgeInsets.only(left:15,top: 20,right: 10),
                                              child:SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 children:[
                                                   Padding(
                                                     padding: const EdgeInsets.only(left: 7,top: 0),
                                                     child: Text("مرشحات شعبية",style: TextStyle(
                                                         color: Colors.black,
                                                         fontSize: 16,
                                                         fontWeight: FontWeight.bold
                                                     ),),
                                                   ),
                                                   height(10),
                                                   // ...Popular_Filters.map((e){
                                                   //   return
                                                   //     StatefulBuilder(
                                                   //       builder:(context,state){
                                                   //         return GestureDetector(
                                                   //           onTap: () {
                                                   //             state(() {
                                                   //               if (selectFilters.contains(e)) {
                                                   //                 selectFilters.remove(e);
                                                   //               } else {
                                                   //                 selectFilters.add(e);
                                                   //               }
                                                   //               print(selectFilters);
                                                   //             });
                                                   //           },
                                                   //           child: Padding(
                                                   //             padding: const EdgeInsets.only(left: 10,right: 15,top: 10,bottom: 10),
                                                   //             child: Container(
                                                   //               child: Row(
                                                   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   //                 children: [
                                                   //                   Text('${e}',style: TextStyle(
                                                   //                       color: Color(0xFF828894),
                                                   //                       fontSize: 16,
                                                   //                       fontWeight: FontWeight.w500
                                                   //                   ),),
                                                   //                   Icon(selectFilters.contains(e)?Icons.check_box:Icons.check_box_outline_blank,color:selectFilters.contains(e)?Colors.red:Color(0xFF828894)),
                                                   //                 ],
                                                   //               ),
                                                   //             ),
                                                   //           ),
                                                   //         );
                                                   //       },
                                                   //     );
                                                   // }),
                                                   Padding(
                                                     padding: const EdgeInsets.only(left: 7,top: 15),
                                                     child: Text("فئات",style: TextStyle(
                                                         color: Colors.black,
                                                         fontSize: 16,
                                                         fontWeight: FontWeight.bold
                                                     ),),
                                                   ),
                                                   height(10),
                                                   ...cubit.categories.map((e){
                                                     return
                                                       StatefulBuilder(
                                                       builder:(context,state){
                                                         return GestureDetector(
                                                           onTap: () {
                                                             state(() {
                                                               if (selectCategories.contains(e['name'])) {
                                                                 selectCategories.remove(e['name']);
                                                               } else {
                                                                 selectCategories.add(e['name']);
                                                               }
                                                               print(selectCategories);
                                                             });
                                                           },
                                                           child: Padding(
                                                             padding: const EdgeInsets.only(left: 10,right: 15,top: 10,bottom: 10),
                                                             child: Container(
                                                               child: Row(
                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                 children: [
                                                                   Text('${e['name']}',style: TextStyle(
                                                                       color: Color(0xFF828894),
                                                                       fontSize: 16,
                                                                       fontWeight: FontWeight.w500
                                                                   ),
                                                                   ),
                                                                  Icon(selectCategories.contains(e['name'])?Icons.check_box:Icons.check_box_outline_blank,color:selectCategories.contains(e['name'])?Colors.red:Color(0xFF828894)),
                                                                 ],
                                                               ),
                                                             ),
                                                           ),
                                                         );
                                                       },
                                                     );
                                                   }),
                                                 ],
                                                ),
                                              ),
                                            ),
    );
  }
}




