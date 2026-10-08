import 'package:flutter_test/flutter_test.dart';
import 'package:imp_app/main.dart';

void main() {
  testWidgets('App opens on tablet setup', (tester) async {
    await tester.pumpWidget(const ImpApp());
    expect(find.text('Set up this tablet'), findsOneWidget);
  });
}
