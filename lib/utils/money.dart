import 'package:intl/intl.dart';

String formatMoney(num number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}

String formatMoneyString(String text) {
  return num.tryParse(text) != null ? formatMoney(num.tryParse(text)!) : '';
}
