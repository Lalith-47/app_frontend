import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error, fatal }

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  factory LoggingService() => _instance;
  LoggingService._internal();

  static const String _appName = 'Praniti';

  void log(
    String message, {
    LogLevel level = LogLevel.info,
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    if (kDebugMode || level.index >= LogLevel.warning.index) {
      final logTag = tag ?? _appName;
      final timestamp = DateTime.now().toIso8601String();
      final levelStr = level.name.toUpperCase();
      
      final logMessage = '[$timestamp] [$levelStr] [$logTag] $message';
      
      switch (level) {
        case LogLevel.debug:
          developer.log(logMessage, level: 500);
          break;
        case LogLevel.info:
          developer.log(logMessage, level: 800);
          break;
        case LogLevel.warning:
          developer.log(logMessage, level: 900, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.error:
          developer.log(logMessage, level: 1000, error: error, stackTrace: stackTrace);
          break;
        case LogLevel.fatal:
          developer.log(logMessage, level: 1200, error: error, stackTrace: stackTrace);
          break;
      }
      
      if (extra != null && kDebugMode) {
        developer.log('Extra data: $extra', level: 500);
      }
    }
  }

  void debug(String message, {String? tag, Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.debug, tag: tag, extra: extra);
  }

  void info(String message, {String? tag, Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.info, tag: tag, extra: extra);
  }

  void warning(String message, {String? tag, dynamic error, Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.warning, tag: tag, error: error, extra: extra);
  }

  void error(String message, {String? tag, dynamic error, StackTrace? stackTrace, Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.error, tag: tag, error: error, stackTrace: stackTrace, extra: extra);
  }

  void fatal(String message, {String? tag, dynamic error, StackTrace? stackTrace, Map<String, dynamic>? extra}) {
    log(message, level: LogLevel.fatal, tag: tag, error: error, stackTrace: stackTrace, extra: extra);
  }

  // Specific logging methods for different features
  void logAuth(String message, {Map<String, dynamic>? extra}) {
    info(message, tag: 'AUTH', extra: extra);
  }

  void logAuthError(String message, {dynamic error, StackTrace? stackTrace, Map<String, dynamic>? extra}) {
    error(message, tag: 'AUTH', error: error, stackTrace: stackTrace, extra: extra);
  }

  void logQuiz(String message, {Map<String, dynamic>? extra}) {
    info(message, tag: 'QUIZ', extra: extra);
  }

  void logQuizError(String message, {dynamic error, StackTrace? stackTrace, Map<String, dynamic>? extra}) {
    error(message, tag: 'QUIZ', error: error, stackTrace: stackTrace, extra: extra);
  }

  void logChat(String message, {Map<String, dynamic>? extra}) {
    info(message, tag: 'CHAT', extra: extra);
  }

  void logChatError(String message, {dynamic error, StackTrace? stackTrace, Map<String, dynamic>? extra}) {
    error(message, tag: 'CHAT', error: error, stackTrace: stackTrace, extra: extra);
  }

  void logApi(String message, {Map<String, dynamic>? extra}) {
    info(message, tag: 'API', extra: extra);
  }

  void logApiError(String message, {dynamic error, StackTrace? stackTrace, Map<String, dynamic>? extra}) {
    error(message, tag: 'API', error: error, stackTrace: stackTrace, extra: extra);
  }

  void logCache(String message, {Map<String, dynamic>? extra}) {
    debug(message, tag: 'CACHE', extra: extra);
  }

  void logPerformance(String message, {Map<String, dynamic>? extra}) {
    info(message, tag: 'PERFORMANCE', extra: extra);
  }

  void logSecurity(String message, {Map<String, dynamic>? extra}) {
    warning(message, tag: 'SECURITY', extra: extra);
  }

  void logUserAction(String action, {Map<String, dynamic>? extra}) {
    info('User action: $action', tag: 'USER_ACTION', extra: extra);
  }

  void logNavigation(String from, String to, {Map<String, dynamic>? extra}) {
    info('Navigation: $from -> $to', tag: 'NAVIGATION', extra: extra);
  }

  void logError(String message, {dynamic error, StackTrace? stackTrace, Map<String, dynamic>? extra}) {
    error(message, tag: 'ERROR', error: error, stackTrace: stackTrace, extra: extra);
  }

  // Performance logging
  void logPerformanceStart(String operation) {
    logPerformance('Starting: $operation');
  }

  void logPerformanceEnd(String operation, Duration duration) {
    logPerformance('Completed: $operation in ${duration.inMilliseconds}ms');
  }

  // Security logging
  void logSecurityEvent(String event, {Map<String, dynamic>? extra}) {
    logSecurity('Security event: $event', extra: extra);
  }

  void logSuspiciousActivity(String activity, {Map<String, dynamic>? extra}) {
    warning('Suspicious activity: $activity', tag: 'SECURITY', extra: extra);
  }
}
