import 'package:essumin_mix/ui/screens/acronyms/acronym_option_screen.dart';
import 'package:essumin_mix/ui/screens/rigger/rigger_option_screen.dart';
import 'package:flutter/material.dart';

import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:essumin_mix/data/models/simbologia/simbologia.dart';

import 'package:essumin_mix/ui/screens/app_info_screen.dart';
import 'package:essumin_mix/ui/screens/home_screen.dart';
import 'package:essumin_mix/ui/screens/siglas/sigla_selected_screen.dart';
import 'package:essumin_mix/ui/screens/simbologia/simbologia_selected_screen.dart';
import 'package:essumin_mix/ui/themes/custom_elevated_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const AppInfo(developer: 'Walter Vilca'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'essumin-mix',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1e40af),
        ),
        scaffoldBackgroundColor: const Color(0xFF0d1117),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        elevatedButtonTheme: customElevatedButtonTheme,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'App Info',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      routes: {
        '/acronyms': (context) {
          final Map<String, dynamic> routeArguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final List<Sigla> data = routeArguments['data'] as List<Sigla>;

          return AcronymOptionScreen(data: data);
        },
        '/rigger': (context) {
          final Map<String, dynamic> routeArguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final List<Simbologia> data =
              routeArguments['data'] as List<Simbologia>;

          return RiggerOptionScreen(data: data);
        },
        '/siglas': (context) {
          final Map<String, dynamic> routeArguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final String category = routeArguments['category'] as String;
          final List<Sigla> options = routeArguments['options'] as List<Sigla>;

          return SiglaSelectedScreen(category: category, options: options);
        },
        '/simbologias': (context) {
          final Map<String, dynamic>? routeArguments = ModalRoute.of(context)
              ?.settings
              .arguments as Map<String, dynamic>?;

          final String category = routeArguments?['category'] as String;
          final List<Simbologia> data =
              routeArguments?['data'] as List<Simbologia>;

          return SimbologiaSelectedScreen(category: category, data: data);
        },
      },
    );
  }
}
