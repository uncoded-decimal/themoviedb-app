import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wework_challenge/src/app/misc/app_textstyles.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.2),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.grey.shade400,
        direction: ShimmerDirection.rtl,
        period: const Duration(seconds: 3),
        child: Text(
          "There seems to be nothing here...",
          style: AppTextStyles.bold16NS(
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
