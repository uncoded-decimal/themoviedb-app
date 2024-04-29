import 'package:flutter/material.dart';
import 'package:wework_challenge/src/app/misc/app_textstyles.dart';
import 'package:wework_challenge/src/data/models/movie_item_model.dart';

class DotsIndicator extends StatefulWidget {
  final List<MovieItemModel> moviesList;
  final int dotsCount;

  final ScrollController controller;
  const DotsIndicator({
    super.key,
    required this.moviesList,
    required this.controller,
    this.dotsCount = 3,
  });

  @override
  State<DotsIndicator> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<DotsIndicator> {
  bool isScrollControllerAttached = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onListen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onListen);
    super.dispose();
  }

  void onListen() {
    setState(() {
      isScrollControllerAttached = widget.controller.hasClients;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = [];
    if (isScrollControllerAttached) {
      final currentScrollIndex = widget.controller.offset;
      final totalScrollExtent = widget.controller.position.maxScrollExtent;
      final itemExtent = totalScrollExtent / (widget.moviesList.length);
      final currentIndex = (currentScrollIndex ~/ itemExtent) + 1;
      int range = widget.moviesList.length ~/ widget.dotsCount;
      for (int dotIndex = 1; dotIndex <= widget.dotsCount; dotIndex++) {
        int rangeStart = 1 + range * (dotIndex - 1);
        int rangeEnd = (dotIndex == widget.dotsCount)
            ? widget.moviesList.length
            : dotIndex * range;
        if (currentIndex > widget.moviesList.length) {
          /// check whether the current index is for the widget at the list end
          /// which will very likely be the fetch button or the shimmer
          rowChildren.add(
            _IndicatorDot(
                currentIndex: currentIndex - 1,
                total: widget.moviesList.length,
                rangeStart: rangeStart,
                rangeEnd: rangeEnd),
          );
          continue;
        }
        rowChildren.add(
          _IndicatorDot(
              currentIndex: currentIndex,
              total: widget.moviesList.length,
              rangeStart: rangeStart,
              rangeEnd: rangeEnd),
        );
      }
    } else {
      rowChildren.add(
        _IndicatorDot(
            currentIndex: 1,
            total: widget.moviesList.length,
            rangeStart: 1,
            rangeEnd: 1),
      );
      for (int dotIndex = 2; dotIndex <= widget.dotsCount; dotIndex++) {
        rowChildren.add(
          _IndicatorDot(
              currentIndex: 1,
              total: widget.moviesList.length,
              rangeStart: 2,
              rangeEnd: 2),
        );
      }
    }
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowChildren,
      ),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  final int currentIndex;
  final int total;
  final int rangeStart, rangeEnd;
  const _IndicatorDot({
    required this.currentIndex,
    required this.total,
    required this.rangeStart,
    required this.rangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    final isInRange = currentIndex >= rangeStart && currentIndex <= rangeEnd;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: isInRange
          ? __InfoDot(currentIndex: currentIndex, totalCount: total)
          : const __EmptyDot(),
    );
  }
}

class __InfoDot extends StatelessWidget {
  final int currentIndex, totalCount;
  const __InfoDot({
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "$currentIndex/$totalCount",
        style: AppTextStyles.regular10NS(color: Colors.white),
      ),
    );
  }
}

class __EmptyDot extends StatelessWidget {
  const __EmptyDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade400,
      ),
    );
  }
}
