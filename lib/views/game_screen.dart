import 'package:flutter/material.dart';
import 'package:myapp/providers/game_provider.dart';
import 'package:myapp/utils/tile_colors.dart';
import 'package:myapp/views/game_header.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Offset? _startOffset;
  Offset? _endOffset;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF7785FE),
    body: Center(
      child: FutureBuilder(
        future: Provider.of<GameProvider>(context, listen: false).loadGameState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Erreur lors du chargement du jeu');
          }
          return GestureDetector(
            onPanStart: (details) {
              _startOffset = details.globalPosition;
            },
            onPanUpdate: (details) {
              _endOffset = details.globalPosition;
            },
            onPanEnd: (details) {
              if (_startOffset != null && _endOffset != null) {
                double dx = _endOffset!.dx - _startOffset!.dx;
                double dy = _endOffset!.dy - _startOffset!.dy;

                double threshold = 20.0;

                if (dx.abs() > threshold || dy.abs() > threshold) {
                  if (dx.abs() > dy.abs()) {
                    if (dx > 0) {
                      Provider.of<GameProvider>(context, listen: false).moveRight();
                    } else {
                      Provider.of<GameProvider>(context, listen: false).moveLeft();
                    }
                  } else {
                    if (dy > 0) {
                      Provider.of<GameProvider>(context, listen: false).moveDown();
                    } else {
                      Provider.of<GameProvider>(context, listen: false).moveUp();
                    }
                  }
                }
                _startOffset = null;
                _endOffset = null;
              }
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameHeader(
                    score: Provider.of<GameProvider>(context).score,
                    highScore: Provider.of<GameProvider>(context).highScore,
                  ),
                  const SizedBox(height: 16),
                  _buildGrid(context),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}


  Widget _buildGrid(BuildContext context) {
    var grid = Provider.of<GameProvider>(context).grid;
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double offset = width / 60;
      return Container(
        width: width,
        height: width,
        padding: EdgeInsets.all(offset),
        decoration: BoxDecoration(
          color: const Color(0xFF5F5B6B),
          borderRadius: BorderRadius.circular(10),
        ),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 16,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemBuilder: (context, index) {
            int x = index ~/ 4;
            int y = index % 4;
            int value = grid[x][y]; 
            return Container(
              margin: EdgeInsets.all(offset),
              decoration: BoxDecoration(
                color: colorForValue(value),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  value == 0 ? '' : '$value',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
