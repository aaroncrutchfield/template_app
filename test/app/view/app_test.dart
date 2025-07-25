import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/app/app.dart';
import 'package:template_app/counter/counter.dart';
import 'package:template_app/injection.dart';

void main() {
  group('App', () {
    setUp(() {
      getIt.reset();
      configureDependencies();
    });

    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      expect(find.byType(CounterView), findsOneWidget);
    });
  });
}
