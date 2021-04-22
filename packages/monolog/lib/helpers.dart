import 'src/logger_registry.dart';

/// Adds a [Record] at an arbitrary level.
///
void log(int level, String message, Map<String, dynamic> context) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.log(level, message, context);
    // ignore: empty_catches
  } catch (e) {}
}

/// Adds a [Record] at the [DEBUG] level
///
void debug(String message, [Map<String, dynamic> context]) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.debug(message, context);
    // ignore: empty_catches
  } catch (e) {}
}

/// Adds a [Record] at the [INFO] level
///
void info(String message, [Map<String, dynamic> context]) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.info(message, context);
    // ignore: empty_catches
  } catch (e) {}
}

/// Adds a [Record] at the [NOTICE] level
///
void notice(String message, [Map<String, dynamic> context]) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.notice(message, context);
    // ignore: empty_catches
  } catch (e) {}
}

/// Adds a [Record] at the [WARNING] level
///
void warning(String message, [Map<String, dynamic> context]) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.warning(message, context);
    // ignore: empty_catches
  } catch (e) {}
}

/// Adds a [Record] at the [ERROR] level
///
void error(String message, [Map<String, dynamic> context]) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.error(message, context);
    // ignore: empty_catches
  } catch (e) {}
}

/// Adds a [Record] at the [CRITICAL] level
///
void critical(String message, [Map<String, dynamic> context]) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.critical(message, context);
    // ignore: empty_catches
  } catch (e) {}
}

/// Adds a [Record] at the [ALERT] level
///
void alert(String message, [Map<String, dynamic> context]) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.alert(message, context);
    // ignore: empty_catches
  } catch (e) {}
}

/// Adds a [Record] at the [EMERGENCY] level
///
void emergency(String message, [Map<String, dynamic> context]) {
  try {
    final logger = LoggerRegistry.instance.get();

    logger.emergency(message, context);
    // ignore: empty_catches
  } catch (e) {}
}
