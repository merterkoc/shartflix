import 'package:flutter/material.dart';
import 'package:shartflix/ui/app_ui.dart';

class RegisterAgreement extends StatelessWidget {
  const RegisterAgreement({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: context.l10n.register_view_agreement_prefix,
              style: const TextStyle(fontSize: 13),
            ),
            TextSpan(
              text: context.l10n.register_view_agreement_bold,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 13,
              ),
            ),
            TextSpan(
              text: context.l10n.register_view_agreement_suffix,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
