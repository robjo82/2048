import 'dart:convert';

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

  bool _isGameOver = false;
  bool get isGameOver => _isGameOver;

  GameProvider() {
    _loadHighScore();
    loadGameState();
  }

  List<List<int>> get grid => _grid;
  int get score => _score;
  int get highScore => _highScore;

  void _initializeGrid() {
    _grid = List.generate(4, (_) => List.generate(4, (_) => 0));
  }

  Future<void> saveGameState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('grid', jsonEncode(_grid));
    await prefs.setInt('score', _score);
  }

  Future<void> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final gridJson = prefs.getString('grid');
    final score = prefs.getInt('score') ?? 0;

    if (gridJson != null) {
      List<List<int>> grid = jsonDecode(gridJson)
          .map<List<int>>(
            (list) => List<int>.from(list),
          )
          .toList();
      _grid = grid;
      _score = score;
      notifyListeners();
    } else {
      resetGame();
    }
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
      if (!const ListEquality().equals(row, newRow)) {
        _grid[i] = newRow;
        moved = true;
      }
    }
    if (moved) {
      _addNewTile();
      _updateGameOverStatus();
    }
    _updateHighScore();
    saveGameState();
  }

  void moveRight() {
    _saveState();
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> row = _grid[i].reversed.toList();
      List<int> newRow = _merge(row).reversed.toList();
      if (!const ListEquality().equals(_grid[i], newRow)) {
        _grid[i] = newRow;
        moved = true;
      }
    }
    if (moved) {
      _addNewTile();
      _updateGameOverStatus();
    }
    _updateHighScore();
    saveGameState();
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
    if (moved) {
      _addNewTile();
      _updateGameOverStatus();
    }
    _updateHighScore();
    saveGameState();
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
    if (moved) {
      _addNewTile();
      _updateGameOverStatus();
    }
    _updateHighScore();
    saveGameState();
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
    _isGameOver = false;
    _initializeGrid();
    _addNewTile();
    _addNewTile();
    _previousGrid = null;
    _previousScore = null;
    notifyListeners();
  }

  bool _checkGameOver() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) return false;
        if (i < 3 && _grid[i][j] == _grid[i + 1][j]) return false;
        if (j < 3 && _grid[i][j] == _grid[i][j + 1]) return false;
      }
    }
    return true;
  }

  void _updateGameOverStatus() {
    _isGameOver = _checkGameOver();
    notifyListeners();
  }
}
