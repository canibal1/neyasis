import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../end_to_end_test.dart';

class DeleteAccountTestParts {
  // Define your global variables here
  static final fullName = find.text("Osman Furkan Güney");
  static final infoText = find.text("905443553324 - 96402590218");
  static final deleteButton = find.byKey(Key("delete__button"));

  Future<void> delete(WidgetTester tester) async {
    expect(fullName, findsOneWidget);
    expect(infoText, findsOneWidget);

    await tester.longPress(fullName);
    await addDelay(1000);
    await tester.tap(deleteButton);
    await addDelay(1000);

    await tester.pumpAndSettle();
    await addDelay(1000);

    expect(fullName, findsNothing);
    expect(infoText, findsNothing);
  }
}
