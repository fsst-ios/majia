import '../domain/data_project.dart';

abstract interface class ProjectStore {
  Future<DataProject?> load();
  Future<void> save(DataProject project);
  Future<void> clear();
}

class MemoryProjectStore implements ProjectStore {
  DataProject? value;

  @override
  Future<void> clear() async => value = null;

  @override
  Future<DataProject?> load() async => value;

  @override
  Future<void> save(DataProject project) async => value = project;
}
