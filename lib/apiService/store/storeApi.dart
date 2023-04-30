import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopapp/shared/components/components.dart';

import '../../shared/network/remote/cachehelper.dart';



 Future getStoresApi({latitude,longitude})async{
  String access_token = Cachehelper.getData(key: "token");
  http.Response response = await http.get(
       Uri.parse('https://www.api.canariapp.com/v1/client/stores?include=menus.products.modifierGroups.products,menus.products&latitude=${latitude}&longitude=${longitude}&all=true&locale=ar'),
    headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${access_token}'},
   );

   var responsebody = jsonDecode(response.body);
    print('---------------------------------------------------------');
    printFullText(responsebody.toString());
   print('---------------------------------------------------------');
    return responsebody;
  }

 Future getStoreApi({slug,latitude,longitude})async{
   http.Response response = await http
    .get(Uri.parse('https://www.api.canariapp.com/v1/client/stores/${slug}?include=menus.products.modifierGroups.products,menus.products&latitude=${latitude}&longitude=${longitude}'));
    var responsebody = jsonDecode(response.body);
    printFullText('get store ${responsebody.toString()}');
    return responsebody;
  }

  Future getCategorieApi()async{
   http.Response response = await http
    .get(Uri.parse('https://www.api.canariapp.com/v1/client/categories?locale=ar'));
    var responsebody = jsonDecode(response.body); 
    return responsebody;
  }


  Future getAreasApi()async{
   http.Response response = await http
    .get(Uri.parse('https://www.api.canariapp.com/v1/client/areas'));
    var responsebody = jsonDecode(response.body); 
    return responsebody;
  }

Future getSliderApi()async{
 http.Response response = await http.get(Uri.parse('https://www.api.canariapp.com/v1/client/sliders'));
 var responsebody = jsonDecode(response.body);
 return responsebody;
}

Future CheckoutApi(payload)async{
 http.Response response = await http.post(
     Uri.parse('https://www.api.canariapp.com/v1/client/orders'),
     body:payload
 );
 var responsebody = jsonDecode(response.body);
 return responsebody;
}


Future FilterDataApi({latitude,longitude,elements})async{
 String access_token = Cachehelper.getData(key: "token");
  var url = 'https://api.canariapp.com/v1/client/stores?filter[categories.translations.name]=${elements}&latitude=${latitude}&longitude=${longitude}&all=true&locale=ar';
 http.Response response = await http
     .get(Uri.parse(url),
  headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${access_token}'},
 );
 print(url);
 var responsebody = jsonDecode(response.body);
 return responsebody;
}