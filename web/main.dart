library dart_minesweeper;

import 'dart:html';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:quiver/core.dart';

part 'cell_content.dart';
part 'cell_coords.dart';
part 'cell_status.dart';
part 'cell.dart';
part 'game.dart';

const boardSize = 20;
const cellSize = 40;
const canvasSize = cellSize * boardSize + 2;
const bombsCount = 60;

void main() {
  var pixelRatio = window.devicePixelRatio;
  var scaledCanvasSize = (canvasSize * pixelRatio).ceil();
  var scaleFactor = scaledCanvasSize / canvasSize;

  var canvas = CanvasElement(width: scaledCanvasSize, height: scaledCanvasSize);
  canvas.style.width = '${canvasSize}px';
  canvas.style.height = '${canvasSize}px';

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

    return Cell(coords, Hidden(), content);
  }

  var cells = List.generate(cellsCount, cellGenerator).build();

  querySelector('#output').append(canvas);

  var game = Game(context, cells);

  game.run();

  canvas.onClick.listen((event) {
    var canvasRect = canvas.getBoundingClientRect();
    var clickX = (event.client.x - canvasRect.left - canvas.clientLeft)
        .clamp(0, canvasSize);
    var clickY = (event.client.y - canvasRect.top - canvas.clientTop)
        .clamp(0, canvasSize);
    var revealQueue = [CellCoords(clickY ~/ cellSize, clickX ~/ cellSize)];

    while (revealQueue.isEmpty == false) {
      var revealingCoords = revealQueue.removeLast();
      var revealingCell = game[revealingCoords];

      if (revealingCell.status.isRevealed == false &&
          revealingCell.content.canBeRevealedByFloodFill) {
        game[revealingCoords] =
            Cell(revealingCell.coords, Revealed(), revealingCell.content);

        if (revealingCell.content.revealsCellsAround) {
          revealQueue = revealingCell.coords.neighbors.toList() + revealQueue;
        }
      }
    }
  });

  canvas.onContextMenu.listen((event) {
    event.preventDefault();

    var canvasRect = canvas.getBoundingClientRect();
    var clickX = (event.client.x - canvasRect.left - canvas.clientLeft)
        .clamp(0, canvasSize);
    var clickY = (event.client.y - canvasRect.top - canvas.clientTop)
        .clamp(0, canvasSize);

    var revealingCoords = CellCoords(clickY ~/ cellSize, clickX ~/ cellSize);
    var revealingCell = game[revealingCoords];

    game[revealingCoords] =
        Cell(revealingCell.coords, Flagged(), revealingCell.content);
  });
}
