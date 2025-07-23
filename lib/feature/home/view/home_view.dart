import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/core/settings/settings_controller.dart';
import 'package:shartflix/core/widget/button/app_button.dart';
import 'package:shartflix/feature/login/bloc/user_bloc.dart';
import 'package:shartflix/ui/app_ui.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final settings = GetIt.instance<SettingsController>();
    final pages = <Widget>[
      const Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Page', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 32),
            AppButton.outlined(
              text: 'Logout',
              icon: Icons.logout,
              onPressed: () {
                context.read<UserBloc>().add(
                  const LogoutRequested(),
                );
              },
            ),
          ],
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              settings.themeMode == Brightness.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip: 'Dark/Light',
            onPressed: () {
              settings.updateThemeMode(
                settings.themeMode == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.palette),
            tooltip: 'Change Theme Color',
            onPressed: () {
              settings.updateThemeStyle((settings.themeStyle + 1) % 4);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _selectedIndex == 0
                    ? AppButton.primary(
                        text: 'Home',
                        icon: Icons.home,
                        onPressed: () {},
                      )
                    : AppButton.outlined(
                        text: 'Home',
                        icon: Icons.home,
                        onPressed: () {
                          setState(() => _selectedIndex = 0);
                        },
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _selectedIndex == 1
                    ? AppButton.primary(
                        text: 'Profile',
                        icon: Icons.person,
                        onPressed: () {},
                      )
                    : AppButton.outlined(
                        text: 'Profile',
                        icon: Icons.person,
                        onPressed: () {
                          setState(() => _selectedIndex = 1);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
