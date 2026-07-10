import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mynote/model/sqldb.dart';
import 'package:mynote/view/spacing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Sqldb sqldb = Sqldb();
  bool? checked = false;

  // حفظ حالة البيانات في متغير مستقل لضمان استقرار التحديث
  Future? _userDataFuture;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _userDataFuture = readData();
  }

  Future readData() async {
    return await sqldb.readData(
      "SELECT * FROM users WHERE is_logged_in = 1",
      [],
    );
  }

  Future<void> deletUser() async {
    await sqldb.deleteData("DELETE FROM users WHERE is_logged_in = 1", []);
  }

  final ImagePicker picker = ImagePicker();

  void _refreshData() {
    setState(() {
      _userDataFuture = readData();
    });
  }

  Future camera() async {
    final directory = await getApplicationDocumentsDirectory();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    String fileName = p.basename(image.path);
    String newPath = p.join(directory.path, fileName);
    File localImage = File(image.path);
    await localImage.copy(newPath);
    await sqldb.updateData(
      "UPDATE users SET image = ? WHERE is_logged_in = 1",
      [newPath],
    );

    _refreshData();
  }

  Future gallery() async {
    final directory = await getApplicationDocumentsDirectory();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    String fileName = p.basename(image.path);
    String newPath = p.join(directory.path, fileName);
    File localImage = File(image.path);
    await localImage.copy(newPath);
    await sqldb.updateData(
      "UPDATE users SET image = ? WHERE is_logged_in = 1",
      [newPath],
    );

    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/home",
              (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: FutureBuilder(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SvgPicture.asset("assets/images/profile.svg");
                }
                if (snapshot.data![0]["image"] == null) {
                  return SvgPicture.asset("assets/images/profile.svg");
                }
                return CircleAvatar(
                  backgroundImage: FileImage(File(snapshot.data![0]["image"])),
                );
              },
            ),
          ),
          SizedBox(width: AppSpacing.stackMd),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.margin),
        child: ListView(
          children: [
            SizedBox(height: AppSpacing.stackLg),
            Center(
              child: Stack(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: FutureBuilder(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return SvgPicture.asset("assets/images/profile.svg");
                        }
                        if (snapshot.data![0]["image"] == null) {
                          return SvgPicture.asset("assets/images/profile.svg");
                        }
                        return CircleAvatar(
                          backgroundImage: FileImage(
                            File(snapshot.data![0]["image"]),
                          ),
                        );
                      },
                    ),
                  ),

                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: OrientationBuilder(
                                builder: (context, orientation) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                    ),
                                    height: orientation == Orientation.portrait
                                        ? height * 0.42
                                        : height * 0.8,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                        AppSpacing.margin,
                                      ),
                                      child: ListView(
                                        children: [
                                          Center(
                                            child: Divider(
                                              thickness: 5,
                                              radius: BorderRadius.circular(8),
                                              height: 15,
                                              indent: 150,
                                              endIndent: 150,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withAlpha(30),
                                            ),
                                          ),
                                          SizedBox(height: AppSpacing.stackMd),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Profile Photo",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(height: AppSpacing.stackLg),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await camera();
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: AppSpacing
                                                              .stackMd,
                                                        ),
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Take a photo",
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.labelMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: AppSpacing.stackLg),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await gallery();
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: AppSpacing
                                                              .stackMd,
                                                        ),
                                                    child: Icon(
                                                      Icons.photo_outlined,
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Upload from Gallery",
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.labelMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: AppSpacing.stackLg),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await sqldb.updateData(
                                                  "UPDATE users SET image = null WHERE is_logged_in = 1",
                                                  [],
                                                );
                                                _refreshData();
                                              },
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: AppSpacing
                                                              .stackMd,
                                                        ),
                                                    child: Icon(
                                                      Icons
                                                          .delete_forever_outlined,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.error,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Remove Current Photo",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.error,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: AppSpacing.stackLg),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Center(
                                              child: Text(
                                                "Cancel",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .copyWith(
                                                      color: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.edit_outlined,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.stackMd),
            Center(
              child: Text(
                "Alex Rivera",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),

            SizedBox(height: AppSpacing.stackLg),
            Text(
              "SECURITY",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: AppSpacing.stackSm),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/update_password");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.stackSm),
                  child: ListTile(
                    leading: Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      "Update Password",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      "Keep your account secure",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    isThreeLine: false,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.stackLg),
            Text(
              "ACCOUNT MANAGEMENT",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: AppSpacing.stackSm),

            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withAlpha(100),
                  builder: (context) => StatefulBuilder(
                    builder: (context, setDialogState) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: AlertDialog(
                          title: Text(
                            "Warning: Permanent Action",
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "This will permanently delete your account and all your associated notes. This action cannot be undone.",
                                style: Theme.of(context).textTheme.labelMedium!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                    ),
                              ),
                              SizedBox(height: AppSpacing.stackMd),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: checked,
                                    onChanged: (v) {
                                      setDialogState(() {
                                        checked = v!;
                                      });
                                    },
                                    activeColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                    checkColor: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "I understand the consequences",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actionsAlignment: MainAxisAlignment.end,
                          actionsPadding: EdgeInsets.only(
                            bottom: AppSpacing.stackMd,
                            right: AppSpacing.stackMd,
                          ),
                          actions: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.stackSm,
                                ),
                                child: Text(
                                  "Cancel",
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                      ),
                                ),
                              ),
                            ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              child: Text("Delete Account"),
                              onPressed: () {
                                if (checked == true) {
                                  deletUser();
                                  if (context.mounted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      "/login",
                                      (route) => false,
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.stackSm),
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_forever_outlined,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      "Delete Account",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),

                    subtitle: Text(
                      "Permanently remove all your notes and data",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer,
                      ),
                    ),
                    trailing: Icon(
                      Icons.warning_amber_outlined,
                      color: Theme.of(context).colorScheme.error,
                    ),
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
