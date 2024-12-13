import 'dart:io';

import 'package:camera/media.service.dart';
import 'package:camera/screens/storage_screen.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _takedImage;
  String? savedImagePath;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () async {
                final file = await MediaService()
                    .takePictureAndSaveToExternalStore('ID:1232');
                setState(() => _takedImage = file != null ? File(file) : null);
              },
              icon: const Icon(Icons.camera),
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: _takedImage == null
                      ? const Text('Empty')
                      : Image.file(
                          _takedImage!,
                          fit: BoxFit.contain,
                        ),
                ),
                IconButton(
                  onPressed: () {
                    picker.pickMultiImage().then((resp) {});
                  },
                  icon: Icon(
                    Icons.picture_in_picture_rounded,
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StorageScreen()),
                  );
                },
                icon: Icon(Icons.storage))
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
