import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/services/note_service.dart';
import '../auth/auth_service.dart';
import '../components/locked_note_list_tile.dart';
import 'notes_page.dart';

class LockedNotePage extends StatefulWidget {
  const LockedNotePage({super.key});

  @override
  State<LockedNotePage> createState() => _LockedNotePageState();
}

class _LockedNotePageState extends State<LockedNotePage> {

  final NotesService _notesService = NotesService();
  final AuthService _authService = AuthService();

  void openNoteBox(context, String? docId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotesPage(noteId: docId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.primary,),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        toolbarHeight: 30,
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //Title text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Locked Notes",
                    style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          letterSpacing: 1.5,
                        )
                    ),
                  ),
                ],
              ),
            ),

            //locked notes stream
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _notesService.getLockedNotesStream(_authService.getCurrentUser()!.email.toString()),
                builder: (context, snapshot) {
                  //if we have data, get all docs
                  if(snapshot.hasData) {
                    List notesList = snapshot.data!.docs;

                    //if no notes to show
                    if(notesList.isEmpty) {
                      return Center(
                        child: Text(
                          "No Locked Notes",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).colorScheme.primary,
                              )
                          ),
                        ),
                      );
                    }

                    //display the list
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notesList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = notesList[index];
                        String docId = document.id;

                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        Note note = Note.fromMap(data);
                        return LockedNote(
                          title: note.title,
                          content: note.content,
                          docId: docId,
                          openNoteBox: openNoteBox,
                          context: context,
                        );
                      },
                    );
                  }
                  else {
                    return const Text("No notes");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
