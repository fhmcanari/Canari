import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/shared/components/components.dart';

import '../../Layout/HomeLayout/profile.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/remote/cachehelper.dart';
import '../../widgets/resturantGridl.dart';

class Filters extends StatefulWidget {
  final selectCategories;
  var text;
   Filters({Key key, this.selectCategories, this.text}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  // List Popular_Filters = [
  //   "توصيل مجاني",
  //   "أعلى تقييم",
  //   "سلمت بواسطتنا",
  //   "عروض",
  // ];


  HashSet selectCategories = new HashSet();
  List filters = [];
  @override
  Widget build(BuildContext context) {
    String MyLocation = Cachehelper.getData(key: "myLocation");
    double latitud = Cachehelper.getData(key: "latitude");
    double longitud = Cachehelper.getData(key: "longitude");
    return BlocProvider(
      create: (context)=>ShopCubit()..FilterData(latitude: latitud,longitude: longitud,text: widget.text)..getcategoriesData(),
     child:  BlocConsumer<ShopCubit,ShopStates>(
       listener:(context,state){
          if(state is GetFilterDataSucessfulState){
            filters = state.filters;
          }
       },
       builder:(context,state){
         var cubit = ShopCubit.get(context);
         return Directionality(
           textDirection: TextDirection.rtl,
           child: Scaffold(
             backgroundColor: Colors.white,
             appBar:appbar(context,myLocation: MyLocation==null?'select Location':MyLocation,icon: Icons.person,ontap: (){
               navigateTo(context, Profile(),);
             },iconback: Icons.keyboard_arrow_down),
             body:cubit.isloading? SingleChildScrollView(
               physics: BouncingScrollPhysics(),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 15,right: 15),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         SearchBarAndFilter(context),
                         width(7),
                         GestureDetector(
                           onTap:(){
                             showModalBottomSheet(
                                 isScrollControlled:true,
                                 enableDrag:false,
                                 context:context,
                                 builder:(context){
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
                                                 setState(() {
                                                   widget.text = "";
                                                   widget.selectCategories.forEach((element) {
                                                     widget.text = widget.text + element + ',';
                                                   });
                                                   print(widget.text);
                                                   cubit.FilterData(
                                                       longitude: longitud,
                                                       latitude: latitud,
                                                       text: widget.text,
                                                   );
                                                   Navigator.pop(context);
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
                                         body:ListView(
                                           physics: BouncingScrollPhysics(),
                                           shrinkWrap: true,
                                             children: [
                                               SingleChildScrollView(child: buildFilter(selectFilters:widget.selectCategories,categories: cubit.categories))
                                             ],
                                         ),
                                       ));
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
                  height(5),

                  Wrap(
                    children: [
                      ...widget.selectCategories.map((e){
                        return Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15),
                          child: FilterChip(
                            labelPadding:EdgeInsets.only(right: 15,left: 10) ,
                            labelStyle:TextStyle(fontSize: 12) ,
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.grey[350],
                              width: 1,
                            ),
                              avatar: Icon(Icons.close,size: 15,),
                              label: Text('${e}',), onSelected: (s){

                            if (widget.selectCategories.contains(e)){
                              widget.selectCategories.remove(e);
                            }
                            setState(() {
                              widget.text = "";
                              widget.selectCategories.forEach((element) {
                                widget.text = widget.text + element + ',';
                              });
                              cubit.FilterData(
                                longitude: longitud,
                                latitude: latitud,
                                text: widget.text,
                              );
                            });
                            if(widget.selectCategories.isEmpty){
                              Navigator.pop(context);
                            }
                          }),
                        );
                      }),
                    ],
                  ),
                   Padding(
                     padding: const EdgeInsets.only(left: 15,top: 10,bottom: 10,right: 18),
                     child: Text('نتائج (${filters.length}) ',style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 15
                     ),),
                   ),
                   height(5),
                   filters.length==0?Padding(
                     padding: const EdgeInsets.only(left: 15,right: 15),
                     child: Container(
                       color: Colors.redAccent,
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('لا يوجد مطعم متوفر بهذا الفلتر حاول مرة أخرى بفلتر مختلف',style: TextStyle(
                             color: Colors.white
                           ),),
                         )),
                   ):height(0),
                   ListView.builder(
                     physics: NeverScrollableScrollPhysics(),
                     shrinkWrap: true,
                       itemBuilder: (context,index){
                     return Padding(
                       padding: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
                       child: ResturantGridl(Restaurant:filters[index],id:filters[index]['id'],size: 220.0),
                     );
                   },itemCount: filters.length)
                 ],
               ),
             ): SingleChildScrollView(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
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
                           onTap:(){
                             showModalBottomSheet(
                                 isScrollControlled:true,
                                 enableDrag:false,
                                 context:context,
                                 builder:(context){
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
                                             padding: const EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 10),
                                             child: GestureDetector(
                                               onTap:(){
                                                 setState(() {
                                                   widget.text = "";
                                                   widget.selectCategories.forEach((element) {
                                                     widget.text = widget.text + element + ',';
                                                   });
                                                   print(widget.text);
                                                   cubit.FilterData(
                                                     longitude: longitud,
                                                     latitude: latitud,
                                                     text: widget.text,
                                                   );
                                                   Navigator.pop(context);
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
                                             child: Text('Short & Filter',style: TextStyle(
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
                                           actions: [
                                             // Padding(
                                             //   padding: const EdgeInsets.only(top: 30),
                                             //   child: TextButton(onPressed: (){}, child: Text('Clear all',
                                             //     style: TextStyle(
                                             //         color: Color(0xFFe9492d),
                                             //         fontSize: 15,
                                             //         fontWeight: FontWeight.bold
                                             //     ),
                                             //   )
                                             //   ),
                                             // )
                                           ],
                                         ),
                                         body:Column(
                                           children: [
                                             buildFilter(selectFilters:widget.selectCategories),
                                           ],
                                         ),
                                       ));
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
                   height(20),

                   Padding(
                     padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15,right: 15),
                     child: Shimmer.fromColors(
                       baseColor: Colors.grey[300],
                       period: Duration(seconds: 2),
                       highlightColor: Colors.grey[100],
                       child: Container(
                         height: 15,
                         color: Colors.white,
                         child: Text('Result (${filters.length})',style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 15
                         ),),
                       ),
                     ),
                   ),

                 ListView.builder(
                     shrinkWrap: true,
                     itemCount: 5,
                     itemBuilder: (context,index){
                   return Padding(
                     padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                     child:
                     Container(
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(10),
                       ),
                       width: double.infinity,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Stack(alignment: Alignment.topLeft, children: [
                             Shimmer.fromColors(
                               baseColor: Colors.grey[300],
                               period: Duration(seconds: 2),
                               highlightColor: Colors.grey[100],
                               child: Container(
                                 height: 125,
                                 width: double.infinity,
                                 decoration: BoxDecoration(
                                   color: Colors.grey,
                                   borderRadius: BorderRadius.circular(5),
                                 ),
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(5),

                                 ),
                               ),
                             ),

                             Padding(
                               padding:
                               const EdgeInsets.only(top: 105, left: 210, right: 10,bottom: 10),
                               child:  Shimmer.fromColors(
                                 baseColor: Colors.grey[300],
                                 period: Duration(seconds: 2),
                                 highlightColor: Colors.grey[100],
                                 child: Container(
                                   height: 35,
                                   child: Row(
                                     crossAxisAlignment: CrossAxisAlignment.center,
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(Icons.timer_outlined,size: 17),
                                       width(5),
                                       Text(
                                         ' min',
                                         textAlign: TextAlign.center,
                                         style: TextStyle(
                                           fontSize: 13,
                                           color: Colors.black,
                                           fontWeight: FontWeight.w400,
                                         ),
                                       ),
                                     ],
                                   ),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(20),
                                       color: Colors.grey,
                                       boxShadow: [
                                         BoxShadow(
                                             color: Colors.grey[200], offset: Offset(0, 1))
                                       ]),
                                 ),
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Shimmer.fromColors(
                                 baseColor: Colors.grey[300],
                                 period: Duration(seconds: 2),
                                 highlightColor: Colors.grey[100],
                                 child: Container(
                                     height: 65,
                                     width: 65,
                                     decoration: BoxDecoration(
                                         color: Colors.grey,
                                         borderRadius: BorderRadius.circular(5),
                                         border: Border.all(
                                           color: Colors.grey,
                                           width: 2,
                                         )),
                                     child: ClipRRect(
                                       borderRadius: BorderRadius.circular(5),
                                       child: Image.network('',fit: BoxFit.cover,),)
                                 ),
                               ),
                             ),
                           ]),
                           Padding(
                             padding:EdgeInsets.only(left: 12,bottom: 10),
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
                                         color: Colors.grey,
                                         child: Text(
                                           'Motlen Chocolate',
                                           style:TextStyle(
                                               fontWeight: FontWeight.normal,
                                               color: Color(0xFF000000),
                                               fontSize: 15),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                                 height(3),
                                 Row(
                                   children: [

                                   ],
                                 ),
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
                                             ' Excellent',
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
                         ],
                       ),
                     ),
                   );
                 })
                 ],
               ),
             )
           ),
         );
       },
     )
    );
  }
   buildFilter({HashSet selectFilters, List categories}){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(left:15,top: 20,right: 10),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:[

            Padding(
              padding: const EdgeInsets.only(left: 7,top: 10),
              child: Text("مرشحات شعبية",style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
            ),
            height(15),
            // ...Popular_Filters.map((e) {
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
            height(15),
            ...categories.map((e) {
              return StatefulBuilder(
                  builder:(context,state){
                    return GestureDetector(
                      onTap: () {
                        state(() {
                          if (selectFilters.contains(e['name'])) {
                            selectFilters.remove(e['name']);
                          } else {
                            selectFilters.add(e['name']);
                          }
                          print(selectFilters);
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
                              Icon(selectFilters.contains(e['name'])?Icons.check_box:Icons.check_box_outline_blank,color:selectFilters.contains(e['name'])?Colors.red:Color(0xFF828894)),
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
    );
  }
}
