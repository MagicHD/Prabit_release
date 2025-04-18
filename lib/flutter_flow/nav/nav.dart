import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../auth/forgot_password_screen/setup_profile_screen/setup_profile_screen.dart';
import '../../habit/congrats/congrats_screen_widget.dart';
import '../../habit/photo/habit_photo_screen_widget.dart';
import '../../habit/review/habit_review_screen_widget.dart';
import '../../photo/post_screen/post_screen_widget.dart';
import '../../profile/calender/calender_widget.dart';
import '../../streak_page/streak_page_widget.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import "../../profile/settings/privacy_policy_screen.dart";

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';
import '../../profile/calender/calender_widget.dart';


const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}
GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
  initialLocation: LoginScreenWidget.routePath, // Keep login as initial
  debugLogDiagnostics: true,
  refreshListenable: appStateNotifier, // Can still be used for other state changes
  navigatorKey: appNavigatorKey,
  errorBuilder: (context, state) => LoginScreenWidget(), // Error fallback to login

  // --- ADD REDIRECT LOGIC ---
  redirect: (BuildContext context, GoRouterState state) {
    final loggedIn = FirebaseAuth.instance.currentUser != null;
    final currentRoute = state.matchedLocation; // Get the route the user is trying to access

    // Define routes accessible only when logged out
    final loggedOutRoutes = [
      LoginScreenWidget.routePath,
      SignupScreenWidget.routePath,
      // Add other auth-related routes like ForgotPasswordScreenWidget.routePath if applicable
      '/forgotPasswordScreen', // Assuming this is the path
    ];

    final isLoggingIn = loggedOutRoutes.contains(currentRoute);

    // Case 1: User is not logged in and trying to access a protected route
    if (!loggedIn && !isLoggingIn) {
      print('Redirecting to login: User not logged in, tried to access $currentRoute');
      return LoginScreenWidget.routePath; // Redirect to login
    }

    // Case 2: User is logged in and trying to access login/signup
    if (loggedIn && isLoggingIn) {
      print('Redirecting to feed: User logged in, tried to access $currentRoute');
      return FeedscreenWidget.routePath; // Redirect to feed screen
    }

    // Case 3: All other cases (logged in accessing protected route, logged out accessing login/signup)
    print('No redirect needed: loggedIn=$loggedIn, trying to access $currentRoute');
    return null; // No redirect needed
  },
  // --- END REDIRECT LOGIC ---



      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => NavBarPage(),
        ),
        FFRoute(
          name: FeedscreenWidget.routeName,
          path: FeedscreenWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Feedscreen')
              : NavBarPage(
                  initialPage: 'Feedscreen',
                  page: FeedscreenWidget(),
                ),
        ),
        FFRoute(
          name: ProfilescreenWidget.routeName,
          path: ProfilescreenWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'Profilescreen')
              : NavBarPage(
                  initialPage: 'Profilescreen',
                  page: ProfilescreenWidget(),
                ),
        ),
        FFRoute(
          name: CalendarWidget.routeName,
          path: CalendarWidget.routePath,
          builder: (context, params) => CalendarWidget(),
        ),
        FFRoute(
          name: StatistiscpageWidget.routeName,
          path: StatistiscpageWidget.routePath,
          builder: (context, params) => StatistiscpageWidget(),
        ),

        FFRoute(
          name: SettingsWidget.routeName,
          path: SettingsWidget.routePath,
          builder: (context, params) => SettingsWidget(),
        ),
        FFRoute(
          name: HabitSelectionScreenWidget.routeName,
          path: HabitSelectionScreenWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'HabitSelectionScreen')
              : NavBarPage(
                  initialPage: 'HabitSelectionScreen',
                  page: HabitSelectionScreenWidget(),
                ),
        ), FFRoute(
          name: HabitPhotoScreenWidget.routeName,
          path: HabitPhotoScreenWidget.routePath,
          builder: (context, params) { // params is FFParameters
            // Access 'extra' directly from the GoRouterState (params.state)
            final extraData = params.state.extra as Map<String, dynamic>?; // Cast the 'extra' object
            final habitData = extraData?['habit'] as Map<String, dynamic>?; // Access 'habit' from extraData

            if (habitData == null) {
              print("Error: Habit data missing for HabitPhotoScreen");
              // Returning a simple error Scaffold
              return Scaffold(body: Center(child: Text("Error: Habit data missing")));
            }
            // Pass the extracted habit data
            return HabitPhotoScreenWidget(habit: habitData);
          },
        ),
        // In lib/flutter_flow/nav/nav.dart within createRouter -> routes: [...]
        FFRoute(
          name: HabitPostScreenWidget.routeName,
          path: HabitPostScreenWidget.routePath,
          builder: (context, params) { // params is FFParameters
            // --- MODIFIED DATA EXTRACTION ---
            // Access 'extra' directly from the GoRouterState (params.state)
            final extraData = params.state.extra as Map<String, dynamic>? ?? {}; // Use empty map if null
            final habitData = extraData['habit'] as Map<String, dynamic>?; // Get habit from extra
            final imageUrl = extraData['imageUrl'] as String?; // Get imageUrl from extra

            if (imageUrl == null || habitData == null) {
              print("Error: Image URL or Habit data missing in extra for HabitPostScreen");
              // Return an error Scaffold or navigate back
              return Scaffold(body: Center(child: Text("Error: Missing data for post screen")));
            }
            // Pass the extracted data to the widget constructor
            return HabitPostScreenWidget(
              imageUrl: imageUrl,
              habit: habitData,
            );
            // --- END MODIFIED DATA EXTRACTION ---
          },
        ),FFRoute(
          name: HabitReviewScreenWidget.routeName,
          path: HabitReviewScreenWidget.routePath,
          builder: (context, params) {
            final extraData = params.state.extra as Map<String, dynamic>? ?? {};
            final rearPath = extraData['rearImagePath'] as String?;
            final frontPath = extraData['frontImagePath'] as String?;
            final habitData = extraData['habit'] as Map<String, dynamic>?;

            if (rearPath == null || frontPath == null || habitData == null) {
              print("Error: Missing image paths or habit data for Review Screen");
              // Handle error appropriately - maybe pop back or show error
              return Scaffold(body: Center(child: Text("Error loading review screen data.")));
            }

            return HabitReviewScreenWidget(
              rearImagePath: rearPath,
              frontImagePath: frontPath,
              habit: habitData,
            );
          },
        ),
        // Keep the CongratsScreen route as it was (it doesn't need 'extra' data in this setup)
        FFRoute(
          name: CongratsScreenWidget.routeName,
          path: CongratsScreenWidget.routePath,
          builder: (context, params) {
            return CongratsScreenWidget();
          },
        ),
        FFRoute(
          name: StreakPageWidget.routeName,
          path: StreakPageWidget.routePath,
          builder: (context, params) {
            return StreakPageWidget();
          },
        ),
        FFRoute(
          name: GroupWidget.routeName,
          path: GroupWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'group')
              : NavBarPage(
                  initialPage: 'group',
                  page: GroupWidget(),
                ),
        ),
        // Inside your GoRouter configuration in nav.dart
        FFRoute(
          name: SetupProfileScreenWidget.routeName,
          path: SetupProfileScreenWidget.routePath,
          builder: (context, params) => SetupProfileScreenWidget(),
          // Add requireAuth: true if needed, though the redirect logic might handle this
        ),
        // Find this route definition in your nav.dart:
        FFRoute(
          name: GroupChatWidget.routeName, // 'group_chat'
          path: GroupChatWidget.routePath, // '/groupChat'

          // --- MODIFY THE builder FUNCTION BELOW ---
          builder: (context, params) { // params is FFParameters
            // Access GoRouterState via params.state
            final GoRouterState state = params.state;
            // Extract parameters from queryParameters map
            final String groupId = state.uri.queryParameters['groupId'] ?? '';
            final String groupName = state.uri.queryParameters['groupName'] ?? 'Chat'; // Default name
            final String? groupImageUrl = state.uri.queryParameters['groupImageUrl']; // Image URL can be null

            // Optional: Add a check for missing essential parameters like groupId
            if (groupId.isEmpty) {
              // Log an error or return an error widget/navigate back
              print('Error navigating to GroupChat: Missing groupId parameter.');
              // Example: Return a simple error view or navigate back
              return Scaffold(
                  appBar: AppBar(title: Text("Error")),
                  body: Center(child: Text("Could not load chat: Missing Group ID."))
              );
              // Alternatively: context.pop(); return Container(); // Pop back immediately
            }

            // Instantiate GroupChatWidget with the extracted parameters
            return GroupChatWidget(
              groupId: groupId,
              groupName: groupName,
              groupImageUrl: groupImageUrl,
            );
          },
          // --- END OF MODIFICATION ---

        ), // End of FFRoute for GroupChatWidget
        FFRoute(
          name: GroupDetailsWidget.routeName,
          path: GroupDetailsWidget.routePath,
          builder: (context, params) => GroupDetailsWidget(),
        ),
        FFRoute(
          name: PrivacyPolicyScreen.routeName,
          path: PrivacyPolicyScreen.routePath,
          builder: (context, params) => PrivacyPolicyScreen(),
        ),
        FFRoute(
          name: StatisticsScreenWidget.routeName,
          path: StatisticsScreenWidget.routePath,
          builder: (context, params) => StatisticsScreenWidget(),
        ),
        FFRoute(
          name: HabitConfigureWidget.routeName,
          path: HabitConfigureWidget.routePath,
          builder: (context, params) => HabitConfigureWidget(),
        ),
        FFRoute(
          name: GroupLeaderboardWidget.routeName,
          path: GroupLeaderboardWidget.routePath,
          builder: (context, params) => GroupLeaderboardWidget(),
        ),
        FFRoute(
          name: GroupCreation2Widget.routeName,
          path: GroupCreation2Widget.routePath,
          builder: (context, params) => GroupCreation2Widget(),
        ),
        FFRoute(
          name: LoginScreenWidget.routeName,
          path: LoginScreenWidget.routePath,
          builder: (context, params) => LoginScreenWidget(),
        ),
        FFRoute(
          name: ForgotPasswordScreenWidget.routeName,
          path: ForgotPasswordScreenWidget.routePath,
          builder: (context, params) => ForgotPasswordScreenWidget(),
        ),
        FFRoute(
          name: SignupScreenWidget.routeName,
          path: SignupScreenWidget.routePath,
          builder: (context, params) => SignupScreenWidget(),
        ),
        FFRoute(
          name: ConfirmJoinGroupWidget.routeName,
          path: ConfirmJoinGroupWidget.routePath,
          builder: (context, params) => ConfirmJoinGroupWidget(),
        ),
        FFRoute(
          name: ConfirmJoinGroup2Widget.routeName,
          path: ConfirmJoinGroup2Widget.routePath,
          builder: (context, params) => ConfirmJoinGroup2Widget(),
        ),
        FFRoute(
          name: SupportScreenWidget.routeName,
          path: SupportScreenWidget.routePath,
          builder: (context, params) => SupportScreenWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
