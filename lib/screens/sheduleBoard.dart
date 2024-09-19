import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Sheduleboard extends StatefulWidget {
  const Sheduleboard({super.key});

  @override
  State<Sheduleboard> createState() => _Sheduleboard();
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

class _Sheduleboard extends State<Sheduleboard> {
  DateTime today = DateTime.now();
  Map<DateTime, List<Meetings>> meetingsShedule = {};
  TextEditingController _topicController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _datetimeController = TextEditingController();
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        final DateTime meetingDateTime = DateTime(
          today.year,
          today.month,
          today.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        _datetimeController.text = DateFormat('HH:mm').format(meetingDateTime);
      });
    }
  }

  Future<void> _saveMeeting() async {
    final String topic = _topicController.text;
    final String location = _locationController.text;
    final String description = _descriptionController.text;

    if (topic.isNotEmpty && location.isNotEmpty && description.isNotEmpty) {
      final DateTime meetingDateTime = DateTime(
        today.year,
        today.month,
        today.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final meeting = Meetings(topic, location, description, meetingDateTime);
      setState(() {
        if (meetingsShedule[today] == null) {
          meetingsShedule[today] = [];
        }
        meetingsShedule[today]!.add(meeting);
      });

      await ref.add(meeting.toMap());

      _topicController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _datetimeController.clear();

      await _fetchMeetingsFromFirebase();

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
                contentPadding: const EdgeInsets.all(20.0),
                content: const Text("Meeting added successfully in schedule!"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Text("Enter meeting details:"),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        controller: _topicController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Topic',
                          labelStyle: TextStyle(color: Colors.purple.shade900),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _locationController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Location',
                          labelStyle: TextStyle(color: Colors.purple.shade900),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.purple.shade900),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _datetimeController,
                        style: TextStyle(color: Colors.black),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          labelStyle: TextStyle(color: Colors.purple.shade900),
                        ),
                        onTap: () {
                          _selectTime(context);
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _saveMeeting();
                      Navigator.of(context).pop();
                    },
                    child: Text('Done', style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return Colors.pink.shade900;
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
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
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Selected day: ${DateFormat('yyyy-MM-dd').format(today)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
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
                      elevation: 0,
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
