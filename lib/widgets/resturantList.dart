import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/modules/pages/RestaurantPage/restaurant_page.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';

class ResturantList extends StatelessWidget {
  final Restaurant;
  final id;
  const ResturantList({
    Key key, this.Restaurant, this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 2,top: 0,bottom: 10),
      child: InkWell(
        onTap: (){
           Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RestaurantPage(

                          name: Restaurant['name'],
                          slug:  Restaurant['slug'],
                          cover: Restaurant['cover'],
                          price_delivery: Restaurant['delivery_price'],
                          rate: Restaurant['rate'],
                          deliveryTime: Restaurant['delivery_time'],
                          cuisines: Restaurant['categories'],
                          id:id,
                          brandlogo:Restaurant['logo'] ,
                        )));
        },
        child: Container(
          child: Row(
          children: [
          Padding(
           padding: const EdgeInsets.only(left: 0,bottom: 0),
           child: Container(
             width: 75,
             height: 75,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(5),
             ),
             child:ClipRRect(
                 borderRadius: BorderRadius.circular(5),
                 child:CachedNetworkImage(
                     imageUrl: '${Restaurant['logo']}',
                     placeholder: (context, url) =>
                         Image.asset('assets/placeholder.png',fit: BoxFit.cover),
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
          ),
            Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(right: 10),
                     child: Text(
                       '${Restaurant['name']}',
                        style:TextStyle(
                           fontWeight: FontWeight.normal,
                           color: Color(0xFF000000),
                           fontSize: 15),
                     ),
                   ),
                 ],
               ),
               height(3),
               Padding(
                 padding: const EdgeInsets.only(right: 10),
                 child: Row(
                   children: [
                     ...Restaurant['categories'].map((categorie){
                       return Row(
                         children:[
                           Text(
                             '${categorie['name']}',
                             style: TextStyle(
                               fontSize: 11,
                               fontWeight: FontWeight.w500,
                               color: Color.fromARGB(255, 68, 71, 71),
                             ),
                           ),
                           Text(
                             '  ',
                             style: TextStyle(
                               fontSize: 10,
                               fontWeight: FontWeight.normal,
                               color: Color.fromARGB(255, 68, 71, 71),
                             ),
                           ),
                         ],
                       );
                     })
                   ],
                 ),
               ),

               height(5),
               Padding(
                 padding: const EdgeInsets.only(right: 10),
                 child: Row(
                   children: [
                     Icon(Icons.star,color: Colors.yellow,size: 14,),
                     width(5),
                     Text(
                       '${Restaurant['rate']} Excellent',
                        style: TextStyle(
                         fontSize:10.5,
                         color: Color.fromARGB(255, 68, 71, 71), fontWeight: FontWeight.w500)
                     ),
                      width(5),
                     Container(
                       height: 20,
                       decoration: BoxDecoration(
                           color:Color.fromARGB(255, 78, 78, 78),
                           shape: BoxShape.circle
                       ),
                       width: 4.5,

                     ),
                      width(5),
                      Row(
                     children: [
                       if(Restaurant['delivery_time']!=null)
                       Row(
                         children: [

                           Icon(Icons.timer_outlined,color: Colors.black,size: 14,),
                           width(2.5),

                           Text(
                               '${Restaurant['delivery_time']} دقيقة ',
                               style: TextStyle(
                                   fontSize:10.5,
                                   color: Color.fromARGB(255, 78, 78, 78), fontWeight: FontWeight.w500)
                           ),
                           width(5),
                           Container(
                             height: 20,
                             decoration: BoxDecoration(
                                 color:Color.fromARGB(255, 78, 78, 78),
                                 shape: BoxShape.circle
                             ),
                             width: 4.5,

                           ),
                         ],
                       ),
                       if(Restaurant['delivery_time']!=null)
                       width(5),
                     Row(
                   children: [
                     Icon(Icons.delivery_dining_outlined,color: Restaurant['delivery_price']!=0?Colors.black:AppColor,size: 14,),
                      width(5),
                     Text(
                         Restaurant['delivery_price']!=0?'${Restaurant['delivery_price']} درهم ':'توصيل مجاني',
                        style: TextStyle(
                         fontSize:10.5,
                         color:Restaurant['delivery_price']!=0? Color.fromARGB(255, 78, 78, 78):AppColor,fontWeight:FontWeight.bold)
                     ),
                   ],
                 ),
                   ],
                 ),
                   ],
                 ),
               ),


             ],
           ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}