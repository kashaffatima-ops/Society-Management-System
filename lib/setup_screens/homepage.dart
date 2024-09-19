import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _textController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _postController = TextEditingController();
  final _hiringstatusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'member name',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                hintText: 'age',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'email',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _numberController,
              decoration: InputDecoration(
                hintText: 'phone number',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: 'post',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _hiringstatusController,
              decoration: InputDecoration(
                hintText: 'hiring status',
                border: OutlineInputBorder(),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                Map<String, dynamic> membermap = {
                  'Name': _textController.text,
                  'Age': _ageController.text,
                  'Email': _emailController.text,
                  'Phone number': _numberController.text,
                  'Post': _postController.text,
                  'Hiring status': _hiringstatusController.text
                };

                final collection =
                    FirebaseFirestore.instance.collection('members');
                await collection.doc().set(membermap);

                setState(() {
                  _textController.clear();
                  _ageController.clear();
                  _emailController.clear();
                  _numberController.clear();
                  _postController.clear();
                  _hiringstatusController.clear();
                });
              },
              color: Colors.blue,
              child: Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
