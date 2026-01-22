import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Settingss"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              editOpt(color, "Edit About section"),
              editOpt(color, "Edit Projects section"),
              editOpt(color, "Edit Education section"),
              editOpt(color, "Edit Experience section"),
              editOpt(color, "Edit Skills section"),
            ],
          ),
        ),
      ),
    );
  }

  Widget editOpt(ColorScheme color, String title) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Clicked")));
        },
        child: Container(
          width: isDesktop ? size.width * 0.4 : size.width * 0.8,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.outline.withAlpha(50)),
            boxShadow: [
              BoxShadow(
                color: color.tertiary.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(2, 5),
              ),
            ],
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
