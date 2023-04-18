import 'package:flutter/material.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/modules/pages/RestaurantPage/resturantCategories.dart';

class ResturantCategoriesItem extends SliverPersistentHeaderDelegate{
   final int selectedIndex;
   final ShopCubit cubit;
   final ValueChanged<int>onchanged;
  ResturantCategoriesItem({this.selectedIndex,this.cubit,this.onchanged,});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
   return cubit.store['menus'].length!=0? Container(
     height: 52,
     decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 226, 226, 226),
          offset: Offset(1, 0),
          blurRadius: 0.3,
          spreadRadius: 0
        )
      ]
     ),
     child: ResturantCategories(
       cubit: cubit,
        selectedIndex:selectedIndex,
        onchange: onchanged,
        ),
   ):Container(
     height: 52,
     child: Text(''),
   );
  }

  @override
  double get maxExtent => 52;
  @override
  double get minExtent =>52;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}
