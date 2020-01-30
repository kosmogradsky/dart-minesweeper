part of dart_minesweeper;

class CellCoords {
  final int row;
  final int column;

  int get x => column * cellSize + 1;
  int get y => row * cellSize + 1;

  const CellCoords(this.row, this.column);

  bool operator ==(Object to) =>
      to is CellCoords && to.row == row && to.column == column;

  int get hashCode => hash2(row, column);

  int get index => row * boardSize + column;

  BuiltSet<CellCoords> get neighbors {
    var neighbors = <CellCoords>{};

    for (var neighborRow = row - 1; neighborRow <= row + 1; neighborRow++) {
      if (neighborRow < 0 || neighborRow > boardSize) {
        continue;
      }

      for (var neighborColumn = column - 1;
          neighborColumn <= column + 1;
          neighborColumn++) {
        if (neighborColumn < 0 || neighborColumn > boardSize) {
          continue;
        }

        var neighbor = CellCoords(neighborRow, neighborColumn);

        if (neighbor == this) {
          continue;
        }

        neighbors.add(neighbor);
      }
    }

    return neighbors.build();
  }

  String toString() {
    return '($row, $column)';
  }
}
