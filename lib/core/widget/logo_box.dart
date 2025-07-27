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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
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
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: child ??
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
