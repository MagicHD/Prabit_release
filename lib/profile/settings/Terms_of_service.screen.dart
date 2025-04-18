import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart'; // Adjust import if needed
import 'package:google_fonts/google_fonts.dart'; // Adjust import if needed

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  // Optional: Define routeName if using named routes
  // static String routeName = 'termsOfService_screen';
  // static String routePath = '/termsOfServiceScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary, // Example color
        title: Text(
          'Terms of Service',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
            fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
            color: Colors.white, // Example color
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
            useGoogleFonts: GoogleFonts.asMap().containsKey(
                FlutterFlowTheme.of(context).headlineSmallFamily),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Example color
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Terms of Service need to be added here.',
            style: FlutterFlowTheme.of(context).bodyLarge.override(
              fontFamily: FlutterFlowTheme.of(context).bodyLargeFamily,
              color: FlutterFlowTheme.of(context).primaryText, // Example color
              letterSpacing: 0.0,
              useGoogleFonts: GoogleFonts.asMap().containsKey(
                  FlutterFlowTheme.of(context).bodyLargeFamily),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}