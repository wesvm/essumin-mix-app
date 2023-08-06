import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:essumin_mix/data/services/message_service.dart';
import 'package:essumin_mix/data/services/user_service.dart';
import 'package:flutter/material.dart';

import 'package:essumin_mix/data/models/message.dart';
import 'package:essumin_mix/data/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({Key? key}) : super(key: key);

  @override
  AdvertisementScreenState createState() => AdvertisementScreenState();
}

class AdvertisementScreenState extends State<AdvertisementScreen> {
  late Future<User> _userFuture;
  late Future<List<Message>> _messagesFuture;

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _userFuture = UserService().getUserById('vJmovNki00GOzqcghJqj');
    _messagesFuture = MessageService().getUserMessages('vJmovNki00GOzqcghJqj');
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveUserAndImage(String username, File? imageFile) async {
    await UserService().saveUser(username, imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Usuario'),
      ),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            User user = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: user.imageUrl!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 50,
                    backgroundImage: imageProvider,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Nombre de Usuario: ${user.username}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Message>>(
                    future: _messagesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Message> messages = snapshot.data!;
                        return ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final formattedTime = DateFormat('d MMM y HH:mm')
                                .format(message.timestamp.toDate());

                            return ListTile(
                              title: Text(message.content),
                              subtitle: Text(formattedTime),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: const Text('Seleccionar Imagen'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveUserAndImage('test_upload', _imageFile);
                  },
                  child: const Text('Guardar Usuario y Imagen'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
