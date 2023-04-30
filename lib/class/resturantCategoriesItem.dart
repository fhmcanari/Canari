import 'package:flutter/material.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/modules/pages/RestaurantPage/resturantCategories.dart';

class ResturantCategoriesItem extends SliverPersistentHeaderDelegate{
   final int selectedIndex;
   final isShow ;
   final ShopCubit cubit;
   final ValueChanged<int>onchanged;
  ResturantCategoriesItem( {this.selectedIndex,this.cubit,this.onchanged,this.isShow});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
   return cubit.store['menus'].length!=0? Container(
     height: 52,
     decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
       isShow?  BoxShadow(
                 color: Colors.grey.withOpacity(0.2),
                 spreadRadius: 2,
                 blurRadius: 4,
                 offset: Offset(1, 2), // changes position of shadow
               ):BoxShadow(
         color: Colors.grey.withOpacity(0.0),
         spreadRadius: 1,
         blurRadius: 2,
         offset: Offset(0, 0), // changes position of shadow
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
