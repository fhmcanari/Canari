import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/modules/pages/cartPage/cart_empty.dart';
import 'package:shopapp/modules/pages/checkout_page.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:shopapp/shared/components/constants.dart';


class CartPage extends StatefulWidget {
  CartPage({Key key,}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return  Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    title: Text(
                      'سلة',
                      style: TextStyle(
                        fontSize: 17,
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                    leading: GestureDetector(
                      onTap: (){
                        Navigator.pop(context,'${cubit.getTotalPrice()}');
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.black,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            left: 10,
                            child: CircleAvatar(
                              backgroundColor: AppColor,
                              child: Text(
                                "${dataService.itemsCart.length}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                              minRadius: 10,
                            ),
                          ),
                        ],
                      ),
                      //  Padding(
                      //       padding: const EdgeInsets.only(right: 20),
                      //       child: Icon(
                      //         Icons.delete_forever,
                      //         size: 28,
                      //         color: Colors.red,
                      //       ),
                      //     ),
                    ],
                  ),
                  body:dataService.itemsCart.length!=0?
                  SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: dataService.itemsCart.length,
                              itemBuilder: (context,index){

                                return Column(
                                  children: [
                                    CartItem(index,cubit,
                                        add:(){
                                          setState((){
                                            cubit.addToCart(product: dataService.itemsCart[index],Qty:cubit.qty,productStoreId:StoreId);
                                          });
                                        },
                                        padding: 25.0,
                                        remove:(){
                                      setState(() {
                                        cubit.removeItem(product:dataService.itemsCart[index],Qty:cubit.qty);
                                      });
                                    }),
                                  ],
                                );
                              }),

                        ],
                      )):Cartempty(),
                  bottomNavigationBar:dataService.itemsCart.length!=0?
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Summary(
                        context, cubit,
                        rout: 'الدفع',
                        ontap: (){
                      navigateTo(context, CheckoutPage());
                    }),
                  ):SizedBox(height: 0),
                );
              // : Cartempty();
        },
      ),
    );
  }



 
}
