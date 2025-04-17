// E.g., in a new file: lib/habit/icon_picker/habit_icon_data.dart
import 'package:flutter/material.dart';

class HabitIconInfo {
  final IconData iconData; // The actual icon (e.g., Icons.sports_soccer)
  final String id;         // The UNIQUE STRING to save (e.g., 'sports_soccer')
  final String name;       // Display name for search (e.g., 'Soccer')
  final String category;   // Category for filtering (e.g., 'Physical')

  const HabitIconInfo({
    required this.iconData,
    required this.id,
    required this.name,
    required this.category,
  });
}

// Define all your available icons here
// --->> IMPORTANT: Use the EXACT string IDs you want saved to Firestore <<---
const List<HabitIconInfo> allHabitIcons = [
  HabitIconInfo(iconData: Icons.directions_run, id: 'directions_run', name: 'Run', category: 'Physical'),
  HabitIconInfo(iconData: Icons.fitness_center, id: 'fitness_center', name: 'Workout', category: 'Physical'),
  HabitIconInfo(iconData: Icons.sports_soccer, id: 'sports_soccer', name: 'Soccer', category: 'Physical'),
  HabitIconInfo(iconData: Icons.sports_tennis, id: 'sports_tennis', name: 'Tennis', category: 'Physical'),
  HabitIconInfo(iconData: Icons.psychology_outlined, id: 'psychology', name: 'Mental', category: 'Mental'),
  HabitIconInfo(iconData: Icons.self_improvement, id: 'self_improvement', name: 'Meditate', category: 'Mindfulness'),
  HabitIconInfo(iconData: Icons.cloud_outlined, id: 'mindfulness', name: 'Mindful', category: 'Mindfulness'),
  HabitIconInfo(iconData: Icons.book, id: 'book', name: 'Read', category: 'Learning'),
  HabitIconInfo(iconData: Icons.school_outlined, id: 'learning', name: 'Study', category: 'Learning'),
  HabitIconInfo(iconData: Icons.code, id: 'code', name: 'Code', category: 'Learning'),
  HabitIconInfo(iconData: Icons.mail_outline_rounded, id: 'social', name: 'Connect', category: 'Social'),
  HabitIconInfo(iconData: Icons.group, id: 'friends', name: 'Friends', category: 'Social'),
  HabitIconInfo(iconData: Icons.monitor_heart, id: 'health', name: 'Health', category: 'Health'),
  // FontAwesome Example (ensure you have font_awesome_flutter dependency)
  // HabitIconInfo(iconData: FontAwesomeIcons.heartPulse, id: 'heart_pulse_fa', name: 'Pulse', category: 'Health'),
  HabitIconInfo(iconData: Icons.music_note_outlined, id: 'creativity', name: 'Music', category: 'Creativity'),
  HabitIconInfo(iconData: Icons.brush, id: 'art', name: 'Art', category: 'Creativity'),
  HabitIconInfo(iconData: Icons.task_alt, id: 'productivity', name: 'Task', category: 'Productivity'),
  HabitIconInfo(iconData: Icons.alarm, id: 'wakeup', name: 'Wake Up', category: 'Productivity'),

  // Add ALL your other icons here...
];

// Helper function to get IconData from the ID string (used in HabitConfigureWidget)
IconData getIconDataById(String? id) {
  if (id == null) return Icons.task_alt; // Default
  return allHabitIcons.firstWhere((iconInfo) => iconInfo.id == id, orElse: () => allHabitIcons.first).iconData;
}

// Helper function to get the categories
List<String> getHabitIconCategories() {
  return allHabitIcons.map((e) => e.category).toSet().toList()..sort();
}