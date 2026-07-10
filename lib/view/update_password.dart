import 'package:flutter/material.dart';
import 'package:mynote/model/sqldb.dart';
import 'package:mynote/view/spacing.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController currentpassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Sqldb sqldb = Sqldb();
  List<Map> userData = [];
  Future readData() async {
    userData = await sqldb.readData(
      "SELECT * FROM users WHERE is_logged_in = 1",
      [],
    );
  }

  Future loadData() async {
    await readData();
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadData();
  }

  bool visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Update Password",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.margin * 2,
              vertical: AppSpacing.stackLg,
            ),
            child: Center(
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSpacing.stackMd,
                        bottom: AppSpacing.stackSm,
                      ),
                      child: Text(
                        "Secure Your Account",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Choose a strong password to keep your notes safe. We recommend using a mix of letters, numbers, and symbols.",

                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: AppSpacing.stackLg),

                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters long";
                        }
                        if (value.length > 100) {
                          return "Password must be less than 100 characters long";
                        }
                        if (userData.isNotEmpty &&
                            value != userData[0]['password']) {
                          return "Password does not match";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      controller: currentpassword,
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: "Current Password...",
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.stackMd),
                    // New Password Field
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters long";
                        }
                        if (value.length > 100) {
                          return "Password must be less than 100 characters long";
                        }

                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      controller: password,
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: "New Password",
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.stackLg),
                    // Confirm Password Field
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != password.text.trim()) {
                          return "Passwords do not match";
                        }

                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      controller: confirmPassword,
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: "confirm Password",
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    SizedBox(height: AppSpacing.margin * 5),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    // spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.margin,
                ),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Text("Cancel"),
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await sqldb.updateData(
                                "UPDATE users SET password = ? WHERE is_logged_in = 1",
                                [password.text.trim()],
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_as_outlined),
                              SizedBox(width: AppSpacing.base),
                              Text("Save Changes"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
