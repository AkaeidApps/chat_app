import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final aboutController = TextEditingController(text: 'Hey there! I am using WhatsApp.');
  final otpController = TextEditingController();

  var isLoading = false.obs;
  var verificationId = ''.obs;
  Rx<File?> profileImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  void sendPhoneOtp() async {
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a valid phone number');
      return;
    }
    isLoading.value = true;
    await _authRepository.verifyPhone(
      phoneNumber: phoneController.text.trim(),
      verificationCompleted: (cred) async {
        isLoading.value = false;
      },
      verificationFailed: (e) {
        isLoading.value = false;
        Get.snackbar('Auth Error', e.message ?? 'Verification failed');
      },
      codeSent: (id, resendToken) {
        isLoading.value = false;
        verificationId.value = id;
        Get.toNamed(AppRoutes.OTP_VERIFICATION);
      },
      codeAutoRetrievalTimeout: (id) {
        verificationId.value = id;
      },
    );
  }

  void verifyOtp() async {
    if (otpController.text.trim().length < 6) {
      Get.snackbar('Error', 'Please enter full 6-digit OTP');
      return;
    }
    isLoading.value = true;
    try {
      final user = await _authRepository.signInWithPhone(
        verificationId.value,
        otpController.text.trim(),
      );
      isLoading.value = false;
      if (user != null) {
        Get.offAllNamed(AppRoutes.CREATE_PROFILE);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Invalid OTP Code');
    }
  }

  void loginWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }
    isLoading.value = true;
    try {
      final user = await _authRepository.loginWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      isLoading.value = false;
      if (user != null) {
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.toNamed(AppRoutes.CREATE_PROFILE);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  void registerWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty || nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill out all fields');
      return;
    }
    isLoading.value = true;
    try {
      await _authRepository.registerWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        about: aboutController.text.trim(),
      );
      isLoading.value = false;
      Get.toNamed(AppRoutes.PROFILE_PHOTO_UPLOAD);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Registration Failed', e.toString());
    }
  }

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your registered email');
      return;
    }
    isLoading.value = true;
    try {
      await _authRepository.sendPasswordReset(emailController.text.trim());
      isLoading.value = false;
      Get.snackbar('Success', 'Password reset email sent');
      Get.back();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  void pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  void saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name');
      return;
    }
    isLoading.value = true;
    try {
      String uid = _authRepository.currentUser!.uid;
      String photoUrl = '';
      if (profileImage.value != null) {
        photoUrl = await _authRepository.uploadProfilePicture(uid, profileImage.value!);
      }
      await _userRepository.updateProfile(
        uid: uid,
        name: nameController.text.trim(),
        about: aboutController.text.trim(),
        photoUrl: photoUrl.isNotEmpty ? photoUrl : null,
      );
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
