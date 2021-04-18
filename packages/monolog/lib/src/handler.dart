import 'record.dart';

abstract class Handler {
  /// Checks whether the given record will be handled by this handler.
  ///
  bool handles(int level);

  /// Handle a [Record].
  ///
  bool handle(Record record);

  /// Handle a set of records.
  ///
  void handleBatch(List<Record> records);

  /// Disposes any resources attached to the handler.
  ///
  /// When disposing the handler all buffers should be flushed, and any open
  /// resources have to be closed.
  ///
  void dispose() {}
}
