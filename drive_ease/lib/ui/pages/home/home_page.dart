import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../logic/bloc/auth/auth_bloc.dart';
import '../../../logic/bloc/auth/auth_event.dart';
import '../../../logic/bloc/auth/auth_state.dart';
import '../katalog/katalog_list_page.dart';
import '../kategori/kategori_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const KatalogListPage(),
    const KategoriListPage(),
  ];

  final List<String> _titles = [
    'Katalog Kendaraan',
    'Kategori Kendaraan',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            _titles[_currentIndex],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          state.username,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: ShadTheme.of(context).colorScheme.primaryForeground,
                              ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: ShadTheme.of(context).colorScheme.primaryForeground,
                          radius: 16,
                          child: Text(
                            state.username.isNotEmpty ? state.username[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            ShadButton.ghost(
              child: const Icon(Icons.logout, color: Colors.red),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: ShadTheme.of(context).colorScheme.accent,
          unselectedItemColor: ShadTheme.of(context).colorScheme.mutedForeground,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: 'Katalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Kategori',
            ),
          ],
        ),
      ),
    );
  }
}
