import 'dart:convert';
import 'package:enhanzer_mobile_app/home.dart';
import 'package:enhanzer_mobile_app/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final DatabaseServices _databaseServices = DatabaseServices.instance;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final url =
        Uri.parse('https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke');
    final body = jsonEncode({
      "API_Body": [
        {"Unique_Id": "", "Pw": password}
      ],
      "Api_Action": "GetUserData",
      "Company_Code": username
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      Map<dynamic, dynamic> json = jsonDecode(response.body);
      final response2 = json["Status_Code"];

      if (response2 == 200) {
        _databaseServices.addUser(username, password);
        final responseData = jsonDecode(response.body);
        print("Login Successfully: $responseData");
        print(response2);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        print("Login failed: ${response2}");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                    "Hello Again",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
                  ),
                ),
                Center(
                  child: Text(
                    "Welcome Back To Enhanzer",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),
                //Form
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter Username",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          prefixIconColor: Colors.lightBlue,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Enter Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          prefixIconColor: Colors.lightBlue,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "* Required";
                          } else if (value.length < 6) {
                            return "Password should be atleast 6 characters";
                          } else if (value.length > 15) {
                            return "Password should not be greater than 15 characters";
                          } else
                            return null;
                        },
                      ),
                    ],
                  )),
                ),

                //Login Button
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 115, 105),
                        ),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            _login();
                          } else {
                            print("Not Validated");
                          }
                        },
                        child: Text("LogIn"),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                //continue with others
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: const Divider(
                          color: Colors.grey,
                          height: 36,
                        ),
                      ),
                    ),
                    const Text(
                      "Or continue with",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: const Divider(
                          color: Colors.grey,
                          height: 36,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      width: 50,
                      "https://www.gstatic.com/devrel-devsite/prod/v38a693baeb774512feb42f10aac8f755d8791ed41119b5be7a531f8e16f8279f/developers/images/touchicon-180-new.png",
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Image.network(
                      width: 50,
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2XR3uve98Zaune2n4CVHaAjR6ReZwmcwHYg&s",
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Image.network(
                      width: 50,
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiXN9xSEe8unzPBEQOeAKXd9Q55efGHGB9BA&s",
                    )
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
