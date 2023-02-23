import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
          'Add': 'Adding',
          'empty_field': "This field must not be empty"
        },
        'swa_KE': {
          'hello': 'Habari Yako',
          'Add': 'Ongeze',
          'Login': 'Ingia',
          'Submit': 'Wasilisha',
          'Contact name': 'Jina la mhusika',
          'Name': 'Jina',
          'Teacher Type': 'Cheo cha Mwalimu',
          'Username': 'Kitambulisho',
          'Active': 'Inatumika',
          "TSC": "tsc",
          "empty_field": "Linahitajika",
          "Faield..": "Imefeli..",
          'Modified': 'Ilibadilishwa Lini',
          'Password': 'Neno Siri',
          'School emis Code / Phone number': 'Kodi ya Shule / Nambari ya simu',
        },
        'de_DE': {
          'hello': 'Hallo Welt',
        }
      };
}
