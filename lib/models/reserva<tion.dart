import 'package:flutter/material.dart';

class Reservation {
  late String name;
  late String phone;
  late String email;
  late DateTime date;
  late TimeOfDay time;
  late int numberOfGuests;

  Reservation({
    required this.name,
    required this.phone,
    required this.email,
    required this.date,
    required this.time,
    required this.numberOfGuests,
  });

  // Convert reservation object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'date': date,
      'time': '${time.hour}:${time.minute}', // Store time as a formatted string
      'numberOfGuests': numberOfGuests,
    };
  }
}
