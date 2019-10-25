import 'package:meta/meta.dart';

@immutable
class BankAccount {
  final String id;
  final String name;
  final double balance;

  BankAccount({@required this.id, @required this.name, @required this.balance});
}