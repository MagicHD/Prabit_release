import '/components/popup_groupjoin_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'confirm_join_group_model.dart';
export 'confirm_join_group_model.dart';

/// Prompt: Design a dark-themed popup screen for a habit-tracking app that
/// previews a group before joining.
///
/// This popup should appear centered and slightly elevated over the
/// background. Layout & Elements: Title: “Join Group” in bold white,
/// top-aligned. Close icon (“X”) on the top-right corner. Group profile
/// picture: Large circular icon with a bold color background and group icon
/// inside (e.g. red with a people icon). Group name: “Daily Readers”
/// displayed next to the icon in bold white text. Group metadata row: Inline
/// below the group name Group type (e.g., Public) with a globe icon Member
/// count (e.g., 86 members) with a people icon About Section: Section header:
/// “About this group” Description text: “Join us as we read at least 10 pages
/// every day. Share book recommendations and discuss your latest reads with
/// the community!” Action Buttons: Two horizontally arranged buttons at the
/// bottom: Cancel (dark gray background) Join Group (bright blue background
/// with white text) Style & Design: Rounded corners on the popup container
/// Dark blue background Clean spacing, legible white text, and compact layout
/// Maintain consistency with modern mobile UI design, optimized for dark mode
/// Use system font or a geometric sans-serif Let me know if you’d like to
/// include more data (e.g. habit time, active days, preview of group habit
/// card), or if you want a variation for private/closed groups!
class ConfirmJoinGroupWidget extends StatefulWidget {
  const ConfirmJoinGroupWidget({super.key});

  static String routeName = 'confirmJoinGroup';
  static String routePath = '/confirmJoinGroup';

  @override
  State<ConfirmJoinGroupWidget> createState() => _ConfirmJoinGroupWidgetState();
}

class _ConfirmJoinGroupWidgetState extends State<ConfirmJoinGroupWidget> {
  late ConfirmJoinGroupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfirmJoinGroupModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0x80000000),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0x80000000),
              ),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      wrapWithModel(
                        model: _model.popupGroupjoinModel,
                        updateCallback: () => safeSetState(() {}),
                        child: PopupGroupjoinWidget(),
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
