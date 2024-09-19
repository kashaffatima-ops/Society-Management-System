import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hopeapp/screens/hashcolorchanger.dart';

class EditEvent extends StatefulWidget {
  final String eventId;
  final Map<String, dynamic> eventData;

  const EditEvent({required this.eventId, required this.eventData, Key? key})
      : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _orgController = TextEditingController();
  final _timeController = TextEditingController();
  final _budgetController = TextEditingController();
  final _venueController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.eventData['Event Name'];
    _dateController.text = widget.eventData['Date'];
    _orgController.text = widget.eventData['Organizer'];
    _timeController.text = widget.eventData['Time'];
    _budgetController.text = widget.eventData['Budget'];
    _venueController.text = widget.eventData['Venue'];
    _descController.text = widget.eventData['Description'];
  }

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

  Future<void> _updateEvent() async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .update({
      'Event Name': _nameController.text,
      'Date': _dateController.text,
      'Organizer': _orgController.text,
      'Time': _timeController.text,
      'Budget': _budgetController.text,
      'Venue': _venueController.text,
      'Description': _descController.text,
    });

    Navigator.pop(context);
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
              "Edit Event",
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 150, 20, 20),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Event Name',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _dateController,
                        style: TextStyle(color: Colors.white70),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _orgController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Organizer',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _timeController,
                        style: TextStyle(color: Colors.white70),
                        readOnly: true,
                        onTap: () => _selectTime(context),
                        decoration: InputDecoration(
                          labelText: 'Time',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _budgetController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Budget',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _venueController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Venue',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _descController,
                        style: TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: Text('Update Event'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 229, 107, 147),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                _updateEvent();
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
                                              "Successfully updated event!!"),
                                        ));
                              }),
                          SizedBox(width: 20),
                          ElevatedButton(
                              child: Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 229, 107, 147),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
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
}
