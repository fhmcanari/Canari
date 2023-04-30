import 'package:flutter/material.dart';
import '../../Layout/HomeLayout/home_page.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class ServiceOff extends StatefulWidget {
  const ServiceOff({Key key}) : super(key: key);

  @override
  State<ServiceOff> createState() => _ServiceOffState();
}

class _ServiceOffState extends State<ServiceOff> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.fastfood,size: 100,color: AppColor),
              height(20),
              Text('! مرحبا بك في كناري ',style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500
              ),),
              height(20),
             Padding(
               padding: const EdgeInsets.only(left: 20,right: 20),
               child: Container(
                 child:Text('أود إخباركم أن خدمتنا لم تبدأ بعد. نحن نعمل بجد لنقدم لك أفضل تجربة ممكنة وسنعلمك بمجرد استعدادنا للانطلاق. شكرا لصبرك و تفهمك',style: TextStyle(
                   height: 2
                 ),textAlign: TextAlign.center,),
               ),
             ),

              Padding(padding: EdgeInsets.only(left: 22,right: 22,top: 50),
              child: SizedBox(
                height: 55.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(AppColor), // set the background color of the button to red
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context)=>
                            MyHomePage(
                              latitude: latitude,
                              longitude: longitude,
                              myLocation: myLocation,
                            )), (route) => false);
                  },
                  child: Text('تصفح تطبيق'),
                ),
              ),
              )
            ],
          ),
        )
    );
  }
}
