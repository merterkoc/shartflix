import 'package:flutter/material.dart';
import 'package:shartflix/core/router/authentication_listener.dart';

class ShellView extends StatefulWidget {
  const ShellView({required this.child, super.key});

  final Widget child;

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView>
    with
        AutomaticKeepAliveClientMixin<ShellView>,
        WidgetsBindingObserver
        {
  AppLifecycleState? appState;

  @override
  void initState() {
    super.initState();
    AuthenticationRouterListener.listen();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appState = state;
    if (state == AppLifecycleState.resumed) {
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
