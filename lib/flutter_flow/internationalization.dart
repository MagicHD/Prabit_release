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

  // Add 'it', 'fr', 'es' to the list of supported languages
  static List<String> languages() => ['de', 'en', 'ko', 'it', 'fr', 'es'];

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
  int get languageIndex {
    // Find index, default to 0 (German) if not found
    final index = languages().indexOf(languageCode);
    return index == -1 ? 0 : index;
  }


  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? key; // Return key if translation missing

  // Updated getVariableText for new languages
  String getVariableText({
    String? deText = '',
    String? enText = '',
    String? koText = '',
    String? itText = '', // Added Italian
    String? frText = '', // Added French
    String? esText = '', // Added Spanish
  }) =>
      [deText, enText, koText, itText, frText, esText][languageIndex] ?? ''; // Added Italian, French, Spanish

  // Language codes list updated based on general usage
  static const Set<String> _languagesWithShortCode = {
    'ar', 'az', 'ca', 'cs', 'da', 'de', 'dv', 'en', 'es', 'et', 'fi', 'fr', // 'es', 'fr' included
    'gr', 'he', 'hi', 'hu', 'it', 'km', 'ko', 'ku', 'mn', 'ms', 'no', 'pt', // 'it', 'ko' included
    'ro', 'ru', 'rw', 'sv', 'th', 'uk', 'vi',
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

// ================== TRANSLATIONS START (it, fr, es ADDED) ==================
final kTranslationsMap = <Map<String, Map<String, String>>>[
  // Feedscreen
  // Feedscreen
  {
    '40uc9yol': {
      'de': 'Freunde',
      'en': 'Friends',
      'ko': '친구',
      'it': 'Amici',
      'fr': 'Amis',
      'es': 'Amigos',
      'ru': 'Друзья',
      'pt': 'Amigos',
      'tr': 'Arkadaşlar',
      'ja': '友達',
      'hi': 'दोस्त',
      'ar': 'الأصدقاء',
      'bn': 'বন্ধু',
    },
    '9sgbuu77': {
      'de': 'Entdecken',
      'en': 'Discover',
      'ko': '탐색',
      'it': 'Scopri',
      'fr': 'Découvrir',
      'es': 'Descubrir',
      'ru': 'Обзор',
      'pt': 'Descobrir',
      'tr': 'Keşfet',
      'ja': '発見',
      'hi': 'खोजें',
      'ar': 'اكتشف',
      'bn': 'আবিষ্কার করুন',
    },
    '5cvgp873': {
      'de': 'Kommt bald',
      'en': 'Coming Soon',
      'ko': '출시 예정',
      'it': 'Prossimamente',
      'fr': 'Bientôt disponible',
      'es': 'Próximamente',
      'ru': 'Скоро',
      'pt': 'Em breve',
      'tr': 'Yakında',
      'ja': '近日公開',
      'hi': 'जल्द आ रहा है',
      'ar': 'قريباً',
      'bn': 'শীঘ্রই আসছে',
    },
    'kvn9u2me': {
      'de': 'Diese Funktion wird in einem zukünftigen Update verfügbar sein.',
      'en': 'This feature will be available in an upcoming update.',
      'ko': '이 기능은 다음 업데이트에서 사용할 수 있습니다.',
      'it': 'Questa funzionalità sarà disponibile in un prossimo aggiornamento.',
      'fr': 'Cette fonctionnalité sera disponible dans une prochaine mise à jour.',
      'es': 'Esta función estará disponible en una próxima actualización.',
      'ru': 'Эта функция будет доступна в следующем обновлении.',
      'pt': 'Este recurso estará disponível em uma atualização futura.',
      'tr': 'Bu özellik gelecek bir güncellemede mevcut olacaktır.',
      'ja': 'この機能は今後のアップデートで利用可能になります。',
      'hi': 'यह सुविधा अगले अपडेट में उपलब्ध होगी।',
      'ar': 'ستكون هذه الميزة متاحة في تحديث قادم.',
      'bn': 'এই বৈশিষ্ট্যটি পরবর্তী আপডেটে উপলব্ধ হবে।',
    },
    'j2028ukr': {
      'de': 'Prabit',
      'en': 'Prabit',
      'ko': 'Prabit',
      'it': 'Prabit',
      'fr': 'Prabit',
      'es': 'Prabit',
      'ru': 'Prabit',
      'pt': 'Prabit',
      'tr': 'Prabit',
      'ja': 'Prabit',
      'hi': 'Prabit',
      'ar': 'Prabit',
      'bn': 'Prabit',
    },
  }, // <-- Make sure there's a comma here before the next section's map starts
  // Profilescreen / profile_screen2 (Consolidated)
  {
    'qfklgi1u': { 'de': 'Mein Profil', 'en': 'My Profile', 'ko': '내 프로필', 'it': 'Il mio profilo', 'fr': 'Mon profil', 'es': 'Mi perfil', 'ru': 'Мой профиль', 'pt': 'Meu perfil', 'tr': 'Profilim', 'ja': 'マイプロフィール', 'hi': 'मेरी प्रोफाइल', 'ar': 'ملفي الشخصي', 'bn': 'আমার প্রোফাইল', },
    'f198t6i7': { 'de': 'Mein Profil', 'en': 'My Profile', 'ko': '내 프로필', 'it': 'Il mio profilo', 'fr': 'Mon profil', 'es': 'Mi perfil', 'ru': 'Мой профиль', 'pt': 'Meu perfil', 'tr': 'Profilim', 'ja': 'マイプロフィール', 'hi': 'मेरी प्रोफाइल', 'ar': 'ملفي الشخصي', 'bn': 'আমার প্রোফাইল', }, // Duplicate key description, consolidated here
    'pappnzlc': { 'de': 'lazylevin123', 'en': 'lazylevin123', 'ko': 'lazylevin123', 'it': 'lazylevin123', 'fr': 'lazylevin123', 'es': 'lazylevin123', 'ru': 'lazylevin123', 'pt': 'lazylevin123', 'tr': 'lazylevin123', 'ja': 'lazylevin123', 'hi': 'lazylevin123', 'ar': 'lazylevin123', 'bn': 'lazylevin123', },
    'ybjjwa3s': { 'de': 'lazylevin123', 'en': 'lazylevin123', 'ko': 'lazylevin123', 'it': 'lazylevin123', 'fr': 'lazylevin123', 'es': 'lazylevin123', 'ru': 'lazylevin123', 'pt': 'lazylevin123', 'tr': 'lazylevin123', 'ja': 'lazylevin123', 'hi': 'lazylevin123', 'ar': 'lazylevin123', 'bn': 'lazylevin123', }, // Duplicate key description, consolidated here
    '6z20lrxo': { 'de': 'Mitglied seit Apr 2025', 'en': 'Member since Apr 2025', 'ko': '가입일: 2025년 4월', 'it': 'Membro da Apr 2025', 'fr': 'Membre depuis Avr 2025', 'es': 'Miembro desde Abr 2025', 'ru': 'Участник с апр 2025', 'pt': 'Membro desde Abr 2025', 'tr': 'Üyelik tarihi Nis 2025', 'ja': 'メンバー登録日: 2025年4月', 'hi': 'सदस्य अप्रैल 2025 से', 'ar': 'عضو منذ أبريل 2025', 'bn': 'এপ্রিল ২০২৫ থেকে সদস্য', },
    'ep1vo1mu': { 'de': 'Mitglied seit Apr 2025', 'en': 'Member since Apr 2025', 'ko': '가입일: 2025년 4월', 'it': 'Membro da Apr 2025', 'fr': 'Membre depuis Avr 2025', 'es': 'Miembro desde Abr 2025', 'ru': 'Участник с апр 2025', 'pt': 'Membro desde Abr 2025', 'tr': 'Üyelik tarihi Nis 2025', 'ja': 'メンバー登録日: 2025年4月', 'hi': 'सदस्य अप्रैल 2025 से', 'ar': 'عضو منذ أبريل 2025', 'bn': 'এপ্রিল ২০২৫ থেকে সদস্য', }, // Duplicate key description, consolidated here
    '8i56dofc': { 'de': 'Ich verfolge meine Gewohnheiten und mache jeden Tag Fortschritte!', 'en': 'I\'m tracking my habits and making progress every day!', 'ko': '매일 습관을 기록하고 발전하고 있습니다!', 'it': 'Sto monitorando le mie abitudini e faccio progressi ogni giorno!', 'fr': 'Je suis mes habitudes et je progresse chaque jour !', 'es': '¡Estoy siguiendo mis hábitos y progresando cada día!', 'ru': 'Я отслеживаю свои привычки и добиваюсь прогресса каждый день!', 'pt': 'Estou acompanhando meus hábitos e progredindo a cada dia!', 'tr': 'Alışkanlıklarımı takip ediyor ve her gün ilerleme kaydediyorum!', 'ja': '毎日習慣を記録し、進歩しています！', 'hi': 'मैं अपनी आदतों पर नज़र रख रहा हूँ और हर दिन प्रगति कर रहा हूँ!', 'ar': 'أنا أتابع عاداتي وأحرز تقدماً كل يوم!', 'bn': 'আমি আমার অভ্যাসগুলি ট্র্যাক করছি এবং প্রতিদিন উন্নতি করছি!', },
    '4y54avtu': { 'de': 'Ich verfolge meine Gewohnheiten und mache jeden Tag Fortschritte!', 'en': 'I\'m tracking my habits and making progress every day!', 'ko': '매일 습관을 기록하고 발전하고 있습니다!', 'it': 'Sto monitorando le mie abitudini e faccio progressi ogni giorno!', 'fr': 'Je suis mes habitudes et je progresse chaque jour !', 'es': '¡Estoy siguiendo mis hábitos y progresando cada día!', 'ru': 'Я отслеживаю свои привычки и добиваюсь прогресса каждый день!', 'pt': 'Estou acompanhando meus hábitos e progredindo a cada dia!', 'tr': 'Alışkanlıklarımı takip ediyor ve her gün ilerleme kaydediyorum!', 'ja': '毎日習慣を記録し、進歩しています！', 'hi': 'मैं अपनी आदतों पर नज़र रख रहा हूँ और हर दिन प्रगति कर रहा हूँ!', 'ar': 'أنا أتابع عاداتي وأحرز تقدماً كل يوم!', 'bn': 'আমি আমার অভ্যাসগুলি ট্র্যাক করছি এবং প্রতিদিন উন্নতি করছি!', }, // Duplicate key description, consolidated here
    '3nqlkwra': { 'de': 'Freunde suchen...', 'en': 'Search friends...', 'ko': '친구 검색...', 'it': 'Cerca amici...', 'fr': 'Rechercher des amis...', 'es': 'Buscar amigos...', 'ru': 'Поиск друзей...', 'pt': 'Procurar amigos...', 'tr': 'Arkadaş ara...', 'ja': '友達を検索...', 'hi': 'मित्र खोजें...', 'ar': 'ابحث عن أصدقاء...', 'bn': 'বন্ধু খুঁজুন...', },
    'ife4fo6p': { 'de': 'Freunde suchen...', 'en': 'Search friends...', 'ko': '친구 검색...', 'it': 'Cerca amici...', 'fr': 'Rechercher des amis...', 'es': 'Buscar amigos...', 'ru': 'Поиск друзей...', 'pt': 'Procurar amigos...', 'tr': 'Arkadaş ara...', 'ja': '友達を検索...', 'hi': 'मित्र खोजें...', 'ar': 'ابحث عن أصدقاء...', 'bn': 'বন্ধু খুঁজুন...', }, // Duplicate key description, consolidated here
    '3t2dyqaa': { 'de': 'Alex Kowac', 'en': 'Alex Kowac', 'ko': 'Alex Kowac', 'it': 'Alex Kowac', 'fr': 'Alex Kowac', 'es': 'Alex Kowac', 'ru': 'Алекс Ковач', 'pt': 'Alex Kowac', 'tr': 'Alex Kowac', 'ja': 'アレックス・コワック', 'hi': 'एलेक्स कोवाक', 'ar': 'أليكس كواك', 'bn': 'অ্যালেক্স কোয়াক', },
    'bf8hn2z6': { 'de': '3 gemeinsame Gewohnheiten', 'en': '3 mutual habits', 'ko': '3개의 공통 습관', 'it': '3 abitudini in comune', 'fr': '3 habitudes mutuelles', 'es': '3 hábitos mutuos', 'ru': '3 общих привычки', 'pt': '3 hábitos mútuos', 'tr': '3 ortak alışkanlık', 'ja': '共通の習慣3つ', 'hi': '3 आपसी आदतें', 'ar': '3 عادات مشتركة', 'bn': '৩টি পারস্পরিক অভ্যাস', },
    'f8hdpj7v': { 'de': 'Maya Johnson', 'en': 'Maya Johnson', 'ko': 'Maya Johnson', 'it': 'Maya Johnson', 'fr': 'Maya Johnson', 'es': 'Maya Johnson', 'ru': 'Майя Джонсон', 'pt': 'Maya Johnson', 'tr': 'Maya Johnson', 'ja': 'マヤ・ジョンソン', 'hi': 'माया जॉनसन', 'ar': 'مايا جونسون', 'bn': 'মায়া জনসন', },
    '8byvz6x2': { 'de': '5 gemeinsame Gewohnheiten', 'en': '5 mutual habits', 'ko': '5개의 공통 습관', 'it': '5 abitudini in comune', 'fr': '5 habitudes mutuelles', 'es': '5 hábitos mutuos', 'ru': '5 общих привычек', 'pt': '5 hábitos mútuos', 'tr': '5 ortak alışkanlık', 'ja': '共通の習慣5つ', 'hi': '5 आपसी आदतें', 'ar': '5 عادات مشتركة', 'bn': '৫টি পারস্পরিক অভ্যাস', },
    'anyor4ur': { 'de': 'Carlos Mendez', 'en': 'Carlos Mendez', 'ko': 'Carlos Mendez', 'it': 'Carlos Mendez', 'fr': 'Carlos Mendez', 'es': 'Carlos Mendez', 'ru': 'Карлос Мендес', 'pt': 'Carlos Mendez', 'tr': 'Carlos Mendez', 'ja': 'カルロス・メンデス', 'hi': 'कार्लोस मेंडेज़', 'ar': 'كارلوس مينديز', 'bn': 'কার্লোস মেন্ডেজ', },
    'g4kmkm20': { 'de': '2 gemeinsame Gewohnheiten', 'en': '2 mutual habits', 'ko': '2개의 공통 습관', 'it': '2 abitudini in comune', 'fr': '2 habitudes mutuelles', 'es': '2 hábitos mutuos', 'ru': '2 общих привычки', 'pt': '2 hábitos mútuos', 'tr': '2 ortak alışkanlık', 'ja': '共通の習慣2つ', 'hi': '2 आपसी आदतें', 'ar': 'عادتان مشتركتان', 'bn': '২টি পারস্পরিক অভ্যাস', },
    'ch55tcb9': { 'de': 'Sarah Williams', 'en': 'Sarah Williams', 'ko': 'Sarah Williams', 'it': 'Sarah Williams', 'fr': 'Sarah Williams', 'es': 'Sarah Williams', 'ru': 'Сара Уильямс', 'pt': 'Sarah Williams', 'tr': 'Sarah Williams', 'ja': 'サラ・ウィリアムズ', 'hi': 'सारा विलियम्स', 'ar': 'سارة ويليامز', 'bn': 'সারা উইলিয়ামস', },
    'k8a2xo1e': { 'de': '7 gemeinsame Gewohnheiten', 'en': '7 mutual habits', 'ko': '7개의 공통 습관', 'it': '7 abitudini in comune', 'fr': '7 habitudes mutuelles', 'es': '7 hábitos mutuos', 'ru': '7 общих привычек', 'pt': '7 hábitos mútuos', 'tr': '7 ortak alışkanlık', 'ja': '共通の習慣7つ', 'hi': '7 आपसी आदतें', 'ar': '7 عادات مشتركة', 'bn': '৭টি পারস্পরিক অভ্যাস', },
    'ie0eiug4': { 'de': 'Jordan Lee', 'en': 'Jordan Lee', 'ko': 'Jordan Lee', 'it': 'Jordan Lee', 'fr': 'Jordan Lee', 'es': 'Jordan Lee', 'ru': 'Джордан Ли', 'pt': 'Jordan Lee', 'tr': 'Jordan Lee', 'ja': 'ジョーダン・リー', 'hi': 'जॉर्डन ली', 'ar': 'جوردان لي', 'bn': 'জর্ডান লি', },
    'gjriids5': { 'de': '4 gemeinsame Gewohnheiten', 'en': '4 mutual habits', 'ko': '4개의 공통 습관', 'it': '4 abitudini in comune', 'fr': '4 habitudes mutuelles', 'es': '4 hábitos mutuos', 'ru': '4 общих привычки', 'pt': '4 hábitos mútuos', 'tr': '4 ortak alışkanlık', 'ja': '共通の習慣4つ', 'hi': '4 आपसी आदतें', 'ar': '4 عادات مشتركة', 'bn': '৪টি পারস্পরিক অভ্যাস', },
  }, // <-- Make sure there's a comma here before the next section's map starts
  // calendar / calendar_widget
  // calendar / calendar_widget
  {
    '1by656i7': {
      'de': 'Kalender',
      'en': 'Calendar',
      'ko': '캘린더',
      'it': 'Calendario',
      'fr': 'Calendrier',
      'es': 'Calendario',
      'ru': 'Календарь',
      'pt': 'Calendário',
      'tr': 'Takvim',
      'ja': 'カレンダー',
      'hi': 'कैलेंडर',
      'ar': 'التقويم',
      'bn': 'ক্যালেন্ডার',
    },
    'qila67g3': { // Note: Month/Year should ideally be dynamic, not hardcoded text
      'de': 'März 2025',
      'en': 'March 2025',
      'ko': '2025년 3월',
      'it': 'Marzo 2025',
      'fr': 'Mars 2025',
      'es': 'Marzo 2025',
      'ru': 'Март 2025',
      'pt': 'Março 2025',
      'tr': 'Mart 2025',
      'ja': '2025年3月',
      'hi': 'मार्च 2025',
      'ar': 'مارس 2025',
      'bn': 'মার্চ ২০২৫',
    },
    //calender
    // Day Abbreviations
    '177k9c8v': { 'de': 'S', 'en': 'S', 'ko': '일', 'it': 'D', 'fr': 'D', 'es': 'D', 'ru': 'Вс', 'pt': 'D', 'tr': 'P', 'ja': '日', 'hi': 'र', 'ar': 'ح', 'bn': 'র', }, // Sunday
    'ufrpfnpk': { 'de': 'M', 'en': 'M', 'ko': '월', 'it': 'L', 'fr': 'L', 'es': 'L', 'ru': 'Пн', 'pt': 'S', 'tr': 'Pzt', 'ja': '月', 'hi': 'सो', 'ar': 'ن', 'bn': 'সো', }, // Monday
    'yp2erjj3': { 'de': 'D', 'en': 'T', 'ko': '화', 'it': 'M', 'fr': 'M', 'es': 'M', 'ru': 'Вт', 'pt': 'T', 'tr': 'Sa', 'ja': '火', 'hi': 'मं', 'ar': 'ث', 'bn': 'ম', }, // Tuesday
    'i58o23eb': { 'de': 'M', 'en': 'W', 'ko': '수', 'it': 'M', 'fr': 'M', 'es': 'X', 'ru': 'Ср', 'pt': 'Q', 'tr': 'Ça', 'ja': '水', 'hi': 'बु', 'ar': 'ر', 'bn': 'বু', }, // Wednesday
    'hynvrs95': { 'de': 'D', 'en': 'T', 'ko': '목', 'it': 'G', 'fr': 'J', 'es': 'J', 'ru': 'Чт', 'pt': 'Q', 'tr': 'Pe', 'ja': '木', 'hi': 'गु', 'ar': 'خ', 'bn': 'বৃ', }, // Thursday
    '4rjz0t0e': { 'de': 'F', 'en': 'F', 'ko': '금', 'it': 'V', 'fr': 'V', 'es': 'V', 'ru': 'Пт', 'pt': 'S', 'tr': 'Cu', 'ja': '金', 'hi': 'शु', 'ar': 'ج', 'bn': 'শু', }, // Friday
    '1s4y3l7p': { 'de': 'S', 'en': 'S', 'ko': '토', 'it': 'S', 'fr': 'S', 'es': 'S', 'ru': 'Сб', 'pt': 'S', 'tr': 'Cmt', 'ja': '土', 'hi': 'श', 'ar': 'س', 'bn': 'শ', }, // Saturday
    // Numbers (Usually not translated this way, but keys exist)
    '4qj321w0': {'de': '1', 'en': '1', 'ko': '1', 'it': '1', 'fr': '1', 'es': '1', 'ru': '1', 'pt': '1', 'tr': '1', 'ja': '1', 'hi': '१', 'ar': '١', 'bn': '১'},
    'jn8sj7b4': {'de': '2', 'en': '2', 'ko': '2', 'it': '2', 'fr': '2', 'es': '2', 'ru': '2', 'pt': '2', 'tr': '2', 'ja': '2', 'hi': '२', 'ar': '٢', 'bn': '২'},
    '5obmi5ju': {'de': '3', 'en': '3', 'ko': '3', 'it': '3', 'fr': '3', 'es': '3', 'ru': '3', 'pt': '3', 'tr': '3', 'ja': '3', 'hi': '३', 'ar': '٣', 'bn': '৩'},
    's3hxx9tj': {'de': '4', 'en': '4', 'ko': '4', 'it': '4', 'fr': '4', 'es': '4', 'ru': '4', 'pt': '4', 'tr': '4', 'ja': '4', 'hi': '४', 'ar': '٤', 'bn': '৪'},
    'e6zaqfuc': {'de': '5', 'en': '5', 'ko': '5', 'it': '5', 'fr': '5', 'es': '5', 'ru': '5', 'pt': '5', 'tr': '5', 'ja': '5', 'hi': '५', 'ar': '٥', 'bn': '৫'},
    '6ttaw8xf': {'de': '6', 'en': '6', 'ko': '6', 'it': '6', 'fr': '6', 'es': '6', 'ru': '6', 'pt': '6', 'tr': '6', 'ja': '6', 'hi': '६', 'ar': '٦', 'bn': '৬'},
    'k5soyhgt': {'de': '7', 'en': '7', 'ko': '7', 'it': '7', 'fr': '7', 'es': '7', 'ru': '7', 'pt': '7', 'tr': '7', 'ja': '7', 'hi': '७', 'ar': '٧', 'bn': '৭'},
    'uuvvq7xg': {'de': '8', 'en': '8', 'ko': '8', 'it': '8', 'fr': '8', 'es': '8', 'ru': '8', 'pt': '8', 'tr': '8', 'ja': '8', 'hi': '८', 'ar': '٨', 'bn': '৮'},
    'g54285j5': {'de': '9', 'en': '9', 'ko': '9', 'it': '9', 'fr': '9', 'es': '9', 'ru': '9', 'pt': '9', 'tr': '9', 'ja': '9', 'hi': '९', 'ar': '٩', 'bn': '৯'},
    'ibv418ck': {'de': '11', 'en': '11', 'ko': '11', 'it': '11', 'fr': '11', 'es': '11', 'ru': '11', 'pt': '11', 'tr': '11', 'ja': '11', 'hi': '११', 'ar': '١١', 'bn': '১১'},
    'uz8d7glt': {'de': '12', 'en': '12', 'ko': '12', 'it': '12', 'fr': '12', 'es': '12', 'ru': '12', 'pt': '12', 'tr': '12', 'ja': '12', 'hi': '१२', 'ar': '١٢', 'bn': '১২'},
    'xwdtwmgx': {'de': '13', 'en': '13', 'ko': '13', 'it': '13', 'fr': '13', 'es': '13', 'ru': '13', 'pt': '13', 'tr': '13', 'ja': '13', 'hi': '१३', 'ar': '١٣', 'bn': '১৩'},
    'v47dxaoi': {'de': '14', 'en': '14', 'ko': '14', 'it': '14', 'fr': '14', 'es': '14', 'ru': '14', 'pt': '14', 'tr': '14', 'ja': '14', 'hi': '१४', 'ar': '١٤', 'bn': '১৪'},
    'nyqax5i2': {'de': '15', 'en': '15', 'ko': '15', 'it': '15', 'fr': '15', 'es': '15', 'ru': '15', 'pt': '15', 'tr': '15', 'ja': '15', 'hi': '१५', 'ar': '١٥', 'bn': '১৫'},
    'fkyy5wq5': {'de': '3', 'en': '3', 'ko': '3', 'it': '3', 'fr': '3', 'es': '3', 'ru': '3', 'pt': '3', 'tr': '3', 'ja': '3', 'hi': '३', 'ar': '٣', 'bn': '৩'}, // Duplicate key '3'
    'bzdt9s1p': {'de': '16', 'en': '16', 'ko': '16', 'it': '16', 'fr': '16', 'es': '16', 'ru': '16', 'pt': '16', 'tr': '16', 'ja': '16', 'hi': '१६', 'ar': '١٦', 'bn': '১৬'},
    'wfhih6hk': {'de': '17', 'en': '17', 'ko': '17', 'it': '17', 'fr': '17', 'es': '17', 'ru': '17', 'pt': '17', 'tr': '17', 'ja': '17', 'hi': '१७', 'ar': '١٧', 'bn': '১৭'},
    '6jeepcrh': {'de': '18', 'en': '18', 'ko': '18', 'it': '18', 'fr': '18', 'es': '18', 'ru': '18', 'pt': '18', 'tr': '18', 'ja': '18', 'hi': '१८', 'ar': '١٨', 'bn': '১৮'},
    'l98l1wkr': {'de': '19', 'en': '19', 'ko': '19', 'it': '19', 'fr': '19', 'es': '19', 'ru': '19', 'pt': '19', 'tr': '19', 'ja': '19', 'hi': '१९', 'ar': '١٩', 'bn': '১৯'},
    '5c4u5gc1': {'de': '20', 'en': '20', 'ko': '20', 'it': '20', 'fr': '20', 'es': '20', 'ru': '20', 'pt': '20', 'tr': '20', 'ja': '20', 'hi': '२०', 'ar': '٢٠', 'bn': '২০'},
    'lwbsj8pm': {'de': '21', 'en': '21', 'ko': '21', 'it': '21', 'fr': '21', 'es': '21', 'ru': '21', 'pt': '21', 'tr': '21', 'ja': '21', 'hi': '२१', 'ar': '٢١', 'bn': '২১'},
    'a1syk1w3': {'de': '22', 'en': '22', 'ko': '22', 'it': '22', 'fr': '22', 'es': '22', 'ru': '22', 'pt': '22', 'tr': '22', 'ja': '22', 'hi': '२२', 'ar': '٢٢', 'bn': '২২'},
    'scann1ne': {'de': '2', 'en': '2', 'ko': '2', 'it': '2', 'fr': '2', 'es': '2', 'ru': '2', 'pt': '2', 'tr': '2', 'ja': '2', 'hi': '२', 'ar': '٢', 'bn': '২'}, // Duplicate key '2'
    'uk5vf7wf': {'de': '23', 'en': '23', 'ko': '23', 'it': '23', 'fr': '23', 'es': '23', 'ru': '23', 'pt': '23', 'tr': '23', 'ja': '23', 'hi': '२३', 'ar': '٢٣', 'bn': '২৩'},
    'u0v8xomu': {'de': '24', 'en': '24', 'ko': '24', 'it': '24', 'fr': '24', 'es': '24', 'ru': '24', 'pt': '24', 'tr': '24', 'ja': '24', 'hi': '२४', 'ar': '٢٤', 'bn': '২৪'},
    '1hwjpcfq': {'de': '25', 'en': '25', 'ko': '25', 'it': '25', 'fr': '25', 'es': '25', 'ru': '25', 'pt': '25', 'tr': '25', 'ja': '25', 'hi': '२५', 'ar': '٢٥', 'bn': '২৫'},
    '4x0db481': {'de': '26', 'en': '26', 'ko': '26', 'it': '26', 'fr': '26', 'es': '26', 'ru': '26', 'pt': '26', 'tr': '26', 'ja': '26', 'hi': '२६', 'ar': '٢٦', 'bn': '২৬'},
    '7je9ecp1': {'de': '27', 'en': '27', 'ko': '27', 'it': '27', 'fr': '27', 'es': '27', 'ru': '27', 'pt': '27', 'tr': '27', 'ja': '27', 'hi': '२७', 'ar': '٢٧', 'bn': '২৭'},
    '77iidrvy': {'de': '28', 'en': '28', 'ko': '28', 'it': '28', 'fr': '28', 'es': '28', 'ru': '28', 'pt': '28', 'tr': '28', 'ja': '28', 'hi': '२८', 'ar': '٢٨', 'bn': '২৮'},
    'fskyvbv4': {'de': '29', 'en': '29', 'ko': '29', 'it': '29', 'fr': '29', 'es': '29', 'ru': '29', 'pt': '29', 'tr': '29', 'ja': '29', 'hi': '२९', 'ar': '٢٩', 'bn': '২৯'},
    'urmmp82a': {'de': '30', 'en': '30', 'ko': '30', 'it': '30', 'fr': '30', 'es': '30', 'ru': '30', 'pt': '30', 'tr': '30', 'ja': '30', 'hi': '३०', 'ar': '٣٠', 'bn': '৩০'},
    'lm7c2zg4': {'de': '31', 'en': '31', 'ko': '31', 'it': '31', 'fr': '31', 'es': '31', 'ru': '31', 'pt': '31', 'tr': '31', 'ja': '31', 'hi': '३१', 'ar': '٣١', 'bn': '৩১'},
  }, // <-- Make sure there's a comma here before the next section's map starts
  // statistiscpage / statistics_screen (Consolidated)
  {
    '4sl2onmm': { 'de': 'Statistiken', 'en': 'Statistics', 'ko': '통계', 'it': 'Statistiche', 'fr': 'Statistiques', 'es': 'Estadísticas', 'ru': 'Статистика', 'pt': 'Estatísticas', 'tr': 'İstatistikler', 'ja': '統計', 'hi': 'सांख्यिकी', 'ar': 'الإحصائيات', 'bn': 'পরিসংখ্যান', },
    'nr1w2zcj': { 'de': 'Statistiken', 'en': 'Statistics', 'ko': '통계', 'it': 'Statistiche', 'fr': 'Statistiques', 'es': 'Estadísticas', 'ru': 'Статистика', 'pt': 'Estatísticas', 'tr': 'İstatistikler', 'ja': '統計', 'hi': 'सांख्यिकी', 'ar': 'الإحصائيات', 'bn': 'পরিসংখ্যান', }, // Duplicate key description
    'bqerj86e': { 'de': 'Serie', 'en': 'Streak', 'ko': '연속 기록', 'it': 'Serie', 'fr': 'Série', 'es': 'Racha', 'ru': 'Серия', 'pt': 'Sequência', 'tr': 'Seri', 'ja': '連続記録', 'hi': 'सिलसिला', 'ar': 'سلسلة متتالية', 'bn': 'ধারাবাহিকতা', },
    'i1x4r4oh': { 'de': '8', 'en': '8', 'ko': '8', 'it': '8', 'fr': '8', 'es': '8', 'ru': '8', 'pt': '8', 'tr': '8', 'ja': '8', 'hi': '८', 'ar': '٨', 'bn': '৮', }, // Data
    'ezjaph7o': { 'de': '8', 'en': '8', 'ko': '8', 'it': '8', 'fr': '8', 'es': '8', 'ru': '8', 'pt': '8', 'tr': '8', 'ja': '8', 'hi': '८', 'ar': '٨', 'bn': '৮', }, // Data
    'coa9vvfd': { 'de': 'Aktuelle Serie', 'en': 'Current Streak', 'ko': '현재 연속 기록', 'it': 'Serie attuale', 'fr': 'Série actuelle', 'es': 'Racha actual', 'ru': 'Текущая серия', 'pt': 'Sequência Atual', 'tr': 'Mevcut Seri', 'ja': '現在の連続記録', 'hi': 'वर्तमान सिलसिला', 'ar': 'السلسلة الحالية', 'bn': 'বর্তমান ধারাবাহিকতা', },
    'it1vq0r1': { 'de': 'Tage in Folge', 'en': 'days in a row', 'ko': '일 연속', 'it': 'giorni di fila', 'fr': 'jours de suite', 'es': 'días seguidos', 'ru': 'дней подряд', 'pt': 'dias seguidos', 'tr': 'gün üst üste', 'ja': '日連続', 'hi': 'दिन लगातार', 'ar': 'أيام متتالية', 'bn': 'টানা দিন', },
    'umnfc3vw': { 'de': '23', 'en': '23', 'ko': '23', 'it': '23', 'fr': '23', 'es': '23', 'ru': '23', 'pt': '23', 'tr': '23', 'ja': '23', 'hi': '२३', 'ar': '٢٣', 'bn': '২৩', }, // Data
    '43zpqv1x': { 'de': '23', 'en': '23', 'ko': '23', 'it': '23', 'fr': '23', 'es': '23', 'ru': '23', 'pt': '23', 'tr': '23', 'ja': '23', 'hi': '२३', 'ar': '٢٣', 'bn': '২৩', }, // Data
    '9yus97gl': { 'de': 'Längste Serie', 'en': 'Longest Streak', 'ko': '최장 연속 기록', 'it': 'Serie più lunga', 'fr': 'Plus longue série', 'es': 'Racha más larga', 'ru': 'Самая длинная серия', 'pt': 'Maior Sequência', 'tr': 'En Uzun Seri', 'ja': '最長連続記録', 'hi': 'सबसे लंबा सिलसिला', 'ar': 'أطول سلسلة متتالية', 'bn': 'দীর্ঘতম ধারাবাহিকতা', },
    'hplt8wwc': { 'de': 'Max. Serie', 'en': 'Max Streak', 'ko': '최대 연속 기록', 'it': 'Serie max', 'fr': 'Série max', 'es': 'Racha máx', 'ru': 'Макс. серия', 'pt': 'Sequência Máx.', 'tr': 'Maks. Seri', 'ja': '最大連続記録', 'hi': 'अधिकतम सिलसिला', 'ar': 'أقصى سلسلة', 'bn': 'সর্বোচ্চ ধারাবাহিকতা', },
    'titegc7k': { 'de': 'Tage in Folge', 'en': 'days in a row', 'ko': '일 연속', 'it': 'giorni di fila', 'fr': 'jours de suite', 'es': 'días seguidos', 'ru': 'дней подряд', 'pt': 'dias seguidos', 'tr': 'gün üst üste', 'ja': '日連続', 'hi': 'दिन लगातार', 'ar': 'أيام متتالية', 'bn': 'টানা দিন', },
    'jveitc1u': { 'de': '152', 'en': '152', 'ko': '152', 'it': '152', 'fr': '152', 'es': '152', 'ru': '152', 'pt': '152', 'tr': '152', 'ja': '152', 'hi': '१५२', 'ar': '١٥٢', 'bn': '১৫২', }, // Data
    'p20ker9v': { 'de': '152', 'en': '152', 'ko': '152', 'it': '152', 'fr': '152', 'es': '152', 'ru': '152', 'pt': '152', 'tr': '152', 'ja': '152', 'hi': '१५२', 'ar': '١٥٢', 'bn': '১৫২', }, // Data
    'yq6jdhxn': { 'de': 'Check-ins gesamt', 'en': 'Total Check-ins', 'ko': '총 체크인', 'it': 'Check-in totali', 'fr': 'Check-ins totaux', 'es': 'Check-ins totales', 'ru': 'Всего отметок', 'pt': 'Total de Check-ins', 'tr': 'Toplam Check-in', 'ja': '合計チェックイン数', 'hi': 'कुल चेक-इन', 'ar': 'إجمالي تسجيلات الحضور', 'bn': 'মোট চেক-ইন', },
    'c4k56jkc': { 'de': 'Posts gesamt', 'en': 'Total Posts', 'ko': '총 게시물', 'it': 'Post totali', 'fr': 'Posts totaux', 'es': 'Posts totales', 'ru': 'Всего постов', 'pt': 'Total de Posts', 'tr': 'Toplam Gönderi', 'ja': '合計投稿数', 'hi': 'कुल पोस्ट', 'ar': 'إجمالي المنشورات', 'bn': 'মোট পোস্ট', },
    '3bwwnqxn': { 'de': 'seit Beginn', 'en': 'since you started', 'ko': '시작 이후', 'it': 'da quando hai iniziato', 'fr': 'depuis que tu as commencé', 'es': 'desde que empezaste', 'ru': 'с момента начала', 'pt': 'desde que você começou', 'tr': 'başladığından beri', 'ja': '開始以来', 'hi': 'शुरू करने के बाद से', 'ar': 'منذ أن بدأت', 'bn': 'শুরু করার পর থেকে', },
    'ewo9brwi': { 'de': '47', 'en': '47', 'ko': '47', 'it': '47', 'fr': '47', 'es': '47', 'ru': '47', 'pt': '47', 'tr': '47', 'ja': '47', 'hi': '४७', 'ar': '٤٧', 'bn': '৪৭', }, // Data
    '4hbtwclj': { 'de': '47', 'en': '47', 'ko': '47', 'it': '47', 'fr': '47', 'es': '47', 'ru': '47', 'pt': '47', 'tr': '47', 'ja': '47', 'hi': '४७', 'ar': '٤٧', 'bn': '৪৭', }, // Data
    'pvmzu0v6': { 'de': 'Gruppen Check-ins', 'en': 'Group Check-ins', 'ko': '그룹 체크인', 'it': 'Check-in di gruppo', 'fr': 'Check-ins de groupe', 'es': 'Check-ins de grupo', 'ru': 'Групповые отметки', 'pt': 'Check-ins de Grupo', 'tr': 'Grup Check-in\'leri', 'ja': 'グループチェックイン', 'hi': 'समूह चेक-इन', 'ar': 'تسجيلات حضور المجموعة', 'bn': 'গ্রুপ চেক-ইন', },
    'bwnj13gt': { 'de': 'Gruppen Posts', 'en': 'Group Posts', 'ko': '그룹 게시물', 'it': 'Post di gruppo', 'fr': 'Posts de groupe', 'es': 'Posts de grupo', 'ru': 'Групповые посты', 'pt': 'Posts de Grupo', 'tr': 'Grup Gönderileri', 'ja': 'グループ投稿', 'hi': 'समूह पोस्ट', 'ar': 'منشورات المجموعة', 'bn': 'গ্রুপ পোস্ট', },
    'afcerjxv': { 'de': 'mit Freunden', 'en': 'with friends', 'ko': '친구와 함께', 'it': 'con amici', 'fr': 'avec des amis', 'es': 'con amigos', 'ru': 'с друзьями', 'pt': 'com amigos', 'tr': 'arkadaşlarla', 'ja': '友達と', 'hi': 'दोस्तों के साथ', 'ar': 'مع الأصدقاء', 'bn': 'বন্ধুদের সাথে', },
    '2esbnt1b': { 'de': 'Diese Woche', 'en': 'This Week', 'ko': '이번 주', 'it': 'Questa settimana', 'fr': 'Cette semaine', 'es': 'Esta semana', 'ru': 'Эта неделя', 'pt': 'Esta Semana', 'tr': 'Bu Hafta', 'ja': '今週', 'hi': 'इस सप्ताह', 'ar': 'هذا الأسبوع', 'bn': 'এই সপ্তাহ', },
    'al681wub': { 'de': 'Diese Woche', 'en': 'This Week', 'ko': '이번 주', 'it': 'Questa settimana', 'fr': 'Cette semaine', 'es': 'Esta semana', 'ru': 'Эта неделя', 'pt': 'Esta Semana', 'tr': 'Bu Hafta', 'ja': '今週', 'hi': 'इस सप्ताह', 'ar': 'هذا الأسبوع', 'bn': 'এই সপ্তাহ', },
    'b4rqtut6': { 'de': 'Dieser Monat', 'en': 'This Month', 'ko': '이번 달', 'it': 'Questo mese', 'fr': 'Ce mois-ci', 'es': 'Este mes', 'ru': 'Этот месяц', 'pt': 'Este Mês', 'tr': 'Bu Ay', 'ja': '今月', 'hi': 'इस महीने', 'ar': 'هذا الشهر', 'bn': 'এই মাস', },
    'fy6s9g93': { 'de': 'Dieser Monat', 'en': 'This Month', 'ko': '이번 달', 'it': 'Questo mese', 'fr': 'Ce mois-ci', 'es': 'Este mes', 'ru': 'Этот месяц', 'pt': 'Este Mês', 'tr': 'Bu Ay', 'ja': '今月', 'hi': 'इस महीने', 'ar': 'هذا الشهر', 'bn': 'এই মাস', },
    'iej2yejz': { 'de': 'Gewohnheitskategorien', 'en': 'Habit Categories', 'ko': '습관 카테고리', 'it': 'Categorie di abitudini', 'fr': 'Catégories d\'habitudes', 'es': 'Categorías de hábitos', 'ru': 'Категории привычек', 'pt': 'Categorias de Hábitos', 'tr': 'Alışkanlık Kategorileri', 'ja': '習慣カテゴリー', 'hi': 'आदत श्रेणियाँ', 'ar': 'فئات العادات', 'bn': 'অভ্যাসের বিভাগ', },
    'fsfl3ixx': { 'de': 'Sieh, in welche Kategorien deine Gewohnheiten fallen', 'en': 'See which categories your habits fall into', 'ko': '습관이 어떤 카테고리에 속하는지 확인하세요', 'it': 'Guarda in quali categorie rientrano le tue abitudini', 'fr': 'Voyez dans quelles catégories vos habitudes se classent', 'es': 'Mira en qué categorías se encuentran tus hábitos', 'ru': 'Посмотрите, к каким категориям относятся ваши привычки', 'pt': 'Veja em quais categorias seus hábitos se enquadram', 'tr': 'Alışkanlıklarınızın hangi kategorilere girdiğini görün', 'ja': 'あなたの習慣がどのカテゴリーに分類されるかを確認', 'hi': 'देखें कि आपकी आदतें किन श्रेणियों में आती हैं', 'ar': 'انظر إلى أي فئات تندرج عاداتك', 'bn': 'আপনার অভ্যাসগুলি কোন বিভাগে পড়ে তা দেখুন', },
    'mrp0arbc': { 'de': 'Körperlich', 'en': 'Physical', 'ko': '신체', 'it': 'Fisico', 'fr': 'Physique', 'es': 'Físico', 'ru': 'Физические', 'pt': 'Físico', 'tr': 'Fiziksel', 'ja': '身体', 'hi': 'शारीरिक', 'ar': 'بدني', 'bn': 'শারীরিক', },
    'zfs1ktqh': { 'de': 'Körperlich', 'en': 'Physical', 'ko': '신체', 'it': 'Fisico', 'fr': 'Physique', 'es': 'Físico', 'ru': 'Физические', 'pt': 'Físico', 'tr': 'Fiziksel', 'ja': '身体', 'hi': 'शारीरिक', 'ar': 'بدني', 'bn': 'শারীরিক', },
    '6isgu2gh': { 'de': '17 Check-ins', 'en': '17 check-ins', 'ko': '17 체크인', 'it': '17 check-in', 'fr': '17 check-ins', 'es': '17 check-ins', 'ru': '17 отметок', 'pt': '17 check-ins', 'tr': '17 check-in', 'ja': '17 チェックイン', 'hi': '17 चेक-इन', 'ar': '17 تسجيل حضور', 'bn': '১৭টি চেক-ইন', },
    'xp5k1jv1': { 'de': '17 Check-ins', 'en': '17 check-ins', 'ko': '17 체크인', 'it': '17 check-in', 'fr': '17 check-ins', 'es': '17 check-ins', 'ru': '17 отметок', 'pt': '17 check-ins', 'tr': '17 check-in', 'ja': '17 チェックイン', 'hi': '17 चेक-इन', 'ar': '17 تسجيل حضور', 'bn': '১৭টি চেক-ইন', },
    '753fpgdj': { 'de': 'Geistig', 'en': 'Mental', 'ko': '정신', 'it': 'Mentale', 'fr': 'Mental', 'es': 'Mental', 'ru': 'Ментальные', 'pt': 'Mental', 'tr': 'Zihinsel', 'ja': '精神', 'hi': 'मानसिक', 'ar': 'عقلي', 'bn': 'মানসিক', },
    'sihxwgg9': { 'de': 'Geistig', 'en': 'Mental', 'ko': '정신', 'it': 'Mentale', 'fr': 'Mental', 'es': 'Mental', 'ru': 'Ментальные', 'pt': 'Mental', 'tr': 'Zihinsel', 'ja': '精神', 'hi': 'मानसिक', 'ar': 'عقلي', 'bn': 'মানসিক', },
    '2zj49ztz': { 'de': '12 Check-ins', 'en': '12 check-ins', 'ko': '12 체크인', 'it': '12 check-in', 'fr': '12 check-ins', 'es': '12 check-ins', 'ru': '12 отметок', 'pt': '12 check-ins', 'tr': '12 check-in', 'ja': '12 チェックイン', 'hi': '12 चेक-इन', 'ar': '12 تسجيل حضور', 'bn': '১২টি চেক-ইন', },
    'a2ps7c52': { 'de': '12 Check-ins', 'en': '12 check-ins', 'ko': '12 체크인', 'it': '12 check-in', 'fr': '12 check-ins', 'es': '12 check-ins', 'ru': '12 отметок', 'pt': '12 check-ins', 'tr': '12 check-in', 'ja': '12 チェックイン', 'hi': '12 चेक-इन', 'ar': '12 تسجيل حضور', 'bn': '১২টি চেক-ইন', },
    'f8w7rhyq': { 'de': 'Lernen', 'en': 'Learning', 'ko': '학습', 'it': 'Apprendimento', 'fr': 'Apprentissage', 'es': 'Aprendizaje', 'ru': 'Обучение', 'pt': 'Aprendizagem', 'tr': 'Öğrenme', 'ja': '学習', 'hi': 'सीखना', 'ar': 'تعلم', 'bn': 'শিক্ষা', },
    '2ripohmt': { 'de': 'Lernen', 'en': 'Learning', 'ko': '학습', 'it': 'Apprendimento', 'fr': 'Apprentissage', 'es': 'Aprendizaje', 'ru': 'Обучение', 'pt': 'Aprendizagem', 'tr': 'Öğrenme', 'ja': '学習', 'hi': 'सीखना', 'ar': 'تعلم', 'bn': 'শিক্ষা', },
    'vypwijcz': { 'de': '10 Check-ins', 'en': '10 check-ins', 'ko': '10 체크인', 'it': '10 check-in', 'fr': '10 check-ins', 'es': '10 check-ins', 'ru': '10 отметок', 'pt': '10 check-ins', 'tr': '10 check-in', 'ja': '10 チェックイン', 'hi': '10 चेक-इन', 'ar': '10 تسجيلات حضور', 'bn': '১০টি চেক-ইন', },
    '24ngvsat': { 'de': '10 Check-ins', 'en': '10 check-ins', 'ko': '10 체크인', 'it': '10 check-in', 'fr': '10 check-ins', 'es': '10 check-ins', 'ru': '10 отметок', 'pt': '10 check-ins', 'tr': '10 check-in', 'ja': '10 チェックイン', 'hi': '10 चेक-इन', 'ar': '10 تسجيلات حضور', 'bn': '১০টি চেক-ইন', },
    'rktvmerh': { 'de': 'Sozial', 'en': 'Social', 'ko': '사회', 'it': 'Sociale', 'fr': 'Social', 'es': 'Social', 'ru': 'Социальные', 'pt': 'Social', 'tr': 'Sosyal', 'ja': '社会', 'hi': 'सामाजिक', 'ar': 'اجتماعي', 'bn': 'সামাজিক', },
    'kb7da1r5': { 'de': 'Sozial', 'en': 'Social', 'ko': '사회', 'it': 'Sociale', 'fr': 'Social', 'es': 'Social', 'ru': 'Социальные', 'pt': 'Social', 'tr': 'Sosyal', 'ja': '社会', 'hi': 'सामाजिक', 'ar': 'اجتماعي', 'bn': 'সামাজিক', },
    'al0hizd0': { 'de': '8 Check-ins', 'en': '8 check-ins', 'ko': '8 체크인', 'it': '8 check-in', 'fr': '8 check-ins', 'es': '8 check-ins', 'ru': '8 отметок', 'pt': '8 check-ins', 'tr': '8 check-in', 'ja': '8 チェックイン', 'hi': '8 चेक-इन', 'ar': '8 تسجيلات حضور', 'bn': '৮টি চেক-ইন', },
    '3j5vwl1s': { 'de': '8 Check-ins', 'en': '8 check-ins', 'ko': '8 체크인', 'it': '8 check-in', 'fr': '8 check-ins', 'es': '8 check-ins', 'ru': '8 отметок', 'pt': '8 check-ins', 'tr': '8 check-in', 'ja': '8 チェックイン', 'hi': '8 चेक-इन', 'ar': '8 تسجيلات حضور', 'bn': '৮টি চেক-ইন', },
    'marswflr': { 'de': 'Gesundheit', 'en': 'Health', 'ko': '건강', 'it': 'Salute', 'fr': 'Santé', 'es': 'Salud', 'ru': 'Здоровье', 'pt': 'Saúde', 'tr': 'Sağlık', 'ja': '健康', 'hi': 'स्वास्थ्य', 'ar': 'صحة', 'bn': 'স্বাস্থ্য', },
    'um36hnq1': { 'de': 'Gesundheit', 'en': 'Health', 'ko': '건강', 'it': 'Salute', 'fr': 'Santé', 'es': 'Salud', 'ru': 'Здоровье', 'pt': 'Saúde', 'tr': 'Sağlık', 'ja': '健康', 'hi': 'स्वास्थ्य', 'ar': 'صحة', 'bn': 'স্বাস্থ্য', },
    'l7hut59c': { 'de': '7 Check-ins', 'en': '7 check-ins', 'ko': '7 체크인', 'it': '7 check-in', 'fr': '7 check-ins', 'es': '7 check-ins', 'ru': '7 отметок', 'pt': '7 check-ins', 'tr': '7 check-in', 'ja': '7 チェックイン', 'hi': '7 चेक-इन', 'ar': '7 تسجيلات حضور', 'bn': '৭টি চেক-ইন', },
    'n4cu9v6x': { 'de': '7 Check-ins', 'en': '7 check-ins', 'ko': '7 체크인', 'it': '7 check-in', 'fr': '7 check-ins', 'es': '7 check-ins', 'ru': '7 отметок', 'pt': '7 check-ins', 'tr': '7 check-in', 'ja': '7 チェックイン', 'hi': '7 चेक-इन', 'ar': '7 تسجيلات حضور', 'bn': '৭টি চেক-ইন', },
    'ba02iqp0': { 'de': 'Kreativität', 'en': 'Creativity', 'ko': '창의성', 'it': 'Creatività', 'fr': 'Créativité', 'es': 'Creatividad', 'ru': 'Творчество', 'pt': 'Criatividade', 'tr': 'Yaratıcılık', 'ja': '創造性', 'hi': 'रचनात्मकता', 'ar': 'إبداع', 'bn': 'সৃজনশীলতা', },
    'd11d7y19': { 'de': 'Kreativität', 'en': 'Creativity', 'ko': '창의성', 'it': 'Creatività', 'fr': 'Créativité', 'es': 'Creatividad', 'ru': 'Творчество', 'pt': 'Criatividade', 'tr': 'Yaratıcılık', 'ja': '創造性', 'hi': 'रचनात्मकता', 'ar': 'إبداع', 'bn': 'সৃজনশীলতা', },
    'p7zqfwtw': { 'de': '5 Check-ins', 'en': '5 check-ins', 'ko': '5 체크인', 'it': '5 check-in', 'fr': '5 check-ins', 'es': '5 check-ins', 'ru': '5 отметок', 'pt': '5 check-ins', 'tr': '5 check-in', 'ja': '5 チェックイン', 'hi': '5 चेक-इन', 'ar': '5 تسجيلات حضور', 'bn': '৫টি চেক-ইন', },
    'ydkefvha': { 'de': '5 Check-ins', 'en': '5 check-ins', 'ko': '5 체크인', 'it': '5 check-in', 'fr': '5 check-ins', 'es': '5 check-ins', 'ru': '5 отметок', 'pt': '5 check-ins', 'tr': '5 check-in', 'ja': '5 チェックイン', 'hi': '5 चेक-इन', 'ar': '5 تسجيلات حضور', 'bn': '৫টি চেক-ইন', },
    '5kx7e47z': { 'de': 'Du machst das großartig!\nHalte deine 8-Tage-Serie aufrecht, um einen neuen persönlichen Rekord zu erreichen.', 'en': 'You\'re doing great!\nKeep up your 8-day streak to reach a new personal record.', 'ko': '잘 하고 있어요!\n8일 연속 기록을 유지하여 새로운 개인 기록을 달성하세요.', 'it': 'Stai andando alla grande!\nMantieni la tua serie di 8 giorni per raggiungere un nuovo record personale.', 'fr': 'Tu te débrouilles très bien !\nMaintiens ta série de 8 jours pour atteindre un nouveau record personnel.', 'es': '¡Lo estás haciendo genial!\nMantén tu racha de 8 días para alcanzar un nuevo récord personal.', 'ru': 'Отличная работа!\nПродолжайте свою 8-дневную серию, чтобы установить новый личный рекорд.', 'pt': 'Você está indo muito bem!\nMantenha sua sequência de 8 dias para alcançar um novo recorde pessoal.', 'tr': 'Harika gidiyorsun!\nYeni bir kişisel rekor kırmak için 8 günlük serini sürdür.', 'ja': '素晴らしい！\n自己新記録達成のために8日連続記録を続けましょう。', 'hi': 'आप बहुत अच्छा कर रहे हैं!\nनया व्यक्तिगत रिकॉर्ड बनाने के लिए अपनी 8-दिवसीय लकीर जारी रखें।', 'ar': 'أنت تقوم بعمل رائع!\nحافظ على سلسلتك المتتالية لمدة 8 أيام للوصول إلى رقم قياسي شخصي جديد.', 'bn': 'আপনি দারুণ করছেন!\nনতুন ব্যক্তিগত রেকর্ড গড়তে আপনার ৮ দিনের ধারাবাহিকতা বজায় রাখুন।', },
  }, // <-- Make sure there's a comma here before the next section's map starts
  // groupcreationscreen / group_creation_2
  // groupcreationscreen / group_creation_2 (Consolidated)
  {
    'aqw0su40': { 'de': 'Gruppe erstellen', 'en': 'Create Group', 'ko': '그룹 만들기', 'it': 'Crea gruppo', 'fr': 'Créer un groupe', 'es': 'Crear grupo', 'ru': 'Создать группу', 'pt': 'Criar Grupo', 'tr': 'Grup Oluştur', 'ja': 'グループを作成', 'hi': 'समूह बनाएँ', 'ar': 'إنشاء مجموعة', 'bn': 'গ্রুপ তৈরি করুন', },
    '8pwt1bxu': { 'de': 'Gewohnheit erstellen', 'en': 'Create Habit', 'ko': '습관 만들기', 'it': 'Crea abitudine', 'fr': 'Créer une habitude', 'es': 'Crear hábito', 'ru': 'Создать привычку', 'pt': 'Criar Hábito', 'tr': 'Alışkanlık Oluştur', 'ja': '習慣を作成', 'hi': 'आदत बनाएँ', 'ar': 'إنشاء عادة', 'bn': 'অভ্যাস তৈরি করুন', }, // Often related to group creation
    '2yfba7eg': { 'de': 'Gruppeninformationen', 'en': 'Group Information', 'ko': '그룹 정보', 'it': 'Informazioni sul gruppo', 'fr': 'Informations sur le groupe', 'es': 'Información del grupo', 'ru': 'Информация о группе', 'pt': 'Informações do Grupo', 'tr': 'Grup Bilgileri', 'ja': 'グループ情報', 'hi': 'समूह जानकारी', 'ar': 'معلومات المجموعة', 'bn': 'গ্রুপের তথ্য', },
    'n52lssqi': { 'de': 'Gruppeninformationen', 'en': 'Group information', 'ko': '그룹 정보', 'it': 'Informazioni sul gruppo', 'fr': 'Informations sur le groupe', 'es': 'Información del grupo', 'ru': 'Информация о группе', 'pt': 'Informações do grupo', 'tr': 'Grup bilgileri', 'ja': 'グループ情報', 'hi': 'समूह जानकारी', 'ar': 'معلومات المجموعة', 'bn': 'গ্রুপের তথ্য', },
    'z2onr9tn': { 'de': 'Gruppennamen eingeben', 'en': 'Enter group name', 'ko': '그룹 이름 입력', 'it': 'Inserisci il nome del gruppo', 'fr': 'Entrez le nom du groupe', 'es': 'Introduce el nombre del grupo', 'ru': 'Введите название группы', 'pt': 'Digite o nome do grupo', 'tr': 'Grup adını girin', 'ja': 'グループ名を入力', 'hi': 'समूह का नाम दर्ज करें', 'ar': 'أدخل اسم المجموعة', 'bn': 'গ্রুপের নাম লিখুন', },
    'mk8p3b43': { 'de': 'Gewohnheitsnamen eingeben', 'en': 'Enter habit name', 'ko': '습관 이름 입력', 'it': 'Inserisci nome abitudine', 'fr': 'Entrez le nom de l\'habitude', 'es': 'Introduce el nombre del hábito', 'ru': 'Введите название привычки', 'pt': 'Digite o nome do hábito', 'tr': 'Alışkanlık adını girin', 'ja': '習慣名を入力', 'hi': 'आदत का नाम दर्ज करें', 'ar': 'أدخل اسم العادة', 'bn': 'অভ্যাসের নাম লিখুন', }, // Assuming this belongs here too
    'ref2t7lu': { 'de': 'Kurze Beschreibung der Gruppe (optional)', 'en': 'Brief description of the group (optional)', 'ko': '그룹에 대한 간략한 설명 (선택 사항)', 'it': 'Breve descrizione del gruppo (opzionale)', 'fr': 'Brève description du groupe (facultatif)', 'es': 'Breve descripción del grupo (opcional)', 'ru': 'Краткое описание группы (необязательно)', 'pt': 'Breve descrição do grupo (opcional)', 'tr': 'Grubun kısa açıklaması (isteğe bağlı)', 'ja': 'グループの簡単な説明（任意）', 'hi': 'समूह का संक्षिप्त विवरण (वैकल्पिक)', 'ar': 'وصف موجز للمجموعة (اختياري)', 'bn': 'গ্রুপের সংক্ষিপ্ত বিবরণ (ঐচ্ছিক)', },
    '6xx513o9': { 'de': 'Kurze Beschreibung der Gruppe (optional)', 'en': 'Brief description of the group (optional)', 'ko': '그룹에 대한 간략한 설명 (선택 사항)', 'it': 'Breve descrizione del gruppo (opzionale)', 'fr': 'Brève description du groupe (facultatif)', 'es': 'Breve descripción del grupo (opcional)', 'ru': 'Краткое описание группы (необязательно)', 'pt': 'Breve descrição do grupo (opcional)', 'tr': 'Grubun kısa açıklaması (isteğe bağlı)', 'ja': 'グループの簡単な説明（任意）', 'hi': 'समूह का संक्षिप्त विवरण (वैकल्पिक)', 'ar': 'وصف موجز للمجموعة (اختياري)', 'bn': 'গ্রুপের সংক্ষিপ্ত বিবরণ (ঐচ্ছিক)', },
    '9bkg5yg6': { 'de': 'Gruppentyp', 'en': 'Group Type', 'ko': '그룹 유형', 'it': 'Tipo di gruppo', 'fr': 'Type de groupe', 'es': 'Tipo de grupo', 'ru': 'Тип группы', 'pt': 'Tipo de Grupo', 'tr': 'Grup Türü', 'ja': 'グループタイプ', 'hi': 'समूह का प्रकार', 'ar': 'نوع المجموعة', 'bn': 'গ্রুপের ধরণ', },
    'gzgkjncy': { 'de': 'Gruppentyp', 'en': 'Group Type', 'ko': '그룹 유형', 'it': 'Tipo di gruppo', 'fr': 'Type de groupe', 'es': 'Tipo de grupo', 'ru': 'Тип группы', 'pt': 'Tipo de Grupo', 'tr': 'Grup Türü', 'ja': 'グループタイプ', 'hi': 'समूह का प्रकार', 'ar': 'نوع المجموعة', 'bn': 'গ্রুপের ধরণ', },
    'bvvh974p': { 'de': 'Öffentlich', 'en': 'Public', 'ko': '공개', 'it': 'Pubblico', 'fr': 'Public', 'es': 'Público', 'ru': 'Общедоступная', 'pt': 'Público', 'tr': 'Herkese Açık', 'ja': '公開', 'hi': 'सार्वजनिक', 'ar': 'عام', 'bn': 'পাবলিক', },
    'habrbvsb': { 'de': 'Privat', 'en': 'Private', 'ko': '비공개', 'it': 'Privato', 'fr': 'Privé', 'es': 'Privado', 'ru': 'Частная', 'pt': 'Privado', 'tr': 'Özel', 'ja': '非公開', 'hi': 'निजी', 'ar': 'خاص', 'bn': 'ব্যক্তিগত', },
    'qtlpe3yt': { 'de': 'Nur per Link sichtbar', 'en': 'Only visible via link', 'ko': '링크로만 공개', 'it': 'Visibile solo tramite link', 'fr': 'Visible uniquement par lien', 'es': 'Visible solo por enlace', 'ru': 'Только по ссылке', 'pt': 'Visível apenas por link', 'tr': 'Sadece bağlantı ile görünür', 'ja': 'リンクでのみ表示', 'hi': 'केवल लिंक के माध्यम से दिखाई दे', 'ar': 'مرئي فقط عبر الرابط', 'bn': 'শুধুমাত্র লিঙ্কের মাধ্যমে দৃশ্যমান', },
    'u7c2h67w': { 'de': 'Privat', 'en': 'Private', 'ko': '비공개', 'it': 'Privato', 'fr': 'Privé', 'es': 'Privado', 'ru': 'Частная', 'pt': 'Privado', 'tr': 'Özel', 'ja': '非公開', 'hi': 'निजी', 'ar': 'خاص', 'bn': 'ব্যক্তিগত', },
    '931z9byq': { 'de': 'Nur per Link sichtbar', 'en': 'Only visible via link', 'ko': '링크로만 공개', 'it': 'Visibile solo tramite link', 'fr': 'Visible uniquement par lien', 'es': 'Visible solo por enlace', 'ru': 'Только по ссылке', 'pt': 'Visível apenas por link', 'tr': 'Sadece bağlantı ile görünür', 'ja': 'リンクでのみ表示', 'hi': 'केवल लिंक के माध्यम से दिखाई दे', 'ar': 'مرئي فقط عبر الرابط', 'bn': 'শুধুমাত্র লিঙ্কের মাধ্যমে দৃশ্যমান', },
    'sxcg6a6z': { 'de': 'Privat', 'en': 'Private', 'ko': '비공개', 'it': 'Privato', 'fr': 'Privé', 'es': 'Privado', 'ru': 'Частная', 'pt': 'Privado', 'tr': 'Özel', 'ja': '非公開', 'hi': 'निजी', 'ar': 'خاص', 'bn': 'ব্যক্তিগত', },
    'neixencx': { 'de': 'Nur per Link sichtbar', 'en': 'Only visible via link', 'ko': '링크로만 공개', 'it': 'Visibile solo tramite link', 'fr': 'Visible uniquement par lien', 'es': 'Visible solo por enlace', 'ru': 'Только по ссылке', 'pt': 'Visível apenas por link', 'tr': 'Sadece bağlantı ile görünür', 'ja': 'リンクでのみ表示', 'hi': 'केवल लिंक के माध्यम से दिखाई दे', 'ar': 'مرئي فقط عبر الرابط', 'bn': 'শুধুমাত্র লিঙ্কের মাধ্যমে দৃশ্যমান', },
    'o4w2uohq': { 'de': 'Details zur Gruppengewohnheit', 'en': 'Group Habit Details', 'ko': '그룹 습관 세부 정보', 'it': 'Dettagli abitudine di gruppo', 'fr': 'Détails de l\'habitude de groupe', 'es': 'Detalles del hábito grupal', 'ru': 'Детали групповой привычки', 'pt': 'Detalhes do Hábito de Grupo', 'tr': 'Grup Alışkanlığı Detayları', 'ja': 'グループ習慣の詳細', 'hi': 'समूह आदत विवरण', 'ar': 'تفاصيل عادة المجموعة', 'bn': 'গ্রুপের অভ্যাসের বিবরণ', },
    'kqrliash': { 'de': 'Informationen zur Gruppengewohnheit', 'en': 'Group habit information', 'ko': '그룹 습관 정보', 'it': 'Informazioni sull\'abitudine di gruppo', 'fr': 'Informations sur l\'habitude de groupe', 'es': 'Información del hábito grupal', 'ru': 'Информация о групповой привычке', 'pt': 'Informações do hábito de grupo', 'tr': 'Grup alışkanlığı bilgileri', 'ja': 'グループ習慣の情報', 'hi': 'समूह आदत जानकारी', 'ar': 'معلومات عادة المجموعة', 'bn': 'গ্রুপের অভ্যাসের তথ্য', },
    'aj2p5hw4': { 'de': 'Gewohnheitsnamen eingeben', 'en': 'Enter habit name', 'ko': '습관 이름 입력', 'it': 'Inserisci nome abitudine', 'fr': 'Entrez le nom de l\'habitude', 'es': 'Introduce el nombre del hábito', 'ru': 'Введите название привычки', 'pt': 'Digite o nome do hábito', 'tr': 'Alışkanlık adını girin', 'ja': '習慣名を入力', 'hi': 'आदत का नाम दर्ज करें', 'ar': 'أدخل اسم العادة', 'bn': 'অভ্যাসের নাম লিখুন', },
    'j4xe8vgz': { 'de': 'Gewohnheitsnamen eingeben', 'en': 'Enter habit name', 'ko': '습관 이름 입력', 'it': 'Inserisci nome abitudine', 'fr': 'Entrez le nom de l\'habitude', 'es': 'Introduce el nombre del hábito', 'ru': 'Введите название привычки', 'pt': 'Digite o nome do hábito', 'tr': 'Alışkanlık adını girin', 'ja': '習慣名を入力', 'hi': 'आदत का नाम दर्ज करें', 'ar': 'أدخل اسم العادة', 'bn': 'অভ্যাসের নাম লিখুন', },
    'jyxjxp2z': { 'de': '08:00', 'en': '08:00 AM', 'ko': '08:00', 'it': '08:00', 'fr': '08:00', 'es': '08:00', 'ru': '08:00', 'pt': '08:00', 'tr': '08:00', 'ja': '08:00', 'hi': '08:00', 'ar': '08:00', 'bn': '08:00', },
    'ykqyd40j': { 'de': '08:00', 'en': '08:00 AM', 'ko': '08:00', 'it': '08:00', 'fr': '08:00', 'es': '08:00', 'ru': '08:00', 'pt': '08:00', 'tr': '08:00', 'ja': '08:00', 'hi': '08:00', 'ar': '08:00', 'bn': '08:00', },
    'ylzv2ngb': { 'de': 'Optional', 'en': 'Optional', 'ko': '선택 사항', 'it': 'Opzionale', 'fr': 'Facultatif', 'es': 'Opcional', 'ru': 'Необязательно', 'pt': 'Opcional', 'tr': 'İsteğe bağlı', 'ja': '任意', 'hi': 'वैकल्पिक', 'ar': 'اختياري', 'bn': 'ঐচ্ছিক', },
    'ytbvwjfo': { 'de': 'Wochentage', 'en': 'Days of the Week', 'ko': '요일', 'it': 'Giorni della settimana', 'fr': 'Jours de la semaine', 'es': 'Días de la semana', 'ru': 'Дни недели', 'pt': 'Dias da Semana', 'tr': 'Haftanın Günleri', 'ja': '曜日', 'hi': 'सप्ताह के दिन', 'ar': 'أيام الأسبوع', 'bn': 'সপ্তাহের দিনগুলো', },
    'ik82jp1f': { 'de': 'M', 'en': 'M', 'ko': '월', 'it': 'L', 'fr': 'L', 'es': 'L', 'ru': 'Пн', 'pt': 'S', 'tr': 'Pzt', 'ja': '月', 'hi': 'सो', 'ar': 'ن', 'bn': 'সো', }, 'lmtvikyq': { 'de': 'M', 'en': 'M', 'ko': '월', 'it': 'L', 'fr': 'L', 'es': 'L', 'ru': 'Пн', 'pt': 'S', 'tr': 'Pzt', 'ja': '月', 'hi': 'सो', 'ar': 'ن', 'bn': 'সো', },
    'r8puj4io': { 'de': 'D', 'en': 'T', 'ko': '화', 'it': 'M', 'fr': 'M', 'es': 'M', 'ru': 'Вт', 'pt': 'T', 'tr': 'Sa', 'ja': '火', 'hi': 'मं', 'ar': 'ث', 'bn': 'ম', }, 'h3fb4e5n': { 'de': 'D', 'en': 'T', 'ko': '화', 'it': 'M', 'fr': 'M', 'es': 'M', 'ru': 'Вт', 'pt': 'T', 'tr': 'Sa', 'ja': '火', 'hi': 'मं', 'ar': 'ث', 'bn': 'ম', },
    '2busx7k5': { 'de': 'M', 'en': 'W', 'ko': '수', 'it': 'M', 'fr': 'M', 'es': 'X', 'ru': 'Ср', 'pt': 'Q', 'tr': 'Ça', 'ja': '水', 'hi': 'बु', 'ar': 'ر', 'bn': 'বু', }, 'sw2ibdpa': { 'de': 'M', 'en': 'W', 'ko': '수', 'it': 'M', 'fr': 'M', 'es': 'X', 'ru': 'Ср', 'pt': 'Q', 'tr': 'Ça', 'ja': '水', 'hi': 'बु', 'ar': 'ر', 'bn': 'বু', },
    '89cfwxk3': { 'de': 'D', 'en': 'T', 'ko': '목', 'it': 'G', 'fr': 'J', 'es': 'J', 'ru': 'Чт', 'pt': 'Q', 'tr': 'Pe', 'ja': '木', 'hi': 'गु', 'ar': 'خ', 'bn': 'বৃ', }, 'goz8q4nq': { 'de': 'D', 'en': 'T', 'ko': '목', 'it': 'G', 'fr': 'J', 'es': 'J', 'ru': 'Чт', 'pt': 'Q', 'tr': 'Pe', 'ja': '木', 'hi': 'गु', 'ar': 'خ', 'bn': 'বৃ', },
    'wb9bjyvp': { 'de': 'F', 'en': 'F', 'ko': '금', 'it': 'V', 'fr': 'V', 'es': 'V', 'ru': 'Пт', 'pt': 'S', 'tr': 'Cu', 'ja': '金', 'hi': 'शु', 'ar': 'ج', 'bn': 'শু', }, '6ld9e79i': { 'de': 'F', 'en': 'F', 'ko': '금', 'it': 'V', 'fr': 'V', 'es': 'V', 'ru': 'Пт', 'pt': 'S', 'tr': 'Cu', 'ja': '金', 'hi': 'शु', 'ar': 'ج', 'bn': 'শু', },
    'g1nezn34': { 'de': 'S', 'en': 'S', 'ko': '토', 'it': 'S', 'fr': 'S', 'es': 'S', 'ru': 'Сб', 'pt': 'S', 'tr': 'Cmt', 'ja': '土', 'hi': 'श', 'ar': 'س', 'bn': 'শ', }, '29pvdgp0': { 'de': 'S', 'en': 'S', 'ko': '토', 'it': 'S', 'fr': 'S', 'es': 'S', 'ru': 'Сб', 'pt': 'S', 'tr': 'Cmt', 'ja': '土', 'hi': 'श', 'ar': 'س', 'bn': 'শ', },
    'hm5txx91': { 'de': 'S', 'en': 'S', 'ko': '일', 'it': 'D', 'fr': 'D', 'es': 'D', 'ru': 'Вс', 'pt': 'D', 'tr': 'P', 'ja': '日', 'hi': 'र', 'ar': 'ح', 'bn': 'র', }, 'h1p5gfni': { 'de': 'S', 'en': 'S', 'ko': '일', 'it': 'D', 'fr': 'D', 'es': 'D', 'ru': 'Вс', 'pt': 'D', 'tr': 'P', 'ja': '日', 'hi': 'र', 'ar': 'ح', 'bn': 'র', },
    'te6mfxa8': { 'de': 'Symbol wählen', 'en': 'Choose an icon', 'ko': '아이콘 선택', 'it': 'Scegli un\'icona', 'fr': 'Choisir une icône', 'es': 'Elige un icono', 'ru': 'Выберите значок', 'pt': 'Escolha um ícone', 'tr': 'Bir simge seçin', 'ja': 'アイコンを選択', 'hi': 'एक आइकन चुनें', 'ar': 'اختر أيقونة', 'bn': 'একটি আইকন নির্বাচন করুন', },
    'wmno4n0p': { 'de': 'Symbol auswählen', 'en': 'Select Icon', 'ko': '아이콘 선택', 'it': 'Seleziona icona', 'fr': 'Sélectionner une icône', 'es': 'Seleccionar icono', 'ru': 'Выбрать значок', 'pt': 'Selecionar Ícone', 'tr': 'Simge Seç', 'ja': 'アイコンを選択', 'hi': 'आइकन चुनें', 'ar': 'حدد أيقونة', 'bn': 'আইকন নির্বাচন করুন', },
    'ven4ixg3': { 'de': 'Farbe', 'en': 'Color', 'ko': '색상', 'it': 'Colore', 'fr': 'Couleur', 'es': 'Color', 'ru': 'Цвет', 'pt': 'Cor', 'tr': 'Renk', 'ja': '色', 'hi': 'रंग', 'ar': 'اللون', 'bn': 'রঙ', },
    'zio7nedw': { 'de': 'Freunde einladen', 'en': 'Invite Friends', 'ko': '친구 초대', 'it': 'Invita amici', 'fr': 'Inviter des amis', 'es': 'Invitar amigos', 'ru': 'Пригласить друзей', 'pt': 'Convidar Amigos', 'tr': 'Arkadaş Davet Et', 'ja': '友達を招待', 'hi': 'मित्रों को आमंत्रित करें', 'ar': 'دعوة الأصدقاء', 'bn': 'বন্ধুদের আমন্ত্রণ জানান', },
  },
  // settings
  {
    'lk39x5at': { 'de': 'Einstellungen', 'en': 'Settings', 'ko': '설정', 'it': 'Impostazioni', 'fr': 'Paramètres', 'es': 'Ajustes', 'ru': 'Настройки', 'pt': 'Configurações', 'tr': 'Ayarlar', 'ja': '設定', 'hi': 'सेटिंग्स', 'ar': 'الإعدادات', 'bn': 'সেটিংস', },
    'cyi02yrp': { 'de': 'SUPPORT', 'en': 'SUPPORT', 'ko': '지원', 'it': 'SUPPORTO', 'fr': 'SUPPORT', 'es': 'SOPORTE', 'ru': 'ПОДДЕРЖКА', 'pt': 'SUPORTE', 'tr': 'DESTEK', 'ja': 'サポート', 'hi': 'समर्थन', 'ar': 'الدعم', 'bn': 'সাপোর্ট', },
    '0djp10fi': { 'de': 'Kontakt', 'en': 'Contact Us', 'ko': '문의하기', 'it': 'Contattaci', 'fr': 'Nous contacter', 'es': 'Contáctanos', 'ru': 'Связаться с нами', 'pt': 'Contate-nos', 'tr': 'Bize Ulaşın', 'ja': 'お問い合わせ', 'hi': 'संपर्क करें', 'ar': 'اتصل بنا', 'bn': 'যোগাযোগ করুন', },
    'qg4ucjhk': { 'de': 'RECHTLICHES', 'en': 'LEGAL', 'ko': '법률', 'it': 'LEGALE', 'fr': 'LÉGAL', 'es': 'LEGAL', 'ru': 'ПРАВОВАЯ ИНФОРМАЦИЯ', 'pt': 'LEGAL', 'tr': 'YASAL', 'ja': '法的情報', 'hi': 'कानूनी', 'ar': 'قانوني', 'bn': 'আইনি', },
    'eb5xlt4v': { 'de': 'Impressum', 'en': 'Legal Notice', 'ko': '법적 고지', 'it': 'Note legali', 'fr': 'Mentions légales', 'es': 'Aviso legal', 'ru': 'Правовая информация', 'pt': 'Aviso Legal', 'tr': 'Yasal Uyarı', 'ja': '法的表示', 'hi': 'कानूनी नोटिस', 'ar': 'إشعار قانوني', 'bn': 'আইনি বিজ্ঞপ্তি', },
    '4vqvhygk': { 'de': 'Datenschutz', 'en': 'Privacy Policy', 'ko': '개인정보 처리방침', 'it': 'Politica sulla privacy', 'fr': 'Politique de confidentialité', 'es': 'Política de privacidad', 'ru': 'Политика конфиденциальности', 'pt': 'Política de Privacidade', 'tr': 'Gizlilik Politikası', 'ja': 'プライバシーポリシー', 'hi': 'गोपनीयता नीति', 'ar': 'سياسة الخصوصية', 'bn': 'গোপনীয়তা নীতি', },
    '11if3nk1': { 'de': 'KONTO', 'en': 'ACCOUNT', 'ko': '계정', 'it': 'ACCOUNT', 'fr': 'COMPTE', 'es': 'CUENTA', 'ru': 'АККАУНТ', 'pt': 'CONTA', 'tr': 'HESAP', 'ja': 'アカウント', 'hi': 'खाता', 'ar': 'الحساب', 'bn': 'অ্যাকাউন্ট', },
    'o8z58kus': { 'de': 'Abmelden', 'en': 'Log Out', 'ko': '로그아웃', 'it': 'Esci', 'fr': 'Se déconnecter', 'es': 'Cerrar sesión', 'ru': 'Выйти', 'pt': 'Sair', 'tr': 'Oturumu Kapat', 'ja': 'ログアウト', 'hi': 'लॉग आउट करें', 'ar': 'تسجيل الخروج', 'bn': 'লগ আউট', },
    'xhlmnyuv': { 'de': 'CREDITS', 'en': 'CREDITS', 'ko': '크레딧', 'it': 'CREDITI', 'fr': 'CRÉDITS', 'es': 'CRÉDITOS', 'ru': 'АВТОРЫ', 'pt': 'CRÉDITOS', 'tr': 'KATKIDA BULUNANLAR', 'ja': 'クレジット', 'hi': 'क्रेडिट्स', 'ar': 'الاعتمادات', 'bn': 'ক্রেডিট', },
    'dd81xh2h': { 'de': 'CREDITS', 'en': 'CREDITS', 'ko': '크레딧', 'it': 'CREDITI', 'fr': 'CRÉDITS', 'es': 'CRÉDITOS', 'ru': 'АВТОРЫ', 'pt': 'CRÉDITOS', 'tr': 'KATKIDA BULUNANLAR', 'ja': 'クレジット', 'hi': 'क्रेडिट्स', 'ar': 'الاعتمادات', 'bn': 'ক্রেডিট', },
    '44vyrai6': { 'de': 'Design & Entwicklung', 'en': 'Design & Development', 'ko': '디자인 및 개발', 'it': 'Design e sviluppo', 'fr': 'Conception et développement', 'es': 'Diseño y desarrollo', 'ru': 'Дизайн и разработка', 'pt': 'Design & Desenvolvimento', 'tr': 'Tasarım ve Geliştirme', 'ja': 'デザイン＆開発', 'hi': 'डिज़ाइन और विकास', 'ar': 'التصميم والتطوير', 'bn': 'ডিজাইন ও ডেভেলপমেন্ট', },
    '7av6gg7q': { 'de': 'Design & Entwicklung', 'en': 'Design & Development', 'ko': '디자인 및 개발', 'it': 'Design e sviluppo', 'fr': 'Conception et développement', 'es': 'Diseño y desarrollo', 'ru': 'Дизайн и разработка', 'pt': 'Design & Desenvolvimento', 'tr': 'Tasarım ve Geliştirme', 'ja': 'デザイン＆開発', 'hi': 'डिज़ाइन और विकास', 'ar': 'التصميم والتطوير', 'bn': 'ডিজাইন ও ডেভেলপমেন্ট', },
    '9swjw4fn': { 'de': 'Prabit Team', 'en': 'Prabit Team', 'ko': 'Prabit 팀', 'it': 'Team Prabit', 'fr': 'Équipe Prabit', 'es': 'Equipo Prabit', 'ru': 'Команда Prabit', 'pt': 'Equipe Prabit', 'tr': 'Prabit Takımı', 'ja': 'Prabitチーム', 'hi': 'प्रैबिट टीम', 'ar': 'فريق Prabit', 'bn': 'প্রাবিট টিম', },
    'tnbeenj0': { 'de': 'Prabit Team', 'en': 'Prabit Team', 'ko': 'Prabit 팀', 'it': 'Team Prabit', 'fr': 'Équipe Prabit', 'es': 'Equipo Prabit', 'ru': 'Команда Prabit', 'pt': 'Equipe Prabit', 'tr': 'Prabit Takımı', 'ja': 'Prabitチーム', 'hi': 'प्रैबिट टीम', 'ar': 'فريق Prabit', 'bn': 'প্রাবিট টিম', },
    'settingsLanguageSectionHeader': { 'de': 'SPRACHE', 'en': 'LANGUAGE', 'ko': '언어', 'it': 'LINGUA', 'fr': 'LANGUE', 'es': 'IDIOMA', 'ru': 'ЯЗЫК', 'pt': 'IDIOMA', 'tr': 'DİL', 'ja': '言語', 'hi': 'भाषा', 'ar': 'اللغة', 'bn': 'ভাষা', },
    'settingsLanguageRowLabel': { 'de': 'Sprache', 'en': 'Language', 'ko': '언어', 'it': 'Lingua', 'fr': 'Langue', 'es': 'Idioma', 'ru': 'Язык', 'pt': 'Idioma', 'tr': 'Dil', 'ja': '言語', 'hi': 'भाषा', 'ar': 'اللغة', 'bn': 'ভাষা', },
  }, // <-- Comma after the settings block
  // HabitSelectionScreen
  // HabitSelectionScreen
  {
    '43f5vne0': { 'de': 'Gewohnheiten', 'en': 'Habits', 'ko': '습관', 'it': 'Abitudini', 'fr': 'Habitudes', 'es': 'Hábitos', 'ru': 'Привычки', 'pt': 'Hábitos', 'tr': 'Alışkanlıklar', 'ja': '習慣', 'hi': 'आदतें', 'ar': 'العادات', 'bn': 'অভ্যাস', },
    'i3xr2cf1': { 'de': 'Deine Gewohnheiten', 'en': 'Your habits', 'ko': '내 습관', 'it': 'Le tue abitudini', 'fr': 'Tes habitudes', 'es': 'Tus hábitos', 'ru': 'Ваши привычки', 'pt': 'Seus hábitos', 'tr': 'Alışkanlıkların', 'ja': 'あなたの習慣', 'hi': 'आपकी आदतें', 'ar': 'عاداتك', 'bn': 'আপনার অভ্যাস', },
    '21878072': { 'de': 'Gruppengewohnheiten', 'en': 'Group habits', 'ko': '그룹 습관', 'it': 'Abitudini di gruppo', 'fr': 'Habitudes de groupe', 'es': 'Hábitos grupales', 'ru': 'Групповые привычки', 'pt': 'Hábitos de grupo', 'tr': 'Grup alışkanlıkları', 'ja': 'グループ習慣', 'hi': 'समूह आदतें', 'ar': 'عادات المجموعة', 'bn': 'গ্রুপের অভ্যাস', },
    'yz1r8wf2': { 'de': 'iui', 'en': 'iui', 'ko': 'iui', 'it': 'iui', 'fr': 'iui', 'es': 'iui', 'ru': 'iui', 'pt': 'iui', 'tr': 'iui', 'ja': 'iui', 'hi': 'आईयूआई', 'ar': 'iui', 'bn': 'আইইউআই', }, // Placeholder? Kept as is.
  }, // <-- Comma after the HabitSelectionScreen block
  // group (Main group screen)
  {
    'n29bio07': { 'de': 'Gruppen', 'en': 'Groups', 'ko': '그룹', 'it': 'Gruppi', 'fr': 'Groupes', 'es': 'Grupos', 'ru': 'Группы', 'pt': 'Grupos', 'tr': 'Gruplar', 'ja': 'グループ', 'hi': 'समूह', 'ar': 'المجموعات', 'bn': 'গ্রুপসমূহ', },
    '79hv9d87': { 'de': 'Meine Gruppen', 'en': 'My Groups', 'ko': '내 그룹', 'it': 'I miei gruppi', 'fr': 'Mes groupes', 'es': 'Mis grupos', 'ru': 'Мои группы', 'pt': 'Meus Grupos', 'tr': 'Gruplarım', 'ja': 'マイグループ', 'hi': 'मेरे समूह', 'ar': 'مجموعاتي', 'bn': 'আমার গ্রুপগুলি', },
    '82rc6hzr': { 'de': 'Gruppen entdecken', 'en': 'Discover Groups', 'ko': '그룹 탐색', 'it': 'Scopri gruppi', 'fr': 'Découvrir des groupes', 'es': 'Descubrir grupos', 'ru': 'Найти группы', 'pt': 'Descobrir Grupos', 'tr': 'Grupları Keşfet', 'ja': 'グループを発見', 'hi': 'समूह खोजें', 'ar': 'اكتشاف المجموعات', 'bn': 'গ্রুপ আবিষ্কার করুন', },
  },
  // group_chat
  {
    'wm2tbgzb': { 'de': 'MR', 'en': 'MR', 'ko': 'MR', 'it': 'MR', 'fr': 'MR', 'es': 'MR', 'ru': 'MR', 'pt': 'MR', 'tr': 'MR', 'ja': 'MR', 'hi': 'एमआर', 'ar': 'MR', 'bn': 'এমআর', },
    'eezpdxjc': { 'de': 'Morgenleser', 'en': 'Morning Readers', 'ko': '아침 독서단', 'it': 'Lettori mattutini', 'fr': 'Lecteurs du matin', 'es': 'Lectores matutinos', 'ru': 'Утренние читатели', 'pt': 'Leitores da Manhã', 'tr': 'Sabah Okuyucuları', 'ja': '朝の読書家', 'hi': 'सुबह के पाठक', 'ar': 'قراء الصباح', 'bn': 'সকালের পাঠক', },
    '35tjdagv': { 'de': '5 Mitglieder', 'en': '5 members', 'ko': '멤버 5명', 'it': '5 membri', 'fr': '5 membres', 'es': '5 miembros', 'ru': '5 участников', 'pt': '5 membros', 'tr': '5 üye', 'ja': 'メンバー5人', 'hi': '5 सदस्य', 'ar': '5 أعضاء', 'bn': '৫ জন সদস্য', },
    'pnkohbh6': { 'de': 'S', 'en': 'S', 'ko': 'S', 'it': 'S', 'fr': 'S', 'es': 'S', 'ru': 'С', 'pt': 'S', 'tr': 'S', 'ja': 'S', 'hi': 'एस', 'ar': 'س', 'bn': 'এস', },
    '693u8axr': { 'de': 'Sarah', 'en': 'Sarah', 'ko': 'Sarah', 'it': 'Sarah', 'fr': 'Sarah', 'es': 'Sarah', 'ru': 'Сара', 'pt': 'Sarah', 'tr': 'Sarah', 'ja': 'サラ', 'hi': 'सारा', 'ar': 'سارة', 'bn': 'সারা', },
    '4u0g83tz': { 'de': 'Heutiger Leseplatz. Perfektes Licht und Ambiente! 📖✨', 'en': 'Today\'s reading spot. Perfect lighting and ambiance! 📖✨', 'ko': '오늘의 독서 장소. 완벽한 조명과 분위기! 📖✨', 'it': 'Posto di lettura di oggi. Illuminazione e atmosfera perfette! 📖✨', 'fr': 'Le coin lecture d\'aujourd\'hui. Éclairage et ambiance parfaits ! 📖✨', 'es': 'El rincón de lectura de hoy. ¡Iluminación y ambiente perfectos! 📖✨', 'ru': 'Сегодняшнее место для чтения. Идеальное освещение и атмосфера! 📖✨', 'pt': 'Local de leitura de hoje. Iluminação e ambiente perfeitos! 📖✨', 'tr': 'Bugünkü okuma köşesi. Mükemmel aydınlatma ve ambiyans! 📖✨', 'ja': '今日の読書スポット。完璧な照明と雰囲気！📖✨', 'hi': 'आज का पढ़ने का स्थान। उत्तम प्रकाश और माहौल! 📖✨', 'ar': 'مكان القراءة اليوم. إضاءة وأجواء مثالية! 📖✨', 'bn': 'আজকের পড়ার জায়গা। নিখুঁত আলো এবং পরিবেশ! 📖✨', },
    'q7fnv0k4': { 'de': '20:05', 'en': '20:05', 'ko': '20:05', 'it': '20:05', 'fr': '20:05', 'es': '20:05', 'ru': '20:05', 'pt': '20:05', 'tr': '20:05', 'ja': '20:05', 'hi': '20:05', 'ar': '20:05', 'bn': '২০:০৫', },
    'pwignj4b': { 'de': 'S', 'en': 'S', 'ko': 'S', 'it': 'S', 'fr': 'S', 'es': 'S', 'ru': 'С', 'pt': 'S', 'tr': 'S', 'ja': 'S', 'hi': 'एस', 'ar': 'س', 'bn': 'এস', },
    'lnmjr5ir': { 'de': 'Sarah', 'en': 'Sarah', 'ko': 'Sarah', 'it': 'Sarah', 'fr': 'Sarah', 'es': 'Sarah', 'ru': 'Сара', 'pt': 'Sarah', 'tr': 'Sarah', 'ja': 'サラ', 'hi': 'सारा', 'ar': 'سارة', 'bn': 'সারা', },
    'mozial58': { 'de': 'Danke! Welches Buch liest du diese Woche?', 'en': 'Thanks! What book are you reading this week?', 'ko': '고마워요! 이번 주에는 어떤 책을 읽고 있나요?', 'it': 'Grazie! Che libro stai leggendo questa settimana?', 'fr': 'Merci ! Quel livre lisez-vous cette semaine ?', 'es': '¡Gracias! ¿Qué libro estás leyendo esta semana?', 'ru': 'Спасибо! Какую книгу читаешь на этой неделе?', 'pt': 'Obrigado! Qual livro você está lendo esta semana?', 'tr': 'Teşekkürler! Bu hafta hangi kitabı okuyorsun?', 'ja': 'ありがとう！今週はどの本を読んでいますか？', 'hi': 'धन्यवाद! इस सप्ताह आप कौन सी किताब पढ़ रहे हैं?', 'ar': 'شكراً! ما الكتاب الذي تقرأه هذا الأسبوع؟', 'bn': 'ধন্যবাদ! এই সপ্তাহে আপনি কোন বই পড়ছেন?', },
    'ydju482e': { 'de': '20:37', 'en': '20:37', 'ko': '20:37', 'it': '20:37', 'fr': '20:37', 'es': '20:37', 'ru': '20:37', 'pt': '20:37', 'tr': '20:37', 'ja': '20:37', 'hi': '20:37', 'ar': '20:37', 'bn': '২০:৩৭', },
    '8mkzzmc9': { 'de': 'Ich lese \'Atomic Habits\' von James Clear. Es ist wirklich aufschlussreich über den Aufbau guter Routinen!', 'en': 'I\'m reading \'Atomic Habits\' by James Clear. It\'s really insightful about building good routines!', 'ko': 'James Clear의 \'Atomic Habits\'를 읽고 있어요. 좋은 습관 형성에 대해 정말 통찰력 있어요!', 'it': 'Sto leggendo \'Atomic Habits\' di James Clear. È davvero illuminante sulla costruzione di buone routine!', 'fr': 'Je lis \'Atomic Habits\' de James Clear. C\'est vraiment instructif sur la création de bonnes habitudes !', 'es': 'Estoy leyendo \'Hábitos Atómicos\' de James Clear. ¡Es realmente revelador sobre cómo construir buenas rutinas!', 'ru': 'Я читаю «Атомные привычки» Джеймса Клира. Очень познавательно о построении хороших рутин!', 'pt': 'Estou lendo \'Hábitos Atômicos\' de James Clear. É muito esclarecedor sobre como construir boas rotinas!', 'tr': 'James Clear\'ın \'Atomik Alışkanlıklar\' kitabını okuyorum. İyi rutinler oluşturma konusunda gerçekten ufuk açıcı!', 'ja': 'ジェームズ・クリアの「アトミック・ハビッツ」を読んでいます。良い習慣を築くことについて、本当に洞察に満ちています！', 'hi': 'मैं जेम्स क्लियर की \'एटॉमिक हैबिट्स\' पढ़ रहा हूँ। यह अच्छी दिनचर्या बनाने के बारे में वास्तव में ज्ञानवर्धक है!', 'ar': 'أنا أقرأ "العادات الذرية" لجيمس كلير. إنه ثاقب حقًا حول بناء روتين جيد!', 'bn': 'আমি জেমস ক্লিয়ারের \'এটমিক হ্যাবিটস\' পড়ছি। ভাল রুটিন তৈরি করার বিষয়ে এটি সত্যিই অন্তর্দৃষ্টিপূর্ণ!', },
    '4arisy3o': { 'de': '20:40', 'en': '20:40', 'ko': '20:40', 'it': '20:40', 'fr': '20:40', 'es': '20:40', 'ru': '20:40', 'pt': '20:40', 'tr': '20:40', 'ja': '20:40', 'hi': '20:40', 'ar': '20:40', 'bn': '২০:৪০', },
    '8w3nbhcn': { 'de': 'Nachricht schreiben...', 'en': 'Type a message...', 'ko': '메시지 입력...', 'it': 'Scrivi un messaggio...', 'fr': 'Écrire un message...', 'es': 'Escribe un mensaje...', 'ru': 'Введите сообщение...', 'pt': 'Digite uma mensagem...', 'tr': 'Bir mesaj yazın...', 'ja': 'メッセージを入力...', 'hi': 'संदेश लिखें...', 'ar': 'اكتب رسالة...', 'bn': 'একটি বার্তা টাইপ করুন...', },
  },
  // group_details
  {
    'wvuzckm1': { 'de': 'Morgenleser', 'en': 'Morning Readers', 'ko': '아침 독서단', 'it': 'Lettori mattutini', 'fr': 'Lecteurs du matin', 'es': 'Lectores matutinos', 'ru': 'Утренние читатели', 'pt': 'Leitores da Manhã', 'tr': 'Sabah Okuyucuları', 'ja': '朝の読書家', 'hi': 'सुबह के पाठक', 'ar': 'قراء الصباح', 'bn': 'সকালের পাঠক', },
    'cpiyu9ck': { 'de': '3', 'en': '3', 'ko': '3', 'it': '3', 'fr': '3', 'es': '3', 'ru': '3', 'pt': '3', 'tr': '3', 'ja': '3', 'hi': '३', 'ar': '٣', 'bn': '৩', },
    'hsf8rpws': { 'de': 'Morgenleser', 'en': 'Morning Readers', 'ko': '아침 독서단', 'it': 'Lettori mattutini', 'fr': 'Lecteurs du matin', 'es': 'Lectores matutinos', 'ru': 'Утренние читатели', 'pt': 'Leitores da Manhã', 'tr': 'Sabah Okuyucuları', 'ja': '朝の読書家', 'hi': 'सुबह के पाठक', 'ar': 'قراء الصباح', 'bn': 'সকালের পাঠক', },
    'tejaimfo': { 'de': 'Privat', 'en': 'Private', 'ko': '비공개', 'it': 'Privato', 'fr': 'Privé', 'es': 'Privado', 'ru': 'Частная', 'pt': 'Privado', 'tr': 'Özel', 'ja': '非公開', 'hi': 'निजी', 'ar': 'خاص', 'bn': 'ব্যক্তিগত', },
    'oqcr0ty4': { 'de': '8 Mitglieder', 'en': '8 members', 'ko': '멤버 8명', 'it': '8 membri', 'fr': '8 membres', 'es': '8 miembros', 'ru': '8 участников', 'pt': '8 membros', 'tr': '8 üye', 'ja': 'メンバー8人', 'hi': '8 सदस्य', 'ar': '8 أعضاء', 'bn': '৮ জন সদস্য', },
    'yc32iao9': { 'de': 'Eine Gemeinschaft von Buchliebhabern, die sich verpflichten, jeden Morgen mindestens 10 Seiten zu lesen. Wir teilen unseren Fortschritt, diskutieren interessante Erkenntnisse und empfehlen uns gegenseitig tolle Bücher.', 'en': 'A community of book lovers who commit to reading at least 10 pages every morning. We share our progress, discuss interesting findings, and recommend great books to each other.', 'ko': '매일 아침 최소 10페이지 이상 독서를 약속하는 책 애호가 커뮤니티입니다. 우리는 진행 상황을 공유하고 흥미로운 발견을 논의하며 서로에게 좋은 책을 추천합니다.', 'it': 'Una comunità di amanti dei libri che si impegnano a leggere almeno 10 pagine ogni mattina. Condividiamo i nostri progressi, discutiamo scoperte interessanti e ci consigliamo ottimi libri a vicenda.', 'fr': 'Une communauté d\'amoureux des livres qui s\'engagent à lire au moins 10 pages chaque matin. Nous partageons nos progrès, discutons de découvertes intéressantes et nous recommandons de bons livres.', 'es': 'Una comunidad de amantes de los libros que se comprometen a leer al menos 10 páginas cada mañana. ¡Compartimos nuestro progreso, discutimos hallazgos interesantes y nos recomendamos grandes libros!', 'ru': 'Сообщество книголюбов, которые обязуются читать не менее 10 страниц каждое утро. Мы делимся нашими успехами, обсуждаем интересные находки и рекомендуем друг другу отличные книги.', 'pt': 'Uma comunidade de amantes de livros que se comprometem a ler pelo menos 10 páginas todas as manhãs. Compartilhamos nosso progresso, discutimos descobertas interessantes e recomendamos ótimos livros uns aos outros.', 'tr': 'Her sabah en az 10 sayfa okumayı taahhüt eden kitap severler topluluğu. İlerlememizi paylaşıyor, ilginç bulguları tartışıyor ve birbirimize harika kitaplar öneriyoruz.', 'ja': '毎朝最低10ページを読むことを約束する本好きのコミュニティ。進捗状況を共有し、興味深い発見について話し合い、お互いに素晴らしい本を推薦します。', 'hi': 'पुस्तक प्रेमियों का एक समुदाय जो हर सुबह कम से कम 10 पृष्ठ पढ़ने के लिए प्रतिबद्ध है। हम अपनी प्रगति साझा करते हैं, दिलचस्प निष्कर्षों पर चर्चा करते हैं, और एक-दूसरे को महान पुस्तकों की सलाह देते हैं।', 'ar': 'مجتمع من محبي الكتب الذين يلتزمون بقراءة 10 صفحات على الأقل كل صباح. نشارك تقدمنا ​​ونناقش النتائج المثيرة للاهتمام ونوصي بكتب رائعة لبعضنا البعض.', 'bn': 'বই প্রেমীদের একটি সম্প্রদায় যারা প্রতিদিন সকালে কমপক্ষে ১০ পৃষ্ঠা পড়ার প্রতিশ্রুতি দেয়। আমরা আমাদের অগ্রগতি শেয়ার করি, আকর্ষণীয় অনুসন্ধান নিয়ে আলোচনা করি এবং একে অপরকে দুর্দান্ত বইয়ের সুপারিশ করি।', },
    'dgqjrj38': { 'de': 'Freunde einladen', 'en': 'Invite Friends', 'ko': '친구 초대', 'it': 'Invita amici', 'fr': 'Inviter des amis', 'es': 'Invitar amigos', 'ru': 'Пригласить друзей', 'pt': 'Convidar Amigos', 'tr': 'Arkadaş Davet Et', 'ja': '友達を招待', 'hi': 'मित्रों को आमंत्रित करें', 'ar': 'دعوة الأصدقاء', 'bn': 'বন্ধুদের আমন্ত্রণ জানান', },
    'fl1sfkpo': { 'de': 'Gruppengewohnheit', 'en': 'Group Habit', 'ko': '그룹 습관', 'it': 'Abitudine di gruppo', 'fr': 'Habitude de groupe', 'es': 'Hábito grupal', 'ru': 'Групповая привычка', 'pt': 'Hábito de Grupo', 'tr': 'Grup Alışkanlığı', 'ja': 'グループ習慣', 'hi': 'समूह आदत', 'ar': 'عادة المجموعة', 'bn': 'গ্রুপের অভ্যাস', },
    'vu84y09j': { 'de': '10 Seiten lesen', 'en': 'Read 10 pages', 'ko': '10페이지 읽기', 'it': 'Leggi 10 pagine', 'fr': 'Lire 10 pages', 'es': 'Leer 10 páginas', 'ru': 'Читать 10 страниц', 'pt': 'Ler 10 páginas', 'tr': '10 sayfa oku', 'ja': '10ページ読む', 'hi': '10 पृष्ठ पढ़ें', 'ar': 'اقرأ 10 صفحات', 'bn': '১০ পৃষ্ঠা পড়ুন', },
    'xalm94la': { 'de': '08:00 (Optional)', 'en': '08:00 AM (Optional)', 'ko': '08:00 (선택 사항)', 'it': '08:00 (Opzionale)', 'fr': '08:00 (Facultatif)', 'es': '08:00 (Opcional)', 'ru': '08:00 (Необязательно)', 'pt': '08:00 (Opcional)', 'tr': '08:00 (İsteğe Bağlı)', 'ja': '08:00 (任意)', 'hi': '08:00 (वैकल्पिक)', 'ar': '08:00 (اختياري)', 'bn': '০৮:০০ (ঐচ্ছিক)', },
    'toq3ob3x': { 'de': 'Aktive Tage:', 'en': 'Active Days:', 'ko': '활성 요일:', 'it': 'Giorni attivi:', 'fr': 'Jours actifs :', 'es': 'Días activos:', 'ru': 'Активные дни:', 'pt': 'Dias Ativos:', 'tr': 'Aktif Günler:', 'ja': 'アクティブな曜日：', 'hi': 'सक्रिय दिन:', 'ar': 'الأيام النشطة:', 'bn': 'সক্রিয় দিন:', },
    'qfvdfzde': { 'de': 'M', 'en': 'M', 'ko': '월', 'it': 'L', 'fr': 'L', 'es': 'L', 'ru': 'Пн', 'pt': 'S', 'tr': 'Pzt', 'ja': '月', 'hi': 'सो', 'ar': 'ن', 'bn': 'সো', }, 'ah8lnltf': { 'de': 'D', 'en': 'T', 'ko': '화', 'it': 'M', 'fr': 'M', 'es': 'M', 'ru': 'Вт', 'pt': 'T', 'tr': 'Sa', 'ja': '火', 'hi': 'मं', 'ar': 'ث', 'bn': 'ম', }, 'l8k88s34': { 'de': 'M', 'en': 'W', 'ko': '수', 'it': 'M', 'fr': 'M', 'es': 'X', 'ru': 'Ср', 'pt': 'Q', 'tr': 'Ça', 'ja': '水', 'hi': 'बु', 'ar': 'ر', 'bn': 'বু', },
    'fg1humrf': { 'de': 'D', 'en': 'T', 'ko': '목', 'it': 'G', 'fr': 'J', 'es': 'J', 'ru': 'Чт', 'pt': 'Q', 'tr': 'Pe', 'ja': '木', 'hi': 'गु', 'ar': 'خ', 'bn': 'বৃ', }, 'nifrnfqv': { 'de': 'F', 'en': 'F', 'ko': '금', 'it': 'V', 'fr': 'V', 'es': 'V', 'ru': 'Пт', 'pt': 'S', 'tr': 'Cu', 'ja': '金', 'hi': 'शु', 'ar': 'ج', 'bn': 'শু', }, 'hlq27n6k': { 'de': 'S', 'en': 'S', 'ko': '토', 'it': 'S', 'fr': 'S', 'es': 'S', 'ru': 'Сб', 'pt': 'S', 'tr': 'Cmt', 'ja': '土', 'hi': 'श', 'ar': 'س', 'bn': 'শ', },
    'x1gncgq1': { 'de': 'S', 'en': 'S', 'ko': '일', 'it': 'D', 'fr': 'D', 'es': 'D', 'ru': 'Вс', 'pt': 'D', 'tr': 'P', 'ja': '日', 'hi': 'र', 'ar': 'ح', 'bn': 'র', },
    'o64m7mz2': { 'de': 'Mitglieder', 'en': 'Members', 'ko': '멤버', 'it': 'Membri', 'fr': 'Membres', 'es': 'Miembros', 'ru': 'Участники', 'pt': 'Membros', 'tr': 'Üyeler', 'ja': 'メンバー', 'hi': 'सदस्य', 'ar': 'الأعضاء', 'bn': 'সদস্যরা', },
    '04rakc52': { 'de': 'JaneR', 'en': 'JaneR', 'ko': 'JaneR', 'it': 'JaneR', 'fr': 'JaneR', 'es': 'JaneR', 'ru': 'JaneR', 'pt': 'JaneR', 'tr': 'JaneR', 'ja': 'JaneR', 'hi': 'जेनआर', 'ar': 'JaneR', 'bn': 'জেনআর', },
    'm5vcdwsm': { 'de': 'Leiter', 'en': 'Leader', 'ko': '리더', 'it': 'Leader', 'fr': 'Leader', 'es': 'Líder', 'ru': 'Лидер', 'pt': 'Líder', 'tr': 'Lider', 'ja': 'リーダー', 'hi': 'नेता', 'ar': 'القائد', 'bn': 'নেতা', },
    'r1wf1t98': { 'de': 'Mitglieder', 'en': 'Members', 'ko': '멤버', 'it': 'Membri', 'fr': 'Membres', 'es': 'Miembros', 'ru': 'Участники', 'pt': 'Membros', 'tr': 'Üyeler', 'ja': 'メンバー', 'hi': 'सदस्य', 'ar': 'الأعضاء', 'bn': 'সদস্যরা', },
    'spdijs05': { 'de': 'JaneR', 'en': 'JaneR', 'ko': 'JaneR', 'it': 'JaneR', 'fr': 'JaneR', 'es': 'JaneR', 'ru': 'JaneR', 'pt': 'JaneR', 'tr': 'JaneR', 'ja': 'JaneR', 'hi': 'जेनआर', 'ar': 'JaneR', 'bn': 'জেনআর', },
    'w0cymwe9': { 'de': 'Leiter', 'en': 'Leader', 'ko': '리더', 'it': 'Leader', 'fr': 'Leader', 'es': 'Líder', 'ru': 'Лидер', 'pt': 'Líder', 'tr': 'Lider', 'ja': 'リーダー', 'hi': 'नेता', 'ar': 'القائد', 'bn': 'নেতা', },
    'jgxeb401': { 'de': 'Gruppe verlassen', 'en': 'Leave Group', 'ko': '그룹 나가기', 'it': 'Lascia gruppo', 'fr': 'Quitter le groupe', 'es': 'Salir del grupo', 'ru': 'Покинуть группу', 'pt': 'Sair do Grupo', 'tr': 'Gruptan Ayrıl', 'ja': 'グループを脱退', 'hi': 'समूह छोड़ें', 'ar': 'مغادرة المجموعة', 'bn': 'গ্রুপ ত্যাগ করুন', },
  },
  // group_leaderboard
  {
    'wx4nh5m0': { 'de': 'Hallo Welt', 'en': 'Hello World', 'ko': '안녕하세요', 'it': 'Ciao mondo', 'fr': 'Bonjour le monde', 'es': 'Hola Mundo', 'ru': 'Привет, мир', 'pt': 'Olá Mundo', 'tr': 'Merhaba Dünya', 'ja': 'ハローワールド', 'hi': 'नमस्ते दुनिया', 'ar': 'مرحباً بالعالم', 'bn': 'হ্যালো ওয়ার্ল্ড', },
    '418pkdy3': { 'de': 'Sieh, wer in der Gruppe am beständigsten ist', 'en': 'See who\'s most consistent in the group', 'ko': '그룹에서 가장 꾸준한 멤버 확인하기', 'it': 'Guarda chi è più costante nel gruppo', 'fr': 'Voyez qui est le plus constant dans le groupe', 'es': 'Mira quién es más constante en el grupo', 'ru': 'Посмотрите, кто самый последовательный в группе', 'pt': 'Veja quem é mais consistente no grupo', 'tr': 'Grupta kimin en tutarlı olduğunu görün', 'ja': 'グループで最も一貫性のあるメンバーを確認', 'hi': 'देखें कि समूह में सबसे सुसंगत कौन है', 'ar': 'انظر من هو الأكثر ثباتًا في المجموعة', 'bn': 'গ্রুপে সবচেয়ে ধারাবাহিক কে দেখুন', },
    '6qhmk00o': { 'de': 'Diese Woche', 'en': 'This Week', 'ko': '이번 주', 'it': 'Questa settimana', 'fr': 'Cette semaine', 'es': 'Esta semana', 'ru': 'Эта неделя', 'pt': 'Esta Semana', 'tr': 'Bu Hafta', 'ja': '今週', 'hi': 'इस सप्ताह', 'ar': 'هذا الأسبوع', 'bn': 'এই সপ্তাহ', },
    'qede8qrj': { 'de': 'Dieser Monat', 'en': 'This Month', 'ko': '이번 달', 'it': 'Questo mese', 'fr': 'Ce mois-ci', 'es': 'Este mes', 'ru': 'Этот месяц', 'pt': 'Este Mês', 'tr': 'Bu Ay', 'ja': '今月', 'hi': 'इस महीने', 'ar': 'هذا الشهر', 'bn': 'এই মাস', },
    '68qmi3pw': { 'de': 'Gesamt', 'en': 'All Time', 'ko': '전체 기간', 'it': 'Sempre', 'fr': 'Tout temps', 'es': 'Todo el tiempo', 'ru': 'За все время', 'pt': 'Todo o Tempo', 'tr': 'Tüm Zamanlar', 'ja': '全期間', 'hi': 'सभी समय', 'ar': 'كل الأوقات', 'bn': 'সর্বকাল', },
    '2bv98tvs': { 'de': '1', 'en': '1', 'ko': '1', 'it': '1', 'fr': '1', 'es': '1', 'ru': '1', 'pt': '1', 'tr': '1', 'ja': '1', 'hi': '१', 'ar': '١', 'bn': '১', }, '75a54lgv': { 'de': 'Emma', 'en': 'Emma', 'ko': 'Emma', 'it': 'Emma', 'fr': 'Emma', 'es': 'Emma', 'ru': 'Эмма', 'pt': 'Emma', 'tr': 'Emma', 'ja': 'エマ', 'hi': 'एम्मा', 'ar': 'إيما', 'bn': 'এমা', },
    '9gtqodm4': { 'de': '9 Check-ins', 'en': '9 check-ins', 'ko': '9 체크인', 'it': '9 check-in', 'fr': '9 check-ins', 'es': '9 check-ins', 'ru': '9 отметок', 'pt': '9 check-ins', 'tr': '9 check-in', 'ja': '9 チェックイン', 'hi': '9 चेक-इन', 'ar': '9 تسجيلات حضور', 'bn': '৯টি চেক-ইন', }, 'wmb2mr3m': { 'de': '14-Tage-Serie', 'en': '14-day streak', 'ko': '14일 연속', 'it': 'Serie di 14 giorni', 'fr': 'Série de 14 jours', 'es': 'Racha de 14 días', 'ru': '14-дневная серия', 'pt': 'Sequência de 14 dias', 'tr': '14 günlük seri', 'ja': '14日間連続記録', 'hi': '14-दिन का सिलसिला', 'ar': 'سلسلة 14 يومًا', 'bn': '১৪ দিনের ধারাবাহিকতা', },
    '1ure0n8i': { 'de': '2', 'en': '2', 'ko': '2', 'it': '2', 'fr': '2', 'es': '2', 'ru': '2', 'pt': '2', 'tr': '2', 'ja': '2', 'hi': '२', 'ar': '٢', 'bn': '২', }, 'irl0lb8g': { 'de': 'Du', 'en': 'You', 'ko': '나', 'it': 'Tu', 'fr': 'Toi', 'es': 'Tú', 'ru': 'Вы', 'pt': 'Você', 'tr': 'Sen', 'ja': 'あなた', 'hi': 'आप', 'ar': 'أنت', 'bn': 'আপনি', },
    '8gagm5gz': { 'de': '8 Check-ins', 'en': '8 check-ins', 'ko': '8 체크인', 'it': '8 check-in', 'fr': '8 check-ins', 'es': '8 check-ins', 'ru': '8 отметок', 'pt': '8 check-ins', 'tr': '8 check-in', 'ja': '8 チェックイン', 'hi': '8 चेक-इन', 'ar': '8 تسجيلات حضور', 'bn': '৮টি চেক-ইন', }, 'o84yv25b': { 'de': '25-Tage-Serie', 'en': '25-day streak', 'ko': '25일 연속', 'it': 'Serie di 25 giorni', 'fr': 'Série de 25 jours', 'es': 'Racha de 25 días', 'ru': '25-дневная серия', 'pt': 'Sequência de 25 dias', 'tr': '25 günlük seri', 'ja': '25日間連続記録', 'hi': '25-दिन का सिलसिला', 'ar': 'سلسلة 25 يومًا', 'bn': '২৫ দিনের ধারাবাহিকতা', },
    't11bciph': { 'de': '3', 'en': '3', 'ko': '3', 'it': '3', 'fr': '3', 'es': '3', 'ru': '3', 'pt': '3', 'tr': '3', 'ja': '3', 'hi': '३', 'ar': '٣', 'bn': '৩', }, 'n2syk12a': { 'de': 'Jacob', 'en': 'Jacob', 'ko': 'Jacob', 'it': 'Jacob', 'fr': 'Jacob', 'es': 'Jacob', 'ru': 'Джейкоб', 'pt': 'Jacob', 'tr': 'Jacob', 'ja': 'ジェイコブ', 'hi': 'जैकब', 'ar': 'جاكوب', 'bn': 'জ্যাকব', },
    'm73qczlr': { 'de': '7 Check-ins', 'en': '7 check-ins', 'ko': '7 체크인', 'it': '7 check-in', 'fr': '7 check-ins', 'es': '7 check-ins', 'ru': '7 отметок', 'pt': '7 check-ins', 'tr': '7 check-in', 'ja': '7 チェックイン', 'hi': '7 चेक-इन', 'ar': '7 تسجيلات حضور', 'bn': '৭টি চেক-ইন', }, 'bf69ikfi': { 'de': '10-Tage-Serie', 'en': '10-day streak', 'ko': '10일 연속', 'it': 'Serie di 10 giorni', 'fr': 'Série de 10 jours', 'es': 'Racha de 10 días', 'ru': '10-дневная серия', 'pt': 'Sequência de 10 dias', 'tr': '10 günlük seri', 'ja': '10日間連続記録', 'hi': '10-दिन का सिलसिला', 'ar': 'سلسلة 10 أيام', 'bn': '১০ দিনের ধারাবাহিকতা', },
    '9us3r2pi': { 'de': '4', 'en': '4', 'ko': '4', 'it': '4', 'fr': '4', 'es': '4', 'ru': '4', 'pt': '4', 'tr': '4', 'ja': '4', 'hi': '४', 'ar': '٤', 'bn': '৪', }, 'sjmcl9hf': { 'de': 'Sarah', 'en': 'Sarah', 'ko': 'Sarah', 'it': 'Sarah', 'fr': 'Sarah', 'es': 'Sarah', 'ru': 'Сара', 'pt': 'Sarah', 'tr': 'Sarah', 'ja': 'サラ', 'hi': 'सारा', 'ar': 'سارة', 'bn': 'সারা', },
    'vknjaxsh': { 'de': '6 Check-ins', 'en': '6 check-ins', 'ko': '6 체크인', 'it': '6 check-in', 'fr': '6 check-ins', 'es': '6 check-ins', 'ru': '6 отметок', 'pt': '6 check-ins', 'tr': '6 check-in', 'ja': '6 チェックイン', 'hi': '6 चेक-इन', 'ar': '6 تسجيلات حضور', 'bn': '৬টি চেক-ইন', }, 'q13psil3': { 'de': '6-Tage-Serie', 'en': '6-day streak', 'ko': '6일 연속', 'it': 'Serie di 6 giorni', 'fr': 'Série de 6 jours', 'es': 'Racha de 6 días', 'ru': '6-дневная серия', 'pt': 'Sequência de 6 dias', 'tr': '6 günlük seri', 'ja': '6日間連続記録', 'hi': '6-दिन का सिलसिला', 'ar': 'سلسلة 6 أيام', 'bn': '৬ দিনের ধারাবাহিকতা', },
    'm7wi30s4': { 'de': '5', 'en': '5', 'ko': '5', 'it': '5', 'fr': '5', 'es': '5', 'ru': '5', 'pt': '5', 'tr': '5', 'ja': '5', 'hi': '५', 'ar': '٥', 'bn': '৫', }, 'y50becld': { 'de': 'Michael', 'en': 'Michael', 'ko': 'Michael', 'it': 'Michael', 'fr': 'Michael', 'es': 'Michael', 'ru': 'Майкл', 'pt': 'Michael', 'tr': 'Michael', 'ja': 'マイケル', 'hi': 'माइकल', 'ar': 'مايكل', 'bn': 'মাইকেল', },
    'bt4l2hla': { 'de': '5 Check-ins', 'en': '5 check-ins', 'ko': '5 체크인', 'it': '5 check-in', 'fr': '5 check-ins', 'es': '5 check-ins', 'ru': '5 отметок', 'pt': '5 check-ins', 'tr': '5 check-in', 'ja': '5 チェックイン', 'hi': '5 चेक-इन', 'ar': '5 تسجيلات حضور', 'bn': '৫টি চেক-ইন', }, 'xkp3bzmq': { 'de': '5-Tage-Serie', 'en': '5-day streak', 'ko': '5일 연속', 'it': 'Serie di 5 giorni', 'fr': 'Série de 5 jours', 'es': 'Racha de 5 días', 'ru': '5-дневная серия', 'pt': 'Sequência de 5 dias', 'tr': '5 günlük seri', 'ja': '5日間連続記録', 'hi': '5-दिन का सिलसिला', 'ar': 'سلسلة 5 أيام', 'bn': '৫ দিনের ধারাবাহিকতা', },
  },
  // confirmJoinGroup2 / popupGroupjoin (Consolidated)
  {
    'vw8c9bws': { 'de': 'Gruppe beitreten', 'en': 'Join Group', 'ko': '그룹 참여하기', 'it': 'Unisciti al gruppo', 'fr': 'Rejoindre le groupe', 'es': 'Unirse al grupo', 'ru': 'Присоединиться к группе', 'pt': 'Entrar no Grupo', 'tr': 'Gruba Katıl', 'ja': 'グループに参加', 'hi': 'समूह में शामिल हों', 'ar': 'الانضمام إلى المجموعة', 'bn': 'গ্রুপে যোগ দিন', },
    'gz60intn': { 'de': 'Gruppe beitreten', 'en': 'Join Group', 'ko': '그룹 참여하기', 'it': 'Unisciti al gruppo', 'fr': 'Rejoindre le groupe', 'es': 'Unirse al grupo', 'ru': 'Присоединиться к группе', 'pt': 'Entrar no Grupo', 'tr': 'Gruba Katıl', 'ja': 'グループに参加', 'hi': 'समूह में शामिल हों', 'ar': 'الانضمام إلى المجموعة', 'bn': 'গ্রুপে যোগ দিন', },
    'uhhrzsjb': { 'de': 'Tägliche Leser', 'en': 'Daily Readers', 'ko': '매일 독서단', 'it': 'Lettori giornalieri', 'fr': 'Lecteurs quotidiens', 'es': 'Lectores diarios', 'ru': 'Ежедневные читатели', 'pt': 'Leitores Diários', 'tr': 'Günlük Okuyucular', 'ja': '毎日の読書家', 'hi': 'दैनिक पाठक', 'ar': 'القراء اليوميون', 'bn': 'দৈনিক পাঠক', },
    'rbkk2g3e': { 'de': 'Tägliche Leser', 'en': 'Daily Readers', 'ko': '매일 독서단', 'it': 'Lettori giornalieri', 'fr': 'Lecteurs quotidiens', 'es': 'Lectores diarios', 'ru': 'Ежедневные читатели', 'pt': 'Leitores Diários', 'tr': 'Günlük Okuyucular', 'ja': '毎日の読書家', 'hi': 'दैनिक पाठक', 'ar': 'القراء اليوميون', 'bn': 'দৈনিক পাঠক', },
    'sn37v2ou': { 'de': 'Öffentlich', 'en': 'Public', 'ko': '공개', 'it': 'Pubblico', 'fr': 'Public', 'es': 'Público', 'ru': 'Общедоступная', 'pt': 'Público', 'tr': 'Herkese Açık', 'ja': '公開', 'hi': 'सार्वजनिक', 'ar': 'عام', 'bn': 'পাবলিক', },
    's1ar25ki': { 'de': 'Öffentlich', 'en': 'Public', 'ko': '공개', 'it': 'Pubblico', 'fr': 'Public', 'es': 'Público', 'ru': 'Общедоступная', 'pt': 'Público', 'tr': 'Herkese Açık', 'ja': '公開', 'hi': 'सार्वजनिक', 'ar': 'عام', 'bn': 'পাবলিক', },
    'ra2jdulp': { 'de': '86 Mitglieder', 'en': '86 members', 'ko': '멤버 86명', 'it': '86 membri', 'fr': '86 membres', 'es': '86 miembros', 'ru': '86 участников', 'pt': '86 membros', 'tr': '86 üye', 'ja': 'メンバー86人', 'hi': '86 सदस्य', 'ar': '86 عضوًا', 'bn': '৮৬ জন সদস্য', },
    'd4gj93om': { 'de': '86 Mitglieder', 'en': '86 members', 'ko': '멤버 86명', 'it': '86 membri', 'fr': '86 membres', 'es': '86 miembros', 'ru': '86 участников', 'pt': '86 membros', 'tr': '86 üye', 'ja': 'メンバー86人', 'hi': '86 सदस्य', 'ar': '86 عضوًا', 'bn': '৮৬ জন সদস্য', },
    '9mw1amvz': { 'de': 'Über diese Gruppe', 'en': 'About this group', 'ko': '그룹 소개', 'it': 'Informazioni su questo gruppo', 'fr': 'À propos de ce groupe', 'es': 'Sobre este grupo', 'ru': 'Об этой группе', 'pt': 'Sobre este grupo', 'tr': 'Bu grup hakkında', 'ja': 'このグループについて', 'hi': 'इस समूह के बारे में', 'ar': 'حول هذه المجموعة', 'bn': 'এই গ্রুপ সম্পর্কে', },
    'b7t1c144': { 'de': 'Über diese Gruppe', 'en': 'About this group', 'ko': '그룹 소개', 'it': 'Informazioni su questo gruppo', 'fr': 'À propos de ce groupe', 'es': 'Sobre este grupo', 'ru': 'Об этой группе', 'pt': 'Sobre este grupo', 'tr': 'Bu grup hakkında', 'ja': 'このグループについて', 'hi': 'इस समूह के बारे में', 'ar': 'حول هذه المجموعة', 'bn': 'এই গ্রুপ সম্পর্কে', },
    'sjaxohpt': { 'de': 'Schließe dich uns an, wenn wir jeden Tag mindestens 10 Seiten lesen. Teile Buchempfehlungen und diskutiere deine neuesten Lektüren mit der Community!', 'en': 'Join us as we read at least 10 pages every day. Share book recommendations and discuss your latest reads with the community!', 'ko': '매일 최소 10페이지 이상 독서하는 저희와 함께하세요. 책 추천을 공유하고 최신 독서에 대해 커뮤니티와 토론하세요!', 'it': 'Unisciti a noi mentre leggiamo almeno 10 pagine ogni giorno. Condividi consigli sui libri e discuti le tue ultime letture con la community!', 'fr': 'Rejoignez-nous pour lire au moins 10 pages chaque jour. Partagez des recommandations de livres et discutez de vos dernières lectures avec la communauté !', 'es': '¡Únete a nosotros mientras leemos al menos 10 páginas cada día. ¡Comparte recomendaciones de libros y discute tus últimas lecturas con la comunidad!', 'ru': 'Присоединяйтесь к нам: мы читаем не менее 10 страниц каждый день. Делитесь рекомендациями книг и обсуждайте последние прочитанные книги с сообществом!', 'pt': 'Junte-se a nós enquanto lemos pelo menos 10 páginas todos os dias. Compartilhe recomendações de livros e discuta suas últimas leituras com a comunidade!', 'tr': 'Her gün en az 10 sayfa okurken bize katılın. Kitap önerilerini paylaşın ve en son okuduklarınızı toplulukla tartışın!', 'ja': '毎日最低10ページを読む私たちに参加しましょう。本の推薦を共有し、最新の読書についてコミュニティと話し合いましょう！', 'hi': 'रोज़ कम से कम 10 पृष्ठ पढ़ने के लिए हमसे जुड़ें। पुस्तक अनुशंसाएँ साझा करें और समुदाय के साथ अपनी नवीनतम पठन पर चर्चा करें!', 'ar': 'انضم إلينا ونحن نقرأ 10 صفحات على الأقل كل يوم. شارك توصيات الكتب وناقش أحدث قراءاتك مع المجتمع!', 'bn': 'প্রতিদিন কমপক্ষে ১০ পৃষ্ঠা পড়ার জন্য আমাদের সাথে যোগ দিন। বইয়ের সুপারিশ শেয়ার করুন এবং সম্প্রদায়ের সাথে আপনার সর্বশেষ পড়া নিয়ে আলোচনা করুন!', },
    'nljzur53': { 'de': 'Schließe dich uns an, wenn wir jeden Tag mindestens 10 Seiten lesen. Teile Buchempfehlungen und diskutiere deine neuesten Lektüren mit der Community!', 'en': 'Join us as we read at least 10 pages every day. Share book recommendations and discuss your latest reads with the community!', 'ko': '매일 최소 10페이지 이상 독서하는 저희와 함께하세요. 책 추천을 공유하고 최신 독서에 대해 커뮤니티와 토론하세요!', 'it': 'Unisciti a noi mentre leggiamo almeno 10 pagine ogni giorno. Condividi consigli sui libri e discuti le tue ultime letture con la community!', 'fr': 'Rejoignez-nous pour lire au moins 10 pages chaque jour. Partagez des recommandations de livres et discutez de vos dernières lectures avec la communauté !', 'es': '¡Únete a nosotros mientras leemos al menos 10 páginas cada día. ¡Comparte recomendaciones de libros y discute tus últimas lecturas con la comunidad!', 'ru': 'Присоединяйтесь к нам: мы читаем не менее 10 страниц каждый день. Делитесь рекомендациями книг и обсуждайте последние прочитанные книги с сообществом!', 'pt': 'Junte-se a nós enquanto lemos pelo menos 10 páginas todos os dias. Compartilhe recomendações de livros e discuta suas últimas leituras com a comunidade!', 'tr': 'Her gün en az 10 sayfa okurken bize katılın. Kitap önerilerini paylaşın ve en son okuduklarınızı toplulukla tartışın!', 'ja': '毎日最低10ページを読む私たちに参加しましょう。本の推薦を共有し、最新の読書についてコミュニティと話し合いましょう！', 'hi': 'रोज़ कम से कम 10 पृष्ठ पढ़ने के लिए हमसे जुड़ें। पुस्तक अनुशंसाएँ साझा करें और समुदाय के साथ अपनी नवीनतम पठन पर चर्चा करें!', 'ar': 'انضم إلينا ونحن نقرأ 10 صفحات على الأقل كل يوم. شارك توصيات الكتب وناقش أحدث قراءاتك مع المجتمع!', 'bn': 'প্রতিদিন কমপক্ষে ১০ পৃষ্ঠা পড়ার জন্য আমাদের সাথে যোগ দিন। বইয়ের সুপারিশ শেয়ার করুন এবং সম্প্রদায়ের সাথে আপনার সর্বশেষ পড়া নিয়ে আলোচনা করুন!', },
    'ycoy68w3': { 'de': 'Gruppengewohnheit', 'en': 'Group Habit', 'ko': '그룹 습관', 'it': 'Abitudine di gruppo', 'fr': 'Habitude de groupe', 'es': 'Hábito grupal', 'ru': 'Групповая привычка', 'pt': 'Hábito de Grupo', 'tr': 'Grup Alışkanlığı', 'ja': 'グループ習慣', 'hi': 'समूह आदत', 'ar': 'عادة المجموعة', 'bn': 'গ্রুপের অভ্যাস', },
    '0exudm0g': { 'de': 'Gruppengewohnheit', 'en': 'Group Habit', 'ko': '그룹 습관', 'it': 'Abitudine di gruppo', 'fr': 'Habitude de groupe', 'es': 'Hábito grupal', 'ru': 'Групповая привычка', 'pt': 'Hábito de Grupo', 'tr': 'Grup Alışkanlığı', 'ja': 'グループ習慣', 'hi': 'समूह आदत', 'ar': 'عادة المجموعة', 'bn': 'গ্রুপের অভ্যাস', },
    'rccof86l': { 'de': '10 Seiten lesen', 'en': 'Read 10 pages', 'ko': '10페이지 읽기', 'it': 'Leggi 10 pagine', 'fr': 'Lire 10 pages', 'es': 'Leer 10 páginas', 'ru': 'Читать 10 страниц', 'pt': 'Ler 10 páginas', 'tr': '10 sayfa oku', 'ja': '10ページ読む', 'hi': '10 पृष्ठ पढ़ें', 'ar': 'اقرأ 10 صفحات', 'bn': '১০ পৃষ্ঠা পড়ুন', },
    '8f3g17im': { 'de': '10 Seiten lesen', 'en': 'Read 10 pages', 'ko': '10페이지 읽기', 'it': 'Leggi 10 pagine', 'fr': 'Lire 10 pages', 'es': 'Leer 10 páginas', 'ru': 'Читать 10 страниц', 'pt': 'Ler 10 páginas', 'tr': '10 sayfa oku', 'ja': '10ページ読む', 'hi': '10 पृष्ठ पढ़ें', 'ar': 'اقرأ 10 صفحات', 'bn': '১০ পৃষ্ঠা পড়ুন', },
    'vmkuohk4': { 'de': 'Abbrechen', 'en': 'Cancel', 'ko': '취소', 'it': 'Annulla', 'fr': 'Annuler', 'es': 'Cancelar', 'ru': 'Отмена', 'pt': 'Cancelar', 'tr': 'İptal', 'ja': 'キャンセル', 'hi': 'रद्द करें', 'ar': 'إلغاء', 'bn': 'বাতিল করুন', },
    'h7nsbp0w': { 'de': 'Gruppe beitreten', 'en': 'Join Group', 'ko': '그룹 참여하기', 'it': 'Unisciti al gruppo', 'fr': 'Rejoindre le groupe', 'es': 'Unirse al grupo', 'ru': 'Присоединиться к группе', 'pt': 'Entrar no Grupo', 'tr': 'Gruba Katıl', 'ja': 'グループに参加', 'hi': 'समूह में शामिल हों', 'ar': 'الانضمام إلى المجموعة', 'bn': 'গ্রুপে যোগ দিন', },
  },
  // post_Screen
  {
    'qehx0rpp': { 'de': 'Tagebuch schreiben', 'en': 'Journaling', 'ko': '일기 쓰기', 'it': 'Diario', 'fr': 'Journalisation', 'es': 'Diario', 'ru': 'Ведение дневника', 'pt': 'Diário', 'tr': 'Günlük Tutma', 'ja': 'ジャーナリング', 'hi': 'जर्नलिंग', 'ar': 'تدوين اليوميات', 'bn': 'জার্নালিং', },
    'fh2g1xe2': { 'de': 'Wiederholen', 'en': 'Retake', 'ko': '다시 찍기', 'it': 'Rifai', 'fr': 'Reprendre', 'es': 'Retomar', 'ru': 'Переснять', 'pt': 'Tirar Novamente', 'tr': 'Tekrar Çek', 'ja': '再試行', 'hi': 'फिर से लें', 'ar': 'إعادة التقاط', 'bn': 'পুনরায় নিন', },
    'wa9zp2n7': { 'de': 'Füge deinem Check-in eine Bildunterschrift hinzu...', 'en': 'Add a caption to your check-in...', 'ko': '체크인에 캡션 추가...', 'it': 'Aggiungi una didascalia al tuo check-in...', 'fr': 'Ajoutez une légende à votre check-in...', 'es': 'Añade un pie de foto a tu check-in...', 'ru': 'Добавьте подпись к вашей отметке...', 'pt': 'Adicione uma legenda ao seu check-in...', 'tr': 'Check-in\'inize bir başlık ekleyin...', 'ja': 'チェックインにキャプションを追加...', 'hi': 'अपने चेक-इन में एक कैप्शन जोड़ें...', 'ar': 'أضف تعليقًا إلى تسجيل حضورك...', 'bn': 'আপনার চেক-ইন এ একটি ক্যাপশন যোগ করুন...', },
    'g8d8klvf': { 'de': 'Privater Post', 'en': 'Private Post', 'ko': '비공개 게시물', 'it': 'Post privato', 'fr': 'Publication privée', 'es': 'Publicación privada', 'ru': 'Частная запись', 'pt': 'Post Privado', 'tr': 'Özel Gönderi', 'ja': 'プライベート投稿', 'hi': 'निजी पोस्ट', 'ar': 'منشور خاص', 'bn': 'ব্যক্তিগত পোস্ট', },
    'vo27c668': { 'de': 'Check-In posten', 'en': 'Post Check-In', 'ko': '체크인 게시', 'it': 'Pubblica check-in', 'fr': 'Publier le check-in', 'es': 'Publicar check-in', 'ru': 'Опубликовать отметку', 'pt': 'Publicar Check-In', 'tr': 'Check-in\'i Gönder', 'ja': 'チェックインを投稿', 'hi': 'चेक-इन पोस्ट करें', 'ar': 'نشر تسجيل الحضور', 'bn': 'চেক-ইন পোস্ট করুন', },
  }, // <-- Comma after the post_Screen block
  // login_screen
  {
    'jcl84ku8': { 'de': 'Willkommen zurück', 'en': 'Welcome back', 'ko': '다시 오신 것을 환영합니다', 'it': 'Bentornato', 'fr': 'Content de vous revoir', 'es': 'Bienvenido de nuevo', 'ru': 'С возвращением', 'pt': 'Bem-vindo de volta', 'tr': 'Tekrar hoş geldin', 'ja': 'おかえりなさい', 'hi': 'वापसी पर स्वागत है', 'ar': 'مرحبًا بعودتك', 'bn': 'আবার স্বাগতম', },
    'ex2fuw84': { 'de': 'Melde dich bei deinem Konto an, um fortzufahren', 'en': 'Sign in to your account to continue', 'ko': '계속하려면 계정에 로그인하세요', 'it': 'Accedi al tuo account per continuare', 'fr': 'Connectez-vous à votre compte pour continuer', 'es': 'Inicia sesión en tu cuenta para continuar', 'ru': 'Войдите в свою учетную запись, чтобы продолжить', 'pt': 'Faça login em sua conta para continuar', 'tr': 'Devam etmek için hesabınıza giriş yapın', 'ja': '続けるにはアカウントにサインインしてください', 'hi': 'जारी रखने के लिए अपने खाते में साइन इन करें', 'ar': 'سجل الدخول إلى حسابك للمتابعة', 'bn': 'চালিয়ে যেতে আপনার অ্যাকাউন্টে সাইন ইন করুন', },
    'xmqn5ye0': { 'de': 'E-Mail', 'en': 'Email', 'ko': '이메일', 'it': 'Email', 'fr': 'Email', 'es': 'Correo electrónico', 'ru': 'Эл. почта', 'pt': 'Email', 'tr': 'E-posta', 'ja': 'メールアドレス', 'hi': 'ईमेल', 'ar': 'البريد الإلكتروني', 'bn': 'ইমেইল', },
    '8wxfq36k': { 'de': 'du@beispiel.com', 'en': 'you@example.com', 'ko': 'you@example.com', 'it': 'tu@esempio.com', 'fr': 'vous@exemple.com', 'es': 'tu@ejemplo.com', 'ru': 'vy@primer.com', 'pt': 'voce@exemplo.com', 'tr': 'siz@ornek.com', 'ja': 'you@example.com', 'hi': 'आप@उदाहरण.कॉम', 'ar': 'you@example.com', 'bn': 'you@example.com', },
    'baaxg0pn': { 'de': 'Passwort', 'en': 'Password', 'ko': '비밀번호', 'it': 'Password', 'fr': 'Mot de passe', 'es': 'Contraseña', 'ru': 'Пароль', 'pt': 'Senha', 'tr': 'Şifre', 'ja': 'パスワード', 'hi': 'पासवर्ड', 'ar': 'كلمة المرور', 'bn': 'পাসওয়ার্ড', },
    'a1p0dqwr': { 'de': 'Passwort vergessen?', 'en': 'Forgot password?', 'ko': '비밀번호를 잊으셨나요?', 'it': 'Password dimenticata?', 'fr': 'Mot de passe oublié ?', 'es': '¿Olvidaste tu contraseña?', 'ru': 'Забыли пароль?', 'pt': 'Esqueceu a senha?', 'tr': 'Şifremi unuttum?', 'ja': 'パスワードをお忘れですか？', 'hi': 'पासवर्ड भूल गए?', 'ar': 'هل نسيت كلمة المرور؟', 'bn': 'পাসওয়ার্ড ভুলে গেছেন?', },
    '5ugn2egv': { 'de': 'Anmelden', 'en': 'Sign in', 'ko': '로그인', 'it': 'Accedi', 'fr': 'Se connecter', 'es': 'Iniciar sesión', 'ru': 'Войти', 'pt': 'Entrar', 'tr': 'Giriş Yap', 'ja': 'サインイン', 'hi': 'साइन इन करें', 'ar': 'تسجيل الدخول', 'bn': 'সাইন ইন করুন', },
    'n4xb5q4m': { 'de': 'ODER', 'en': 'OR', 'ko': '또는', 'it': 'O', 'fr': 'OU', 'es': 'O', 'ru': 'ИЛИ', 'pt': 'OU', 'tr': 'VEYA', 'ja': 'または', 'hi': 'या', 'ar': 'أو', 'bn': 'অথবা', },
    'apzszk8t': { 'de': 'Mit Google anmelden', 'en': 'Sign in with Google', 'ko': 'Google 계정으로 로그인', 'it': 'Accedi con Google', 'fr': 'Se connecter avec Google', 'es': 'Iniciar sesión con Google', 'ru': 'Войти через Google', 'pt': 'Entrar com o Google', 'tr': 'Google ile Giriş Yap', 'ja': 'Googleでサインイン', 'hi': 'Google से साइन इन करें', 'ar': 'تسجيل الدخول باستخدام جوجل', 'bn': 'Google দিয়ে সাইন ইন করুন', },
    '8nol2hvf': { 'de': 'Du hast noch kein Konto? ', 'en': 'Don\'t have an account? ', 'ko': '계정이 없으신가요? ', 'it': 'Non hai un account? ', 'fr': 'Vous n\'avez pas de compte ? ', 'es': '¿No tienes una cuenta? ', 'ru': 'Нет аккаунта? ', 'pt': 'Não tem uma conta? ', 'tr': 'Hesabınız yok mu? ', 'ja': 'アカウントをお持ちではありませんか？ ', 'hi': 'खाता नहीं है? ', 'ar': 'ليس لديك حساب؟ ', 'bn': 'অ্যাকাউন্ট নেই? ', },
    'qid7i1mm': { 'de': 'Konto erstellen', 'en': 'Create an account', 'ko': '계정 만들기', 'it': 'Crea un account', 'fr': 'Créer un compte', 'es': 'Crear una cuenta', 'ru': 'Создать аккаунт', 'pt': 'Criar uma conta', 'tr': 'Hesap Oluştur', 'ja': 'アカウントを作成', 'hi': 'खाता बनाएं', 'ar': 'إنشاء حساب', 'bn': 'অ্যাকাউন্ট তৈরি করুন', },
  }, // <-- Comma after the login_screen block
  // forgotPassword_screen
  {
    'i13rkjnz': { 'de': 'Passwort zurücksetzen', 'en': 'Reset your password', 'ko': '비밀번호 재설정', 'it': 'Reimposta la tua password', 'fr': 'Réinitialiser votre mot de passe', 'es': 'Restablecer tu contraseña', 'ru': 'Сбросить пароль', 'pt': 'Redefinir sua senha', 'tr': 'Şifrenizi sıfırlayın', 'ja': 'パスワードをリセット', 'hi': 'अपना पासवर्ड रीसेट करें', 'ar': 'إعادة تعيين كلمة المرور الخاصة بك', 'bn': 'আপনার পাসওয়ার্ড রিসেট করুন', },
    'malrqoft': { 'de': 'Gib deine E-Mail-Adresse ein und wir senden dir einen Link zum Zurücksetzen', 'en': 'Enter your email address and we\'ll send you a reset link', 'ko': '이메일 주소를 입력하시면 재설정 링크를 보내드립니다', 'it': 'Inserisci il tuo indirizzo email e ti invieremo un link di reimpostazione', 'fr': 'Entrez votre adresse e-mail et nous vous enverrons un lien de réinitialisation', 'es': 'Introduce tu dirección de correo electrónico y te enviaremos un enlace de restablecimiento', 'ru': 'Введите свой адрес электронной почты, и мы отправим вам ссылку для сброса', 'pt': 'Digite seu endereço de e-mail e enviaremos um link de redefinição', 'tr': 'E-posta adresinizi girin, size bir sıfırlama bağlantısı gönderelim', 'ja': 'メールアドレスを入力してください。リセットリンクをお送りします', 'hi': 'अपना ईमेल पता दर्ज करें और हम आपको एक रीसेट लिंक भेजेंगे', 'ar': 'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين', 'bn': 'আপনার ইমেল ঠিকানা লিখুন এবং আমরা আপনাকে একটি রিসেট লিঙ্ক পাঠাব', },
    'ruvb2hvi': { 'de': 'E-Mail', 'en': 'Email', 'ko': '이메일', 'it': 'Email', 'fr': 'Email', 'es': 'Correo electrónico', 'ru': 'Эл. почта', 'pt': 'Email', 'tr': 'E-posta', 'ja': 'メールアドレス', 'hi': 'ईमेल', 'ar': 'البريد الإلكتروني', 'bn': 'ইমেইল', },
    'ctzysw0x': { 'de': 'du@beispiel.com', 'en': 'you@example.com', 'ko': 'you@example.com', 'it': 'tu@esempio.com', 'fr': 'vous@exemple.com', 'es': 'tu@ejemplo.com', 'ru': 'vy@primer.com', 'pt': 'voce@exemplo.com', 'tr': 'siz@ornek.com', 'ja': 'you@example.com', 'hi': 'आप@उदाहरण.कॉम', 'ar': 'you@example.com', 'bn': 'you@example.com', },
    'm6e37oti': { 'de': 'Gib die mit deinem Konto verknüpfte E-Mail-Adresse ein.', 'en': 'Enter the email address associated with your account.', 'ko': '계정에 연결된 이메일 주소를 입력하세요.', 'it': 'Inserisci l\'indirizzo email associato al tuo account.', 'fr': 'Entrez l\'adresse e-mail associée à votre compte.', 'es': 'Introduce la dirección de correo electrónico asociada a tu cuenta.', 'ru': 'Введите адрес электронной почты, связанный с вашей учетной записью.', 'pt': 'Digite o endereço de e-mail associado à sua conta.', 'tr': 'Hesabınızla ilişkili e-posta adresini girin.', 'ja': 'アカウントに関連付けられているメールアドレスを入力してください。', 'hi': 'अपने खाते से संबद्ध ईमेल पता दर्ज करें।', 'ar': 'أدخل عنوان البريد الإلكتروني المرتبط بحسابك.', 'bn': 'আপনার অ্যাকাউন্টের সাথে যুক্ত ইমেল ঠিকানা লিখুন।', },
    'ldx3dvqv': { 'de': 'Link senden', 'en': 'Send reset link', 'ko': '재설정 링크 보내기', 'it': 'Invia link di reimpostazione', 'fr': 'Envoyer le lien de réinitialisation', 'es': 'Enviar enlace de restablecimiento', 'ru': 'Отправить ссылку для сброса', 'pt': 'Enviar link de redefinição', 'tr': 'Sıfırlama bağlantısı gönder', 'ja': 'リセットリンクを送信', 'hi': 'रीसेट लिंक भेजें', 'ar': 'إرسال رابط إعادة التعيين', 'bn': 'রিসেট লিঙ্ক পাঠান', },
    'q76rfh9r': { 'de': 'Zurück zum Login', 'en': 'Back to login', 'ko': '로그인으로 돌아가기', 'it': 'Torna al login', 'fr': 'Retour à la connexion', 'es': 'Volver al inicio de sesión', 'ru': 'Назад ко входу', 'pt': 'Voltar ao login', 'tr': 'Girişe geri dön', 'ja': 'ログインに戻る', 'hi': 'लॉगिन पर वापस जाएं', 'ar': 'العودة إلى تسجيل الدخول', 'bn': 'লগইনে ফিরে যান', },
  }, // <-- Comma after the forgotPassword_screen block
  // signup_screen
  {
    '0gosyzd4': { 'de': 'Konto erstellen', 'en': 'Create an account', 'ko': '계정 만들기', 'it': 'Crea un account', 'fr': 'Créer un compte', 'es': 'Crear una cuenta', 'ru': 'Создать аккаунт', 'pt': 'Criar uma conta', 'tr': 'Hesap Oluştur', 'ja': 'アカウントを作成', 'hi': 'खाता बनाएं', 'ar': 'إنشاء حساب', 'bn': 'অ্যাকাউন্ট তৈরি করুন', },
    'ks8yv9hy': { 'de': 'Gib deine Daten ein, um dein Konto zu erstellen', 'en': 'Enter your details to create your account', 'ko': '정보를 입력하여 계정을 만드세요', 'it': 'Inserisci i tuoi dati per creare il tuo account', 'fr': 'Entrez vos informations pour créer votre compte', 'es': 'Introduce tus datos para crear tu cuenta', 'ru': 'Введите свои данные для создания аккаунта', 'pt': 'Digite seus dados para criar sua conta', 'tr': 'Hesabınızı oluşturmak için bilgilerinizi girin', 'ja': 'アカウントを作成するために詳細を入力してください', 'hi': 'अपना खाता बनाने के लिए अपना विवरण दर्ज करें', 'ar': 'أدخل بياناتك لإنشاء حسابك', 'bn': 'আপনার অ্যাকাউন্ট তৈরি করতে আপনার বিবরণ লিখুন', },
    'ojp7acfq': { 'de': 'E-Mail', 'en': 'Email', 'ko': '이메일', 'it': 'Email', 'fr': 'Email', 'es': 'Correo electrónico', 'ru': 'Эл. почта', 'pt': 'Email', 'tr': 'E-posta', 'ja': 'メールアドレス', 'hi': 'ईमेल', 'ar': 'البريد الإلكتروني', 'bn': 'ইমেইল', },
    'wsj30c4x': { 'de': 'du@beispiel.com', 'en': 'you@example.com', 'ko': 'you@example.com', 'it': 'tu@esempio.com', 'fr': 'vous@exemple.com', 'es': 'tu@ejemplo.com', 'ru': 'vy@primer.com', 'pt': 'voce@exemplo.com', 'tr': 'siz@ornek.com', 'ja': 'you@example.com', 'hi': 'आप@उदाहरण.कॉम', 'ar': 'you@example.com', 'bn': 'you@example.com', },
    'vbjj43ng': { 'de': 'Passwort', 'en': 'Password', 'ko': '비밀번호', 'it': 'Password', 'fr': 'Mot de passe', 'es': 'Contraseña', 'ru': 'Пароль', 'pt': 'Senha', 'tr': 'Şifre', 'ja': 'パスワード', 'hi': 'पासवर्ड', 'ar': 'كلمة المرور', 'bn': 'পাসওয়ার্ড', },
    'i1q7x8uh': { 'de': 'Benutzername', 'en': 'Username', 'ko': '사용자 이름', 'it': 'Nome utente', 'fr': 'Nom d\'utilisateur', 'es': 'Nombre de usuario', 'ru': 'Имя пользователя', 'pt': 'Nome de usuário', 'tr': 'Kullanıcı adı', 'ja': 'ユーザー名', 'hi': 'उपयोगकर्ता नाम', 'ar': 'اسم المستخدم', 'bn': 'ব্যবহারকারীর নাম', },
    'jvdw5o21': { 'de': 'Geburtstag', 'en': 'Birthday', 'ko': '생년월일', 'it': 'Compleanno', 'fr': 'Anniversaire', 'es': 'Cumpleaños', 'ru': 'День рождения', 'pt': 'Aniversário', 'tr': 'Doğum günü', 'ja': '誕生日', 'hi': 'जन्मदिन', 'ar': 'تاريخ الميلاد', 'bn': 'জন্মদিন', },
    'domcoetw': { 'de': 'JJJJ', 'en': 'YYYY', 'ko': 'YYYY', 'it': 'AAAA', 'fr': 'AAAA', 'es': 'AAAA', 'ru': 'ГГГГ', 'pt': 'AAAA', 'tr': 'YYYY', 'ja': 'YYYY', 'hi': 'YYYY', 'ar': 'YYYY', 'bn': 'YYYY', },
    '6h79a6k1': { 'de': 'Du musst mindestens 13 Jahre alt sein, um diesen Dienst zu nutzen.', 'en': 'You must be at least 13 years old to use this service.', 'ko': '이 서비스를 이용하려면 만 13세 이상이어야 합니다.', 'it': 'Devi avere almeno 13 anni per utilizzare questo servizio.', 'fr': 'Vous devez avoir au moins 13 ans pour utiliser ce service.', 'es': 'Debes tener al menos 13 años para usar este servicio.', 'ru': 'Вам должно быть не менее 13 лет, чтобы использовать этот сервис.', 'pt': 'Você deve ter pelo menos 13 anos para usar este serviço.', 'tr': 'Bu hizmeti kullanmak için en az 13 yaşında olmalısınız.', 'ja': 'このサービスを利用するには、13歳以上である必要があります。', 'hi': 'इस सेवा का उपयोग करने के लिए आपकी आयु कम से कम 13 वर्ष होनी चाहिए।', 'ar': 'يجب أن يكون عمرك 13 عامًا على الأقل لاستخدام هذه الخدمة.', 'bn': 'এই পরিষেবা ব্যবহার করার জন্য আপনার বয়স কমপক্ষে ১৩ বছর হতে হবে।', },
    'vjqzemw9': { 'de': 'Ich stimme den Nutzungsbedingungen und der Datenschutzrichtlinie zu', 'en': 'I agree to the terms of service and privacy policy', 'ko': '서비스 이용 약관 및 개인정보 처리방침에 동의합니다', 'it': 'Accetto i termini di servizio e l\'informativa sulla privacy', 'fr': 'J\'accepte les conditions d\'utilisation et la politique de confidentialité', 'es': 'Acepto los términos de servicio y la política de privacidad', 'ru': 'Я согласен с условиями обслуживания и политикой конфиденциальности', 'pt': 'Concordo com os termos de serviço e a política de privacidade', 'tr': 'Hizmet şartlarını ve gizlilik politikasını kabul ediyorum', 'ja': '利用規約とプライバシーポリシーに同意します', 'hi': 'मैं सेवा की शर्तों और गोपनीयता नीति से सहमत हूँ', 'ar': 'أوافق على شروط الخدمة وسياسة الخصوصية', 'bn': 'আমি পরিষেবার শর্তাবলী এবং গোপনীয়তা নীতিতে সম্মত', },
    'm5an2ndx': { 'de': 'Durch das Erstellen eines Kontos stimmst du unseren ', 'en': 'By creating an account, you agree to our ', 'ko': '계정을 생성함으로써 당사의 ', 'it': 'Creando un account, accetti i nostri ', 'fr': 'En créant un compte, vous acceptez nos ', 'es': 'Al crear una cuenta, aceptas nuestros ', 'ru': 'Создавая аккаунт, вы соглашаетесь с нашими ', 'pt': 'Ao criar uma conta, você concorda com nossos ', 'tr': 'Bir hesap oluşturarak şunları kabul etmiş olursunuz: ', 'ja': 'アカウントを作成することにより、当社の', 'hi': 'खाता बनाकर, आप हमारी ', 'ar': 'من خلال إنشاء حساب، فإنك توافق على ', 'bn': 'একটি অ্যাকাউন্ট তৈরি করার মাধ্যমে, আপনি আমাদের ', },
    'rbbty9tw': { 'de': 'Nutzungsbedingungen', 'en': 'Terms of Service', 'ko': '서비스 이용 약관', 'it': 'Termini di servizio', 'fr': 'Conditions d\'utilisation', 'es': 'Términos de servicio', 'ru': 'Условия обслуживания', 'pt': 'Termos de Serviço', 'tr': 'Hizmet Şartları', 'ja': '利用規約', 'hi': 'सेवा की शर्तें', 'ar': 'شروط الخدمة', 'bn': 'পরিষেবার শর্তাবলী', },
    'x5cnfgpw': { 'de': ' und ', 'en': ' and ', 'ko': ' 및 ', 'it': ' e ', 'fr': ' et ', 'es': ' y ', 'ru': ' и ', 'pt': ' e ', 'tr': ' ve ', 'ja': 'および', 'hi': ' और ', 'ar': ' و ', 'bn': ' এবং ', },
    'hqpvp9r0': { 'de': 'Datenschutzrichtlinie', 'en': 'Privacy Policy', 'ko': '개인정보 처리방침', 'it': 'Informativa sulla privacy', 'fr': 'Politique de confidentialité', 'es': 'Política de privacidad', 'ru': 'Политика конфиденциальности', 'pt': 'Política de Privacidade', 'tr': 'Gizlilik Politikası', 'ja': 'プライバシーポリシー', 'hi': 'गोपनीयता नीति', 'ar': 'سياسة الخصوصية', 'bn': 'গোপনীয়তা নীতি', },
    'rm8reted': { 'de': 'Registrieren', 'en': 'Sign up', 'ko': '가입하기', 'it': 'Iscriviti', 'fr': 'S\'inscrire', 'es': 'Registrarse', 'ru': 'Зарегистрироваться', 'pt': 'Inscrever-se', 'tr': 'Kaydol', 'ja': 'サインアップ', 'hi': 'साइन अप करें', 'ar': 'التسجيل', 'bn': 'সাইন আপ করুন', },
    '14vmfpv5': { 'de': 'Du hast bereits ein Konto? ', 'en': 'Already have an account? ', 'ko': '이미 계정이 있으신가요? ', 'it': 'Hai già un account? ', 'fr': 'Vous avez déjà un compte ? ', 'es': '¿Ya tienes una cuenta? ', 'ru': 'Уже есть аккаунт? ', 'pt': 'Já tem uma conta? ', 'tr': 'Zaten hesabınız var mı? ', 'ja': 'すでにアカウントをお持ちですか？ ', 'hi': 'पहले से ही खाता है? ', 'ar': 'هل لديك حساب بالفعل؟ ', 'bn': 'ইতিমধ্যে একটি অ্যাকাউন্ট আছে? ', },
    'e1xg9tab': { 'de': 'Anmelden', 'en': 'Sign in', 'ko': '로그인', 'it': 'Accedi', 'fr': 'Se connecter', 'es': 'Iniciar sesión', 'ru': 'Войти', 'pt': 'Entrar', 'tr': 'Giriş Yap', 'ja': 'サインイン', 'hi': 'साइन इन करें', 'ar': 'تسجيل الدخول', 'bn': 'সাইন ইন করুন', },
  }, // <-- Comma after the signup_screen block
  // supportScreen / supportScreenCopy (Consolidated)
  {
    'o9sfq8jn': { 'de': 'Kontakt', 'en': 'Contact Us', 'ko': '문의하기', 'it': 'Contattaci', 'fr': 'Nous contacter', 'es': 'Contáctanos', 'ru': 'Связаться с нами', 'pt': 'Contate-nos', 'tr': 'Bize Ulaşın', 'ja': 'お問い合わせ', 'hi': 'संपर्क करें', 'ar': 'اتصل بنا', 'bn': 'যোগাযোগ করুন', },
    '97q2tpif': { 'de': 'Kontakt', 'en': 'Contact Us', 'ko': '문의하기', 'it': 'Contattaci', 'fr': 'Nous contacter', 'es': 'Contáctanos', 'ru': 'Связаться с нами', 'pt': 'Contate-nos', 'tr': 'Bize Ulaşın', 'ja': 'お問い合わせ', 'hi': 'संपर्क करें', 'ar': 'اتصل بنا', 'bn': 'যোগাযোগ করুন', }, // Duplicate key
    'oq7lelxo': { 'de': 'Sende uns eine Nachricht und wir melden uns so schnell wie möglich bei dir.', 'en': 'Send us a message and we\'ll get back to you as soon as possible.', 'ko': '메시지를 보내주시면 최대한 빨리 답변드리겠습니다.', 'it': 'Inviaci un messaggio e ti risponderemo il prima possibile.', 'fr': 'Envoyez-nous un message et nous vous répondrons dès que possible.', 'es': 'Envíanos un mensaje y te responderemos lo antes posible.', 'ru': 'Отправьте нам сообщение, и мы свяжемся с вами как можно скорее.', 'pt': 'Envie-nos uma mensagem e retornaremos o mais breve possível.', 'tr': 'Bize bir mesaj gönderin, en kısa sürede size geri dönüş yapalım.', 'ja': 'メッセージをお送りいただければ、できるだけ早く返信いたします。', 'hi': 'हमें एक संदेश भेजें और हम जल्द से जल्द आपसे संपर्क करेंगे।', 'ar': 'أرسل لنا رسالة وسنرد عليك في أقرب وقت ممكن.', 'bn': 'আমাদের একটি বার্তা পাঠান এবং আমরা যত তাড়াতাড়ি সম্ভব আপনার কাছে ফিরে আসব।', },
    'edw06gyn': { 'de': 'Sende uns eine Nachricht und wir melden uns so schnell wie möglich bei dir.', 'en': 'Send us a message and we\'ll get back to you as soon as possible.', 'ko': '메시지를 보내주시면 최대한 빨리 답변드리겠습니다.', 'it': 'Inviaci un messaggio e ti risponderemo il prima possibile.', 'fr': 'Envoyez-nous un message et nous vous répondrons dès que possible.', 'es': 'Envíanos un mensaje y te responderemos lo antes posible.', 'ru': 'Отправьте нам сообщение, и мы свяжемся с вами как можно скорее.', 'pt': 'Envie-nos uma mensagem e retornaremos o mais breve possível.', 'tr': 'Bize bir mesaj gönderin, en kısa sürede size geri dönüş yapalım.', 'ja': 'メッセージをお送りいただければ、できるだけ早く返信いたします。', 'hi': 'हमें एक संदेश भेजें और हम जल्द से जल्द आपसे संपर्क करेंगे।', 'ar': 'أرسل لنا رسالة وسنرد عليك في أقرب وقت ممكن.', 'bn': 'আমাদের একটি বার্তা পাঠান এবং আমরা যত তাড়াতাড়ি সম্ভব আপনার কাছে ফিরে আসব।', }, // Duplicate key
    'n5ja8cbb': { 'de': 'Kontaktgrund', 'en': 'Reason for contact', 'ko': '문의 사유', 'it': 'Motivo del contatto', 'fr': 'Raison du contact', 'es': 'Motivo del contacto', 'ru': 'Причина обращения', 'pt': 'Motivo do contato', 'tr': 'İletişim nedeni', 'ja': '連絡理由', 'hi': 'संपर्क का कारण', 'ar': 'سبب الاتصال', 'bn': 'যোগাযোগের কারণ', },
    '04cob80g': { 'de': 'Kontaktgrund', 'en': 'Reason for contact', 'ko': '문의 사유', 'it': 'Motivo del contatto', 'fr': 'Raison du contact', 'es': 'Motivo del contacto', 'ru': 'Причина обращения', 'pt': 'Motivo do contato', 'tr': 'İletişim nedeni', 'ja': '連絡理由', 'hi': 'संपर्क का कारण', 'ar': 'سبب الاتصال', 'bn': 'যোগাযোগের কারণ', }, // Duplicate key
    '41tnjyyb': { 'de': '📩 Feedback', 'en': '📩 Feedback', 'ko': '📩 피드백', 'it': '📩 Feedback', 'fr': '📩 Commentaires', 'es': '📩 Comentarios', 'ru': '📩 Обратная связь', 'pt': '📩 Feedback', 'tr': '📩 Geri Bildirim', 'ja': '📩 フィードバック', 'hi': '📩 प्रतिक्रिया', 'ar': '📩 ملاحظات', 'bn': '📩 ফিডব্যাক', },
    'fdpxye3f': { 'de': '📩 Feedback', 'en': '📩 Feedback', 'ko': '📩 피드백', 'it': '📩 Feedback', 'fr': '📩 Commentaires', 'es': '📩 Comentarios', 'ru': '📩 Обратная связь', 'pt': '📩 Feedback', 'tr': '📩 Geri Bildirim', 'ja': '📩 フィードバック', 'hi': '📩 प्रतिक्रिया', 'ar': '📩 ملاحظات', 'bn': '📩 ফিডব্যাক', }, // Duplicate key
    'mvmyrkl8': { 'de': '⚠️ Problem melden', 'en': '⚠️ Report an issue', 'ko': '⚠️ 문제 신고', 'it': '⚠️ Segnala un problema', 'fr': '⚠️ Signaler un problème', 'es': '⚠️ Informar de un problema', 'ru': '⚠️ Сообщить о проблеме', 'pt': '⚠️ Reportar um problema', 'tr': '⚠️ Sorun Bildir', 'ja': '⚠️ 問題を報告', 'hi': '⚠️ समस्या की रिपोर्ट करें', 'ar': '⚠️ الإبلاغ عن مشكلة', 'bn': '⚠️ সমস্যা রিপোর্ট করুন', },
    'oz0q0s0o': { 'de': '⚠️ Problem melden', 'en': '⚠️ Report an issue', 'ko': '⚠️ 문제 신고', 'it': '⚠️ Segnala un problema', 'fr': '⚠️ Signaler un problème', 'es': '⚠️ Informar de un problema', 'ru': '⚠️ Сообщить о проблеме', 'pt': '⚠️ Reportar um problema', 'tr': '⚠️ Sorun Bildir', 'ja': '⚠️ 問題を報告', 'hi': '⚠️ समस्या की रिपोर्ट करें', 'ar': '⚠️ الإبلاغ عن مشكلة', 'bn': '⚠️ সমস্যা রিপোর্ট করুন', }, // Duplicate key
    'uly48p0u': { 'de': '📦 Persönliche Daten anfordern', 'en': '📦 Receive personal data', 'ko': '📦 개인 데이터 요청', 'it': '📦 Richiedi dati personali', 'fr': '📦 Recevoir les données personnelles', 'es': '📦 Recibir datos personales', 'ru': '📦 Получить личные данные', 'pt': '📦 Receber dados pessoais', 'tr': '📦 Kişisel verileri al', 'ja': '📦 個人データを受け取る', 'hi': '📦 व्यक्तिगत डेटा प्राप्त करें', 'ar': '📦 استلام البيانات الشخصية', 'bn': '📦 ব্যক্তিগত ডেটা পান', },
    '0mg7fqwk': { 'de': '📦 Persönliche Daten anfordern', 'en': '📦 Receive personal data', 'ko': '📦 개인 데이터 요청', 'it': '📦 Richiedi dati personali', 'fr': '📦 Recevoir les données personnelles', 'es': '📦 Recibir datos personales', 'ru': '📦 Получить личные данные', 'pt': '📦 Receber dados pessoais', 'tr': '📦 Kişisel verileri al', 'ja': '📦 個人データを受け取る', 'hi': '📦 व्यक्तिगत डेटा प्राप्त करें', 'ar': '📦 استلام البيانات الشخصية', 'bn': '📦 ব্যক্তিগত ডেটা পান', }, // Duplicate key
    '0p7uavcm': { 'de': '🗑️ Konto löschen', 'en': '🗑️ Account deletion', 'ko': '🗑️ 계정 삭제', 'it': '🗑️ Eliminazione account', 'fr': '🗑️ Suppression de compte', 'es': '🗑️ Eliminación de cuenta', 'ru': '🗑️ Удаление аккаунта', 'pt': '🗑️ Exclusão de conta', 'tr': '🗑️ Hesap silme', 'ja': '🗑️ アカウント削除', 'hi': '🗑️ खाता हटाना', 'ar': '🗑️ حذف الحساب', 'bn': '🗑️ অ্যাকাউন্ট মুছে ফেলা', },
    'a6euqu6g': { 'de': '🗑️ Konto löschen', 'en': '🗑️ Account deletion', 'ko': '🗑️ 계정 삭제', 'it': '🗑️ Eliminazione account', 'fr': '🗑️ Suppression de compte', 'es': '🗑️ Eliminación de cuenta', 'ru': '🗑️ Удаление аккаунта', 'pt': '🗑️ Exclusão de conta', 'tr': '🗑️ Hesap silme', 'ja': '🗑️ アカウント削除', 'hi': '🗑️ खाता हटाना', 'ar': '🗑️ حذف الحساب', 'bn': '🗑️ অ্যাকাউন্ট মুছে ফেলা', }, // Duplicate key
    'hj4wzcaw': { 'de': '➕ Sonstiges', 'en': '➕ Other', 'ko': '➕ 기타', 'it': '➕ Altro', 'fr': '➕ Autre', 'es': '➕ Otro', 'ru': '➕ Другое', 'pt': '➕ Outro', 'tr': '➕ Diğer', 'ja': '➕ その他', 'hi': '➕ अन्य', 'ar': '➕ أخرى', 'bn': '➕ অন্যান্য', },
    'kh0ehgv8': { 'de': '➕ Sonstiges', 'en': '➕ Other', 'ko': '➕ 기타', 'it': '➕ Altro', 'fr': '➕ Autre', 'es': '➕ Otro', 'ru': '➕ Другое', 'pt': '➕ Outro', 'tr': '➕ Diğer', 'ja': '➕ その他', 'hi': '➕ अन्य', 'ar': '➕ أخرى', 'bn': '➕ অন্যান্য', }, // Duplicate key
    'jr754jrp': { 'de': 'Deine E-Mail-Adresse', 'en': 'Your email address', 'ko': '이메일 주소', 'it': 'Il tuo indirizzo email', 'fr': 'Votre adresse e-mail', 'es': 'Tu dirección de correo electrónico', 'ru': 'Ваш адрес электронной почты', 'pt': 'Seu endereço de e-mail', 'tr': 'E-posta adresiniz', 'ja': 'あなたのメールアドレス', 'hi': 'आप का ईमेल पता', 'ar': 'عنوان بريدك الإلكتروني', 'bn': 'আপনার ইমেল ঠিকানা', },
    'eet7ay7h': { 'de': 'Deine E-Mail-Adresse', 'en': 'Your email address', 'ko': '이메일 주소', 'it': 'Il tuo indirizzo email', 'fr': 'Votre adresse e-mail', 'es': 'Tu dirección de correo electrónico', 'ru': 'Ваш адрес электронной почты', 'pt': 'Seu endereço de e-mail', 'tr': 'E-posta adresiniz', 'ja': 'あなたのメールアドレス', 'hi': 'आप का ईमेल पता', 'ar': 'عنوان بريدك الإلكتروني', 'bn': 'আপনার ইমেল ঠিকানা', }, // Duplicate key
    'assaubjl': { 'de': ' *', 'en': ' *', 'ko': ' *', 'it': ' *', 'fr': ' *', 'es': ' *', 'ru': ' *', 'pt': ' *', 'tr': ' *', 'ja': ' *', 'hi': ' *', 'ar': ' *', 'bn': ' *', },
    'q1yiytcf': { 'de': ' *', 'en': ' *', 'ko': ' *', 'it': ' *', 'fr': ' *', 'es': ' *', 'ru': ' *', 'pt': ' *', 'tr': ' *', 'ja': ' *', 'hi': ' *', 'ar': ' *', 'bn': ' *', }, // Duplicate key
    '16s6tuii': { 'de': 'Gib deine E-Mail-Adresse ein', 'en': 'Enter your email address', 'ko': '이메일 주소 입력', 'it': 'Inserisci il tuo indirizzo email', 'fr': 'Entrez votre adresse e-mail', 'es': 'Introduce tu dirección de correo electrónico', 'ru': 'Введите свой адрес электронной почты', 'pt': 'Digite seu endereço de e-mail', 'tr': 'E-posta adresinizi girin', 'ja': 'メールアドレスを入力してください', 'hi': 'अपना ईमेल पता दर्ज करें', 'ar': 'أدخل عنوان بريدك الإلكتروني', 'bn': 'আপনার ইমেল ঠিকানা লিখুন', },
    't3lnws16': { 'de': 'Gib deine E-Mail-Adresse ein', 'en': 'Enter your email address', 'ko': '이메일 주소 입력', 'it': 'Inserisci il tuo indirizzo email', 'fr': 'Entrez votre adresse e-mail', 'es': 'Introduce tu dirección de correo electrónico', 'ru': 'Введите свой адрес электронной почты', 'pt': 'Digite seu endereço de e-mail', 'tr': 'E-posta adresinizi girin', 'ja': 'メールアドレスを入力してください', 'hi': 'अपना ईमेल पता दर्ज करें', 'ar': 'أدخل عنوان بريدك الإلكتروني', 'bn': 'আপনার ইমেল ঠিকানা লিখুন', }, // Duplicate key
    'hgwa2li4': { 'de': 'Deine Nachricht', 'en': 'Your message', 'ko': '메시지 내용', 'it': 'Il tuo messaggio', 'fr': 'Votre message', 'es': 'Tu mensaje', 'ru': 'Ваше сообщение', 'pt': 'Sua mensagem', 'tr': 'Mesajınız', 'ja': 'あなたのメッセージ', 'hi': 'आपका सन्देश', 'ar': 'رسالتك', 'bn': 'আপনার বার্তা', },
    'cgo5ym1b': { 'de': 'Deine Nachricht', 'en': 'Your message', 'ko': '메시지 내용', 'it': 'Il tuo messaggio', 'fr': 'Votre message', 'es': 'Tu mensaje', 'ru': 'Ваше сообщение', 'pt': 'Sua mensagem', 'tr': 'Mesajınız', 'ja': 'あなたのメッセージ', 'hi': 'आपका सन्देश', 'ar': 'رسالتك', 'bn': 'আপনার বার্তা', }, // Duplicate key
    'gd5ems9f': { 'de': 'Sag uns, wie wir helfen können...', 'en': 'Tell us how we can help...', 'ko': '어떻게 도와드릴까요...', 'it': 'Dicci come possiamo aiutarti...', 'fr': 'Dites-nous comment nous pouvons vous aider...', 'es': 'Dinos cómo podemos ayudarte...', 'ru': 'Расскажите, как мы можем помочь...', 'pt': 'Diga-nos como podemos ajudar...', 'tr': 'Size nasıl yardımcı olabileceğimizi bize bildirin...', 'ja': 'どのようにお手伝いできますか...', 'hi': 'हमें बताएं कि हम कैसे मदद कर सकते हैं...', 'ar': 'أخبرنا كيف يمكننا المساعدة...', 'bn': 'বলুন আমরা কিভাবে সাহায্য করতে পারি...', },
    'i6masrx6': { 'de': 'Sag uns, wie wir helfen können...', 'en': 'Tell us how we can help...', 'ko': '어떻게 도와드릴까요...', 'it': 'Dicci come possiamo aiutarti...', 'fr': 'Dites-nous comment nous pouvons vous aider...', 'es': 'Dinos cómo podemos ayudarte...', 'ru': 'Расскажите, как мы можем помочь...', 'pt': 'Diga-nos como podemos ajudar...', 'tr': 'Size nasıl yardımcı olabileceğimizi bize bildirin...', 'ja': 'どのようにお手伝いできますか...', 'hi': 'हमें बताएं कि हम कैसे मदद कर सकते हैं...', 'ar': 'أخبرنا كيف يمكننا المساعدة...', 'bn': 'বলুন আমরা কিভাবে সাহায্য করতে পারি...', }, // Duplicate key
    '5vvolqy9': { 'de': 'Nachricht senden', 'en': 'Send message', 'ko': '메시지 보내기', 'it': 'Invia messaggio', 'fr': 'Envoyer le message', 'es': 'Enviar mensaje', 'ru': 'Отправить сообщение', 'pt': 'Enviar mensagem', 'tr': 'Mesaj gönder', 'ja': 'メッセージを送信', 'hi': 'संदेश भेजो', 'ar': 'إرسال رسالة', 'bn': 'বার্তা পাঠান', },
    '4zpr3gxa': { 'de': 'Nachricht senden', 'en': 'Send message', 'ko': '메시지 보내기', 'it': 'Invia messaggio', 'fr': 'Envoyer le message', 'es': 'Enviar mensaje', 'ru': 'Отправить сообщение', 'pt': 'Enviar mensagem', 'tr': 'Mesaj gönder', 'ja': 'メッセージを送信', 'hi': 'संदेश भेजो', 'ar': 'إرسال رسالة', 'bn': 'বার্তা পাঠান', }, // Duplicate key
    'e0rpmxxd': { 'de': 'Abbrechen', 'en': 'Cancel', 'ko': '취소', 'it': 'Annulla', 'fr': 'Annuler', 'es': 'Cancelar', 'ru': 'Отмена', 'pt': 'Cancelar', 'tr': 'İptal', 'ja': 'キャンセル', 'hi': 'रद्द करें', 'ar': 'إلغاء', 'bn': 'বাতিল করুন', },
    'n1mz9efg': { 'de': 'Abbrechen', 'en': 'Cancel', 'ko': '취소', 'it': 'Annulla', 'fr': 'Annuler', 'es': 'Cancelar', 'ru': 'Отмена', 'pt': 'Cancelar', 'tr': 'İptal', 'ja': 'キャンセル', 'hi': 'रद्द करें', 'ar': 'إلغاء', 'bn': 'বাতিল করুন', }, // Duplicate key
    'y9s10ipl': { 'de': 'Option 1', 'en': 'Option 1', 'ko': '옵션 1', 'it': 'Opzione 1', 'fr': 'Option 1', 'es': 'Opción 1', 'ru': 'Вариант 1', 'pt': 'Opção 1', 'tr': 'Seçenek 1', 'ja': 'オプション1', 'hi': 'विकल्प 1', 'ar': 'الخيار 1', 'bn': 'বিকল্প ১', },
    'sljjnukb': { 'de': 'Option 2', 'en': 'Option 2', 'ko': '옵션 2', 'it': 'Opzione 2', 'fr': 'Option 2', 'es': 'Opción 2', 'ru': 'Вариант 2', 'pt': 'Opção 2', 'tr': 'Seçenek 2', 'ja': 'オプション2', 'hi': 'विकल्प 2', 'ar': 'الخيار 2', 'bn': 'বিকল্প ২', },
    'g3xw0wla': { 'de': 'Option 3', 'en': 'Option 3', 'ko': '옵션 3', 'it': 'Opzione 3', 'fr': 'Option 3', 'es': 'Opción 3', 'ru': 'Вариант 3', 'pt': 'Opção 3', 'tr': 'Seçenek 3', 'ja': 'オプション3', 'hi': 'विकल्प 3', 'ar': 'الخيار 3', 'bn': 'বিকল্প ৩', },
  }, // <-- Comma after the supportScreen block
  // streak_page
  // streak_page
  {
    'l5hlxu8x': { 'de': '21', 'en': '21', 'ko': '21', 'it': '21', 'fr': '21', 'es': '21', 'ru': '21', 'pt': '21', 'tr': '21', 'ja': '21', 'hi': '२१', 'ar': '٢١', 'bn': '২১', }, // Number, ideally dynamic
    '3c9f9t29': { 'de': 'Tage Serie!', 'en': 'day streak!', 'ko': '일 연속!', 'it': 'giorni di serie!', 'fr': 'jours de série !', 'es': '¡días de racha!', 'ru': 'дней подряд!', 'pt': 'dias de sequência!', 'tr': 'günlük seri!', 'ja': '日間連続！', 'hi': 'दिन का सिलसिला!', 'ar': 'يوم متتالي!', 'bn': 'দিনের ধারাবাহিকতা!', },
    'qcfdyz36': { 'de': 'Du bist 21 Tage lang beständig geblieben – mach weiter so!', 'en': 'You\'ve stayed consistent for 21 days – keep the momentum going!', 'ko': '21일 동안 꾸준히 해왔습니다 – 계속 이 기세를 이어가세요!', 'it': 'Sei stato costante per 21 giorni – continua così!', 'fr': 'Vous avez été constant pendant 21 jours – continuez sur votre lancée !', 'es': '¡Has sido constante durante 21 días – mantén el impulso!', 'ru': 'Вы были последовательны 21 день – продолжайте в том же духе!', 'pt': 'Você se manteve consistente por 21 dias – mantenha o ritmo!', 'tr': '21 gündür tutarlısın – ivmeyi koru!', 'ja': '21日間継続しました – この調子で続けましょう！', 'hi': 'आप 21 दिनों तक लगातार बने रहे हैं - गति बनाए रखें!', 'ar': 'لقد حافظت على ثباتك لمدة 21 يومًا - حافظ على الزخم!', 'bn': 'আপনি ২১ দিন ধরে ধারাবাহিক থেকেছেন – এই গতি বজায় রাখুন!', }, // Number ideally dynamic
    'le7oay1x': { 'de': 'Teilen', 'en': 'Share', 'ko': '공유하기', 'it': 'Condividi', 'fr': 'Partager', 'es': 'Compartir', 'ru': 'Поделиться', 'pt': 'Compartilhar', 'tr': 'Paylaş', 'ja': '共有', 'hi': 'साझा करें', 'ar': 'مشاركة', 'bn': 'শেয়ার করুন', },
    'gkxdodb7': { 'de': 'Weiter', 'en': 'Continue', 'ko': '계속하기', 'it': 'Continua', 'fr': 'Continuer', 'es': 'Continuar', 'ru': 'Продолжить', 'pt': 'Continuar', 'tr': 'Devam', 'ja': '続ける', 'hi': 'जारी रखें', 'ar': 'متابعة', 'bn': 'চালিয়ে যান', },
  }, // <-- Comma after the streak_page block
  // feedcard
  {
    'ltw1ki3o': { 'de': 'sarah', 'en': 'sarah', 'ko': 'sarah', 'it': 'sarah', 'fr': 'sarah', 'es': 'sarah', 'ru': 'сара', 'pt': 'sarah', 'tr': 'sarah', 'ja': 'サラ', 'hi': 'सारा', 'ar': 'سارة', 'bn': 'সারা', }, // Username
    'p6rco3pc': { 'de': 'Meinen Morgenlauf beendet! 5km in 25 Minuten, neue persönliche Bestzeit!', 'en': 'Completed my morning run! 5km in 25 minutes, a new personal best!', 'ko': '아침 달리기 완료! 25분 만에 5km, 개인 최고 기록!', 'it': 'Completata la mia corsa mattutina! 5km in 25 minuti, nuovo record personale!', 'fr': 'J\'ai terminé ma course matinale ! 5 km en 25 minutes, un nouveau record personnel !', 'es': '¡He completado mi carrera matutina! 5 km en 25 minutos, ¡un nuevo récord personal!', 'ru': 'Завершил утреннюю пробежку! 5 км за 25 минут, новый личный рекорд!', 'pt': 'Completei minha corrida matinal! 5km em 25 minutos, um novo recorde pessoal!', 'tr': 'Sabah koşumu tamamlandı! 25 dakikada 5 km, yeni kişisel rekor!', 'ja': '朝のランニング完了！25分で5km、自己ベスト更新！', 'hi': 'अपनी सुबह की दौड़ पूरी की! 25 मिनट में 5 किमी, एक नया व्यक्तिगत सर्वश्रेष्ठ!', 'ar': 'أكملت ركضي الصباحي! 5 كم في 25 دقيقة، أفضل رقم شخصي جديد!', 'bn': 'সকালের দৌড় সম্পন্ন! ২৫ মিনিটে ৫ কিমি, নতুন ব্যক্তিগত সেরা!', },
    'y11mlk40': { 'de': '👅 Reagieren', 'en': '👅 React', 'ko': '👅 반응하기', 'it': '👅 Reagisci', 'fr': '👅 Réagir', 'es': '👅 Reaccionar', 'ru': '👅 Отреагировать', 'pt': '👅 Reagir', 'tr': '👅 Tepki Ver', 'ja': '👅 リアクション', 'hi': '👅 प्रतिक्रिया दें', 'ar': '👅 تفاعل', 'bn': '👅 প্রতিক্রিয়া', },
    'ky8tl0o9': { 'de': '2', 'en': '2', 'ko': '2', 'it': '2', 'fr': '2', 'es': '2', 'ru': '2', 'pt': '2', 'tr': '2', 'ja': '2', 'hi': '२', 'ar': '٢', 'bn': '২', }, // Count
    'mng66p9n': { 'de': 'vor 10 Std.', 'en': '10h ago', 'ko': '10시간 전', 'it': '10 ore fa', 'fr': 'Il y a 10h', 'es': 'Hace 10h', 'ru': '10 ч назад', 'pt': '10h atrás', 'tr': '10sa önce', 'ja': '10時間前', 'hi': '10 घंटे पहले', 'ar': 'قبل 10 ساعات', 'bn': '১০ ঘণ্টা আগে', }, // Timestamp
  }, // <-- Comma after the feedcard block
  // Friendlistitem
  {
    'jau915vf': { 'de': 'Alex Kowac', 'en': 'Alex Kowac', 'ko': 'Alex Kowac', 'it': 'Alex Kowac', 'fr': 'Alex Kowac', 'es': 'Alex Kowac', 'ru': 'Алекс Ковач', 'pt': 'Alex Kowac', 'tr': 'Alex Kowac', 'ja': 'アレックス・コワック', 'hi': 'एलेक्स कोवाक', 'ar': 'أليكس كواك', 'bn': 'অ্যালেক্স কোয়াক', }, // Name
  }, // <-- Comma after the Friendlistitem block
  // Habitcard
  {
    'ocivy9st': { 'de': 'Selbstfürsorge', 'en': 'Self-care', 'ko': '자기 관리', 'it': 'Cura di sé', 'fr': 'Soins personnels', 'es': 'Autocuidado', 'ru': 'Забота о себе', 'pt': 'Autocuidado', 'tr': 'Öz bakım', 'ja': 'セルフケア', 'hi': 'स्वयं की देखभाल', 'ar': 'العناية الذاتية', 'bn': 'আত্ম-যত্ন', },
    'u4m4bidd': { 'de': '09:15', 'en': '09:15', 'ko': '09:15', 'it': '09:15', 'fr': '09:15', 'es': '09:15', 'ru': '09:15', 'pt': '09:15', 'tr': '09:15', 'ja': '09:15', 'hi': '09:15', 'ar': '09:15', 'bn': '০৯:১৫', }, // Time
    '47lyi7wg': { 'de': 'M', 'en': 'M', 'ko': '월', 'it': 'L', 'fr': 'L', 'es': 'L', 'ru': 'Пн', 'pt': 'S', 'tr': 'Pzt', 'ja': '月', 'hi': 'सो', 'ar': 'ن', 'bn': 'সো', },
    '5h9sa52r': { 'de': 'D', 'en': 'T', 'ko': '화', 'it': 'M', 'fr': 'M', 'es': 'M', 'ru': 'Вт', 'pt': 'T', 'tr': 'Sa', 'ja': '火', 'hi': 'मं', 'ar': 'ث', 'bn': 'ম', },
    'a0vrj50a': { 'de': 'M', 'en': 'W', 'ko': '수', 'it': 'M', 'fr': 'M', 'es': 'X', 'ru': 'Ср', 'pt': 'Q', 'tr': 'Ça', 'ja': '水', 'hi': 'बु', 'ar': 'ر', 'bn': 'বু', },
    'fu48xf2d': { 'de': 'D', 'en': 'T', 'ko': '목', 'it': 'G', 'fr': 'J', 'es': 'J', 'ru': 'Чт', 'pt': 'Q', 'tr': 'Pe', 'ja': '木', 'hi': 'गु', 'ar': 'خ', 'bn': 'বৃ', },
    'w8cryc0h': { 'de': 'F', 'en': 'F', 'ko': '금', 'it': 'V', 'fr': 'V', 'es': 'V', 'ru': 'Пт', 'pt': 'S', 'tr': 'Cu', 'ja': '金', 'hi': 'शु', 'ar': 'ج', 'bn': 'শু', },
    'xkkawx75': { 'de': 'S', 'en': 'S', 'ko': '토', 'it': 'S', 'fr': 'S', 'es': 'S', 'ru': 'Сб', 'pt': 'S', 'tr': 'Cmt', 'ja': '土', 'hi': 'श', 'ar': 'س', 'bn': 'শ', },
    'byt540hv': { 'de': 'S', 'en': 'S', 'ko': '일', 'it': 'D', 'fr': 'D', 'es': 'D', 'ru': 'Вс', 'pt': 'D', 'tr': 'P', 'ja': '日', 'hi': 'र', 'ar': 'ح', 'bn': 'র', },
  }, // <-- Comma after the Habitcard block
  // Tabbar
  {
    'qkem2ayu': { 'de': 'Freunde', 'en': 'Friends', 'ko': '친구', 'it': 'Amici', 'fr': 'Amis', 'es': 'Amigos', 'ru': 'Друзья', 'pt': 'Amigos', 'tr': 'Arkadaşlar', 'ja': '友達', 'hi': 'दोस्त', 'ar': 'الأصدقاء', 'bn': 'বন্ধু', },
    '06yity6g': { 'de': 'Freunde von Freunden', 'en': 'Friends of Friends', 'ko': '친구의 친구', 'it': 'Amici di amici', 'fr': 'Amis d\'amis', 'es': 'Amigos de amigos', 'ru': 'Друзья друзей', 'pt': 'Amigos de Amigos', 'tr': 'Arkadaşların Arkadaşları', 'ja': '友達の友達', 'hi': 'दोस्तों के दोस्त', 'ar': 'أصدقاء الأصدقاء', 'bn': 'বন্ধুদের বন্ধু', },
    'ggzhlty1': { 'de': 'Kommt bald', 'en': 'Coming Soon', 'ko': '출시 예정', 'it': 'Prossimamente', 'fr': 'Bientôt disponible', 'es': 'Próximamente', 'ru': 'Скоро', 'pt': 'Em breve', 'tr': 'Yakında', 'ja': '近日公開', 'hi': 'जल्द आ रहा है', 'ar': 'قريباً', 'bn': 'শীঘ্রই আসছে', },
    'bgk4ztgp': { 'de': 'Diese Funktion wird in einem zukünftigen Update verfügbar sein.', 'en': 'This feature will be available in an upcoming update.', 'ko': '이 기능은 다음 업데이트에서 사용할 수 있습니다.', 'it': 'Questa funzionalità sarà disponibile in un prossimo aggiornamento.', 'fr': 'Cette fonctionnalité sera disponible dans une prochaine mise à jour.', 'es': 'Esta función estará disponible en una próxima actualización.', 'ru': 'Эта функция будет доступна в следующем обновлении.', 'pt': 'Este recurso estará disponível em uma atualização futura.', 'tr': 'Bu özellik gelecek bir güncellemede mevcut olacaktır.', 'ja': 'この機能は今後のアップデートで利用可能になります。', 'hi': 'यह सुविधा अगले अपडेट में उपलब्ध होगी।', 'ar': 'ستكون هذه الميزة متاحة في تحديث قادم.', 'bn': 'এই বৈশিষ্ট্যটি পরবর্তী আপডেটে উপলব্ধ হবে।', },
  }, // <-- Make sure there's a comma here if more sections follow
// ExistingGroup
  {
    '4k40sy3j': { 'de': 'Öffentlich', 'en': 'Public', 'ko': '공개', 'it': 'Pubblico', 'fr': 'Public', 'es': 'Público', 'ru': 'Общедоступная', 'pt': 'Público', 'tr': 'Herkese Açık', 'ja': '公開', 'hi': 'सार्वजनिक', 'ar': 'عام', 'bn': 'পাবলিক', },
  }, // <-- Comma after the ExistingGroup block
  // DiscoverGroup
  {
    '1cqyh5uj': { 'de': 'Öffentlich', 'en': 'Public', 'ko': '공개', 'it': 'Pubblico', 'fr': 'Public', 'es': 'Público', 'ru': 'Общедоступная', 'pt': 'Público', 'tr': 'Herkese Açık', 'ja': '公開', 'hi': 'सार्वजनिक', 'ar': 'عام', 'bn': 'পাবলিক', },
    'jgrrzt1q': { 'de': 'Beitreten', 'en': 'Join', 'ko': '참여하기', 'it': 'Unisciti', 'fr': 'Rejoindre', 'es': 'Unirse', 'ru': 'Присоединиться', 'pt': 'Entrar', 'tr': 'Katıl', 'ja': '参加', 'hi': 'शामिल हों', 'ar': 'انضم', 'bn': 'যোগ দিন', },
  }, // <-- Comma after the DiscoverGroup block

// friend_message
  {
    '0zn8t2n0': { 'de': 'E', 'en': 'E', 'ko': 'E', 'it': 'E', 'fr': 'E', 'es': 'E', 'ru': 'E', 'pt': 'E', 'tr': 'E', 'ja': 'E', 'hi': 'ई', 'ar': 'E', 'bn': 'ই', }, // Initials
    'cy4vbq8r': { 'de': 'Emma', 'en': 'Emma', 'ko': 'Emma', 'it': 'Emma', 'fr': 'Emma', 'es': 'Emma', 'ru': 'Эмма', 'pt': 'Emma', 'tr': 'Emma', 'ja': 'エマ', 'hi': 'एम्मा', 'ar': 'إيما', 'bn': 'এমা', }, // Name
    'gcs4n56m': { 'de': 'Das ist ein tolles Ziel! Ich ziele selbst auf 25 Seiten ab. Ich liebe deine Leseecke!', 'en': 'That\'s a great goal! I\'m aiming for 25 pages myself. Love your reading nook!', 'ko': '멋진 목표네요! 저도 25페이지를 목표로 하고 있어요. 독서 공간이 마음에 드네요!', 'it': 'È un grande obiettivo! Anch\'io punto a 25 pagine. Adoro il tuo angolo lettura!', 'fr': 'C\'est un super objectif ! Je vise moi-même 25 pages. J\'adore ton coin lecture !', 'es': '¡Es un gran objetivo! Yo también aspiro a 25 páginas. ¡Me encanta tu rincón de lectura!', 'ru': 'Отличная цель! Я и сам стремлюсь к 25 страницам. Обожаю твой читальный уголок!', 'pt': 'Essa é uma ótima meta! Eu mesmo estou mirando 25 páginas. Adoro seu cantinho de leitura!', 'tr': 'Bu harika bir hedef! Ben de 25 sayfayı hedefliyorum. Okuma köşene bayıldım!', 'ja': '素晴らしい目標ですね！私も25ページを目指しています。あなたの読書スペース、素敵ですね！', 'hi': 'यह एक महान लक्ष्य है! मैं स्वयं 25 पृष्ठों का लक्ष्य रख रहा हूँ। आपका पढ़ने का कोना बहुत पसंद आया!', 'ar': 'هذا هدف رائع! أنا أهدف إلى 25 صفحة بنفسي. أحب ركن القراءة الخاص بك!', 'bn': 'এটা একটা দারুণ লক্ষ্য! আমিও ২৫ পৃষ্ঠা পড়ার লক্ষ্য রাখছি। আপনার পড়ার কোণটি খুব পছন্দ হয়েছে!', },
    'r21q9tz4': { 'de': '20:32', 'en': '20:32', 'ko': '20:32', 'it': '20:32', 'fr': '20:32', 'es': '20:32', 'ru': '20:32', 'pt': '20:32', 'tr': '20:32', 'ja': '20:32', 'hi': '20:32', 'ar': '20:32', 'bn': '২০:৩২', }, // Timestamp
  }, // <-- Comma after the friend_message block
  // currentuser_message
  {
    'ej93pxu8': { 'de': 'Ich beginne gleich meine Morgensitzung. Hoffe, heute 30 Seiten zu schaffen!', 'en': 'I\'m about to start my morning session. Hoping to finish 30 pages today!', 'ko': '곧 아침 세션을 시작할 거예요. 오늘 30페이지를 끝내길 바라요!', 'it': 'Sto per iniziare la mia sessione mattutina. Spero di finire 30 pagine oggi!', 'fr': 'Je suis sur le point de commencer ma session du matin. J\'espère finir 30 pages aujourd\'hui !', 'es': 'Estoy a punto de empezar mi sesión matutina. ¡Espero terminar 30 páginas hoy!', 'ru': 'Я скоро начну утреннюю сессию. Надеюсь осилить сегодня 30 страниц!', 'pt': 'Estou prestes a começar minha sessão matinal. Esperando terminar 30 páginas hoje!', 'tr': 'Sabah seansıma başlamak üzereyim. Bugün 30 sayfa bitirmeyi umuyorum!', 'ja': 'まもなく朝のセッションを開始します。今日30ページ終えられるといいな！', 'hi': 'मैं अपना सुबह का सत्र शुरू करने वाला हूँ। उम्मीद है आज 30 पेज पूरे कर लूँगा!', 'ar': 'أنا على وشك أن أبدأ جلستي الصباحية. آمل أن أنهي 30 صفحة اليوم!', 'bn': 'আমি এখনি আমার সকালের সেশন শুরু করতে যাচ্ছি। আশা করি আজ ৩০ পৃষ্ঠা শেষ করতে পারব!', },
    'fpc7t1br': { 'de': '20:17', 'en': '20:17', 'ko': '20:17', 'it': '20:17', 'fr': '20:17', 'es': '20:17', 'ru': '20:17', 'pt': '20:17', 'tr': '20:17', 'ja': '20:17', 'hi': '20:17', 'ar': '20:17', 'bn': '২০:১৭', }, // Timestamp
  }, // <-- Comma after the currentuser_message block
  // Miscellaneous
// Miscellaneous
  {
    'gvxpduya': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    '02cheus0': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    '0miysv00': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'xa1himpx': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'oisjwf3n': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'fj4r9861': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'ta8uquug': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'f6l5wfle': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'ypqfilq9': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'z39lvhbb': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'q8yba67u': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'gpzelp4p': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'co7vp6yr': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'tk62je0j': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'y11i7oqe': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'kp50twwe': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    '5r8r7dkh': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'rw8p72u5': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    '4w5u8sjf': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    '8e5fhz1x': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    '3le1qzu6': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    '7g0dv4ah': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'bjwl72fw': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'ity22no1': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
    'slvl00dk': {'de': '', 'en': '', 'ko': '', 'it': '', 'fr': '', 'es': '', 'ru': '', 'pt': '', 'tr': '', 'ja': '', 'hi': '', 'ar': '', 'bn': ''},
  },
].reduce((a, b) => a..addAll(b));

// ================== TRANSLATIONS END ==================