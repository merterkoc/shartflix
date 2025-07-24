import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shartflix/core/widget/text_field/app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    required this.controller,
    required this.hintText,
    super.key,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofocus = false,
    this.onChanged,
    this.autofillHints,
  });

  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final List<String>? autofillHints;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      prefixIcon: const Icon(FontAwesomeIcons.lock),
      obscureText: _obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      autofillHints: widget.autofillHints,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    );
  }
}
