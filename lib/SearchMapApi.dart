import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shopapp/shared/components/constants.dart';

import 'class/services.dart';
final service = new Services();
class SearchMapApi extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        this.query = '';
      }, icon: Icon(Icons.close))
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back));
  }
  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Text('No results found');
    }
    return FutureBuilder(
        future:service.getSuggestion(query),
        builder: (_,AsyncSnapshot snapshot){
          print('data:${service.placesList.length>0}');
            return service.placesList.length>0 ? ListView.builder(
                itemCount:service.placesList['predictions'].length,
                itemBuilder: (context,index){
                  final data = service.placesList['predictions'];
                  print(service.placesList['predictions']);
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0),color: Colors.white,),
                      child: ListTile(
                        onTap: ()async{
                          List<Location> locations = await locationFromAddress(data[index]['description']);
                          print(locations.last.latitude);
                          print(locations.last.longitude);
                          print(data[index]['description']);
                          var place = {
                            "latitude":locations.last.latitude,
                            "longitude":locations.last.longitude,
                            "address":data[index]['description']
                          };
                          latitude = locations.last.latitude;
                          longitude = locations.last.longitude;
                          this.close(context,place,);
                        },
                        trailing: Icon(Icons.location_on_outlined,color: Colors.orange),
                        title: Text('${data[index]['description']}',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black)),

                      ),
                    ),
                  );
                }):Center(child: CircularProgressIndicator());

        });
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future:service.getSuggestion(query),
        builder: (_,AsyncSnapshot snapshot){
          print('data:${service.placesList}');
            return service.placesList.length>0 ? ListView.builder(
                itemCount: service.placesList['predictions'].length,
                itemBuilder: (context,index){

                  final data = service.placesList['predictions'];
                  print('place :${data[index]['description']}');
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0),color: Colors.white,),
                      child: ListTile(
                        onTap: ()async{
                          List<Location> locations = await locationFromAddress(data[index]['description']);
                          var place = {
                            "latitude":locations.last.latitude,
                            "longitude":locations.last.longitude,
                            "address":data[index]['description']
                          };

                          print(place);
                          this.close(context,place,);
                        },
                        trailing: Icon(Icons.location_on_outlined,color: Colors.black38),
                        title: Text('${data[index]['description']}',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black)),

                      ),
                    ),
                  );
                }):Center(child: CircularProgressIndicator());


        });
  }

}