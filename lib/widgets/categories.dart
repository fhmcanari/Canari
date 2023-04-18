import 'dart:collection';

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/shared/components/components.dart';

class Category extends StatelessWidget {
  const Category({
    Key key,
    @required this.cubit,
    this.selectFilters,
  }) : super(key: key);

  final ShopCubit cubit;

  final HashSet selectFilters;
  @override
  Widget build(BuildContext context) {
    return BuildCondition(
      condition: cubit.isloading,
      builder: (context){
        return category(context,selectFilters);
      },
      fallback: (context){
        return Container(
     height: 90,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return width(10);
          },
          physics: BouncingScrollPhysics(),
          itemCount:7,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                Shimmer.fromColors(
                   baseColor: Colors.grey[300],
                   period: Duration(seconds: 2),
                   highlightColor: Colors.grey[100],
                   child: Container(
    height: 80,
    width: 100,
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 139, 139, 139),
      borderRadius: BorderRadius.circular(5),
    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 35),
                  child: Text(
    "",
    style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          }),
    ));
      },
     );
  }
}

