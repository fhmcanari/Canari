import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/apiService/store/storeApi.dart';
import 'package:shopapp/class/data.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:shopapp/shared/network/remote/dio_helper.dart';
import '../../shared/network/remote/cachehelper.dart';
import 'shopstate.dart';
import 'package:http/http.dart' as http;
final dataService = new DataSource();
class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopIntiaialStates());
  static ShopCubit get(context) => BlocProvider.of(context);

  List<dynamic> cuisines = [];
  List<dynamic> offers = [];
  List<dynamic> menu = [];
  List<dynamic> dishes = [];
  List<dynamic> itemCart=[];
  bool isloading = true;
  List categories = [];
  List<dynamic> stores = [];
  int qty = 1;

  void minus(){
    if (qty > 1) {
      qty--;
      emit(minusSucessfulState());
    }
  }

  void plus(){
     qty++;
     emit(pluseSucessfulState());
  }

  void getcategoriesData() {
    emit(GetCategoryDataLoadingState());
    isloading = false;
    getCategorieApi().then((value) {
      categories = value;
      isloading = true;
      print(categories[0]['image']=='');
      emit(GetCategoryDataSucessfulState());
    }).catchError((error) {
      print(error.toString());
      emit(GetCategoryDataErrorState(error.toString()));
    });
  }

  getStoresData({latitude,longitude}){
    emit(GetResturantDataLoadingState());
     isloading = false;
     getStoresApi(latitude:latitude,longitude: longitude).then((value){
      stores = value;
      isloading = true;
      emit(GetResturantDataSucessfulState());
    }).catchError((error) {
      print(error.toString());
      emit(GetResturantDataErrorState(error.toString()));
    });
  }
 Map<String,dynamic> store;

  getStoreData({String slug,}) {
    emit(GetResturantPageDataLoadingState());
    getStoreApi(slug: slug,latitude:latitude ,longitude: longitude).then((value) {
    isloading = true;
    store = value;
    storeLatitude = store['latitude'];
    storeLongitude = store['longitude'];
  //    restaurant = value.data;
  //  restaurant.forEach((element) { 
  //    dataService.menu = element['menu'];
     
  //  });
      emit(GetResturantPageDataSucessfulState());
    }).catchError((error) {
      print(error.toString());
      emit(GetResturantPageDataErrorState(error.toString()));
    });
  }
   
   List sliders = [];
  void getSliders() {
    emit(GetSlidersLoadingState());
     isloading = false;
     getSliderApi().then((value) {
      sliders = value;
       isloading = true;
       print(value);
      emit(GetSlidersSucessfulState());
    }).catchError((error) {
      print(error.toString());
      emit(GetSlidersErrorState(error.toString()));
    });
  }

  List search = [];
  void getSearchData(String value) {
    emit(GetSearchLoadingState());
    DioHelper.getData(
        url: 'https://api.canariapp.com/v1/client/stores?city=1&search=${value}&all=true&locale=ar',
       ).then((value) {
      search = value.data;
      print(search);
      emit(GetSearchSucessfulState());
    }).catchError((error) {
      print(error.toString());
      emit(GetSearchErrorState(error.toString()));
    });
  }

  List products = [];
  bool isStoreExit = false;
  bool isinCart = false;
   addToCart({product,productStoreId,productId,Qty,attributes,storeStats}){

      if(dataService.itemsCart.length==0){
        dataService.itemsCart.add({
          "storeStatus":storeStats,
       "productStoreId":productStoreId,
       "id":product['id'],
       "quantity":Qty,
       "name":product['name'],
       "descripton":product['description'],
       "image":product['image'],
       "price":product['price'],
       "attributes":products
     });
     attributes.forEach((e){
       e['products'].forEach((e){
         products.add({
           "id":e['id'],
           "quantity":1,
           "price":e['price'],
           "name":e['name']
         });
       });
     });
        isinCart = true;
     emit(AddtoCartSucessfulState(getTotalPrice()));
         getTotalPrice();
      }else{
        var cantainStore = dataService.itemsCart.where((element) => element['productStoreId']==productStoreId).toList();
        if(cantainStore.isNotEmpty){
          var containProduct = dataService.itemsCart.where((element) => element['id']==product['id']).toList();
          if(containProduct.isEmpty){
            dataService.itemsCart.add({
              "storeStats":storeStats,
              "productStoreId": productStoreId,
              "id": product['id'],
              "quantity": Qty,
              "name": product['name'],
              "descripton": product['description'],
              "image": product['image'],
              "price": product['price'],
              "attributes": products
            });
            attributes.forEach((e) {
              e['products'].forEach((e) {
                products.add({
                  "id": e['id'],
                  "quantity": 1,
                  "price": e['price'],
                  "name": e['name']
                });
              });
            });

            emit(AddtoCartSucessfulState(getTotalPrice()));
            getTotalPrice();
          }else{
            containProduct.forEach((element){
        element['quantity']=element['quantity']+Qty;

      });

      getTotalPrice();
      emit(AddtoCartSucessfulState(getTotalPrice()));
    }
        }else{
          isStoreExit = true;
          emit(ChangevalueState());
          print('you cant add this store to the cart');

        }
      }



  }
 
  void removeItem({product, productStoreId,productId,Qty}){
     var contain = dataService.itemsCart.where((element) => element['id']==product['id']);
      contain.forEach((element) {
        element['quantity']=element['quantity']-Qty;
         if (element['quantity']==0) {
          dataService.itemsCart.removeWhere((item) => item["id"]==product['id']);
          dataService.productsCart.removeWhere((item) => item["id"]==product['id']);
          emit(RemovetoCartSucessfulState()); 
        }
      });

   }






   getCartItem(){
     return dataService.itemsCart.length;
   }
   getTotalPrice(){
    var totalPrice = 0.0;
    dataService.itemsCart.forEach((element){
      if(element['attributes'].length==0){
        totalPrice = totalPrice + double.parse(element['price']) * element['quantity'];
      }else{
        totalPrice = totalPrice + double.parse(element['price']) * element['quantity'];
        print(element['attributes']);
        for(var i = 0 ;i<element['attributes'].length;i++){
          totalPrice = totalPrice + double.parse(element['attributes'][i]['price']);
        }
      }
    });
    return totalPrice;
  }

  Future CheckoutApi(payload)async{
    isloading = false;
    String access_token = Cachehelper.getData(key: "token");
    printFullText('checkout :${payload}');
    emit(CheckoutLoadingState());
    http.Response response = await http.post(
        Uri.parse('https://www.api.canariapp.com/v1/client/orders'),
        headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${access_token}',},
        body:jsonEncode(payload)
    ).then((value) {
      var responsebody = jsonDecode(value.body);
      printFullText(value.body.toString());
      Myorder(responsebody['order_ref']);
      emit(CheckoutSucessfulState());
    }).catchError((error){
      printFullText(error.toString());
      emit(CheckoutErrorState(error.toString()));
    });

    return response;
  }


  Future Myorder(refcode)async{
    String access_token = Cachehelper.getData(key: "token");
        emit(MyorderLoadingState());
    isload = false;
    http.Response response = await http.get(
        Uri.parse('https://www.api.canariapp.com/v1/client/orders/${refcode}?include=products,store'),
        headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${access_token}',}
    ).then((value) {

      var responsebody = jsonDecode(value.body);
      myorder = responsebody;
      printFullText('order:${responsebody.toString()}');

      isload = true;
       dataService.itemsCart.clear();
      emit(MyorderSucessfulState(responsebody));
    }).catchError((error){

      printFullText(error.toString());
      emit(MyorderErrorState(error.toString()));
    });
    printFullText(response.toString());
    return response;
  }

 List myorders = [];
  Map<String, dynamic> myorder = {};
  bool isload = false;
  bool isorderLoading= false;

  Future Myorders()async{
    String access_token = Cachehelper.getData(key: "token");
    emit(MyordersLoadingState());
    isorderLoading = false;
    http.Response response = await http.get(
        Uri.parse('https://www.api.canariapp.com/v1/client/orders?include=products,store'),
        headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${access_token}',}
    ).then((value) {
      var responsebody = jsonDecode(value.body);

      myorders = responsebody['data'];
      printFullText(myorders.toString());
      isorderLoading = true;
      isload = true;
      emit(MyordersSucessfulState(responsebody));
    }).catchError((error){
      printFullText(error.toString());
      emit(MyordersErrorState(error.toString()));
    });
    return response;
  }




  Future RegisterApi(data) async{
    print('register :${data}');
    emit(RegisterLoadingStates());
    http.Response response = await http.post(
        Uri.parse('https://www.api.canariapp.com/v1/client/register'),
        headers:{'Content-Type':'application/json','Accept':'application/json',},
    body: jsonEncode(data)
    ).then((value) {
      var responsebody = jsonDecode(value.body);
      Cachehelper.sharedPreferences.setString("deviceId",responsebody['device_id'].toString());
      Cachehelper.sharedPreferences.setString("token",responsebody['token']);
      print('============================================================');
      printFullText(responsebody.toString());
      Cachehelper.sharedPreferences.setString("first_name",responsebody['client']['first_name']);
      Cachehelper.sharedPreferences.setString("last_name",responsebody['client']['last_name']);
      Cachehelper.sharedPreferences.setString("phone",responsebody['client']['phone']);
      print('--------------------------------------------------------------------');
      printFullText('data : ${responsebody.toString()}');
      print('============================================================');
      emit(RegisterSucessfulState(responsebody));
    }).catchError((error) {
      printFullText('error ${error.toString()}');
      emit(RegisterErrorState(error.toString()));
    });
    print(response);
    return response;
  }

  Future LoginApi(data) async{
    print('-----------------------------------');
    printFullText(data.toString());
    print('-----------------------------------');
    emit(LoginLoadingStates());
    await  DioHelper.postData(
      data:data,
      url: 'https://www.api.canariapp.com/v1/client/login',
    ).then((value) {
      printFullText(value.data.toString());
      //  // var responsebody = jsonDecode(value.data);
      //  Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
      //  Cachehelper.sharedPreferences.setString("token",value.data['token']);
      // // print('============================================================');
      // // printFullText(responsebody.toString());
      // Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
      // Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
      // Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
      emit(LoginSucessfulState(value.data));
    }).catchError((error) {
      printFullText(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }

  void FilterData({latitude,longitude,text}) {
     emit(GetFilterDataLoadingState());

    isloading = false;
    FilterDataApi(latitude:latitude,longitude: longitude,elements:text).then((value){
      isloading = true;
      print(text);
      print(value);
      emit(GetFilterDataSucessfulState(value));
    }).catchError((error) {
      print(error.toString());
       emit(GetFilterDataErrorState(error.toString()));
    });
  }

  Future UpdateProfile(data) async{
    String access_token = Cachehelper.getData(key: "token");
    emit(UpdateProfileLoadingState());
    http.Response response = await http.put(
        Uri.parse('https://api.canariapp.com/v1/client/profile'),
        headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${access_token}'},
        body: jsonEncode(data)
    ).then((value) {
      var responsebody = jsonDecode(value.body);
      print('============================================================');
      printFullText(responsebody.toString());
      Cachehelper.sharedPreferences.setString("first_name",responsebody['first_name']);
      Cachehelper.sharedPreferences.setString("last_name",responsebody['last_name']);
      Cachehelper.sharedPreferences.setString("phone",responsebody['phone']);
      printFullText(responsebody.toString());
      print('============================================================');
      emit(UpdateProfileSucessfulState());
    }).catchError((error) {
      printFullText('error ${error.toString()}');
      emit(UpdateProfileErrorState(error.toString()));
    });
    print(response);
    return response;
  }



}
