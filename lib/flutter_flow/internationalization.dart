import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['de', 'en'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? deText = '',
    String? enText = '',
  }) =>
      [deText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // Feedscreen
  {
    '40uc9yol': {
      'de': 'Friends',
      'en': '',
    },
    '9sgbuu77': {
      'de': 'Discover',
      'en': '',
    },
    '5cvgp873': {
      'de': 'Coming Soon',
      'en': '',
    },
    'kvn9u2me': {
      'de': 'This feature will be availiable in an upcoming update.',
      'en': '',
    },
    'j2028ukr': {
      'de': 'Prabit',
      'en': '',
    },
  },
  // Profilescreen
  {
    'qfklgi1u': {
      'de': 'My Profile',
      'en': '',
    },
    'pappnzlc': {
      'de': 'lazylevin123',
      'en': '',
    },
    '6z20lrxo': {
      'de': 'Member since Apr 2025',
      'en': '',
    },
    '8i56dofc': {
      'de': 'I\'m tracking my habits and making progress every day!',
      'en': '',
    },
    '3nqlkwra': {
      'de': 'Search friends...',
      'en': '',
    },
  },
  // calendar
  {
    '1by656i7': {
      'de': 'Calendar',
      'en': '',
    },
    'qila67g3': {
      'de': 'March 2025',
      'en': '',
    },
    '177k9c8v': {
      'de': 'S',
      'en': '',
    },
    'ufrpfnpk': {
      'de': 'M',
      'en': '',
    },
    'yp2erjj3': {
      'de': 'T',
      'en': '',
    },
    'i58o23eb': {
      'de': 'W',
      'en': '',
    },
    'hynvrs95': {
      'de': 'T',
      'en': '',
    },
    '4rjz0t0e': {
      'de': 'F',
      'en': '',
    },
    '1s4y3l7p': {
      'de': 'S',
      'en': '',
    },
    '4qj321w0': {
      'de': '1',
      'en': '',
    },
    'jn8sj7b4': {
      'de': '2',
      'en': '',
    },
    '5obmi5ju': {
      'de': '3',
      'en': '',
    },
    's3hxx9tj': {
      'de': '4',
      'en': '',
    },
    'e6zaqfuc': {
      'de': '5',
      'en': '',
    },
    '6ttaw8xf': {
      'de': '6',
      'en': '',
    },
    'k5soyhgt': {
      'de': '7',
      'en': '',
    },
    'uuvvq7xg': {
      'de': '8',
      'en': '',
    },
    'g54285j5': {
      'de': '9',
      'en': '',
    },
    'ibv418ck': {
      'de': '11',
      'en': '',
    },
    'uz8d7glt': {
      'de': '12',
      'en': '',
    },
    'xwdtwmgx': {
      'de': '13',
      'en': '',
    },
    'v47dxaoi': {
      'de': '14',
      'en': '',
    },
    'nyqax5i2': {
      'de': '15',
      'en': '',
    },
    'fkyy5wq5': {
      'de': '3',
      'en': '',
    },
    'bzdt9s1p': {
      'de': '16',
      'en': '',
    },
    'wfhih6hk': {
      'de': '17',
      'en': '',
    },
    '6jeepcrh': {
      'de': '18',
      'en': '',
    },
    'l98l1wkr': {
      'de': '19',
      'en': '',
    },
    '5c4u5gc1': {
      'de': '20',
      'en': '',
    },
    'lwbsj8pm': {
      'de': '21',
      'en': '',
    },
    'a1syk1w3': {
      'de': '22',
      'en': '',
    },
    'scann1ne': {
      'de': '2',
      'en': '',
    },
    'uk5vf7wf': {
      'de': '23',
      'en': '',
    },
    'u0v8xomu': {
      'de': '24',
      'en': '',
    },
    '1hwjpcfq': {
      'de': '25',
      'en': '',
    },
    '4x0db481': {
      'de': '26',
      'en': '',
    },
    '7je9ecp1': {
      'de': '27',
      'en': '',
    },
    '77iidrvy': {
      'de': '28',
      'en': '',
    },
    'fskyvbv4': {
      'de': '29',
      'en': '',
    },
    'urmmp82a': {
      'de': '30',
      'en': '',
    },
    'lm7c2zg4': {
      'de': '31',
      'en': '',
    },
  },
  // statistiscpage
  {
    '4sl2onmm': {
      'de': 'Statistics',
      'en': '',
    },
    'i1x4r4oh': {
      'de': '8',
      'en': '',
    },
    'coa9vvfd': {
      'de': 'Current Streak',
      'en': '',
    },
    'umnfc3vw': {
      'de': '23',
      'en': '',
    },
    '9yus97gl': {
      'de': 'Longest Streak',
      'en': '',
    },
    'jveitc1u': {
      'de': '152',
      'en': '',
    },
    'yq6jdhxn': {
      'de': 'Total Check-ins',
      'en': '',
    },
    'ewo9brwi': {
      'de': '47',
      'en': '',
    },
    'pvmzu0v6': {
      'de': 'Group Check-ins',
      'en': '',
    },
    '2esbnt1b': {
      'de': 'This Week',
      'en': '',
    },
    'b4rqtut6': {
      'de': 'This Month',
      'en': '',
    },
    'mrp0arbc': {
      'de': 'Physical',
      'en': '',
    },
    '6isgu2gh': {
      'de': '17 check-ins',
      'en': '',
    },
    '753fpgdj': {
      'de': 'Mental',
      'en': '',
    },
    '2zj49ztz': {
      'de': '12 check-ins',
      'en': '',
    },
    'f8w7rhyq': {
      'de': 'Learning',
      'en': '',
    },
    'vypwijcz': {
      'de': '10 check-ins',
      'en': '',
    },
    'rktvmerh': {
      'de': 'Social',
      'en': '',
    },
    'al0hizd0': {
      'de': '8 check-ins',
      'en': '',
    },
    'marswflr': {
      'de': 'Health',
      'en': '',
    },
    'l7hut59c': {
      'de': '7 check-ins',
      'en': '',
    },
    'ba02iqp0': {
      'de': 'Creativity',
      'en': '',
    },
    'p7zqfwtw': {
      'de': '5 check-ins',
      'en': '',
    },
    '5kx7e47z': {
      'de':
          'You\'re doing great!\nKeep up your 8-day streak to reach a new personal record.',
      'en': '',
    },
  },
  // groupcreationscreen
  {
    'aqw0su40': {
      'de': 'Create Group',
      'en': '',
    },
    '2yfba7eg': {
      'de': 'Group Information',
      'en': '',
    },
    'z2onr9tn': {
      'de': 'Enter group name',
      'en': '',
    },
    'ref2t7lu': {
      'de': 'Brief description of the group (optional)',
      'en': '',
    },
    '9bkg5yg6': {
      'de': 'Group Type',
      'en': '',
    },
    'bvvh974p': {
      'de': 'Public',
      'en': '',
    },
    'o4w2uohq': {
      'de': 'Group Habit Details',
      'en': '',
    },
    'aj2p5hw4': {
      'de': 'Enter habit name',
      'en': '',
    },
    'jyxjxp2z': {
      'de': '08:00 AM',
      'en': '',
    },
    'ylzv2ngb': {
      'de': 'Optional',
      'en': '',
    },
    'ytbvwjfo': {
      'de': 'Days of the Week',
      'en': '',
    },
    'ik82jp1f': {
      'de': 'M',
      'en': '',
    },
    'r8puj4io': {
      'de': 'T',
      'en': '',
    },
    '2busx7k5': {
      'de': 'W',
      'en': '',
    },
    '89cfwxk3': {
      'de': 'T',
      'en': '',
    },
    'wb9bjyvp': {
      'de': 'F',
      'en': '',
    },
    'g1nezn34': {
      'de': 'S',
      'en': '',
    },
    'hm5txx91': {
      'de': 'S',
      'en': '',
    },
    'te6mfxa8': {
      'de': 'Choose an icon',
      'en': '',
    },
    'ven4ixg3': {
      'de': 'Color',
      'en': '',
    },
    'zio7nedw': {
      'de': 'Invite Friends',
      'en': '',
    },
  },
  // settings
  {
    'lk39x5at': {
      'de': 'Settings',
      'en': '',
    },
    'cyi02yrp': {
      'de': 'SUPPORT',
      'en': '',
    },
    '0djp10fi': {
      'de': 'Contact Us',
      'en': '',
    },
    'qg4ucjhk': {
      'de': 'LEGAL',
      'en': '',
    },
    'eb5xlt4v': {
      'de': 'Legal Notice',
      'en': '',
    },
    '4vqvhygk': {
      'de': 'Privacy Policy',
      'en': '',
    },
    '11if3nk1': {
      'de': 'ACCOUNT',
      'en': '',
    },
    'o8z58kus': {
      'de': 'Log Out',
      'en': '',
    },
    'xhlmnyuv': {
      'de': 'CREDITS',
      'en': '',
    },
    '44vyrai6': {
      'de': 'Design & Development',
      'en': '',
    },
    '9swjw4fn': {
      'de': 'Prabit Team',
      'en': '',
    },
  },
  // HabitSelectionScreen
  {
    '43f5vne0': {
      'de': 'Habits',
      'en': '',
    },
    'i3xr2cf1': {
      'de': 'Your habits',
      'en': '',
    },
    '21878072': {
      'de': 'Group habits',
      'en': '',
    },
    'yz1r8wf2': {
      'de': 'iui',
      'en': '',
    },
  },
  // group
  {
    'n29bio07': {
      'de': 'Groups',
      'en': '',
    },
    '79hv9d87': {
      'de': 'My Groups',
      'en': '',
    },
    '82rc6hzr': {
      'de': 'Discover Groups',
      'en': '',
    },
  },
  // group_chat
  {
    'wm2tbgzb': {
      'de': 'MR',
      'en': '',
    },
    'eezpdxjc': {
      'de': 'Morning Readers',
      'en': '',
    },
    '35tjdagv': {
      'de': '5 members',
      'en': '',
    },
    'pnkohbh6': {
      'de': 'S',
      'en': '',
    },
    '693u8axr': {
      'de': 'Sarah',
      'en': '',
    },
    '4u0g83tz': {
      'de': 'Today\'s reading spot. Perfect lighting and ambiance! 📖✨',
      'en': '',
    },
    'q7fnv0k4': {
      'de': '20:05',
      'en': '',
    },
    'pwignj4b': {
      'de': 'S',
      'en': '',
    },
    'lnmjr5ir': {
      'de': 'Sarah',
      'en': '',
    },
    'mozial58': {
      'de': 'Thanks! What book are you reading this week?',
      'en': '',
    },
    'ydju482e': {
      'de': '20:37',
      'en': '',
    },
    '8mkzzmc9': {
      'de':
          'I\'m reading \'Atomic Habits\' by James Clear. It\'s really insightful about building good routines!',
      'en': '',
    },
    '4arisy3o': {
      'de': '20:40',
      'en': '',
    },
    '8w3nbhcn': {
      'de': 'Type a message...',
      'en': '',
    },
  },
  // group_details
  {
    'wvuzckm1': {
      'de': 'Morning Readers',
      'en': '',
    },
    'cpiyu9ck': {
      'de': '3',
      'en': '',
    },
    'hsf8rpws': {
      'de': 'Morning Readers',
      'en': '',
    },
    'tejaimfo': {
      'de': 'Private',
      'en': '',
    },
    'oqcr0ty4': {
      'de': '8 members',
      'en': '',
    },
    'yc32iao9': {
      'de':
          'A community of book lovers who commit to reading at least 10 pages every morning. We share our progress, discuss interesting findings, and recommend great books to each other.',
      'en': '',
    },
    'dgqjrj38': {
      'de': 'Invite Friends',
      'en': '',
    },
    'fl1sfkpo': {
      'de': 'Group Habit',
      'en': '',
    },
    'vu84y09j': {
      'de': 'Read 10 pages',
      'en': '',
    },
    'xalm94la': {
      'de': '08:00 AM (Optional)',
      'en': '',
    },
    'toq3ob3x': {
      'de': 'Active Days:',
      'en': '',
    },
    'qfvdfzde': {
      'de': 'M',
      'en': '',
    },
    'ah8lnltf': {
      'de': 'T',
      'en': '',
    },
    'l8k88s34': {
      'de': 'W',
      'en': '',
    },
    'fg1humrf': {
      'de': 'T',
      'en': '',
    },
    'nifrnfqv': {
      'de': 'F',
      'en': '',
    },
    'hlq27n6k': {
      'de': 'S',
      'en': '',
    },
    'x1gncgq1': {
      'de': 'S',
      'en': '',
    },
    'o64m7mz2': {
      'de': 'Members',
      'en': '',
    },
    '04rakc52': {
      'de': 'JaneR',
      'en': '',
    },
    'm5vcdwsm': {
      'de': 'Leader',
      'en': '',
    },
    'r1wf1t98': {
      'de': 'Members',
      'en': '',
    },
    'spdijs05': {
      'de': 'JaneR',
      'en': '',
    },
    'w0cymwe9': {
      'de': 'Leader',
      'en': '',
    },
    'jgxeb401': {
      'de': 'Leave Group',
      'en': '',
    },
  },
  // statistics_screen
  {
    'nr1w2zcj': {
      'de': 'Statistics',
      'en': '',
    },
    'bqerj86e': {
      'de': 'Streak',
      'en': '',
    },
    'ezjaph7o': {
      'de': '8',
      'en': '',
    },
    'it1vq0r1': {
      'de': 'days in a row',
      'en': '',
    },
    'hplt8wwc': {
      'de': 'Max Streak',
      'en': '',
    },
    '43zpqv1x': {
      'de': '23',
      'en': '',
    },
    'titegc7k': {
      'de': 'days in a row',
      'en': '',
    },
    'c4k56jkc': {
      'de': 'Total Posts',
      'en': '',
    },
    'p20ker9v': {
      'de': '152',
      'en': '',
    },
    '3bwwnqxn': {
      'de': 'since you started',
      'en': '',
    },
    'bwnj13gt': {
      'de': 'Group Posts',
      'en': '',
    },
    '4hbtwclj': {
      'de': '47',
      'en': '',
    },
    'afcerjxv': {
      'de': 'with friends',
      'en': '',
    },
    'iej2yejz': {
      'de': 'Habit Categories',
      'en': '',
    },
    'fsfl3ixx': {
      'de': 'See which categories your habits fall into',
      'en': '',
    },
    'al681wub': {
      'de': 'This Week',
      'en': '',
    },
    'fy6s9g93': {
      'de': 'This Month',
      'en': '',
    },
    'zfs1ktqh': {
      'de': 'Physical',
      'en': '',
    },
    'xp5k1jv1': {
      'de': '17 check-ins',
      'en': '',
    },
    'sihxwgg9': {
      'de': 'Mental',
      'en': '',
    },
    'a2ps7c52': {
      'de': '12 check-ins',
      'en': '',
    },
    '2ripohmt': {
      'de': 'Learning',
      'en': '',
    },
    '24ngvsat': {
      'de': '10 check-ins',
      'en': '',
    },
    'kb7da1r5': {
      'de': 'Social',
      'en': '',
    },
    '3j5vwl1s': {
      'de': '8 check-ins',
      'en': '',
    },
    'um36hnq1': {
      'de': 'Health',
      'en': '',
    },
    'n4cu9v6x': {
      'de': '7 check-ins',
      'en': '',
    },
    'd11d7y19': {
      'de': 'Creativity',
      'en': '',
    },
    'ydkefvha': {
      'de': '5 check-ins',
      'en': '',
    },
  },
  // habit_configure
  {
    'uoy72169': {
      'de': 'Create Habit',
      'en': '',
    },
    'znbfms7b': {
      'de': 'Habit Name',
      'en': '',
    },
    '1k633i9r': {
      'de': 'Enter habit name',
      'en': '',
    },
    'hfbd6ief': {
      'de': 'Time (Optional)',
      'en': '',
    },
    'lch016c0': {
      'de': '08:00 AM',
      'en': '',
    },
    'z8k3r8u2': {
      'de': 'Days',
      'en': '',
    },
    'j1wgbwkw': {
      'de': 'M',
      'en': '',
    },
    'h7r4t8ij': {
      'de': 'T',
      'en': '',
    },
    'kdcmblme': {
      'de': 'W',
      'en': '',
    },
    'clbwih2d': {
      'de': 'T',
      'en': '',
    },
    'bboeouw7': {
      'de': 'F',
      'en': '',
    },
    'xdmz6e21': {
      'de': 'S',
      'en': '',
    },
    'z6ntn6yf': {
      'de': 'S',
      'en': '',
    },
    'ssb073ij': {
      'de': 'Color',
      'en': '',
    },
    'e9ivxfh1': {
      'de': 'Icon',
      'en': '',
    },
    '5sq430y4': {
      'de': 'Select Icon',
      'en': '',
    },
    'duoeg3ai': {
      'de': 'Category',
      'en': '',
    },
    'ww1rw39y': {
      'de': 'Physical',
      'en': '',
    },
    'ieiic0ns': {
      'de': 'Mental',
      'en': '',
    },
    'ec4ugesd': {
      'de': 'Learning',
      'en': '',
    },
    '98fmkouc': {
      'de': 'Social',
      'en': '',
    },
    '67xdqhyf': {
      'de': 'Health',
      'en': '',
    },
    '59caj3e5': {
      'de': 'Creativity',
      'en': '',
    },
    'p6ycnc8w': {
      'de': 'Productivity',
      'en': '',
    },
    'b5qt6f6w': {
      'de': 'Mindfulness',
      'en': '',
    },
    '66qp058a': {
      'de':
          'Categorizing your habit helps you organize and track patterns in your habit formation journey.',
      'en': '',
    },
  },
  // group_leaderboard
  {
    'wx4nh5m0': {
      'de': 'Hello World',
      'en': '',
    },
    '418pkdy3': {
      'de': 'See who\'s most consistent in the group',
      'en': '',
    },
    '6qhmk00o': {
      'de': 'This Week',
      'en': '',
    },
    'qede8qrj': {
      'de': 'This Month',
      'en': '',
    },
    '68qmi3pw': {
      'de': 'All Time',
      'en': '',
    },
    '2bv98tvs': {
      'de': '1',
      'en': '',
    },
    '75a54lgv': {
      'de': 'Emma',
      'en': '',
    },
    '9gtqodm4': {
      'de': '9 check-ins',
      'en': '',
    },
    'wmb2mr3m': {
      'de': '14-day streak',
      'en': '',
    },
    '1ure0n8i': {
      'de': '2',
      'en': '',
    },
    'irl0lb8g': {
      'de': 'You',
      'en': '',
    },
    '8gagm5gz': {
      'de': '8 check-ins',
      'en': '',
    },
    'o84yv25b': {
      'de': '25-day streak',
      'en': '',
    },
    't11bciph': {
      'de': '3',
      'en': '',
    },
    'n2syk12a': {
      'de': 'Jacob',
      'en': '',
    },
    'm73qczlr': {
      'de': '7 check-ins',
      'en': '',
    },
    'bf69ikfi': {
      'de': '10-day streak',
      'en': '',
    },
    '9us3r2pi': {
      'de': '4',
      'en': '',
    },
    'sjmcl9hf': {
      'de': 'Sarah',
      'en': '',
    },
    'vknjaxsh': {
      'de': '6 check-ins',
      'en': '',
    },
    'q13psil3': {
      'de': '6-day streak',
      'en': '',
    },
    'm7wi30s4': {
      'de': '5',
      'en': '',
    },
    'y50becld': {
      'de': 'Michael',
      'en': '',
    },
    'bt4l2hla': {
      'de': '5 check-ins',
      'en': '',
    },
    'xkp3bzmq': {
      'de': '5-day streak',
      'en': '',
    },
  },
  // post_Screen
  {
    'qehx0rpp': {
      'de': 'Journaling',
      'en': '',
    },
    'fh2g1xe2': {
      'de': 'Retake',
      'en': '',
    },
    'wa9zp2n7': {
      'de': 'Add a caption to your check-in...',
      'en': '',
    },
    'g8d8klvf': {
      'de': 'Private Post',
      'en': '',
    },
    'vo27c668': {
      'de': 'Post Check-In',
      'en': '',
    },
  },
  // group_creation_2
  {
    '8pwt1bxu': {
      'de': 'Create Habit',
      'en': '',
    },
    'n52lssqi': {
      'de': 'Group information',
      'en': '',
    },
    'mk8p3b43': {
      'de': 'Enter habit name',
      'en': '',
    },
    '6xx513o9': {
      'de': 'Brief description of the group (optional)',
      'en': '',
    },
    'gzgkjncy': {
      'de': 'Group Type',
      'en': '',
    },
    'habrbvsb': {
      'de': 'Private',
      'en': '',
    },
    'qtlpe3yt': {
      'de': 'Only visible via link',
      'en': '',
    },
    'u7c2h67w': {
      'de': 'Private',
      'en': '',
    },
    '931z9byq': {
      'de': 'Only visible via link',
      'en': '',
    },
    'sxcg6a6z': {
      'de': 'Private',
      'en': '',
    },
    'neixencx': {
      'de': 'Only visible via link',
      'en': '',
    },
    'kqrliash': {
      'de': 'Group habit information',
      'en': '',
    },
    'j4xe8vgz': {
      'de': 'Enter habit name',
      'en': '',
    },
    'ykqyd40j': {
      'de': '08:00 AM',
      'en': '',
    },
    'lmtvikyq': {
      'de': 'M',
      'en': '',
    },
    'h3fb4e5n': {
      'de': 'T',
      'en': '',
    },
    'sw2ibdpa': {
      'de': 'W',
      'en': '',
    },
    'goz8q4nq': {
      'de': 'T',
      'en': '',
    },
    '6ld9e79i': {
      'de': 'F',
      'en': '',
    },
    '29pvdgp0': {
      'de': 'S',
      'en': '',
    },
    'h1p5gfni': {
      'de': 'S',
      'en': '',
    },
    'wmno4n0p': {
      'de': 'Select Icon',
      'en': '',
    },
  },
  // login_screen
  {
    'jcl84ku8': {
      'de': 'Welcome back',
      'en': '',
    },
    'ex2fuw84': {
      'de': 'Sign in to your account to continue',
      'en': '',
    },
    'xmqn5ye0': {
      'de': 'Email',
      'en': '',
    },
    '8wxfq36k': {
      'de': 'you@example.com',
      'en': '',
    },
    'baaxg0pn': {
      'de': 'Password',
      'en': '',
    },
    'a1p0dqwr': {
      'de': 'Forgot password?',
      'en': '',
    },
    '5ugn2egv': {
      'de': 'Sign in',
      'en': '',
    },
    'n4xb5q4m': {
      'de': 'OR',
      'en': '',
    },
    'apzszk8t': {
      'de': 'Sign in with Google',
      'en': '',
    },
    '8nol2hvf': {
      'de': 'Don\'t have an account? ',
      'en': '',
    },
    'qid7i1mm': {
      'de': 'Create an account',
      'en': '',
    },
  },
  // forgotPassword_screen
  {
    'i13rkjnz': {
      'de': 'Reset your password',
      'en': '',
    },
    'malrqoft': {
      'de': 'Enter your email address and we\'ll send you a reset link',
      'en': '',
    },
    'ruvb2hvi': {
      'de': 'Email',
      'en': '',
    },
    'ctzysw0x': {
      'de': 'you@example.com',
      'en': '',
    },
    'm6e37oti': {
      'de': 'Enter the email address associated with your account.',
      'en': '',
    },
    'ldx3dvqv': {
      'de': 'Send reset link',
      'en': '',
    },
    'q76rfh9r': {
      'de': 'Back to login',
      'en': '',
    },
  },
  // signup_screen
  {
    '0gosyzd4': {
      'de': 'Create an account',
      'en': '',
    },
    'ks8yv9hy': {
      'de': 'Enter your details to create your account',
      'en': '',
    },
    'ojp7acfq': {
      'de': 'Email',
      'en': '',
    },
    'wsj30c4x': {
      'de': 'you@example.com',
      'en': '',
    },
    'vbjj43ng': {
      'de': 'Password',
      'en': '',
    },
    'i1q7x8uh': {
      'de': 'Username',
      'en': '',
    },
    'jvdw5o21': {
      'de': 'Birthday',
      'en': '',
    },
    'domcoetw': {
      'de': 'YYYY',
      'en': '',
    },
    '6h79a6k1': {
      'de': 'You must be at least 13 years old to use this service.',
      'en': '',
    },
    'vjqzemw9': {
      'de': 'I agree to the terms of service and privacy policy',
      'en': '',
    },
    'm5an2ndx': {
      'de': 'By creating an account, you agree to our ',
      'en': '',
    },
    'rbbty9tw': {
      'de': 'Terms of Service',
      'en': '',
    },
    'x5cnfgpw': {
      'de': ' and ',
      'en': '',
    },
    'hqpvp9r0': {
      'de': 'Privacy Policy',
      'en': '',
    },
    'rm8reted': {
      'de': 'Sign in',
      'en': '',
    },
    '14vmfpv5': {
      'de': 'Already have an account? ',
      'en': '',
    },
    'e1xg9tab': {
      'de': 'Sign in',
      'en': '',
    },
  },
  // confirmJoinGroup2
  {
    'vw8c9bws': {
      'de': 'Join Group',
      'en': '',
    },
    'uhhrzsjb': {
      'de': 'Daily Readers',
      'en': '',
    },
    'sn37v2ou': {
      'de': 'Public',
      'en': '',
    },
    'ra2jdulp': {
      'de': '86 members',
      'en': '',
    },
    '9mw1amvz': {
      'de': 'About this group',
      'en': '',
    },
    'sjaxohpt': {
      'de':
          'Join us as we read at least 10 pages every day. Share book recommendations and discuss your latest reads with the community!',
      'en': '',
    },
    'ycoy68w3': {
      'de': 'Group Habit',
      'en': '',
    },
    'rccof86l': {
      'de': 'Read 10 pages',
      'en': '',
    },
  },
  // supportScreen
  {
    'o9sfq8jn': {
      'de': 'Contact Us',
      'en': '',
    },
    'oq7lelxo': {
      'de': 'Send us a message and we\'ll get back to you as soon as possible.',
      'en': '',
    },
    'n5ja8cbb': {
      'de': 'Reason for contact',
      'en': '',
    },
    '41tnjyyb': {
      'de': '📩 Feedback',
      'en': '',
    },
    'mvmyrkl8': {
      'de': '⚠️ Report an issue',
      'en': '',
    },
    'uly48p0u': {
      'de': '📦 Receive personal data',
      'en': '',
    },
    '0p7uavcm': {
      'de': '🗑️ Account deletion',
      'en': '',
    },
    'hj4wzcaw': {
      'de': '➕ Other',
      'en': '',
    },
    'jr754jrp': {
      'de': 'Your email address',
      'en': '',
    },
    'assaubjl': {
      'de': ' *',
      'en': '',
    },
    '16s6tuii': {
      'de': 'Enter your email address',
      'en': '',
    },
    'hgwa2li4': {
      'de': 'Your message',
      'en': '',
    },
    'gd5ems9f': {
      'de': 'Tell us how we can help...',
      'en': '',
    },
    '5vvolqy9': {
      'de': 'Send message',
      'en': '',
    },
    'e0rpmxxd': {
      'de': 'Cancel',
      'en': '',
    },
  },
  // profile_screen2
  {
    'f198t6i7': {
      'de': 'My Profile',
      'en': '',
    },
    'ybjjwa3s': {
      'de': 'lazylevin123',
      'en': '',
    },
    'ep1vo1mu': {
      'de': 'Member since Apr 2025',
      'en': '',
    },
    '4y54avtu': {
      'de': 'I\'m tracking my habits and making progress every day!',
      'en': '',
    },
    'ife4fo6p': {
      'de': 'Search friends...',
      'en': '',
    },
    '3t2dyqaa': {
      'de': 'Alex Kowac',
      'en': '',
    },
    'bf8hn2z6': {
      'de': '3 mutual habits',
      'en': '',
    },
    'f8hdpj7v': {
      'de': 'Maya Johnson',
      'en': '',
    },
    '8byvz6x2': {
      'de': '5 mutual habits',
      'en': '',
    },
    'anyor4ur': {
      'de': 'Carlos Mendez',
      'en': '',
    },
    'g4kmkm20': {
      'de': '2 mutual habits',
      'en': '',
    },
    'ch55tcb9': {
      'de': 'Sarah Williams',
      'en': '',
    },
    'k8a2xo1e': {
      'de': '7 mutual habits',
      'en': '',
    },
    'ie0eiug4': {
      'de': 'Jordan Lee',
      'en': '',
    },
    'gjriids5': {
      'de': '4 mutual habits',
      'en': '',
    },
  },
  // supportScreenCopy
  {
    '97q2tpif': {
      'de': 'Contact Us',
      'en': '',
    },
    'edw06gyn': {
      'de': 'Send us a message and we\'ll get back to you as soon as possible.',
      'en': '',
    },
    '04cob80g': {
      'de': 'Reason for contact',
      'en': '',
    },
    'fdpxye3f': {
      'de': '📩 Feedback',
      'en': '',
    },
    'oz0q0s0o': {
      'de': '⚠️ Report an issue',
      'en': '',
    },
    '0mg7fqwk': {
      'de': '📦 Receive personal data',
      'en': '',
    },
    'a6euqu6g': {
      'de': '🗑️ Account deletion',
      'en': '',
    },
    'kh0ehgv8': {
      'de': '➕ Other',
      'en': '',
    },
    'eet7ay7h': {
      'de': 'Your email address',
      'en': '',
    },
    'q1yiytcf': {
      'de': ' *',
      'en': '',
    },
    't3lnws16': {
      'de': 'Enter your email address',
      'en': '',
    },
    'cgo5ym1b': {
      'de': 'Your message',
      'en': '',
    },
    'i6masrx6': {
      'de': 'Tell us how we can help...',
      'en': '',
    },
    '4zpr3gxa': {
      'de': 'Send message',
      'en': '',
    },
    'n1mz9efg': {
      'de': 'Cancel',
      'en': '',
    },
    'y9s10ipl': {
      'de': 'Option 1',
      'en': '',
    },
    'sljjnukb': {
      'de': 'Option 2',
      'en': '',
    },
    'g3xw0wla': {
      'de': 'Option 3',
      'en': '',
    },
  },
  // streak_page
  {
    'l5hlxu8x': {
      'de': '21',
      'en': '',
    },
    '3c9f9t29': {
      'de': 'day streak!',
      'en': '',
    },
    'qcfdyz36': {
      'de': 'You\'ve stayed consistent for 21 days – keep the momentum going!',
      'en': '',
    },
    'le7oay1x': {
      'de': 'Share',
      'en': '',
    },
    'gkxdodb7': {
      'de': 'Continue',
      'en': '',
    },
  },
  // feedcard
  {
    'ltw1ki3o': {
      'de': 'sarah',
      'en': '',
    },
    'p6rco3pc': {
      'de': 'Completed my morning run! 5km in 25 minutes, a new personal best!',
      'en': '',
    },
    'y11mlk40': {
      'de': '👅 React',
      'en': '',
    },
    'ky8tl0o9': {
      'de': '2',
      'en': '',
    },
    'mng66p9n': {
      'de': '10h ago',
      'en': '',
    },
  },
  // Friendlistitem
  {
    'jau915vf': {
      'de': 'Alex Kowac',
      'en': '',
    },
  },
  // Habitcard
  {
    'ocivy9st': {
      'de': 'Self-care',
      'en': '',
    },
    'u4m4bidd': {
      'de': '09:15',
      'en': '',
    },
    '47lyi7wg': {
      'de': 'M',
      'en': '',
    },
    '5h9sa52r': {
      'de': 'M',
      'en': '',
    },
    'a0vrj50a': {
      'de': 'M',
      'en': '',
    },
    'fu48xf2d': {
      'de': 'M',
      'en': '',
    },
    'w8cryc0h': {
      'de': 'M',
      'en': '',
    },
    'xkkawx75': {
      'de': 'M',
      'en': '',
    },
    'byt540hv': {
      'de': 'M',
      'en': '',
    },
  },
  // Tabbar
  {
    'qkem2ayu': {
      'de': 'Friends',
      'en': '',
    },
    '06yity6g': {
      'de': 'Friends of Friends',
      'en': '',
    },
    'ggzhlty1': {
      'de': 'Coming Soon',
      'en': '',
    },
    'bgk4ztgp': {
      'de': 'This feature will be availiable in an upcoming update.',
      'en': '',
    },
  },
  // ExistingGroup
  {
    '4k40sy3j': {
      'de': 'Public',
      'en': '',
    },
  },
  // DiscoverGroup
  {
    '1cqyh5uj': {
      'de': 'Public',
      'en': '',
    },
    'jgrrzt1q': {
      'de': 'Join',
      'en': '',
    },
  },
  // friend_message
  {
    '0zn8t2n0': {
      'de': 'E',
      'en': '',
    },
    'cy4vbq8r': {
      'de': 'Emma',
      'en': '',
    },
    'gcs4n56m': {
      'de':
          'That\'s a great goal! I\'m aiming for 25 pages myself. Love your reading nook!',
      'en': '',
    },
    'r21q9tz4': {
      'de': '20:32',
      'en': '',
    },
  },
  // currentuser_message
  {
    'ej93pxu8': {
      'de':
          'I\'m about to start my morning session. Hoping to finish 30 pages today!',
      'en': '',
    },
    'fpc7t1br': {
      'de': '20:17',
      'en': '',
    },
  },
  // popupGroupjoin
  {
    'gz60intn': {
      'de': 'Join Group',
      'en': '',
    },
    'rbkk2g3e': {
      'de': 'Daily Readers',
      'en': '',
    },
    's1ar25ki': {
      'de': 'Public',
      'en': '',
    },
    'd4gj93om': {
      'de': '86 members',
      'en': '',
    },
    'b7t1c144': {
      'de': 'About this group',
      'en': '',
    },
    'nljzur53': {
      'de':
          'Join us as we read at least 10 pages every day. Share book recommendations and discuss your latest reads with the community!',
      'en': '',
    },
    '0exudm0g': {
      'de': 'Group Habit',
      'en': '',
    },
    '8f3g17im': {
      'de': 'Read 10 pages',
      'en': '',
    },
    'vmkuohk4': {
      'de': 'Cancel',
      'en': '',
    },
    'h7nsbp0w': {
      'de': 'Join Group',
      'en': '',
    },
  },
  // Miscellaneous
  {
    'gvxpduya': {
      'de': '',
      'en': '',
    },
    '02cheus0': {
      'de': '',
      'en': '',
    },
    '0miysv00': {
      'de': '',
      'en': '',
    },
    'xa1himpx': {
      'de': '',
      'en': '',
    },
    'oisjwf3n': {
      'de': '',
      'en': '',
    },
    'fj4r9861': {
      'de': '',
      'en': '',
    },
    'ta8uquug': {
      'de': '',
      'en': '',
    },
    'f6l5wfle': {
      'de': '',
      'en': '',
    },
    'ypqfilq9': {
      'de': '',
      'en': '',
    },
    'z39lvhbb': {
      'de': '',
      'en': '',
    },
    'q8yba67u': {
      'de': '',
      'en': '',
    },
    'gpzelp4p': {
      'de': '',
      'en': '',
    },
    'co7vp6yr': {
      'de': '',
      'en': '',
    },
    'tk62je0j': {
      'de': '',
      'en': '',
    },
    'y11i7oqe': {
      'de': '',
      'en': '',
    },
    'kp50twwe': {
      'de': '',
      'en': '',
    },
    '5r8r7dkh': {
      'de': '',
      'en': '',
    },
    'rw8p72u5': {
      'de': '',
      'en': '',
    },
    '4w5u8sjf': {
      'de': '',
      'en': '',
    },
    '8e5fhz1x': {
      'de': '',
      'en': '',
    },
    '3le1qzu6': {
      'de': '',
      'en': '',
    },
    '7g0dv4ah': {
      'de': '',
      'en': '',
    },
    'bjwl72fw': {
      'de': '',
      'en': '',
    },
    'ity22no1': {
      'de': '',
      'en': '',
    },
    'slvl00dk': {
      'de': '',
      'en': '',
    },
  },
].reduce((a, b) => a..addAll(b));
