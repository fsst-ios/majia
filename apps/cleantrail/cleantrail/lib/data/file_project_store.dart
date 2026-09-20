import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/data_project.dart';
import 'project_store.dart';

class FileProjectStore implements ProjectStore {
  FileProjectStore({Future<Directory> Function()? directoryProvider})
    : _directoryProvider =
          directoryProvider ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _directoryProvider;

  Future<File> _projectFile() async {
    final directory = await _directoryProvider();
    return File('${directory.path}/cleantrail-project.json');
  }

  File _temporaryFile(File projectFile) => File('${projectFile.path}.tmp');

  File _backupFile(File projectFile) => File('${projectFile.path}.backup');

  @override
  Future<void> clear() async {
    final file = await _projectFile();
    final temporary = _temporaryFile(file);
    if (await temporary.exists()) await temporary.delete();
    final backup = _backupFile(file);
    if (await backup.exists()) await backup.delete();
    // Delete the authoritative snapshot last. If removal of an auxiliary file
    // fails, the current project remains restorable and the controller can
    // truthfully keep showing it.
    if (await file.exists()) await file.delete();
  }

  @override
  Future<DataProject?> load() async {
    final file = await _projectFile();
    if (!await file.exists()) {
      final backup = _backupFile(file);
      if (!await backup.exists()) return null;
      return _decode(backup);
    }
    try {
      return await _decode(file);
    } on Object {
      final backup = _backupFile(file);
      if (!await backup.exists()) rethrow;
      return _decode(backup);
    }
  }

  @override
  Future<void> save(DataProject project) async {
    final file = await _projectFile();
    final temporary = _temporaryFile(file);
    final backup = _backupFile(file);
    await temporary.writeAsString(jsonEncode(project.toJson()), flush: true);
    if (await file.exists()) await file.copy(backup.path);
    await temporary.rename(file.path);
  }

  Future<DataProject> _decode(File file) async {
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return DataProject.fromJson(json);
  }
}
