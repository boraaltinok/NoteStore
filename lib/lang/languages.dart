import 'package:get/get.dart';
import 'package:my_notes/lang/en.dart';
import 'package:my_notes/lang/ru.dart';
import 'package:my_notes/lang/tr.dart';


class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'ko_KR': {
      'greeting': '안녕하세요',
    },
    'ja_JP': {
      'greeting': 'こんにちは',
    },
    'en_US': En().messages,
    'tr_TR': Tr().messages,
    'ru_RU': Ru().messages
  };

}