import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/library/presentation/screens/library_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: YarnBopApp(),
    ),
  );
}

class YarnBopApp extends StatelessWidget {
  const YarnBopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YarnBop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LibraryScreen(),
    );
  }
}
