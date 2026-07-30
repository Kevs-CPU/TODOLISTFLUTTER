import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  // =====================================================
  // REGISTER
  // =====================================================

  Future<dynamic> register(
    String username,
    String gmail,
    String password,
  );

  // =====================================================
  // LOGIN
  // =====================================================

  Future<User?> login(
    String username,
    String password,
  );

  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout();

  // =====================================================
  // RESET PASSWORD
  // =====================================================

  Future<void> resetPassword(
    String gmail,
  );

  // =====================================================
  // GET USER PROFILE
  // =====================================================

  Future<Map<String, dynamic>?> getUserProfile(
    String uid,
  );

  // =====================================================
  // SAVE USER PROFILE
  // =====================================================

  Future<Map<String, dynamic>> saveUserProfile(
    String uid,
    String username,
    String email,
  );

  // =====================================================
  // UPDATE VERIFIED EMAIL
  // =====================================================

  Future<void> updateVerifiedEmail(
    String uid,
    String email,
  );

  // =====================================================
  // OBSERVE AUTH STATE
  // =====================================================

  Stream<User?> observeAuthState();

  // =====================================================
  // GET CURRENT USER
  // =====================================================

  Future<User?> getCurrentUser();
}