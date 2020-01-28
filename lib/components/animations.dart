import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation(
      {Key key, this.widget, this.controller, this.begin, this.end})
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

  Widget _buildAnimation(BuildContext context, Widget child) {
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

class MenuAnimation extends StatelessWidget {
  MenuAnimation({Key key, this.widget, this.controller, this.begin, this.end})
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

  Widget _buildAnimation(BuildContext context, Widget child) {
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
