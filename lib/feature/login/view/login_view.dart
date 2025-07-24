import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shartflix/core/widget/auth_screen_promt.dart';
import 'package:shartflix/core/widget/logo_row.dart';
import 'package:shartflix/core/widget/text_field/app_password_field.dart';
import 'package:shartflix/core/widget/text_field/app_text_field.dart';
import 'package:shartflix/feature/login/bloc/login_validation_bloc.dart';
import 'package:shartflix/feature/login/bloc/user_bloc.dart';
import 'package:shartflix/feature/register/bloc/email_input.dart';
import 'package:shartflix/feature/register/bloc/password_input.dart';
import 'package:shartflix/ui/app_ui.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<UserBloc>.value(value: context.read<UserBloc>()),
          BlocProvider<LoginValidationBloc>(
            create: (_) => LoginValidationBloc(),
          ),
        ],
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserFailure) {
              showAppErrorBottomSheet(
                context: context,
                title: context.l10n.login_view_error_title,
                message: context.l10n.login_view_error_message,
                icon: Icons.error_outline,
              );
            }
          },
          child: BlocBuilder<LoginValidationBloc, LoginValidationState>(
            builder: (context, validationState) {
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Spacer(),
                            Text(
                              context.l10n.login_view_title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              context.l10n.login_view_subtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 46),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease,
                              margin: EdgeInsets.only(
                                bottom:
                                    ((validationState.email.isNotValid &&
                                            validationState.email.error ==
                                                EmailValidationError.empty &&
                                            !validationState.email.isPure) ||
                                        (validationState.email.isNotValid &&
                                            validationState.email.error ==
                                                EmailValidationError.invalid &&
                                            !validationState.email.isPure))
                                    ? 8
                                    : 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppTextField(
                                    controller: _emailController,
                                    hintText:
                                        context.l10n.login_view_email_hint,
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
                                        .read<LoginValidationBloc>()
                                        .add(LoginEmailChanged(value)),
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        (validationState.email.isNotValid &&
                                            validationState.email.error ==
                                                EmailValidationError.empty &&
                                            !validationState.email.isPure)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (validationState.email.isNotValid &&
                                            validationState.email.error ==
                                                EmailValidationError.empty &&
                                            !validationState.email.isPure)
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
                                        (validationState.email.isNotValid &&
                                            validationState.email.error ==
                                                EmailValidationError.invalid &&
                                            !validationState.email.isPure)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (validationState.email.isNotValid &&
                                            validationState.email.error ==
                                                EmailValidationError.invalid &&
                                            !validationState.email.isPure)
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
                                    (validationState.password.isNotValid &&
                                        validationState.password.error ==
                                            PasswordValidationError.empty &&
                                        !validationState.password.isPure)
                                    ? 8
                                    : 0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppPasswordField(
                                    controller: _passwordController,
                                    hintText:
                                        context.l10n.login_view_password_hint,
                                    focusNode: _passwordFocus,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    onChanged: (value) => context
                                        .read<LoginValidationBloc>()
                                        .add(LoginPasswordChanged(value)),
                                  ),
                                  AnimatedOpacity(
                                    opacity:
                                        (validationState.password.isNotValid &&
                                            validationState.password.error ==
                                                PasswordValidationError.empty &&
                                            !validationState.password.isPure)
                                        ? 1.0
                                        : 0.0,
                                    duration: const Duration(milliseconds: 250),
                                    child:
                                        (validationState.password.isNotValid &&
                                            validationState.password.error ==
                                                PasswordValidationError.empty &&
                                            !validationState.password.isPure)
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
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  surfaceTintColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                  overlayColor: Colors.transparent,
                                  textStyle: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                  ),
                                ),
                                child: Text(
                                  context.l10n.login_view_forgot_password,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                final isLoading = state is UserLoading;
                                return AppButton.primary(
                                  text: context.l10n.login_view_login_button,
                                  width: double.infinity,
                                  isLoading: isLoading,
                                  onPressed:
                                      isLoading || !validationState.status
                                      ? null
                                      : () {
                                          final email = _emailController.text
                                              .trim();
                                          final password = _passwordController
                                              .text
                                              .trim();
                                          context.read<UserBloc>().add(
                                            LoginRequested(
                                              email: email,
                                              password: password,
                                            ),
                                          );
                                        },
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            const LogoRow(),
                            const SizedBox(height: 20),
                            const AuthScreenPrompt(),
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
