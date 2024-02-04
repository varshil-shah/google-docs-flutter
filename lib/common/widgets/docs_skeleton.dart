import 'package:flutter/material.dart';
import 'package:google_docs/colors.dart';
import 'package:skeletons/skeletons.dart';

class DocumentSkeleton extends StatelessWidget {
  const DocumentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Container(
        decoration: BoxDecoration(
          color: kLightGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 100,
      ),
    );
  }
}
