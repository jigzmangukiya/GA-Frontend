import 'package:guardian_angel/utils.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorConstant.borderTextFieldColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
