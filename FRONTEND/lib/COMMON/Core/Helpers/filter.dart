

// Base file filter for creating other filters
abstract class FileFilter {
  /// Checking if file is valid or not
  /// if it was valid then return [true] else [false]
  bool isValid(String path, String root);
}