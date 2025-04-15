import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> notes;
  final Function ondelete;
  final Function onetap;
  final List<Color> noteColors;
  const NoteCard({
    super.key,
    required this.notes,
    required this.ondelete,
    required this.onetap,
    required this.noteColors,
  });

  @override
  Widget build(BuildContext context) {
    final colorIndex = notes['color'] as int;

    return GestureDetector(
      onTap: () => onetap(), // Correctly invoke the onetap function
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: noteColors[colorIndex],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notes['date'],
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              notes['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                notes['description'],
                style: const TextStyle(color: Colors.black54, height: 1.5),
                overflow: TextOverflow.fade,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black54,
                    size: 20,
                  ),
                  onPressed: () => ondelete(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
