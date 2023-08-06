import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:essumin_mix/data/models/user.dart';
import 'package:essumin_mix/data/services/image_service.dart';

class UserService {
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUser(String username, File? imageFile) async {
    try {
      String? profileImageUrl =
          await ImageService().uploadUserProfileImage(username, imageFile);

      Map<String, dynamic> userData = {
        'username': username,
      };

      if (profileImageUrl != null) {
        userData['imageUrl'] = profileImageUrl;
      }

      await usersCollection.add(userData);
    } catch (e) {
      throw Exception('Error al guardar el usuario: $e');
    }
  }

  Future<User> getUserById(String id) async {
    final userDoc = await usersCollection.doc(id).get();

    if (userDoc.exists) {
      return User(
        id: userDoc.id,
        username: userDoc['username'],
        imageUrl: userDoc['imageUrl'],
      );
    } else {
      throw Exception('El usuario no existe');
    }
  }

  Future<List<User>> getUsers() async {
    final userDoc = await usersCollection.get();
    return userDoc.docs
        .map((doc) => User(
              id: doc.id,
              username: doc['username'],
            ))
        .toList();
  }
}
