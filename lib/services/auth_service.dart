import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<String?> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      return 'Ошибка регистрации';
    }
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      return 'Ошибка входа';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _mapError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Неверный формат email';
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Email уже зарегистрирован';
      case 'weak-password':
        return 'Пароль слишком простой (минимум 6 символов)';
      case 'network-request-failed':
        return 'Нет интернета';
      default:
        return 'Ошибка: $code';
    }
  }
}
