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

  static List<String> languages() => ['de', 'en']; // Keep supported languages

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
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? key; // Return key if translation missing

  String getVariableText({
    String? deText = '',
    String? enText = '',
  }) =>
      [deText, enText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar', 'az', 'ca', 'cs', 'da', 'de', 'dv', 'en', 'es', 'et', 'fi', 'fr',
    'gr', 'he', 'hi', 'hu', 'it', 'km', 'ku', 'mn', 'ms', 'no', 'pt', 'ro',
    'ru', 'rw', 'sv', 'th', 'uk', 'vi',
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

// ================== TRANSLATIONS START (GERMAN CORRECTED) ==================
final kTranslationsMap = <Map<String, Map<String, String>>>[
  // Feedscreen
  {
    '40uc9yol': { 'de': 'Freunde', 'en': 'Friends', },
    '9sgbuu77': { 'de': 'Entdecken', 'en': 'Discover', },
    '5cvgp873': { 'de': 'Kommt bald', 'en': 'Coming Soon', },
    'kvn9u2me': { 'de': 'Diese Funktion wird in einem zukünftigen Update verfügbar sein.', 'en': 'This feature will be available in an upcoming update.', },
    'j2028ukr': { 'de': 'Prabit', 'en': 'Prabit', },
  },
  // Profilescreen / profile_screen2
  {
    'qfklgi1u': { 'de': 'Mein Profil', 'en': 'My Profile', },
    'f198t6i7': { 'de': 'Mein Profil', 'en': 'My Profile', },
    'pappnzlc': { 'de': 'lazylevin123', 'en': 'lazylevin123', },
    'ybjjwa3s': { 'de': 'lazylevin123', 'en': 'lazylevin123', },
    '6z20lrxo': { 'de': 'Mitglied seit Apr 2025', 'en': 'Member since Apr 2025', },
    'ep1vo1mu': { 'de': 'Mitglied seit Apr 2025', 'en': 'Member since Apr 2025', },
    '8i56dofc': { 'de': 'Ich verfolge meine Gewohnheiten und mache jeden Tag Fortschritte!', 'en': 'I\'m tracking my habits and making progress every day!', },
    '4y54avtu': { 'de': 'Ich verfolge meine Gewohnheiten und mache jeden Tag Fortschritte!', 'en': 'I\'m tracking my habits and making progress every day!', },
    '3nqlkwra': { 'de': 'Freunde suchen...', 'en': 'Search friends...', },
    'ife4fo6p': { 'de': 'Freunde suchen...', 'en': 'Search friends...', },
    '3t2dyqaa': { 'de': 'Alex Kowac', 'en': 'Alex Kowac', },
    'bf8hn2z6': { 'de': '3 gemeinsame Gewohnheiten', 'en': '3 mutual habits', },
    'f8hdpj7v': { 'de': 'Maya Johnson', 'en': 'Maya Johnson', },
    '8byvz6x2': { 'de': '5 gemeinsame Gewohnheiten', 'en': '5 mutual habits', },
    'anyor4ur': { 'de': 'Carlos Mendez', 'en': 'Carlos Mendez', },
    'g4kmkm20': { 'de': '2 gemeinsame Gewohnheiten', 'en': '2 mutual habits', },
    'ch55tcb9': { 'de': 'Sarah Williams', 'en': 'Sarah Williams', },
    'k8a2xo1e': { 'de': '7 gemeinsame Gewohnheiten', 'en': '7 mutual habits', },
    'ie0eiug4': { 'de': 'Jordan Lee', 'en': 'Jordan Lee', },
    'gjriids5': { 'de': '4 gemeinsame Gewohnheiten', 'en': '4 mutual habits', },
  },
  // calendar / calendar_widget
  {
    '1by656i7': { 'de': 'Kalender', 'en': 'Calendar', },
    'qila67g3': { 'de': 'März 2025', 'en': 'March 2025', }, // Dynamic date recommended
    '177k9c8v': { 'de': 'S', 'en': 'S', }, // Sonntag
    'ufrpfnpk': { 'de': 'M', 'en': 'M', }, // Montag
    'yp2erjj3': { 'de': 'D', 'en': 'T', }, // Dienstag
    'i58o23eb': { 'de': 'M', 'en': 'W', }, // Mittwoch
    'hynvrs95': { 'de': 'D', 'en': 'T', }, // Donnerstag
    '4rjz0t0e': { 'de': 'F', 'en': 'F', }, // Freitag
    '1s4y3l7p': { 'de': 'S', 'en': 'S', }, // Samstag
    // Numbers generally don't need translation keys
    '4qj321w0': { 'de': '1', 'en': '1', }, 'jn8sj7b4': { 'de': '2', 'en': '2', }, '5obmi5ju': { 'de': '3', 'en': '3', },
    's3hxx9tj': { 'de': '4', 'en': '4', }, 'e6zaqfuc': { 'de': '5', 'en': '5', }, '6ttaw8xf': { 'de': '6', 'en': '6', },
    'k5soyhgt': { 'de': '7', 'en': '7', }, 'uuvvq7xg': { 'de': '8', 'en': '8', }, 'g54285j5': { 'de': '9', 'en': '9', },
    'ibv418ck': { 'de': '11', 'en': '11', }, 'uz8d7glt': { 'de': '12', 'en': '12', }, 'xwdtwmgx': { 'de': '13', 'en': '13', },
    'v47dxaoi': { 'de': '14', 'en': '14', }, 'nyqax5i2': { 'de': '15', 'en': '15', }, 'fkyy5wq5': { 'de': '3', 'en': '3', },
    'bzdt9s1p': { 'de': '16', 'en': '16', }, 'wfhih6hk': { 'de': '17', 'en': '17', }, '6jeepcrh': { 'de': '18', 'en': '18', },
    'l98l1wkr': { 'de': '19', 'en': '19', }, '5c4u5gc1': { 'de': '20', 'en': '20', }, 'lwbsj8pm': { 'de': '21', 'en': '21', },
    'a1syk1w3': { 'de': '22', 'en': '22', }, 'scann1ne': { 'de': '2', 'en': '2', }, 'uk5vf7wf': { 'de': '23', 'en': '23', },
    'u0v8xomu': { 'de': '24', 'en': '24', }, '1hwjpcfq': { 'de': '25', 'en': '25', }, '4x0db481': { 'de': '26', 'en': '26', },
    '7je9ecp1': { 'de': '27', 'en': '27', }, '77iidrvy': { 'de': '28', 'en': '28', }, 'fskyvbv4': { 'de': '29', 'en': '29', },
    'urmmp82a': { 'de': '30', 'en': '30', }, 'lm7c2zg4': { 'de': '31', 'en': '31', },
  },
  // statistiscpage / statistics_screen
  {
    '4sl2onmm': { 'de': 'Statistiken', 'en': 'Statistics', },
    'nr1w2zcj': { 'de': 'Statistiken', 'en': 'Statistics', },
    'i1x4r4oh': { 'de': '8', 'en': '8', },
    'ezjaph7o': { 'de': '8', 'en': '8', },
    'coa9vvfd': { 'de': 'Aktuelle Serie', 'en': 'Current Streak', },
    'bqerj86e': { 'de': 'Serie', 'en': 'Streak', },
    'it1vq0r1': { 'de': 'Tage in Folge', 'en': 'days in a row', },
    'umnfc3vw': { 'de': '23', 'en': '23', },
    '43zpqv1x': { 'de': '23', 'en': '23', },
    '9yus97gl': { 'de': 'Längste Serie', 'en': 'Longest Streak', },
    'hplt8wwc': { 'de': 'Max. Serie', 'en': 'Max Streak', },
    'titegc7k': { 'de': 'Tage in Folge', 'en': 'days in a row', },
    'jveitc1u': { 'de': '152', 'en': '152', },
    'p20ker9v': { 'de': '152', 'en': '152', },
    'yq6jdhxn': { 'de': 'Check-ins gesamt', 'en': 'Total Check-ins', },
    'c4k56jkc': { 'de': 'Posts gesamt', 'en': 'Total Posts', }, // Changed 'Posts'
    '3bwwnqxn': { 'de': 'seit Beginn', 'en': 'since you started', },
    'ewo9brwi': { 'de': '47', 'en': '47', },
    '4hbtwclj': { 'de': '47', 'en': '47', },
    'pvmzu0v6': { 'de': 'Gruppen Check-ins', 'en': 'Group Check-ins', },
    'bwnj13gt': { 'de': 'Gruppen Posts', 'en': 'Group Posts', }, // Changed 'Posts'
    'afcerjxv': { 'de': 'mit Freunden', 'en': 'with friends', },
    '2esbnt1b': { 'de': 'Diese Woche', 'en': 'This Week', },
    'al681wub': { 'de': 'Diese Woche', 'en': 'This Week', },
    'b4rqtut6': { 'de': 'Dieser Monat', 'en': 'This Month', },
    'fy6s9g93': { 'de': 'Dieser Monat', 'en': 'This Month', },
    'iej2yejz': { 'de': 'Gewohnheitskategorien', 'en': 'Habit Categories', },
    'fsfl3ixx': { 'de': 'Sieh, in welche Kategorien deine Gewohnheiten fallen', 'en': 'See which categories your habits fall into', },
    'mrp0arbc': { 'de': 'Körperlich', 'en': 'Physical', },
    'zfs1ktqh': { 'de': 'Körperlich', 'en': 'Physical', },
    '6isgu2gh': { 'de': '17 Check-ins', 'en': '17 check-ins', },
    'xp5k1jv1': { 'de': '17 Check-ins', 'en': '17 check-ins', },
    '753fpgdj': { 'de': 'Geistig', 'en': 'Mental', },
    'sihxwgg9': { 'de': 'Geistig', 'en': 'Mental', },
    '2zj49ztz': { 'de': '12 Check-ins', 'en': '12 check-ins', },
    'a2ps7c52': { 'de': '12 Check-ins', 'en': '12 check-ins', },
    'f8w7rhyq': { 'de': 'Lernen', 'en': 'Learning', },
    '2ripohmt': { 'de': 'Lernen', 'en': 'Learning', },
    'vypwijcz': { 'de': '10 Check-ins', 'en': '10 check-ins', },
    '24ngvsat': { 'de': '10 Check-ins', 'en': '10 check-ins', },
    'rktvmerh': { 'de': 'Sozial', 'en': 'Social', },
    'kb7da1r5': { 'de': 'Sozial', 'en': 'Social', },
    'al0hizd0': { 'de': '8 Check-ins', 'en': '8 check-ins', },
    '3j5vwl1s': { 'de': '8 Check-ins', 'en': '8 check-ins', },
    'marswflr': { 'de': 'Gesundheit', 'en': 'Health', },
    'um36hnq1': { 'de': 'Gesundheit', 'en': 'Health', },
    'l7hut59c': { 'de': '7 Check-ins', 'en': '7 check-ins', },
    'n4cu9v6x': { 'de': '7 Check-ins', 'en': '7 check-ins', },
    'ba02iqp0': { 'de': 'Kreativität', 'en': 'Creativity', },
    'd11d7y19': { 'de': 'Kreativität', 'en': 'Creativity', },
    'p7zqfwtw': { 'de': '5 Check-ins', 'en': '5 check-ins', },
    'ydkefvha': { 'de': '5 Check-ins', 'en': '5 check-ins', },
    '5kx7e47z': { 'de': 'Du machst das großartig!\nHalte deine 8-Tage-Serie aufrecht, um einen neuen persönlichen Rekord zu erreichen.', 'en': 'You\'re doing great!\nKeep up your 8-day streak to reach a new personal record.', },
  },
  // groupcreationscreen / group_creation_2
  {
    'aqw0su40': { 'de': 'Gruppe erstellen', 'en': 'Create Group', },
    '8pwt1bxu': { 'de': 'Gewohnheit erstellen', 'en': 'Create Habit', }, // Title discrepancy? Assuming Create Group was intended
    '2yfba7eg': { 'de': 'Gruppeninformationen', 'en': 'Group Information', },
    'n52lssqi': { 'de': 'Gruppeninformationen', 'en': 'Group information', },
    'z2onr9tn': { 'de': 'Gruppennamen eingeben', 'en': 'Enter group name', },
    'mk8p3b43': { 'de': 'Gewohnheitsnamen eingeben', 'en': 'Enter habit name', }, // Assuming group name placeholder was intended
    'ref2t7lu': { 'de': 'Kurze Beschreibung der Gruppe (optional)', 'en': 'Brief description of the group (optional)', },
    '6xx513o9': { 'de': 'Kurze Beschreibung der Gruppe (optional)', 'en': 'Brief description of the group (optional)', },
    '9bkg5yg6': { 'de': 'Gruppentyp', 'en': 'Group Type', },
    'gzgkjncy': { 'de': 'Gruppentyp', 'en': 'Group Type', },
    'bvvh974p': { 'de': 'Öffentlich', 'en': 'Public', },
    'habrbvsb': { 'de': 'Privat', 'en': 'Private', },
    'qtlpe3yt': { 'de': 'Nur per Link sichtbar', 'en': 'Only visible via link', },
    'u7c2h67w': { 'de': 'Privat', 'en': 'Private', },
    '931z9byq': { 'de': 'Nur per Link sichtbar', 'en': 'Only visible via link', },
    'sxcg6a6z': { 'de': 'Privat', 'en': 'Private', },
    'neixencx': { 'de': 'Nur per Link sichtbar', 'en': 'Only visible via link', },
    'o4w2uohq': { 'de': 'Details zur Gruppengewohnheit', 'en': 'Group Habit Details', },
    'kqrliash': { 'de': 'Informationen zur Gruppengewohnheit', 'en': 'Group habit information', },
    'aj2p5hw4': { 'de': 'Gewohnheitsnamen eingeben', 'en': 'Enter habit name', },
    'j4xe8vgz': { 'de': 'Gewohnheitsnamen eingeben', 'en': 'Enter habit name', },
    'jyxjxp2z': { 'de': '08:00', 'en': '08:00 AM', }, // Using 24h format for German
    'ykqyd40j': { 'de': '08:00', 'en': '08:00 AM', }, // Using 24h format for German
    'ylzv2ngb': { 'de': 'Optional', 'en': 'Optional', },
    'ytbvwjfo': { 'de': 'Wochentage', 'en': 'Days of the Week', },
    'ik82jp1f': { 'de': 'M', 'en': 'M', }, 'lmtvikyq': { 'de': 'M', 'en': 'M', },
    'r8puj4io': { 'de': 'D', 'en': 'T', }, 'h3fb4e5n': { 'de': 'D', 'en': 'T', },
    '2busx7k5': { 'de': 'M', 'en': 'W', }, 'sw2ibdpa': { 'de': 'M', 'en': 'W', },
    '89cfwxk3': { 'de': 'D', 'en': 'T', }, 'goz8q4nq': { 'de': 'D', 'en': 'T', },
    'wb9bjyvp': { 'de': 'F', 'en': 'F', }, '6ld9e79i': { 'de': 'F', 'en': 'F', },
    'g1nezn34': { 'de': 'S', 'en': 'S', }, '29pvdgp0': { 'de': 'S', 'en': 'S', },
    'hm5txx91': { 'de': 'S', 'en': 'S', }, 'h1p5gfni': { 'de': 'S', 'en': 'S', },
    'te6mfxa8': { 'de': 'Symbol wählen', 'en': 'Choose an icon', },
    'wmno4n0p': { 'de': 'Symbol auswählen', 'en': 'Select Icon', },
    'ven4ixg3': { 'de': 'Farbe', 'en': 'Color', },
    'zio7nedw': { 'de': 'Freunde einladen', 'en': 'Invite Friends', },
  },
  // settings
  {
    'lk39x5at': { 'de': 'Einstellungen', 'en': 'Settings', },
    'cyi02yrp': { 'de': 'SUPPORT', 'en': 'SUPPORT', },
    '0djp10fi': { 'de': 'Kontakt', 'en': 'Contact Us', },
    'qg4ucjhk': { 'de': 'RECHTLICHES', 'en': 'LEGAL', },
    'eb5xlt4v': { 'de': 'Impressum', 'en': 'Legal Notice', },
    '4vqvhygk': { 'de': 'Datenschutz', 'en': 'Privacy Policy', },
    '11if3nk1': { 'de': 'KONTO', 'en': 'ACCOUNT', },
    'o8z58kus': { 'de': 'Abmelden', 'en': 'Log Out', },
    'xhlmnyuv': { 'de': 'CREDITS', 'en': 'CREDITS', },
    'dd81xh2h': { 'de': 'CREDITS', 'en': 'CREDITS', },
    '44vyrai6': { 'de': 'Design & Entwicklung', 'en': 'Design & Development', },
    '7av6gg7q': { 'de': 'Design & Entwicklung', 'en': 'Design & Development', },
    '9swjw4fn': { 'de': 'Prabit Team', 'en': 'Prabit Team', },
    'tnbeenj0': { 'de': 'Prabit Team', 'en': 'Prabit Team', },
    'settingsLanguageSectionHeader': { 'de': 'SPRACHE', 'en': 'LANGUAGE', },
    'settingsLanguageRowLabel': { 'de': 'Sprache', 'en': 'Language', },
  },
  // HabitSelectionScreen
  {
    '43f5vne0': { 'de': 'Gewohnheiten', 'en': 'Habits', },
    'i3xr2cf1': { 'de': 'Deine Gewohnheiten', 'en': 'Your habits', },
    '21878072': { 'de': 'Gruppengewohnheiten', 'en': 'Group habits', },
    'yz1r8wf2': { 'de': 'iui', 'en': 'iui', }, // Placeholder?
  },
  // group
  {
    'n29bio07': { 'de': 'Gruppen', 'en': 'Groups', },
    '79hv9d87': { 'de': 'Meine Gruppen', 'en': 'My Groups', },
    '82rc6hzr': { 'de': 'Gruppen entdecken', 'en': 'Discover Groups', },
  },
  // group_chat
  {
    'wm2tbgzb': { 'de': 'MR', 'en': 'MR', },
    'eezpdxjc': { 'de': 'Morgenleser', 'en': 'Morning Readers', },
    '35tjdagv': { 'de': '5 Mitglieder', 'en': '5 members', },
    'pnkohbh6': { 'de': 'S', 'en': 'S', },
    '693u8axr': { 'de': 'Sarah', 'en': 'Sarah', },
    '4u0g83tz': { 'de': 'Heutiger Leseplatz. Perfektes Licht und Ambiente! 📖✨', 'en': 'Today\'s reading spot. Perfect lighting and ambiance! 📖✨', },
    'q7fnv0k4': { 'de': '20:05', 'en': '20:05', },
    'pwignj4b': { 'de': 'S', 'en': 'S', },
    'lnmjr5ir': { 'de': 'Sarah', 'en': 'Sarah', },
    'mozial58': { 'de': 'Danke! Welches Buch liest du diese Woche?', 'en': 'Thanks! What book are you reading this week?', },
    'ydju482e': { 'de': '20:37', 'en': '20:37', },
    '8mkzzmc9': { 'de': 'Ich lese \'Atomic Habits\' von James Clear. Es ist wirklich aufschlussreich über den Aufbau guter Routinen!', 'en': 'I\'m reading \'Atomic Habits\' by James Clear. It\'s really insightful about building good routines!', },
    '4arisy3o': { 'de': '20:40', 'en': '20:40', },
    '8w3nbhcn': { 'de': 'Nachricht schreiben...', 'en': 'Type a message...', },
  },
  // group_details
  {
    'wvuzckm1': { 'de': 'Morgenleser', 'en': 'Morning Readers', },
    'cpiyu9ck': { 'de': '3', 'en': '3', },
    'hsf8rpws': { 'de': 'Morgenleser', 'en': 'Morning Readers', },
    'tejaimfo': { 'de': 'Privat', 'en': 'Private', },
    'oqcr0ty4': { 'de': '8 Mitglieder', 'en': '8 members', },
    'yc32iao9': { 'de': 'Eine Gemeinschaft von Buchliebhabern, die sich verpflichten, jeden Morgen mindestens 10 Seiten zu lesen. Wir teilen unseren Fortschritt, diskutieren interessante Erkenntnisse und empfehlen uns gegenseitig tolle Bücher.', 'en': 'A community of book lovers who commit to reading at least 10 pages every morning. We share our progress, discuss interesting findings, and recommend great books to each other.', },
    'dgqjrj38': { 'de': 'Freunde einladen', 'en': 'Invite Friends', },
    'fl1sfkpo': { 'de': 'Gruppengewohnheit', 'en': 'Group Habit', },
    'vu84y09j': { 'de': '10 Seiten lesen', 'en': 'Read 10 pages', },
    'xalm94la': { 'de': '08:00 (Optional)', 'en': '08:00 AM (Optional)', }, // Using 24h format for German
    'toq3ob3x': { 'de': 'Aktive Tage:', 'en': 'Active Days:', },
    'qfvdfzde': { 'de': 'M', 'en': 'M', }, 'ah8lnltf': { 'de': 'D', 'en': 'T', }, 'l8k88s34': { 'de': 'M', 'en': 'W', },
    'fg1humrf': { 'de': 'D', 'en': 'T', }, 'nifrnfqv': { 'de': 'F', 'en': 'F', }, 'hlq27n6k': { 'de': 'S', 'en': 'S', },
    'x1gncgq1': { 'de': 'S', 'en': 'S', },
    'o64m7mz2': { 'de': 'Mitglieder', 'en': 'Members', },
    '04rakc52': { 'de': 'JaneR', 'en': 'JaneR', },
    'm5vcdwsm': { 'de': 'Leiter', 'en': 'Leader', },
    'r1wf1t98': { 'de': 'Mitglieder', 'en': 'Members', },
    'spdijs05': { 'de': 'JaneR', 'en': 'JaneR', },
    'w0cymwe9': { 'de': 'Leiter', 'en': 'Leader', },
    'jgxeb401': { 'de': 'Gruppe verlassen', 'en': 'Leave Group', },
  },
  // group_leaderboard
  {
    'wx4nh5m0': { 'de': 'Hallo Welt', 'en': 'Hello World', }, // Placeholder?
    '418pkdy3': { 'de': 'Sieh, wer in der Gruppe am beständigsten ist', 'en': 'See who\'s most consistent in the group', },
    '6qhmk00o': { 'de': 'Diese Woche', 'en': 'This Week', },
    'qede8qrj': { 'de': 'Dieser Monat', 'en': 'This Month', },
    '68qmi3pw': { 'de': 'Gesamt', 'en': 'All Time', },
    '2bv98tvs': { 'de': '1', 'en': '1', }, '75a54lgv': { 'de': 'Emma', 'en': 'Emma', },
    '9gtqodm4': { 'de': '9 Check-ins', 'en': '9 check-ins', }, 'wmb2mr3m': { 'de': '14-Tage-Serie', 'en': '14-day streak', },
    '1ure0n8i': { 'de': '2', 'en': '2', }, 'irl0lb8g': { 'de': 'Du', 'en': 'You', },
    '8gagm5gz': { 'de': '8 Check-ins', 'en': '8 check-ins', }, 'o84yv25b': { 'de': '25-Tage-Serie', 'en': '25-day streak', },
    't11bciph': { 'de': '3', 'en': '3', }, 'n2syk12a': { 'de': 'Jacob', 'en': 'Jacob', },
    'm73qczlr': { 'de': '7 Check-ins', 'en': '7 check-ins', }, 'bf69ikfi': { 'de': '10-Tage-Serie', 'en': '10-day streak', },
    '9us3r2pi': { 'de': '4', 'en': '4', }, 'sjmcl9hf': { 'de': 'Sarah', 'en': 'Sarah', },
    'vknjaxsh': { 'de': '6 Check-ins', 'en': '6 check-ins', }, 'q13psil3': { 'de': '6-Tage-Serie', 'en': '6-day streak', },
    'm7wi30s4': { 'de': '5', 'en': '5', }, 'y50becld': { 'de': 'Michael', 'en': 'Michael', },
    'bt4l2hla': { 'de': '5 Check-ins', 'en': '5 check-ins', }, 'xkp3bzmq': { 'de': '5-Tage-Serie', 'en': '5-day streak', },
  },
  // post_Screen
  {
    'qehx0rpp': { 'de': 'Tagebuch schreiben', 'en': 'Journaling', },
    'fh2g1xe2': { 'de': 'Wiederholen', 'en': 'Retake', },
    'wa9zp2n7': { 'de': 'Füge deinem Check-in eine Bildunterschrift hinzu...', 'en': 'Add a caption to your check-in...', },
    'g8d8klvf': { 'de': 'Privater Post', 'en': 'Private Post', },
    'vo27c668': { 'de': 'Check-In posten', 'en': 'Post Check-In', },
  },
  // login_screen
  {
    'jcl84ku8': { 'de': 'Willkommen zurück', 'en': 'Welcome back', },
    'ex2fuw84': { 'de': 'Melde dich bei deinem Konto an, um fortzufahren', 'en': 'Sign in to your account to continue', },
    'xmqn5ye0': { 'de': 'E-Mail', 'en': 'Email', },
    '8wxfq36k': { 'de': 'du@beispiel.com', 'en': 'you@example.com', },
    'baaxg0pn': { 'de': 'Passwort', 'en': 'Password', },
    'a1p0dqwr': { 'de': 'Passwort vergessen?', 'en': 'Forgot password?', },
    '5ugn2egv': { 'de': 'Anmelden', 'en': 'Sign in', },
    'n4xb5q4m': { 'de': 'ODER', 'en': 'OR', },
    'apzszk8t': { 'de': 'Mit Google anmelden', 'en': 'Sign in with Google', },
    '8nol2hvf': { 'de': 'Du hast noch kein Konto? ', 'en': 'Don\'t have an account? ', },
    'qid7i1mm': { 'de': 'Konto erstellen', 'en': 'Create an account', },
  },
  // forgotPassword_screen
  {
    'i13rkjnz': { 'de': 'Passwort zurücksetzen', 'en': 'Reset your password', },
    'malrqoft': { 'de': 'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen', 'en': 'Enter your email address and we\'ll send you a reset link', },
    'ruvb2hvi': { 'de': 'E-Mail', 'en': 'Email', },
    'ctzysw0x': { 'de': 'du@beispiel.com', 'en': 'you@example.com', },
    'm6e37oti': { 'de': 'Gib die mit deinem Konto verknüpfte E-Mail-Adresse ein.', 'en': 'Enter the email address associated with your account.', },
    'ldx3dvqv': { 'de': 'Link senden', 'en': 'Send reset link', },
    'q76rfh9r': { 'de': 'Zurück zum Login', 'en': 'Back to login', },
  },
  // signup_screen
  {
    '0gosyzd4': { 'de': 'Konto erstellen', 'en': 'Create an account', },
    'ks8yv9hy': { 'de': 'Gib deine Daten ein, um dein Konto zu erstellen', 'en': 'Enter your details to create your account', },
    'ojp7acfq': { 'de': 'E-Mail', 'en': 'Email', },
    'wsj30c4x': { 'de': 'du@beispiel.com', 'en': 'you@example.com', },
    'vbjj43ng': { 'de': 'Passwort', 'en': 'Password', },
    'i1q7x8uh': { 'de': 'Benutzername', 'en': 'Username', },
    'jvdw5o21': { 'de': 'Geburtstag', 'en': 'Birthday', },
    'domcoetw': { 'de': 'JJJJ', 'en': 'YYYY', },
    '6h79a6k1': { 'de': 'Du musst mindestens 13 Jahre alt sein, um diesen Dienst zu nutzen.', 'en': 'You must be at least 13 years old to use this service.', },
    'vjqzemw9': { 'de': 'Ich stimme den Nutzungsbedingungen und der Datenschutzrichtlinie zu', 'en': 'I agree to the terms of service and privacy policy', },
    'm5an2ndx': { 'de': 'Durch das Erstellen eines Kontos stimmst du unseren ', 'en': 'By creating an account, you agree to our ', },
    'rbbty9tw': { 'de': 'Nutzungsbedingungen', 'en': 'Terms of Service', },
    'x5cnfgpw': { 'de': ' und ', 'en': ' and ', },
    'hqpvp9r0': { 'de': 'Datenschutzrichtlinie', 'en': 'Privacy Policy', },
    'rm8reted': { 'de': 'Registrieren', 'en': 'Sign up', }, // Corrected German for Sign Up
    '14vmfpv5': { 'de': 'Du hast bereits ein Konto? ', 'en': 'Already have an account? ', },
    'e1xg9tab': { 'de': 'Anmelden', 'en': 'Sign in', },
  },
  // confirmJoinGroup2 / popupGroupjoin
  {
    'vw8c9bws': { 'de': 'Gruppe beitreten', 'en': 'Join Group', },
    'gz60intn': { 'de': 'Gruppe beitreten', 'en': 'Join Group', },
    'uhhrzsjb': { 'de': 'Tägliche Leser', 'en': 'Daily Readers', },
    'rbkk2g3e': { 'de': 'Tägliche Leser', 'en': 'Daily Readers', },
    'sn37v2ou': { 'de': 'Öffentlich', 'en': 'Public', },
    's1ar25ki': { 'de': 'Öffentlich', 'en': 'Public', },
    'ra2jdulp': { 'de': '86 Mitglieder', 'en': '86 members', },
    'd4gj93om': { 'de': '86 Mitglieder', 'en': '86 members', },
    '9mw1amvz': { 'de': 'Über diese Gruppe', 'en': 'About this group', },
    'b7t1c144': { 'de': 'Über diese Gruppe', 'en': 'About this group', },
    'sjaxohpt': { 'de': 'Schließe dich uns an, wenn wir jeden Tag mindestens 10 Seiten lesen. Teile Buchempfehlungen und diskutiere deine neuesten Lektüren mit der Community!', 'en': 'Join us as we read at least 10 pages every day. Share book recommendations and discuss your latest reads with the community!', },
    'nljzur53': { 'de': 'Schließe dich uns an, wenn wir jeden Tag mindestens 10 Seiten lesen. Teile Buchempfehlungen und diskutiere deine neuesten Lektüren mit der Community!', 'en': 'Join us as we read at least 10 pages every day. Share book recommendations and discuss your latest reads with the community!', },
    'ycoy68w3': { 'de': 'Gruppengewohnheit', 'en': 'Group Habit', },
    '0exudm0g': { 'de': 'Gruppengewohnheit', 'en': 'Group Habit', },
    'rccof86l': { 'de': '10 Seiten lesen', 'en': 'Read 10 pages', },
    '8f3g17im': { 'de': '10 Seiten lesen', 'en': 'Read 10 pages', },
    'vmkuohk4': { 'de': 'Abbrechen', 'en': 'Cancel', },
    'h7nsbp0w': { 'de': 'Gruppe beitreten', 'en': 'Join Group', },
  },
  // supportScreen / supportScreenCopy
  {
    'o9sfq8jn': { 'de': 'Kontakt', 'en': 'Contact Us', },
    '97q2tpif': { 'de': 'Kontakt', 'en': 'Contact Us', },
    'oq7lelxo': { 'de': 'Sende uns eine Nachricht und wir melden uns so schnell wie möglich bei dir.', 'en': 'Send us a message and we\'ll get back to you as soon as possible.', },
    'edw06gyn': { 'de': 'Sende uns eine Nachricht und wir melden uns so schnell wie möglich bei dir.', 'en': 'Send us a message and we\'ll get back to you as soon as possible.', },
    'n5ja8cbb': { 'de': 'Kontaktgrund', 'en': 'Reason for contact', },
    '04cob80g': { 'de': 'Kontaktgrund', 'en': 'Reason for contact', },
    '41tnjyyb': { 'de': '📩 Feedback', 'en': '📩 Feedback', },
    'fdpxye3f': { 'de': '📩 Feedback', 'en': '📩 Feedback', },
    'mvmyrkl8': { 'de': '⚠️ Problem melden', 'en': '⚠️ Report an issue', },
    'oz0q0s0o': { 'de': '⚠️ Problem melden', 'en': '⚠️ Report an issue', },
    'uly48p0u': { 'de': '📦 Persönliche Daten anfordern', 'en': '📦 Receive personal data', },
    '0mg7fqwk': { 'de': '📦 Persönliche Daten anfordern', 'en': '📦 Receive personal data', },
    '0p7uavcm': { 'de': '🗑️ Konto löschen', 'en': '🗑️ Account deletion', },
    'a6euqu6g': { 'de': '🗑️ Konto löschen', 'en': '🗑️ Account deletion', },
    'hj4wzcaw': { 'de': '➕ Sonstiges', 'en': '➕ Other', },
    'kh0ehgv8': { 'de': '➕ Sonstiges', 'en': '➕ Other', },
    'jr754jrp': { 'de': 'Deine E-Mail-Adresse', 'en': 'Your email address', },
    'eet7ay7h': { 'de': 'Deine E-Mail-Adresse', 'en': 'Your email address', },
    'assaubjl': { 'de': ' *', 'en': ' *', },
    'q1yiytcf': { 'de': ' *', 'en': ' *', },
    '16s6tuii': { 'de': 'Gib deine E-Mail-Adresse ein', 'en': 'Enter your email address', },
    't3lnws16': { 'de': 'Gib deine E-Mail-Adresse ein', 'en': 'Enter your email address', },
    'hgwa2li4': { 'de': 'Deine Nachricht', 'en': 'Your message', },
    'cgo5ym1b': { 'de': 'Deine Nachricht', 'en': 'Your message', },
    'gd5ems9f': { 'de': 'Sag uns, wie wir helfen können...', 'en': 'Tell us how we can help...', },
    'i6masrx6': { 'de': 'Sag uns, wie wir helfen können...', 'en': 'Tell us how we can help...', },
    '5vvolqy9': { 'de': 'Nachricht senden', 'en': 'Send message', },
    '4zpr3gxa': { 'de': 'Nachricht senden', 'en': 'Send message', },
    'e0rpmxxd': { 'de': 'Abbrechen', 'en': 'Cancel', },
    'n1mz9efg': { 'de': 'Abbrechen', 'en': 'Cancel', },
    'y9s10ipl': { 'de': 'Option 1', 'en': 'Option 1', },
    'sljjnukb': { 'de': 'Option 2', 'en': 'Option 2', },
    'g3xw0wla': { 'de': 'Option 3', 'en': 'Option 3', },
  },
  // streak_page
  {
    'l5hlxu8x': { 'de': '21', 'en': '21', },
    '3c9f9t29': { 'de': 'Tage Serie!', 'en': 'day streak!', },
    'qcfdyz36': { 'de': 'Du bist 21 Tage lang beständig geblieben – mach weiter so!', 'en': 'You\'ve stayed consistent for 21 days – keep the momentum going!', },
    'le7oay1x': { 'de': 'Teilen', 'en': 'Share', },
    'gkxdodb7': { 'de': 'Weiter', 'en': 'Continue', },
  },
  // feedcard
  {
    'ltw1ki3o': { 'de': 'sarah', 'en': 'sarah', },
    'p6rco3pc': { 'de': 'Meinen Morgenlauf beendet! 5km in 25 Minuten, neue persönliche Bestzeit!', 'en': 'Completed my morning run! 5km in 25 minutes, a new personal best!', },
    'y11mlk40': { 'de': '👅 Reagieren', 'en': '👅 React', },
    'ky8tl0o9': { 'de': '2', 'en': '2', },
    'mng66p9n': { 'de': 'vor 10 Std.', 'en': '10h ago', },
  },
  // Friendlistitem
  {
    'jau915vf': { 'de': 'Alex Kowac', 'en': 'Alex Kowac', },
  },
  // Habitcard
  {
    'ocivy9st': { 'de': 'Selbstfürsorge', 'en': 'Self-care', },
    'u4m4bidd': { 'de': '09:15', 'en': '09:15', },
    '47lyi7wg': { 'de': 'M', 'en': 'M', }, '5h9sa52r': { 'de': 'D', 'en': 'T', }, 'a0vrj50a': { 'de': 'M', 'en': 'W', },
    'fu48xf2d': { 'de': 'D', 'en': 'T', }, 'w8cryc0h': { 'de': 'F', 'en': 'F', }, 'xkkawx75': { 'de': 'S', 'en': 'S', },
    'byt540hv': { 'de': 'S', 'en': 'S', },
  },
  // Tabbar (from nichtwichtig)
  {
    'qkem2ayu': { 'de': 'Freunde', 'en': 'Friends', },
    '06yity6g': { 'de': 'Freunde von Freunden', 'en': 'Friends of Friends', },
    'ggzhlty1': { 'de': 'Kommt bald', 'en': 'Coming Soon', },
    'bgk4ztgp': { 'de': 'Diese Funktion wird in einem zukünftigen Update verfügbar sein.', 'en': 'This feature will be available in an upcoming update.', },
  },
  // ExistingGroup
  {
    '4k40sy3j': { 'de': 'Öffentlich', 'en': 'Public', },
  },
  // DiscoverGroup
  {
    '1cqyh5uj': { 'de': 'Öffentlich', 'en': 'Public', },
    'jgrrzt1q': { 'de': 'Beitreten', 'en': 'Join', },
  },
  // friend_message
  {
    '0zn8t2n0': { 'de': 'E', 'en': 'E', },
    'cy4vbq8r': { 'de': 'Emma', 'en': 'Emma', },
    'gcs4n56m': { 'de': 'Das ist ein tolles Ziel! Ich ziele selbst auf 25 Seiten ab. Ich liebe deine Leseecke!', 'en': 'That\'s a great goal! I\'m aiming for 25 pages myself. Love your reading nook!', },
    'r21q9tz4': { 'de': '20:32', 'en': '20:32', },
  },
  // currentuser_message
  {
    'ej93pxu8': { 'de': 'Ich beginne gleich meine Morgensitzung. Hoffe, heute 30 Seiten zu schaffen!', 'en': 'I\'m about to start my morning session. Hoping to finish 30 pages today!', },
    'fpc7t1br': { 'de': '20:17', 'en': '20:17', },
  },
  // Miscellaneous
  {
    'gvxpduya': { 'de': '', 'en': '', }, '02cheus0': { 'de': '', 'en': '', }, '0miysv00': { 'de': '', 'en': '', },
    'xa1himpx': { 'de': '', 'en': '', }, 'oisjwf3n': { 'de': '', 'en': '', }, 'fj4r9861': { 'de': '', 'en': '', },
    'ta8uquug': { 'de': '', 'en': '', }, 'f6l5wfle': { 'de': '', 'en': '', }, 'ypqfilq9': { 'de': '', 'en': '', },
    'z39lvhbb': { 'de': '', 'en': '', }, 'q8yba67u': { 'de': '', 'en': '', }, 'gpzelp4p': { 'de': '', 'en': '', },
    'co7vp6yr': { 'de': '', 'en': '', }, 'tk62je0j': { 'de': '', 'en': '', }, 'y11i7oqe': { 'de': '', 'en': '', },
    'kp50twwe': { 'de': '', 'en': '', }, '5r8r7dkh': { 'de': '', 'en': '', }, 'rw8p72u5': { 'de': '', 'en': '', },
    '4w5u8sjf': { 'de': '', 'en': '', }, '8e5fhz1x': { 'de': '', 'en': '', }, '3le1qzu6': { 'de': '', 'en': '', },
    '7g0dv4ah': { 'de': '', 'en': '', }, 'bjwl72fw': { 'de': '', 'en': '', }, 'ity22no1': { 'de': '', 'en': '', },
    'slvl00dk': { 'de': '', 'en': '', },
  },
].reduce((a, b) => a..addAll(b));

// ================== TRANSLATIONS END ==================