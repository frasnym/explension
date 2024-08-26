import 'package:intl/intl.dart';

String formatMoney(num number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}
