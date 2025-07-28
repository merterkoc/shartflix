import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/extensions/context_ext.dart';
import 'package:shartflix/core/router/go_router.dart';

enum AuthPromptMode { login, register }

class AuthScreenPrompt extends StatelessWidget {
  const AuthScreenPrompt({
    super.key,
    this.promptText,
    this.actionText,
    this.mode = AuthPromptMode.login,
  });

  final String? promptText;
  final String? actionText;
  final AuthPromptMode mode;

  @override
  Widget build(BuildContext context) {
    final isRegister = mode == AuthPromptMode.register;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      alignment: WrapAlignment.center,
      children: [
        Text(
          promptText ??
              (isRegister
                  ? context.l10n.register_view_login_prompt
                  : context.l10n.login_view_register_prompt),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          onPressed: () {
            if (isRegister) {
              context.goNamed(AppRoute.login.name);
            } else {
              context.goNamed(AppRoute.register.name);
            }
          },
          child: Text(
            actionText ??
                (isRegister
                    ? context.l10n.register_view_login_button
                    : context.l10n.login_view_register_button),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
