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
  bool _isRegistered = false;

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
        _isRegistered = false;
      });
    }
    _resetFields();
  }

  void _goToLogin() {
    if (mounted) {
      setState(() {
        _isRegistering = false;
        _isResetting = false;
        _localError = null;
        _successMessage = null;
        _isRegistered = false;
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
        _isRegistered = false;
      });
    }
    _resetFields();
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      setState(() {
        _isRegistered = true;
        _successMessage = AuthProvider.cleanErrorMessage(message);
        _localError = null;
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      setState(() {
        _localError = AuthProvider.cleanErrorMessage(message);
        _successMessage = null;
        _isRegistered = false;
      });
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      setState(() {
        _successMessage = AuthProvider.cleanErrorMessage(message);
        _localError = null;
        _isRegistered = false;
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
        _isRegistered = false;
      });
    }

    final authProvider = context.read<AuthProvider>();

    try {
      if (_isResetting) {
        await authProvider.resetPassword(_emailController.text);
        if (mounted) {
          _showSuccess('Password reset email sent! Check your inbox.');
          setState(() => _isResetting = false);
        }
        _resetFields();
      } else if (_isRegistering) {
        final result = await authProvider.register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );
        final message = result['message']?.toString() ??
            'You are registered! Please log in.';
        _showSuccessMessage(message);
        _resetFields();
        if (mounted) {
          setState(() {
            _isResetting = false;
            _isRegistering = false;
          });
        }
      } else {
        await authProvider.loginWithUsername(
          _usernameController.text,
          _passwordController.text,
        );
        if (mounted) {
          await context.router.replace(const DashboardRoute());
        }
      }
    } on AuthFailure catch (e) {
      _showError(e.message);
    } on ValidationFailure catch (e) {
      _showError(e.message);
    } on NetworkFailure catch (e) {
      _showError(e.message);
    } on ServerFailure catch (_) {
      _showError('Server error. Please try again later.');
    } catch (error) {
      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LoginWidgetStyles.backgroundGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 420,
                maxHeight: screenHeight * 0.85,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -40,
                    left: -30,
                    child: _blurBlob(
                      size: 100,
                      color: LoginWidgetStyles.blobColor.withValues(alpha: 0.5),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    right: -30,
                    child: _blurBlob(
                      size: 130,
                      color: LoginWidgetStyles.blobColor.withValues(alpha: 0.5),
                    ),
                  ),
                  Container(
                    decoration: LoginWidgetStyles.cardOuterDecoration,
                    padding: EdgeInsets.all(LoginWidgetStyles.cardBorderWidth),
                    child: Container(
                      decoration: LoginWidgetStyles.cardInnerDecoration,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 32,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: LoginWidgetStyles.iconBadgeDecoration,
                              child: const Icon(
                                Icons.assignment_turned_in,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _isResetting
                                  ? 'Reset Password'
                                  : _isRegistering && !_isRegistered
                                      ? 'Create Account'
                                      : _isRegistering && _isRegistered
                                          ? 'Registration Successful'
                                          : 'Todo List',
                              style: LoginWidgetStyles.titleStyle,
                            ),
                            const SizedBox(height: 4),
                            if (!_isRegistering || _isRegistered)
                              Text(
                                _isResetting
                                    ? 'Reset your password'
                                    : _isRegistering && _isRegistered
                                        ? 'You are registered! Please log in.'
                                        : 'Sign in to continue',
                                textAlign: TextAlign.center,
                                style: _isRegistering && _isRegistered
                                    ? TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green.shade600,
                                      )
                                    : LoginWidgetStyles.subtitleStyle,
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 20,
                              child: _localError != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.warning_amber_rounded,
                                          size: 14,
                                          color: LoginWidgetStyles.errorColor,
                                        ),
                                        const SizedBox(width: 4),
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
                                              size: 14,
                                              color: LoginWidgetStyles.successColor,
                                            ),
                                            const SizedBox(width: 4),
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
                            const SizedBox(height: 10),
                            if (!_isResetting && !_isRegistered) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Username',
                                  style: LoginWidgetStyles.labelStyle,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _usernameController,
                                enabled: !_loading,
                                style: const TextStyle(
                                  color: LoginWidgetStyles.inputTextColor,
                                  fontSize: 14,
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
                                validator: AuthProvider.validateUsername,
                              ),
                              const SizedBox(height: 14),
                            ],
                            if ((_isRegistering || _isResetting) && !_isRegistered) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email Address',
                                  style: LoginWidgetStyles.labelStyle,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _emailController,
                                enabled: !_loading,
                                style: const TextStyle(
                                  color: LoginWidgetStyles.inputTextColor,
                                  fontSize: 14,
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
                                validator: AuthProvider.validateEmail,
                              ),
                              const SizedBox(height: 14),
                            ],
                            if (!_isResetting && !_isRegistered) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Password',
                                  style: LoginWidgetStyles.labelStyle,
                                ),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _passwordController,
                                enabled: !_loading,
                                style: const TextStyle(
                                  color: LoginWidgetStyles.inputTextColor,
                                  fontSize: 14,
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
                                    fontSize: 14,
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
                                    horizontal: 34,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: LoginWidgetStyles.inputBorder,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: LoginWidgetStyles.inputBorder,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: LoginWidgetStyles.accentColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                validator: (value) => AuthProvider.validatePassword(
                                  value,
                                  isRegistering: _isRegistering,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                            const SizedBox(height: 14),
                            if (!_isRegistered)
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
                                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                            if (_isRegistered) ...[
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _goToLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Go to Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            if (!_isResetting && !_isRegistered)
                              TextButton(
                                onPressed: _loading ? null : _toggleMode,
                                child: Text(
                                  _isRegistering
                                      ? 'Already have an account? Sign in'
                                      : "Don't have an account? Sign up",
                                  style: LoginWidgetStyles.toggleButtonStyle,
                                ),
                              ),
                            if (!_isRegistered)
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
        ),
      ),
    );
  }
}