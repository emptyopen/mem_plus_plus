import 'package:flutter/material.dart';
import 'standard.dart';
import 'animations.dart';

class ScreenOne extends StatelessWidget {

  ScreenOne({this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StaggerAnimation(
                begin: 0,
                end: 0.6,
                widget: Text(
                  'Welcome to MEM++',
                  style: TextStyle(fontSize: 28),
                ),
                controller: controller.view,
              ),
              StaggerAnimation(
                begin: 0.2,
                end: 1,
                widget: Text(
                  'We\'re going to improve your memory! \n\n'
                    'Life is going to be so much better! \n\n'
                    'But let\'s do this one step at a time...',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                controller: controller.view,
              )
            ],
          ),
        ),
        Positioned(
          child: MenuAnimation(
            begin: 0,
            end: 1.0,
            widget: PopButton(
              widget: Text(
                'Skip',
                style: TextStyle(fontSize: 18),
              ),
              color: Colors.amber[50],
            ),
            controller: controller.view,
          ),
          left: 20,
          bottom: 20),
        Positioned(
          child: MenuAnimation(
            begin: 0.2,
            end: 1.0,
            widget: PopButton(
              widget: Text(
                'Next',
                style: TextStyle(fontSize: 24),
              ),
              color: Colors.amber[50],
            ),
            controller: controller.view,
          ),
          right: 20,
          bottom: 20),
      ],
    );
  }
}