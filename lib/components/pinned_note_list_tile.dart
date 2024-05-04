import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2.0,),
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.background
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                //title and content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //title box
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text(
                        title,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary
                            )
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    //content box
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.5,
                      height: 115,
                      child: Text(
                        content,
                        softWrap: true,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.primary,
                            )
                        ),
                      ),
                    ),
                  ],
                ),

                //menu icon and pinned icon
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    //pin button
                    IconButton(
                      icon: Icon(
                        Typicons.pin,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      onPressed: () async {
                        Note note = Note.fromMap(await _notesService.getNoteContentById(_authService.getCurrentUser()!.email.toString(), docId));
                        _notesService.togglePinNote(_authService.getCurrentUser()!.email.toString(), docId, !(note.isPinned));
                      },
                    ),

                    //menu button
                    PopupMenuButton<dynamic>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
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
                                    "UnPin",
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                        )
                                    ),
                                  ),
                                  Icon(
                                    Icons.vertical_align_top,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 18,
                                  )
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
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                        )
                                    ),
                                  ),
                                  Icon(
                                    Icons.lock_outline,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 18,)
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
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500
                                        )
                                    ),
                                  ),
                                  Icon(
                                    Icons.edit,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 18,)
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
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        )
                                    ),
                                  ),
                                  Icon(
                                    Icons.delete_forever,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 18,)
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
                                    style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        )
                                    ),
                                  ),
                                  Icon(
                                    Icons.share,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 18,)
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
