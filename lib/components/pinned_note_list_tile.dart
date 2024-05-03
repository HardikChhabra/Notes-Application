import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/services/note_service.dart';

import '../pages/notes_page.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class PinnedNote extends StatelessWidget {

  final String title;
  final String content;
  final String docId;
  final void Function(BuildContext, String) openNoteBox;
  final BuildContext context;
  PinnedNote({super.key, required this.title, required this.content, required this.docId, required this.openNoteBox, required this.context});

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
          height: 150,
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

                //title and content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        title,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary
                            )
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 150,
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

                //menu icon and pinned icon
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Typicons.pin,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        Note note = Note.fromMap(await _notesService.getNoteContentById(_authService.getCurrentUser()!.email.toString(), docId));
                        _notesService.togglePinNote(_authService.getCurrentUser()!.email.toString(), docId, !(note.isPinned));
                      },
                    ),
                    PopupMenuButton<dynamic>(
                      icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).colorScheme.primary,),
                      color: Theme.of(context).colorScheme.background,
                      elevation: 16,
                      itemBuilder: (BuildContext context) {
                        return [
                          //pin button item
                          PopupMenuItem(
                            value: 'pin',
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Toggle Pin",
                                    style: GoogleFonts.playfairDisplay(
                                        textStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 20,
                                            letterSpacing: 2.0,
                                            fontWeight: FontWeight.w800
                                        )
                                    ),
                                  ),
                                  Icon(Icons.vertical_align_top, color: Theme.of(context).colorScheme.primary, size: 20,)
                                ],
                              ),
                            ),
                          ),

                          //lock button item
                          PopupMenuItem(
                            value: 'lock',
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Lock",
                                    style: GoogleFonts.playfairDisplay(
                                        textStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 20,
                                            letterSpacing: 2.0,
                                            fontWeight: FontWeight.w800
                                        )
                                    ),
                                  ),
                                  Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.primary, size: 20,)
                                ],
                              ),
                            ),
                          ),

                          //update item
                          PopupMenuItem(
                            value: 'update',
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Edit",
                                    style: GoogleFonts.playfairDisplay(
                                        textStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 20,
                                            letterSpacing: 2.0,
                                            fontWeight: FontWeight.w800
                                        )
                                    ),
                                  ),
                                  Icon(Icons.edit, color: Theme.of(context).colorScheme.primary, size: 20,)
                                ],
                              ),
                            ),
                          ),

                          //delete item
                          PopupMenuItem(
                            value: 'delete',
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delete",
                                    style: GoogleFonts.playfairDisplay(
                                        textStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 20,
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.w800,
                                        )
                                    ),
                                  ),
                                  Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.primary, size: 20,)
                                ],
                              ),
                            ),
                          ),

                          //share item
                          PopupMenuItem(
                            value: 'share',
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Share",
                                    style: GoogleFonts.playfairDisplay(
                                        textStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 20,
                                          letterSpacing: 2.0,
                                          fontWeight: FontWeight.w800,
                                        )
                                    ),
                                  ),
                                  Icon(Icons.share, color: Theme.of(context).colorScheme.primary, size: 20,)
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      onSelected: (dynamic value) async {
                        switch (value) {
                          case 'delete':
                          //handle delete option
                            _notesService.deleteNote(docId, _authService.getCurrentUser()!.email.toString());
                            break;

                          case 'update':
                          //handle update option
                            openNoteBox(context, docId);
                            break;

                          case 'share':
                          //handle share option
                            Note note = Note.fromMap(await _notesService.getNoteContentById(_authService.getCurrentUser()!.email.toString(), docId));
                            Share.share('${note.title}\n${note.content}');
                            break;

                          case 'pin':
                          //handle pin option
                            Note note = Note.fromMap(await _notesService.getNoteContentById(_authService.getCurrentUser()!.email.toString(), docId));
                            _notesService.togglePinNote(_authService.getCurrentUser()!.email.toString(), docId, !(note.isPinned));
                            break;

                          case 'lock':
                          //handle lock option
                            _notesService.lockNote(_authService.getCurrentUser()!.email.toString(), docId);
                            break;
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
