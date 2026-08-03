import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/failure.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // =====================================================
  // ERROR MAPPING HELPERS
  // =====================================================

  Failure _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return const NetworkFailure(
          message: 'No internet connection. Please check your network and try again.',
        );

      case 'user-not-found':
        return const AuthFailure(
          message: 'No account found with that username or email.',
        );

      case 'wrong-password':
      case 'invalid-credential':
        return const AuthFailure(
          message: 'Incorrect password. Please try again.',
        );

      case 'user-disabled':
        return const AuthFailure(
          message: 'This account has been disabled. Please contact support.',
        );

      case 'too-many-requests':
        return const AuthFailure(
          message: 'Too many attempts. Please wait a moment and try again.',
        );

      case 'email-already-in-use':
        return const ValidationFailure(
          message: 'This email is already registered. Please sign in instead.',
        );

      case 'weak-password':
        return const ValidationFailure(
          message: 'Password is too weak. Please choose a stronger password.',
        );

      case 'invalid-email':
        return const ValidationFailure(
          message: 'Please enter a valid email address.',
        );

      default:
        return ServerFailure(
          message: e.message ?? 'Something went wrong. Please try again.',
        );
    }
  }

  Failure _mapFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'unavailable':
        return const NetworkFailure(
          message: 'No internet connection. Please check your network and try again.',
        );

      case 'permission-denied':
        return const AuthFailure(
          message: 'You do not have permission to perform this action.',
        );

      default:
        return ServerFailure(
          message: e.message ?? 'Something went wrong. Please try again.',
        );
    }
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } on FirebaseException catch (e) {
      throw _mapFirestoreException(e);
    } on SocketException {
      throw const NetworkFailure(
        message: 'No internet connection. Please check your network and try again.',
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  // =====================================================
  // REGISTER
  // =====================================================

  @override
  Future<Map<String, dynamic>> register(
    String username,
    String gmail,
    String password,
  ) {
    return _guard(() async {
      final cleanUsername = username.trim();
      final cleanGmail = gmail.trim().toLowerCase();
      final usernameLower = cleanUsername.toLowerCase();

      // Check if username is already taken
      final usernameDoc = await _firestore
          .collection('usernames')
          .doc(usernameLower)
          .get();

      if (usernameDoc.exists) {
        throw const ValidationFailure(
          message: 'Username is already taken. Please choose another.',
        );
      }

      // Create Firebase Authentication account
      final result = await _auth.createUserWithEmailAndPassword(
        email: cleanGmail,
        password: password,
      );

      final firebaseUser = result.user;

      if (firebaseUser == null) {
        throw const ServerFailure(
          message: 'Failed to create user account.',
        );
      }

      // Update Firebase display name
      await firebaseUser.updateDisplayName(cleanUsername);

      // Save username reference
      await _firestore
          .collection('usernames')
          .doc(usernameLower)
          .set({
        'uid': firebaseUser.uid,
        'email': cleanGmail,
      });

      // Save user profile
      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set({
        'uid': firebaseUser.uid,
        'username': cleanUsername,
        'email': cleanGmail,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Sign out after registration
      await _auth.signOut();

      return {
        'success': true,
        'message': 'You are registered! Please log in.',
        'user': firebaseUser,
      };
    });
  }

  // =====================================================
  // LOGIN
  // =====================================================

  @override
  Future<User?> login(
    String username,
    String password,
  ) {
    return _guard(() async {
      final usernameLower = username.trim().toLowerCase();

      // Find username document
      final usernameDoc = await _firestore
          .collection('usernames')
          .doc(usernameLower)
          .get();

      if (!usernameDoc.exists) {
        throw const AuthFailure(
          message: 'No account found with that username.',
        );
      }

      final data = usernameDoc.data();

      final email = data?['email'] as String?;

      if (email == null || email.isEmpty) {
        throw const ServerFailure(
          message: 'No email associated with this username.',
        );
      }

      // Login using the email associated with the username
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    });
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  @override
  Future<void> logout() {
    return _guard(() async {
      await _auth.signOut();
    });
  }

  // =====================================================
  // RESET PASSWORD
  // =====================================================

  @override
  Future<void> resetPassword(
    String gmail,
  ) {
    return _guard(() async {
      final cleanGmail = gmail.trim().toLowerCase();
      await _auth.sendPasswordResetEmail(
        email: cleanGmail,
      );
    });
  }

  // =====================================================
  // GET USER PROFILE
  // =====================================================

  @override
  Future<Map<String, dynamic>?> getUserProfile(
    String uid,
  ) {
    return _guard(() async {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!snapshot.exists) {
        return null;
      }

      return snapshot.data();
    });
  }

  // =====================================================
  // SAVE USER PROFILE
  // =====================================================

  @override
  Future<Map<String, dynamic>> saveUserProfile(
    String uid,
    String username,
    String email,
  ) {
    return _guard(() async {
      final profile = <String, dynamic>{
        'uid': uid,
        'username': username,
        'email': email,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firestore
          .collection('users')
          .doc(uid)
          .set(
            profile,
            SetOptions(merge: true),
          );

      return profile;
    });
  }

  // =====================================================
  // UPDATE VERIFIED EMAIL
  // =====================================================

  @override
  Future<void> updateVerifiedEmail(
    String uid,
    String email,
  ) {
    return _guard(() async {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({
        'verifiedEmail': email.trim().toLowerCase(),
        'emailVerified': true,
      });
    });
  }

  // =====================================================
  // OBSERVE AUTH STATE
  // =====================================================

  @override
  Stream<User?> observeAuthState() {
    return _auth.authStateChanges();
  }

  // =====================================================
  // GET CURRENT USER
  // =====================================================

  @override
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }
}