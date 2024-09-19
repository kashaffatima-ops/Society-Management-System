import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/reusable_widgets/reuseablewidgets.dart';
import 'package:hopeapp/screens/executiveBody.dart';
import 'package:hopeapp/screens/forgot_pass.dart';
import 'package:hopeapp/screens/googleSignupDashboard.dart';
import 'package:hopeapp/screens/mentorDshboard.dart';
import 'package:hopeapp/screens/president_dashboard.dart';
import 'package:hopeapp/screens/membersDashboard.dart';
import 'package:hopeapp/screens/randomPersonDashboard.dart';
import 'package:hopeapp/screens/signup_screen.dart';
import 'hashcolorchanger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _isPasswordVisible = false;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('members');

  Future<void> authenticatewithgoogle({required BuildContext context}) async {
    try {
      await signInWithGoogle();
    } catch (e) {
      if (!context.mounted) return;
      print("Error: $e");
    }
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.isNotEmpty;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white70,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorchanger('#A70052'),
              colorchanger('#A0153E'),
              colorchanger('#720455'),
              colorchanger('#3C0753'),
              colorchanger('#0F094F'),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 80),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/images/logo_name.png",
                    width: 400,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: 400,
                  child: reuseableTextField(
                    "Enter Email",
                    Icons.email_outlined,
                    false,
                    _emailTextController,
                    true,
                    () {},
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: reuseableTextField(
                    "Enter Password",
                    Icons.lock_outline,
                    true,
                    _passwordTextController,
                    _isPasswordVisible,
                    _togglePasswordVisibility,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      String email = _emailTextController.text;
                      String password = _passwordTextController.text;

                      if (!_isValidEmail(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid email format.')),
                        );
                        return;
                      }
                      if (!_isValidPassword(password)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid password.')),
                        );
                        return;
                      }

                      QuerySnapshot querySnapshot = await _usersCollection
                          .where('Email', isEqualTo: email)
                          .where('Password', isEqualTo: password)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        DocumentSnapshot userDoc = querySnapshot.docs.first;
                        String status = userDoc['Post'];

                        setState(() {
                          _passwordTextController.clear();
                          _emailTextController.clear();
                        });

                        if (status == 'President') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        membersId: userDoc.id,
                                      )));
                        } else if (status == 'Members') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Membersdashboard(
                                        membersId: userDoc.id,
                                      )));
                        } else if (status == 'Non-society person') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Randompersondashboard(
                                        membersId: userDoc.id,
                                      )));
                        } else if (status == 'Exective body') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Executivebody(
                                        membersId: userDoc.id,
                                      )));
                        } else if (status == 'Mentor') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Mentordshboard(
                                        membersId: userDoc.id,
                                      )));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid email or password.')),
                        );
                      }
                    },
                    child: Text("Log In"),
                  ),
                ),
                const SizedBox(height: 20),
                signUpOption(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "\n          OR\nContinue with",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await signInWithGoogle();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Googlesignupdashboard()),
                      );
                    } catch (e) {
                      print('Error during Google Sign-In: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Google Sign-In failed: $e')),
                      );
                    }
                  },
                  icon: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      "assets/images/google.png",
                      width: 70,
                      height: 70,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUnScreen()));
          },
          child: const Text(
            " Sign up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
