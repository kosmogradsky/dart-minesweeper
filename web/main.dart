import 'dart:html';
import 'dart:math';

class Cell {
  final int row;
  final int column;
  final bool isExplosive;
  const Cell(this.row, this.column, this.isExplosive);
}

const boardSize = 20;
const cellSize = 40;
const canvasSize = cellSize * boardSize + 2;
const bombsCount = boardSize;

void main() {
  var pixelRatio = window.devicePixelRatio;
  var scaledCanvasSize = (canvasSize * pixelRatio).ceil();
  var scaleFactor = scaledCanvasSize / canvasSize;

  var canvas = CanvasElement(width: scaledCanvasSize, height: scaledCanvasSize);
  canvas.style.width = '${canvasSize}px';
  canvas.style.height = '${canvasSize}px';

  canvas.addEventListener('click', (event) {
    print(event);
  });

  var cellsCount = pow(boardSize, 2);

  var indicesWithBombs = <int>{};
  var randomizer = Random();
  while(indicesWithBombs.length < bombsCount) {
    indicesWithBombs.add(randomizer.nextInt(cellsCount + 1));
  }

  var context = canvas.context2D;
  context.scale(scaleFactor, scaleFactor);

  var cells = List.generate(
    cellsCount,
    (index) => Cell(
      index ~/ boardSize,
      index % boardSize,
      indicesWithBombs.contains(index)
    )
  );

  for (var cell in cells) {
    var cellX = cell.row * cellSize + 1;
    var cellY = cell.column * cellSize + 1;

    context.strokeStyle = 'black';
    context.lineWidth = 1;
    context.strokeRect(
      cellX,
      cellY,
      cellSize,
      cellSize
    );

    if (cell.isExplosive) {
      context.fillStyle = 'gray';
      context.beginPath();
      context.arc(cellX + cellSize / 2, cellY + cellSize / 2, cellSize / 4, 0, 2 * pi);
      context.fill();
      context.stroke();
    }
  }

  querySelector('#output').append(canvas);
}
