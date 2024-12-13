import 'dart:io';

import 'package:camera/app_confing.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class MediaService {
  late String _localPath;
  late TargetPlatform? platform;

  MediaService() {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await _isAndroid11OrAbove()) {
        // For Android 11 and above, request MANAGE_EXTERNAL_STORAGE permission
        if (!await Permission.manageExternalStorage.isGranted) {
          await Permission.manageExternalStorage.request();
        }
      } else {
        // For Android versions below 11, request READ/WRITE_EXTERNAL_STORAGE permissions
        if (!await Permission.storage.isGranted) {
          await Permission.storage.request();
        }
      }
    }
  }

  Future<bool> _isAndroid11OrAbove() async {
    return (await Permission.manageExternalStorage.isGranted) ||
        Platform.version.contains('API 30');
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await getStorage())!;
    final savedDir = Directory(_localPath);

    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<XFile?> _takePictureFromCamera() async {
    return await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 600);
  }

  Future<String?> _savePicture({
    XFile? imageFile,
    required String idCheckItem,
  }) async {
    if (imageFile is XFile) {
      final extensionFile = path.extension(imageFile.path);
      final fileName =
          '${idCheckItem}_${DateTime.now().millisecondsSinceEpoch}$extensionFile';
      final fullPath = '$_localPath/$fileName';
      await imageFile.saveTo(fullPath);

      return fullPath;
    }
    return null;
  }

   Future<String?> getStorage() async {
    if (platform == TargetPlatform.android) {
      // return "/sdcard/download/";
      final localPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_PICTURES,
      );
      return '$localPath/${AppConfing.saveDir}';
    } else {
      var directory = await syspath.getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  Future<String?> takePictureAndSaveToExternalStore(String idCheckItem) async {
    await _requestStoragePermission();
    await _prepareSaveDir();
    final xFile = await _takePictureFromCamera();
    final fullPath = await _savePicture(
      imageFile: xFile,
      idCheckItem: idCheckItem,
    );
    return fullPath;
  }
}
