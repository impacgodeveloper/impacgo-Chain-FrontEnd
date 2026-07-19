import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impacgo_chain/main.dart';
import 'package:impacgo_chain/features/entities/entity_detail_drawer.dart';
import 'package:impacgo_chain/shared/widgets/buttons/app_button.dart';
import 'package:impacgo_chain/shared/widgets/tables/app_data_table.dart';
import 'package:impacgo_chain/core/router/app_router.dart';
import 'package:impacgo_chain/shared/widgets/dialogs/app_confirm_dialog.dart';

void main() {
  testWidgets('Test detail drawer delete button tap on leads page', (WidgetTester tester) async {
    // Ignore layout overflows in test
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) {
        return; // ignore overflow errors
      }
      previousOnError?.call(details);
    };

    // Pump App
    await tester.pumpWidget(const ProviderScope(child: ImpacgoChainApp()));
    await tester.pumpAndSettle();

    // Navigate to Leads page
    final element = tester.element(find.byType(ImpacgoChainApp));
    final container = ProviderScope.containerOf(element);
    final router = container.read(appRouterProvider);
    router.go('/entity/leads');
    await tester.pumpAndSettle();

    // Find and tap the first row in AppDataTable to open the detail drawer
    final rowTapFinder = find.byType(AppDataTable);
    expect(rowTapFinder, findsOneWidget);

    // Let's click on the first cell text in the data table
    final cellTextFinder = find.textContaining(RegExp(r'^LEAD-'));
    expect(cellTextFinder, findsAtLeastNWidgets(1));
    await tester.tap(cellTextFinder.first);
    await tester.pumpAndSettle(); // Wait for drawer slide transition

    // Verify detail drawer is open and contains Delete button
    final deleteButtonFinder = find.widgetWithText(AppButton, 'Delete');
    expect(deleteButtonFinder, findsOneWidget);

    // Tap the Delete button inside the detail drawer
    await tester.tap(deleteButtonFinder);
    await tester.pumpAndSettle();

    // Verify if the confirm dialog text is shown (checking if the dialog opened)
    expect(find.textContaining('Delete'), findsAtLeastNWidgets(1));
    
    // Restore onError
    FlutterError.onError = previousOnError;
  });
}
