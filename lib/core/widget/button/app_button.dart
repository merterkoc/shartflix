import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton.primary({
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    super.key,
  }) : outlined = false;

  const AppButton.outlined({
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    super.key,
  }) : outlined = true;
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final double? width;
  final double? height;

  static const double _defaultHeight = 53.31;
  static const double _radius = 18;
  static const Color _brandColor = Color(0xFFE50914);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: outlined ? _brandColor : Theme.of(context).colorScheme.onPrimary,
      decoration: TextDecoration.none,
    );
    final button = outlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
              side: const BorderSide(color: _brandColor, width: 2),
              foregroundColor: _brandColor,
              textStyle: style,
              backgroundColor: Colors.transparent,
              minimumSize: Size(width ?? 0, height ?? _defaultHeight),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(text, style: style),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_radius),
              ),
              textStyle: style,
              elevation: 0,
              minimumSize: Size(width ?? 0, height ?? _defaultHeight),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(text, style: style),
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
