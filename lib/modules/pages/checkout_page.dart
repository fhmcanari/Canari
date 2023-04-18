import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopapp/modules/Register/register.dart';
import 'package:shopapp/modules/pages/order.dart';
import 'package:shopapp/shared/components/components.dart';
import '../../Layout/HomeLayout/selectLocation.dart';
import '../../Layout/shopcubit/shopcubit.dart';
import '../../Layout/shopcubit/shopstate.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/remote/cachehelper.dart';
import 'cartPage/cart_empty.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {


  Completer<GoogleMapController> _controller = Completer();

  Future<void> animateCamera(latitude,longitude)async{
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPosition = CameraPosition(
        target:LatLng(latitude,longitude),
        zoom: 17.4746
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }
  TextEditingController NoteController = TextEditingController();
  var adress;
  bool isAdd = false;


  @override
  Widget build(BuildContext context) {
    double latitud = Cachehelper.getData(key: "latitude");
    double longitud = Cachehelper.getData(key: "longitude");
    String MyLocation = Cachehelper.getData(key: "myLocation");

    String access_token = Cachehelper.getData(key: "token");
    print(access_token);
    animateCamera(latitude,longitude);
    Set<Marker>myMarkers={
      Marker(
        draggable: true,
        onDragEnd: (LatLng latLng){

        },
        markerId: MarkerId('1'),
        position:LatLng(latitud, longitud),

      )
    };
    return BlocProvider(
        create: (BuildContext context) => ShopCubit(),
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context,state){
           if(state is MyorderSucessfulState){
             navigateTo(context,Order(order: state.order));
           }
          },
          builder: (context,state){
            print(type);
            var cubit = ShopCubit.get(context);
            String device_id = Cachehelper.getData(key:"deviceId");
            return Scaffold(
              bottomNavigationBar:Directionality(
                textDirection: TextDirection.rtl,
                child:dataService.itemsCart.length!=0?Summary(context,cubit,
                    rout: "اتمام طلب",
                    ontap: (){
                    access_token==null? navigateTo(context,Register(NoteController:NoteController,)):
                    ShopCubit.get(context).CheckoutApi({
                    "store_id":StoreId,
                    "payment_method":'CASH',
                    "delivery_address":{
                      "label":MyLocation,
                      "latitude":latitud,
                      "longitude":longitud
                    },
                    "type":'delivery',
                    "note":{
                      "allergy_info":"${NoteController.text}",
                      "special_requirements":""
                    },
                    "products":dataService.itemsCart, "device_id":device_id
                  });

                }):SizedBox(height: 0),
              ),
              backgroundColor: Colors.white,
              appBar:
              AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title:Text(
                  'الدفع',
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
              body:dataService.itemsCart.length!=0?
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,top: 0,right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            Text('منتجاتك',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:FontWeight.w500,
                              ),
                            ),
                            width(5),
                            Text('(${dataService.itemsCart.length})',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height(10),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: dataService.itemsCart.length,
                          itemBuilder: (context,index){
                            return
                              Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('x${dataService.itemsCart[index]['quantity']}',style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor
                                      ),),
                                      width(5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${dataService.itemsCart[index]['name']}',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color:Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            height(5),
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
                                      Text('${dataService.itemsCart[index]['price']} MAD',style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      )),
                                    ],
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                      itemCount:dataService.itemsCart[index]['attributes'].length,
                                      itemBuilder:(context,atributindex){
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 20,bottom: 15),
                                      child: Text(
                                        '${dataService.itemsCart[index]['attributes'][atributindex]['name']}',
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 11.5,
                                            color: Color.fromARGB(255, 78, 78, 78), fontWeight: FontWeight.normal),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                           onTap:(){
                                             setState(() {
                                               cubit.removeItem(product:dataService.itemsCart[index],Qty:cubit.qty,productStoreId:StoreId);
                                             });
                                           },
                                          child: CircleAvatar(
                                            maxRadius: 16,
                                            backgroundColor:Color(0xFFffe1e6),
                                            child: CircleAvatar(
                                                backgroundColor: Color(0xFFffe1e6),
                                                maxRadius: 15,
                                                child: Icon(Icons.remove,size: 20,color: Colors.red,)),
                                          )),
                                      GestureDetector(
                                           onTap:(){
                                             setState((){
                                               cubit.addToCart(product: dataService.itemsCart[index],Qty:cubit.qty,productStoreId:StoreId);
                                             });
                                           },
                                          child: CircleAvatar(
                                            maxRadius: 16,
                                            backgroundColor: Color(0xFFffe1e6),
                                            child: CircleAvatar(
                                                maxRadius: 15,
                                                backgroundColor: Color(0xFFffe1e6),
                                                child: Icon(Icons.add,size: 20,color: AppColor,)),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            );
                          }),

                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            Text('تفاصيل التسليم',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      height(10),
                      Container(
                        height: 155,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                ),
                                child:GoogleMap(
                                  onTap: (LatLng latLng)async{
                                    // myMarkers.remove(Marker(markerId: MarkerId('1')));
                                    // myMarkers.add(Marker(markerId: MarkerId('1'),position: latLng));
                                    // setState(() {
                                    //   latitude  =  latLng.latitude;
                                    //   longitude = latLng.longitude;
                                    //   getPlace(latitude:latitude,longitude:longitude);
                                    //   showModalBottomSheet(
                                    //     isScrollControlled: false,
                                    //     context: context, builder: (context){
                                    //     return showButton(myLocation: myLocation,latitude: latitude,longitude: longitude,);
                                    //   });

                                    // });
                                  },

                                  onCameraMove: (CameraPosition position){
                                    print(position.target.latitude);
                                     // myMarkers.remove(Marker(markerId: MarkerId('1')));
                                     // myMarkers.add(Marker(markerId: MarkerId('1'),position: LatLng(position.target.latitude, position.target.longitude)));
                                     // latitude =position.target.latitude;
                                     // longitude= position.target.longitude;
                                    // showModalBottomSheet(
                                    //     isScrollControlled: false,
                                    //     context: context, builder: (context){
                                    //     return showButton(myLocation: myLocation,latitude: latitude,longitude: longitude,);
                                    //   });
                                    setState((){

                                    });
                                  },
                                  onCameraIdle: (){
                                    setState(() {
                                     print('object');
                                    });
                                  },

                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(latitud, longitud),
                                    zoom: 15.2356,
                                  ),
                                  markers: myMarkers,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Directionality(
                       textDirection: TextDirection.rtl,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.grey[200],
                                  width: 0.7
                              )
                          ),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: Text('تسليم الى',style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13),),
                                      ),
                                      height(3),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(child:Text(
                                              MyLocation!=null? "${MyLocation}":'اختر موقعا',
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: ()async{
                                    final changeAdress = await navigateTo(context, SelectLocation(routing: 'checkout',));
                                    setState(() {
                                      if(changeAdress!=null){
                                        myLocation = changeAdress;
                                      }
                                     print(changeAdress);
                                    });

                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                       
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Center(child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          Text('تغيير الموقع',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 10),),
                                          Icon(Icons.location_on_outlined,size: 20,color: Colors.red,)
                                        ],
                                      ),
                                    )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      height(15),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            Text('أضف ملاحظات',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 0,right: 0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                              height: 60,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[50],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          onChanged: (s){
                                            setState((){
                                              print(s);
                                            });
                                          },
                                          controller: NoteController,
                                          validator: (value){
                                            if (value == null || value.isEmpty) {
                                              return 'request is not to be empty';
                                            }
                                            return null;
                                          },
                                          maxLines: null,
                                          expands: true,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'اكتب ملاحظاتك هنا .....',hintMaxLines:20,hintStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Color(0xFF7B919D),),)
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ),
                      ),
                  height(30),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5,top: 12,right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.home_outlined,color: Colors.grey,size: 20),
                                  Text('عربة التسوق الخاصة بك من',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey)),
                                ],
                              ),
                              height(5),
                              Text('${StoreName}',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20)),
                              height(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "المجموع الفرعي",
                                      style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey)
                                  ),

                                  Text(
                                      "${cubit.getTotalPrice()} دراهم ",
                                      style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)
                                  ),
                                ],
                              ),
                              height(15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "رسوم التوصيل",
                                      style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey)
                                  ),

                                  Text(
                                      "${deliveryPrice}  دراهم ",
                                      style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)
                                  ),
                                ],
                              ),
                              height(15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "المجموع",
                                      style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey)
                                  ),

                                  Text(
                                      "${cubit.getTotalPrice() + deliveryPrice} دراهم ",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFde2706),)
                                  ),
                                ],
                              ),
                              height(10),
                            ],
                          ),
                          height(10),
                        ],
                      ),
                    ),
                  ),
                      height(10)
                    ],
                  ),
                ),
              ):Cartempty(),

            );
          },

        ),
      );
  }

}

