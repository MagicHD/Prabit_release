import '/feed/feedcard/feedcard_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'tabbar_widget.dart' show TabbarWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TabbarModel extends FlutterFlowModel<TabbarWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for feedcard component.
  late FeedcardModel feedcardModel1;
  // Model for feedcard component.
  late FeedcardModel feedcardModel2;

  @override
  void initState(BuildContext context) {
    feedcardModel1 = createModel(context, () => FeedcardModel());
    feedcardModel2 = createModel(context, () => FeedcardModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    feedcardModel1.dispose();
    feedcardModel2.dispose();
  }
}
