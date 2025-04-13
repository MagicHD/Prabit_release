import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/group/discover_group/discover_group_widget.dart';
import '/group/existing_group/existing_group_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'group_model.dart';
export 'group_model.dart';

/// The group screen of the Prabit app is designed to help users effortlessly
/// manage their current group memberships and discover new communities.
///
/// The screen’s layout is structured, user-centric, and visually consistent
/// with the rest of the app’s dark mode aesthetic. It emphasizes clarity,
/// social engagement, and accessibility. At the top of the screen, the title
/// “Groups” is displayed in bold white text, aligned to the left. To the
/// right is a search icon, allowing users to quickly find specific groups.
/// This sets the stage for both browsing and targeted discovery. My Groups
/// The first section, labeled “My Groups”, displays the user’s current group
/// memberships in a vertically stacked list. Each group is encapsulated in a
/// rounded rectangular card with a dark blue background and colored icon
/// representing the group’s identity. Each card includes: A group icon in a
/// colored circular background (blue, purple, green) representing the group’s
/// theme or category. The group name in bold white text (e.g., “Morning
/// Fitness Club”). A small label below the name showing: The group type
/// (Public or Private) with an accompanying icon. The number of members in
/// gray text with a member icon. A chevron arrow on the right side indicates
/// that the user can tap to view more details or manage the group. The clear
/// visual hierarchy and use of spacing make each card easy to scan and
/// distinguish, even at a glance. Discover Groups The second section, titled
/// “Discover Groups”, highlights suggested or popular public groups that the
/// user hasn’t joined yet. These cards follow the same design principles as
/// the ones in “My Groups,” but with the addition of a “Join” button on the
/// right side of each card. Each group card in this section includes: A
/// colored icon (e.g., red, orange, teal) for category identity. The group
/// name, type (always public), and member count. A vibrant blue “Join” button
/// that stands out against the dark background, inviting immediate
/// interaction. Floating Action Button In the bottom-right corner of the
/// screen, there is a prominent floating action button (FAB)—a bright blue
/// circle with a white plus icon. This button is used to create a new group,
/// and it follows mobile UI best practices for initiating primary actions.
/// Summary The group screen in Prabit is optimized for both engagement and
/// exploration. It visually separates joined and available groups, provides
/// clear metadata on each group, and makes key actions like joining or
/// creating a group immediately accessible. The use of bold iconography,
/// colored tags, and responsive design elements within a dark interface makes
/// this screen approachable, social, and effective.
class GroupWidget extends StatefulWidget {
  const GroupWidget({super.key});

  static String routeName = 'group';
  static String routePath = '/group';

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  late GroupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupModel());
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
        backgroundColor: FlutterFlowTheme.of(context).primary,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            context.pushNamed(GroupCreation2Widget.routeName);
          },
          backgroundColor: FlutterFlowTheme.of(context).buttonBackground,
          elevation: 3.0,
          child: Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).buttonText,
            size: 24.0,
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            FFLocalizations.of(context).getText(
              'n29bio07' /* Groups */,
            ),
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).displaySmallFamily),
                ),
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 40.0,
                  buttonSize: 40.0,
                  icon: Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            '79hv9d87' /* My Groups */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .titleLargeFamily),
                              ),
                        ),
                        wrapWithModel(
                          model: _model.existingGroupModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: ExistingGroupWidget(
                            groupname: 'Gym',
                            membercount: '123',
                            icon: FaIcon(
                              FontAwesomeIcons.alignCenter,
                            ),
                          ),
                        ),
                        wrapWithModel(
                          model: _model.existingGroupModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: ExistingGroupWidget(
                            icon: FaIcon(
                              FontAwesomeIcons.airbnb,
                            ),
                          ),
                        ),
                        wrapWithModel(
                          model: _model.existingGroupModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: ExistingGroupWidget(
                            icon: FaIcon(
                              FontAwesomeIcons.airFreshener,
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            '82rc6hzr' /* Discover Groups */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .titleLargeFamily),
                              ),
                        ),
                        wrapWithModel(
                          model: _model.discoverGroupModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: DiscoverGroupWidget(),
                        ),
                        wrapWithModel(
                          model: _model.discoverGroupModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: DiscoverGroupWidget(
                            groupname: 'wer',
                            members: 'wer',
                          ),
                        ),
                        wrapWithModel(
                          model: _model.discoverGroupModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: DiscoverGroupWidget(
                            groupname: 'werwerwer',
                            members: 'weeee',
                          ),
                        ),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
