import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/services/note_service.dart';

import '../pages/notes_page.dart';

class NoteListTile extends StatelessWidget {

  final String title;
  final String content;
  final String docId;
  final void Function(BuildContext, String) openNoteBox;
  final BuildContext context;
  NoteListTile({super.key, required this.title, required this.content, required this.docId, required this.openNoteBox, required this.context});

  final NotesService _notesService = NotesService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotesPage(noteId: docId)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2.0,),
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.background
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary
                        )
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        content,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.primary,
                            )
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //update
                    IconButton(
                      icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary,),
                      onPressed: () => openNoteBox(context, docId),
                    ),
      
                    //delete
                    IconButton(
                      icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.primary,),
                      onPressed: () => _notesService.deleteNote(docId, _authService.getCurrentUser()!.email.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
