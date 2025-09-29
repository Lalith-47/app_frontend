import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/common/custom_button.dart';

class ErrorScreen extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Error Title
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Error Message
              Text(
                error ?? 'An unexpected error occurred. Please try again.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Action Buttons
              Column(
                children: [
                  CustomButton(
                    text: 'Try Again',
                    onPressed: onRetry ?? () {
                      context.go('/');
                    },
                    isFullWidth: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  CustomButton(
                    text: 'Go Home',
                    type: ButtonType.outline,
                    onPressed: () {
                      context.go('/');
                    },
                    isFullWidth: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




