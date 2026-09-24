import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_app/data/repositories/product_repository.dart';
import 'package:product_catalog_app/presentation/providers/product_provider.dart';
import 'package:product_catalog_app/main.dart';

void main() {
  testWidgets('App renders correctly test', (WidgetTester tester) async {
    final repository = ProductRepository();
    final provider = ProductProvider(repository: repository);

    await tester.pumpWidget(MyApp(productProvider: provider));
    expect(find.text('Product Catalog'), findsOneWidget);
  });
}
