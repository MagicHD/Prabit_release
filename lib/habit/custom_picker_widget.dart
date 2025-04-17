// lib/components/custom_time_picker_widget.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prabit_design/flutter_flow/flutter_flow_theme.dart'; // Make sure this path is correct
import 'package:prabit_design/flutter_flow/flutter_flow_widgets.dart'; // Make sure this path is correct

class CustomTimePickerPopup extends StatefulWidget {
  final TimeOfDay? initialTime;

  const CustomTimePickerPopup({
    Key? key,
    this.initialTime,
  }) : super(key: key);

  @override
  _CustomTimePickerPopupState createState() => _CustomTimePickerPopupState();
}

class _CustomTimePickerPopupState extends State<CustomTimePickerPopup> {
  late int _selectedHour;
  late int _selectedMinute;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    // Initialize with initialTime or a default (e.g., current time or 08:00)
    final initial = widget.initialTime ?? TimeOfDay.now();
    _selectedHour = initial.hour;
    _selectedMinute = initial.minute;

    // Create scroll controllers to set initial values
    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  // Helper to build picker items with leading zeros and theme color
  Widget _buildPickerItem(BuildContext context, int value) {
    return Center(
      child: Text(
        value.toString().padLeft(2, '0'),
        style: TextStyle(
          color: FlutterFlowTheme.of(context).info, // Use theme text color
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    const double pickerHeight = 150.0; // Height of the scrolling wheels
    const double itemExtent = 40.0; // Height of each item in the wheels

    return Dialog(
      backgroundColor: theme.secondaryBackground, // Dialog background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for Dialog sizing
          children: [
            Text(
              'Select Time', // Title
              style: theme.headlineSmall.override(
                fontFamily: theme.headlineSmallFamily,
                color: theme.info,
                letterSpacing: 0.0,
                useGoogleFonts: false, // Assuming default system font or matching FF setup
              ),
            ),
            const SizedBox(height: 20),
            // Pickers Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hour Picker
                SizedBox(
                  width: 70, // Width for hour picker
                  height: pickerHeight,
                  child: CupertinoPicker(
                    scrollController: _hourController,
                    itemExtent: itemExtent,
                    magnification: 1.1, // Slight zoom effect
                    useMagnifier: true,
                    looping: true, // Hours loop 0-23
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedHour = index;
                      });
                    },
                    children: List<Widget>.generate(24, (int index) {
                      return _buildPickerItem(context, index); // 0 to 23
                    }),
                  ),
                ),
                // Colon Separator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.info,
                    ),
                  ),
                ),
                // Minute Picker
                SizedBox(
                  width: 70, // Width for minute picker
                  height: pickerHeight,
                  child: CupertinoPicker(
                    scrollController: _minuteController,
                    itemExtent: itemExtent,
                    magnification: 1.1,
                    useMagnifier: true,
                    looping: true, // Minutes loop 0-59
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedMinute = index;
                      });
                    },
                    children: List<Widget>.generate(60, (int index) {
                      return _buildPickerItem(context, index); // 0 to 59
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                FFButtonWidget(
                  onPressed: () {
                    Navigator.pop(context); // Return null implicitly
                  },
                  text: 'Cancel',
                  options: FFButtonOptions(
                    width: 100, // Adjust width if needed
                    height: 40,
                    color: theme.secondaryBackground,
                    textStyle: theme.titleSmall.override(
                      fontFamily: theme.titleSmallFamily,
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: theme.alternate,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                // Confirm Button
                FFButtonWidget(
                  onPressed: () {
                    final selectedTime = TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
                    Navigator.pop(context, selectedTime); // Return selected TimeOfDay
                  },
                  text: 'Confirm',
                  options: FFButtonOptions(
                    width: 100, // Adjust width if needed
                    height: 40,
                    color: theme.buttonBackground, // Use your primary button color
                    textStyle: theme.titleSmall.override(
                      fontFamily: theme.titleSmallFamily,
                      color: theme.info, // Use contrasting text color
                      letterSpacing: 0.0,
                      useGoogleFonts: false,
                    ),
                    elevation: 2,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}