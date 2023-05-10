import 'package:flutter/material.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class ServiceIosOff extends StatefulWidget {
  final String ServicetimingStart;
  const ServiceIosOff({Key key,this.ServicetimingStart}) : super(key: key);

  @override
  State<ServiceIosOff> createState() => _ServiceIosOffState();
}

class _ServiceIosOffState extends State<ServiceIosOff> {
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),

                  onPressed: () {

                  },
                  child: Text('اطلب من موقع'),
                ),
              ),
              )
            ],
          ),
        )
    );
  }
}
