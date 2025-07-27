import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shartflix/core/widget/logo_box.dart';

class LogoRow extends StatelessWidget {
  const LogoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LogoBox(icon: FontAwesomeIcons.google),
        LogoBox(icon: FontAwesomeIcons.apple),
        LogoBox(icon: FontAwesomeIcons.facebookF),
      ],
    );
  }
}
