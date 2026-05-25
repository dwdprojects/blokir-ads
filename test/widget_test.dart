import 'package:flutter_test/flutter_test.dart';
import 'package:blokir_ads/app.dart';
import 'package:blokir_ads/di/injection_container.dart';

void main() {
  setUpAll(() async {
    await initDependencies();
  });

  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
  });
}
