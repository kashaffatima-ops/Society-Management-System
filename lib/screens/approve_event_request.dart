import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class ApproveEventRequest extends StatefulWidget {
  const ApproveEventRequest({Key? key}) : super(key: key);

  @override
  _ApproveEventRequestState createState() => _ApproveEventRequestState();
}

class _ApproveEventRequestState extends State<ApproveEventRequest> {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('events');

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
              "Event Requests",
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
                              eventData['Event Name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Date: ${eventData['Date']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Organizer: ${eventData['Organizer']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Time: ${eventData['Time']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Budget: ${eventData['Budget']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Venue: ${eventData['Venue']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Description: ${eventData['Description']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                            'Event Name':
                                                documentSnapshot['Event Name'],
                                            'Date': documentSnapshot['Date'],
                                            'Organizer':
                                                documentSnapshot['Organizer'],
                                            'Time': documentSnapshot['Time'],
                                            'Budget':
                                                documentSnapshot['Budget'],
                                            'Venue': documentSnapshot['Venue'],
                                            'Description':
                                                documentSnapshot['Description'],
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
                                                        "Event approved successfully!!"),
                                                  ));
                                        },
                                        child: Text('Approve',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
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
                                                        "Event disapproved successfully!!"),
                                                  ));
                                        },
                                        child: Text('Disapprove',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                WidgetState.pressed)) {
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
