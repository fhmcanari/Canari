import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/widgets/resturantList.dart';

import '../../shared/network/remote/cachehelper.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
   List Suggets = [
     'McDonalds',
     'Pizza',
     'Tacos',
     'Kfc',
     'Salad',
     'Chicken',
     'Burger',
     'Shawarma',
     'Sandwiches',
     'Cake',
     'Breakfast',
     'Mc Lamadona',
     'Tacos',
     'Kfc',
     'Salad',
     'Chicken',
     'Burger',
     'Shawarma',
     'Sandwiches',
     'Cake',
     'Breakfast',
     'Mc Lamadona',

   ];
   List Searches = [
     'McDonalds',
     'Pizza',
     'Starbucks'
   ];
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double latitud = Cachehelper.getData(key: "latitude");
    double longitud = Cachehelper.getData(key: "longitude");
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..getStoresData(latitude: latitud==null?27.149890:latitud,longitude: longitud==null?-13.199970:longitud),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          var search = ShopCubit.get(context).search;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0.50,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  title: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                          child: Icon(Icons.arrow_back)),
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "search must be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            ShopCubit.get(context).getSearchData(value);
                          },

                          textInputAction: TextInputAction.search,
                          autofocus:true,
                          decoration:InputDecoration(
                              suffixIcon: InkWell(
                                child: Icon(Icons.close,color:searchController.text.isEmpty?Colors.white:Colors.grey,size: 22,),
                                onTap: (){
                                  searchController.clear();
                                  setState(() {

                                  });
                                },
                              ),
                              filled: true,
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              hintText: 'ابحث عن طبق أو مطاعم'),

                        ),
                      ),
                    ],
                  )
                ),
                body:searchController.text.isNotEmpty && cubit.search.isEmpty?Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Image.network('https://canariapp.com/_nuxt/img/binoculars.9681313.png',),
                      height(10),
                      Text('لم أجد أي شيء " ${searchController.text}" ',style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),
                      height(10),
                      Text('حاول البحث عن متجر أو فئة أخرى'),
                    ],
                  ),
                ):SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      searchController.text.isEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15,top: 15),
                                child: Text('بعض اقتراحات',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                              ),
                              height(10),
                            cubit.isloading ?  ListView.separated(
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
                                      padding: const EdgeInsets.only(left: 10,right: 15,top: 10),
                                      child: ResturantList(Restaurant:cubit.stores[index],id:cubit.stores[index]['id']),
                                    );
                                  }): ListView.builder(
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
                        ],
                      ) : ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 1,
                                );
                              },
                              itemCount: cubit.search.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ResturantList(Restaurant:search[index],id: cubit.stores[index]['id'],),
                                );
                              })

                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
