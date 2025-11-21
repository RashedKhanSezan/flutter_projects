import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // Uses the themeMode from the ThemeProvider
            themeMode: themeProvider.themeMode, 
            theme: ThemeData(
              useMaterial3: true,
              // Uses Teal as the primary color seed for a modern look
              colorSchemeSeed: Colors.teal,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              // Uses Teal as the primary color seed for a modern look
              colorSchemeSeed: Colors.teal,
              brightness: Brightness.dark,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
