import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calender_model.dart';
export 'calender_model.dart';

// Added imports for local file access
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class CalenderWidget extends StatefulWidget {
  const CalenderWidget({
    super.key,
    // Changed to DateTime to easily format the filename
    required this.date,
  });

  // Changed from String day to DateTime date
  final DateTime date;

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  late CalenderModel _model;
  // State variable to hold the image file
  File? _imageFile;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalenderModel());
    // Load the image when the widget is initialized
    _loadImageForDay();
  }

  // Function to load image from local storage, adapted from habit_calendarScreen.txt [cite: 5]
  Future<void> _loadImageForDay() async {
    try {
      final directory = await getApplicationDocumentsDirectory(); // [cite: 5]
      final imageDirPath = directory.path; // [cite: 6]
      // Format the date part of the filename like in habit_calendarScreen.txt [cite: 10]
      final dateString = DateFormat('yyyy_M_d').format(widget.date);
      final expectedFileName = 'Photo_${dateString}.jpg'; // [cite: 8, 10]
      final filePath = '$imageDirPath/$expectedFileName';
      final file = File(filePath);

      // Check if the file exists before trying to load it
      if (await file.exists()) { // [cite: 7] equivalent check
        setState(() {
          _imageFile = file; // [cite: 12] storing the file reference
        });
      } else {
        // Optionally handle the case where the image doesn't exist
        print('Image not found for date: $dateString');
        setState(() {
          _imageFile = null;
        });
      }
    } catch (e) {
      print('Error loading image for ${widget.date.toIso8601String()}: $e'); // [cite: 14]
      setState(() {
        _imageFile = null;
      });
    }
  }


  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the day number from the DateTime object
    final String dayOfMonth = widget.date.day.toString();

    return Container(
      width: 45.0,
      height: 45.0,
      decoration: BoxDecoration(
        // Using a slightly transparent background in case image fails to load
          color: _imageFile == null ? FlutterFlowTheme.of(context).secondaryBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate, // Add a subtle border
            width: 0.5,
          )
      ),
      child: Stack(
        children: [
          // Conditionally display Image.file if _imageFile is not null [cite: 32]
          if (_imageFile != null)
            Positioned.fill( // Use Positioned.fill to make image cover the container
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                // Use Image.file to load from local storage [cite: 32]
                child: Image.file(
                  _imageFile!,
                  width: double.infinity, // Ensure it tries to fill width
                  height: double.infinity, // Ensure it tries to fill height
                  fit: BoxFit.cover, // Cover the area
                  // Optional: Add error handling for image loading itself
                  errorBuilder: (context, error, stackTrace) {
                    print("Error loading image file: $error");
                    return Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 20)); // Placeholder on error
                  },
                ),
              ),
            ),
          // Display the day number
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(4.0, 2.0, 0.0, 0.0), // Adjusted padding slightly
            child: Text(
              dayOfMonth, // Use the extracted day number
              style: FlutterFlowTheme.of(context).bodySmall.override( // Adjusted text style for potentially better fit
                fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                letterSpacing: 0.0,
                // Make text slightly more visible over images
                color: _imageFile != null ? Colors.white : FlutterFlowTheme.of(context).primaryText,
                fontWeight: FontWeight.bold,
                shadows: _imageFile != null ? [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 2)] : [], // Add shadow if image exists
                useGoogleFonts: GoogleFonts.asMap().containsKey(
                    FlutterFlowTheme.of(context).bodySmallFamily),
              ),
            ),
          ),
        ],
      ),
    );
  }
}