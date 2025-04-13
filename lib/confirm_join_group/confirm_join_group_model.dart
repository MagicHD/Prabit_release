import '/components/popup_groupjoin_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'confirm_join_group_widget.dart' show ConfirmJoinGroupWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ConfirmJoinGroupModel extends FlutterFlowModel<ConfirmJoinGroupWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for popupGroupjoin component.
  late PopupGroupjoinModel popupGroupjoinModel;

  @override
  void initState(BuildContext context) {
    popupGroupjoinModel = createModel(context, () => PopupGroupjoinModel());
  }

  @override
  void dispose() {
    popupGroupjoinModel.dispose();
  }
}
