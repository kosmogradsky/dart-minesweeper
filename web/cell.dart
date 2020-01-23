part of dart_minesweeper;

class Cell {
  final CellCoords coords;
  final CellStatus status;
  final CellContent content;

  const Cell(this.coords, this.status, this.content);

  void render(CanvasRenderingContext2D context) {
    status.render(coords, content, context);

    context.strokeStyle = 'black';
    context.lineWidth = 1;
    context.strokeRect(coords.x, coords.y, cellSize, cellSize);
  }
}
