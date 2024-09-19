import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Sheduleboardformembers extends StatefulWidget {
  const Sheduleboardformembers({super.key});

  @override
  State<Sheduleboardformembers> createState() => _Sheduleboardformembers();
}

class Meetings {
  final String topic;
  final String location;
  final String description;
  final DateTime datetime;

  Meetings(this.topic, this.location, this.description, this.datetime);

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'location': location,
      'description': description,
      'datetime': datetime,
    };
  }

  static Meetings fromMap(Map<String, dynamic> map) {
    return Meetings(
      map['topic'],
      map['location'],
      map['description'],
      (map['datetime'] as Timestamp).toDate(),
    );
  }
}

class _Sheduleboardformembers extends State<Sheduleboardformembers> {
  DateTime today = DateTime.now();
  Map<DateTime, List<Meetings>> meetingsShedule = {};
  TimeOfDay selectedTime = TimeOfDay.now();

  final CollectionReference ref =
      FirebaseFirestore.instance.collection('meetingShedule');

  @override
  void initState() {
    super.initState();
    _fetchMeetingsFromFirebase();
  }

  Future<void> _fetchMeetingsFromFirebase() async {
    meetingsShedule.clear();
    QuerySnapshot querySnapshot = await ref.get();
    final allData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      for (var meetingData in allData) {
        Meetings meeting = Meetings.fromMap(meetingData);
        DateTime date = DateTime(meeting.datetime.year, meeting.datetime.month,
            meeting.datetime.day);
        if (meetingsShedule[date] == null) {
          meetingsShedule[date] = [];
        }
        meetingsShedule[date]!.add(meeting);
      }
      setState(() {});
    });
  }

  void _ondaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
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
            border: Border(
              bottom: BorderSide(color: Colors.white70, width: 1),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.black,
            elevation: 8,
            toolbarHeight: 60,
            centerTitle: true,
            title: const Text(
              "Meeting Schedule Board",
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
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 100.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white54.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: TableCalendar(
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      availableGestures: AvailableGestures.all,
                      selectedDayPredicate: (day) => isSameDay(day, today),
                      focusedDay: today,
                      firstDay: DateTime.utc(2024, 7, 19),
                      lastDay: DateTime.utc(2025, 6, 20),
                      onDaySelected: _ondaySelected,
                      eventLoader: (day) {
                        return meetingsShedule[
                                DateTime(day.year, day.month, day.day)] ??
                            [];
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  "Selected day: ${DateFormat('yyyy-MM-dd').format(today)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: meetingsShedule[
                              DateTime(today.year, today.month, today.day)]
                          ?.length ??
                      0,
                  itemBuilder: (context, index) {
                    final meeting = meetingsShedule[
                        DateTime(today.year, today.month, today.day)]![index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      child: ListTile(
                        title: Text(
                          meeting.topic,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location: ${meeting.location}'),
                            Text('Description: ${meeting.description}'),
                            Text(
                                'Time: ${DateFormat('HH:mm').format(meeting.datetime)}'),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
