import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ReadNow extends StatefulWidget {
  final String pdfUrl;

  ReadNow({required this.pdfUrl});

  @override
  _ReadNowState createState() => _ReadNowState();
}

class _ReadNowState extends State<ReadNow> {
  String? localFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadAndLoadPDF();
  }

  Future<void> downloadAndLoadPDF() async {
    try {
      final url = widget.pdfUrl;
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/tempFile.pdf');
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          localFilePath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Read Now',
          style: GoogleFonts.merriweather(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
      ),
      body: Stack(
        children: [
          if (localFilePath != null)
            PDFView(
              filePath: localFilePath!,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (_) {
                setState(() {
                  isLoading = false;
                });
              },
              onError: (error) {
                print('Error rendering PDF: $error');
              },
            ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
