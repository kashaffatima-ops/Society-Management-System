import 'package:flutter/material.dart';
import 'package:hopeapp/screens/ProfilePage.dart';
import 'package:hopeapp/screens/UploadImageofEvent.dart';
import 'package:hopeapp/screens/add_event.dart';
import 'package:hopeapp/screens/approve_event_participation.dart';
import 'package:hopeapp/screens/approve_event_request.dart';
import 'package:hopeapp/screens/display_events_for_president.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';
import 'package:hopeapp/screens/membersdirectory.dart';
import 'package:hopeapp/screens/navbar.dart';
import 'package:hopeapp/screens/sheduleBoard.dart';

class Mentordshboard extends StatefulWidget {
  final String membersId;
  const Mentordshboard({required this.membersId, Key? key}) : super(key: key);

  @override
  _MentordshboardState createState() => _MentordshboardState();
}

class _MentordshboardState extends State<Mentordshboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border.all(color: Colors.black, width: 1),
          ),
          child: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white70,
            ),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.black,
            elevation: 8,
            toolbarHeight: 60,
            centerTitle: true,
            title: const Text("Home",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white70)),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(membersId: widget.membersId),
                    ),
                  );
                },
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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 110,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Mentor',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    alignment: Alignment.topCenter,
                    icon: Icon(
                      Icons.message,
                      size: 24,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Flexible(
              child: GridView.count(
                childAspectRatio: 1.0,
                padding: EdgeInsets.only(left: 16, right: 16),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 9, 7, 7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Eventspage()));
                      },
                      icon: gridItem("assets/images/event.png", "Add events"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 9, 7, 7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DisplayEventsForPresident()));
                      },
                      icon: gridItem(
                          "assets/images/view_events.png", "View events"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 9, 7, 7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ApproveEventRequest()));
                      },
                      icon: gridItem("assets/images/approve_event_requests.png",
                          "Approve event requests"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 9, 7, 7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ApproveEventParticipationRequest()));
                      },
                      icon: gridItem(
                          "assets/images/approve_event_participation_requests.png",
                          "Approve event participation requests"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 9, 7, 7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UploadAndDisplayImages()));
                      },
                      icon: gridItem("assets/images/picture_upload.png",
                          "Upload event images"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 9, 7, 7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Sheduleboard()));
                      },
                      icon: gridItem("assets/images/calender.png",
                          "Meeting Shedule Board"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(128, 9, 7, 7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Membersdirectory()));
                      },
                      icon: gridItem("assets/images/meetingsdashboard.png",
                          "Member's Directory"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gridItem(String imagePath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imagePath,
          width: 100,
          height: 100,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
