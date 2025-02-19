import 'package:intl/intl.dart';

decimal(String harga){
  final numberFormat=NumberFormat.decimalPattern("id");
  return numberFormat.format(int.parse(
    harga
  ));
  
}