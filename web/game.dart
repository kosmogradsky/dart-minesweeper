part of dart_minesweeper;

class Game {
  BuiltList<Cell> cells;
  final CanvasRenderingContext2D context;

  Game(this.context, this.cells);

  Cell operator [](CellCoords coords) {
    return cells[coords.index];
  }

  void operator []=(CellCoords coords, Cell cell) {
    cells = cells.rebuild((prevCells) {
      prevCells[coords.index] = cell;
    });
  }

  void run() {
    for (var cell in cells) {
      cell.render(context);
    }

    window.animationFrame.then((num time) {
      run();
    });
  }
}
