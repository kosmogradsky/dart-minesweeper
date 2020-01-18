import 'dart:html';
import 'dart:math';

class CellCoords {
  final int row;
  final int column;
  const CellCoords(this.row, this.column);
}

abstract class Cell {
  int get row;
  int get column;
  
  int get x => row * cellSize + 1;
  int get y => column * cellSize + 1;

  void renderContent(CanvasRenderingContext2D context);

  void renderBorders(CanvasRenderingContext2D context) {
    context.fillStyle = 'lightgray';
    context.fillRect(
      x,
      y,
      cellSize,
      cellSize
    );
    context.strokeStyle = 'black';
    context.lineWidth = 1;
    context.strokeRect(
      x,
      y,
      cellSize,
      cellSize
    );
  }

  void render(CanvasRenderingContext2D context) {
    renderBorders(context);
    renderContent(context);
  }
}

const boardSize = 20;
const cellSize = 40;
const canvasSize = cellSize * boardSize + 2;
const bombsCount = 60;

class Hint with Cell {
  final int row;
  final int column;
  final int bombsAround;
  Hint(this.row, this.column, this.bombsAround);

  void renderContent(CanvasRenderingContext2D context) {
    if (bombsAround != 0) {
      context.fillStyle = 'black';
      context.font = '400 ${cellSize ~/ 1.3}px sans-serif';
      context.fillText(bombsAround.toString(), x + cellSize * 0.25, y + cellSize * 0.75);
    }
  }
}

class Mine with Cell {
  final int row;
  final int column;
  Mine(this.row, this.column);

  void renderContent(CanvasRenderingContext2D context) {
    context.fillStyle = 'gray';
    context.beginPath();
    context.arc(x + cellSize / 2, y + cellSize / 2, cellSize / 4, 0, 2 * pi);
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
  while(indicesWithBombs.length < bombsCount) {
    indicesWithBombs.add(randomizer.nextInt(cellsCount + 1));
  }

  var coordinatesWithBombs = indicesWithBombs.map((index) {
    var row = index ~/ boardSize;
    var column = index % boardSize;

    return CellCoords(row, column);
  });

  var context = canvas.context2D;
  context.scale(scaleFactor, scaleFactor);

  Cell cellGenerator(int index) {
    var row = index ~/ boardSize;
    var column = index % boardSize;

    if (indicesWithBombs.contains(index)) {
      return Mine(row, column);
    }

    var bombsAround = coordinatesWithBombs.fold<int>(
      0,
      (count, bomb) {
        if ({row - 1, row, row + 1}.contains(bomb.row)) {
          if ({column - 1, column, column + 1}.contains(bomb.column)) {
            return count + 1;
          }
        }

        return count;
      }
    );

    return Hint(row, column, bombsAround);
  }

  var cells = List.generate(
    cellsCount,
    cellGenerator
  );

  for (var cell in cells) {
    cell.render(context);
  }

  querySelector('#output').append(canvas);
}
