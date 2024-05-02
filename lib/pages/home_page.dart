import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/components/drawer.dart';
import 'package:todo_list/components/notes_list_tile.dart';
import 'package:todo_list/pages/notes_page.dart';
import 'package:todo_list/services/note_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController note = TextEditingController();

  final NotesService _notesService = NotesService();

  final AuthService _authService = AuthService();

  void openNoteBox(context, String? docId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotesPage(noteId: docId)));
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
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: IconButton(
              icon: Icon(Icons.menu_rounded, color: Theme.of(context).colorScheme.primary,),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        toolbarHeight: 30,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "All Notes",
                  style: GoogleFonts.playfairDisplay(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        letterSpacing: 2.0,
                      )
                  ),
                ),
              ],
            ),
          ),
          Flexible(
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
        ],
      ),
    );
  }
}
