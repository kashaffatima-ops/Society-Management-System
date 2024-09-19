import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class ApproveEventParticipationRequest extends StatefulWidget {
  const ApproveEventParticipationRequest({Key? key}) : super(key: key);

  @override
  _ApproveEventParticipationRequestState createState() =>
      _ApproveEventParticipationRequestState();
}

class _ApproveEventParticipationRequestState
    extends State<ApproveEventParticipationRequest> {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('participation_requests');

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
              "Event Participation Requests",
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
        child: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  final eventData =
                      documentSnapshot.data() as Map<String, dynamic>;

                  if (documentSnapshot['Approval_status'] != false) {
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
                              eventData['First name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'First name: ${eventData['First name']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Last name: ${eventData['Last name']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Batch: ${eventData['Batch']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Email: ${eventData['Email']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Phone number: ${eventData['Phone number']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Map<String, dynamic> eventmap = {
                                        'First name':
                                            documentSnapshot['First name'],
                                        'Last name':
                                            documentSnapshot['Last name'],
                                        'Batch': documentSnapshot['Batch'],
                                        'Email': documentSnapshot['Email'],
                                        'Phone number':
                                            documentSnapshot['Phone number'],
                                        'Event id':
                                            documentSnapshot['Event id'],
                                        'Approval_status': true,
                                      };

                                      await ref
                                          .doc(documentSnapshot.id)
                                          .update(eventmap);

                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Close"),
                                                  )
                                                ],
                                                title:
                                                    const Text("Notification"),
                                                contentPadding:
                                                    const EdgeInsets.all(20.0),
                                                content: const Text(
                                                    "Application approved successfully!!"),
                                              ));
                                    },
                                    child: Text('Approve',
                                        style: TextStyle(color: Colors.white)),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(WidgetState.pressed)) {
                                          return Colors.black26;
                                        }
                                        return Colors.blue;
                                      }),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await ref
                                          .doc(documentSnapshot.id)
                                          .delete();

                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Close"),
                                                  )
                                                ],
                                                title:
                                                    const Text("Notification"),
                                                contentPadding:
                                                    const EdgeInsets.all(20.0),
                                                content: const Text(
                                                    "Application disapproved successfully!!"),
                                              ));
                                    },
                                    child: Text('Disapprove',
                                        style: TextStyle(color: Colors.white)),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(WidgetState.pressed)) {
                                          return Colors.black26;
                                        }
                                        return Colors.blue;
                                      }),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
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
