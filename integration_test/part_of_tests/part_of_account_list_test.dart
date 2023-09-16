import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../end_to_end_test.dart';

class AccountListTestParts {
  // Define your global variables here
  static final easyLocalizationWidget = find.byKey(Key('easy_localization__widget_key'));
  static final myAppKey = find.byKey(Key('my_app__key'));
  static final accountsPageKey = find.byKey(Key('accounts_page__key'));
  static final addOrEditButton = find.byKey(Key('add_or_edit__button'));
  static final listFinder = find.byType(Scrollable);

  Future<void> verifyWidgets(WidgetTester tester) async {
    await tester.pumpAndSettle();
    expect(easyLocalizationWidget, findsOneWidget);
    expect(myAppKey, findsOneWidget);
    await addDelay(1000);
    await tester.pumpAndSettle();
    expect(accountsPageKey, findsOneWidget);
    expect(addOrEditButton, findsOneWidget);
    await addDelay(1000);
    await tester.pumpAndSettle();
  }

  int getRandomInteger() {
    int min = 1;
    int max = 40;

    Random random = Random();
    int randomNumber = min + random.nextInt(max - min + 1);
    return randomNumber;
  }

  Future<void> scrollAndEdit(WidgetTester tester) async {
    final randomNumber = getRandomInteger();
    final listItemFinder = find.byKey(Key('account_list_item$randomNumber'));
    final secondListItemFinder = find.byKey(Key('account_list_item${randomNumber + 1}'));

    await tester.scrollUntilVisible(listItemFinder, -500.0, scrollable: listFinder,);

    await addDelay(500);
    await tester.longPress(listItemFinder);
    await addDelay(1000);
    await tester.tap(secondListItemFinder);
    await addDelay(1000);
    await tester.longPress(listItemFinder);
  }

  Future<void> goToEditPage(WidgetTester tester) async {
    expect(addOrEditButton, findsOneWidget);
    await addDelay(1000);
    await tester.tap(addOrEditButton);

    await addDelay(500);
    await tester.pumpAndSettle();
  }
}
