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

  static BuiltSet<CellCoords> getNeighbors(CellCoords coords) {
    var neighbors = <CellCoords>{};

    for (var row = coords.row - 1; row < coords.row + 1; row++) {
      if (row < 0 || row > boardSize) {
        continue;
      }

      for (var column = coords.column - 1;
          column < coords.column + 1;
          column++) {
        if (column < 0 || column > boardSize) {
          continue;
        }

        var neighbor = CellCoords(row, column);

        if (neighbor == coords) {
          continue;
        }

        neighbors.add(neighbor);
      }
    }

    return neighbors.build();
  }
}
