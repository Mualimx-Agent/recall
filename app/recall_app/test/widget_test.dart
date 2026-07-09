// Basic widget smoke test for Recall.
import 'package:flutter_test/flutter_test.dart';
import 'package:recall_app/main.dart';

void main() {
  testWidgets('Recall app starts and shows onboarding', (tester) async {
    await tester.pumpWidget(const RecallApp());
    await tester.pump();
    expect(find.text('Recall'), findsWidgets);
  });
}
