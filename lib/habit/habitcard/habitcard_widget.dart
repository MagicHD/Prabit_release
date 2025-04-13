import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'habitcard_model.dart';
export 'habitcard_model.dart';

class HabitcardWidget extends StatefulWidget {
  const HabitcardWidget({
    super.key,
    required this.habitName, // <-- Add parameter
    required this.habitTime, // <-- Add parameter
    required this.habitIconCode, // <-- Add parameter (e.g., FontAwesome code point)
    required this.habitIconFontFamily, // <-- Add parameter (e.g., 'FontAwesomeSolid')
    required this.selectedDays, // <-- Add parameter (List<int> or similar)
    required this.habitColor, // <-- Keep or modify as needed
  });

  final String habitName; // <-- Define type
  final String habitTime; // <-- Define type
  final int habitIconCode; // <-- Define type
  final String habitIconFontFamily; // <-- Define type
  final List<dynamic> selectedDays; // <-- Define type (use List<int> if possible)
  final Color habitColor;

  @override
  State<HabitcardWidget> createState() => _HabitcardWidgetState();
}

class _HabitcardWidgetState extends State<HabitcardWidget> {
  late HabitcardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HabitcardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  IconData _getIconData(int code, String fontFamily) {
    if (fontFamily == 'FontAwesomeSolid') {
      return IconData(code, fontFamily: fontFamily, fontPackage: 'font_awesome_flutter');
    }
    // Add conditions for other icon families if needed
    return Icons.help_outline; // Default icon
  }

  @override
  Widget build(BuildContext context) {

    final dayMap = {1: 'M', 2: 'T', 3: 'W', 4: 'T', 5: 'F', 6: 'S', 7: 'S'}; // Or Mon, Tue etc.



    return Container(
      width: 190.0,
      height: 190.0,
      decoration: BoxDecoration(
        color: widget.habitColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Use dynamic icon
                Icon(
                  _getIconData(widget.habitIconCode, widget.habitIconFontFamily), // <-- Use helper
                  color: Colors.white,
                  size: 24.0,
                ),
                // Keep the options menu, potentially adding onTap logic later
                Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 24.0,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 2.0),
              child: Text(
                  widget.habitName,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).titleMediumFamily,
                      color: Colors.white,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).titleMediumFamily),
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
              child: Text(
                widget.habitTime,
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                      color: Color(0xCCFFFFFF),
                      letterSpacing: 0.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodySmallFamily),
                    ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 8.0, 0.0),
                // Use dynamic days
                child: GridView.builder( // <-- Use GridView.builder for dynamic days
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 days
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 3.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 7, // Always 7 days
                  shrinkWrap: true, // Important within a Column
                  physics: NeverScrollableScrollPhysics(), // Disable scroll within card
                  itemBuilder: (context, index) {
                    int dayNum = index + 1;
                    bool isActive = widget.selectedDays.contains(dayNum); // Check if day is selected

                    // Function to generate lighter color (from habit_selectionScreen.txt [cite: 79])
                    Color generateLighterColor(Color baseColor) {
                      HSLColor hsl = HSLColor.fromColor(baseColor);
                      return hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
                    }

                    return Container(
                      width: 5.0, // Adjust size as needed
                      decoration: BoxDecoration(
                        // Use lighter color based on habit color for active days
                        color: isActive ? generateLighterColor(widget.habitColor).withOpacity(1.0) : widget.habitColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          dayMap[dayNum]!, // Display day letter
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                            // Adjust text opacity based on active state
                            color: Colors.white.withOpacity(isActive ? 1.0 : 0.6),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodySmallFamily),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
