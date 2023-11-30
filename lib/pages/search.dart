import 'package:flutter/material.dart';
import 'package:reservation/pages/receiptScreen.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<int> availableTables = [
    2,
    4,
    6,
    8
  ]; // Replace with actual available tables
  List<int> selectedTables = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Tables:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 10.0,
              children: availableTables
                  .map((table) => ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (selectedTables.contains(table)) {
                              selectedTables.remove(table);
                            } else {
                              selectedTables.add(table);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: selectedTables.contains(table)
                              ? Colors.green
                              : Colors.blue,
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        child: Text(
                          '$table',
                          style: TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement reservation confirmation logic
                if (selectedTables.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Reservation Confirmation'),
                        content: Text('Tables reserved: $selectedTables'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Navigate to the receipt screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReceiptScreen(
                                    selectedTables: selectedTables,
                                    // Pass other reservation details to the receipt screen
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select at least one table.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: Text(
                'Confirm Reservation',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
