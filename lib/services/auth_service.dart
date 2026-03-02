import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  static final AuthService _instance = AuthService._internal();
  AuthService._internal();
  static AuthService get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      try {
        await credential.user?.updateDisplayName(name.trim());
      } catch (_) {}

      return null;

    } on FirebaseAuthException catch (e) {
      return _translateError(e.code);
    } catch (_) {
      return null; 
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _translateError(e.code);
    } catch (_) {
      return null; 
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _translateError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-credential':
        return 'Incorrect email or password';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return 'Something went wrong. Try again';
    }
  }
}