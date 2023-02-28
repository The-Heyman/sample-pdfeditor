import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadFile(String url, [String? filename]) async {
  var hasStoragePermission = await Permission.storage.isGranted;
  Directory downloadDir = Directory('/storage/emulated/0/Download');
  if (!hasStoragePermission) {
    final status = await Permission.storage.request();
    hasStoragePermission = status.isGranted;
  }
  if (hasStoragePermission) {
    final taskId = await FlutterDownloader.enqueue(
        url: url,
        headers: {},
        savedDir: downloadDir.path,
        saveInPublicStorage: true,
        fileName: filename);
  }
}
