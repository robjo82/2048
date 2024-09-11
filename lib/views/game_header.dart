import 'package:flutter/material.dart';
import 'package:myapp/providers/game_provider.dart';
import 'package:provider/provider.dart';

class GameHeader extends StatelessWidget {
  final int score;
  final int highScore;

  GameHeader({required this.score, required this.highScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '2048',
                style: TextStyle(
                    fontSize: 72,
                    color: Color(0xFFFDE8E9),
                    fontWeight: FontWeight.bold,
                    height: 0.1),
              ),
              Row(
                children: [
                  _buildScoreBox('SCORE', score),
                  SizedBox(width: 16),
                  _buildScoreBox('HIGH SCORE', highScore),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Spacer(),
              _buildCancelButton(context),
              SizedBox(width: 32),
              _buildResetButton(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildScoreBox(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF5F5B6B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFFFDE8E9),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFFCF7FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF5F5B6B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.refresh,
          color: Color(0xFFFCF7FF),
          size: 30,
        ),
        onPressed: () {
          Provider.of<GameProvider>(context, listen: false).resetGame();
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 22,
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF5F5B6B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.undo,
          color: Color(0xFFFCF7FF),
          size: 30,
        ),
        onPressed: () {
          Provider.of<GameProvider>(context, listen: false).undo();
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 22,
      ),
    );
  }
}
