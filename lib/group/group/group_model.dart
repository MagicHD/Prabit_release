import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/group/discover_group/discover_group_widget.dart';
import '/group/existing_group/existing_group_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'group_widget.dart' show GroupWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GroupModel extends FlutterFlowModel<GroupWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ExistingGroup component.
  late ExistingGroupModel existingGroupModel1;
  // Model for ExistingGroup component.
  late ExistingGroupModel existingGroupModel2;
  // Model for ExistingGroup component.
  late ExistingGroupModel existingGroupModel3;
  // Model for DiscoverGroup component.
  late DiscoverGroupModel discoverGroupModel1;
  // Model for DiscoverGroup component.
  late DiscoverGroupModel discoverGroupModel2;
  // Model for DiscoverGroup component.
  late DiscoverGroupModel discoverGroupModel3;

  @override
  void initState(BuildContext context) {
    existingGroupModel1 = createModel(context, () => ExistingGroupModel());
    existingGroupModel2 = createModel(context, () => ExistingGroupModel());
    existingGroupModel3 = createModel(context, () => ExistingGroupModel());
    discoverGroupModel1 = createModel(context, () => DiscoverGroupModel());
    discoverGroupModel2 = createModel(context, () => DiscoverGroupModel());
    discoverGroupModel3 = createModel(context, () => DiscoverGroupModel());
  }

  @override
  void dispose() {
    existingGroupModel1.dispose();
    existingGroupModel2.dispose();
    existingGroupModel3.dispose();
    discoverGroupModel1.dispose();
    discoverGroupModel2.dispose();
    discoverGroupModel3.dispose();
  }
}
