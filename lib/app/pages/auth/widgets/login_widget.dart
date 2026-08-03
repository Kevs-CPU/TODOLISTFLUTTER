// lib/app/pages/auth/widgets/login_widget.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:todovalidate/app/providers/auth_provider.dart';
import 'package:todovalidate/app/pages/auth/widgets/login_widget_styles.dart';
import 'package:todovalidate/core/failure.dart';
import 'package:todovalidate/core/autoroutes/routes.dart';

@RoutePage()
class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegistering = false;
  bool _isResetting = false;
  bool _showPassword = false;
  bool _loading = false;

  String? _localError;
  String? _successMessage;

  bool _showToast = false;
  String _toastMessage = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _resetFields() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  void _toggleMode() {
    if (mounted) {
      setState(() {
        _isRegistering = !_isRegistering;
        _isResetting = false;
        _localError = null;
        _successMessage = null;
      });
    }
    _resetFields();
  }

  void _toggleReset() {
    if (mounted) {
      setState(() {
        _isResetting = !_isResetting;
        _isRegistering = false;
        _localError = null;
        _successMessage = null;
      });
    }
    _resetFields();
  }

  void _showToastMessage(String message) {
    if (mounted) {
      setState(() {
        _showToast = true;
        _toastMessage = message;
      });
    }
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showToast = false);
    });
  }

  void _showError(String message) {
    if (mounted) {
      setState(() {
        _localError = message;
        _successMessage = null;
      });
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      setState(() {
        _successMessage = message;
        _localError = null;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (mounted) {
      setState(() {
        _localError = null;
        _successMessage = null;
        _loading = true;
      });
    }

    final authProvider = context.read<AuthProvider>();

    try {
      if (_isResetting) {
        debugPrint('[LoginWidget] Resetting password for: ${_emailController.text}');
        await authProvider.resetPassword(_emailController.text);

        if (mounted) {
          _showSuccess('Password reset email sent! Check your inbox.');
          setState(() => _isResetting = false);
        }
        _resetFields();

      } else if (_isRegistering) {
        debugPrint('[LoginWidget] Registering user: ${_usernameController.text}');
        final result = await authProvider.register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );

        final message = result['message']?.toString() ??
            'You are registered! Please log in.';

        _showToastMessage(message);
        _resetFields();

        if (mounted) {
          setState(() => _isRegistering = false);
        }

      } else {
        debugPrint('[LoginWidget] Logging in: ${_usernameController.text}');
        await authProvider.loginWithUsername(
          _usernameController.text,
          _passwordController.text,
        );

        if (mounted) {
          context.router.replace(const DashboardRoute());
        }
      }

    } on AuthFailure catch (e) {
      debugPrint('[LoginWidget] AuthFailure: ${e.message}');
      _showError(e.message);

    } on ValidationFailure catch (e) {
      debugPrint('[LoginWidget] ValidationFailure: ${e.message}');
      _showError(e.message);

    } on ServerFailure catch (e) {
      debugPrint('[LoginWidget] ServerFailure: ${e.message}');
      _showError('Server error. Please try again later.');

    } catch (error) {
      debugPrint('[LoginWidget] Unknown error: $error');
      _showError(error.toString().replaceFirst('Exception: ', ''));

    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // Soft blurred circle accent, like the blobs peeking behind the cards
  // in the reference design.
  Widget _blurBlob({required double size, required Color color}) {
    return IgnorePointer(
      child: ClipOval(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
          child: Container(
            width: size,
            height: size,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LoginWidgetStyles.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Toast Notification
            if (_showToast)
              Positioned(
                top: MediaQuery.of(context).padding.top + 20,
                left: 20,
                right: 20,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: LoginWidgetStyles.successColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 20,
                          color: LoginWidgetStyles.successColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _toastMessage,
                            style: const TextStyle(
                              color: LoginWidgetStyles.successColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() => _showToast = false);
                            }
                          },
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: LoginWidgetStyles.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Decorative blurred blobs, peeking from behind the card
                    // like in the reference design.
                    Positioned(
                      top: -50,
                      left: -40,
                      child: _blurBlob(
                        size: 130,
                        color: LoginWidgetStyles.blobColor.withValues(alpha: 0.55),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      right: -50,
                      child: _blurBlob(
                        size: 170,
                        color: LoginWidgetStyles.blobColor.withValues(alpha: 0.55),
                      ),
                    ),

                    // Gradient-bordered card
                    Container(
                      constraints: const BoxConstraints(maxWidth: 420),
                      decoration: LoginWidgetStyles.cardOuterDecoration,
                      padding: EdgeInsets.all(LoginWidgetStyles.cardBorderWidth),
                      child: Container(
                        decoration: LoginWidgetStyles.cardInnerDecoration,
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header with Icon Badge
                              Container(
                                width: 48,
                                height: 48,
                                decoration: LoginWidgetStyles.iconBadgeDecoration,
                                child: const Icon(
                                  Icons.assignment_turned_in,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _isResetting
                                    ? 'Reset Password'
                                    : _isRegistering
                                        ? 'Create Account'
                                        : 'Todo List',
                                style: LoginWidgetStyles.titleStyle,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _isResetting
                                    ? 'Reset your password'
                                    : _isRegistering
                                        ? 'Create your account'
                                        : 'Sign in to continue',
                                textAlign: TextAlign.center,
                                style: LoginWidgetStyles.subtitleStyle,
                              ),
                              const SizedBox(height: 28),

                              // Message Slot
                              SizedBox(
                                height: 22,
                                child: _localError != null
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.warning_amber_rounded,
                                            size: 16,
                                            color: LoginWidgetStyles.errorColor,
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              _localError!,
                                              style: LoginWidgetStyles.errorTextStyle,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : (_successMessage != null
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.check_circle,
                                                size: 16,
                                                color: LoginWidgetStyles.successColor,
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  _successMessage!,
                                                  style: LoginWidgetStyles.successTextStyle,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink()),
                              ),
                              const SizedBox(height: 12),

                              // USERNAME FIELD
                              if (!_isResetting) ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Username',
                                    style: LoginWidgetStyles.labelStyle,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _usernameController,
                                  enabled: !_loading,
                                  style: const TextStyle(
                                    color: LoginWidgetStyles.inputTextColor,
                                    fontSize: 14.5,
                                  ),
                                  keyboardType: TextInputType.text,
                                  autofillHints: const [AutofillHints.username],
                                  decoration: LoginWidgetStyles.inputDecoration(
                                    hint: 'Enter your username',
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                      size: 16,
                                      color: LoginWidgetStyles.iconColor,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Username is required';
                                    }
                                    if (value.length < 3 || value.length > 20) {
                                      return 'Username must be 3-20 characters';
                                    }
                                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                      return 'Username can only contain letters, numbers, and underscores';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                              ],

                              // EMAIL FIELD
                              if (_isRegistering || _isResetting) ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Email Address',
                                    style: LoginWidgetStyles.labelStyle,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _emailController,
                                  enabled: !_loading,
                                  style: const TextStyle(
                                    color: LoginWidgetStyles.inputTextColor,
                                    fontSize: 14.5,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  decoration: LoginWidgetStyles.inputDecoration(
                                    hint: 'example@gmail.com',
                                    prefixIcon: const Icon(
                                      Icons.mail_outline,
                                      size: 16,
                                      color: LoginWidgetStyles.iconColor,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Email is required';
                                    }
                                    if (!value.contains('@') || !value.contains('.')) {
                                      return 'Enter a valid email address';
                                    }
                                    final emailRegex = RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                    );
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                              ],

                              // Password
                              if (!_isResetting) ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Password',
                                    style: LoginWidgetStyles.labelStyle,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _passwordController,
                                  enabled: !_loading,
                                  style: const TextStyle(
                                    color: LoginWidgetStyles.inputTextColor,
                                    fontSize: 14.5,
                                  ),
                                  obscureText: !_showPassword,
                                  autofillHints: [
                                    _isRegistering
                                        ? AutofillHints.newPassword
                                        : AutofillHints.password
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'Enter your password',
                                    hintStyle: const TextStyle(
                                      color: LoginWidgetStyles.inputHintColor,
                                      fontSize: 14.5,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      size: 16,
                                      color: LoginWidgetStyles.iconColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 16,
                                        color: LoginWidgetStyles.iconColor,
                                      ),
                                      onPressed: _loading
                                          ? null
                                          : () => setState(
                                              () => _showPassword = !_showPassword,
                                            ),
                                    ),
                                    filled: true,
                                    fillColor: LoginWidgetStyles.inputBackground,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 38,
                                      vertical: 11,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: LoginWidgetStyles.inputBorder,
                                        width: 1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: LoginWidgetStyles.inputBorder,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: LoginWidgetStyles.accentColor,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    if (_isRegistering && value.length < 8) {
                                      return 'Password must be at least 8 characters for registration';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 4),
                              ],
                              const SizedBox(height: 18),

                              // Submit Button — floating white pill w/ shadow
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Ink(
                                    decoration: LoginWidgetStyles.buttonDecoration(
                                      disabled: _loading,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                      alignment: Alignment.center,
                                      child: Text(
                                        _loading
                                            ? 'Loading...'
                                            : _isResetting
                                                ? 'Send reset email'
                                                : _isRegistering
                                                    ? 'Create account'
                                                    : 'Sign in',
                                        style: LoginWidgetStyles.buttonTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Footer Buttons — plain "Cancel"-style links
                              if (!_isResetting)
                                TextButton(
                                  onPressed: _loading ? null : _toggleMode,
                                  child: Text(
                                    _isRegistering
                                        ? 'Already have an account? Sign in'
                                        : "Don't have an account? Sign up",
                                    style: LoginWidgetStyles.toggleButtonStyle,
                                  ),
                                ),
                              TextButton(
                                onPressed: _loading ? null : _toggleReset,
                                child: Text(
                                  _isResetting
                                      ? 'Back to sign in'
                                      : 'Forgot password?',
                                  style: LoginWidgetStyles.toggleButtonStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}