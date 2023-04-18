import 'dart:collection';

import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/shared/components/components.dart';

import '../modules/pages/filters.dart';

class Sliders extends StatefulWidget {
  const Sliders({
    Key key,
    @required this.cubit, @required this.selectFilters,
  }) : super(key: key);

  final ShopCubit cubit;
  final HashSet selectFilters;

  @override
  State<Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  Widget build(BuildContext context) {
    return BuildCondition(
      condition: widget.cubit.isloading,
      builder: (context){
        return  Padding(
        padding: const EdgeInsets.only(left: 5,right: 15),
        child: Container(
            height: 135,
            color: Colors.white,
            child: ListView.separated(
                separatorBuilder: (context, index){
                  return width(12);
                },
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.cubit.sliders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      print(widget.selectFilters);
                      widget.selectFilters.add(widget.cubit.sliders[index]['name']);
                      var text = "";
                      widget.selectFilters.forEach((element) {
                        text = text + element + ',';
                      });
                      navigateTo(context, Filters(selectCategories: widget.selectFilters,text: text));

                      // navigateTo(context, Filters(selectCategories: selectFilters,text: text));
                    },
                    child: Container(
                      height: 135,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(5),
                        child: CachedNetworkImage(
                            imageUrl: '${widget.cubit.sliders[index]['image']}',
                            placeholder: (context, url) =>
                                Image.asset('assets/placeholder.png',fit: BoxFit.cover),
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
                    ),
                  );
                })),
      );
      },
      fallback: (context){
      return  Padding(
        padding: const EdgeInsets.only(left: 15,right: 15),
        child: Container(
            height: 135,
            color: Colors.white,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return width(12);
                },
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                     baseColor: Colors.grey[300],
                     period: Duration(seconds: 2),
                     highlightColor: Colors.grey[100],
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey,),
                      height: 135,
                      width: 280,
                    ),
                  );
                })),
      );
      },
    );
  }
}