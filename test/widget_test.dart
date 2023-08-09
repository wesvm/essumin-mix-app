import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:essumin_mix/ui/screens/acronyms/acronyms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Widget should not show CustomAppBar when keyboard is covering',
      (WidgetTester tester) async {
    final data = List.generate(
        10, (index) => Sigla('key test $index', 'value test $index'));
    await tester.pumpWidget(MaterialApp(
        home: AcronymsScreen(
      data: data,
      isRandom: false,
      startIndex: 1,
      endIndex: 5,
      rangeOption: 5,
    )));

    await tester.binding.setSurfaceSize(const Size(800, 1000));

    await tester.pumpAndSettle();

    // Simular el teclado
    await tester.showKeyboard(find.byType(TextField));
    await tester.pumpAndSettle();

    // Cerrar el teclado simulado
    tester.testTextInput.hide();
  });
}
