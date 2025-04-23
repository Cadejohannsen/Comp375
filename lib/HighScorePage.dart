import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HighScoresPage extends StatefulWidget {
  const HighScoresPage({Key? key}) : super(key: key);

  @override
  State<HighScoresPage> createState() => _HighScoresPageState();
}

class _HighScoresPageState extends State<HighScoresPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  Future<void> _submitScore() async {
    final String name = _nameController.text.trim();
    final String scoreText = _scoreController.text.trim();
    final int? score = int.tryParse(scoreText);

    if (name.isEmpty || score == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name and number score.')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('HighScores').add({
      'name': name,
      'score': score,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _nameController.clear();
    _scoreController.clear();
  }

  InputDecoration _whiteInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('High Scores')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _whiteInputDecoration('Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _scoreController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _whiteInputDecoration('Score'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitScore,
                  child: const Text('Submit Score'),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white),
          const Text(
            'Leaderboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('HighScores')
                  .orderBy('score', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No scores yet', style: TextStyle(color: Colors.white)));
                }

                final scores = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    final data = scores[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name'] ?? 'Unknown', style: const TextStyle(color: Colors.white)),
                      trailing: Text('${data['score'] ?? 0}', style: const TextStyle(color: Colors.white)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[850],
    );
  }
}
