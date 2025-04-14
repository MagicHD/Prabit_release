import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart'; // Import RadioButton
// Import RadioButton
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart'; // Import FormFieldController
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Ensure provider is available

// Import Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // If you need user info

import 'support_screen_model.dart';
export 'support_screen_model.dart';

class SupportScreenWidget extends StatefulWidget {
  const SupportScreenWidget({super.key});

  static String routeName = 'supportScreen';
  static String routePath = '/supportScreen';

  @override
  State<SupportScreenWidget> createState() => _SupportScreenWidgetState();
}

class _SupportScreenWidgetState extends State<SupportScreenWidget> {
  late SupportScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SupportScreenModel());

    // Initialize controllers
    _model.emailController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.messageController ??= TextEditingController();
    _model.messageFocusNode ??= FocusNode();

    // Initialize radio button controller
    _model.reasonValueController ??= FormFieldController<String>(null);

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- Firestore Submission Logic ---
  Future<void> _submitSupportMessage() async {
    // Prevent multiple submissions
    if (_model.isSubmitting) return;

    // Validate the form first
    if (_model.validateForm()) {
      setState(() => _model.isSubmitting = true); // Indicate loading/processing

      final reason = _model.reasonValue!;
      final email = _model.emailController!.text;
      final message = _model.messageController!.text;
      final timestamp = FieldValue.serverTimestamp(); // Use server timestamp
      final userId = FirebaseAuth.instance.currentUser?.uid; // Optional: include user ID

      try {
        // Get Firestore instance
        final firestore = FirebaseFirestore.instance;

        // Define the main collection
        final supportCollection = firestore.collection('support');

        // Define the subcollection based on the reason
        // Sanitize reason to be a valid collection ID if necessary (e.g., lowercase, replace spaces)
        final reasonSubcollection = supportCollection.doc(reason.toLowerCase().replaceAll(' ', '_')).collection('messages');

        // Add the new message document
        await reasonSubcollection.add({
          'email': email,
          'message': message,
          'reason': reason, // Store the original reason text
          'timestamp': timestamp,
          'userId': userId, // Optional
          'status': 'new', // Optional: track status
        });

        // --- Success ---
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message sent successfully!'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
        // Optionally clear the form or navigate back
        _model.reasonValueController?.value = null;
        _model.emailController?.clear();
        _model.messageController?.clear();
        setState(() {
          _model.reasonValue = null; // Reset radio button visually if needed
        });
        // context.pop(); // Uncomment to navigate back after success

      } catch (e) {
        // --- Error Handling ---
        print('Error saving to Firestore: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message. Please try again.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      } finally {
        setState(() => _model.isSubmitting = false); // Re-enable button
      }
    } else {
      // --- Validation Failed ---
      // Show a general validation error message if reason is not selected
      if (_model.reasonValue == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a reason for contact.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      } else {
        // Let the TextFormField validators show specific field errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fix the errors in the form.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // Listen to changes in the model if needed (e.g., using context.watch)
    // context.watch<SupportScreenModel>(); // If using Provider directly

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF121212), // Or FlutterFlowTheme.of(context).primaryBackground
        body: SafeArea(
          top: true,
          child: Padding( // Added padding around the main column
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SingleChildScrollView( // Make content scrollable
              child: Form( // Wrap content in a Form widget
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.disabled, // Validate on submit
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Fit content vertically
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText('o9sfq8jn' /* Contact Us */,),
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).headlineMediumFamily),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                child: Text(
                                  FFLocalizations.of(context).getText('oq7lelxo' /* Send us a message... */,),
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                    color: Color(0xFFB0B0B0),
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          icon: Icon(Icons.close, color: Colors.white, size: 24.0,),
                          onPressed: () => context.pop(), // Navigate back
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0), // Spacing

                    // --- Reason for Contact ---
                    Text(
                      FFLocalizations.of(context).getText('n5ja8cbb' /* Reason for contact */,),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).titleMediumFamily),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    FlutterFlowRadioButton(
                      options: [
                        FFLocalizations.of(context).getText('41tnjyyb' /* 📩 Feedback */,),
                        FFLocalizations.of(context).getText('mvmyrkl8' /* ⚠️ Report an issue */,),
                        FFLocalizations.of(context).getText('uly48p0u' /* 📦 Receive personal data */,),
                        FFLocalizations.of(context).getText('0p7uavcm' /* 🗑️ Account deletion */,),
                        FFLocalizations.of(context).getText('hj4wzcaw' /* ➕ Other */,),
                      ].toList(),
                      onChanged: (val) => setState(() => _model.reasonValue = val),
                      controller: _model.reasonValueController!,
                      optionHeight: 35.0, // Adjust height
                      textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: Color(0xFFB0B0B0), // Default text color
                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                      selectedTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).buttonBackground, // Selected text color (blue)
                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                      buttonPosition: RadioButtonPosition.left,
                      direction: Axis.vertical, // Display vertically
                      radioButtonColor: Colors.blue,
                      inactiveRadioButtonColor: Color(0xFFB0B0B0),
                      toggleable: false, // Must select one
                      horizontalAlignment: WrapAlignment.start,
                      verticalAlignment: WrapCrossAlignment.start,
                    ),
                    SizedBox(height: 24.0),

                    // --- Email Input ---
                    Row(
                      children: [
                        Text(
                          FFLocalizations.of(context).getText('jr754jrp' /* Your email address */,),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.white,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText('assaubjl' /* * */,),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Color(0xFFFF5252), // Red asterisk
                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _model.emailController,
                      focusNode: _model.emailFocusNode,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: FFLocalizations.of(context).getText('16s6tuii' /* Enter your email address */,),
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: Color(0xFF757575),
                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).primaryBordercolor, width: 1.0,),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).buttonBackground, width: 1.0,),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder( // Show error border
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0,),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder( // Show error border on focus
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0,),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground, // Use theme color
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: Colors.white,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.blue,
                      validator: _model.emailControllerValidator.asValidator(context),
                    ),
                    SizedBox(height: 24.0),

                    // --- Message Input ---
                    Row( // Add label row for consistency
                      children: [
                        Text(
                          FFLocalizations.of(context).getText('hgwa2li4' /* Your message */,),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.white,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                        ),
                        Text( // Add mandatory asterisk
                          FFLocalizations.of(context).getText('assaubjl' /* * */,),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Color(0xFFFF5252), // Red asterisk
                            useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _model.messageController,
                      focusNode: _model.messageFocusNode,
                      autofocus: false,
                      textInputAction: TextInputAction.done, // Use done for last field
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: FFLocalizations.of(context).getText('gd5ems9f' /* Tell us how we can help... */,),
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: Color(0xFF757575),
                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).primaryBordercolor, width: 1.0,),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).buttonBackground, width: 1.0,),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0,),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: FlutterFlowTheme.of(context).error, width: 1.0,),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: Colors.white,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                      maxLines: 5,
                      minLines: 4,
                      keyboardType: TextInputType.multiline,
                      cursorColor: Colors.blue,
                      validator: _model.messageControllerValidator.asValidator(context),
                      onFieldSubmitted: (_) => _submitSupportMessage(), // Submit on done action
                    ),
                    SizedBox(height: 32.0), // Increased spacing before buttons

                    // --- Action Buttons ---
                    FFButtonWidget(
                      // Disable button while submitting
                      onPressed: _model.isSubmitting ? null : _submitSupportMessage,
                      text: _model.isSubmitting
                          ? 'Sending...' // Show loading text
                          : FFLocalizations.of(context).getText('5vvolqy9' /* Send message */,),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsets.all(8.0),
                        iconPadding: EdgeInsets.zero,
                        color: _model.isSubmitting ? Colors.grey : Colors.blue, // Change color when disabled
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).titleSmallFamily),
                        ),
                        elevation: 0.0,
                        borderSide: BorderSide(color: Colors.transparent, width: 1.0,),
                        borderRadius: BorderRadius.circular(8.0),
                        // Add disabled color state if needed in theme
                        // disabledColor: FlutterFlowTheme.of(context).alternate,
                        // disabledTextColor: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                    SizedBox(height: 16.0), // Spacing between buttons
                    FFButtonWidget(
                      onPressed: () => context.pop(), // Cancel button just pops the screen
                      text: FFLocalizations.of(context).getText('e0rpmxxd' /* Cancel */,),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0, // Standard height
                        padding: EdgeInsets.all(8.0),
                        iconPadding: EdgeInsets.zero,
                        color: Color(0xFF424242), // Dark gray background
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).titleSmallFamily),
                        ),
                        elevation: 0.0,
                        borderSide: BorderSide(color: Colors.transparent, width: 1.0,),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}