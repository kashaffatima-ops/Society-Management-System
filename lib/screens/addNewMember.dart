import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class Addnewmember extends StatefulWidget {
  const Addnewmember({Key? key}) : super(key: key);

  @override
  _AddnewmemberState createState() => _AddnewmemberState();
}

class _AddnewmemberState extends State<Addnewmember> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _phoneController = TextEditingController();
  final _postController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.black,
            elevation: 8,
            toolbarHeight: 60,
            centerTitle: true,
            title: const Text(
              "Event Creation",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white70,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white70),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {},
                icon: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    "assets/images/profile.png",
                    width: 70,
                    height: 70,
                  ),
                ),
              ),
            ],
          ),
        ),
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
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      buildTextField(_nameController, 'Member Name'),
                      const SizedBox(height: 20),
                      buildTextField(_emailController, 'Email'),
                      const SizedBox(height: 20),
                      buildTextField(_passController, 'Password'),
                      const SizedBox(height: 20),
                      buildTextField(_phoneController, 'Contact Number'),
                      const SizedBox(height: 20),
                      buildTextField(_ageController, 'Age'),
                      const SizedBox(height: 20),
                      buildTextField(_postController, 'Post'),
                      const SizedBox(height: 20),
                      Container(
                        width: 150,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90)),
                        child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> eventmap = {
                              'Name': _nameController.text,
                              'Email': _emailController.text,
                              'Password': _passController.text,
                              'Phone number': _phoneController.text,
                              'Post': _postController.text,
                              'Age': _ageController.text,
                              'Hiring status': "",
                              'profile': '',
                            };

                            final collection = FirebaseFirestore.instance
                                .collection('members');
                            await collection.doc().set(eventmap);

                            setState(() {
                              _nameController.clear();
                              _emailController.clear();
                              _passController.clear();
                              _phoneController.clear();
                              _postController.clear();
                              _ageController.clear();
                            });

                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Close"),
                                        )
                                      ],
                                      title: const Text("Notification"),
                                      contentPadding:
                                          const EdgeInsets.all(20.0),
                                      content: const Text(
                                          "Member added successfully!!"),
                                    ));
                          },
                          child: Text('Add',
                              style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.black26;
                              }
                              return Colors.blue;
                            }),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
    );
  }
}
