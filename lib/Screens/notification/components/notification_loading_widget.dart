import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_app/Utils/utils.dart';

class notificationLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Shimmer.fromColors(
                    child: CircleAvatar(
                      backgroundColor:
                          Utils(context: context).WidgetShimmerColor,
                      radius: 26,
                    ),
                    baseColor: Utils(context: context).baseShimmerColor,
                    highlightColor:
                        Utils(context: context).highlightShimmerColor,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Utils(context: context).WidgetShimmerColor,
                            borderRadius: BorderRadius.circular(8)),
                        height: 28,
                        width: getWidth(context: context) * 0.2,
                      ),
                      baseColor: Utils(context: context).baseShimmerColor,
                      highlightColor:
                          Utils(context: context).highlightShimmerColor,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Shimmer.fromColors(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Utils(context: context).WidgetShimmerColor,
                            borderRadius: BorderRadius.circular(7)),
                        height: 24,
                        width: getWidth(context: context) * 0.5,
                      ),
                      baseColor: Utils(context: context).baseShimmerColor,
                      highlightColor:
                          Utils(context: context).highlightShimmerColor,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Shimmer.fromColors(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Utils(context: context).WidgetShimmerColor,
                            borderRadius: BorderRadius.circular(5)),
                        height: 15,
                        width: getWidth(context: context) * 0.18,
                      ),
                      baseColor: Utils(context: context).baseShimmerColor,
                      highlightColor:
                          Utils(context: context).highlightShimmerColor,
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Shimmer.fromColors(
              child: Container(
                decoration: BoxDecoration(
                    color: Utils(context: context).WidgetShimmerColor,
                    borderRadius: BorderRadius.circular(5)),
                height: 1,
                width: getWidth(context: context),
              ),
              baseColor: Utils(context: context).baseShimmerColor,
              highlightColor: Utils(context: context).highlightShimmerColor,
            ),
          ),
        ],
      ),
    );
  }
}
