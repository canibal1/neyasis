import 'package:equatable/equatable.dart';

// final class Account extends Equatable {
//   const Account(
//       {required this.id,
//       required this.name,
//       required this.surname,
//       required this.birthdate,
//       required this.salary,
//       required this.phoneNumber,
//       required this.identity});
//
//   final int id;
//   final String name;
//   final String surname;
//   final String birthdate;
//   final String salary;
//   final String phoneNumber;
//   final String identity;
//
//   @override
//   List<Object> get props => [id, name, surname, birthdate, salary, phoneNumber, identity];
// }

// To parse this JSON data, do
//
//     final account = accountFromJson(jsonString);

import 'dart:convert';

Account accountFromJson(String str) => Account.fromJson(json.decode(str));

String accountToJson(Account data) => json.encode(data.toJson());

class Account extends Equatable{
  final String? name;
  final String? surname;
  final DateTime? birthdate;
  final double? salary;
  final String? phoneNumber;
  final String? identity;
  final String? id;

  const Account({
    this.name,
    this.surname,
    this.birthdate,
    this.salary,
    this.phoneNumber,
    this.identity,
    this.id,
  });

  Account copyWith({
    String? name,
    String? surname,
    DateTime? birthdate,
    double? salary,
    String? phoneNumber,
    String? identity,
    String? id,
  }) =>
      Account(
        name: name ?? this.name,
        surname: surname ?? this.surname,
        birthdate: birthdate ?? this.birthdate,
        salary: salary ?? this.salary,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        identity: identity ?? this.identity,
        id: id ?? this.id,
      );

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    name: json["name"],
    surname: json["surname"],
    birthdate: json["birthdate"] == null ? null : DateTime.parse(json["birthdate"]),
    salary: json["salary"]?.toDouble(),
    phoneNumber: json["phoneNumber"],
    identity: json["identity"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "surname": surname,
    "birthdate": birthdate.toString(),
    "salary": salary,
    "phoneNumber": phoneNumber,
    "identity": identity,
    "id": id,
  };
  @override
  List<Object> get props => [id??"", name??"", surname??"", birthdate??"", salary??"", phoneNumber??"", identity??""];

}
