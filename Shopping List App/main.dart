import 'package:flutter/material.dart';
import 'package:shopping_list/list_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 51, 59),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: ListScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
