import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  final double width, height, radins;

  const SkeletonContainer._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.radins = double.infinity,
    Key? key,
  }) : super(key: key);

  const SkeletonContainer.square(
      {required double width, required double height,required double radins})
      : this._(width: width, height: height, radins: radins);

  @override
  Widget build(BuildContext context) => SkeletonAnimation(
        // curve: Curves.easeInQuad,
        // borderRadius: BorderRadius.circular(15),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radins),
            color: Colors.grey[300],
          ),
        ),
      );
}
