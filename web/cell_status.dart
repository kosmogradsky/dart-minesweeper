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

class Flag implements CellStatus {
  final bool isRevealed = true;

  void render(CellCoords coords, CellContent content,
      CanvasRenderingContext2D context) {
    context.beginPath();
    context.moveTo(coords.x + cellSize * 0.3, coords.y + cellSize * 0.2);
    context.lineTo(coords.x + cellSize * 0.7, coords.y + cellSize * 0.35);
    context.lineTo(coords.x + cellSize * 0.3, coords.y + cellSize * 0.5);
    context.fillStyle = 'red';
    context.fill();

    context.beginPath();
    context.moveTo(coords.x + cellSize * 0.3, coords.y + cellSize * 0.2);
    context.lineTo(coords.x + cellSize * 0.3, coords.y + cellSize * 0.8);
    context.stroke();
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
