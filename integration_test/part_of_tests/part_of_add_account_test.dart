import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../end_to_end_test.dart';

class AddAccountTestParts {
  // Define your global variables here
  static final addPageButton = find.byKey(Key("add_or_edit__button"));
  static final enterNameTextField = find.byKey(Key("enter_name__key"));
  static final enterSurnameTextField = find.byKey(Key("enter_surname__key"));
  static final enterBirthdateTextField = find.byKey(Key("enter_birthdate__key"));
  static final createPageDoneButton = find.byKey(Key("create_account__button"));
  static final birthDayError = find.text("Please enter valid a birthdate");
  static final enterSalaryTextField = find.byKey(Key("enter_salary__key"));
  static final enterPhoneNumberTextField = find.byKey(Key("enter_phone_number__key"));
  static final enterIdentityTextField = find.byKey(Key("enter_identity__key"));
  static final accountListWidget = find.byKey(Key("account_list__key"));
  static final expectedName = find.text("Osman Furkan");
  static final expectedSurname = find.text("Güney");
  static final expectedBirthdate = find.text("1997-12-12");
  static final expectedIdentity = find.text("96402590218");
  static final expectedSalary = find.text("300000");
  static final expectedPhoneNumber = find.text("905443553324");
  static final listFinder = find.byType(Scrollable);

  Future<void> goToAddAccountPage(WidgetTester tester) async {
    expect(addPageButton, findsOneWidget);
    await addDelay(1000);
    await tester.tap(addPageButton);

    await addDelay(1000);
    await tester.pumpAndSettle();
  }

  Future<void> enterName(WidgetTester tester) async {
    expect(enterNameTextField, findsOneWidget);

    await addDelay(1000);
    await tester.tap(enterNameTextField);
    await tester.enterText(enterNameTextField, "Osman Furkan");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await addDelay(1000);
    expect(expectedName, findsOneWidget);
    await tester.pump();
  }

  Future<void> enterSurname(WidgetTester tester) async {
    expect(enterSurnameTextField, findsOneWidget);

    await addDelay(1000);
    await tester.tap(enterSurnameTextField);
    await tester.enterText(enterSurnameTextField, "Güney");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(expectedSurname, findsOneWidget);
    await tester.pump();
  }

  Future<void> enterAndValidateBirthdate(WidgetTester tester) async {
    expect(enterBirthdateTextField, findsOneWidget);

    await tester.tap(enterBirthdateTextField);

    await tester.enterText(enterBirthdateTextField, "1997-12-12");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await addDelay(1000);

    expect(expectedBirthdate, findsOneWidget);

    await tester.tap(createPageDoneButton);
    await addDelay(1000);
  }

  Future<void> enterSalaryTest(WidgetTester tester) async {
    expect(enterSalaryTextField, findsOneWidget);

    await addDelay(1000);
    await tester.tap(enterSalaryTextField);
    await tester.enterText(enterSalaryTextField, "300000");
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(expectedSalary, findsOneWidget);
  }

  Future<void> enterPhoneNumberTest(WidgetTester tester) async {
    await addDelay(1000);
    expect(enterPhoneNumberTextField, findsOneWidget);
    await tester.tap(enterPhoneNumberTextField);
    await tester.enterText(enterPhoneNumberTextField, "905443553324");
    await addDelay(1000);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await addDelay(1000);

    expect(expectedPhoneNumber, findsWidgets);
  }

  Future<void> enterIdentityTest(WidgetTester tester) async {
    expect(enterIdentityTextField, findsOneWidget);
    await tester.tap(enterIdentityTextField);
    await tester.enterText(enterIdentityTextField, "96402590218");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(expectedIdentity, findsOneWidget);

    await tester.pumpAndSettle();
    await addDelay(3000);
  }

  Future<void> goToAccountPage(WidgetTester tester) async {
    await tester.tap(createPageDoneButton);
    await addDelay(1000);
    await tester.pumpAndSettle();
  }

  Future<void> addCompleteTestScenario(WidgetTester tester) async {
    await addDelay(1000);
    expect(accountListWidget, findsWidgets);
    await tester.scrollUntilVisible(find.text("Osman Furkan Güney"), 500.0, scrollable: listFinder);
    expect(find.text("905443553324 - 96402590218"), findsWidgets);
  }
}
