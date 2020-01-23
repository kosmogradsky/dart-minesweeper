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
}
