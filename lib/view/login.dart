import 'package:flutter/material.dart';
import 'package:mynote/model/sqldb.dart';
import 'package:mynote/view/home.dart';
import 'package:mynote/view/spacing.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();

  const Login({super.key});
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

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
                  child: SvgPicture.asset(
                    "assets/images/icon.svg",
                    semanticsLabel: "Note book",
                  ),
                ),
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
                    "Mindful Productivity Awaits",
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
                  obscureText: visible ? false : true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: password,
                  enabled: true,
                  decoration: InputDecoration(
                    hintText: "password",
                    suffixIcon: IconButton(
                      icon: visible
                          ? Icon(
                              Icons.visibility,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.stackLg),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // Check if the username and password match a record in the database
                      List<Map> checkLogin = await sqldb.readData(
                        "SELECT * FROM users WHERE username = ? AND password = ?",
                        [userName.text.trim(), password.text.trim()],
                      );
                      // If so ...
                      if (checkLogin.isNotEmpty) {
                        await sqldb.updateData(
                          "UPDATE users SET is_logged_in = 1 WHERE username = ?",
                          [userName.text.trim()],
                        );
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (route) => false,
                          );
                        }
                      }
                      // If not, show an error message
                      else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              content: SizedBox(
                                height: 20,
                                child: Text(
                                  "Invalid username or password",
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
                          userName.clear();
                          password.clear();
                        }
                      }
                    }
                  },
                  child: Center(child: Text("Login")),
                ),
                SizedBox(height: AppSpacing.stackLg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                      child: Text(
                        "Sign Up",
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
