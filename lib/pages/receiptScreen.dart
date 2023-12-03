import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReceiptScreen extends StatelessWidget {
  final List<int> selectedTables;
  final String name;
  final String phone;
  final String email;
  final int numberOfGuests;




  const ReceiptScreen({Key? key, required this.selectedTables, required this.name, required this.phone, required this.email, required this.numberOfGuests})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation Receipt'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reservation Receipt',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Table(s) Reserved:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              selectedTables.join(", "),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Reservation Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),
            Text('Date: ${DateTime.now().toLocal()}'),
            Text('Name: $name'),
            Text('Number of Guests: $numberOfGuests'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to go back to the home screen or navigate to a new reservation
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );

  }

  Future<void> generateAndSavePDF(List<int> selectedTables) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Table(s) Reserved: ${selectedTables.join(", ")}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Reservation Details:',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
                pw.SizedBox(height: 8),
                // Example details, replace with your actual reservation details
                pw.Text('Date: ${DateTime.now().toLocal()}'),
                pw.Text('Guest Name: Your name'),
                pw.Text('Number of guests: 4'),
              ],
            );
          },
        ),
      );

      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/reservation_receipt.pdf';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      print('PDF generated successfully! Path: $filePath');

      // opening the file picker
      final result = await FilePicker.platform.saveFile(
        allowedExtensions: ['pdf'],
        fileName: 'reservation_receipt',
        initialDirectory: directory.path,
      );
    } catch (e) {
      print('Error generating PDF: $e');
    }
  }
}
