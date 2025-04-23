import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firestore

class ThirdPage extends StatefulWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  bool isWhiteTurn = true;
  List<List<String?>> boardState = List.generate(8, (_) => List.filled(8, null));
  int? selectedRow;
  int? selectedCol;
  bool checkmate = false;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    boardState = List.generate(8, (_) => List.filled(8, null));
    boardState[0] = ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'];
    boardState[1] = List.filled(8, 'p');
    boardState[6] = List.filled(8, 'P');
    boardState[7] = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'];
  }

  bool _isValidMove(int sr, int sc, int er, int ec) {
    String? piece = boardState[sr][sc];
    if (piece == null) return false;
    bool isWhitePiece = piece == piece.toUpperCase();
    if (isWhitePiece != isWhiteTurn) return false;
    if (boardState[er][ec] != null &&
        (boardState[er][ec]!.toUpperCase() == boardState[er][ec]) ==
            isWhitePiece) return false;

    switch (piece.toLowerCase()) {
      case 'p':
        return _isValidPawnMove(sr, sc, er, ec);
      case 'r':
        return _isValidRookMove(sr, sc, er, ec);
      case 'n':
        return _isValidKnightMove(sr, sc, er, ec);
      case 'b':
        return _isValidBishopMove(sr, sc, er, ec);
      case 'q':
        return _isValidQueenMove(sr, sc, er, ec);
      case 'k':
        return _isValidKingMove(sr, sc, er, ec);
      default:
        return false; //Should not reach here
    }
  }

  bool _isValidPawnMove(int sr, int sc, int er, int ec) {
    String? piece = boardState[sr][sc];
    if (piece == null) return false;
    bool isWhite = piece == piece.toUpperCase();
    int direction = isWhite ? -1 : 1;
    int startRow = isWhite ? 6 : 1;

    if (sc == ec && boardState[er][ec] == null) {
      if (er == sr + direction) return true;
      if (sr == startRow &&
          er == sr + 2 * direction &&
          boardState[sr + direction][sc] == null) return true;
    } else if ((ec - sc).abs() == 1 &&
        er == sr + direction &&
        boardState[er][ec] != null &&
        (boardState[er][ec]!.toUpperCase() != boardState[er][ec]) == isWhite) {
      return true;
    }
    return false;
  }

  bool _isValidRookMove(int sr, int sc, int er, int ec) {
    if (sr != er && sc != ec) return false;
    int dr = sr == er ? 0 : (er - sr) ~/ (er - sr).abs();
    int dc = sc == ec ? 0 : (ec - sc) ~/ (ec - sc).abs();
    int r = sr + dr, c = sc + dc;
    while (r != er || c != ec) {
      if (boardState[r][c] != null) return false;
      r += dr;
      c += dc;
    }
    return true;
  }

  bool _isValidKnightMove(int sr, int sc, int er, int ec) {
    int dr = (sr - er).abs();
    int dc = (sc - ec).abs();
    return (dr == 2 && dc == 1) || (dr == 1 && dc == 2);
  }

  bool _isValidBishopMove(int sr, int sc, int er, int ec) {
    if ((sr - er).abs() != (sc - ec).abs()) return false;
    int dr = (er - sr) ~/ (er - sr).abs();
    int dc = (ec - sc) ~/ (ec - sc).abs();
    int r = sr + dr, c = sc + dc;
    while (r != er && c != ec) {
      if (boardState[r][c] != null) return false;
      r += dr;
      c += dc;
    }
    return true;
  }

  bool _isValidQueenMove(int sr, int sc, int er, int ec) {
    return _isValidRookMove(sr, sc, er, ec) ||
        _isValidBishopMove(sr, sc, er, ec);
  }

  bool _isValidKingMove(int sr, int sc, int er, int ec) {
    int dr = (sr - er).abs();
    int dc = (sc - ec).abs();
    return dr <= 1 && dc <= 1;
  }

  void _handleTap(int row, int col) {
    if (checkmate) return;

    setState(() {
      if (selectedRow == null || selectedCol == null) {
        if (boardState[row][col] != null &&
            (boardState[row][col]!.toUpperCase() == boardState[row][col]) ==
                isWhiteTurn) {
          selectedRow = row;
          selectedCol = col;
        }
      } else {
        if (_isValidMove(selectedRow!, selectedCol!, row, col)) {
          _movePiece(selectedRow!, selectedCol!, row, col);
        } else {
          setState(() {
            selectedRow = null;
            selectedCol = null;
          });
        }
      }
    });
  }

  void _movePiece(int sr, int sc, int er, int ec) {
    setState(() {
      String? movedPiece = boardState[sr][sc];
      boardState[er][ec] = movedPiece;
      boardState[sr][sc] = null;
      isWhiteTurn = !isWhiteTurn;
      selectedRow = null;
      selectedCol = null;
      checkmate = _isCheckmate(!isWhiteTurn);
    });
  }

  bool _isCheck(bool whiteKing) {
    int kingRow = -1, kingCol = -1;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        String? piece = boardState[r][c];
        if (piece == (whiteKing ? 'K' : 'k')) {
          kingRow = r;
          kingCol = c;
          break;
        }
      }
    }
    if (kingRow == -1) return false;

    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (boardState[r][c] != null &&
            (boardState[r][c]!.toUpperCase() == boardState[r][c]) !=
                whiteKing) {
          if (_isValidMove(r, c, kingRow, kingCol)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _isCheckmate(bool whiteKing) {
    if (!_isCheck(whiteKing)) return false;

    for (int sr = 0; sr < 8; sr++) {
      for (int sc = 0; sc < 8; sc++) {
        if (boardState[sr][sc] != null &&
            (boardState[sr][sc]!.toUpperCase() == boardState[sr][sc]) ==
                whiteKing) {
          for (int er = 0; er < 8; er++) {
            for (int ec = 0; ec < 8; ec++) {
              if (_isValidMove(sr, sc, er, ec)) {
                List<List<String?>> tempBoard =
                boardState.map((list) => List<String?>.from(list)).toList();

                String? backup = tempBoard[er][ec];
                tempBoard[er][ec] = tempBoard[sr][sc];
                tempBoard[sr][sc] = null;
                bool stillInCheck = _isCheck(whiteKing);

                if (!stillInCheck) {
                  return false;
                }
                tempBoard[sr][sc] = tempBoard[er][ec];
                tempBoard[er][ec] = backup;
              }
            }
          }
        }
      }
    }
    return true;
  }

  void _promotePawn(int row, int col, String movedPiece) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Promote your pawn'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Queen'),
                onTap: () {
                  _promotePawnTo(row, col, movedPiece, 'Q');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Rook'),
                onTap: () {
                  _promotePawnTo(row, col, movedPiece, 'R');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Bishop'),
                onTap: () {
                  _promotePawnTo(row, col, movedPiece, 'B');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Knight'),
                onTap: () {
                  _promotePawnTo(row, col, movedPiece, 'N');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _promotePawnTo(int row, int col, String movedPiece, String piece) {
    setState(() {
      boardState[row][col] = movedPiece.toUpperCase() == movedPiece
          ? piece.toUpperCase()
          : piece.toLowerCase();
      selectedRow = null;
      selectedCol = null;
      isWhiteTurn = !isWhiteTurn;
      checkmate = _isCheckmate(!isWhiteTurn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(checkmate
            ? '${isWhiteTurn ? 'Black' : 'White'} Wins!'
            : '${isWhiteTurn ? 'White' : 'Black'} to move'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: 64,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int col = index % 8;
                bool isSelected = selectedRow == row && selectedCol == col;
                return GestureDetector(
                  onTap: () => _handleTap(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (row + col).isEven
                          ? Colors.brown[300]
                          : Colors.brown[100],
                      border: isSelected
                          ? Border.all(color: Colors.red, width: 3)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        boardState[row][col] != null ? boardState[row][col]! : '',
                        style: TextStyle(
                          fontSize: 24,
                          color: boardState[row][col] != null &&
                              boardState[row][col] ==
                                  boardState[row][col]!.toUpperCase()
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            // Added ElevatedButton
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FirestoreDataPage(), // Navigate to FirestoreDataPage
                ),
              );
            },
            child: const Text('Go to Firestore Data Page'),
          ),
        ],
      ),
    );
  }
}

// FirestoreDataPage widget to display data from Firestore
class FirestoreDataPage extends StatefulWidget {
  @override
  _FirestoreDataPageState createState() => _FirestoreDataPageState();
}

class _FirestoreDataPageState extends State<FirestoreDataPage> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _firestoreData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchFirestoreData();
  }

  Future<void> _fetchFirestoreData() async {
    _isLoading = true;
    _errorMessage = '';
    try {
      // Get the data from the 'items' collection
      QuerySnapshot querySnapshot =
      await _firestore.collection('items').get(); // Changed collection name

      // Map the documents to a list of Maps
      _firestoreData = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the document ID
          'data': doc.data(), // Include all the data in the document
        };
      }).toList();
    } catch (e) {
      _errorMessage = 'Error fetching data from Firestore: $e';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildFirestoreBody(),
      ),
    );
  }

  Widget _buildFirestoreBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    } else if (_firestoreData.isEmpty) {
      return const Center(child: Text('No data to display.'));
    } else {
      return ListView.builder(
        itemCount: _firestoreData.length,
        itemBuilder: (context, index) {
          final item = _firestoreData[index];
          final String documentId = item['id'];
          final Map<String, dynamic>? data =
          item['data'] as Map<String, dynamic>?; // Cast to Map<String, dynamic>

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Document ID: $documentId',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (data != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${data['name'] ?? 'N/A'}'),
                        Text('Age: ${data['age'] ?? 'N/A'}'),
                        // Add more Text widgets for other fields as needed
                      ],
                    )
                  else
                    const Text('No data in document'),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

