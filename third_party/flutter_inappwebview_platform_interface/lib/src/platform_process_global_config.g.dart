
part of 'platform_process_global_config.dart';

class ProcessGlobalConfigSettings {
  String? dataDirectorySuffix;

  ProcessGlobalConfigDirectoryBasePaths? directoryBasePaths;
  ProcessGlobalConfigSettings(
      {this.dataDirectorySuffix, this.directoryBasePaths});

  static ProcessGlobalConfigSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ProcessGlobalConfigSettings(
      dataDirectorySuffix: map['dataDirectorySuffix'],
      directoryBasePaths: ProcessGlobalConfigDirectoryBasePaths.fromMap(
          map['directoryBasePaths']?.cast<String, dynamic>()),
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "dataDirectorySuffix": dataDirectorySuffix,
      "directoryBasePaths": directoryBasePaths?.toMap(),
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  ProcessGlobalConfigSettings copy() {
    return ProcessGlobalConfigSettings.fromMap(toMap()) ??
        ProcessGlobalConfigSettings();
  }

  @override
  String toString() {
    return 'ProcessGlobalConfigSettings{dataDirectorySuffix: $dataDirectorySuffix, directoryBasePaths: $directoryBasePaths}';
  }
}

class ProcessGlobalConfigDirectoryBasePaths {
  String cacheDirectoryBasePath;

  String dataDirectoryBasePath;
  ProcessGlobalConfigDirectoryBasePaths(
      {required this.cacheDirectoryBasePath,
      required this.dataDirectoryBasePath});

  static ProcessGlobalConfigDirectoryBasePaths? fromMap(
      Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = ProcessGlobalConfigDirectoryBasePaths(
      cacheDirectoryBasePath: map['cacheDirectoryBasePath'],
      dataDirectoryBasePath: map['dataDirectoryBasePath'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "cacheDirectoryBasePath": cacheDirectoryBasePath,
      "dataDirectoryBasePath": dataDirectoryBasePath,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ProcessGlobalConfigDirectoryBasePaths{cacheDirectoryBasePath: $cacheDirectoryBasePath, dataDirectoryBasePath: $dataDirectoryBasePath}';
  }
}
