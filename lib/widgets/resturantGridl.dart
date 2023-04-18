import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/modules/pages/RestaurantPage/restaurant_page.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';

class ResturantGridl extends StatefulWidget {
  final Restaurant;
  final id;
  final size;
   ResturantGridl({
    Key key, this.Restaurant, this.id,this.size
  }) : super(key: key);

  @override
  State<ResturantGridl> createState() => _ResturantGridlState();
}

class _ResturantGridlState extends State<ResturantGridl> {
  var price;
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: ()async{
        var totalPrice = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RestaurantPage(

                          name: widget.Restaurant['name'],
                          cover: widget.Restaurant['cover'],
                          price_delivery: widget.Restaurant['delivery_price'],
                          rate: widget.Restaurant['rate'],
                          deliveryTime: widget.Restaurant['delivery_time'],
                          cuisines: widget.Restaurant['categories'],
                          id:widget.id,
                          slug:widget.Restaurant['slug'],
                          brandlogo:widget.Restaurant['logo'] ,

                        )));
        setState(() {

          totalPrice = price;
        });
      },
      child: Container(
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(10),
       ),
       width: 275,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Stack(alignment: Alignment.topLeft, children: [
             Container(
               height: 125,
               width: double.infinity,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(5),
                 ),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(5),
                 child:
                 Container(
                   color: Colors.black,
                   child: Opacity(
                     opacity:widget.Restaurant['is_open']==false?0.3:1,
                     child: CachedNetworkImage(
                         height: 250,
                         width: double.infinity,
                         imageUrl: '${widget.Restaurant['cover']}',
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


               ),
             ),
             widget.Restaurant['is_open']==false?
             Padding(
               padding: const EdgeInsets.only(top: 50),
               child: Center(child: Text('مغلق',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16))),
             ):height(0),
             if(widget.Restaurant['delivery_time']!=null)
             Padding(
               padding:
                    EdgeInsets.only(top: 105, left: widget.size, right: 15),
               child: Container(
                 height: 35,
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.timer_outlined,size: 17),
                     width(2),
                     Text(
                   '${widget.Restaurant['delivery_time']} دقيقة ',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 12,
                     color: Colors.black,
                     fontWeight: FontWeight.w400,
                   ),
                 ),
                   ],
                 ),
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Colors.white,
                     boxShadow: [
                       BoxShadow(
                           color: Colors.grey[200], offset: Offset(0, 1))
                     ]),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
                 height: 65,
                 width: 65,
                 decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(5),
                     border: Border.all(
                       color: Colors.white,
                       width: 2,
                     )),
                 child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:CachedNetworkImage(
                      imageUrl: '${widget.Restaurant['logo']}',
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
                  )
               ),
             ),
           ]),
           Padding(
             padding:EdgeInsets.only(left: 12,right: 10,top: 10),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Row(
                   children: [
                     Text(
                       '${widget.Restaurant['name']}',
                        style:TextStyle(
                           fontWeight: FontWeight.normal,
                           color: Color(0xFF000000),
                           fontSize: 15),
                     ),
                   ],
                 ),
                 // Restaurant['categories']
                 height(3),
                 Wrap(
                   crossAxisAlignment: WrapCrossAlignment.start,
                   children: [
                     ...widget.Restaurant['categories'].map((cuisines) {

                       return Padding(
                         padding: const EdgeInsets.only(left: 5,bottom: 5),
                         child: Container(
                           
                           decoration: BoxDecoration(
                             color: Colors.grey[200],
                             borderRadius: BorderRadius.circular(3)
                           ),
                           child: Padding(
                             padding: const EdgeInsets.all(4.0),
                             child: Text(
                               '${cuisines['name']}',
                               style: TextStyle(
                                 fontSize: 9,
                                 fontWeight: FontWeight.w600,
                                 color: Color.fromARGB(255, 78, 78, 78),
                               ),
                               textAlign: TextAlign.center,
                             ),
                           ),
                         ),
                       );
                     })
                   ],
                 ),
                 height(5),
                 Row(
                   children: [
                     Container(
                         margin: EdgeInsets.only(bottom: 4),
                         child: Icon(Icons.star,color: Color(0xff77bf2a),size: 14,)),
                     width(2),
                     Text(
                       '${widget.Restaurant['rate']} Excellent',
                        style: TextStyle(
                         fontSize:10.5,
                         color: Color(0xff77bf2a), fontWeight: FontWeight.bold)
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
                      Icon(Icons.delivery_dining_outlined,color:widget.Restaurant['delivery_price']!=0?Colors.black:AppColor,size: 14,),
                       width(5),
                      Text(
                          widget.Restaurant['delivery_price']!=0?'${widget.Restaurant['delivery_price']} درهم ':"توصيل مجاني",
                         style: TextStyle(
                          fontSize:10.5,
                          color:widget.Restaurant['delivery_price']!=0? Color.fromARGB(255, 78, 78, 78):AppColor,
                             fontWeight: FontWeight.bold)
                      ),
                   ],
                 ),
                   ],
                 ),


                 // height(9),
               ],
             ),
           ),
         ],
       ),
            ),
    );
  }
}
