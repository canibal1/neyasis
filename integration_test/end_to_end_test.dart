import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:neyasis/app.dart';
import 'package:neyasis/main.dart' as neyasis;

void main() {
  testWidgets('tap on the floating action button, verify counter', (tester) async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Login Page Test', (WidgetTester tester) async {

      neyasis.main();
    });
  });
}
