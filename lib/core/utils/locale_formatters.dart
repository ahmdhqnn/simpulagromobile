import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension LocaleFormatters on BuildContext {
  String get localeTag => Localizations.localeOf(this).toLanguageTag();

  DateFormat dateFormat(String pattern) => DateFormat(pattern, localeTag);
}
