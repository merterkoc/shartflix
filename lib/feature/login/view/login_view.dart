import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shartflix/core/widget/text_field/app_password_field.dart';
import 'package:shartflix/core/widget/text_field/app_text_field.dart';
import 'package:shartflix/feature/login/widget/login_logo_row.dart';
import 'package:shartflix/feature/login/widget/register_prompt.dart';
import 'package:shartflix/ui/app_ui.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingXLarge,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.login_view_title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                context.l10n.login_view_subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 46),
              AppTextField(
                controller: _emailController,
                hintText: context.l10n.login_view_email_hint,
                prefixIcon: const Icon(FontAwesomeIcons.envelope),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                controller: _passwordController,
                hintText: context.l10n.login_view_password_hint,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    surfaceTintColor: Theme.of(context).colorScheme.secondary,
                    overlayColor: Colors.transparent,
                    textStyle: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                    ),
                  ),
                  child: Text(context.l10n.login_view_forgot_password),
                ),
              ),
              const SizedBox(height: 16),
              AppButton.primary(
                text: context.l10n.login_view_login_button,
                width: double.infinity,
                onPressed: () {},
              ),
              const SizedBox(height: 24),
              const LoginLogoRow(),
              const SizedBox(height: 20),
              const RegisterPrompt(),
            ],
          ),
        ),
      ),
    );
  }
}
