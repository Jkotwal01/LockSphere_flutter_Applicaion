import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _sendOtp() async {
    String phone = _phoneController.text.trim();
    FocusScope.of(context).unfocus();

    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    // Firebase requires E.164 format (+CountryCode). Defaulting for this environment:
    if (!phone.startsWith('+')) {
      phone = '+91$phone';
    }

    try {
      await context.read<AuthProvider>().sendOtp(
        phone,
        onCodeSent: (verificationId) {
          if (mounted) {
            context.read<AuthProvider>().setLoading(false);
            context.push(AppConstants.otpRoute, extra: {
              'phone': phone,
              'verificationId': verificationId,
            });
          }
        },
        onError: (e) {
          if (mounted) {
            context.read<AuthProvider>().setLoading(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Error from Firebase.')),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        context.read<AuthProvider>().setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to launch request.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.shield_rounded, size: 48, color: AppTheme.primary),
              const SizedBox(height: 32),
              Text('Welcome\nHome', style: AppTextStyles.displayLg),
              const SizedBox(height: 16),
              Text(
                'Enter your registered phone number to unlock the access gateway.',
                style: AppTextStyles.bodyLg,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: AppTextStyles.bodyLg,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF6B7280)),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: context.watch<AuthProvider>().isLoading ? null : _sendOtp,
                  child: context.watch<AuthProvider>().isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: AppTheme.primary, strokeWidth: 2),
                        )
                      : const Text('Send Verification Code', style: TextStyle(color: AppTheme.surface)),
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text('Login with Email instead', style: AppTextStyles.titleSm),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
