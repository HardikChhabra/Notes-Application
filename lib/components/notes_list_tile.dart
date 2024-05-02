import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/auth/auth_service.dart';
/*import 'package:todo_list/components/button.dart';*/
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
      /*onLongPress: () {
        showDialog(context: context, builder: (BuildContext context) {
          return AlertDialog(
            shape: ,
            title: Text(
              title,
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary
                  )
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //pin button
                Button(text: "Pin", onTap: () {}),
                const SizedBox(height: 4,),

                //lock button
                Button(text: "Lock", onTap: () {}),
                const SizedBox(height: 4,),

                //edit button
                Button(text: "Edit", onTap: (){}),
                const SizedBox(height: 4,),

                //delete button
                Button(text: "Delete", onTap: (){})
              ],
            ),
          );
        });
      },*/
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
                                "Pin",
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
                  onSelected: (dynamic value) {
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
                        break;

                      case 'pin':
                        //handle pin option
                        break;
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
