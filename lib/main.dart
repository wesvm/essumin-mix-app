import 'package:essumin_mix/data/option.dart';
import 'package:essumin_mix/ui/screens/option_selected_screen.dart';
import 'package:essumin_mix/ui/themes/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/data_bloc.dart';
import 'ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
              create: (_) => DataBloc(),
              child: const HomeScreen(),
            ),
        '/option': (context) {
          final Map<String, dynamic> routeArguments = ModalRoute.of(context)!
              .settings
              .arguments as Map<String, dynamic>;
          final String category = routeArguments['category'] as String;
          final List<Option> options =
              routeArguments['options'] as List<Option>;

          return OptionSelectedScreen(category: category, options: options);
        },
      },
    );
  }
}
