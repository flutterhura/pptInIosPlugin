//@dart=2.9
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ppt_view_ios/filereader.dart';

class PptViewIos extends StatefulWidget{
  final String filePath; //local path
  final Function(bool) openSuccess;
  final Widget loadingWidget;
  final Widget unSupportFileWidget;

  PptViewIos(
      {
        this.filePath,
        this.openSuccess,
        this.loadingWidget,
        this.unSupportFileWidget});



  @override
  State<StatefulWidget> createState() {
    return _FileReaderViewState();
  }
}

class _FileReaderViewState extends State<PptViewIos> {
  FileReader fileReader=FileReader();
  FileReaderState _status = FileReaderState.LOADING_ENGINE;
  String filePath;

  @override
  void initState() {
    super.initState();
    filePath = widget.filePath;
    File(filePath).exists().then((exists) {
      if (exists) {
        _checkOnLoad();
      } else {
        _setStatus(FileReaderState.FILE_NOT_FOUND);
      }
    });
  }

  _checkOnLoad() {
    fileReader.engineLoadStatus((success) {
      if (success) {
        _setStatus(FileReaderState.ENGINE_LOAD_SUCCESS);
      } else {
        _setStatus(FileReaderState.ENGINE_LOAD_FAIL);
      }
    });
  }

  _setStatus(FileReaderState status) {
    _status = status;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      if (_status == FileReaderState.LOADING_ENGINE) {
        return _loadingWidget();
      } else if (_status == FileReaderState.UNSUPPORT_FILE) {
        return _unSupportFile();
      } else if (_status == FileReaderState.ENGINE_LOAD_SUCCESS) {
        if (Platform.isAndroid) {
          return _createAndroidView();
        } else {
          return _createIosView();
        }
      } else if (_status == FileReaderState.ENGINE_LOAD_FAIL) {
        return _enginLoadFail();
      } else if (_status == FileReaderState.FILE_NOT_FOUND) {
        return _fileNotFoundFile();
      } else {
        return _loadingWidget();
      }
    } else {
      return Center(child: Text("Unsupported platform"));
    }
  }

  Widget _unSupportFile() {
    return widget.unSupportFileWidget ??
        Center(
          child: Text("不支持打开${_fileType(filePath)}类型的文件"),
        );
  }

  Widget _fileNotFoundFile() {
    return Center(
      child: Text("File does not exist"),
    );
  }

  Widget _enginLoadFail() {

    return Center(
      child: Text("Engine failed to load, please exit and try again"),
    );
  }

  Widget _loadingWidget() {
    return widget.loadingWidget ??
        Center(
          child: CupertinoActivityIndicator(),
        );
  }

  Widget _createAndroidView() {
    return AndroidView(
        viewType: "FileReader",
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParamsCodec: StandardMessageCodec());
  }

  _onPlatformViewCreated(int id) {

    fileReader.openFile(id, filePath, (success) {
      if (!success) {
        _setStatus(FileReaderState.UNSUPPORT_FILE);
      }
      widget.openSuccess.call(success);
    });
  }

  Widget _createIosView() {
    return UiKitView(
      viewType: "FileReader",
      onPlatformViewCreated: _onPlatformViewCreated,
      creationParamsCodec: StandardMessageCodec(),
    );
  }

  String _fileType(String filePath) {
    if (filePath == null || filePath.isEmpty) {
      return "";
    }
    int i = filePath.lastIndexOf('.');
    if (i <= -1) {
      return "";
    }
    return filePath.substring(i + 1);
  }
}

