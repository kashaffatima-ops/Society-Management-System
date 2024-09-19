import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class Editmembers extends StatefulWidget {
  final String membersId;
  final Map<String, dynamic> membersData;

  const Editmembers(
      {required this.membersId, required this.membersData, Key? key})
      : super(key: key);

  @override
  _EditmembersState createState() => _EditmembersState();
}

class _EditmembersState extends State<Editmembers> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _phoneController = TextEditingController();
  final _postController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.membersData['Name'];
    _emailController.text = widget.membersData['Email'];
    _passController.text = widget.membersData['Password'];
    _phoneController.text = widget.membersData['Phone number'];
    _postController.text = widget.membersData['Post'];
    _ageController.text = widget.membersData['Age'];
  }

  Future<void> _updateMember() async {
    await FirebaseFirestore.instance
        .collection('members')
        .doc(widget.membersId)
        .update({
      'Name': _nameController.text,
      'Email': _emailController.text,
      'Password': _passController.text,
      'Phone number': _phoneController.text,
      'Post': _postController.text,
      'Age': _ageController.text,
      'Hiring status': "",
      'profile': '',
    });

    Navigator.pop(context);
  }

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
              "Edit Member's Data",
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
            padding: const EdgeInsets.fromLTRB(20, 140, 20, 20),
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
                      TextField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Member Name',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _phoneController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Contact number',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _postController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Post',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _ageController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Age',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: Text('Update Data'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 229, 107, 147),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                _updateMember();
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
                                              "Successfully updated member's data!!"),
                                        ));
                              }),
                          SizedBox(width: 20),
                          ElevatedButton(
                              child: Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 229, 107, 147),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 15),
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
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
}
