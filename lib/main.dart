import 'package:essumin_mix/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'ui/screens/home_screen.dart';
import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:essumin_mix/data/models/simbologia/simbologia.dart';

import 'package:essumin_mix/ui/screens/siglas/sigla_selected_screen.dart';
import 'package:essumin_mix/ui/screens/simbologia/simbologia_selected_screen.dart';

import 'package:essumin_mix/ui/themes/custom_elevated_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(username: 'Walter Vilca')
  ];

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
      ),
      home: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.push_pin),
              label: 'Info',
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
        // '/': (context) => BlocProvider(
        //       create: (_) => DataBloc(),
        //       child: const HomeScreen(),
        //     ),
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
