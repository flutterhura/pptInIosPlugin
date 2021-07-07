import 'package:flutter/services.dart';
class FileReader {


  static const MethodChannel _channel = const MethodChannel('wv.io/FileReader');



  //X5 engin  load state
  // -1 loading  5 success 10 fail
  void engineLoadStatus(Function(bool) loadCallback) async {
    _channel.invokeMethod("isLoad").then((status) {
      if (status == 5) {
        loadCallback.call(true);
      } else if (status == 10) {
        loadCallback.call(false);
      } else if (status == -1) {
        _channel.setMethodCallHandler((call) {
          if (call.method == "onLoad") {
            int status = call.arguments;
            if (status == 5) {
              return loadCallback.call(true);
            } else if (status == 10) {
              return loadCallback.call(false);
            }
          }
          return loadCallback.call(true);
        });
      }
    });
  }

  /// open file when platformview create
  /// filepath only support local path
  void openFile(int platformViewId, String filePath, Function(bool) onOpen) {
    MethodChannel('wv.io/FileReader' + "_$platformViewId")
        .invokeMethod("openFile", filePath)
        .then((openSuccess) {
      onOpen.call(openSuccess);
    });
  }
}

enum FileReaderState {
  LOADING_ENGINE, //loading engine
  ENGINE_LOAD_SUCCESS, //loading engine success
  ENGINE_LOAD_FAIL, //loading engine fail (only Android ,ios,Ignore)
  UNSUPPORT_FILE, // not support file type
  FILE_NOT_FOUND, //file not found
}
