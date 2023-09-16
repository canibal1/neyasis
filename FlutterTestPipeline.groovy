pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Check out your Flutter app repository
                git branch: "development", url: 'https://github.com/canibal1/neyasis'
            }
        }

        stage('Package Clean & Update') {
            steps {
                sh 'flutter pub cache clean -f'
                sh 'sudo rm -Rf /var/lib/jenkins/.pub-cache/*'
                sh 'flutter pub get'
            }
        }

        stage('Build and Test UAT Flavor') {
            steps {
                script {
                    // Install Flutter dependencies
                    sh 'flutter pub get'

                    // Build and run the app with the uat flavor
                    sh 'flutter run --flavor uat --target ../neyasis/lib/main.dart'

                    // Run integration tests for the uat flavor
                    sh 'flutter test --flavor uat integration_test/end_to_end_test.dart'
                }
            }
        }

        stage('Build and Test FTest Flavor') {
            steps {
                script {
                    // Install Flutter dependencies
                    sh 'flutter pub get'

                    // Build and run the app with the ftest flavor
                    sh 'flutter run --flavor ftest --target ../neyasis/lib/main.dart'

                    // Run integration tests for the ftest flavor
                    sh 'flutter test --flavor ftest integration_test/end_to_end_test.dart'
                }
            }
        }
        stage('Build and Test Prod Flavor') {
            steps {
                script {
                    // Install Flutter dependencies
                    sh 'flutter pub get'

                    // Build and run the app with the prod flavor
                    sh 'flutter run --flavor prod --target ../neyasis/lib/main.dart'

                    // Run integration tests for the prod flavor
                    sh 'flutter test --flavor prod integration_test/end_to_end_test.dart'
                }
            }
        }
    }
}
