import 'package:cloud_firestore/cloud_firestore.dart';

class NotesService {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //Create an new note
  Future<void> addNote(String title, String content, String userId) async {
    try {
      await _firestore.collection("Users").doc(userId).collection("notes").add(
        {
          'title': title,
          'content': content,
          'timeStamp': Timestamp.now()
        }
      );
    } catch(e) {
      throw Exception(e);
    }
  }

  //Read from database by building a stream
  Stream<QuerySnapshot> getNotesStream (String userId) {
    final notesStream = _firestore.collection('Users').doc(userId).collection('notes').orderBy('timeStamp', descending: true).snapshots();
    return notesStream;
  }

  //Update an existing note
  Future<void> updateNote(String title, String noteId, String newContent, String userId) async {
    return _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).update(
        {
          'title': title,
          'content': newContent,
          'timeStamp': Timestamp.now()
        }
    );
  }

  //delete a note
  Future<void> deleteNote(String noteId, String userId) async {
    return _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).delete();
  }

}