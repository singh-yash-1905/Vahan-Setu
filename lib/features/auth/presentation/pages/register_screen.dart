import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vahan_setu/features/auth/presentation/bloc/register_event.dart';
import 'package:vahan_setu/features/auth/presentation/bloc/register_state.dart';

import '../../../../core/theme/app_colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _accessCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _accessCodeController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    if (_accessCodeController.text.trim() != 'ADMIN_ACCESS_2026') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid admin access code'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      RegisterRequested(
        accessCode: _accessCodeController.text.trim(),
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        role: _roleController.text.trim(),
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputAction textInputAction = TextInputAction.next,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: _decoration(label, icon).copyWith(suffixIcon: suffixIcon),
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Enter $label';
            }
            return null;
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }

          if (state is AuthAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful. Please login.'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.directions_car,
                          size: 80,
                          color: AppColors.primary,
                        ).animate().fadeIn().scale(),

                        const SizedBox(height: 24),

                        const Text(
                          'Vahan Setu Admin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideY(),

                        const SizedBox(height: 12),

                        const Text(
                          'Create Admin Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),

                        const SizedBox(height: 40),

                        _field(
                          controller: _accessCodeController,
                          label: 'Access Code',
                          icon: Icons.key_outlined,
                        ).animate().fadeIn(delay: 300.ms).slideX(),

                        const SizedBox(height: 16),

                        _field(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter email';
                            }

                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }

                            return null;
                          },
                        ).animate().fadeIn(delay: 400.ms).slideX(),

                        const SizedBox(height: 16),

                        _field(
                          controller: _nameController,
                          label: 'Name',
                          icon: Icons.person_outline,
                        ).animate().fadeIn(delay: 450.ms).slideX(),

                        const SizedBox(height: 16),

                        _field(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ).animate().fadeIn(delay: 500.ms).slideX(),

                        const SizedBox(height: 16),

                        _field(
                          controller: _phoneController,
                          label: 'Phone',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ).animate().fadeIn(delay: 550.ms).slideX(),

                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: _roleController.text.isEmpty
                              ? null
                              : _roleController.text,
                          decoration: _decoration(
                            'Role',
                            Icons.admin_panel_settings_outlined,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Admin (Auditor & Approver)',
                              child: Text('Admin (Auditor & Approver)'),
                            ),
                          ],
                          onChanged: (value) {
                            _roleController.text = value ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Select role';
                            }

                            return null;
                          },
                        ).animate().fadeIn(delay: 600.ms).slideX(),

                        const SizedBox(height: 32),

                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ).animate().fadeIn(delay: 650.ms).scale(),

                        const SizedBox(height: 20),

                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                },
                          child: const Text('Already have an account? Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
