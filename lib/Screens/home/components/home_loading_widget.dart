import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_app/Utils/utils.dart';

class homeLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 30, bottom: 10),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                        child: CircleAvatar(
                          radius: 26,
                          backgroundColor:
                              Utils(context: context).WidgetShimmerColor,
                        ),
                        baseColor: Utils(context: context).baseShimmerColor,
                        highlightColor:
                            Utils(context: context).highlightShimmerColor),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Utils(context: context).baseShimmerColor,
                            highlightColor:
                                Utils(context: context).highlightShimmerColor,
                            child: Container(
                              width: 120,
                              height: 26,
                              decoration: BoxDecoration(
                                  color: Utils(context: context)
                                      .WidgetShimmerColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Shimmer.fromColors(
                            baseColor: Utils(context: context).baseShimmerColor,
                            highlightColor:
                                Utils(context: context).highlightShimmerColor,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Utils(context: context)
                                      .WidgetShimmerColor,
                                  borderRadius: BorderRadius.circular(8)),
                              width: 100,
                              height: 18,
                            ),
                          )
                        ],
                      ),
                    ),
                    Shimmer.fromColors(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Utils(context: context).WidgetShimmerColor,
                            borderRadius: BorderRadius.circular(5)),
                        height: 25,
                        width: 10,
                      ),
                      baseColor: Utils(context: context).baseShimmerColor,
                      highlightColor:
                          Utils(context: context).highlightShimmerColor,
                    )
                  ],
                ),
              ),
              AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Shimmer.fromColors(
                    baseColor: Utils(context: context).baseShimmerColor,
                    highlightColor:
                        Utils(context: context).highlightShimmerColor,
                    child: Container(
                      color: Utils(context: context).WidgetShimmerColor,
                    ),
                  )),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 4),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 8, bottom: 2),
                        child: Shimmer.fromColors(
                          baseColor: Utils(context: context).baseShimmerColor,
                          highlightColor:
                              Utils(context: context).highlightShimmerColor,
                          child: Icon(
                            Icons.favorite,
                            size: 30,
                            color: Utils(context: context).WidgetShimmerColor,
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 8, bottom: 2),
                        child: Shimmer.fromColors(
                          baseColor: Utils(context: context).baseShimmerColor,
                          highlightColor:
                              Utils(context: context).highlightShimmerColor,
                          child: Icon(
                            Icons.comment,
                            size: 30,
                            color: Utils(context: context).WidgetShimmerColor,
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Shimmer.fromColors(
                    baseColor: Utils(context: context).baseShimmerColor,
                    highlightColor:
                        Utils(context: context).highlightShimmerColor,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Utils(context: context).WidgetShimmerColor,
                          borderRadius: BorderRadius.circular(16)),
                      height: 50,
                      width: double.infinity,
                    ),
                  )),
              SizedBox(
                height: 5,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 3),
                  child: Shimmer.fromColors(
                      baseColor: Utils(context: context).baseShimmerColor,
                      highlightColor:
                          Utils(context: context).highlightShimmerColor,
                      child: Container(
                        height: 25,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Utils(context: context).WidgetShimmerColor,
                            borderRadius: BorderRadius.circular(9)),
                      )))
            ],
          ),
        ),
      ],
    );
  }
}
