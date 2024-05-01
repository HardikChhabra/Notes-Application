import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/components/drawer.dart';
import 'package:todo_list/components/textfield.dart';
import 'package:todo_list/services/note_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController note = TextEditingController();
  final NotesService _notesService = NotesService();
  final AuthService _authService = AuthService();

  void openNoteBox(context, String? docId) {
    showDialog(context: context, builder: (context) => AlertDialog(
      content: MyTextField(
        hint: 'Type something...',
        obscureText: false,
        controller: note,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            //adding a new note
            if(docId == null) {
              _notesService.addNote("Nothing", note.text, _authService.getCurrentUser()!.email.toString());
            }

            //updating an existing note
            else{
              _notesService.updateNote('Nothing', docId, note.text, _authService.getCurrentUser()!.email.toString());
            }
            note.clear();
            Navigator.pop(context);
          },
          child: const Text("Add"),
        )
      ],
    ));
  }

  void logout() {
    AuthService authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("H O M E"),
      ),
      drawer: HomeDrawer(
        onTap: logout,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(context, null),
        child: const Text('+'),
      ),
      body: StreamBuilder(
        stream: _notesService.getNotesStream(_authService.getCurrentUser()!.email.toString()),
        builder: (context, snapshot) {
          //if we have data, get all docs
          if(snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            //display the list
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docId = document.id;

                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String noteText = data['content'];

                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //update
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => openNoteBox(context, docId),
                      ),

                      //delete
                      IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () => _notesService.deleteNote(docId, _authService.getCurrentUser()!.email.toString()),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          else {
            return const Text("No notes");
          }
        },
      ),
    );
  }
}
