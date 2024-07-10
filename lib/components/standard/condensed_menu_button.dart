import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class CondensedMenuButton extends StatelessWidget {
  final Activity activity;
  final Function callback;
  final Widget route;
  final IconData icon;
  final Color color;
  final bool testPrepAvailable;
  final PrefsUpdater prefs = PrefsUpdater();

  CondensedMenuButton({
    required this.activity,
    required this.callback,
    required this.route,
    required this.icon,
    required this.color,
    this.testPrepAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 10,
      child: ElevatedButton(
        child: Icon(icon, color: Colors.black),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          shadowColor: Colors.black.withOpacity(1),
        ),
        onPressed: testPrepAvailable
            ? () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) =>
                        route,
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) =>
                        SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }
}
