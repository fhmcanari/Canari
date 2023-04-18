
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/shared/components/constants.dart';

import '../../shared/components/components.dart';

class ProductDetail extends StatefulWidget {
 final dishes;
 final  int id;
 final StoreName;
 final storeStatus;
 final DeliveryPrice;
  const ProductDetail({ Key key,this.id, this.dishes, this.StoreName, this.DeliveryPrice, this.storeStatus,}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<dynamic> attributes = [];
  List<dynamic> products = [];
 bool isshow = false;
     check(){
       var checkmin = false;
     var  flag  = widget.dishes['modifierGroups'].where((e)=>e['min']!=0).toList().every((modifier){
      var contain = this.attributes.where((e) => e['id'] == modifier['id']).toList();
        if(contain.length==0){
          print('null');
        }else{
          checkmin = modifier['min'] <= contain[0]['products'].length;
        }
      return contain.isNotEmpty?checkmin:false;

       });
print(flag);
       if(flag){
         setState(() {
           isshow =true;
         });
       }else{
         isshow =false;
       }
    }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
    create: (BuildContext context) =>ShopCubit(),
    child: BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){
        var cubit = ShopCubit.get(context);
        if(state is AddtoCartSucessfulState){
          Navigator.pop(context,'${state.totalprice}');

        }
        if(state is ChangevalueState){
          dataService.itemsCart.clear();
          dataService.productsCart.clear();
          cubit.addToCart(product:widget.dishes,Qty:cubit.qty,productStoreId: widget.id,attributes:attributes,storeStats:widget.storeStatus);
        }
      },
      builder: (context,state){
         if(widget.dishes['modifierGroups'].length==0){
           isshow=true;
         }
        var cubit = ShopCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
               bottomNavigationBar:
               Container(
                 decoration: BoxDecoration(
                    color: Colors.white,
                   boxShadow: [
                   BoxShadow(
                     color: Colors.grey[300],
                     blurRadius: 3,
                     spreadRadius: 1,
                   offset: Offset(0, 2)
                   )
                 ]),
                 height: 75,
                 child:
                 Padding(
                        padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10,top: 10),
                        child: GestureDetector(
                          onTap: (){
                            StoreName = widget.StoreName;
                            StoreId = widget.id;
                            print(widget.id);
                            deliveryPrice = widget.DeliveryPrice;
                            check();
                            if(isshow){

                              cubit.addToCart(product:widget.dishes,Qty:cubit.qty,productStoreId: widget.id,attributes:attributes,storeStats: widget.storeStatus);
                              print(dataService.itemsCart);
                              setState(() {

                              });
                            }else{
                              print('select');
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:isshow?AppColor:Colors.grey,
                                  ),
                                  width: double.infinity,
                                  child: Center(child: Text('أضف إلى السلة',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                                  )
                                  ),
                                ),
                              ),
                              width(5),
                              Expanded(
                                child: Container(
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Icon(Icons.add,color: Colors.black,size: 30,),
                                        ),
                                        onTap: (){
                                          cubit.plus();
                                        },
                                      ),
                                      width(20),
                                      Text('${cubit.qty}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
                                      width(20),
                                      GestureDetector(
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color:Colors.grey[100],
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Icon(Icons.remove,color: Colors.black,size: 30,),
                                        ),
                                        onTap: (){
                                          cubit.minus();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
               ),
              body:SingleChildScrollView(
                physics:widget.dishes['modifierGroups'].length==0? NeverScrollableScrollPhysics():null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Stack(
                    children: [
                     Container(
                          height:widget.dishes['modifierGroups'].length==0? 250:250,
                          width: double.infinity,
                          color:  Colors.white,
                          child:widget.dishes['image']==''?
                          Image.asset('assets/placeholder.png',fit: BoxFit.cover,):
                          CachedNetworkImage(
                              imageUrl: '${widget.dishes['image']}',
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
                        Padding(
                          padding:EdgeInsets.only(top:widget.dishes['modifierGroups'].length==0?20:40,left: 15,right: 15),
                          child:GestureDetector(
                            onTap: (){
                              setState((){
                                Navigator.pop(context,'${cubit.getTotalPrice()}');
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.close,color: Colors.black,size: 25)),
                          ),
                        )
                   ],
                 ),
                 height(10),
                 Padding(
                      padding: const EdgeInsets.only(left: 15,top: 5,right: 15),
                      child: Text('${widget.dishes['name']}',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                    ),
                   height(10),
                    widget.dishes['description']!=null?   Column(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 15,top: 5,right: 15),
                           child: Text(
                             '${widget.dishes['description']}',
                             style:
                             TextStyle(
                                 fontSize: 14,
                                 fontWeight: FontWeight.normal,
                                 color: Colors.grey
                             ),
                           ),
                         ),
                       ],
                     ):height(0),
                    height(5),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children:[
                          Padding(
                          padding: const EdgeInsets.only(left: 15,top: 5,right: 15,bottom: 15),
                          child: Text('${widget.dishes['price']} درهم ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black),),
                    ),
                       ],
                       ),
                    widget.dishes['description']==null? height(30):height(0),

                    widget.dishes['modifierGroups'] != null ? StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return ListView.separated(
                          separatorBuilder: (context,index){
                            return Container(
                              height: 8,
                              width: double.infinity,
                              color: Colors.grey[100],
                            );
                          },
                            physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:widget.dishes['modifierGroups'].length,
                        itemBuilder: (context,index){

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                padding: const EdgeInsets.only(left: 15,bottom: 15,top: 10,right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.dishes['modifierGroups'][index]['name'],
                                            style:TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight:FontWeight.bold),
                                        ),
                                        height(8),
                                        Text(' اختر ما يصل الى   ${widget.dishes['modifierGroups'][index]['max']} ',style:TextStyle(
                                            color: Color(0xFFa4a7af),
                                            fontSize: 12.5,
                                            fontWeight:FontWeight.w500,),)
                                      ],
                                    ),

                                    widget.dishes['modifierGroups'][index]['min']!=0?
                                    Text('مطلوب',style: TextStyle(
                                      color: Color(0xFFa4a7af),
                                      fontSize: 12.5,
                                      fontWeight:FontWeight.w600,
                                    ),):
                                    Text('',style: TextStyle(
                                        color: Color(0xFFa4a7af),
                                      fontSize: 12.5,
                                      fontWeight:FontWeight.w600,
                          ),)
                                  ],
                                ),
                              ),
                                ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context,option){
                                  return Padding(
                                    padding:const EdgeInsets.only(left: 15,top: 10,bottom: 5,right: 15),
                                    child: GestureDetector(
                                      onTap: (){

                                        var myModifier = attributes.firstWhere((e) => e['id'] == widget.dishes['modifierGroups'][index]['id'],orElse: () => null);
                                        if(myModifier==null){
                                          attributes.add({
                                            "id":widget.dishes['modifierGroups'][index]['id'],
                                            "max":widget.dishes['modifierGroups'][index]['max'],
                                            "min":widget.dishes['modifierGroups'][index]['min'],
                                            "products":[widget.dishes['modifierGroups'][index]['products'][option]],
                                          });
                                          this.checkModifier(widget.dishes['modifierGroups'][index]['id'],widget.dishes['modifierGroups'][index]['products'][option]['id']);
                                          check();
                                        }
                                        else{
                                          if(myModifier['products'].length == myModifier['max'] &&  (myModifier['products'].firstWhere((p) => p['id'] == widget.dishes['modifierGroups'][index]['id'],orElse: () => null))==null){
                                            this.delete(widget.dishes['modifierGroups'][index]['id'],widget.dishes['modifierGroups'][index]['products'][option]['id']);
                                            myModifier['products'].add(widget.dishes['modifierGroups'][index]['products'][option]);
                                            this.checkModifier(widget.dishes['modifierGroups'][index]['id'],widget.dishes['modifierGroups'][index]['products'][option]['id']);
                                            check();
                                          }

                                          if(myModifier['products'].length < myModifier['max'] &&(myModifier['products'].firstWhere((p) => p['id'] == widget.dishes['modifierGroups'][index]['id'],orElse: () => null))==null){
                                            myModifier['products'].add(widget.dishes['modifierGroups'][index]['products'][option]);
                                            checkModifier(widget.dishes['modifierGroups'][index]['id'],widget.dishes['modifierGroups'][index]['products'][option]['id']);
                                            check();
                                          }

                                          else if(myModifier['min'] != 1 && (myModifier['products'].firstWhere((p) => p['id'] == widget.dishes['modifierGroups'][index]['id'],orElse: () => null))==null){
                                            this.delete(widget.dishes['modifierGroups'][index]['id'],widget.dishes['modifierGroups'][index]['products'][option]['id']);
                                            check();
                                          }
                                        }
                                        setState((){

                                        });
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        height: 45,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text('${widget.dishes['modifierGroups'][index]['products'][option]['name']}',style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,

                                              )),],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 15),
                                              child: Row(
                                                children: [
                                                  widget.dishes['modifierGroups'][index]['products'][option]['price']!="0.00"?Text(
                                                   '+ ${widget.dishes['modifierGroups'][index]['products'][option]['price']} MAD ',style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 13,
                                                      color: Colors.grey[600]
                                                  ),):Text(
                                                    '',style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                      color: Color(0xFF28c76f)
                                                  ),),
                                                  width(6),
                                                  checkModifier(widget.dishes['modifierGroups'][index]['id'],widget.dishes['modifierGroups'][index]['products'][option]['id'])==null?Icon(Icons.radio_button_off_rounded,color: Colors.grey,)
                                                      :Icon( checkModifier(widget.dishes['modifierGroups'][index]['id'],widget.dishes['modifierGroups'][index]['products'][option]['id'])?Icons.radio_button_checked:Icons.radio_button_off_rounded,
                                                       color:checkModifier(widget.dishes['modifierGroups'][index]['id'],widget.dishes['modifierGroups'][index]['products'][option]['id'])?Colors.red:Colors.grey,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                    separatorBuilder: (context,index){
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 15,right: 15,top: 5),
                                    child: Container(
                                      height: 0.5,
                                      width: double.infinity,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                    },
                                    itemCount: widget.dishes['modifierGroups'][index]['products'].length)

                              ],
                            ),
                          ),
                        );
                      });
                      },

                    ):SizedBox(height: 0,),

                     SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
  }

  void delete(id, productId) {
   var mymodifier = attributes.where((element) => element['id']==id).first;
   var product = mymodifier['products'].removeAt(0);

   setState(() {
      print(product);
   });

  }

  checkModifier(id, productId) {
  var mymodifier =attributes.firstWhere((e) => e['id'] == id,orElse: () => null);
  if(mymodifier!=null){
    var contain = mymodifier['products'].where((element) => element['id'] == productId);
    if (contain.isEmpty){
      return false;
    } else {
      return true;
    }
  }else{
    return null;
  }
  }

}