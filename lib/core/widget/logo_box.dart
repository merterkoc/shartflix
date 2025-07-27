import 'package:flutter/material.dart';

class LogoBox extends StatelessWidget {
  const LogoBox({required this.icon, super.key, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(51),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary.withAlpha(77),
            ),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 22,
          ),
        ),
      ),
    );
  }
}
