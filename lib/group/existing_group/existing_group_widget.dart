import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'existing_group_model.dart';
export 'existing_group_model.dart';

class ExistingGroupWidget extends StatefulWidget {
  const ExistingGroupWidget({
    super.key,
    String? groupname,
    this.membercount,
    this.icon,
  }) : this.groupname = groupname ?? 'TestGroup';

  final String groupname;
  final String? membercount;
  final Widget? icon;

  @override
  State<ExistingGroupWidget> createState() => _ExistingGroupWidgetState();
}

class _ExistingGroupWidgetState extends State<ExistingGroupWidget> {
  late ExistingGroupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExistingGroupModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondary,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryBordercolor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF0D6DFD),
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: widget!.icon!,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget!.groupname,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            useGoogleFonts:
                                GoogleFonts.asMap().containsKey('Inter'),
                          ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.public_rounded,
                              color: Color(0xFF9CA3AF),
                              size: 14.0,
                            ),
                            Text(
                              FFLocalizations.of(context).getText(
                                '4k40sy3j' /* Public */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey('Inter'),
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.people_rounded,
                              color: Color(0xFF9CA3AF),
                              size: 14.0,
                            ),
                            Text(
                              valueOrDefault<String>(
                                widget!.membercount,
                                'nul',
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey('Inter'),
                                  ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ].divide(SizedBox(height: 4.0)),
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
