// File: prabit_design/lib/habit/congrats_screen/congrats_screen_widget.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/flutter_flow/flutter_flow_theme.dart'; // Import theme
import '/flutter_flow/flutter_flow_util.dart'; // Import utils
import '/index.dart'; // Import index for routes


class CongratsScreenWidget extends StatefulWidget {
  // Renamed class

  // Optional: Pass streak if calculated beforehand, otherwise fetch here
  final int? initialStreak;

  const CongratsScreenWidget({
    Key? key,
    this.initialStreak
  }) : super(key: key);

  // Define routeName and routePath for navigation
  static const String routeName = 'CongratsScreen';
  static const String routePath = '/congratsScreen';


  @override
  State<CongratsScreenWidget> createState() => _CongratsScreenWidgetState();
}


class _CongratsScreenWidgetState extends State<CongratsScreenWidget> {
  int _streak = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialStreak != null) {
      _streak = widget.initialStreak!;
      _loading = false;
    } else {
      _fetchStreak();
    }
  }

  Future<void> _fetchStreak() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if(mounted) setState(() => _loading = false);
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      final userDoc = await userRef.get();
      if (userDoc.exists && mounted) {
        setState(() {
          _streak = userDoc.data()?['streak'] ?? 0;
          _loading = false;
        });
      } else if (mounted) {
        setState(() => _loading = false); // Handle case where user doc might not exist yet
      }
    } catch (e) {
      print('Error fetching streak: $e');
      if(mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder for a nice graphic/icon
              Icon(Icons.celebration, size: 80, color: Color(0xFF2E7D32)),
              const SizedBox(height: 24),
              Text(
                'Great Job!',
                style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Inter Tight',
                  color: Color(0xFF2E7D32), // Dark green
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'You completed your habit!', // More generic message
                style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Inter',
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3E0), // Light orange background for streak
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "🔥 Current Streak: $_streak days",
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD84315), // Orange for streak emphasis
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Navigate back to the main flow (e.g., Feed screen)
                  // Use GoRouter's go method to replace the stack up to the feed screen.
                  context.go(FeedscreenWidget.routePath); // Navigate to feed

                  // Or pop until a specific route (less reliable if stack changes)
                  // Navigator.popUntil(context, ModalRoute.withName(HabitSelectionScreenWidget.routeName)); // Or FeedscreenWidget.routeName
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50), // Green button
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Keep Going!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}