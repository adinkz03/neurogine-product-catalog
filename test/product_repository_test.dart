import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:product_catalog_app/data/repositories/product_repository.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ProductRepository Unit Tests', () {
    test('returns ProductResponse when http call succeeds (200)', () async {
      final client = MockClient();
      final repository = ProductRepository(client: client);

      const jsonResponse = '''
      {
        "products": [
          {
            "id": 1,
            "title": "Essence Mascara Lash Princess",
            "description": "Popular mascara",
            "price": 9.99,
            "rating": 4.94,
            "thumbnail": "https://dummyjson.com/thumb.png",
            "images": []
          }
        ],
        "total": 100,
        "skip": 0,
        "limit": 20
      }
      ''';

      when(
        client.get(Uri.parse('https://dummyjson.com/products?limit=20&skip=0')),
      ).thenAnswer((_) async => http.Response(jsonResponse, 200));

      final result = await repository.fetchProducts(limit: 20, skip: 0);

      expect(result.products.length, 1);
      expect(result.products.first.title, 'Essence Mascara Lash Princess');
      expect(result.total, 100);
    });

    test('throws Exception when http call fails (404)', () {
      final client = MockClient();
      final repository = ProductRepository(client: client);

      when(
        client.get(Uri.parse('https://dummyjson.com/products?limit=20&skip=0')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(repository.fetchProducts(limit: 20, skip: 0), throwsException);
    });
  });
}
