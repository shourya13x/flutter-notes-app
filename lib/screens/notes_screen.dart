import 'package:flutter/material.dart';
import '../database/notes_database.dart';
import 'note_card.dart';
import 'note_dialog.dart';
import 'package:lottie/lottie.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDatabase.instance.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    const Color(0xFF3949AB), // Indigo
    const Color(0xFF4DB6AC), // Teal
    const Color(0xFFFF7043), // Deep Orange
    const Color(0xFF9575CD), // Purple
    const Color(0xFFFFEB3B), // Yellow
    const Color(0xFF66BB6A), // Green
    const Color(0xFF00ACC1), // Cyan
    const Color(0xFFFFA726), // Orange
    const Color(0xFFD32F2F), // Red
    const Color(0xFF607D8B), // Blue Grey
  ];
  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int colorIndex = 0,
  }) async {
    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return NoteDialog(
          colorIndex: colorIndex,
          noteColors: noteColors,
          onNoteSaved: (
            newTitle,
            newDescription,
            selectedColorIndex,
            date,
          ) async {
            if (id == null) {
              await NotesDatabase.instance.addNote(
                newTitle,
                newDescription,
                date,
                selectedColorIndex,
              );
            } else {
              await NotesDatabase.instance.updateNote(
                id.toString(),
                newTitle,
                newDescription,
                date,
                selectedColorIndex,
              );
            }

            if (dialogContext.mounted && Navigator.of(dialogContext).canPop()) {
              Navigator.of(dialogContext).pop(true);
            }
          },
          title: title,
          content: content,
          noteID: id,
        );
      },
    );

    if (mounted && result == true) {
      await fetchNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notes',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.amber,
            fontSize: 28,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showNoteDialog(); // show the dialog instead of navigating
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black87),
      ),
      body:
          notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Lottie.asset(
                          'assets/animations/empty_notes.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Notes Found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      notes: note,
                      ondelete: () async {
                        await NotesDatabase.instance.deleteNote(note['id']);
                        fetchNotes();
                      },
                      onetap: () {
                        showNoteDialog(
                          id: note['id'],
                          title: note['title'],
                          content: note['description'],
                          colorIndex: note['color'],
                        );
                      },
                      noteColors: noteColors,
                    );
                  },
                ),
              ),
    );
  }
}
