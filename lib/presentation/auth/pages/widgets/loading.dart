import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationController;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _rotationController =
        Tween(begin: 0.0, end: 2 * pi).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _rotationController.value,
          child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              border: Border(
                left: BorderSide(
                  //                   <--- left side
                  color: AppColors.primary,
                  width: 3.0,
                ),
                right: BorderSide(color: AppColors.primary, width: 3.0),
                top: BorderSide(color: AppColors.primary, width: 3.0),
              ),
            ),
          ),
        );
      },
    );
  }
}
