import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/class/resturantCategoriesItem.dart';
import 'package:shopapp/modules/pages/RestaurantPage/ResturantInfo.dart';
import 'package:shopapp/modules/pages/RestaurantPage/placeholder.dart';
import 'package:shopapp/modules/pages/checkout_page.dart';
import 'package:shopapp/shared/components/components.dart';
import '../../../Layout/HomeLayout/selectLocation.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/cachehelper.dart';
import '../product_detail.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:io' show Platform;

const productHeight = 110.0;

class RestaurantPage extends StatefulWidget {
  final String name;
  final String slug;
  final String cover;
  final String brandlogo;
  final dynamic price_delivery;
  final String deliveryTime;
  final int rate;
  List<dynamic> cuisines = [];
  List<Map<String, dynamic>> menu = [];
  int id;

  RestaurantPage({
    Key key,
    this.cover,
    this.name,
    this.price_delivery,
    this.rate,
    this.deliveryTime,
    this.cuisines,
    this.id,
    this.menu,
    this.brandlogo,
    this.slug,
  }) : super(key: key);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

    class _RestaurantPageState extends State<RestaurantPage> {
      bool ServiceStatus;
      Future<bool>serviceStatus() async {
        RemoteConfig remoteConfig = RemoteConfig.instance;
        remoteConfig.setConfigSettings(RemoteConfigSettings(
            fetchTimeout: Duration(seconds: 60),
            minimumFetchInterval: Duration(seconds: 1)
        ));
        await remoteConfig.fetchAndActivate();
        bool remoteConfigVersion = remoteConfig.getBool('serviceStatus');
        ServiceStatus = remoteConfigVersion;
        setState(() {

        });

        return remoteConfigVersion;

      }
    int selectCategoryIndex = 0;
    bool isScroller = false;
    final scrollController = ScrollController();

    double resturantInfoHeight = 195 + 52 - kToolbarHeight; //Appbar height
    var price;
    var address;
    bool isShow = false;
    bool isExited = false;


    List<double>breackPoints = [];

    final GlobalKey<FormState> containerKey = GlobalKey<FormState>();
    @override
    void initState() {
      serviceStatus();
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      Future<void> share() async {
        if (Platform.isAndroid) {
          await FlutterShare.share(
            title: 'Canari food and More',
            text: 'مرحباً ، لقد وجدت هذا المطعم ${widget.name} في كناري. الطعام يبدو جيدًا! إلق نظرة',
            linkUrl: 'https://play.google.com/store/apps/details?id=com.canari.app',
          );
        } else if (Platform.isIOS) {
          await FlutterShare.share(
            title: 'Canari food and More',
            text: 'مرحباً ، لقد وجدت هذا المطعم ${widget.name} في كناري. الطعام يبدو جيدًا! إلق نظرة',
            linkUrl: 'https://apps.apple.com/ma/app/canari-food-delivery/id6448685108',
          );
        }

      }

      String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
      double latitud = Cachehelper.getData(key: "latitude");
      String MyLocation = Cachehelper.getData(key: "myLocation");
      return BlocProvider(
        create: (BuildContext context) => ShopCubit()
          ..getStoreData(
            slug: widget.slug,
          )
          ..getCartItem(),
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state) {},
          builder: (context, state) {

            var cubit = ShopCubit.get(context);

            if(cubit.store!=null){
              double firstBreackPoint = resturantInfoHeight + 15 + (119 * cubit.store['menus'][0]['products'].length);
              breackPoints.add(firstBreackPoint);
              for(var i = 1;i<cubit.store['menus'].length;i++){
                double breackPoint = breackPoints.last + 15 +(119 * cubit.store['menus'][i]['products'].length);
                breackPoints.add(breackPoint);
              }
              scrollController.addListener(() {
                for(var i=0;i<cubit.store['menus'].length;i++){
                  if(i==0){
                    if((scrollController.offset < breackPoints.first)&(selectCategoryIndex!=0)){
                      setState(() {
                        selectCategoryIndex =0;
                      });
                    }
                  }else if((breackPoints[i-1]<=scrollController.offset)&(scrollController.offset<breackPoints[i])){
                    if(selectCategoryIndex!=i){
                      setState(() {
                        selectCategoryIndex = i;
                      });
                    }
                  }
                }
                if (scrollController.offset > 150) {
                  setState(() {
                    isShow = true;
                  });
                } else {
                  setState(() {
                    isShow = false;
                  });
                }
              });

            }





      return SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar:
              state is! GetResturantPageDataLoadingState ? cubit.getCartItem() != 0
                      ?  dataService.itemsCart[0]['productStoreId']==widget.id? Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                    offset: Offset(0, 1))
                              ]),
                          height: 75,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 15, left: 15, bottom: 10, top: 10),
                            child: GestureDetector(
                              onTap: () async {
                                if(!ServiceStatus){
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      " أود إخباركم أن خدمتنا لم تبدأ بعد. نحن نعمل بجد لنقدم لك أفضل تجربة ممكنة وسنعلمك بمجرد استعدادنا للانطلاق. شكرا لصبرك و تفهمك",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    duration: Duration(milliseconds: 5000),
                                  ));
                                  dataService.itemsCart.clear();
                                  setState(() {

                                  });
                                }else{
                                if (!dataService.itemsCart[0]['storeStatus']) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "لقد طلبت من مطعم مغلق ! ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    duration: Duration(milliseconds: 2000),
                                  ));
                                  dataService.itemsCart.clear();
                                  setState(() {

                                  });
                                } else {
                                  if (latitud != null) {
                                    var totalPrice = await navigateTo(
                                        context,CheckoutPage(
                                        delivery_price: widget.price_delivery,
                                    ));
                                    setState(() {
                                      totalPrice = price;
                                    });
                                  } else {
                                    final changeAdress = await navigateTo(
                                        context,
                                        SelectLocation(
                                          routing: 'checkout',
                                        ));
                                    setState(() {
                                      if (changeAdress != null) {
                                        MyLocation = changeAdress;
                                      }
                                    });
                                  }
                                }}
                              },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColor,
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 35,
                                          width: 35,
                                          decoration: BoxDecoration(
                                            borderRadius:BorderRadius.circular(5),
                                            color:cubit.getCartItem() == 0 ? Color.fromARGB(255, 253, 143, 135) : Color.fromARGB(255, 253, 106, 95),
                                          ),
                                          child: Center(
                                              child: Text(
                                            '${cubit.getCartItem()}',
                                            textAlign:
                                                TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.bold),
                                          ))),
                                      width(10),
                                      Text(
                                        'رؤية طلب',
                                        style: TextStyle(
                                            fontWeight:
                                                FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                Text(
                                  '${cubit.getTotalPrice()} درهم ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        )
                  : SizedBox(
                      height: 0,
                    ):SizedBox(
                     height: 0,
                     ),
              body: state is! GetResturantPageDataLoadingState
                  ? CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 195,
                          pinned: true,
                          title: Text(
                            isShow ? '${widget.name}' : '',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 0,
                          flexibleSpace: FlexibleSpaceBar(
                              background: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                color: Colors.black,
                                child: Opacity(
                                  opacity: cubit.store['is_open'] == false
                                      ? 0.3
                                      : 1,
                                  child: CachedNetworkImage(
                                      width: double.infinity,
                                      imageUrl: '${widget.cover}',
                                      placeholder: (context, url) =>
                                          Image.asset(
                                            'assets/placeholder.png',
                                            fit: BoxFit.cover,
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              cubit.store['is_open'] == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 120,
                                          right: 100,
                                          top: 50,
                                          bottom: 50),
                                      child: Text('مغلق',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                    )
                                  : height(0),
                            ],
                          )),
                          actions: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16, right: 5),
                                  child: GestureDetector(
                                    onTap: () {
                                    share();
                                    },
                                    child: CircleAvatar(
                                        child: Icon(Icons.share,
                                            color: Colors.black, size: 24),
                                        backgroundColor: Colors.white,
                                        minRadius: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          leading:
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(3, 3),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16, right: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, '${cubit.getTotalPrice()}');
                                    setState(() {

                                    });
                                  },
                                  child: CircleAvatar(
                                      child: Icon(Icons.arrow_back,
                                          color: Colors.black, size: 26),
                                      backgroundColor: Colors.white,
                                      minRadius: 22),
                                ),
                              ),
                            ],
                          ),


                        ),
                        ResturantInfo(widget: widget, cubit: cubit),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: ResturantCategoriesItem(
                              isShow :isShow,
                              cubit: cubit,
                              selectedIndex: selectCategoryIndex,
                              onchanged: (int index) {
                                if (selectCategoryIndex != index) {
                                  int totalItems = 0;
                                  for (var i = 0; i < index; i++) {
                                    totalItems += cubit.store['menus'][i]['products'].length;
                                  }
                                  scrollController.animateTo(
                                      resturantInfoHeight +
                                          (120 * totalItems) +
                                          (20 * index),
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                }
                                setState(() {
                                  selectCategoryIndex = index;
                                });
                              }),
                        ),
                        SliverPadding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  cubit.store['menus'].length == 0
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'نحن نعمل على ادراج هذا المتجر ، تعال قريبًا',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                              height(20),
                                              LinearProgressIndicator(
                                                  color: AppColor,
                                                  backgroundColor:
                                                      Color(0xFFFFCDD2)),
                                            ],
                                          ),
                                        )
                                      : SizedBox(height: 0),
                     Container(
                    color: Colors.grey[100],
                    child: Column(
                      children: [

                        // Container(
                        //   decoration: BoxDecoration(
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.grey.withOpacity(0.5),
                        //         spreadRadius: 2,
                        //         blurRadius: 5,
                        //         offset: Offset(1, 8), // changes position of shadow
                        //       ),
                        //     ],
                        //   ),
                        //   child: ElevatedButton(
                        //     onPressed: () {},
                        //     child: Text('My Button'),
                        //   ),
                        // ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cubit.store['menus'].length,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(bottom: 10, top: 0),
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16,right: 10),
                                        child: Text(
                                          '${capitalize('${cubit.store['menus'][index]['name']}')}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      height(10),
                                      Column(
                                  children: [





                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: cubit.store['menus'][index]['products'].length,
                                    itemBuilder: (BuildContext context, productindex) {
                                      var product =
                                          cubit.store['menus'][index]['products'][productindex];
                                      var contain = dataService.itemsCart.where((element) =>
                                              element['id'] == product['id']).toList();
                                      if (contain.isEmpty) {
                                        isExited = false;
                                      } else {
                                        isExited = true;
                                      }

                                      return Container(
                                        child:
                                            Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                      Container(
                                        height:productHeight,
                                        color: Colors.white,
                                        child: InkWell(
                                          onTap: () async {
                                            if (product['modifierGroups'].length == 0) {
                                              var totalPrice = await showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                ),
                                                  isScrollControlled: true,

                                                  context: context,
                                                  builder: (context) {
                                                    StoreName = cubit.store['name'];
                                                    StoreId = cubit.store['id'];
                                                    deliveryPrice = cubit.store['delivery_price'];
                                                    storeStatus = cubit.store['is_open'];
                                                    cubit.qty = 1;
                                                    return buildProduct(product,cubit,StoreName,StoreId,deliveryPrice,storeStatus);
                                                  });
                                              setState(() {
                                                totalPrice = price;
                                              });
                                            } else {
                                              StoreName = cubit.store['name'];
                                              StoreId = cubit.store['id'];
                                              deliveryPrice = cubit.store['delivery_price'];
                                              storeStatus = cubit.store['is_open'];
                                              var totalPrice = await navigateTo(context,ProductDetail(
                                                    id: StoreId,
                                                    StoreName: StoreName,
                                                    DeliveryPrice: deliveryPrice,
                                                    dishes: product,
                                                    storeStatus: storeStatus,
                                                  ));
                                              setState(() {
                                                totalPrice = price;
                                              });
                                            }
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              isExited
                                                  ? Padding(
                                                      padding: const EdgeInsets.only(top: 15),
                                                      child: Container(
                                                          height: 90,
                                                          width: 2.7,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50),
                                                            color: AppColor,
                                                          )),
                                                    )
                                                  : height(0),
                                              width(6),
                                              isExited
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 20,
                                                      ),
                                                      child: Container(
                                                        height: 23,
                                                        width: 23,
                                                        decoration: BoxDecoration(color: AppColor, shape: BoxShape.circle, boxShadow: [
                                                          BoxShadow(color: Colors.grey[300], offset: Offset(2, 1), blurRadius: 2, spreadRadius: 1)
                                                        ]),
                                                        child: Center(
                                                            child: contain.length > 0
                                                                ? Text(
                                                                    'x${contain[0]['quantity']}',
                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white),
                                                                  )
                                                                : height(0)),
                                                      ),
                                                    )
                                                  : height(0),
                                              width(4),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      product['name'] == null ? '' : '${product['name']}',
                                                      maxLines: 2,
                                                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                                    ),
                                                    height(5),
                                                    Text(
                                                      product['description'] == null ? '' : '${product['description']}',
                                                      maxLines: 2,
                                                      style: TextStyle(fontSize: 12.5, color: Color.fromARGB(255, 78, 78, 78), fontWeight: FontWeight.normal),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    height(2),
                                                    Text.rich(TextSpan(children: [
                                                      TextSpan(
                                                        text: '${product['price']} درهم ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          color: Color.fromARGB(255, 78, 78, 78),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ])),
                                                    height(9),
                                                  ],
                                                ),
                                              ),
                                              width(15),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: product['image'] == ''
                                                        ? height(0)
                                                        : CachedNetworkImage(
                                                            imageUrl: '${product['image']}',
                                                            placeholder: (context, url) => Image.asset('assets/placeholder.png', fit: BoxFit.cover),
                                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                                            imageBuilder: (context, imageProvider) {
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                            height(3),
                                      Container(
                                        height:0.5,
                                        width:double.infinity,
                                        color:Colors.grey[350],
                                      )
                                          ],
                                        ),
                                      );
                                    })
                                  ],
                                )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                                ]),
                          ),
                        ),
                      ],
                    )
                  : placeholder()),
        ),
      );
          },
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

    Widget buildProduct(product,cubit,StoreName,StoreId,deliveryPrice,storeStatus){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              product['image']!=''? Container(
                height: 300,
                width: double.infinity,
                child:product['image']==''?
                Image.asset('assets/placeholder.png',):
                CachedNetworkImage(
                    imageUrl: '${product['image']}',
                    placeholder: (context, url) =>
                        Image.asset('assets/placeholder.png',fit: BoxFit.cover,),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    imageBuilder: (context, imageProvider){
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          image: DecorationImage(
                            image: imageProvider,
                              fit: BoxFit.cover
                          ),
                        ),
                      );
                    }
                ),


              ):height(0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    setState((){
                      Navigator.pop(
                          context, '${cubit.getTotalPrice()}');
                    });
                  },
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close,color: Colors.black,size: 25)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15,top: 20,right: 15),
            child: Text('${product['name']}',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
          ),
          product['description']!=null?   Padding(
            padding: const EdgeInsets.only(left: 15,top: 20,right: 15),
            child: Column(

              children: [
                Text(
                  '${product['description']}',
                  style:
                  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                  ),
                ),
              ],
            ),
          ):height(0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Padding(
                padding: const EdgeInsets.only(left: 15,top: 5,right: 15,bottom: 15),
                child: Text('${product['price']} درهم ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black),),
              ),
            ],
          ),

          height(20),
         StatefulBuilder(builder: (context,setState){
           return Container(
             decoration: BoxDecoration(
                 color: Colors.white,
                ),
             height: 75,
             child: Padding(
               padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10,top: 10),
               child: GestureDetector(
                 onTap: (){
                   StoreName = StoreName;
                   StoreId = StoreId;
                   deliveryPrice = deliveryPrice;
                   cubit.addToCart(product:product,Qty:cubit.qty,productStoreId:StoreId,attributes:[],storeStats: storeStatus);
                   if(cubit.isinCart){
                     Navigator.pop(context, '${cubit.getTotalPrice()}');
                   }
                   if(cubit.isinCart==false){
                     dataService.itemsCart.clear();
                     dataService.productsCart.clear();
                     cubit.addToCart(product:product,Qty:cubit.qty,productStoreId:StoreId,attributes:[],storeStats: storeStatus);
                     if(cubit.isinCart){
                       Navigator.pop(
                           context, '${cubit.getTotalPrice()}');

                     }
                   }


                 },
                 child: Row(
                   children: [
                     Expanded(
                       child: Container(
                         height: 50,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5),
                           color:AppColor,
                         ),
                         width: double.infinity,
                         child: Center(child: Text('أضف إلى السلة',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                         )
                         ),
                       ),
                     ),
                     width(5),
                     StatefulBuilder(builder: (context,setState){
                       return Expanded(
                         child: Container(
                           child:Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               GestureDetector(
                                 child: Container(
                                   height: 50,
                                   width: 50,
                                   decoration: BoxDecoration(
                                       color: Colors.grey[100],
                                       borderRadius: BorderRadius.circular(5)
                                   ),
                                   child: Icon(Icons.add,color: Colors.black,size: 30,),
                                 ),
                                 onTap: (){
                                   cubit.plus();
                                   setState((){});
                                 },
                               ),
                               width(20),
                               Text('${cubit.qty}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
                               width(20),
                               GestureDetector(
                                 child: Container(
                                   height: 50,
                                   width: 50,
                                   decoration: BoxDecoration(
                                       color:Colors.grey[100],
                                       borderRadius: BorderRadius.circular(5)
                                   ),
                                   child: Icon(Icons.remove,color: Colors.black,size: 30,),
                                 ),
                                 onTap: (){
                                   cubit.minus();
                                   setState((){});
                                 },
                               )
                             ],
                           ),
                         ),
                       );
                     })
                   ],
                 ),
               ),
             ),
           );
         })
        ],
      );
    }
}
