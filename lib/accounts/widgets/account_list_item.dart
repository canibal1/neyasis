import 'package:flutter/material.dart';
import 'package:neyasis/accounts/accounts.dart';

class AccountListItem extends StatelessWidget {
  const AccountListItem({required this.account, super.key});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('${account.id}'),
      title: Text((account.name ?? "") + " " + (account.surname ?? "")),
      isThreeLine: true,
      subtitle: Text((account.phoneNumber ?? "") + " - " + (account.identity ?? "")),
      dense: true,
    );
  }
}
