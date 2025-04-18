import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart'; // Keep FlutterFlow index if needed

// ---- Imports needed for Group Creation & Habit Config ----
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For DateFormat
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For FaIcon if used

// Import necessary helper widgets (Ensure these files exist and paths are correct)
import '../../habit/custom_picker_widget.dart';
import '../../habit/icon/icon_picker_widget.dart';
// ---- End of imports ----

import 'group_creation2_model.dart';
export 'group_creation2_model.dart';

class GroupCreation2Widget extends StatefulWidget {
  const GroupCreation2Widget({super.key});

  static String routeName = 'group_creation_2';
  static String routePath = '/groupCreation2';

  @override
  State<GroupCreation2Widget> createState() => _GroupCreation2WidgetState();
}

class _GroupCreation2WidgetState extends State<GroupCreation2Widget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // --- State variables for Group Details ---
  String _groupName = '';
  String _groupCode = '';
  String _groupId = '';
  String _groupType = 'Public - Instant Join';
  String? _groupImageUrl;
  File? _selectedImage;
  String _groupBio = '';

  // --- State variables for Habit Details ---
  String _habitName = '';
  DateTime? _selectedTime;
  Map<String, bool> _selectedDays = {
    'Mon': false, 'Tue': false, 'Wed': false, 'Thu': false, 'Fri': false, 'Sat': false, 'Sun': false,
  };
  Color? _selectedColor;
  IconData? _selectedIcon;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateGroupCode();
    _generateGroupId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // --- Helper Functions ---
  String _generateUniqueCode(int length, {bool alphanumeric = false}) { /* ... code ... */
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    const digits = '0123456789';
    final random = Random();
    final source = alphanumeric ? chars : digits;
    return List.generate(length, (_) => source[random.nextInt(source.length)]).join();
  }
  void _generateGroupCode() => setState(() => _groupCode = _generateUniqueCode(8));
  void _generateGroupId() => setState(() => _groupId = _generateUniqueCode(12, alphanumeric: true));

  Future<void> _selectImage() async { /* ... code ... */
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() => _selectedImage = File(pickedImage.path));
    }
  }

  // --- Save Function ---
  Future<void> _saveGroupToFirebase() async { /* ... code ... */
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Error: User not logged in."))); return; }
    if (_groupName.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please enter a group name."))); return; }
    if (_habitName.trim().isEmpty) { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please enter a group habit name."))); return; }
    if (_selectedIcon == null) { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select a habit icon."))); return; }
    if (_selectedColor == null) { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select a habit color."))); return; }
    final List<String> daysList = _selectedDays.entries.where((entry) => entry.value).map((entry) => entry.key).toList();
    if (daysList.isEmpty) { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Please select at least one habit day."))); return; }

    setState(() => _isLoading = true);
    try {
      String? uploadedImageUrl = _groupImageUrl;
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance.ref('group_images/$_groupId.jpg');
        final uploadTask = storageRef.putFile(_selectedImage!);
        final snapshot = await uploadTask;
        uploadedImageUrl = await snapshot.ref.getDownloadURL();
      }
      String? timeString = _selectedTime != null ? DateFormat('HH:mm').format(_selectedTime!) : null;
      String colorString = '#${_selectedColor!.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      int? iconCodePoint = _selectedIcon?.codePoint;
      String? iconFontFamily = _selectedIcon?.fontFamily;
      String? iconFontPackage = _selectedIcon?.fontPackage;

      final groupData = {
        'groupName': _groupName.trim(), 'groupCode': _groupCode, 'groupId': _groupId,
        'adminUid': currentUser.uid, 'members': [currentUser.uid], 'groupImageUrl': uploadedImageUrl,
        'createdAt': FieldValue.serverTimestamp(), 'groupBio': _groupBio.trim(), 'groupType': _groupType,
        'habitName': _habitName.trim(), 'habitDays': daysList,
        'habitIconCodePoint': iconCodePoint, 'habitIconFontFamily': iconFontFamily, 'habitIconFontPackage': iconFontPackage,
        'habitColor': colorString, 'habitTime': timeString, 'category': "Group habit",
      };
      await FirebaseFirestore.instance.collection('groups').doc(_groupId).set(groupData);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Group created successfully!")));
      context.goNamed(GroupWidget.routeName);
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error creating group: $e');
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Failed to create group: ${e.toString()}")));
    }
  }

  // --- ** DEFENSIVE TextStyle Helper ** ---
  // Use this helper to create TextStyles safely
  TextStyle _getTextStyle( BuildContext context, TextStyle baseStyle, String? fontFamilyName,
      {Color? colorOverride, double? fontSizeOverride, FontWeight? fontWeightOverride, double? letterSpacingOverride}) {
    TextStyle style = baseStyle;
    if (colorOverride != null) style = style.copyWith(color: colorOverride);
    if (fontSizeOverride != null) style = style.copyWith(fontSize: fontSizeOverride);
    if (fontWeightOverride != null) style = style.copyWith(fontWeight: fontWeightOverride);
    if (letterSpacingOverride != null) style = style.copyWith(letterSpacing: letterSpacingOverride);

    if (fontFamilyName != null && GoogleFonts.asMap().containsKey(fontFamilyName)) {
      return GoogleFonts.getFont(fontFamilyName, textStyle: style);
    } else {
      return style.copyWith(fontFamily: fontFamilyName); // Apply family name directly, may fallback
    }
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Use helper for styles to avoid repetition and errors
    final titleLargeStyle = _getTextStyle(context, theme.titleLarge, theme.titleLargeFamily, letterSpacingOverride: 0.0);
    final headlineSmallStyle = _getTextStyle(context, theme.headlineSmall, theme.headlineSmallFamily, letterSpacingOverride: 0.0);
    final bodyMediumStyle = _getTextStyle(context, theme.bodyMedium, theme.bodyMediumFamily, colorOverride: theme.info, letterSpacingOverride: 0.0);
    final bodyMediumHintStyle = _getTextStyle(context, theme.bodyMedium, theme.bodyMediumFamily, colorOverride: Colors.white, letterSpacingOverride: 0.0); // Hint color specific
    final timePickerTextStyle = _getTextStyle(context, theme.bodyMedium, theme.bodyMediumFamily, colorOverride: theme.info);
    final dayButtonTextStyle = _getTextStyle(context, theme.bodyMedium, theme.bodyMediumFamily, colorOverride: theme.info);
    final iconButtonTextStyle = _getTextStyle(context, theme.bodyMedium, theme.bodyMediumFamily, colorOverride: theme.info);


    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primary,
        appBar: AppBar(
          backgroundColor: theme.primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 20, buttonSize: 40,
            icon: Icon( Icons.arrow_back_rounded, color: theme.info, size: 24,),
            onPressed: () => context.pop(),
          ),
          title: Text('Create Group', style: headlineSmallStyle), // Use safe style
          actions: [
            _isLoading
                ? Padding( padding: const EdgeInsets.all(12.0), child: SizedBox( width: 24, height: 24, child: CircularProgressIndicator(color: theme.info, strokeWidth: 3,),),)
                : Padding( padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: FlutterFlowIconButton(
                borderRadius: 20, buttonSize: 40,
                icon: Icon( Icons.check_rounded, color: theme.info, size: 24,),
                onPressed: _saveGroupToFirebase,
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration( color: theme.primaryBackground,),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // --- Group Image Picker ---
                    GestureDetector(
                      onTap: _selectImage,
                      child: Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          color: theme.secondary, shape: BoxShape.circle,
                          image: _selectedImage != null ? DecorationImage( image: FileImage(_selectedImage!), fit: BoxFit.cover,) : null,
                          border: Border.all( color: theme.primaryBordercolor, width: 2,),
                        ),
                        child: _selectedImage == null ? Align( alignment: AlignmentDirectional(0, 0), child: Icon( Icons.camera_alt, color: Colors.white, size: 40,),) : null,
                      ),
                    ),

                    // --- Group Info Section ---
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Group Information', style: titleLargeStyle), // Use safe style
                        TextFormField(
                          initialValue: _groupName,
                          onChanged: (value) => _groupName = value,
                          decoration: InputDecoration(
                            hintText: 'Enter group name',
                            hintStyle: bodyMediumHintStyle, // Use safe style
                            enabledBorder: OutlineInputBorder( borderSide: BorderSide(color: theme.primaryBordercolor, width: 1), borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: theme.primaryText, width: 1), borderRadius: BorderRadius.circular(12)),
                            filled: true, fillColor: theme.secondary, contentPadding: EdgeInsets.all(16),
                          ),
                          style: bodyMediumStyle, // Use safe style
                          cursorColor: theme.primaryText,
                        ),
                        TextFormField(
                          initialValue: _groupBio,
                          onChanged: (value) => _groupBio = value,
                          decoration: InputDecoration(
                            hintText: 'Group Bio (optional)',
                            hintStyle: bodyMediumHintStyle, // Use safe style
                            enabledBorder: OutlineInputBorder( borderSide: BorderSide(color: theme.primaryBordercolor, width: 1), borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: theme.primaryText, width: 1), borderRadius: BorderRadius.circular(12)),
                            filled: true, fillColor: theme.secondary, contentPadding: EdgeInsets.all(16),
                          ),
                          style: bodyMediumStyle, // Use safe style
                          maxLines: 3, minLines: 3,
                          cursorColor: theme.primaryText,
                        ),
                      ].divide(SizedBox(height: 8)),
                    ),

                    // --- Group Type Buttons ---
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( 'Group Type', style: titleLargeStyle,), // Use safe style
                        SizedBox(height: 8),
                        _buildGroupTypeButton( context: context, typeName: 'Public - Instant Join', description: 'Anyone can find and join', iconData: Icons.public, isSelected: _groupType == 'Public - Instant Join', ),
                        _buildGroupTypeButton( context: context, typeName: 'Private - Code & Admin Approval', description: 'Only visible via link/code', iconData: Icons.lock_outline, isSelected: _groupType == 'Private - Code & Admin Approval',),
                        _buildGroupTypeButton( context: context, typeName: 'Closed - Invite Only', description: 'Invite-only, hidden', iconData: Icons.shield_outlined, isSelected: _groupType == 'Closed - Invite Only',),
                      ].divide(SizedBox(height: 10)),
                    ),

                    // --- Group Habit Information Section ---
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding( padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8.0), child: Text( 'Group Habit Information', style: titleLargeStyle,),), // Use safe style

                        // Habit Name
                        TextFormField(
                          initialValue: _habitName,
                          onChanged: (value) => _habitName = value,
                          decoration: InputDecoration(
                            hintText: 'Enter group habit name',
                            hintStyle: bodyMediumHintStyle, // Use safe style
                            enabledBorder: OutlineInputBorder( borderSide: BorderSide(color: theme.primaryBordercolor, width: 1), borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: theme.primaryText, width: 1), borderRadius: BorderRadius.circular(12)),
                            filled: true, fillColor: theme.secondary, contentPadding: EdgeInsets.all(16),
                          ),
                          style: bodyMediumStyle, // Use safe style
                          cursorColor: theme.primaryText,
                        ),
                        SizedBox(height: 16),

                        // Time Picker
                        Text('Time (Optional)', style: titleLargeStyle), // Use safe style
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async { /* ... Time Picker Dialog Logic ... */
                            final TimeOfDay? picked = await showDialog<TimeOfDay?>( context: context, builder: (dialogContext) => CustomTimePickerPopup( initialTime: _selectedTime != null ? TimeOfDay.fromDateTime(_selectedTime!) : TimeOfDay(hour: 8, minute: 0),),);
                            if (picked != null) { final now = DateTime.now(); setState(() => _selectedTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute)); }
                          },
                          child: Container(
                            decoration: BoxDecoration( color: theme.secondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.primaryBordercolor, width: 1)),
                            child: Padding( padding: EdgeInsets.all(16),
                              child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row( children: [ Icon( Icons.access_time, color: theme.info, size: 24,), SizedBox(width: 12), Text( _selectedTime != null ? DateFormat.jm().format(_selectedTime!) : 'Select Time', style: timePickerTextStyle,),],), // Use safe style
                                  Icon( Icons.edit_calendar_outlined, color: theme.info, size: 24,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Day Selection
                        Text('Days', style: titleLargeStyle), // Use safe style
                        SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0, childAspectRatio: 1.0,),
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            final dayKey = days[index];
                            final displayDay = days[index].substring(0,1);
                            final isSelected = _selectedDays[dayKey] ?? false;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedDays[dayKey] = !isSelected),
                              child: Container(
                                decoration: BoxDecoration( color: isSelected ? theme.buttonBackground : theme.secondary, shape: BoxShape.circle, border: Border.all( color: isSelected ? theme.buttonBackground : theme.primaryBordercolor, width: isSelected ? 2.0 : 1.0),),
                                alignment: Alignment.center,
                                child: Text(displayDay, style: dayButtonTextStyle), // Use safe style
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        // Color Selection
                        Text('Color', style: titleLargeStyle), // Use safe style
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildColorSwatch(Color(0xFFFFD700)), _buildColorSwatch(Color(0xFFFF8C00)), _buildColorSwatch(Color(0xFFFF4500)),
                            _buildColorSwatch(Color(0xFFFF1493)), _buildColorSwatch(Color(0xFF9370DB)), _buildColorSwatch(Color(0xFF4169E1)),
                            _buildColorSwatch(Color(0xFF00BFFF)), _buildColorSwatch(Color(0xFF32CD32)),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Icon Selection
                        Text('Icon', style: titleLargeStyle), // Use safe style
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async { /* ... Icon Picker Dialog Logic ... */
                            final IconData? selectedIconResult = await showDialog<IconData?>( context: context, builder: (dialogContext) => Dialog( child: IconPickerWidget(),));
                            if (selectedIconResult != null) { setState(() => _selectedIcon = selectedIconResult); }
                          },
                          child: Container(
                            decoration: BoxDecoration( color: theme.secondary, borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.primaryBordercolor, width: 1)),
                            child: Padding( padding: EdgeInsets.all(16),
                              child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Container( width: 40, height: 40,
                                      decoration: BoxDecoration( color: _selectedColor ?? theme.buttonBackground, borderRadius: BorderRadius.circular(8),),
                                      child: Align( alignment: AlignmentDirectional(0, 0), child: Icon( _selectedIcon ?? Icons.add_reaction_outlined, color: theme.info, size: 24,),),
                                    ),
                                    SizedBox(width: 16),
                                    Text( _selectedIcon != null ? 'Icon Selected' : 'Select Icon', style: iconButtonTextStyle,), // Use safe style
                                  ],),
                                  Icon( Icons.keyboard_arrow_right, color: Colors.white, size: 24,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),


                      ],
                    ), // End of Habit Info Column

                  ].divide(SizedBox(height: 24)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  // --- Helper Widgets ---

  // Helper for Group Type Buttons (Using Defensive Styling)
  Widget _buildGroupTypeButton({
    required BuildContext context,
    required String typeName,
    required String description,
    required IconData iconData,
    required bool isSelected,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final Color backgroundColor = isSelected ? theme.buttonBackground : theme.secondary;
    final Color contentColor = isSelected ? theme.primaryBackground : theme.info;
    final Border border = Border.all( color: isSelected ? theme.buttonBackground : theme.primaryBordercolor, width: isSelected ? 2.0 : 1.0,);

    TextStyle titleStyle = _getTextStyle(context, theme.bodyLarge, theme.bodyLargeFamily, colorOverride: contentColor, fontWeightOverride: FontWeight.bold, letterSpacingOverride: 0.0);
    TextStyle descriptionStyle = _getTextStyle(context, theme.bodySmall, theme.bodySmallFamily, colorOverride: contentColor.withOpacity(0.8), letterSpacingOverride: 0.0);

    return GestureDetector(
      onTap: () => setState(() => _groupType = typeName),
      child: Container( width: double.infinity, decoration: BoxDecoration( color: backgroundColor, borderRadius: BorderRadius.circular(12.0), border: border,),
        child: Padding( padding: EdgeInsets.all(12),
          child: Row( mainAxisSize: MainAxisSize.max,
            children: [
              Icon( iconData, color: contentColor, size: 32,),
              SizedBox(width: 12),
              Expanded(
                child: Column( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( typeName.split(' - ')[0], style: titleStyle,),
                    SizedBox(height: 4),
                    Text( description, style: descriptionStyle,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Helper for Color Swatches
  Widget _buildColorSwatch(Color color) { /* ... code as before ... */
    bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 32.0, height: 32.0,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: FlutterFlowTheme.of(context).info, width: 2.0) : null,
        ),
      ),
    );
  }


// --- End of Helper Widgets ---

} // End of _GroupCreation2WidgetState