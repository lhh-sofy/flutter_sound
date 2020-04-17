import 'dart:io';
import 'dart:typed_data';

import 'file_management.dart' as fm;

/// Used to track temporary media files
/// that need to be deleted once they
/// are no longer used.
/// Call the [delete] method to cleanup the temp file.
class TempMediaFile {
  /// path to the temporary media file.
  String path;

  bool _deleted = false;

  /// Track a temporary media file
  /// [path] to the temporary file.
  TempMediaFile(this.path);

  /// Deletes the temporary media file.
  void delete() {
    if (_deleted) {
      throw TempMediaFileAlreadyDeletedException(
          "The file $path has already been deleted");
    }
    if (fm.exists(path)) fm.delete(path);
    _deleted = true;
  }

  /// Writes [dataBuffer] to a temporary file
  /// and returns the path to that file.
  TempMediaFile.fromBuffer(Uint8List dataBuffer) {
    path = fm.tempFile();

    if (fm.exists(path)) {
      fm.delete(path);
    }
    File(path).writeAsBytesSync(dataBuffer); // Write
  }
}

/// You tried to delete a temporary media file that has already
/// been deleted.
class TempMediaFileAlreadyDeletedException implements Exception {
  final String _message;

  ///
  TempMediaFileAlreadyDeletedException(this._message);

  String toString() => _message;
}
