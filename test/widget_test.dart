import 'package:flutter_test/flutter_test.dart';

import 'package:chat_app/main.dart';

void main() {
  testWidgets('Firebase setup screen explains required configuration',
      (tester) async {
    await tester.pumpWidget(
        const FirebaseSetupApp(message: 'Missing platform options'));

    expect(find.text('Firebase setup required'), findsOneWidget);
    expect(
        find.text(
            'Add the Firebase configuration for this app, then restart it.'),
        findsOneWidget);
    expect(find.text('Missing platform options'), findsOneWidget);
  });

  testWidgets('unsupported Firebase platform shows a visible explanation',
      (tester) async {
    await tester.pumpWidget(
      const FirebaseSetupApp(
        title: 'Firebase unavailable on this platform',
        description:
            'Run the app on Android or iOS, or configure Firebase for this platform.',
        message: 'Linux Firebase options are missing',
      ),
    );

    expect(find.text('Firebase unavailable on this platform'), findsOneWidget);
    expect(find.text('Linux Firebase options are missing'), findsOneWidget);
  });
}
