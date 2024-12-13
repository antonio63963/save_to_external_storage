import 'dart:io';

import 'package:camera/file.service.dart';
import 'package:camera/media.service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker picker = ImagePicker();

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  List<FileSystemEntity> storagePictures = [];

  @override
  void initState() {
    MediaService().getStorage().then((path) {
      if (path is String) {
        storagePictures = FileService.getFilesFromFolder(path);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Storage'),
          ),
          body: storagePictures.isNotEmpty
              ? ListView.builder(
                  itemCount: storagePictures.length,
                  itemBuilder: (_, index) {
                    final pic = storagePictures[index].path;
                    return Image.file(File(pic));
                  })
              : Text('NO PHOTOS YET')),
    );
  } 
}
