import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

         
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Icon(
                themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: themeProvider.isDark,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
