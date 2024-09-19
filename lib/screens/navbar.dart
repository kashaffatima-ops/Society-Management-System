import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';
import 'package:hopeapp/screens/ourStory.dart';
import 'package:hopeapp/screens/startingPage.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Saim Naveen"),
            accountEmail: Text("saim@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset("assets/images/user.png")),
            ),
            decoration: BoxDecoration(
              color: colorchanger('#A70052'),
            ),
          ),
          ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              onTap: () {}),
          ListTile(
              leading: Icon(Icons.sports_esports),
              title: Text("Our story"),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Ourstory()))),
          ListTile(
              leading: Icon(Icons.help), title: Text("Help"), onTap: () {}),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {}),
          ListTile(
              leading: Icon(Icons.share), title: Text("Share"), onTap: () {}),
          ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sign out"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Startingpage()),
                );
              }),
        ],
      ),
    );
  }
}
