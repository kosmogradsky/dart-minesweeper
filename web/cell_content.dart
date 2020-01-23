part of dart_minesweeper;

abstract class CellContent {
  factory CellContent(CellCoords coords, Iterable<CellCoords> fieldBombs) {
    if (fieldBombs.contains(coords)) {
      return Mine();
    }

    var bombsAround = fieldBombs.fold<int>(0, (count, bomb) {
      if ({coords.row - 1, coords.row, coords.row + 1}.contains(bomb.row)) {
        if ({coords.column - 1, coords.column, coords.column + 1}
            .contains(bomb.column)) {
          return count + 1;
        }
      }

      return count;
    });

    return Hint(bombsAround);
  }

  bool get revealsCellsAround;

  void render(CellCoords coords, CanvasRenderingContext2D context);
}

class Hint implements CellContent {
  final int bombsAround;
  const Hint(this.bombsAround);

  bool get revealsCellsAround => bombsAround == 0;

  void render(CellCoords coords, CanvasRenderingContext2D context) {
    if (bombsAround != 0) {
      context.fillStyle = 'black';
      context.font = '400 ${cellSize ~/ 1.3}px sans-serif';
      context.fillText(bombsAround.toString(), coords.x + cellSize * 0.25,
          coords.y + cellSize * 0.75);
    }
  }
}

class Mine implements CellContent {
  const Mine();

  final revealsCellsAround = false;

  void render(CellCoords coords, CanvasRenderingContext2D context) {
    context.fillStyle = 'gray';
    context.beginPath();
    context.arc(coords.x + cellSize / 2, coords.y + cellSize / 2, cellSize / 4,
        0, 2 * pi);
    context.fill();
    context.stroke();
  }
}
