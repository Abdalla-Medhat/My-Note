import 'package:flutter/material.dart';
import 'package:mynote/view/home.dart';
import 'package:mynote/view/spacing.dart';
import 'package:mynote/model/sqldb.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Sqldb sqldb = Sqldb();

  bool visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: AppSpacing.stackLg,
        ),
        child: Center(
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.stackMd,
                      bottom: AppSpacing.stackSm,
                    ),
                    child: Text(
                      "MyNote",
                      style: Theme.of(context).textTheme.headlineLarge!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Capture your thoughts, simply.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.stackLg),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.base),
                  child: Text("User Name"),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a username";
                    }
                    if (value.length < 4) {
                      return "Username must be at least 4 characters long";
                    }
                    if (value.length > 50) {
                      return "Username must be less than 50 characters long";
                    }
                    return null;
                  },
                  controller: userName,
                  enabled: true,
                  decoration: InputDecoration(hintText: "username..."),
                ),
                SizedBox(height: AppSpacing.stackMd),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.base),
                  child: Text("Password"),
                ),
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
                  decoration: InputDecoration(hintText: "password..."),
                ),
                SizedBox(height: AppSpacing.stackLg),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.base),
                  child: Text("Confirm Password"),
                ),
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
                  decoration: InputDecoration(hintText: "confirm Password..."),
                ),
                SizedBox(height: AppSpacing.stackLg),

                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      List<Map> checkUser = await sqldb.readData(
                        "SELECT * FROM users WHERE username = ?",
                        [userName.text.trim()],
                      );
                      if (checkUser.isNotEmpty) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              content: SizedBox(
                                height: 20,
                                child: Text(
                                  "Username already exists",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.error,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }

                      await sqldb.insertData(
                        "INSERT INTO users (username, password, is_logged_in) VALUES (?, ?, 1)",
                        [userName.text.trim(), password.text.trim()],
                      );
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false,
                        );
                      }
                    }
                  },
                  child: Center(child: Text("Create Account")),
                ),
                SizedBox(height: AppSpacing.stackLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          "/login",
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
