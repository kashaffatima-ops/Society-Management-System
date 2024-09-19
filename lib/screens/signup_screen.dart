import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/reusable_widgets/reuseablewidgets.dart';
import 'package:hopeapp/screens/executiveBody.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';
import 'package:hopeapp/screens/membersDashboard.dart';
import 'package:hopeapp/screens/mentorDshboard.dart';
import 'package:hopeapp/screens/president_dashboard.dart';
import 'package:hopeapp/screens/randomPersonDashboard.dart';

class SignUnScreen extends StatefulWidget {
  const SignUnScreen({Key? key}) : super(key: key);

  @override
  _SignUnScreenState createState() => _SignUnScreenState();
}

class _SignUnScreenState extends State<SignUnScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _postTextController = TextEditingController();
  String _dropdownvalue = 'Mentor';
  var _item = [
    'Mentor',
    'President',
    'Members',
    'Exective body',
    'Non-society person'
  ];
  bool _isPasswordVisible = false;

  bool _isValidName(String name) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z]+$');
    return name.isNotEmpty && name.length <= 20 && nameRegExp.hasMatch(name);
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final RegExp passwordRegExp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegExp.hasMatch(password);
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
          color: Colors.white70, // Change this to your desired color
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Image.asset(
                  "assets/images/logo_name.png",
                  width: 400,
                  height: 100,
                ),
                const SizedBox(height: 80),
                SizedBox(
                    width: 400,
                    child: reuseableTextField(
                      "Enter UserName",
                      Icons.person_outline,
                      false,
                      _userNameTextController,
                      true,
                      () {},
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: reuseableTextField(
                    "Enter Email Id",
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
                const SizedBox(height: 10),
                SizedBox(
                  width: 400,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: DropdownButton<String>(
                      value: _dropdownvalue,
                      icon: SizedBox.shrink(),
                      iconSize: 22,
                      elevation: 16,
                      dropdownColor: Colors.white,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 18),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      items: _item.map<DropdownMenuItem<String>>((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 8),
                              Text(item,
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          179, 62, 60, 60))),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownvalue = newValue!;
                          _postTextController.text = newValue;
                        });
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return _item.map<Widget>((String item) {
                          return Row(
                            children: <Widget>[
                              Icon(Icons.co_present, color: Colors.white70),
                              SizedBox(width: 10),
                              Text(item,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9))),
                              SizedBox(width: 119),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white70,
                              ),
                            ],
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_isValidName(_userNameTextController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Enter valid name. Your name should not contain any numbers or special characters')),
                        );
                        return;
                      }
                      if (!_isValidEmail(_emailTextController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid email.')),
                        );
                        return;
                      }
                      if (!_isValidPassword(_passwordTextController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Password cannot be empty. Your password must contain: \n - atleast 1 uppercase letter\n - atleast 1 lowercase leyter \n - atleast 1 special character\n - atleast 8 numeric digits')),
                        );
                        return;
                      }

                      Map<String, dynamic> membermap = {
                        'Name': _userNameTextController.text,
                        'Email': _emailTextController.text,
                        'Password': _passwordTextController.text,
                        'Age': '',
                        'Phone number': '',
                        'Post': _postTextController.text,
                        'Hiring status': '',
                        'profile': '',
                      };
                      String status = _postTextController.text;
                      String email = _emailTextController.text;
                      String password = _passwordTextController.text;
                      final collection =
                          FirebaseFirestore.instance.collection('members');
                      collection.add(membermap).then((_) async {
                        setState(() {
                          _userNameTextController.clear();
                          _passwordTextController.clear();
                          _emailTextController.clear();
                          _postTextController.clear();
                        });
                        final CollectionReference _usersCollection =
                            FirebaseFirestore.instance.collection('members');
                        QuerySnapshot querySnapshot = await _usersCollection
                            .where('Email', isEqualTo: email)
                            .where('Password', isEqualTo: password)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          DocumentSnapshot userDoc = querySnapshot.docs.first;

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
                        }
                      }).catchError((error) {
                        print("Failed to add user: $error");
                      });
                    },
                    child: Text("Sign Up"),
                  ),
                ),
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
                      // Attempt to sign in with Google and handle the UserCredential response
                      UserCredential userCredential = await signInWithGoogle();

                      // Handle successful sign-in (e.g., navigate to a different screen)
                      // For example:
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => Randompersondashboard()),
                      // );
                    } catch (e) {
                      // Handle any errors that occurred during sign-in
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
}
