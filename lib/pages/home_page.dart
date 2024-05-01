import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/components/drawer.dart';
import 'package:todo_list/components/notes_list_tile.dart';
import 'package:todo_list/components/textfield.dart';
import 'package:todo_list/pages/notes_page.dart';
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
              _notesService.addNote("Title", note.text, _authService.getCurrentUser()!.email.toString());
            }

            //updating an existing note
            else{
              _notesService.updateNote('Title', docId, note.text, _authService.getCurrentUser()!.email.toString());
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
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        title: Text(
          "Notes",
          style: GoogleFonts.playfairDisplay(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                letterSpacing: 3.0,
              )
          ),
        ),
        toolbarHeight: 80,
      ),
      drawer: HomeDrawer(
        onTap: logout,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(context, null),
        child: const Text(
          "+",
          style: TextStyle(
            fontSize: 30
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: _notesService.getNotesStream(_authService.getCurrentUser()!.email.toString()),
            builder: (context, snapshot) {
              //if we have data, get all docs
              if(snapshot.hasData) {
                List notesList = snapshot.data!.docs;

                if(notesList.isEmpty) {
                  return Center(
                    child: Text(
                      "No notes to Show\nCreate new note",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.primary,
                          )
                      ),
                    ),
                  );
                }

                //display the list
                return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = notesList[index];
                    String docId = document.id;

                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    Note note = Note.fromMap(data);

                    return NoteListTile(title: note.title, content: note.content, docId: docId, openNoteBox: openNoteBox, context: context);
                  },
                );
              }
              else {
                return const Text("No notes");
              }
            },
          ),
        ),
      ),
    );
  }
}
