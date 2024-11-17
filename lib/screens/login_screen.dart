import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medication_adherence_app/screens/home_screen.dart';
import 'package:medication_adherence_app/screens/signup_screen.dart';
import 'package:medication_adherence_app/services/auth_service.dart';
import 'package:medication_adherence_app/services/notification_service.dart';

class LoginScreen extends StatefulWidget {
  final FirebaseFirestore firestore;

  LoginScreen({required this.firestore});

  @override
  _LoginScreenState createState() => _LoginScreenState(
        firebaseFirestore: firestore,
      );
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  late final FirebaseFirestore firebaseFirestore;

  _LoginScreenState({
    required this.firebaseFirestore,
  });

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isPasswordVisible = false; // Manage the visibility of the password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade700)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passController,
                obscureText: !_isPasswordVisible, // Obscure password text
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade700)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black, // text color
                  ),
                  onPressed: () async {
                    User? user = await _auth.signInWithEmailAndPassword(
                      _emailController.text,
                      _passController.text,
                    );
                    if (user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                    auth: _auth.auth,
                                    firestore: firebaseFirestore,
                                    enableNotifications: true,
                                  )));
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                "OR",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black, // text color
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                  child: Text(
                    "Create Account",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
