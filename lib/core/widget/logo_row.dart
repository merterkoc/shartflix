import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LogoRow extends StatelessWidget {
  const LogoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LogoBox(icon: FontAwesomeIcons.google),
        SizedBox(width: 10),
        LogoBox(icon: FontAwesomeIcons.apple),
        SizedBox(width: 10),
        LogoBox(icon: FontAwesomeIcons.facebookF),
      ],
    );
  }
}

class LogoBox extends StatelessWidget {
  const LogoBox({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
