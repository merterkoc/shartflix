import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/core/widget/auth_screen_promt.dart';
import 'package:shartflix/core/widget/logo_row.dart';
import 'package:shartflix/feature/login/bloc/user_bloc.dart';
import 'package:shartflix/feature/register/bloc/email_input.dart';
import 'package:shartflix/feature/register/bloc/name_input.dart';
import 'package:shartflix/feature/register/bloc/password_input.dart';
import 'package:shartflix/feature/register/bloc/register_bloc.dart';
import 'package:shartflix/ui/app_ui.dart';
import 'package:shartflix/model/enum/register_failure.dart';
import 'package:shartflix/core/widget/app_error_bottom_sheet.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (_) => RegisterBloc(),
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserRegisterFailure) {
              String errorMessage;
              switch (state.registerFailure) {
                case RegisterFailure.userExist:
                  errorMessage = context.l10n.register_error_user_exists;
                case RegisterFailure.invalidEmail:
                  errorMessage = context.l10n.register_error_invalid_email;
                case RegisterFailure.unknownError:
                  errorMessage = context.l10n.register_error_unknown;
              }
              showAppErrorBottomSheet(
                context: context,
                title: context.l10n.register_view_title,
                message: errorMessage,
                icon: Icons.error_outline,
              );
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, formState) {
              return CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.paddingXLarge,
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              context.l10n.register_view_title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              context.l10n.register_view_subtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 46),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease,
                              margin: EdgeInsets.only(
                                bottom:
                                    (formState.name.isNotValid &&
                                        formState.name.error ==
                                            NameValidationError.empty &&
                                        !formState.name.isPure)
                                    ? 8
                                    : 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextField(
                                    controller: _nameController,
                                    hintText:
                                        context.l10n.register_view_name_hint,
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                    ),
                                    keyboardType: TextInputType.name,
                                    focusNode: _nameFocus,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_emailFocus);
                                    },
                                    onChanged: (value) => context
                                        .read<RegisterBloc>()
                                        .add(RegisterNameChanged(value)),
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        (formState.name.isNotValid &&
                                            formState.name.error ==
                                                NameValidationError.empty &&
                                            !formState.name.isPure)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (formState.name.isNotValid &&
                                            formState.name.error ==
                                                NameValidationError.empty &&
                                            !formState.name.isPure)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                              left: 8,
                                            ),
                                            child: Text(
                                              context.l10n.register_name_empty,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease,
                              margin: EdgeInsets.only(
                                bottom:
                                    ((formState.email.isNotValid &&
                                            formState.email.error ==
                                                EmailValidationError.empty &&
                                            !formState.email.isPure) ||
                                        (formState.email.isNotValid &&
                                            formState.email.error ==
                                                EmailValidationError.invalid &&
                                            !formState.email.isPure))
                                    ? 8
                                    : 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextField(
                                    controller: _emailController,
                                    hintText:
                                        context.l10n.register_view_email_hint,
                                    prefixIcon: const Icon(
                                      FontAwesomeIcons.envelope,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    focusNode: _emailFocus,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_passwordFocus);
                                    },
                                    onChanged: (value) => context
                                        .read<RegisterBloc>()
                                        .add(RegisterEmailChanged(value)),
                                    autofillHints: const [AutofillHints.email],
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        (formState.email.isNotValid &&
                                            formState.email.error ==
                                                EmailValidationError.empty &&
                                            !formState.email.isPure)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (formState.email.isNotValid &&
                                            formState.email.error ==
                                                EmailValidationError.empty &&
                                            !formState.email.isPure)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                              left: 8,
                                            ),
                                            child: Text(
                                              context.l10n.register_email_empty,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        (formState.email.isNotValid &&
                                            formState.email.error ==
                                                EmailValidationError.invalid &&
                                            !formState.email.isPure)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (formState.email.isNotValid &&
                                            formState.email.error ==
                                                EmailValidationError.invalid &&
                                            !formState.email.isPure)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                              left: 8,
                                            ),
                                            child: Text(
                                              context
                                                  .l10n
                                                  .register_email_invalid,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease,
                              margin: EdgeInsets.only(
                                bottom:
                                    ((formState.password.isNotValid &&
                                            formState.password.error ==
                                                PasswordValidationError.empty &&
                                            !formState.password.isPure) ||
                                        (formState.password.isNotValid &&
                                            formState.password.error ==
                                                PasswordValidationError
                                                    .tooShort &&
                                            !formState.password.isPure))
                                    ? 8
                                    : 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppPasswordField(
                                    controller: _passwordController,
                                    hintText: context
                                        .l10n
                                        .register_view_password_hint,
                                    focusNode: _passwordFocus,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_confirmPasswordFocus);
                                    },
                                    onChanged: (value) => context
                                        .read<RegisterBloc>()
                                        .add(RegisterPasswordChanged(value)),
                                    autofillHints: const [
                                      AutofillHints.newPassword,
                                    ],
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        (formState.password.isNotValid &&
                                            formState.password.error ==
                                                PasswordValidationError.empty &&
                                            !formState.password.isPure)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (formState.password.isNotValid &&
                                            formState.password.error ==
                                                PasswordValidationError.empty &&
                                            !formState.password.isPure)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                              left: 8,
                                            ),
                                            child: Text(
                                              context
                                                  .l10n
                                                  .register_password_empty,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        (formState.password.isNotValid &&
                                            formState.password.error ==
                                                PasswordValidationError
                                                    .tooShort &&
                                            !formState.password.isPure)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (formState.password.isNotValid &&
                                            formState.password.error ==
                                                PasswordValidationError
                                                    .tooShort &&
                                            !formState.password.isPure)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                              left: 8,
                                            ),
                                            child: Text(
                                              context
                                                  .l10n
                                                  .register_password_min_length,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease,
                              margin: EdgeInsets.only(
                                bottom:
                                    (!formState.confirmPassword.isPure &&
                                        formState.confirmPassword.value !=
                                            formState.password.value)
                                    ? 8
                                    : 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppPasswordField(
                                    controller: _confirmPasswordController,
                                    hintText: context
                                        .l10n
                                        .register_view_confirm_password_hint,
                                    focusNode: _confirmPasswordFocus,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    onChanged: (value) =>
                                        context.read<RegisterBloc>().add(
                                          RegisterConfirmPasswordChanged(value),
                                        ),
                                    autofillHints: const [
                                      AutofillHints.newPassword,
                                    ],
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        (!formState.confirmPassword.isPure &&
                                            formState.confirmPassword.value !=
                                                formState.password.value)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (!formState.confirmPassword.isPure &&
                                            formState.confirmPassword.value !=
                                                formState.password.value)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                              left: 8,
                                            ),
                                            child: Text(
                                              context
                                                  .l10n
                                                  .register_passwords_do_not_match,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: context
                                          .l10n
                                          .register_view_agreement_prefix,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    TextSpan(
                                      text: context
                                          .l10n
                                          .register_view_agreement_bold,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 13,
                                      ),
                                    ),
                                    TextSpan(
                                      text: context
                                          .l10n
                                          .register_view_agreement_suffix,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                final isLoading = state is UserLoading;
                                return AppButton.primary(
                                  text: context.l10n.register_view_button,
                                  width: double.infinity,
                                  isLoading: isLoading,
                                  onPressed: isLoading || !formState.status
                                      ? null
                                      : () {
                                          context.read<RegisterBloc>().add(
                                            RegisterSubmitted(),
                                          );
                                          context.read<UserBloc>().add(
                                            RegisterRequested(
                                              name: _nameController.text.trim(),
                                              email: _emailController.text
                                                  .trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                              confirmPassword:
                                                  _confirmPasswordController
                                                      .text
                                                      .trim(),
                                            ),
                                          );
                                        },
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            const LogoRow(),
                            const SizedBox(height: 20),
                            const AuthScreenPrompt(
                              mode: AuthPromptMode.register,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
