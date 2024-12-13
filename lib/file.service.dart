import 'dart:io';

class FileService {
  static delete(String path) {
    // open file
    File file = File('test.txt');
    // check if file exists
    if (file.existsSync()) {
      // delete file
      file.deleteSync();
      print('File deleted.');
    } else {
      print('File does not exist.');
    }
  }

  static List<FileSystemEntity> getFilesFromFolder(String folderPath) {
    Directory dir = Directory(folderPath);
    return dir.listSync(recursive: false).toList();
  }

  Map<String, int> dirStatSync(String dirPath) {
    int fileNum = 0;
    int totalSize = 0;
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }

    return {'fileNum': fileNum, 'size': totalSize};
  }

  Map<String, Object> fileStat() {
    final stat = FileStat.statSync("test.dart");
    return {
      "timeLastAccess": stat.accessed,
      "timeLastModified": stat.modified,
      "timeLastChangedStatus": stat.changed,
    };
  }
}
