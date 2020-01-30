part of dart_minesweeper;

abstract class CellStatus {
  bool get isRevealed;

  void render(
      CellCoords coords, CellContent content, CanvasRenderingContext2D context);
}

class Hidden implements CellStatus {
  final bool isRevealed = false;

  void render(CellCoords coords, CellContent content,
      CanvasRenderingContext2D context) {
    context.fillStyle = 'white';
    context.fillRect(coords.x, coords.y, cellSize, cellSize);
  }
}

class Revealed implements CellStatus {
  final bool isRevealed = true;

  void render(CellCoords coords, CellContent content,
      CanvasRenderingContext2D context) {
    context.fillStyle = 'lightgray';
    context.fillRect(coords.x, coords.y, cellSize, cellSize);

    content.render(coords, context);
  }
}
