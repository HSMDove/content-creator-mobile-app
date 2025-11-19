import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/folder_provider.dart';
import 'screens/folder_list_screen.dart';

void main() {
  runApp(const ContentCreatorApp());
}

class ContentCreatorApp extends StatelessWidget {
  const ContentCreatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FolderProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'منظم أفكار المحتوى',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
          fontFamily: 'Roboto',
        ),
        home: const FolderListScreen(),
      ),
    );
  }
}
