import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'dart:io';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await Permission.storage.request();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(children: <Widget>[
          Expanded(
              child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    "https://editor-8f407.web.app")),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(useOnDownloadStart: true),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onDownloadStartRequest:
                (InAppWebViewController inAppWebViewController,
                    DownloadStartRequest downloadStartRequest) async {
              var dio = Dio();
              var dir = await getApplicationDocumentsDirectory();
              var file = File(
                  "${dir.path}/${downloadStartRequest.suggestedFilename}");
              print(file);
              var url = downloadStartRequest.url.path;
              var response = await dio.download(
                url,
                file.path,
                onReceiveProgress: (received, total) {
                  // Print the download progress
                  print("$received");
                },
              );
              if (response.statusCode == 200) {
                print("File Downloaded");
              }
            },
            /*async {
                print("downloading");
                print(downloadStartRequest.url.toString());
                final taskId = await FlutterDownloader.enqueue(
                  url: downloadStartRequest.url.toString(),
                  savedDir:
                      (await getApplicationDocumentsDirectory())!.path,
                  showNotification:
                      true, // show download progress in status bar (for Android)
                  openFileFromNotification:
                      true, // click on notification to open downloaded file (for Android)
                );
              }*/
          ))
        ]),
      ),
    );
  }
}
