import 'package:flutter/material.dart';

import 'package:clipboard_handler/clipboard_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            children: [
              StreamBuilder(
                stream: ClipboardHandler.events,
                builder: (context, snapshot) {
                  return FutureBuilder(
                    future: ClipboardHandler.instance.hasURLs(),
                    builder: (context, snapshot) => Text(
                      (snapshot.data ?? false) ? 'Has urls' : "Not has urls",
                    ),
                  );
                },
              ),
              TextField(
                controller: TextEditingController(text: "ss"),
              ),
              TextField(
                controller: TextEditingController(
                  text:
                      "https://chatgpt.com/c/673dd7dd-94a4-8011-9bed-ded20936079b",
                ),
              )
            ],
          ),
          bottomNavigationBar: FloatingActionButton(
            onPressed: () {},
            child: Text("CHECK"),
          ),
        ),
      ),
    );
  }
}
