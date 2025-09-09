import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddEditNote extends StatefulWidget {
  const AddEditNote({super.key});

  @override
  State<AddEditNote> createState() => _AddEditNoteState();
}

class _AddEditNoteState extends State<AddEditNote> {
  Map<String, dynamic> extractedData = {};
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argu = ModalRoute.of(context)?.settings.arguments;
    if (argu != null && argu is Map<String, dynamic>) {
      extractedData = argu;
      titleController.text = extractedData["title"];
      noteController.text = extractedData["note"];
      parsed = true;
    }
  }

  ///Extracting Data and processing it then remove the old one.
  Future parsedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("notes") ?? "[]";
    List<Map<String, dynamic>> dataDecoded = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    if (parsed == true) {
      dataDecoded.removeWhere(
        (element) => element["title"] == extractedData["title"],
      );
    }
    String dataEncode = jsonEncode(dataDecoded);
    await prefs.setString("notes", dataEncode);
  }

  DateTime date = DateTime.now();
  late String noteDate = noteDate =
      "${date.year}-${date.month}-${date.day}, ${date.hour}:${date.minute}";
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool parsed = false;

  Future saveNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("notes") ?? "[]";
    List<Map<String, dynamic>> dataDecoded = (jsonDecode(data) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    dataDecoded.add({
      "title": titleController.text,
      "note": noteController.text,
      "date": noteDate,
    });
    String dataEncode = jsonEncode(dataDecoded);
    await prefs.setString("notes", dataEncode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25, left: 30),
          child: SizedBox(
            height: 80,
            width: 100,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Color(0xff8CBF91),
              elevation: 9,

              onPressed: () {
                if (formKey.currentState!.validate()) {
                  parsedData();
                  saveNote();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, "home");
                  }
                }
              },
              child: Text(
                "Save",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 5,
        shadowColor: Color(0xff8CBF91),
        iconTheme: IconThemeData(color: Colors.blueGrey),
        // leadingWidth: 100,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 7),
        //   child: SizedBox(
        //     height: 30,
        //     width: 70,
        //     child: MaterialButton(
        //       color: Color(0xff8CBF91),
        //       child: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
        //         parsedData();
        //       },),
        //       onPressed: () {},
        //     ),
        //   ),
        // ),
        backgroundColor: Color(0xffB2DBB5),
        title: const Text(
          "My Note",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'That field is required';
                } else {
                  return null;
                }
              },
              style: TextStyle(fontSize: 20, color: Color(0xff5F6F60)),
              cursorColor: Color(0xff8CBF91),
              controller: titleController,
              textAlignVertical: TextAlignVertical.top,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 25,
                  color: const Color(0xff5F6F60).withAlpha(190),
                ),
                fillColor: Color(0xffD8F5D9),
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                hintText: "Title",
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              maxLines: 1,
            ),

            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'That field is required';
                  } else {
                    return null;
                  }
                },
                style: TextStyle(fontSize: 18, color: Color(0xff5F6F60)),
                cursorColor: Color(0xff8CBF91),
                controller: noteController,
                textAlignVertical: TextAlignVertical.top,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: const Color(0xff5F6F60).withAlpha(190),
                  ),
                  fillColor: Color(0xffD8F5D9),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  hintText: "Note",
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            // SizedBox(
            //   height: 50,
            //   width: 80,
            //   child: MaterialButton(
            //     color: Color(0xff8CBF91),

            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(40),
            //     ),
            //     child: Text(
            //       "Save",
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 15,
            //       ),
            //     ),
            //     onPressed: () {
            //       if (formKey.currentState!.validate()) {
            //         parsedData();
            //         saveNote();
            //         if (context.mounted) {
            //           Navigator.pushReplacementNamed(context, "home");
            //         }
            //       }
            //     },
            //   ),
            // ),
            Container(color: Color(0xffD8F5D9), height: 110),
          ],
        ),
      ),
    );
  }
}
