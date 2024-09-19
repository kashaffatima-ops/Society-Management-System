import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/screens/addNewMember.dart';
import 'package:hopeapp/screens/editMembers.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class Membersdirectory extends StatefulWidget {
  const Membersdirectory({Key? key}) : super(key: key);

  @override
  _MembersdirectoryState createState() => _MembersdirectoryState();
}

class _MembersdirectoryState extends State<Membersdirectory> {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('members');

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
              "Member's Directory",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addnewmember(),
            ),
          );
        },
        child: Icon(Icons.add),
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
        child: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  final membersData =
                      documentSnapshot.data() as Map<String, dynamic>;
                  if (documentSnapshot['Hiring status'] == false) {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Card(
                      color: Colors.black.withOpacity(0.7),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['Name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Email: ${documentSnapshot['Email']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Age: ${documentSnapshot['Age']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Phone number: ${documentSnapshot['Phone number']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Post: ${documentSnapshot['Post']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Password: ${documentSnapshot['Password']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(width: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.edit, color: Colors.white70),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Editmembers(
                                            membersId: documentSnapshot.id,
                                            membersData: membersData,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.white70),
                                      onPressed: () {
                                        ref.doc(documentSnapshot.id).delete();
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text("Close"),
                                                    )
                                                  ],
                                                  title: const Text(
                                                      "Notification"),
                                                  contentPadding:
                                                      const EdgeInsets.all(
                                                          20.0),
                                                  content: const Text(
                                                      "Member deleted successfully!!"),
                                                ));
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
