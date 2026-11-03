import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'user_repository.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();
  final StorageService _storageService = StorageService();

  User? get currentUser => _authService.currentUser;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<UserModel?> loginWithEmail(String email, String password) async {
    UserCredential cred = await _authService.loginWithEmail(email, password);
    if (cred.user != null) {
      UserModel? user = await _userRepository.getUserById(cred.user!.uid);
      if (user != null) {
        await _userRepository.updateOnlineStatus(user.uid, true);
      }
      return user;
    }
    return null;
  }

  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
    String about = 'Hey there! I am using WhatsApp.',
  }) async {
    UserCredential cred = await _authService.registerWithEmail(email, password);
    UserModel user = UserModel(
      uid: cred.user!.uid,
      email: email,
      name: name,
      about: about,
      isOnline: true,
      createdAt: DateTime.now(),
    );
    await _userRepository.createUser(user);
    return user;
  }

  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String codeId, int? resendToken) codeSent,
    required Function(String codeId) codeAutoRetrievalTimeout,
  }) async {
    await _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserModel?> signInWithPhone(String verificationId, String smsCode) async {
    UserCredential cred = await _authService.signInWithPhoneCredential(verificationId, smsCode);
    if (cred.user != null) {
      UserModel? existing = await _userRepository.getUserById(cred.user!.uid);
      if (existing == null) {
        UserModel newUser = UserModel(
          uid: cred.user!.uid,
          phoneNumber: cred.user!.phoneNumber ?? '',
          name: 'WhatsApp User',
          isOnline: true,
          createdAt: DateTime.now(),
        );
        await _userRepository.createUser(newUser);
        return newUser;
      } else {
        await _userRepository.updateOnlineStatus(existing.uid, true);
        return existing;
      }
    }
    return null;
  }

  Future<String> uploadProfilePicture(String uid, File imageFile) async {
    return await _storageService.uploadProfileImage(uid, imageFile);
  }

  Future<void> signOut() async {
    if (currentUser != null) {
      await _userRepository.updateOnlineStatus(currentUser!.uid, false);
    }
    await _authService.signOut();
  }
}
