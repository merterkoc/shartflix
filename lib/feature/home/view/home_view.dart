import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/bloc/user/user_bloc.dart';
import 'package:shartflix/core/settings/settings_controller.dart';
import 'package:shartflix/feature/home/tabs/movies_tab.dart';
import 'package:shartflix/feature/home/tabs/profile_tab.dart';
import 'package:shartflix/ui/app_ui.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    if (context.read<UserBloc>().state.userResponse.status.isInitialized) {
      context.read<UserBloc>().add(const FetchUser());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = GetIt.instance<SettingsController>();
    final pages = <Widget>[
      const MoviesTab(),
      const ProfileTab(),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _selectedIndex == 1
          ? AppBar(
              centerTitle: true,
              title: Text(
                context.l10n.home_view_profile_title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    settings.themeMode == Brightness.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  tooltip: context.l10n.home_view_dark_light_tooltip,
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
                  tooltip: context.l10n.home_view_change_theme_tooltip,
                  onPressed: () {
                    settings.updateThemeStyle((settings.themeStyle + 1) % 4);
                  },
                ),

                IconButton(
                  onPressed: () {
                    context.read<UserBloc>().add(const LogoutRequested());
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
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
                        text: context.l10n.home_view_home_button,
                        icon: Icons.home,
                        onPressed: () {},
                      )
                    : AppButton.outlined(
                        text: context.l10n.home_view_home_button,
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
                        text: context.l10n.home_view_profile_button,
                        icon: Icons.person,
                        onPressed: () {},
                      )
                    : AppButton.outlined(
                        text: context.l10n.home_view_profile_button,
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
