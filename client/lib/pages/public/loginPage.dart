import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// Local libraries
import '../../api/utils.dart';
import '../../models/credentials.dart';
// import '../../api/ApiAuth.dart';
import '../private/main_page.dart';
// import 'mainPagePublic.dart';
import 'registrationPage.dart';
import 'unauthorizedPage.dart';

class SignInScreen extends StatefulWidget {
  final ValueChanged<Credentials> onSignIn;
  final bool isAuth;
  const SignInScreen({
    super.key,
    required this.onSignIn,
    required this.isAuth,
  });

  @override
  // ignore: no_logic_in_create_state
  State<SignInScreen> createState() => _SignInScreenState(isAuth: isAuth);
}

/*
  Login page

  @param isAuth
          {@code bool} variable to check for what page should user be redirected
*/
class _SignInScreenState extends State<SignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isAuth;
  _SignInScreenState({
    required this.isAuth,
  });

  /// Sends request to login endpoint
  /// return status code of a responce 
  Future<int> loginRequest(login, pass) async {
    String url = "$URL/api/v1/auth/login";
    Map credits = {"username": login, "password": pass};
    var bodyData = json.encode(credits);
    final response = await http.post(Uri.parse(url), body: bodyData);
    var data = response.statusCode;
    Utils.TOKEN = json.decode(response.body)["token"];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            constraints: BoxConstraints.loose(const Size(600, 600)),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Sign in",
                    style: Theme.of(context).textTheme.headlineMedium),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    cursorColor: Colors.blue,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: OutlineInputBorder(),
                      labelText: "Username",
                    ),
                    controller: _usernameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    cursorColor: Colors.blue,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                    obscureText: true,
                    controller: _passwordController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () async {
                      if (_usernameController.value.text == "" &&
                          _passwordController.value.text == "") {
                        showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Error!"),
                            content: const Text(
                                "All fields should be filled in order to login."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, "OK"),
                                child: const Text("OK",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        if (_usernameController.value.text != "" ||
                            _passwordController.value.text != "") {
                          if (_usernameController.value.text != "" &&
                              _passwordController.value.text == "") {
                            showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Error!"),
                                content:
                                    const Text("You forgot your password."),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, "OK"),
                                    child: const Text("OK",
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (_usernameController.value.text == "" &&
                              _passwordController.value.text != "") {
                            showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Error!"),
                                content:
                                    const Text("You forgot your username."),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, "OK"),
                                    child: const Text("OK",
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            );
                          } else if (_usernameController.value.text != "" &&
                              _passwordController.value.text != "") {
                            var login = _usernameController.value.text;
                            var pass = _passwordController.value.text;
                            var status = await loginRequest(login, pass);
                            // await ApiAuth().loginRequest(login, pass);
                            // print(status);
                            if (status == 200) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PrivateMain(
                                          selectedIndex: 0,
                                          isAuth: true,
                                        )),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UnauthorizedScreen()),
                              );
                            }
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationPage()),
                      );
                    },
                    child: const Text("New user? Click to register.",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
