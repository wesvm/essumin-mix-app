import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essumin_mix/data/models/message.dart';

class MessageService {
  final messagesCollection = FirebaseFirestore.instance.collection('messages');
  Future<void> saveMessage(String content, String userId) {
    return messagesCollection.add({
      'content': content,
      'userId': userId,
      'timesTamp': Timestamp.now(),
    });
  }

  Future<List<Message>> getUserMessages(String userId) async {
    final messageDoc =
        await messagesCollection.where('userId', isEqualTo: userId).get();
    return messageDoc.docs
        .map((doc) => Message(
              id: doc.id,
              content: doc['content'],
              userId: doc['userId'],
              timestamp: doc['timestamp'],
            ))
        .toList();
  }
}
