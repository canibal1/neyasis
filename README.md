# neyasis

#You can open the app with this commands:

flutter run  --flavor prod --target ../neyasis/lib/main.dart 
flutter run  --flavor uat --target ../neyasis/lib/main.dart 
flutter run  --flavor ftest --target ../neyasis/lib/main.dart

You can test the application end-to-end with integration test with the following command:

flutter test --flavor ftest integration_test/end_to_end_test.dart