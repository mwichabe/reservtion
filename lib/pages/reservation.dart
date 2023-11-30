import 'package:flutter/material.dart';
import 'package:reservation/pages/search.dart';

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
        title: Text('Reservation Form'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date',
                      ),
                      child: Text(
                        "${selectedDate.toLocal()}".split(' ')[0],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
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
                Text('Number of Guests:'),
                SizedBox(width: 10),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement reservation logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultScreen(),
                  ),
                );
              },
              child: Text('Search Tables'),
            ),
          ],
        ),
      ),
    );
  }
}
