import 'dart:html';
import 'dart:math';

class CellCoords {
  final int row;
  final int column;

  int get x => row * cellSize + 1;
  int get y => column * cellSize + 1;

  const CellCoords(this.row, this.column);
}

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

  void render(CellCoords coords, CanvasRenderingContext2D context);
}

class Cell {
  final CellCoords coords;
  final CellContent content;

  const Cell(this.coords, this.content);

  void renderBorders(CanvasRenderingContext2D context) {
    context.fillStyle = 'lightgray';
    context.fillRect(coords.x, coords.y, cellSize, cellSize);
    context.strokeStyle = 'black';
    context.lineWidth = 1;
    context.strokeRect(coords.x, coords.y, cellSize, cellSize);
  }

  void render(CanvasRenderingContext2D context) {
    renderBorders(context);
    content.render(coords, context);
  }
}

const boardSize = 20;
const cellSize = 40;
const canvasSize = cellSize * boardSize + 2;
const bombsCount = 60;

class Hint implements CellContent {
  final int bombsAround;
  const Hint(this.bombsAround);

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

  void render(CellCoords coords, CanvasRenderingContext2D context) {
    context.fillStyle = 'gray';
    context.beginPath();
    context.arc(coords.x + cellSize / 2, coords.y + cellSize / 2, cellSize / 4,
        0, 2 * pi);
    context.fill();
    context.stroke();
  }
}

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
  while (indicesWithBombs.length < bombsCount) {
    indicesWithBombs.add(randomizer.nextInt(cellsCount + 1));
  }

  var fieldBombs = indicesWithBombs.map((index) {
    var row = index ~/ boardSize;
    var column = index % boardSize;

    return CellCoords(row, column);
  });

  var context = canvas.context2D;
  context.scale(scaleFactor, scaleFactor);

  Cell cellGenerator(int index) {
    var row = index ~/ boardSize;
    var column = index % boardSize;
    var coords = CellCoords(row, column);
    var content = CellContent(coords, fieldBombs);

    return Cell(coords, content);
  }

  var cells = List.generate(cellsCount, cellGenerator);

  for (var cell in cells) {
    cell.render(context);
  }

  querySelector('#output').append(canvas);
}
