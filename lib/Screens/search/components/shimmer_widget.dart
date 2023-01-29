import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_app/Utils/utils.dart';

class shimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
            child: Container(
              decoration: BoxDecoration(
                  color: Utils(context: context).WidgetShimmerColor,
                  borderRadius: BorderRadius.circular(6)),
              width: 50,
              height: 27,
            ),
            baseColor: Utils(context: context).baseShimmerColor,
            highlightColor: Utils(context: context).highlightShimmerColor),
        SizedBox(
          height: 3,
        ),
        Shimmer.fromColors(
            child: Container(
              decoration: BoxDecoration(
                  color: Utils(context: context).WidgetShimmerColor,
                  borderRadius: BorderRadius.circular(5)),
              width: 50,
              height: 13,
            ),
            baseColor: Utils(context: context).baseShimmerColor,
            highlightColor: Utils(context: context).highlightShimmerColor),
      ],
    );
  }
}
