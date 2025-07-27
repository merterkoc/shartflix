import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton.outlined({
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
    super.key,
  }) : outlined = true;

  const AppButton.primary({
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.icon,
    this.isLoading = false,
    super.key,
  }) : outlined = false;
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final double? width;
  final double? height;
  final IconData? icon;
  final bool isLoading;

  static const double _defaultHeight = 42;
  static const double _radius = 14;

  @override
  Widget build(BuildContext context) {
    final brandColor = Theme.of(context).colorScheme.primary;
    final style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: outlined ? brandColor : Colors.white,
      decoration: TextDecoration.none,
    );
    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            outlined ? brandColor : Colors.white,
          ),
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: outlined ? brandColor : Colors.white, size: 22),
          const SizedBox(width: 8),
          Flexible(child: Text(text, style: style)),
        ],
      );
    } else {
      child = Text(text, style: style);
    }
    final button = outlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
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
            onPressed: isLoading ? null : onPressed,
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
