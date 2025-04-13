import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/friendlistitem/friendlistitem_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'profilescreen_widget.dart' show ProfilescreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilescreenModel extends FlutterFlowModel<ProfilescreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Friendlistitem component.
  late FriendlistitemModel friendlistitemModel1;
  // Model for Friendlistitem component.
  late FriendlistitemModel friendlistitemModel2;
  // Model for Friendlistitem component.
  late FriendlistitemModel friendlistitemModel3;

  @override
  void initState(BuildContext context) {
    friendlistitemModel1 = createModel(context, () => FriendlistitemModel());
    friendlistitemModel2 = createModel(context, () => FriendlistitemModel());
    friendlistitemModel3 = createModel(context, () => FriendlistitemModel());
  }

  @override
  void dispose() {
    friendlistitemModel1.dispose();
    friendlistitemModel2.dispose();
    friendlistitemModel3.dispose();
  }
}
