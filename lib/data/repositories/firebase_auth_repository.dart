import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // =====================================================
  // REGISTER
  // =====================================================

  @override
  Future<dynamic> register(
    String username,
    String gmail,
    String password,
  ) async {
    final cleanUsername = username.trim();
    final cleanGmail = gmail.trim().toLowerCase();
    final usernameLower = cleanUsername.toLowerCase();

    // Check if username is already taken
    final usernameDoc = await _firestore
        .collection('usernames')
        .doc(usernameLower)
        .get();

    if (usernameDoc.exists) {
      throw Exception(
        'Username is already taken. Please choose another.',
      );
    }

    // Create Firebase Authentication account
    final result = await _auth.createUserWithEmailAndPassword(
      email: cleanGmail,
      password: password,
    );

    final firebaseUser = result.user;

    if (firebaseUser == null) {
      throw Exception(
        'Failed to create user account.',
      );
    }

    // Update Firebase display name
    await firebaseUser.updateDisplayName(
      cleanUsername,
    );

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
  }

  // =====================================================
  // LOGIN
  // =====================================================

  @override
  Future<User?> login(
    String username,
    String password,
  ) async {
    final usernameLower = username.trim().toLowerCase();

    // Find username document
    final usernameDoc = await _firestore
        .collection('usernames')
        .doc(usernameLower)
        .get();

    if (!usernameDoc.exists) {
      throw Exception(
        'No account found with that username.',
      );
    }

    final data = usernameDoc.data();

    final email = data?['email'] as String?;

    if (email == null || email.isEmpty) {
      throw Exception(
        'No email associated with this username.',
      );
    }

    // Login using the email associated with the username
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  // =====================================================
  // LOGOUT
  // =====================================================

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  // =====================================================
  // RESET PASSWORD
  // =====================================================

  @override
  Future<void> resetPassword(
    String gmail,
  ) async {
    final cleanGmail = gmail.trim().toLowerCase();

    await _auth.sendPasswordResetEmail(
      email: cleanGmail,
    );
  }

  // =====================================================
  // GET USER PROFILE
  // =====================================================

  @override
  Future<Map<String, dynamic>?> getUserProfile(
    String uid,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  // =====================================================
  // SAVE USER PROFILE
  // =====================================================

  @override
  Future<Map<String, dynamic>> saveUserProfile(
    String uid,
    String username,
    String email,
  ) async {
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
  }

  // =====================================================
  // UPDATE VERIFIED EMAIL
  // =====================================================

  @override
  Future<void> updateVerifiedEmail(
    String uid,
    String email,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({
      'verifiedEmail': email.trim().toLowerCase(),
      'emailVerified': true,
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