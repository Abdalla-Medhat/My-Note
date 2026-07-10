import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mynote/view/spacing.dart';
import 'package:mynote/model/sqldb.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Note extends StatefulWidget {
  final String? title;
  final String? note;
  final bool editMode;
  final int? noteId;
  final String? img;
  const Note({
    super.key,
    this.title,
    this.note,
    this.noteId,
    this.img,
    this.editMode = false,
  });

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String? image;

  Future gallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    final directory = await getApplicationDocumentsDirectory();
    if (pickImage == null) return;
    String fileName = p.basename(pickImage.path);
    String newPath = p.join(directory.path, fileName);
    File localImage = File(pickImage.path);
    await localImage.copy(newPath);
    image = newPath;
    setState(() {});
  }

  String date = DateFormat('dd/mm/yyyy hh:mm').format(DateTime.now());
  Sqldb sqldb = Sqldb();
  addNote() async {
    List<Map<dynamic, dynamic>> getUser = await sqldb.readData(
      "SELECT * FROM users WHERE is_logged_in = 1",
      [],
    );
    String? imagePath = image != null ? image : null;
    await sqldb.insertData(
      "INSERT INTO notes (title, note, user_id, last_edit, image) VALUES ( ?, ?, ?, ?, ?)",
      [
        titleController.text.trim(),
        noteController.text.trim(),
        getUser[0]['id'],
        date,
        imagePath,
      ],
    );
  }

  updateNote() async {
    if (image != null) {
      await sqldb.updateData(
        "UPDATE notes SET title = ?, note = ?, last_edit = ?, image = ? WHERE id = ? ",
        [
          titleController.text.trim(),
          noteController.text.trim(),
          date,
          image,
          widget.noteId,
        ],
      );
    } else {
      await sqldb.updateData(
        "UPDATE notes SET title = ?, note = ?, last_edit = ? WHERE id = ? ",
        [
          titleController.text.trim(),
          noteController.text.trim(),
          date,
          widget.noteId,
        ],
      );
    }
  }

  deleteNote() async {
    await sqldb.deleteData("DELETE FROM notes WHERE id = ? ", [widget.noteId]);
  }

  @override
  void initState() {
    titleController.text = widget.title ?? "";
    noteController.text = widget.note ?? "";
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: [
          widget.editMode
              ? IconButton(
                  onPressed: () async {
                    await deleteNote();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/home",
                        (route) => false,
                      );
                    }
                  },
                  icon: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                    size: 30,
                  ),
                )
              : SizedBox(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(30, 45),
              maximumSize: Size(110, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (widget.editMode) {
                  await updateNote();
                } else {
                  await addNote();
                }
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/home",
                    (route) => false,
                  );
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Icon(Icons.save_as_outlined), Text("Save")],
            ),
          ),
          SizedBox(width: AppSpacing.stackMd),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.margin),
        child: ListView(
          children: [
            Card(
              color: Theme.of(context).cardColor,
              elevation: 1.5,
              shadowColor: Theme.of(context).shadowColor.withAlpha(150),
              child: Padding(
                padding: EdgeInsetsGeometry.all(AppSpacing.stackSm),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),

                              child: Image.file(
                                File(image!),
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
                            )
                          : widget.img != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(widget.img!),
                                fit: BoxFit.cover,
                                width: 200,
                                height: 200,
                              ),
                            )
                          : Container(),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        maxLines: 1,
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: "Title",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      // Note
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: noteController,
                          decoration: InputDecoration(
                            hintText: "Note",
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      Divider(
                        thickness: 1.5,
                        height: 1,
                        indent: 10,
                        endIndent: 10,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withAlpha(30),
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                await gallery();
                              },
                              icon: Icon(Icons.image_outlined),
                            ),
                            Spacer(),
                            Text(
                              "Last edited: $date",
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withAlpha(100),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
