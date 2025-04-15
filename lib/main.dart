import 'package:flutter/material.dart';
import 'screens/notes_screen.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF121212)
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const NotesScreen(),
        '/add_note': (context) => AddNoteScreen(), // ensure this screen exists
      },
    );
  }
}

// Added AddNoteScreen widget as a placeholder.
class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: const Center(
        child: Text('Add Note Screen'),
      ),
    );
  }
}
