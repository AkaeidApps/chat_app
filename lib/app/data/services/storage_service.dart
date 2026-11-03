import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  Future<String> uploadProfileImage(String uid, File imageFile) async {
    final ref = _storage.ref().child('users/$uid/profile.jpg');
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<String> uploadChatMedia({
    required String chatId,
    required File file,
    required String fileType, // image, video, audio, document
    required String extension,
  }) async {
    final fileName = '${_uuid.v4()}.$extension';
    final ref = _storage.ref().child('chats/$chatId/$fileType/$fileName');
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }

  Future<String> uploadStatusMedia({
    required String uid,
    required File file,
    required String mediaType, // image or video
  }) async {
    final fileName = _uuid.v4();
    final ref = _storage
        .ref()
        .child('status')
        .child(uid)
        .child(mediaType)
        .child(fileName);
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }
}
