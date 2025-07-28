import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/form_validation/email_input.dart';
import 'package:shartflix/core/form_validation/name_input.dart';
import 'package:shartflix/core/form_validation/password_input.dart';
import 'package:shartflix/feature/register/bloc/register_bloc.dart';
import 'package:shartflix/feature/register/widget/register_form_field.dart';
import 'package:shartflix/ui/app_ui.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode nameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmPasswordFocus;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, formState) {
        return Column(
          children: [
            RegisterFormField(
              controller: nameController,
              hintText: context.l10n.register_view_name_hint,
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
              focusNode: nameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(emailFocus);
              },
              onChanged: (value) =>
                  context.read<RegisterBloc>().add(RegisterNameChanged(value)),
              hasError:
                  formState.name.isNotValid &&
                  formState.name.error == NameValidationError.empty &&
                  !formState.name.isPure,
              errorMessage: context.l10n.register_name_empty,
              showError:
                  formState.name.isNotValid &&
                  formState.name.error == NameValidationError.empty &&
                  !formState.name.isPure,
            ),
            const SizedBox(height: 16),
            RegisterFormField(
              controller: emailController,
              hintText: context.l10n.register_view_email_hint,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              focusNode: emailFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocus);
              },
              onChanged: (value) =>
                  context.read<RegisterBloc>().add(RegisterEmailChanged(value)),
              autofillHints: const [AutofillHints.email],
              hasError:
                  (formState.email.isNotValid &&
                      formState.email.error == EmailValidationError.empty &&
                      !formState.email.isPure) ||
                  (formState.email.isNotValid &&
                      formState.email.error == EmailValidationError.invalid &&
                      !formState.email.isPure),
              errorMessage: formState.email.error == EmailValidationError.empty
                  ? context.l10n.register_email_empty
                  : context.l10n.register_email_invalid,
              showError:
                  (formState.email.isNotValid &&
                      formState.email.error == EmailValidationError.empty &&
                      !formState.email.isPure) ||
                  (formState.email.isNotValid &&
                      formState.email.error == EmailValidationError.invalid &&
                      !formState.email.isPure),
            ),
            const SizedBox(height: 16),
            RegisterFormField(
              controller: passwordController,
              hintText: context.l10n.register_view_password_hint,
              focusNode: passwordFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(confirmPasswordFocus);
              },
              onChanged: (value) => context.read<RegisterBloc>().add(
                RegisterPasswordChanged(value),
              ),
              autofillHints: const [AutofillHints.newPassword],
              isPassword: true,
              hasError:
                  (formState.password.isNotValid &&
                      formState.password.error ==
                          PasswordValidationError.empty &&
                      !formState.password.isPure) ||
                  (formState.password.isNotValid &&
                      formState.password.error ==
                          PasswordValidationError.tooShort &&
                      !formState.password.isPure),
              errorMessage:
                  formState.password.error == PasswordValidationError.empty
                  ? context.l10n.register_password_empty
                  : context.l10n.register_password_min_length,
              showError:
                  (formState.password.isNotValid &&
                      formState.password.error ==
                          PasswordValidationError.empty &&
                      !formState.password.isPure) ||
                  (formState.password.isNotValid &&
                      formState.password.error ==
                          PasswordValidationError.tooShort &&
                      !formState.password.isPure),
            ),
            const SizedBox(height: 16),
            RegisterFormField(
              controller: confirmPasswordController,
              hintText: context.l10n.register_view_confirm_password_hint,
              focusNode: confirmPasswordFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) => context.read<RegisterBloc>().add(
                RegisterConfirmPasswordChanged(value),
              ),
              autofillHints: const [AutofillHints.newPassword],
              isPassword: true,
              hasError:
                  !formState.confirmPassword.isPure &&
                  formState.confirmPassword.value != formState.password.value,
              errorMessage: context.l10n.register_passwords_do_not_match,
              showError:
                  !formState.confirmPassword.isPure &&
                  formState.confirmPassword.value != formState.password.value,
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
