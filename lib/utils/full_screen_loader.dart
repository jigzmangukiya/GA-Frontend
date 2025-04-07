import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoadingIndicator extends PopupRoute {
  static Future<void> show(BuildContext context) async {
    try {
      if (_currentHud != null) {
        _currentHud?.navigator?.pop();
      }
      LoadingIndicator hud = LoadingIndicator();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _currentHud = hud;
        Navigator.push(context, hud);
      });
    } catch (e) {
      print("Progress = $e");
      _currentHud = null;
    }
  }

  static Future<void> dismiss() async {
    try {
      if (_currentHud != null) {
        _currentHud?.navigator?.pop();
        _currentHud = null;
      }
    } catch (e) {
      print("Progress = $e");
      _currentHud = null;
    }
  }

  static LoadingIndicator? _currentHud;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => kThemeAnimationDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Material(
        color: Colors.transparent,
        child: Container(
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Center(
                child: _getProgress(),
              ),
            ),
          ),
        ));
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }

  Widget _getProgress() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            color: Colors.white38,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
