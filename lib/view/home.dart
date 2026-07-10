import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mynote/model/sqldb.dart';
import 'package:mynote/view/note.dart';
import 'package:mynote/view/spacing.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Sqldb sqldb = Sqldb();
  List<Map> userData = [];
  List<Map> notes = [];
  Future readData() async {
    userData = await sqldb.readData(
      "SELECT * FROM users WHERE is_logged_in = 1",
      [],
    );
    notes = await sqldb.readData("SELECT * FROM notes WHERE user_id = ?", [
      userData[0]['id'],
    ]);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    await readData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/note");
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
        shadowColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: Text(
          "MyNote",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: PopupMenuButton(
              color: Theme.of(context).cardColor,
              offset: const Offset(0, 60),
              child: userData.isNotEmpty && userData[0]['image'] != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(File(userData[0]['image'])),
                    )
                  : SvgPicture.asset("assets/images/profile.svg"),

              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "settings",
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: AppSpacing.stackSm),
                      Text("Settings"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "signout",
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: AppSpacing.stackSm),
                      Text("Sign Out"),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == "signout") {
                  sqldb.updateData(
                    "UPDATE users SET is_logged_in = 0 WHERE is_logged_in = 1",
                    [],
                  );
                  Navigator.pushReplacementNamed(context, "/login");
                }
                if (value == "settings") {
                  Navigator.pushNamed(context, "/settings");
                }
              },
            ),
          ),
          SizedBox(width: AppSpacing.stackMd),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.margin),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.stackLg),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 7,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),

                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              blurRadius: 1,
                              offset: Offset(1, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(AppSpacing.base),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Note(
                                    note: notes[index]['note'],
                                    title: notes[index]['title'],
                                    img: notes[index]['image'],
                                    editMode: true,
                                    noteId: notes[index]['id'],
                                  ),
                                ),
                              );
                            },
                            title: Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.stackMd,
                              ),
                              child: Text(
                                notes[index]['title'],
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Text(
                              notes[index]['note'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelMedium!,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.stackMd),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
