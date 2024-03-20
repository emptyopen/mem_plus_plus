import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation(
      {Key? key,
      required this.widget,
      required this.controller,
      required this.begin,
      required this.end})
      : opacity = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              begin,
              end,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
          end: const EdgeInsets.fromLTRB(10, 10, 10, 50),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              begin,
              end,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Widget widget;
  final double begin;
  final double end;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<EdgeInsets> padding;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: padding.value,
      child: Opacity(opacity: opacity.value, child: widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class FadeAwayAnimation extends StatelessWidget {
  FadeAwayAnimation(
      {Key? key,
      required this.widget,
      required this.controller,
      required this.begin,
      required this.end})
      : opacityIn = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              begin,
              (begin + end) / 2,
              curve: Curves.ease,
            ),
          ),
        ),
        opacityOut = Tween<double>(
          begin: 0,
          end: -1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              (begin + end) / 2,
              end,
              curve: Curves.ease,
            ),
          ),
        ),
        paddingIn = Tween<double>(
          begin: 0,
          end: 10,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              begin,
              (begin + end) / 2,
              curve: Curves.ease,
            ),
          ),
        ),
        paddingOut = Tween<double>(
          begin: 0,
          end: 10,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              (begin + end) / 2,
              end,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Widget widget;
  final double begin;
  final double end;
  final Animation<double> controller;
  final Animation<double> opacityIn;
  final Animation<double> opacityOut;
  final Animation<double> paddingIn;
  final Animation<double> paddingOut;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: EdgeInsets.fromLTRB(50 - paddingIn.value + paddingOut.value, 0,
          paddingIn.value - paddingOut.value, 0),
      child:
          Opacity(opacity: opacityIn.value + opacityOut.value, child: widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class StaggerAnimationSideways extends StatelessWidget {
  StaggerAnimationSideways({
    Key? key,
    required this.widget,
    required this.controller,
    required this.begin,
    required this.end,
  })  : opacity = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              begin,
              end,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.fromLTRB(0, 0, 50, 0),
          end: const EdgeInsets.fromLTRB(50, 0, 0, 0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              begin,
              end,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Widget widget;
  final double begin;
  final double end;
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<EdgeInsets> padding;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: padding.value,
      child: Opacity(opacity: opacity.value, child: widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class PercentageAnimation extends StatelessWidget {
  PercentageAnimation({
    Key? key,
    required this.widget,
    required this.controller,
    required this.color,
    required this.size,
    required this.begin,
    required this.end,
  })  : height = Tween<double>(
          begin: size,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              begin,
              end,
              curve: Curves.linear,
            ),
          ),
        ),
        super(key: key);

  final Widget widget;
  final Color color;
  final double size;
  final double begin;
  final double end;
  final Animation<double> controller;
  final Animation<double> height;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            color,
            backgroundColor,
          ], // whitish to gray
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      width: 40,
      height: height.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class MenuAnimation extends StatelessWidget {
  MenuAnimation(
      {Key? key,
      required this.widget,
      required this.controller,
      required this.begin,
      required this.end})
      : opacity = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              begin,
              end,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Widget widget;
  final double begin;
  final double end;
  final Animation<double> controller;
  final Animation<double> opacity;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Opacity(opacity: opacity.value, child: widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
