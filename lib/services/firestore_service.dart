import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  void addGame(String name, String imageUrl, List<String> platforms, bool status, DateTime fecha) {
    FirebaseFirestore.instance.collection('games').add({
      'name': name,
      'image': imageUrl,
      'platforms': platforms,
      'status': status,
      'fecha': fecha,
    });
  }
  Stream<QuerySnapshot> getGames() {
    return FirebaseFirestore.instance.collection('games').snapshots();
  }
  void updateGame(String gameId, bool status) {
    FirebaseFirestore.instance.collection('games').doc(gameId).update({
      'status': status,
    });
  }
  void deleteGame(String gameId) {
    FirebaseFirestore.instance.collection('games').doc(gameId).delete();
  }
}