part of dart_minesweeper;

class Game {
  BuiltList<Cell> cells;
  final CanvasRenderingContext2D context;

  Game(this.context, this.cells);

  void run() {
    for (var cell in cells) {
      cell.render(context);
    }

    window.animationFrame.then((num time) {
      run();
    });
  }
}
