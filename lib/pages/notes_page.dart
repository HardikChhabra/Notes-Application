import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/services/note_service.dart';

class NotesPage extends StatelessWidget {

  final String? noteId;
  final NotesService _notesService = NotesService();
  final AuthService _authService = AuthService();

  NotesPage({super.key, required this.noteId});

  final TextEditingController _content = TextEditingController();
  final TextEditingController _title = TextEditingController();

  void onPop (bool isPinned, bool isLocked) {

    //if value changed
    if(_content.text.isNotEmpty) {
      _notesService.updateNote(_title.text, noteId!, _content.text, _authService.getCurrentUser()!.email.toString(), isLocked, isPinned);
    }
    //if value removed
    else{
      _notesService.deleteNote(noteId!, _authService.getCurrentUser()!.email.toString());
    }
  }

  void createNewNote (bool? notRequired) {
    if(_content.text.isNotEmpty) {
      _notesService.addNote(_title.text, _content.text, _authService.getCurrentUser()!.email.toString(), false, false);

    }
  }


  @override
  Widget build(BuildContext context) {
    if(noteId != null) {
      return StreamBuilder(
        stream: _notesService.getNoteById(
            _authService.getCurrentUser()!.email.toString(), noteId),
        builder: (context, snapshot) {
          //if we have data, get all docs
          if (snapshot.hasData) {
            Note note = Note.fromMap(snapshot.data!.data()!);
            _content.text = note.content;
            _title.text = note.title;

            //display the note
            return PopScope(
              onPopInvoked: (bool? notRequired) {
                onPop(note.isPinned, note.isLocked);
              },
              child: Scaffold(
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //appbar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios, color: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary,
                                    size: 21,
                                  ),
                                ),
                                Text(
                                  'All notes',
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w500,
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                  ),
                                )
                              ],
                            ),
                            IconButton(onPressed: () {
                              Share.share('${_title.text}\n${_content.text}');
                            },
                                icon: Icon(
                                  Icons.ios_share_outlined, color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                  size: 21,
                                ))
                          ],
                        ),
                      ),

                      //title
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flexible(
                          child: TextField(
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary
                                )
                            ),
                            controller: _title,
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title',
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .primary
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*MyTextField(hint: 'Content', obscureText: false, controller: _content),*/

                      //content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary
                                )
                            ),
                            controller: _content,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Content',
                              hintStyle: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme
                                          .of(context)
                                          .colorScheme
                                          .primary
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    else {
      return PopScope(
        onPopInvoked: createNewNote,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //appbar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios, color: Theme
                                .of(context)
                                .colorScheme
                                .primary,
                              size: 21,
                            ),
                          ),
                          Text(
                            'All notes',
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary,
                                )
                            ),
                          )
                        ],
                      ),
                      IconButton(onPressed: () {
                        Share.share('${_title.text}\n${_content.text}');
                      },
                          icon: Icon(
                            Icons.ios_share_outlined, color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                            size: 21,
                          ))
                    ],
                  ),
                ),

                //title
                Flexible(
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary
                            )
                        ),
                        controller: _title,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title',
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .primary
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /*MyTextField(hint: 'Content', obscureText: false, controller: _content),*/

                //content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primary
                          )
                      ),
                      controller: _content,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Content',
                        hintStyle: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary
                            )
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class Note {
  String title;
  String content;
  bool isLocked;
  bool isPinned;

  Note({required this.title, required this.content, required this.isLocked, required this.isPinned});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      isLocked: map['isLocked'],
      isPinned: map['isPinned'],
    );
  }
}