import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neyasis/accounts/bloc/account_bloc.dart';
import 'package:neyasis/accounts/view/add_account_page.dart';
import 'accounts/view/accounts_page.dart';
import 'constants/pages.dart';
import 'edit_account/bloc/edit_account_bloc.dart';
import 'edit_account/view/edit_accont_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required AccountBloc accountBloc,
    required EditAccountBloc editAccountBloc,
  })  : _accountBloc = accountBloc,
        _editAccountBloc = editAccountBloc;

  final AccountBloc _accountBloc;
  final EditAccountBloc _editAccountBloc;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neyasis',
      initialRoute: '/',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: {
        PageRouth.accountListPage: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _accountBloc),
                BlocProvider.value(value: _editAccountBloc),
              ],
              child: const AccountsPage(key:Key("accounts_page__key")),
            ),
        PageRouth.addAccountPage: (context) => BlocProvider.value(
              value: _accountBloc,
              child: const AddAccountsPage(),
            ),
        PageRouth.editAccountPage: (context) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _accountBloc),
                BlocProvider.value(value: _editAccountBloc),
              ],
              child: EditAccountsPage(),
            )
      },
    );
  }
}
