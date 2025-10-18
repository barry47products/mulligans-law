import 'package:flutter/material.dart';

void main() {
  runApp(const MulligansLawApp());
}

class MulligansLawApp extends StatelessWidget {
  const MulligansLawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mulligans Law',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Mulligans Law'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.golf_course,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to Mulligans Law',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Golf Society Score Tracking',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
