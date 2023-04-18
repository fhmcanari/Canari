import 'package:flutter/material.dart';
import 'package:shopapp/Layout/HomeLayout/home_page.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';

class Cartempty extends StatefulWidget {
  const Cartempty({Key key}) : super(key: key);

  @override
  _CartemptyState createState() => _CartemptyState();
}

class _CartemptyState extends State<Cartempty> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

         Text('عربة التسوق فارغة',style: TextStyle(color:Color(0xFF6b7280),fontSize: 26,fontWeight: FontWeight.bold),),
            height(20),
            Center(
              child: Image.network('https://canariapp.com/_nuxt/img/empty-cart.761fc5a.png'),
            ),

          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
               latitude:latitude ,
               longitude:longitude,
               myLocation: myLocation,                  
                                          )), (route) => route.isFirst);
            },
            child: Container(
              height: 60,
              width: 200,
              child: Center(child: Text('عرض المطاعم',style: TextStyle(color: AppColor,fontWeight: FontWeight.bold,fontSize: 20),textAlign:TextAlign.center)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColor,
                  width: 1.5
                )
              ),
             
            ),
          )
         ],
        ),);
  }
}
