import 'package:flutter/material.dart';
import 'package:shartflix/core/extensions/context_ext.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.not_found_view_app_bar_title),
      ),
      body: Center(
        child: Text(
          context.l10n.not_found_view_message,
        ),
      ),
    );
  }
}
