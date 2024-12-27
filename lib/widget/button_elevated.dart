import 'package:flutter/material.dart';

class ButtonElevated extends StatelessWidget {
  const ButtonElevated({
    this.size = 40,
    this.width,
    this.height,
    this.onPressed,
    this.child,
    this.borderRadius,
    this.borderColor,
    this.backgroundColor = Colors.white,
  });

  final double? size;
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? size,
      height: height ?? size,
      child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(0),
                    side:
                        BorderSide(color: borderColor ?? Colors.transparent))),
            elevation: WidgetStateProperty.resolveWith<double>(
              (Set<WidgetState> states) {
                if (backgroundColor == Colors.transparent) {
                  return 0;
                }
                if (states.contains(WidgetState.pressed)) {
                  return 2;
                }
                return 0;
              },
            ),
            overlayColor: WidgetStateProperty.all(Color(0xFFEDF0F2)),
            backgroundColor: WidgetStateProperty.all(backgroundColor),
            padding: WidgetStateProperty.all(EdgeInsets.all(0)),
          ),
          onPressed: onPressed,
          child: child),
    );
  }
}
