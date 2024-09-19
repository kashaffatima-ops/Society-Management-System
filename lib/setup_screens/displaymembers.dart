import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class displaymember extends StatefulWidget {
  const displaymember({Key? key}) : super(key: key);

  @override
  _displaymemberState createState() => _displaymemberState();
}

class _displaymemberState extends State<displaymember> {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('members');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Material(
                      child: ListTile(
                          title: Text(
                            'Name: ' + documentSnapshot['Name'],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Age: ' + documentSnapshot['Age']),
                              Text('Email: ' + documentSnapshot['Email']),
                              Text('Phone number: ' +
                                  documentSnapshot['Phone number']),
                              Text('Post: ' + documentSnapshot['Post']),
                              Text('Hiring status: ' +
                                  documentSnapshot['Hiring status']),
                            ],
                          )),
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
