import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class Eventspage extends StatefulWidget {
  const Eventspage({Key? key}) : super(key: key);

  @override
  _EventspageState createState() => _EventspageState();
}

class _EventspageState extends State<Eventspage> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _orgController = TextEditingController();
  final _timeController = TextEditingController();
  final _budgetController = TextEditingController();
  final _venueController = TextEditingController();
  final _descController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
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
              "Event Creation",
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
            actions: <Widget>[
              IconButton(
                onPressed: () {},
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 130, 20, 0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      buildTextField(_nameController, 'Event Name'),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: buildTextField(_dateController, 'Date'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _selectTime(context),
                        child: AbsorbPointer(
                          child: buildTextField(_timeController, 'Time'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildTextField(_orgController, 'Organizer'),
                      const SizedBox(height: 20),
                      buildTextField(_budgetController, 'Budget'),
                      const SizedBox(height: 20),
                      buildTextField(_venueController, 'Venue'),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _descController,
                        cursorColor: Colors.white,
                        maxLength: 500,
                        maxLines: null,
                        style: TextStyle(color: Colors.white.withOpacity(0.9)),
                        decoration: InputDecoration(
                          labelText: 'Event Description',
                          labelStyle:
                              TextStyle(color: Colors.white.withOpacity(0.9)),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 150,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90)),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_descController.text.split(' ').length > 500) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Description exceeds 500 words limit.'),
                                ),
                              );
                              return;
                            }

                            Map<String, dynamic> eventmap = {
                              'Event Name': _nameController.text,
                              'Date': _dateController.text,
                              'Organizer': _orgController.text,
                              'Time': _timeController.text,
                              'Budget': _budgetController.text,
                              'Venue': _venueController.text,
                              'Description': _descController.text,
                              'Approval_status': true,
                            };

                            final collection =
                                FirebaseFirestore.instance.collection('events');
                            await collection.doc().set(eventmap);

                            setState(() {
                              _nameController.clear();
                              _dateController.clear();
                              _orgController.clear();
                              _timeController.clear();
                              _budgetController.clear();
                              _venueController.clear();
                              _descController.clear();
                            });

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
                                      contentPadding:
                                          const EdgeInsets.all(20.0),
                                      content: const Text(
                                          "Event added successfully!!"),
                                    ));
                          },
                          child: Text('Add',
                              style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.black26;
                              }
                              return Colors.blue;
                            }),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
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
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none),
        ),
      ),
    );
  }
}
