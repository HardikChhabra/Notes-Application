import 'package:flutter/material.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/components/textfield.dart';
import 'package:todo_list/services/note_service.dart';

class NotesPage extends StatelessWidget {

  final String noteId;
  final NotesService _notesService = NotesService();
  final AuthService _authService = AuthService();

  NotesPage({super.key, required this.noteId});

  final TextEditingController _content = TextEditingController();
  final TextEditingController _title = TextEditingController();

  void onPop (bool? notRequired) {

    //if value changed
    if(_content.text.isNotEmpty) {
      _notesService.updateNote(_title.text, noteId, _content.text, _authService.getCurrentUser()!.email.toString());
    }
    //if value removed
    else{
      _notesService.deleteNote(noteId, _authService.getCurrentUser()!.email.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _notesService.getNoteById(_authService.getCurrentUser()!.email.toString(), noteId),
      builder: (context, snapshot) {
        //if we have data, get all docs
        if(snapshot.hasData) {

          Note note = Note.fromMap(snapshot.data!.data()!);
          _content.text = note.content;
          _title.text = note.title;

          //display the note
          return PopScope(
            onPopInvoked: onPop,
            child: Scaffold(
              body: Column(
                children: [
                  //title
                  MyTextField(hint: 'Title', obscureText: false, controller: _title),
                  MyTextField(hint: 'Content', obscureText: false, controller: _content),
                ],
              ),
            ),
          );

        }
        else {
          return const Text("No notes");
        }
      },
    );
  }
}

class Note {
  String title;
  String content;

  Note({required this.title, required this.content});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
    );
  }
}