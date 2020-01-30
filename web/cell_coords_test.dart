import 'package:test/test.dart';
import 'package:built_collection/built_collection.dart';

import 'main.dart';

void main() {
  group('CellCoords', () {
    test('correctly finds neighbors for cornered cell', () {
      const coords = CellCoords(0, 0);

      var expected =
          {CellCoords(1, 1), CellCoords(0, 1), CellCoords(1, 0)}.build();

      expect(coords.neighbors, equals(expected));
    });

    test('correctly finds neighbors for non-cornered cell', () {
      const coords = CellCoords(5, 5);

      var expected = {
        CellCoords(4, 4),
        CellCoords(4, 5),
        CellCoords(4, 6),
        CellCoords(5, 4),
        CellCoords(5, 6),
        CellCoords(6, 4),
        CellCoords(6, 5),
        CellCoords(6, 6),
      }.build();

      expect(coords.neighbors, equals(expected));
    });
  });
}
