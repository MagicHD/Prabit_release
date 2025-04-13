import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/group/currentuser_message/currentuser_message_widget.dart';
import '/group/friend_message/friend_message_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'group_chat_widget.dart' show GroupChatWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GroupChatModel extends FlutterFlowModel<GroupChatWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for currentuser_message component.
  late CurrentuserMessageModel currentuserMessageModel;
  // Model for friend_message component.
  late FriendMessageModel friendMessageModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    currentuserMessageModel =
        createModel(context, () => CurrentuserMessageModel());
    friendMessageModel = createModel(context, () => FriendMessageModel());
  }

  @override
  void dispose() {
    currentuserMessageModel.dispose();
    friendMessageModel.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
