import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/network/api_client.dart';
import 'core/services/cache_service.dart';
import 'core/services/logging_service.dart';
import 'shared/widgets/app_router.dart';
import 'shared/widgets/theme/app_theme.dart';
import 'shared/widgets/common/error_boundary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize global error handling
  GlobalErrorHandler.initialize();
  
  // Initialize logging
  LoggingService().info('App starting...');
  
  try {
    // Initialize Hive for local storage
    await Hive.initFlutter();
    LoggingService().info('Hive initialized');
    
    // Initialize Cache Service
    await CacheService().initialize();
    LoggingService().info('Cache service initialized');
    
    // Initialize API Client
    ApiClient().initialize();
    LoggingService().info('API client initialized');
    
    // Clean expired cache
    await CacheService().cleanExpiredCache();
    LoggingService().info('Expired cache cleaned');
    
    LoggingService().info('All services initialized successfully');
    
    runApp(
      const ProviderScope(
        child: PranitiApp(),
      ),
    );
  } catch (e, stackTrace) {
    LoggingService().fatal('Failed to initialize app', error: e, stackTrace: stackTrace);
    rethrow;
  }
}

class PranitiApp extends ConsumerWidget {
  const PranitiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}