import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainerBox extends StatelessWidget {
  final double width, height;

  const SkeletonContainerBox._({
    this.width = double.infinity,
    this.height = double.infinity,
    Key? key,
  }) : super(key: key);

  const SkeletonContainerBox.square(
      {required double width, required double height})
      : this._(width: width, height: height);

  @override
  Widget build(BuildContext context) => SkeletonAnimation(
        // curve: Curves.easeInQuad,
        // borderRadius: BorderRadius.circular(15),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
        ),
      );
}
