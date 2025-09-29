import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'logging_service.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, DateTime> _operationStartTimes = {};
  final Map<String, List<Duration>> _operationDurations = {};
  final Map<String, int> _operationCounts = {};
  final Map<String, int> _operationErrors = {};

  // Start timing an operation
  void startOperation(String operationName) {
    _operationStartTimes[operationName] = DateTime.now();
    LoggingService().logPerformance('Started: $operationName');
  }

  // End timing an operation
  Duration? endOperation(String operationName, {bool logResult = true}) {
    final startTime = _operationStartTimes.remove(operationName);
    if (startTime == null) {
      LoggingService().warning('Operation $operationName was not started');
      return null;
    }

    final duration = DateTime.now().difference(startTime);
    
    // Store duration for analytics
    _operationDurations.putIfAbsent(operationName, () => []).add(duration);
    _operationCounts[operationName] = (_operationCounts[operationName] ?? 0) + 1;

    if (logResult) {
      LoggingService().logPerformance('Completed: $operationName in ${duration.inMilliseconds}ms');
    }

    // Log slow operations
    if (duration.inMilliseconds > 1000) {
      LoggingService().warning('Slow operation: $operationName took ${duration.inMilliseconds}ms');
    }

    return duration;
  }

  // Record operation error
  void recordError(String operationName) {
    _operationErrors[operationName] = (_operationErrors[operationName] ?? 0) + 1;
    LoggingService().logPerformance('Error in operation: $operationName');
  }

  // Get operation statistics
  Map<String, dynamic> getOperationStats(String operationName) {
    final durations = _operationDurations[operationName] ?? [];
    final count = _operationCounts[operationName] ?? 0;
    final errors = _operationErrors[operationName] ?? 0;

    if (durations.isEmpty) {
      return {
        'operation': operationName,
        'count': count,
        'errors': errors,
        'errorRate': count > 0 ? errors / count : 0.0,
        'averageDuration': 0.0,
        'minDuration': 0.0,
        'maxDuration': 0.0,
        'totalDuration': 0.0,
      };
    }

    final totalDuration = durations.fold<Duration>(
      Duration.zero,
      (sum, duration) => sum + duration,
    );

    final averageDuration = totalDuration.inMilliseconds / durations.length;
    final minDuration = durations.map((d) => d.inMilliseconds).reduce((a, b) => a < b ? a : b);
    final maxDuration = durations.map((d) => d.inMilliseconds).reduce((a, b) => a > b ? a : b);

    return {
      'operation': operationName,
      'count': count,
      'errors': errors,
      'errorRate': count > 0 ? errors / count : 0.0,
      'averageDuration': averageDuration,
      'minDuration': minDuration,
      'maxDuration': maxDuration,
      'totalDuration': totalDuration.inMilliseconds,
    };
  }

  // Get all operation statistics
  Map<String, Map<String, dynamic>> getAllStats() {
    final stats = <String, Map<String, dynamic>>{};
    
    for (final operation in _operationDurations.keys) {
      stats[operation] = getOperationStats(operation);
    }
    
    return stats;
  }

  // Clear statistics
  void clearStats() {
    _operationDurations.clear();
    _operationCounts.clear();
    _operationErrors.clear();
    LoggingService().logPerformance('Performance statistics cleared');
  }

  // Monitor memory usage
  void logMemoryUsage() {
    if (kDebugMode) {
      developer.log('Memory usage: ${_getMemoryUsage()}');
    }
  }

  String _getMemoryUsage() {
    // This is a simplified memory usage calculation
    // In a real app, you might use platform-specific APIs
    return 'Memory usage monitoring not available in debug mode';
  }

  // Monitor frame rendering performance
  void startFrameMonitoring() {
    if (kDebugMode) {
      // Frame monitoring would be implemented here
      LoggingService().logPerformance('Frame monitoring started');
    }
  }

  void stopFrameMonitoring() {
    if (kDebugMode) {
      LoggingService().logPerformance('Frame monitoring stopped');
    }
  }

  // Performance timing decorator
  Future<T> timeOperation<T>(
    String operationName,
    Future<T> Function() operation, {
    bool logResult = true,
  }) async {
    startOperation(operationName);
    try {
      final result = await operation();
      endOperation(operationName, logResult: logResult);
      return result;
    } catch (e) {
      recordError(operationName);
      endOperation(operationName, logResult: logResult);
      rethrow;
    }
  }

  // Synchronous operation timing
  T timeSyncOperation<T>(
    String operationName,
    T Function() operation, {
    bool logResult = true,
  }) {
    startOperation(operationName);
    try {
      final result = operation();
      endOperation(operationName, logResult: logResult);
      return result;
    } catch (e) {
      recordError(operationName);
      endOperation(operationName, logResult: logResult);
      rethrow;
    }
  }

  // Network performance monitoring
  void recordNetworkRequest(String endpoint, Duration duration, bool success) {
    final operationName = 'network_$endpoint';
    _operationDurations.putIfAbsent(operationName, () => []).add(duration);
    _operationCounts[operationName] = (_operationCounts[operationName] ?? 0) + 1;
    
    if (!success) {
      recordError(operationName);
    }

    LoggingService().logPerformance(
      'Network request: $endpoint ${success ? 'success' : 'failed'} in ${duration.inMilliseconds}ms',
    );
  }

  // Database performance monitoring
  void recordDatabaseOperation(String operation, Duration duration, bool success) {
    final operationName = 'db_$operation';
    _operationDurations.putIfAbsent(operationName, () => []).add(duration);
    _operationCounts[operationName] = (_operationCounts[operationName] ?? 0) + 1;
    
    if (!success) {
      recordError(operationName);
    }

    LoggingService().logPerformance(
      'Database operation: $operation ${success ? 'success' : 'failed'} in ${duration.inMilliseconds}ms',
    );
  }

  // UI performance monitoring
  void recordUIRender(String widgetName, Duration duration) {
    final operationName = 'ui_$widgetName';
    _operationDurations.putIfAbsent(operationName, () => []).add(duration);
    _operationCounts[operationName] = (_operationCounts[operationName] ?? 0) + 1;

    LoggingService().logPerformance(
      'UI render: $widgetName in ${duration.inMilliseconds}ms',
    );
  }

  // Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    final allStats = getAllStats();
    final totalOperations = _operationCounts.values.fold(0, (sum, count) => sum + count);
    final totalErrors = _operationErrors.values.fold(0, (sum, errors) => sum + errors);
    final totalDuration = allStats.values
        .map((stats) => stats['totalDuration'] as double)
        .fold(0.0, (sum, duration) => sum + duration);

    return {
      'totalOperations': totalOperations,
      'totalErrors': totalErrors,
      'errorRate': totalOperations > 0 ? totalErrors / totalOperations : 0.0,
      'totalDuration': totalDuration,
      'averageOperationTime': totalOperations > 0 ? totalDuration / totalOperations : 0.0,
      'operationCount': allStats.length,
      'operations': allStats,
    };
  }
}
