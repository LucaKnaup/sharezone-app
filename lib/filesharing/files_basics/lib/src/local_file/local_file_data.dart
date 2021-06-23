import 'dart:typed_data';
import 'package:files_basics/src/local_file/mime_type.dart';

import 'local_file.dart';

class LocalFileData extends LocalFile {
  final Uint8List fileData;
  final String fileName;
  final int sizeBytes;
  final MimeType mimeType;
  final String path;

  LocalFileData._(
      {this.fileData, this.fileName, this.path, this.sizeBytes, this.mimeType});

  factory LocalFileData.fromData(
      Uint8List data, String path, String name, String type) {
    return LocalFileData._(
      fileData: data,
      sizeBytes: data.lengthInBytes,
      path: path,
      mimeType: MimeType(type),
      fileName: name,
    );
  }

  @override
  getFile() {
    throw UnimplementedError();
  }

  @override
  getData() {
    return fileData;
  }

  @override
  String getPath() {
    return path;
  }

  @override
  MimeType getType() {
    return mimeType;
  }

  @override
  String getName() {
    return fileName;
  }

  @override
  int getSizeBytes() {
    return sizeBytes;
  }
}
