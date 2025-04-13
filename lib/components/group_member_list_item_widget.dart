import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'group_member_list_item_model.dart';
export 'group_member_list_item_model.dart';

class GroupMemberListItemWidget extends StatefulWidget {
  const GroupMemberListItemWidget({
    super.key,
    String? username,
    this.userProfilePicture,
  }) : this.username = username ?? 'user';

  final String username;
  final String? userProfilePicture;

  @override
  State<GroupMemberListItemWidget> createState() =>
      _GroupMemberListItemWidgetState();
}

class _GroupMemberListItemWidgetState extends State<GroupMemberListItemWidget> {
  late GroupMemberListItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupMemberListItemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent1,
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Image.network(
                widget!.userProfilePicture!,
                width: 60.0,
                height: 60.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: Text(
              widget!.username,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                    color: FlutterFlowTheme.of(context).info,
                    letterSpacing: 0.0,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodySmallFamily),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
