import 'package:intl/intl.dart';

/// Ported from `fmtMoney` / `fmtDate` / `fmtDateTime`.
abstract final class Formatters {
  static final _moneyFmt = NumberFormat('#,##0.00', 'en_US');
  static final _dateFmt = DateFormat('MMM dd, yyyy');
  static final _dateTimeFmt = DateFormat('MMM dd, yyyy � h:mm a');
  static final _numberFmt = NumberFormat('#,##0', 'en_US');

  static String money(num? value, {String currency = 'USD'}) {
    final n = value ?? 0;
    final sign = n < 0 ? '-' : '';
    final abs = n.abs();
    final symbol = currency == 'USD' ? r'$' : (currency == 'EUR' ? '�' : '$currency ');
    return '$sign$symbol${_moneyFmt.format(abs)}';
  }

  static String date(DateTime? value) => value == null ? '�' : _dateFmt.format(value);

  static String dateTime(DateTime? value) => value == null ? '�' : _dateTimeFmt.format(value);

  static String number(num? value) => value == null ? '�' : _numberFmt.format(value);

  static String percent(num? value) => value == null ? '�' : '$value%';

  static String initials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).take(2);
    return parts.map((p) => p[0]).join().toUpperCase();
  }
}
