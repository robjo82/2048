import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class GameProvider with ChangeNotifier {
  List<List<int>> _grid = [];
  int _score = 0;
  int _highScore = 0;

  List<List<int>>? _previousGrid;
  int? _previousScore;

  GameProvider() {
    _loadHighScore();
    if (grid.isEmpty) {
      resetGame();
    }
  }

  List<List<int>> get grid => _grid;
  int get score => _score;
  int get highScore => _highScore;

  void _initializeGrid() {
    _grid = List.generate(4, (_) => List.generate(4, (_) => 0));
  }

  Future<void> _loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('highScore') ?? 0;
    notifyListeners();
  }

  Future<void> _updateHighScore() async {
    if (_score > _highScore) {
      _highScore = _score;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('highScore', _highScore);
      _highScore = score;
      notifyListeners();
    }
  }

  void _addNewTile() {
    List<Offset> emptyTiles = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) {
          emptyTiles.add(Offset(i.toDouble(), j.toDouble()));
        }
      }
    }

    if (emptyTiles.isNotEmpty) {
      var randomPosition = emptyTiles[Random().nextInt(emptyTiles.length)];
      _grid[randomPosition.dx.toInt()][randomPosition.dy.toInt()] =
          Random().nextInt(10) < 9 ? 2 : 4;
      notifyListeners();
    }
  }

  void _saveState() {
    _previousGrid = _grid.map((row) => List<int>.from(row)).toList();
    _previousScore = _score;
  }

  void moveLeft() {
    _saveState();
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = _grid[i];
      List<int> newRow = _merge(row);
      if (!ListEquality().equals(row, newRow)) {
        _grid[i] = newRow;
        moved = true;
      }
    }
    if (moved) _addNewTile();
    _updateHighScore();
  }

  void moveRight() {
    _saveState();
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = _grid[i].reversed.toList();
      List<int> newRow = _merge(row).reversed.toList();
      if (!ListEquality().equals(_grid[i], newRow)) {
        _grid[i] = newRow;
        moved = true;
      }
    }
    if (moved) _addNewTile();
    _updateHighScore();
  }

  void moveUp() {
    _saveState();
    bool moved = false;
    for (int j = 0; j < 4; j++) {
      List<int> column = [];
      for (int i = 0; i < 4; i++) {
        column.add(_grid[i][j]);
      }
      List<int> newColumn = _merge(column);
      for (int i = 0; i < 4; i++) {
        if (_grid[i][j] != newColumn[i]) {
          _grid[i][j] = newColumn[i];
          moved = true;
        }
      }
    }
    if (moved) _addNewTile();
    _updateHighScore();
  }

  void moveDown() {
    _saveState();
    bool moved = false;
    for (int j = 0; j < 4; j++) {
      List<int> column = [];
      for (int i = 0; i < 4; i++) {
        column.add(_grid[i][j]);
      }
      List<int> newColumn = _merge(column.reversed.toList()).reversed.toList();
      for (int i = 0; i < 4; i++) {
        if (_grid[i][j] != newColumn[i]) {
          _grid[i][j] = newColumn[i];
          moved = true;
        }
      }
    }
    if (moved) _addNewTile();
    _updateHighScore();
  }

  List<int> _merge(List<int> row) {
    List<int> newRow = row.where((value) => value != 0).toList();
    for (int i = 0; i < newRow.length - 1; i++) {
      if (newRow[i] == newRow[i + 1]) {
        newRow[i] *= 2;
        _score += newRow[i];
        newRow[i + 1] = 0;
      }
    }
    newRow = newRow.where((value) => value != 0).toList();
    while (newRow.length < 4) {
      newRow.add(0);
    }
    notifyListeners();
    return newRow;
  }

  void undo() {
    if (_previousGrid != null && _previousScore != null) {
      _grid = _previousGrid!;
      _score = _previousScore!;
      _previousGrid = null;
      _previousScore = null;
      notifyListeners();
    }
  }

  void resetGame() {
    _score = 0;
    _initializeGrid();
    _addNewTile();
    _addNewTile();
    _previousGrid = null;
    _previousScore = null;
    notifyListeners();
  }
}
