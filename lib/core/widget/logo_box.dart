import 'package:flutter/material.dart';

class LogoBox extends StatelessWidget {
  const LogoBox({
    this.icon,
    super.key,
    this.onPressed,
    this.height = 56,
    this.width = 56,
    this.child,
    this.iconSize = 22,
    this.borderRadius = 18,
  }) : assert(
         icon == null || child == null,
         'icon and child cannot be used at the same time',
       );

  final IconData? icon;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final Widget? child;
  final double iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(51),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withAlpha(77),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child:
            child ??
            Center(
              child: Icon(
                icon,
                size: iconSize,
              ),
            ),
      ),
    );
  }
}
