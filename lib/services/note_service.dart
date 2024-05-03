import 'package:cloud_firestore/cloud_firestore.dart';

class NotesService {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //Create an new note
  Future<void> addNote(String title, String content, String userId, bool isLocked, bool isPinned) async {
    try {
      await _firestore.collection("Users").doc(userId).collection("notes").add(
        {
          'title': title,
          'content': content,
          'timeStamp': Timestamp.now(),
          'isLocked': isLocked,
          'isPinned': isPinned,
        }
      );
    } catch(e) {
      throw Exception(e);
    }
  }

  //Read from database by building a stream
  Stream<QuerySnapshot> getNotesStream (String userId) {
    final notesStream = _firestore.collection('Users').doc(userId).collection('notes').where('isPinned', isEqualTo: false,).orderBy('timeStamp', descending: true).snapshots();
    return notesStream;
  }

  //Update an existing note
  Future<void> updateNote(String title, String noteId, String newContent, String userId, bool isLocked, bool isPinned) async {
    return _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).update(
        {
          'title': title,
          'content': newContent,
          'timeStamp': Timestamp.now(),
          'isLocked': isLocked,
          'isPinned': isPinned,
        }
    );
  }

  //delete a note
  Future<void> deleteNote(String noteId, String userId) async {
    return _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).delete();
  }

  //get a single note stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> getNoteById (String userId, noteId) {
    final noteStream = _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).snapshots();
    return noteStream;
  }

  //get note content by id
  Future<Map<String, dynamic>> getNoteContentById (String userId, noteId) async {
    final Map<String, dynamic> response;
    final DocumentSnapshot noteStream = await _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).get();
    if(noteStream.exists) {
      response = {
        'title': noteStream.get('title'),
        'content' : noteStream.get('content'),
        'isLocked': noteStream.get('isLocked'),
        'isPinned': noteStream.get('isPinned'),
      };
      return response;
    }
    else {
      response = {
        'title': "Title",
        'content' : "Content",
      };
      return response;
    }
  }

  //update pinned state
  Future<void> togglePinNote(String userId, noteId,bool isPinned) async {
    return await _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).update(
        {
          'isPinned': isPinned,
        }
    );
  }

  //get notes stream of pinned notes
  Stream<QuerySnapshot> getPinnedNotesStream (String userId) {
    final notesStream = _firestore.collection('Users').doc(userId).collection('notes').where('isPinned', isEqualTo: true).where('isLocked', isEqualTo: false,).snapshots();
    return notesStream;
  }

  //get notes stream of non-pinned notes
  Stream<QuerySnapshot> getNonPinnedNotesStream (String userId) {
    final notesStream = _firestore.collection('Users').doc(userId).collection('notes').where('isPinned', isEqualTo: false,).where('isLocked', isEqualTo: false,).snapshots();
    return notesStream;
  }
  
  //get notes stream of locked notes
  Stream<QuerySnapshot> getLockedNotesStream (String userId) {
    final notesStream = _firestore.collection('Users').doc(userId).collection('notes').where('isLocked', isEqualTo: true).snapshots();
    return notesStream;
  }

  //lock a note
  Future<void> lockNote(String userId, noteId) async {
    return await _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).update(
        {
          'isLocked': true,
        }
    );
  }

  Future<void> unlockNote(String userId, noteId) async {
    return await _firestore.collection('Users').doc(userId).collection('notes').doc(noteId).update(
        {
          'isLocked': false,
        }
    );
  }

}