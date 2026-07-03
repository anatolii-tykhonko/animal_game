import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/ui/game/widgets/type_answer_field.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(home: Scaffold(body: child));

  TypeAnswerField makeField({
    void Function(String)? onSubmit,
    bool isEnabled = true,
    String label = 'Type the animal name:',
    String hint = 'e.g. cat...',
    String checkLabel = 'Check',
  }) =>
      TypeAnswerField(
        onSubmit: onSubmit ?? (_) {},
        isEnabled: isEnabled,
        label: label,
        hint: hint,
        checkLabel: checkLabel,
      );

  group('TypeAnswerField', () {
    testWidgets('shows text field and Check button', (tester) async {
      await tester.pumpWidget(wrap(makeField()));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Check'), findsOneWidget);
    });

    testWidgets('shows label text', (tester) async {
      await tester.pumpWidget(wrap(makeField()));
      expect(find.text('Type the animal name:'), findsOneWidget);
    });

    testWidgets('shows Ukrainian label and check button', (tester) async {
      await tester.pumpWidget(wrap(makeField(
        label: 'Введи назву тварини:',
        checkLabel: 'Перевірити',
      )));
      expect(find.text('Введи назву тварини:'), findsOneWidget);
      expect(find.text('Перевірити'), findsOneWidget);
    });

    testWidgets('calls onSubmit with typed text when Check tapped', (tester) async {
      String? submitted;
      await tester.pumpWidget(wrap(makeField(onSubmit: (t) => submitted = t)));

      await tester.enterText(find.byType(TextField), 'cat');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(submitted, 'cat');
    });

    testWidgets('calls onSubmit when keyboard action triggered', (tester) async {
      String? submitted;
      await tester.pumpWidget(wrap(makeField(onSubmit: (t) => submitted = t)));

      await tester.enterText(find.byType(TextField), 'dog');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(submitted, 'dog');
    });

    testWidgets('Check button is disabled when isEnabled is false', (tester) async {
      await tester.pumpWidget(wrap(makeField(isEnabled: false)));
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('onSubmit not called when disabled and Check tapped', (tester) async {
      bool called = false;
      await tester.pumpWidget(wrap(makeField(
        onSubmit: (_) => called = true,
        isEnabled: false,
      )));
      await tester.tap(find.byType(ElevatedButton), warnIfMissed: false);
      await tester.pump();
      expect(called, isFalse);
    });

    testWidgets('Check button tap target is at least 64px tall', (tester) async {
      await tester.pumpWidget(wrap(makeField()));
      final size = tester.getSize(find.byType(ElevatedButton));
      expect(size.height, greaterThanOrEqualTo(64));
    });
  });
}
