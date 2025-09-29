import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/error_service.dart';
import '../../../core/services/logging_service.dart';

class ErrorBoundary extends ConsumerStatefulWidget {
  final Widget child;
  final Widget? fallback;
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
  });

  @override
  ConsumerState<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends ConsumerState<ErrorBoundary> {
  bool hasError = false;
  String? errorDetails;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return widget.fallback ?? _buildErrorWidget();
    }

    return widget.child;
  }

  Widget _buildErrorWidget() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                widget.errorTitle ?? 'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.errorMessage ?? 
                'An unexpected error occurred. Please try again.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              if (errorDetails != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    errorDetails!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: _reportError,
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Report'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retry() {
    setState(() {
      hasError = false;
      errorDetails = null;
    });
    
    if (widget.onRetry != null) {
      widget.onRetry!();
    }
  }

  void _reportError() {
    // In a real app, this would send error reports to a service
    LoggingService().error('User reported error', extra: {
      'errorDetails': errorDetails,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error reported. Thank you for your feedback!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    setState(() {
      hasError = true;
      errorDetails = error.toString();
    });

    LoggingService().error('Error boundary caught error', 
      error: error, 
      stackTrace: stackTrace,
    );
  }
}

// Error boundary provider
final errorBoundaryProvider = Provider<ErrorBoundary>((ref) {
  return ErrorBoundary(
    child: const SizedBox.shrink(),
  );
});

// Global error handler
class GlobalErrorHandler {
  static void initialize() {
    FlutterError.onError = (FlutterErrorDetails details) {
      LoggingService().error(
        'Flutter error: ${details.exception}',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      LoggingService().error(
        'Platform error: $error',
        error: error,
        stackTrace: stack,
      );
      return true;
    };
  }
}

// Error boundary wrapper for specific widgets
class SafeWidget extends StatelessWidget {
  final Widget child;
  final String? errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const SafeWidget({
    super.key,
    required this.child,
    this.errorTitle,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      onRetry: onRetry,
      child: child,
    );
  }
}

// Error boundary for async operations
class AsyncErrorBoundary extends ConsumerStatefulWidget {
  final Future<void> Function() operation;
  final Widget child;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final VoidCallback? onRetry;

  const AsyncErrorBoundary({
    super.key,
    required this.operation,
    required this.child,
    this.loadingWidget,
    this.errorWidget,
    this.onRetry,
  });

  @override
  ConsumerState<AsyncErrorBoundary> createState() => _AsyncErrorBoundaryState();
}

class _AsyncErrorBoundaryState extends ConsumerState<AsyncErrorBoundary> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _executeOperation();
  }

  Future<void> _executeOperation() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
        errorMessage = null;
      });

      await widget.operation();
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });

      LoggingService().error('Async operation failed', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return widget.loadingWidget ?? const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (hasError) {
      return widget.errorWidget ?? _buildErrorWidget();
    }

    return widget.child;
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Operation failed',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'An unexpected error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _executeOperation();
                if (widget.onRetry != null) {
                  widget.onRetry!();
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
