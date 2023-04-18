
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/Layout/HomeLayout/search.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/modules/Register/register.dart';

import 'package:shopapp/shared/components/constants.dart';

import '../../modules/pages/filters.dart';



void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
 navigateTo(context, Widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));

Widget appbar(context,{myLocation,IconData icon,Function ontap,IconData iconback,Function onback}) {
  return AppBar(
    
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                elevation: 0,
                actions: [
                     IconButton(
                         onPressed:ontap,
                      icon:Icon(icon,color: AppColor,size: 25,))
                    ],
                title: Row(
                  children: [
                    Icon(Icons.location_on,color: AppColor,),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('تسليم الى',style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13),),
                            GestureDetector(
                              onTap:onback,
                              child: Row(
                                children: [
                                  myLocation.length<=30? Text(
                              myLocation!=null? "${myLocation}":'Select location',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                ),
                              ):Expanded(child:Text(
                                    myLocation!=null? "${myLocation}":'Select location',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  GestureDetector(
                                    onTap:onback,
                                    child: Icon(
                                      iconback,
                                      size: 25,
                                      color: Color.fromARGB(255, 68, 71, 71),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                )
              );
}

Widget SearchBarAndFilter(context){
    return Expanded(
        child: GestureDetector(
          onTap: (){
            navigateTo(context, Search());
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Color.fromARGB(255, 250, 250, 250)
            ),
            height: 50,
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(width: 15,),
                Icon(Icons.search,color: Color.fromARGB(255, 98, 98, 98),size: 23),
                width(5),
                Text('ابحث عن طبق أو مطاعم',style: TextStyle(
                    color: Color.fromARGB(255, 98, 98, 98)
                )),
              ],
            ),
          ),
        ),
      );
}

Widget height(
  double height,
) {
  return SizedBox(
    height: height,
  );
}

Widget width(
  double width,
) {
  return SizedBox(
    width: width,
  );
}

Widget title({@required String text,double size,Color color}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
    child: Text(
      text,
      style: TextStyle(
        color:color,
        fontSize: size,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget  category(context,selectFilters) {
  var cubit = ShopCubit.get(context);
  return
    Container(
      height: 75,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 15),
        child: ListView.separated(
            separatorBuilder: (context, index) {
              return width(10);
            },
            physics: BouncingScrollPhysics(),
            itemCount: cubit.categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  selectFilters.add(cubit.categories[index]['name']);
                 var text = "";
                  selectFilters.forEach((element) {
                    text = text + element + ',';
                  });
                  navigateTo(context, Filters(selectCategories: selectFilters,text: text));
                  },
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Opacity(
                          opacity: 1,
                          child:cubit.categories[index]['image']==''?Opacity(
                            opacity: 1,
                              child: Image.asset('assets/placeholder.png',fit: BoxFit.cover)
                              )
                              : Opacity(
                            opacity: 1,
                            child: CachedNetworkImage(
                            imageUrl: '${cubit.categories[index]['image']}',
                            placeholder: (context, url) => Image.asset('assets/placeholder.png',fit: BoxFit.cover),
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
                              )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 35),
                      child: Text(
                        "${cubit.categories[index]['name']}",
                        style: const TextStyle(
                          shadows: [
                         Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 52, 52, 52),
                            ),
                             ],
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ));
}



Widget CartItem(int index, ShopCubit cubit,{Function remove,add,double padding}){

  return Padding(
    padding: EdgeInsets.only(left: padding,right: padding,bottom: 10),
    child: Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${dataService.itemsCart[index]['name']}',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500
                    ),),
                  height(6),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('${double.parse(dataService.itemsCart[index]['price']) * (dataService.itemsCart[index]['quantity'])} MAD',style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12
                      ),),
                      // Row(
                      //   children: [
                      //     ...dataService.itemsCart[index]['attributes'].map((e){
                      //      return Row(
                      //        children: [
                      //
                      //          Text('${e['name']}',style: TextStyle(
                      //              fontWeight: FontWeight.w500,
                      //              fontSize: 11.5,
                      //              color:Color(0xffa3aab5),
                      //
                      //          ),),
                      //          width(3),
                      //          e == dataService.itemsCart[index]['attributes'].last?Text(''):Text(',',style: TextStyle(
                      //            color:Color(0xffa3aab5),
                      //          ),),
                      //          width(3),
                      //        ],
                      //      );
                      //     }),
                      //
                      //   ],
                      // ),

                    ],
                  ),
                ],
              ),Container(
                height: 35,
                color: Colors.white,
                child: Row(
                  children: [
                    GestureDetector(
                        onTap:remove,
                        child: CircleAvatar(
                          maxRadius: 14,
                          backgroundColor: Colors.red,
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              maxRadius: 13,
                              child: Icon(Icons.remove,size: 20,color: AppColor,)),
                        )),
                    SizedBox(width: 8,),
                    Text(
                      '${dataService.itemsCart[index]['quantity']}',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8,),
                    GestureDetector(
                        onTap:add,
                        child: CircleAvatar(
                          maxRadius: 14,
                          backgroundColor: Colors.red,
                          child: CircleAvatar(
                              maxRadius: 13,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.add,size: 20,color: AppColor,)),
                        ))
                  ],
                ),
              ),
            ],
          ),
          height(5),
          Wrap(
            children: [
              ...dataService.itemsCart[index]['attributes'].map((e){
               return Row(
                 children: [
                   Text('${e['name']}',style: TextStyle(
                     fontWeight: FontWeight.w500,
                     fontSize: 11.5,
                     color:Color(0xffa3aab5),
                   ),),
                 ],
               );
              }),

            ],
          ),

        ],
      ),
    ),
  );
}

Widget Summary(BuildContext context,ShopCubit cubit,{Function ontap,String rout}){
  return Container(
    height: 80,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow:[
          BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 3),
              spreadRadius: 1,
              color: Colors.grey[350]
          )
        ]
    ),

    child: Padding(
      padding: const EdgeInsets.only(left: 20,top: 12,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: ontap,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor
                ),
                height: 55,
                width: double.infinity,
                child:
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(child: ShopCubit.get(context).isloading?
                  Text('${rout}',style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),):
                  CircleAvatar(
                    maxRadius: 16,
                      backgroundColor:AppColor ,
                      child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3.3,))),
                )
            ),
          ),
          height(10),
        ],
      ),
    ),
  );
}


Widget buildForm({
  Key fromkey,
  TextEditingController FirstnameController,
  TextEditingController LastnameController,
  Function ontap,
  Function onpress,
  String phoneCode,
  String phoneNumber,
  bool isloading
}){
  return
    Form(
    key: fromkey,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sign Up to Canari',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
          height(20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: buildTextFiled(
              controller: FirstnameController,
              keyboardType: TextInputType.name,
              hintText: 'First name',
              valid: 'first name',
            ),
          ),

          height(15),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: buildTextFiled(
              controller: LastnameController,
              valid: 'last name',
              keyboardType: TextInputType.name,
              hintText: 'Last name',
            ),
          ),
          height(15),
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
                            color: AppColor,
                            width: 2)),
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
          height(15),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: GestureDetector(
              onTap:ontap,
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
          height(6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('I have an account !'),
              TextButton(onPressed:onpress,
                  child: Text('Login', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16),))
            ],
          ),
        ],
      ),
    ),
  );
}


// buildFilter({HashSet selectFilters, List categories}){
//   return  Directionality(
//     textDirection: TextDirection.rtl,
//     child: Padding(
//       padding: const EdgeInsets.only(left:15,top: 20,right: 10),
//       child:SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children:[
//             Padding(
//               padding: const EdgeInsets.only(left: 7,top: 0),
//               child: Text("مرشحات شعبية",style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold
//               ),),
//             ),
//             height(10),
//             ...Popular_Filters.map((e){
//               return
//                 StatefulBuilder(
//                   builder:(context,state){
//                     return GestureDetector(
//                       onTap: () {
//                         state(() {
//                           if (selectFilters.contains(e)) {
//                             selectFilters.remove(e);
//                           } else {
//                             selectFilters.add(e);
//                           }
//                           print(selectFilters);
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 10,right: 15,top: 10,bottom: 10),
//                         child: Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('${e}',style: TextStyle(
//                                   color: Color(0xFF828894),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500
//                               ),),
//                               Icon(selectFilters.contains(e)?Icons.check_box:Icons.check_box_outline_blank,color:selectFilters.contains(e)?Colors.red:Color(0xFF828894)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//             }),
//             Padding(
//               padding: const EdgeInsets.only(left: 7,top: 15),
//               child: Text("فئات",style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold
//               ),),
//             ),
//             height(10),
//             ...categories.map((e){
//               return
//                 StatefulBuilder(
//                   builder:(context,state){
//                     return GestureDetector(
//                       onTap: () {
//                         state(() {
//                           if (selectCategories.contains(e['name'])) {
//                             selectCategories.remove(e['name']);
//                           } else {
//                             selectCategories.add(e['name']);
//                           }
//                           print(selectCategories);
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 10,right: 15,top: 10,bottom: 10),
//                         child: Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('${e['name']}',style: TextStyle(
//                                   color: Color(0xFF828894),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500
//                               ),
//                               ),
//                               Icon(selectCategories.contains(e['name'])?Icons.check_box:Icons.check_box_outline_blank,color:selectCategories.contains(e['name'])?Colors.red:Color(0xFF828894)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//             }),
//           ],
//         ),
//       ),
//     ),
//   );
// }


Widget buildButton({bool ishow,Function ontap}){
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              spreadRadius: 1,
              offset: Offset(0, 1)
          )
        ]),
    height: 75,
    child: Padding(
      padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10,top: 10),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:ishow?AppColor:Colors.grey,
          ),
          width: double.infinity,
          child: Center(child: Text('أضف إلى السلة',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),
        ),
      ),
    ),
  );
}