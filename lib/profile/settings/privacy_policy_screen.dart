import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import the webview package
import '/flutter_flow/flutter_flow_theme.dart'; // Assuming you use FlutterFlow themes
import '/flutter_flow/flutter_flow_icon_button.dart'; // Assuming you use FlutterFlow widgets
import 'package:google_fonts/google_fonts.dart'; // If you use Google Fonts

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  // Add a routeName for easy navigation if you use named routes
  static String routeName = 'privacyPolicy';
  static String routePath = '/privacy-policy'; // Define a path if needed

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;
  bool _isLoading = true; // Optional: Add a loading indicator

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000)) // Optional: Set background color
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Optional: Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true; // Start loading
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false; // Finish loading
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Prevent navigation away from the policy if needed
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadFlutterAsset('assets/privacy_policy.html'); // Load your HTML file [cite: 3]
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use your app's theme colors
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary, // Adapt theme color
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton( // Use FlutterFlow back button
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white, // Adapt theme color
            size: 30.0,
          ),
          onPressed: () async {
            context.pop(); // Use FlutterFlow context extension
          },
        ),
        title: Text(
          'Privacy Policy',
          style: FlutterFlowTheme.of(context).headlineMedium.override( // Adapt theme style
            fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
            color: Colors.white,
            fontSize: 22.0,
            letterSpacing: 0.0,
            useGoogleFonts: GoogleFonts.asMap().containsKey(
                FlutterFlowTheme.of(context).headlineMediumFamily),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0, // Adapt theme elevation
      ),
      body: SafeArea(
        top: true,
        child: Stack( // Use Stack to show loading indicator overlay
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) // Show indicator while loading
              Center(
                child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).primary, // Use theme color
                ),
              ),
          ],
        ),
      ),
    );
  }
}