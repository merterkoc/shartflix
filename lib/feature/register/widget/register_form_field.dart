import 'package:flutter/material.dart';
import 'package:shartflix/core/widget/text_field/app_password_field.dart';
import 'package:shartflix/core/widget/text_field/app_text_field.dart';

class RegisterFormField extends StatelessWidget {
  const RegisterFormField({
    required this.controller,
    required this.hintText,
    super.key,
    this.prefixIcon,
    this.keyboardType,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.autofillHints,
    this.isPassword = false,
    this.hasError = false,
    this.errorMessage,
    this.showError = false,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final List<String>? autofillHints;
  final bool isPassword;
  final bool hasError;
  final String? errorMessage;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.ease,
      margin: EdgeInsets.only(
        bottom: (hasError && showError) ? 8 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPassword)
            AppPasswordField(
              controller: controller,
              hintText: hintText,
              focusNode: focusNode,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
              onChanged: onChanged,
              autofillHints: autofillHints,
            )
          else
            AppTextField(
              controller: controller,
              hintText: hintText,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              keyboardType: keyboardType,
              focusNode: focusNode,
              textInputAction: textInputAction,
              onFieldSubmitted: onFieldSubmitted,
              onChanged: onChanged,
              autofillHints: autofillHints,
            ),
          AnimatedOpacity(
            opacity: (hasError && showError) ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: (hasError && showError)
                ? Padding(
                    padding: const EdgeInsets.only(top: 2, left: 8),
                    child: Text(
                      errorMessage ?? '',
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
    );
  }
}
