import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neyasis/accounts/accounts.dart';
import 'package:neyasis/utils/extensions.dart';

import '../../edit_account/widget/account_text_field.dart';

class AddAccountsPage extends StatefulWidget {
  const AddAccountsPage({super.key});

  @override
  State<AddAccountsPage> createState() => _AddAccountsPageState();
}

late TextEditingController _nameController;
late TextEditingController _surnameController;
late TextEditingController _birthdateController;
late TextEditingController _salaryController;
late TextEditingController _phoneNumberController;
late TextEditingController _identityController;
final _formKey = GlobalKey<FormState>();

class _AddAccountsPageState extends State<AddAccountsPage> {
  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _birthdateController = TextEditingController();
    _salaryController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _identityController = TextEditingController();
    super.initState();
  }

  String? _validateBirthDate(String? datetime) {
    try {
      DateTime.parse(_birthdateController.text);
      return null;
    } catch (_) {
      return "birthdate_error".tr();
    }
  }

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) return "name_error".tr();
    return null;
  }

  String? _validateSurname(String? surname) {
    if (surname == null || surname.isEmpty) return "surname_error".tr();
    return null;
  }

  String? _validateSalary(String? salary) {
    if (salary == null || salary.isEmpty) return "salary_error".tr();
    return null;
  }

  String? _validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) return "phone_number_error".tr();
    return null;
  }

  String? _validateIdentity(String? identity) {
    if (identity != null && identity.isNotEmpty && identity.isValidTC()) {
      return null;
    } else {
      return "identity_error".tr();
    }
  }
  Future<void> _createAccount(BuildContext context) async {
    final newAccount = Account(
      name: _nameController.text,
      surname: _surnameController.text,
      birthdate: DateTime.parse(_birthdateController.text),
      salary: double.parse(_salaryController.text.isEmpty ? "0" : _salaryController.text),
      phoneNumber: _phoneNumberController.text,
      identity: _identityController.text,
    );

    BlocProvider.of<AccountBloc>(context).add(AccountPostEvent(account: newAccount));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context1) {
    return BlocConsumer<AccountBloc, AccountState>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('create_accounts_title').tr(),
            actions: [
              CupertinoButton(
                  child: Text(
                    "create_button",
                    style: TextStyle(color: Colors.red),
                  ).tr(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _createAccount(context);
                    }
                    ;
                  })
            ],
          ),
          body: _buildFormContent(),
        );
      },
    );
  }

  Widget _buildFormContent() {
    final fields = [
      // You can make this as a separate object if needed for cleaner representation
      {"controller": _nameController, "hint": "name_example".tr(), "label": "enter_name".tr(), "validator": _validateName},
      {"controller": _surnameController, "hint": "surname_example".tr(), "label": "enter_surname".tr(), "validator": _validateSurname},
      {"controller": _birthdateController, "hint": "birthdate_example".tr(), "label": "enter_birthdate".tr(), "validator": _validateBirthDate},
      {"controller": _salaryController, "hint": "salary_example".tr(), "label": "enter_salary".tr(), "validator": _validateSalary},
      {"controller": _phoneNumberController, "hint": "phone_number_example".tr(), "label": "enter_phone_number".tr(), "validator":
      _validatePhoneNumber},
      {"controller": _identityController, "hint": "identity_example".tr(), "label": "enter_identity".tr(), "validator": _validateIdentity},
    ];

    return Form(
      key: _formKey,
      child: ListView(
        children: fields
            .map((field) => AccountTextField(
          controller: field["controller"] as TextEditingController,
          hintText: field["hint"] as String,
          labelText: field["label"] as String,
          validator: field["validator"] as String? Function(String?)?,
          onChanged: (value) {
            return value;
          },
        ))
            .toList(),
      ),
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthdateController.dispose();
    _salaryController.dispose();
    _phoneNumberController.dispose();
    _identityController.dispose();
    super.dispose();
  }
}
