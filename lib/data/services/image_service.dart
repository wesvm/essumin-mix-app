import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadUserProfileImage(String userId, File? imageFile) async {
    if (imageFile == null) return null;

    try {
      final String extension = imageFile.path.split('.').last;
      final String fileName = '$userId.$extension';
      final ref = _storage.ref().child('profile_images').child(fileName);

      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      return null;
    }
  }
}
