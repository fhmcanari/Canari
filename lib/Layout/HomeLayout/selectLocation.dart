import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopapp/Layout/HomeLayout/home_page.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopapp/shared/network/remote/cachehelper.dart';
import '../../SearchMapApi.dart';
import '../../shared/components/constants.dart';
import 'package:uuid/uuid.dart';
class SelectLocation extends StatefulWidget {
  final String routing;
  const SelectLocation({ Key key, this.routing }) : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  var myLocation = 'اختر موقع';
  bool ismylocation = false;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(27.149890, -13.199970),
      zoom: 15.2356,
    );
  LatLng currentLocation = _initialCameraPosition.target;
  Position currentPosition;
  var latitude;
  var longitude;
  bool locationCollected = true;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      return false;
    }
    return true;
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).then((value) {
      latitude = value.latitude;
      longitude = value.longitude;
      ismylocation =true;
      // lat = value.latitude;
      // lag = value.longitude;
      locationCollected = true;
      _animateCamera(value);
      setState(() {});
      return value;
    });

    return position;
  }

  Future<void> _getCurrentPosition() async{
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
         latitude = position.latitude;
         longitude =position.longitude;
         locationCollected = true;

         _animateCamera(position);
      setState(() => currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _animateCamera(Position position)async{
    final GoogleMapController controller = await _controller.future;
    CameraPosition _cameraPosition = CameraPosition(
        target:LatLng(position.latitude, position.longitude),
      zoom: 17.4746
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
   }

  Future getPlace({latitude,longitude,bool myaddres})async{
    print(myaddres);
    List placemarks = await placemarkFromCoordinates(latitude,longitude);
         myLocation = placemarks[0].street;
         setState(() {

         });
  }

  Set<Marker>myMarkers={
   Marker(

      markerId: MarkerId('1'),
      position:LatLng(27.149890, -13.199970),
   )
  };

    var uuid = Uuid();

    void onChange(){
     if(sessionToken==null){
       setState(() {
         sessionToken = uuid.v4();
       });
     }

    }








  @override
  void initState(){
    _handleLocationPermission();
     getPlace(latitude:27.149890 ,longitude:-13.199970,);
     latitude = 27.149890;
     longitude= -13.199970;
    super.initState();
  }
  @override

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: ()async{
          await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
            latitude: latitude,
            longitude: longitude,
            myLocation: myLocation,
          )), (route) => false);
          return false;
        },
        child: Scaffold(
                  appBar:appbar(context,myLocation: myLocation,icon: Icons.search, iconback: null,
                      ontap: ()async{
                        var mylist;
                        mylist = await showSearch(context: context, delegate: SearchMapApi());
                        print(mylist);
                        final GoogleMapController controller = await _controller.future;
                        CameraPosition _cameraPosition = CameraPosition(
                            target:LatLng(mylist['latitude'], mylist['longitude']),
                            zoom: 17.4746
                        );
                        controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                        setState(() {
                          latitude = mylist['latitude'];
                          longitude = mylist['longitude'];
                        });

                      },),


          bottomNavigationBar:
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 15,top: 15,right:20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('تسليم الى',style: TextStyle(color: Color.fromARGB(255, 116, 117, 117),fontWeight: FontWeight.w400,fontSize: 14.50)),
                  height(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined,size: 17,color: Colors.red),
                      width(6),
                      Expanded(child: Text('${myLocation}',style: TextStyle(color: Color.fromARGB(255, 68, 71, 71),fontWeight: FontWeight.w600,fontSize: 14,),maxLines: 1,)),
                    ],
                  ),
                  height(8),
                  GestureDetector(
                    onTap: (){
                      if(widget.routing=="checkout"){
                        myLocation = myLocation;
                        Cachehelper.sharedPreferences.setString('myLocation', myLocation);
                        Cachehelper.sharedPreferences.setDouble('latitude', latitude);
                        Cachehelper.sharedPreferences.setDouble('longitude', longitude);
                       setState(() {
                         Navigator.pop(context,'${myLocation}');
                       });
                      }else {
                       myLocation = myLocation;
                       Cachehelper.sharedPreferences.setString('myLocation', myLocation);
                       Cachehelper.sharedPreferences.setDouble('latitude', latitude);
                       Cachehelper.sharedPreferences.setDouble('longitude', longitude);

                       Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyHomePage(
                         myLocation:myLocation,
                         latitude:latitude,
                         longitude:longitude,
                       )));
                      }

                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color:AppColor,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        height: 50,
                        width: double.infinity,
                        child: Center(child: Text('تسليم هنا',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),))),
                  ),
                  height(10),
                ],
              ),
            ),
          ),
                  backgroundColor: Colors.white,
                  floatingActionButton:FloatingActionButton(
                    child:locationCollected?Icon(Icons.location_searching):CircularProgressIndicator(backgroundColor: Colors.white),
                    onPressed: (){
                      setState(() {
                        getLocation();
                        locationCollected = false;
                      });
                      _handleLocationPermission();
                      _getCurrentPosition();
                    },
                  ) ,
                  body:GoogleMap(
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller){
                      _controller.complete(controller);

                    },
                    onCameraMove: (CameraPosition position){
                      myMarkers.remove(Marker(markerId: MarkerId('1')));
                      myMarkers.add(Marker(markerId: MarkerId('1'),position: LatLng(position.target.latitude, position.target.longitude)));
                      latitude =position.target.latitude;
                      longitude= position.target.longitude;
                      setState((){
                      });
                    },
                    onCameraIdle: (){
                      setState(() {
                        getPlace(longitude:longitude ,latitude: latitude);
                      });
                    },

                    initialCameraPosition:_initialCameraPosition,
                    markers: myMarkers,
                  ),
                ),
      ),
    );
  }


}



