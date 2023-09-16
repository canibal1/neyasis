import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:neyasis/accounts/bloc/account_bloc.dart';
import 'package:neyasis/app.dart';
import 'package:neyasis/simple_bloc_observer.dart';
import 'package:neyasis/utils/http_client.dart';
import 'edit_account/bloc/edit_account_bloc.dart';

 String environment = "";

Future<void> main() async {
  Bloc.observer = const SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final _accountBloc = AccountBloc(httpClient: HttpClient());
  final _editAccountBloc = EditAccountBloc();
  FlutterNativeSplash.remove();

  runApp(
    EasyLocalization(
      key: Key("easy_localization__widget_key"),
      supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations',
      startLocale: environment == "test" ? Locale('en', 'US') : null,
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(
        key: Key("my_app__key"),
        accountBloc: _accountBloc,
        editAccountBloc: _editAccountBloc,
      ),
    ),
  );
}
