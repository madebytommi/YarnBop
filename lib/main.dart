import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/local_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/library/presentation/screens/library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive offline database
  await LocalStorageService.initHive();

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
