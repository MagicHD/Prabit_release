import '/feed/feedcard/feedcard_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'feedscreen_widget.dart' show FeedscreenWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedscreenModel extends FlutterFlowModel<FeedscreenWidget> {
  ///  State fields for stateful widgets in this page.

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
