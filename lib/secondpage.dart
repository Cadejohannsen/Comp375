import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Game Rules', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome to Chess!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'The Objective:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'The goal of chess is to checkmate the opponent\'s king. Checkmate occurs when the king is under immediate attack (in "check") and there is no way to remove it from attack.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'The Pieces:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Each player starts with 16 pieces:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Pawn (8): Moves one square forward, but can move two squares forward on its first move. Pawns capture diagonally one square forward.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Rook (2): Moves any number of squares horizontally or vertically.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Knight (2): Moves in an "L" shape: two squares in one direction (horizontally or vertically) and then one square perpendicularly.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Bishop (2): Moves any number of squares diagonally.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Queen (1): Moves any number of squares horizontally, vertically, or diagonally (combining the moves of a rook and a bishop).',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'King (1): Moves one square in any direction (horizontally, vertically, or diagonally). The king is the most important piece, but also one of the weakest in terms of movement.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Basic Rules:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Turns: White always moves first. Players alternate turns, moving one piece at a time (except for castling, which involves two pieces).',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Capturing: To capture an opponent\'s piece, you move one of your pieces to the square occupied by the opponent\'s piece. The captured piece is removed from the board.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Check: When a king is under attack, it is said to be in "check". The player whose king is in check must make a move to remove the threat.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Checkmate: If a player\'s king is in check and there is no legal move to remove it from attack, the king is "checkmated," and that player loses the game.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Stalemate: A stalemate occurs when the player whose turn it is has no legal moves, but their king is NOT currently in check. A stalemate results in a draw.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              'Special Moves:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Castling: A special move involving the king and one of the rooks. It allows the player to move two pieces in one turn and can provide king safety.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'En Passant: A special pawn capture that can occur immediately after an opponent\'s pawn moves two squares forward from its starting position.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Pawn Promotion: If a pawn reaches the opposite side of the board, it can be promoted to any other piece (queen, rook, bishop, or knight). The queen is the most common choice.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            Text(
              'Have fun playing RcadeChess!',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}