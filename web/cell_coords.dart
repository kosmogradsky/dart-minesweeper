part of dart_minesweeper;

class CanvasCoords {
  final int clientLeft;
  final int clientTop;
  final Rectangle<num> rect;

  const CanvasCoords(this.clientLeft, this.clientTop, this.rect);
}

class CellCoords {
  final int row;
  final int column;

  int get x => column * cellSize + 1;
  int get y => row * cellSize + 1;

  const CellCoords(this.row, this.column);

  factory CellCoords.fromMouseEvent(
      MouseEvent event, CanvasCoords canvasCoords) {
    var clickX =
        (event.client.x - canvasCoords.rect.left - canvasCoords.clientLeft)
            .clamp(0, canvasSize);
    var clickY =
        (event.client.y - canvasCoords.rect.top - canvasCoords.clientTop)
            .clamp(0, canvasSize);

    return CellCoords(clickY ~/ cellSize, clickX ~/ cellSize);
  }

  bool operator ==(Object to) =>
      to is CellCoords && to.row == row && to.column == column;

  int get hashCode => hash2(row, column);

  int get index => row * boardSize + column;

  BuiltSet<CellCoords> get neighbors {
    var neighbors = <CellCoords>{};

    for (var neighborRow = row - 1; neighborRow <= row + 1; neighborRow++) {
      if (neighborRow < 0 || neighborRow > boardSize - 1) {
        continue;
      }

      for (var neighborColumn = column - 1;
          neighborColumn <= column + 1;
          neighborColumn++) {
        if (neighborColumn < 0 || neighborColumn > boardSize - 1) {
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
