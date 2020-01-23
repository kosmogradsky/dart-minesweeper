part of dart_minesweeper;

abstract class CellStatus {
  void render(
      CellCoords coords, CellContent content, CanvasRenderingContext2D context);
}

class Hidden implements CellStatus {
  void render(CellCoords coords, CellContent content,
      CanvasRenderingContext2D context) {
    context.fillStyle = 'white';
    context.fillRect(coords.x, coords.y, cellSize, cellSize);
  }
}

class Revealed implements CellStatus {
  void render(CellCoords coords, CellContent content,
      CanvasRenderingContext2D context) {
    context.fillStyle = 'lightgray';
    context.fillRect(coords.x, coords.y, cellSize, cellSize);

    content.render(coords, context);
  }
}
