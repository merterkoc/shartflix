import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton.outlined({
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.icon,
    super.key,
  }) : outlined = true;

  const AppButton.primary({
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.icon,
    super.key,
  }) : outlined = false;
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final double? width;
  final double? height;
  final IconData? icon;

  static const double _defaultHeight = 53.31;
  static const double _radius = 18;

  @override
  Widget build(BuildContext context) {
    final brandColor = Theme.of(context).colorScheme.primary;
    final style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: outlined ? brandColor : Colors.white,
      decoration: TextDecoration.none,
    );
    Widget child = Text(text, style: style);
    if (icon != null) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: outlined ? brandColor : Colors.white, size: 22),
          const SizedBox(width: 8),
          Flexible(child: Text(text, style: style)),
        ],
      );
    }
    final button = outlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
              side: BorderSide(color: brandColor),
              foregroundColor: brandColor,
              textStyle: style,
              backgroundColor: Colors.transparent,
              minimumSize: Size(width ?? 0, height ?? _defaultHeight),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: brandColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
              textStyle: style,
              elevation: 0,
              minimumSize: Size(width ?? 0, height ?? _defaultHeight),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: child,
          );
    Widget result = button;
    if (width != null || height != null) {
      result = SizedBox(
        width: width,
        height: height ?? _defaultHeight,
        child: button,
      );
    }
    return result;
  }
}
