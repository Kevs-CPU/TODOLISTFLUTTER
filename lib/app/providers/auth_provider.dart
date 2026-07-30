// lib/app/providers/auth_provider.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todovalidate/core/injection_container.dart';
import 'package:todovalidate/domain/repositories/auth_repository.dart';
import 'package:todovalidate/domain/usecases/auth/login_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/register_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/logout_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/reset_password_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/get_user_profile_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/save_user_profile_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/update_verified_email_usecase.dart';

class AuthProvider extends ChangeNotifier {
  // =====================================================
  // STATE
  // =====================================================

  User? _user;
  Map<String, dynamic>? _userProfile;
  bool _loading = true;
  String _verifiedEmail = '';
  bool _emailVerified = false;
  StreamSubscription<User?>? _authSubscription;
  bool _initialized = false;
  bool _disposed = false;

  // =====================================================
  // DEPENDENCIES (Using serviceLocator)
  // =====================================================

  late final AuthRepository _authRepository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final ResetPasswordUseCase _resetPasswordUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;
  late final GetUserProfileUseCase _getUserProfileUseCase;
  late final SaveUserProfileUseCase _saveUserProfileUseCase;
  late final UpdateVerifiedEmailUseCase _updateVerifiedEmailUseCase;

  AuthProvider() {
    _initDependencies();
  }

  void _initDependencies() {
    try {
      if (!serviceLocator.isRegistered<AuthRepository>()) {
        debugPrint('[AuthProvider]  WARNING: serviceLocator not ready!');
        return;
      }

      _authRepository = serviceLocator<AuthRepository>();
      _loginUseCase = serviceLocator<LoginUseCase>();
      _registerUseCase = serviceLocator<RegisterUseCase>();
      _logoutUseCase = serviceLocator<LogoutUseCase>();
      _resetPasswordUseCase = serviceLocator<ResetPasswordUseCase>();
      _getCurrentUserUseCase = serviceLocator<GetCurrentUserUseCase>();
      _getUserProfileUseCase = serviceLocator<GetUserProfileUseCase>();
      _saveUserProfileUseCase = serviceLocator<SaveUserProfileUseCase>();
      _updateVerifiedEmailUseCase = serviceLocator<UpdateVerifiedEmailUseCase>();
      
      debugPrint('[AuthProvider]  Dependencies initialized successfully');
    } catch (e) {
      debugPrint('[AuthProvider]  Failed to initialize dependencies: $e');
      // Don't rethrow - let the app continue
    }
  }

  // =====================================================
  // GETTERS
  // =====================================================

  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get loading => _loading;
  bool get isLoading => _loading;
  String get verifiedEmail => _verifiedEmail;
  bool get emailVerified => _emailVerified;
  bool get isAuthenticated => _user != null;

  // =====================================================
  // SAFE NOTIFY LISTENERS
  // =====================================================

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  // =====================================================
  // INITIALIZE AUTH STATE OBSERVER
  // =====================================================

  void initialize() {
    if (_initialized) {
      debugPrint('[AuthProvider] Already initialized.');
      return;
    }

    _initialized = true;

    debugPrint('[AuthProvider] Setting up auth state observer...');

    _authSubscription = _authRepository.observeAuthState().listen(
      (firebaseUser) async {
        debugPrint(
          '[AuthProvider] Auth state changed: '
          'uid=${firebaseUser?.uid}, '
          'email=${firebaseUser?.email}, '
          'displayName=${firebaseUser?.displayName}',
        );

        if (firebaseUser != null) {
          debugPrint('[AuthProvider] User logged in: ${firebaseUser.uid}');

          _user = firebaseUser;
          notifyListeners();

          try {
            debugPrint('[AuthProvider] Getting user profile...');

            final profile = await _getUserProfileUseCase.execute(
              firebaseUser.uid,
            );

            _userProfile = profile;

            if (profile != null && profile.containsKey('verifiedEmail')) {
              _verifiedEmail = profile['verifiedEmail'] ?? '';
              _emailVerified = profile['emailVerified'] ?? false;
              debugPrint(
                '[AuthProvider] Loaded verified email: $_verifiedEmail, '
                'emailVerified: $_emailVerified',
              );
            }

            debugPrint(
              '[AuthProvider] User profile loaded successfully: '
              'uid=${profile?['uid']}, '
              'username=${profile?['username']}, '
              'email=${profile?['email']}',
            );
          } catch (error) {
            debugPrint('[AuthProvider] Failed to load user profile: $error');
            _userProfile = null;
          }
        } else {
          debugPrint('[AuthProvider] No user logged in - clearing state');

          _user = null;
          _userProfile = null;
          resetVerificationState(notify: false);
        }

        _loading = false;
        notifyListeners();

        debugPrint('[AuthProvider] Loading state set to false');
      },
      onError: (error) {
        debugPrint('[AuthProvider] Auth observer error: $error');
        _loading = false;
        notifyListeners();
      },
    );
  }

  // =====================================================
  // REGISTER
  // =====================================================

  Future<dynamic> register(
    String username,
    String gmail,
    String password,
  ) async {
    debugPrint('[AuthProvider] Register started: username=$username, gmail=$gmail');

    try {
      final result = await _registerUseCase.execute(
        username: username,
        gmail: gmail,
        password: password,
      );

      debugPrint('[AuthProvider] Register successful');

      // Save user profile after registration
      if (result != null && result['user'] != null) {
        final user = result['user'] as User;
        await _saveUserProfileUseCase.execute(
          user.uid,
          username,
          gmail,
        );
        debugPrint('[AuthProvider] User profile saved successfully');
      }

      _user = null;
      _userProfile = null;
      resetVerificationState(notify: false);
      notifyListeners();

      return result;
    } catch (error) {
      debugPrint('[AuthProvider] Registration failed: $error');
      throw Exception(error.toString());
    }
  }

  // =====================================================
  // SAVE USER PROFILE
  // =====================================================

  Future<void> saveUserProfile({
    required String uid,
    required String username,
    required String email,
  }) async {
    debugPrint('[AuthProvider] Saving user profile: uid=$uid, username=$username, email=$email');
    
    try {
      await _saveUserProfileUseCase.execute(uid, username, email);
      
      // Update local profile
      if (_userProfile != null) {
        _userProfile!['username'] = username;
        _userProfile!['email'] = email;
        _userProfile!['uid'] = uid;
      } else {
        _userProfile = {
          'uid': uid,
          'username': username,
          'email': email,
        };
      }
      
      notifyListeners();
      debugPrint('[AuthProvider] User profile saved successfully');
    } catch (error) {
      debugPrint('[AuthProvider] Failed to save user profile: $error');
      rethrow;
    }
  }

  // =====================================================
  // LOGIN with Username
  // =====================================================

  Future<User?> loginWithUsername(
    String username,
    String password,
  ) async {
    debugPrint('[AuthProvider]  Login started: $username');

    try {
      final result = await _loginUseCase.execute(
        username: username,
        password: password,
      );

      debugPrint('[AuthProvider]  Login successful: uid=${result?.uid}');
      return result;
    } catch (error) {
      debugPrint('[AuthProvider]  Login failed: $error');
      throw Exception(error.toString());
    }
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout() async {
    debugPrint('[AuthProvider] Logout started');

    try {
      await _logoutUseCase.execute();

      debugPrint('[AuthProvider] Logout successful');

      _user = null;
      _userProfile = null;
      resetVerificationState(notify: false);
      notifyListeners();
    } catch (error) {
      debugPrint('[AuthProvider] Logout failed: $error');
      throw Exception(error.toString());
    }
  }

  // =====================================================
  // RESET PASSWORD
  // =====================================================

  Future<void> resetPassword(
    String gmail,
  ) async {
    debugPrint('[AuthProvider] Reset password started: $gmail');

    try {
      await _resetPasswordUseCase.execute(gmail);
      debugPrint('[AuthProvider] Reset password successful');
    } catch (error) {
      debugPrint('[AuthProvider] Reset password failed: $error');
      throw Exception(error.toString());
    }
  }

  // =====================================================
  // UPDATE VERIFIED EMAIL
  // =====================================================

  Future<void> updateVerifiedEmail(String email) async {
    debugPrint('[AuthProvider] Updating verified email: $email');

    if (email.isEmpty || email.trim().isEmpty) {
      throw Exception('Email is required.');
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      throw Exception('Please enter a valid email address.');
    }

    final currentUser = _user;
    if (currentUser == null) {
      throw Exception('No authenticated user found. Please login first.');
    }

    final previousVerifiedEmail = _verifiedEmail;
    final previousEmailVerified = _emailVerified;

    _verifiedEmail = email.trim();
    _emailVerified = true;
    notifyListeners();

    try {
      // Update verified email
      await _updateVerifiedEmailUseCase.execute(
        uid: currentUser.uid,
        email: email.trim(),
      );

      // Save updated profile
      final username = getUsername();
      await _saveUserProfileUseCase.execute(
        currentUser.uid,
        username,
        email.trim(),
      );

      if (_userProfile != null) {
        _userProfile!['verifiedEmail'] = email.trim();
        _userProfile!['emailVerified'] = true;
        _userProfile!['email'] = email.trim();
      }

      debugPrint('[AuthProvider] Verified email updated successfully: $email');

      notifyListeners();
    } catch (error) {
      debugPrint('[AuthProvider] Failed to update verified email: $error');

      _verifiedEmail = previousVerifiedEmail;
      _emailVerified = previousEmailVerified;

      if (_userProfile != null && previousVerifiedEmail.isNotEmpty) {
        _userProfile!['verifiedEmail'] = previousVerifiedEmail;
        _userProfile!['emailVerified'] = previousEmailVerified;
      }

      notifyListeners();

      rethrow;
    }
  }

  // =====================================================
  // GET CURRENT USER
  // =====================================================

  Future<User?> getCurrentUser() async {
    debugPrint('[AuthProvider] Getting current user...');

    try {
      final currentUser = await _getCurrentUserUseCase.execute();
      debugPrint('[AuthProvider] Current user: ${currentUser?.uid}');
      return currentUser;
    } catch (error) {
      debugPrint('[AuthProvider] Failed to get current user: $error');
      rethrow;
    }
  }

  // =====================================================
  // GET USERNAME
  // =====================================================

  String getUsername() {
    final username = _userProfile?['username'] ?? _user?.displayName ?? '';
    debugPrint('[AuthProvider] getUsername: $username');
    return username.toString();
  }

  // =====================================================
  // GET EMAIL
  // =====================================================

  String getEmail() {
    final email = _userProfile?['email'] ?? _user?.email ?? '';
    debugPrint('[AuthProvider] getEmail: $email');
    return email.toString();
  }

  // =====================================================
  // GET VERIFIED EMAIL
  // =====================================================

  String getVerifiedEmail() {
    debugPrint('[AuthProvider] getVerifiedEmail: $_verifiedEmail');
    return _verifiedEmail;
  }

  // =====================================================
  // REFRESH USER PROFILE
  // =====================================================

  Future<void> refreshUserProfile() async {
    if (_user == null) {
      debugPrint('[AuthProvider] Cannot refresh profile: No user logged in');
      return;
    }

    try {
      debugPrint('[AuthProvider] Refreshing user profile...');

      final profile = await _getUserProfileUseCase.execute(_user!.uid);
      _userProfile = profile;

      if (profile != null && profile.containsKey('verifiedEmail')) {
        _verifiedEmail = profile['verifiedEmail'] ?? '';
        _emailVerified = profile['emailVerified'] ?? false;
      }

      notifyListeners();
      debugPrint('[AuthProvider] User profile refreshed successfully');
    } catch (error) {
      debugPrint('[AuthProvider] Failed to refresh user profile: $error');
      rethrow;
    }
  }

  // =====================================================
  // RESET VERIFICATION STATE
  // =====================================================

  void resetVerificationState({
    bool notify = true,
  }) {
    debugPrint('[AuthProvider] Resetting verification state');

    _verifiedEmail = '';
    _emailVerified = false;

    if (notify) {
      notifyListeners();
    }
  }

  // =====================================================
  // CLEAR STATE
  // =====================================================

  void clearState() {
    debugPrint('[AuthProvider] Clearing state');

    _user = null;
    _userProfile = null;
    _loading = false;
    resetVerificationState(notify: false);
    notifyListeners();
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    debugPrint('[AuthProvider] Cleaning up auth state observer...');

    _disposed = true;
    _authSubscription?.cancel();
    _authSubscription = null;
    _initialized = false;

    super.dispose();
  }
}