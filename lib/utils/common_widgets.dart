import 'package:guardian_angel/utils.dart';
import 'package:flutter/material.dart';

class RoundedTextButton extends StatefulWidget {
  RoundedTextButton({
    required this.onPressed,
    required this.text,
    this.color = ColorConstant.primaryColor,
    this.height,
    this.width = double.infinity,
    required this.textStyle,
    this.prefix,
    this.suffix,
    this.marqueeEnabled = false,
    this.alignment = Alignment.center,
  });

  final Function()? onPressed;
  final String text;
  final Color color;
  final double? height;
  final double width;
  final TextStyle? textStyle;
  final Widget? prefix;
  final Widget? suffix;
  final bool marqueeEnabled;
  final Alignment alignment;

  @override
  _RoundedTextButtonState createState() => _RoundedTextButtonState();
}

class _RoundedTextButtonState extends State<RoundedTextButton> with SingleTickerProviderStateMixin {
  double? _scale;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller?.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller?.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - (_controller?.value ?? 0);

    return GestureDetector(
      key: Key(widget.text),
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _controller?.reverse(),
      child: Transform.scale(
        scale: _scale,
        child: Container(
          alignment: Alignment.center,
          height: widget.height != null ? widget.height : MediaQuery.of(context).size.height * 0.055,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(6.0),
            // boxShadow: [
            //   BoxShadow(
            //     color: ColorConstant.primaryColor.withOpacity(0.3),
            //     blurRadius: 20.0, // soften the shadow
            //     offset: Offset(
            //       0.0, // Move to right 10  horizontally
            //       10.0, // Move to bottom 10 Vertically
            //     ),
            //   ), // Shadow according to mobile app XD
            // ],
          ),
          child: Stack(
            children: [
              Container(
                height: 56,
                width: 50,
                child: widget.prefix,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: widget.prefix != null ? 40 : 0,
                  right: widget.suffix != null ? 40 : 0,
                  // top: 1,
                  // bottom: 1,
                ),
                child: Align(
                  alignment: widget.alignment,
                  child: Text(widget.text, maxLines: 1, overflow: TextOverflow.ellipsis, style: widget.textStyle),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 50,
                  width: 40,
                  child: widget.suffix,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
