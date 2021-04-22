import 'package:meta/meta.dart';

import 'handler.dart';
import 'record.dart';

typedef Processor = Record Function(Record record);
typedef ExceptionHandler = void Function(Object error, Record record);

class Logger {
  /// Detailed debug information.
  ///
  static const DEBUG = 100;

  /// Interesting application events.
  ///
  static const INFO = 200;

  /// Uncommon events.
  ///
  static const NOTICE = 250;

  /// Exceptional occurrences that are not errors.
  ///
  /// E.g. Use of deprecated APIs or undesirable events that are not necessarily wrong.
  ///
  static const WARNING = 300;

  /// Runtime errors.
  ///
  static const ERROR = 400;

  /// Critical conditions.
  ///
  /// E.g. Application component unavailable, unexpected exception.
  ///
  static const CRITICAL = 500;

  /// Action must be taken immediately
  ///
  /// E.g. Entire backend down, database unavailable, etc.
  ///
  static const ALERT = 550;

  /// Urgent alert.
  ///
  static const EMERGENCY = 600;

  static const LEVELS = {
    DEBUG: 'DEBUG',
    INFO: 'INFO',
    NOTICE: 'NOTICE',
    WARNING: 'WARNING',
    ERROR: 'ERROR',
    CRITICAL: 'CRITICAL',
    ALERT: 'ALERT',
    EMERGENCY: 'EMERGENCY',
  };

  final String name;
  final List<Handler> handlers;
  final List<Processor> processors;
  final ExceptionHandler exceptionHandler;

  Logger(
    this.name, {
    this.handlers = const [],
    this.processors = const [],
    this.exceptionHandler,
  });

  /// Add a [Record]. Will return a [bool] indicating if the [Record] has been
  /// processed.
  ///
  bool addRecord(
    int level,
    String message, [
    Map<String, dynamic> context = const {},
    StackTrace stackTrace,
  ]) {
    Record record;

    for (final handler in handlers) {
      if (record == null) {
        if (!handler.handles(level)) continue;

        record = Record(
          message: message,
          context: context,
          level: level,
          levelName: LEVELS[level],
          channel: name,
          dateTime: DateTime.now(),
          stackTrace: stackTrace,
        );

        try {
          for (final processor in processors) {
            record = processor(record);
          }
        } catch (e) {
          handleError(e, record);

          return true;
        }
      }

      try {
        if (handler.handle(record)) {
          break;
        }
      } catch (e) {
        handleError(e, record);

        return true;
      }
    }

    return record != null;
  }

  /// Check whether the [Logger] has a [Handler] that listens to the given level.
  ///
  bool isHandling(int level) {
    for (final handler in handlers) {
      if (handler.handles(level)) return true;
    }

    return false;
  }

  /// Adds a [Record] at an arbitrary level.
  ///
  void log(
    int level,
    String message,
    Map<String, dynamic> context,
  ) =>
      addRecord(
        level,
        message,
        context,
      );

  /// Adds a [Record] at the [DEBUG] level
  ///
  void debug(String message, [Map<String, dynamic> context]) =>
      addRecord(DEBUG, message, context);

  /// Adds a [Record] at the [INFO] level
  ///
  void info(String message, [Map<String, dynamic> context]) =>
      addRecord(INFO, message, context);

  /// Adds a [Record] at the [NOTICE] level
  ///
  void notice(String message, [Map<String, dynamic> context]) =>
      addRecord(NOTICE, message, context);

  /// Adds a [Record] at the [WARNING] level
  ///
  void warning(String message, [Map<String, dynamic> context]) =>
      addRecord(WARNING, message, context);

  /// Adds a [Record] at the [ERROR] level
  ///
  void error(String message,
          [Map<String, dynamic> context, StackTrace stackTrace]) =>
      addRecord(
        ERROR,
        message,
        context,
        stackTrace ?? StackTrace.current,
      );

  /// Adds a [Record] at the [CRITICAL] level
  ///
  void critical(
    String message, [
    Map<String, dynamic> context,
    StackTrace stackTrace,
  ]) =>
      addRecord(
        CRITICAL,
        message,
        context,
        stackTrace ?? StackTrace.current,
      );

  /// Adds a [Record] at the [ALERT] level
  ///
  void alert(
    String message, [
    Map<String, dynamic> context,
    StackTrace stackTrace,
  ]) =>
      addRecord(
        ALERT,
        message,
        context,
        stackTrace ?? StackTrace.current,
      );

  /// Adds a [Record] at the [EMERGENCY] level
  ///
  void emergency(
    String message, [
    Map<String, dynamic> context,
    StackTrace stackTrace,
  ]) =>
      addRecord(
        EMERGENCY,
        message,
        context,
        stackTrace ?? StackTrace.current,
      );

  /// Delegates the exception management to the custom exception handler, or
  /// throws the exception if no custom handler is set.
  ///
  @protected
  void handleError(Object error, Record record) {
    if (exceptionHandler != null) {
      return exceptionHandler(error, record);
    }

    throw error;
  }

  /// Dispose the logger instance and any handlers attached to it.
  ///
  void dispose() {
    for (final handler in handlers) {
      handler.dispose();
    }
  }
}
