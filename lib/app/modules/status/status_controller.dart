import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/status_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';

class StatusController extends GetxController {
  final StatusRepository _statusRepository = StatusRepository();
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();

  final textStatusController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  var backgroundColorHex = '0xFF075E54'.obs;
  var isLoading = false.obs;
  Rx<File?> selectedMedia = Rx<File?>(null);

  final List<String> bgColors = [
    '0xFF075E54',
    '0xFF128C7E',
    '0xFF25D366',
    '0xFFE91E63',
    '0xFF9C27B0',
    '0xFF3F51B5',
    '0xFF009688',
    '0xFFFF9800',
  ];

  void changeBgColor() {
    int index = bgColors.indexOf(backgroundColorHex.value);
    int next = (index + 1) % bgColors.length;
    backgroundColorHex.value = bgColors[next];
  }

  void postTextStatus() async {
    final text = textStatusController.text.trim();
    if (text.isEmpty) return;

    isLoading.value = true;
    try {
      final uid = _authRepository.currentUser!.uid;
      final user = await _userRepository.getUserById(uid);

      await _statusRepository.addStatus(
        uid: uid,
        userName: user?.name ?? 'User',
        userPic: user?.photoUrl ?? '',
        type: 'text',
        content: text,
        backgroundColorHex: backgroundColorHex.value,
      );

      isLoading.value = false;
      Get.back();
      Get.snackbar('Status Posted', 'Your status update has been posted.');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  void pickMedia(ImageSource source, {bool isVideo = false}) async {
    final XFile? file = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source, imageQuality: 75);

    if (file != null) {
      selectedMedia.value = File(file.path);
    }
  }

  void postMediaStatus({required String type}) async {
    if (selectedMedia.value == null) return;

    isLoading.value = true;
    try {
      final uid = _authRepository.currentUser!.uid;
      final user = await _userRepository.getUserById(uid);

      await _statusRepository.addStatus(
        uid: uid,
        userName: user?.name ?? 'User',
        userPic: user?.photoUrl ?? '',
        type: type,
        content: '',
        caption: textStatusController.text.trim(),
        mediaFile: selectedMedia.value,
      );

      isLoading.value = false;
      Get.back();
      Get.snackbar('Status Posted', 'Your media status update has been posted.');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  void markViewed(String ownerUid, String statusItemId) {
    final uid = _authRepository.currentUser?.uid;
    if (uid != null) {
      _statusRepository.markStatusViewed(ownerUid, statusItemId, uid);
    }
  }
}
