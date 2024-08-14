import 'package:explension/models/source.dart';
import 'package:explension/utils/logger.dart';
import 'package:hive/hive.dart';

class SourceService {
  final logger = Logger();
  final Box _sourceBox = Hive.box('sources');

  // Add a method to initialize default sources
  Future<void> initializeDefaultSources() async {
    if (_sourceBox.isEmpty) {
      final defaultSources = [
        Source(id: 1, name: 'Cash'),
        Source(id: 2, name: 'Gopay'),
        Source(id: 3, name: 'OVO'),
      ];
      await _sourceBox.addAll(defaultSources);
    }
  }

  // Get all sources from the Hive box
  List<Source> getSources() {
    return _sourceBox.values.cast<Source>().toList();
  }
}
