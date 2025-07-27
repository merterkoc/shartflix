import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/bloc/user/user_bloc.dart';
import 'package:shartflix/core/widget/auth_screen_prompt.dart';
import 'package:shartflix/core/widget/logo_row.dart';
import 'package:shartflix/feature/register/bloc/register_bloc.dart';
import 'package:shartflix/feature/register/widget/register_agreement.dart';
import 'package:shartflix/feature/register/widget/register_form.dart';
import 'package:shartflix/feature/register/widget/register_header.dart';
import 'package:shartflix/model/enum/register_failure.dart';
import 'package:shartflix/ui/app_ui.dart';

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
            if (state.userResponse.status.isError) {
              late final String errorMessage;
              switch (RegisterFailure.fromCode(state.userResponse.message!)) {
                case RegisterFailure.userExist:
                  errorMessage = context.l10n.register_error_user_exists;
                case RegisterFailure.invalidEmail:
                  errorMessage = context.l10n.register_error_invalid_email;
                case RegisterFailure.unknownError:
                  errorMessage = context.l10n.register_error_unknown;
                case RegisterFailure.passwordTooShort:
                  errorMessage = 'Password must be at least 6 characters long.';
                case RegisterFailure.noPasswordMatch:
                  errorMessage = 'Passwords do not match.';
              }
              showAppErrorBottomSheet(
                context: context,
                title: context.l10n.register_error_title,
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
                            const RegisterHeader(),
                            RegisterForm(
                              nameController: _nameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              confirmPasswordController:
                                  _confirmPasswordController,
                              nameFocus: _nameFocus,
                              emailFocus: _emailFocus,
                              passwordFocus: _passwordFocus,
                              confirmPasswordFocus: _confirmPasswordFocus,
                            ),
                            const RegisterAgreement(),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                final isLoading =
                                    state.userResponse.status.isLoading;
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
