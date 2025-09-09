import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/* colors I need to use in my app:s
| الاستخدام                  | الكود Hex   | الملاحظات                          |
| -------------------------- | ----------- | ---------------------------------- |
| اللون الأساسي (Primary)    | **#B2DBB5** | اللون الحالي                       |
| أساسي غامق (Primary Dark)  | **#8CBF91** | مناسب للأزرار والعناوين            |
| أساسي فاتح (Primary Light) | **#D8F5D9** | للخلفيات أو الـ hover              |
| لون مكمّل (Accent)          | **#B5B2DB** | بنفسجي فاتح يكمل الأخضر            |
| لون متباين (Contrast)      | **#F2A65A** | برتقالي دافئ يعطي جمالية مع الأخضر |
| رمادي نصوص (Text Gray)     | **#5F6F60** | نصوص ثانوية أو أيقونات             |
*/
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map> notes = [];
  Future loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString("notes") ?? "[]";
    List<Map> dataDecode = jsonDecode(data).cast<Map>();
    setState(() {
      notes = dataDecode;
    });
  }

  Future deleteNote(i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notes.removeAt(i);
    String dataEncode = jsonEncode(notes);
    await prefs.setString("notes", dataEncode);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 255, 235),
      appBar: AppBar(
        backgroundColor: Color(0xffB2DBB5),
        title: const Text(
          "My Note",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // childAspectRatio: 1.0,
                  mainAxisExtent: 300,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xffB2DBB5),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              notes[i]["title"],
                              style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                overflow: TextOverflow.ellipsis,
                              ),
                              textAlign: TextAlign.center,
                              // softWrap: true,
                              // maxLines: 2,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: const Color(0xffD8F5D9),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                notes[i]["note"],
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 5,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xffB2DBB5),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                notes[i]["date"] ?? "0",
                                style: TextStyle(
                                  color: Color(0xff5F6F60),
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              PopupMenuButton(
                                icon: Icon(Icons.more_horiz),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text("Edit"),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        "addEditNote",
                                        arguments: notes[i],
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    onTap: () {
                                      deleteNote(i);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: notes.length,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xff8CBF91),
                    elevation: 9,

                    onPressed: () {
                      Navigator.pushNamed(context, "addEditNote");
                    },
                    child: Icon(Icons.add, size: 30),
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
