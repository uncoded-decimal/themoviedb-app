import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wework_challenge/src/utils/utils.dart';
import 'dart:math' as math;

class WeLoadingWidget extends StatefulWidget {
  const WeLoadingWidget({super.key});

  @override
  State<WeLoadingWidget> createState() => _WeLoadingWidgetState();
}

class _WeLoadingWidgetState extends State<WeLoadingWidget>
    with SingleTickerProviderStateMixin {
  Tween<double> loadingProgress = Tween(
    begin: 0,
    end: 100,
  );
  late AnimationController loadingController;

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(seconds: 2),
    );
    loadingProgress.animate(loadingController).addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        loadingController.forward(from: 0);
      }
    });
    super.initState();
    loadingController
      ..forward()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 350,
          padding: const EdgeInsets.all(52),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: SvgPicture.asset(
            getLocalSvg('logo_full'),
            width: 150,
          ),
        ),
        SizedBox(
          height: 250,
          width: 250,
          child: Transform.rotate(
            angle: math.pi / 2,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              value: loadingController.value,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
