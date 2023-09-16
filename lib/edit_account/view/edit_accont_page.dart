import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neyasis/accounts/accounts.dart';
import 'package:neyasis/utils/extensions.dart';

import '../../edit_account/widget/account_text_field.dart';
import '../bloc/edit_account_bloc.dart';

class EditAccountsPage extends StatefulWidget {
  const EditAccountsPage({Key? key}) : super(key: key);

  @override
  _EditAccountsPageState createState() => _EditAccountsPageState();
}

class _EditAccountsPageState extends State<EditAccountsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _identityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String accountId = "";

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

  Future<void> _editAccount(BuildContext context) async {
    final newAccount = Account(
        name: _nameController.text,
        surname: _surnameController.text,
        birthdate: DateTime.parse(_birthdateController.text),
        salary: double.parse(_salaryController.text.isEmpty ? "0" : _salaryController.text),
        phoneNumber: _phoneNumberController.text,
        identity: _identityController.text,
        id: accountId);

    BlocProvider.of<AccountBloc>(context).add(AccountEditEvent(account: newAccount));
    Navigator.pop(context);
  }

  _initEditPage(EditAccountState state) {
    _nameController.text = state.account.name ?? "";
    _surnameController.text = state.account.surname ?? "";
    _birthdateController.text = state.account.birthdate.toString();
    _salaryController.text = (state.account.salary ?? 0.0).toString();
    _phoneNumberController.text = state.account.phoneNumber ?? "";
    _identityController.text = state.account.identity ?? "";
    accountId = state.account.id ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      builder: (context, state) {
        if (state.status == EditAccountStatus.initial) {
          _initEditPage(state);
          BlocProvider.of<EditAccountBloc>(context).add(
            EditAccountChangeStatusEvent(status: EditAccountStatus.ready),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('edit_accounts_title').tr(),
            actions: [
              BlocBuilder<AccountBloc, AccountState>(
                builder: (BuildContext contextAccount, Object? state) => CupertinoButton(
                  key: Key("edit_page__done_button"),
                  child: const Text("done_button", style: TextStyle(color: Colors.red)).tr(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _editAccount(contextAccount);
                      BlocProvider.of<EditAccountBloc>(context).add(
                        EditAccountChangeStatusEvent(status: EditAccountStatus.initial),
                      );
                    }
                  },
                ),
              )
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
      {
        "key": "enter_name__key",
        "controller": _nameController,
        "hint": "name_example".tr(),
        "label": "enter_name".tr(),
        "validator": _validateName,
      },
      {
        "key": "enter_surname__key",
        "controller": _surnameController,
        "hint": "surname_example".tr(),
        "label": "enter_surname".tr(),
        "validator": _validateSurname
      },
      {
        "key": "enter_birthdate__key",
        "controller": _birthdateController,
        "hint": "birthdate_example".tr(),
        "label": "enter_birthdate".tr(),
        "validat"
            "or": _validateBirthDate
      },
      {
        "key": "enter_salary__key",
        "controller": _salaryController,
        "hint": "salary_example".tr(),
        "label": "enter_salary".tr(),
        "validator": _validateSalary
      },
      {
        "key": "enter_phone_number__key",
        "controller": _phoneNumberController,
        "hint": "phone_number_example".tr(),
        "label": "enter_phone_number".tr(),
        ""
            "validator": _validatePhoneNumber
      },
      {
        "key": "enter_identity__key",
        "controller": _identityController,
        "hint": "identity_example".tr(),
        "label": "enter_identity".tr(),
        "validator": _validateIdentity
      },
    ];

    return Form(
      key: _formKey,
      child: ListView(
        key: Key("edit_account_page__listview_key"),
        children: fields
            .map((field) => AccountTextField(
                  textFieldKey: Key("${field["key"] as String}"),
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
