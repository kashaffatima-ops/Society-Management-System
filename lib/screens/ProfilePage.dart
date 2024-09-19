import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopeapp/screens/editProfileData.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class ProfilePage extends StatefulWidget {
  final String membersId;

  const ProfilePage({required this.membersId, Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? membersData;

  @override
  void initState() {
    super.initState();
    _fetchMemberData();
  }

  Future<void> _fetchMemberData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(widget.membersId)
        .get();

    setState(() {
      membersData = documentSnapshot.data() as Map<String, dynamic>?;
    });
  }

  Future<void> _navigateAndUpdateProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Editprofiledata(
          membersId: widget.membersId,
          membersData: membersData!,
        ),
      ),
    );

    _fetchMemberData();
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
              "Profile",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white70,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white70),
                onPressed: () {
                  // Navigate to the Editmembers screen
                  _navigateAndUpdateProfile();
                },
              ),
            ],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white70),
            ),
          ),
        ),
      ),
      body: membersData == null
          ? Center(child: CircularProgressIndicator())
          : Container(
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
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            Colors.black12.withOpacity(0.5))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child:
                                      membersData!['profile'].toString() == ""
                                          ? const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.white,
                                            )
                                          : Image(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  membersData!['profile']),
                                            ),
                                ),
                              ),
                            ),
                            SizedBox(height: 7),
                            _buildProfileField(
                                "Name", membersData!['Name'], Icons.person),
                            SizedBox(height: 7),
                            _buildProfileField(
                                "Email", membersData!['Email'], Icons.email),
                            SizedBox(height: 7),
                            _buildProfileField("Phone Number",
                                membersData!['Phone number'], Icons.phone),
                            SizedBox(height: 7),
                            _buildProfileField(
                                "Post", membersData!['Post'], Icons.work),
                            SizedBox(height: 7),
                            _buildProfileField(
                                "Age", membersData!['Age'], Icons.cake),
                            SizedBox(height: 7),
                            _buildProfileField("Password",
                                membersData!['Password'], Icons.lock),
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

  Widget _buildProfileField(String label, String value, IconData icon) {
    return Column(
      children: [
        ListTile(
          title: Text(
            label,
            style: TextStyle(
              color: Colors.white, // Set title color to white
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: Icon(
            icon,
            color: Colors.white, // Set icon color to white
          ),
          trailing: Text(
            value,
            style: TextStyle(
              color: Colors.white, // Set trailing text color to white
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Divider(color: Colors.white.withOpacity(0.5))
      ],
    );
  }
}
