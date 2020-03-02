import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

listenNum(int num) {
  if (num > 10000) {
    return sprintf('%.1f万', [num / 10000.0]);
  }
  if (num > 100000000) {
    return sprintf('%.1f亿', [num / 100000000.0]);
  }

  return '$num';
}

dateformat(String date){

  var dateTime = DateTime.parse(date);
  return DateFormat('MM-dd').format(dateTime);
}