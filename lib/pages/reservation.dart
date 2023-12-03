import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reservation/pages/search.dart';

import '../models/reserva<tion.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  int numberOfGuests = 2; // Default number of guests
  //editing controllers
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Form'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             TextField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: name
            ),
             TextField(
              decoration: InputDecoration(labelText: 'Phone'),
              controller: phone
            ),
             TextField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: email
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                      ),
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Time',
                      ),
                      child: Text(
                        "${selectedTime.format(context)}",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('Number of Guests:'),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: numberOfGuests,
                  onChanged: (value) {
                    setState(() {
                      numberOfGuests = value!;
                    });
                  },
                  items: [2, 4, 6, 8]
                      .map((guests) => DropdownMenuItem<int>(
                            value: guests,
                            child: Text('$guests'),
                          ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                postReservationToFirestore();
                // Implement reservation logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  SearchResultScreen(name: name.text, phone: phone.text, email: email.text, numberOfGuests: numberOfGuests,),
                  ),
                );
              },
              child: const Text('Search Tables'),
            ),
          ],
        ),
      ),
    );
  }
  void postReservationToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create a reservation object with the selected details
      Reservation reservation = Reservation(
        name: name.text,
        phone: phone.text,
        email: email.text,
        date: selectedDate,
        time: selectedTime,
        numberOfGuests: numberOfGuests,
      );

      // Convert reservation object to a map
      Map<String, dynamic> reservationMap = reservation.toMap();

      // Add the reservation to Firestore
      await firebaseFirestore.collection('reservations').add({
        'userId': user.uid,
        ...reservationMap,
      });
    }
  }

}
