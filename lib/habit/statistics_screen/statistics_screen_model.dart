import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'statistics_screen_widget.dart' show StatisticsScreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StatisticsScreenModel extends FlutterFlowModel<StatisticsScreenWidget> {


  final FirebaseAuth _auth = FirebaseAuth.instance; // [cite: 3]
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // [cite: 3]

  // Variables to hold fetched data
  Map<String, int> categoryData = {}; // [cite: 3]
  int totalPostsAmount = 0; // [cite: 3] - Represents Total Check-ins
  int currentStreak = 0; // [cite: 3, 5]
  int highestStreak = 0; // [cite: 3, 5]
  // Note: 'Group Check-ins' needs separate fetching logic if required [cite: 2]
  int groupCheckIns = 0; // Placeholder for Group Check-ins

  bool isLoading = true; // [cite: 3, 4] To track loading state
  String selectedTimePeriod = 'This Week';





  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
