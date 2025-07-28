import 'package:flutter/material.dart';
import 'package:shartflix/core/extensions/context_ext.dart';
import 'package:shartflix/core/widget/button/app_button.dart';

Future<void> showAppErrorBottomSheet({
  required BuildContext context,
  required String title,
  required String message,
  IconData? icon,
  VoidCallback? onAction,
  String? actionLabel,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _AppErrorBottomSheet(
      title: title,
      message: message,
      icon: icon,
      onAction: onAction,
      actionLabel: actionLabel,
    ),
  );
}

class _AppErrorBottomSheet extends StatelessWidget {
  const _AppErrorBottomSheet({
    required this.title,
    required this.message,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  final String title;
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
              const SizedBox(height: 24),
              AppButton.primary(
                text: context.l10n.close_button_label,
                width: double.infinity,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
