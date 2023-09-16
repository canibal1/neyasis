import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:neyasis/accounts/view/add_account_page.dart';
import 'package:neyasis/main.dart' as neyasis;

import 'part_of_tests/part_of_account_list_test.dart';
import 'part_of_tests/part_of_add_account_test.dart';
import 'part_of_tests/part_of_delete_account_test.dart';
import 'part_of_tests/part_of_edit_account_test.dart';

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

Future<void> runAppAndDelay() async {
  neyasis.main();
  await addDelay(1000);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  AccountListTestParts accountList = AccountListTestParts();
  EditAccountTestParts editAccount = EditAccountTestParts();
  DeleteAccountTestParts deleteAccount = DeleteAccountTestParts();
  AddAccountTestParts addAccount = AddAccountTestParts();
  setUpAll(() {
    neyasis.environment = "test";
  });

  testWidgets('tap on the floating action button, verify counter', (tester) async {
    await runAppAndDelay();
    await accountList.verifyWidgets(tester);
    await addAndDeleteAccountScenario(addAccount, tester, deleteAccount);
    await editAndDeleteScenario(accountList, tester, editAccount, deleteAccount);
  });
}

Future<void> editAndDeleteScenario(
  AccountListTestParts accountList,
  WidgetTester tester,
  EditAccountTestParts editAccount,
  DeleteAccountTestParts deleteAccount,
) async {
  await accountList.scrollAndEdit(tester);
  await accountList.goToEditPage(tester);
  await editAccount.enterName(tester);
  await editAccount.enterSurname(tester);
  await editAccount.enterAndValidateBirthdate(tester);
  await editAccount.enterSalaryTest(tester);
  await editAccount.enterPhoneNumberTest(tester);
  await editAccount.enterIdentityTest(tester);
  await editAccount.goToAccountPage(tester);
  await editAccount.editCompleteTestScenario(tester);
  await deleteAccount.delete(tester);
}

Future<void> addAndDeleteAccountScenario(
  AddAccountTestParts addAccount,
  WidgetTester tester,
  DeleteAccountTestParts deleteAccount,
) async {
  await addAccount.goToAddAccountPage(tester);
  await addAccount.enterName(tester);
  await addAccount.enterSurname(tester);
  await addAccount.enterAndValidateBirthdate(tester);
  await addAccount.enterSalaryTest(tester);
  await addAccount.enterPhoneNumberTest(tester);
  await addAccount.enterIdentityTest(tester);
  await addAccount.goToAccountPage(tester);
  await addAccount.addCompleteTestScenario(tester);

  await deleteAccount.delete(tester);
}
