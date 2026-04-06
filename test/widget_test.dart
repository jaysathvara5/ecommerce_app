import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/main.dart';

void main() {  testWidgets('App load test', (WidgetTester tester) async {
  await tester.pumpWidget(const MyEcommerceApp());
  expect(find.text('Apni Dukaan'), findsOneWidget);
});
}