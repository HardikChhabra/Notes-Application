import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/pages/home_page.dart';
import 'package:todo_list/pages/locked_notes_page.dart';
import 'package:todo_list/pages/settings_page.dart';

class HomeDrawer extends StatelessWidget {

  final void Function() onTap;
  const HomeDrawer({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 64.0, 8.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //logo
            Icon(
              Icons.notes_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 80,
            ),
            const SizedBox(height: 32,),

            //home list tile
            Column(
              children: [
                ListTile(
                  title: Text(
                      "H O M E",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ),
                  ),
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  },
                ),

                //settings list tile
                ListTile(
                  title: Text(
                    "S E T T I N G S",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )
                    ),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                  },
                ),
                ListTile(
                  title: Text(
                    "L O C K E D",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        )
                    ),
                  ),
                  leading: Icon(
                    Icons.lock_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LockedNotePage()));
                  },
                ),
              ],
            ),

            //logout list tile
            ListTile(
              title: Text(
                'L O G O U T',
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )
                ),
              ),
              trailing: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: onTap,
            )
          ],
        ),
      ),
    );
  }
}
