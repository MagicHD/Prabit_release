import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

import '../../profile/settings/Terms_of_service.screen.dart';
import '../../profile/settings/privacy_policy_screen.dart';
import '../auth_service.dart';
import '../forgot_password_screen/setup_profile_screen/setup_profile_screen.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '/index.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signup_screen_model.dart';
export 'signup_screen_model.dart';

/// The login screen of the Prabit app is designed to be clean, welcoming, and
/// highly accessible.
///
/// It maintains the app’s modern dark theme with bright interactive elements
/// and clear typographic hierarchy, creating a focused and user-friendly
/// entry point. Container & Layout The entire login form is centered within
/// the screen, enclosed in a rounded rectangular card with a slightly lighter
/// black background. This centered card layout provides focus and symmetry,
/// emphasizing the form elements while reducing distractions. Welcome Text At
/// the top of the card, the screen greets the user with: A bold white
/// headline: “Welcome back” A smaller gray subtext: “Sign in to your account
/// to continue” This introductory message is friendly and informative,
/// setting the tone for re-engaging with the app. Input Fields Two form
/// fields follow, both styled with a dark background, rounded corners, and
/// subtle outlines: Email: Label: “Email” in whi te Placeholder:
/// “you@example.com” in a lighter gray Password: Label: “Password” Includes a
/// “Forgot password?” link on the right in bright blue, allowing easy
/// recovery access The fields are minimal, clearly spaced, and provide
/// excellent contrast for readability. Sign In Button Beneath the inputs is
/// the primary sign-in button: Full-width, rectangular with rounded edges
/// Bright blue background and white text: “Sign in” Provides a strong
/// call-to-action with high visibility Divider A slim horizontal divider with
/// the text “— OR —” separates standard login from the alternative method,
/// visually breaking up the flow without clutter. Google Sign-In Button Below
/// the divider is a secondary button for social login: “Sign in with Google”
/// appears in black text on a white background Includes the Google “G” logo
/// for instant recognition Rounded and full-width, providing a familiar and
/// frictionless alternative to email/password login Sign-Up Prompt At the
/// bottom of the form, a simple prompt is included: “Don’t have an account?
/// Create an account” The “Create an account” link is styled in blue,
/// encouraging new users to sign up while staying visually consistent with
/// the rest of the screen. Summary The login screen in Prabit is intuitive,
/// polished, and thoughtfully designed. It offers multiple sign-in options,
/// error prevention through “forgot password,” and a clear path to
/// registration—all within a visually harmonious dark theme. The use of
/// color, spacing, and typography ensures excellent accessibility while
/// maintaining a welcoming and professional appearance.
class SignupScreenWidget extends StatefulWidget {
  const SignupScreenWidget({super.key});

  static String routeName = 'signup_screen';
  static String routePath = '/signupScreen';

  @override
  State<SignupScreenWidget> createState() => _SignupScreenWidgetState();
}

class _SignupScreenWidgetState extends State<SignupScreenWidget> {
  late SignupScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _dateOfBirth;

  final AuthService _authService = AuthService(); // Instantiate AuthService
  bool _isLoading = false; // Add loading state
  bool _termsAccepted = false; // State for terms checkbox


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignupScreenModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textFieldFocusNode4?.addListener(_onBirthdayFocus);

  }

  @override
  void dispose() {
    _model.textFieldFocusNode4?.removeListener(_onBirthdayFocus); // Clean up listener

    _model.dispose();

    super.dispose();
  }


  // --- Add Date Picker Logic (optional but good UX) ---
  void _onBirthdayFocus() {
    if (_model.textFieldFocusNode4?.hasFocus ?? false) {
      _selectDate(context);
      // Immediately unfocus to prevent keyboard from appearing
      FocusScope.of(context).requestFocus(new FocusNode());
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _model.datePicked ?? DateTime.now().subtract(Duration(days: 13 * 365)), // Default ~13 years ago
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _model.datePicked) {
      setState(() {
        _model.datePicked = picked;
        // Update the text field to show the picked date
        _model.textController4.text = DateFormat.yMd().format(picked); // Use intl package format
      });
    }
  }
  // --- End Date Picker Logic ---


  // --- Add Sign Up Method ---
  Future<void> _signUpUser() async {
    if (_isLoading) return;

    final email = _model.textController1.text.trim();
    final password = _model.textController2.text.trim();
    final username = _model.textController3.text.trim();
    // final birthdayString = _model.textController4.text.trim(); // Get birthday if needed
    // final DateTime? dob = _model.datePicked; // Use the picked date


    // Basic Validation
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields (Email, Password, Username).')),
      );
      return;
    }
    // Add more validation here if needed (password complexity, username check, age check from dob)
    // Example Age Check (requires _model.datePicked to be set)
    // if (dob == null) { ... show error ... return; }
    // final age = DateTime.now().difference(dob).inDays / 365;
    // if (age < 13) { ... show error ... return; }


    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept the Terms of Service and Privacy Policy.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    User? user = await _authService.signUp(email, password, username, context);

    if (user != null) {
      // --- MODIFIED NAVIGATION ---
      context
          .pushNamed(SetupProfileScreenWidget.routeName);
      // Or use goNamed if you prefer its behavior (often replaces stack too)
      // context.goNamed(SetupProfileScreenWidget.routeName);
      // --- END MODIFICATION ---
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
  // --- End Sign Up Method ---


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF14181B),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 70.0, 0.0, 0.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF14181B),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    '0gosyzd4' /* Create an account */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .headlineMediumFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .headlineMediumFamily),
                                      ),
                                ),
                                Text(
                                  FFLocalizations.of(context).getText(
                                    'ks8yv9hy' /* Enter your details to create y... */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF8B8B8B),
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ].divide(SizedBox(height: 8.0)),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'ojp7acfq' /* Email */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .labelMediumFamily,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily),
                                          ),
                                    ),
                                    TextFormField(
                                      controller: _model.textController1,
                                      focusNode: _model.textFieldFocusNode1,
                                      autofocus: false,
                                      textInputAction: TextInputAction.next,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText:
                                            FFLocalizations.of(context).getText(
                                          'wsj30c4x' /* you@example.com */,
                                        ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF8B8B8B),
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF3A3A3A),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFF252A30),
                                        contentPadding: EdgeInsets.all(16.0),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                      keyboardType: TextInputType.emailAddress,
                                      cursorColor: Color(0xFF39D2C0),
                                      validator: _model.textController1Validator
                                          .asValidator(context),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'vbjj43ng' /* Password */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily),
                                              ),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _model.textController2,
                                      focusNode: _model.textFieldFocusNode2,
                                      autofocus: false,
                                      textInputAction: TextInputAction.done,
                                      obscureText: !_model.passwordVisibility,
                                      decoration: InputDecoration(
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF8B8B8B),
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF3A3A3A),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFF252A30),
                                        contentPadding: EdgeInsets.all(16.0),
                                        suffixIcon: InkWell(
                                          onTap: () => safeSetState(
                                            () => _model.passwordVisibility =
                                                !_model.passwordVisibility,
                                          ),
                                          focusNode:
                                              FocusNode(skipTraversal: true),
                                          child: Icon(
                                            _model.passwordVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                      cursorColor: Color(0xFF39D2C0),
                                      validator: _model.textController2Validator
                                          .asValidator(context),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'i1q7x8uh' /* Username */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMediumFamily,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMediumFamily),
                                              ),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _model.textController3,
                                      focusNode: _model.textFieldFocusNode3,
                                      autofocus: false,
                                      textInputAction: TextInputAction.done,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF8B8B8B),
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFF3A3A3A),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFF252A30),
                                        contentPadding: EdgeInsets.all(16.0),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily),
                                          ),
                                      cursorColor: Color(0xFF39D2C0),
                                      validator: _model.textController3Validator
                                          .asValidator(context),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                                // --- Birthday Field (Consider using showDatePicker) ---
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        'jvdw5o21' /* Birthday */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium.override(
                                        fontFamily: 'Manrope',
                                        color: Colors.white, // Adjusted color
                                        // ... rest of style
                                      ),
                                    ),
                                    InkWell( // Wrap TextField in InkWell to trigger date picker
                                      onTap: () => _selectDate(context),
                                      child: IgnorePointer( // Use IgnorePointer to prevent keyboard pop-up
                                        child: TextFormField(
                                          controller: _model.textController4, // Use the controller
                                          focusNode: _model.textFieldFocusNode4, // Use the focus node
                                          readOnly: true, // Make it read-only as value comes from picker
                                          // ... rest of decoration, style, validator
                                          decoration: InputDecoration(
                                            hintText: FFLocalizations.of(context).getText(
                                              'domcoetw' /* Select Birthday */, // Better hint
                                            ),
                                            // ... rest of decoration
                                            suffixIcon: Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        '6h79a6k1' /* You must be at least 13 years ... */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .labelSmall.override(
                                        fontFamily: 'Manrope',
                                        color: Colors.white,
                                        //...
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 4.0)),
                                ),
                                // --- UPDATE Terms of Service Checkbox ---
                                Container(
                                  // ... (existing decoration)
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Theme( // Wrap Checkbox with Theme to style it
                                          data: ThemeData(unselectedWidgetColor: FlutterFlowTheme.of(context).secondaryText), // Style unchecked color
                                          child: Checkbox(
                                            value: _termsAccepted,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                _termsAccepted = value!;
                                              });
                                            },
                                            activeColor: FlutterFlowTheme.of(context).buttonBackground, // Style checked color
                                            checkColor: Colors.white, // Style check mark color
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Removed the clickable Text, using checkbox state now
                                              RichText(
                                                textScaler:
                                                MediaQuery.of(context).textScaler,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: FFLocalizations.of(context).getText(
                                                        'm5an2ndx' /* By creating an account, you agree to the */,
                                                      ),
                                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                                          fontFamily: 'Manrope', color: Colors.white // Ensure style consistency
                                                      ),
                                                    ),
                                                    // Inside the RichText widget's TextSpan children list:
                                                    TextSpan(
                                                      text: FFLocalizations.of(context).getText(
                                                        'rbbty9tw' /* Terms of Service */,
                                                      ),
                                                      style: TextStyle(
                                                        color: FlutterFlowTheme.of(context).buttonBackground, // Use theme color
                                                        // decoration: TextDecoration.underline, // Add underline if desired
                                                      ),
                                                      recognizer: TapGestureRecognizer()
                                                        ..onTap = () {
                                                          // --- MODIFIED ACTION ---
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => TermsOfServiceScreen()),
                                                          );
                                                          // Alternatively, if using named routes with go_router:
                                                          // context.pushNamed(TermsOfServiceScreen.routeName); // Ensure routeName is defined in TermsOfServiceScreen
                                                          // --- END MODIFICATION ---
                                                          // print('Terms of Service tapped'); // Original action (can be removed)
                                                        },
                                                    ),
                                                    TextSpan(
                                                      text: FFLocalizations.of(context).getText(
                                                        'x5cnfgpw' /* and */,
                                                      ),
                                                      style: FlutterFlowTheme.of(context).labelSmall.override(
                                                          fontFamily: 'Manrope', color: Colors.white
                                                      ),
                                                    ),
                                                    // Inside the RichText widget's TextSpan children list:
                                                    TextSpan(
                                                      text: FFLocalizations.of(context).getText(
                                                        'hqpvp9r0' /* Privacy Policy */,
                                                      ),
                                                      style: TextStyle(
                                                        color: FlutterFlowTheme.of(context).buttonBackground, // Use theme color
                                                        // decoration: TextDecoration.underline,
                                                      ),
                                                      recognizer: TapGestureRecognizer()
                                                        ..onTap = () {
                                                          // --- MODIFIED ACTION ---
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                                                          );
                                                          // Alternatively, if using named routes with go_router:
                                                          // context.pushNamed(PrivacyPolicyScreen.routeName); // Ensure routeName is defined in PrivacyPolicyScreen
                                                          // --- END MODIFICATION ---
                                                          // print('Privacy Policy tapped'); // Original action (can be removed)
                                                        },
                                                    )
                                                  ],
                                                  style: FlutterFlowTheme.of(context).labelSmall.override(
                                                      fontFamily: 'Manrope', color: Colors.white
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)), // Keep divider if needed
                                    ),
                                  ),
                                ),

                                // --- UPDATE Sign up Button ---
                                FFButtonWidget(
                                  onPressed: _signUpUser, // Call the sign-up method
                                  text: _isLoading ? 'Creating Account...' : FFLocalizations.of(context).getText( // Show loading state
                                    'rm8reted' /* Sign up */, // Corrected text from 'Sign in'
                                  ),
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    // ... (rest of the options are fine)
                                    disabledColor: Colors.grey, // Optional loading style
                                    disabledTextColor: Colors.white70, // Optional
                                  ),
                                  showLoadingIndicator: _isLoading, // Show indicator on button
                                ),
                              ].divide(SizedBox(height: 16.0)),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  FFLocalizations.of(context).getText(
                                    '14vmfpv5' /* Already have an account?  */,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Color(0xFF8B8B8B),
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context
                                        .pushNamed(LoginScreenWidget.routeName);
                                  },
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'e1xg9tab' /* Sign in */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color: FlutterFlowTheme.of(context)
                                              .buttonBackground,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ].divide(SizedBox(height: 24.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
