import 'dart:developer' as developer;

import 'package:monolog/helpers.dart';
import 'package:monolog/monolog.dart';

class _ErrorHandler implements Handler {
  @override
  void dispose() {}

  @override
  bool handle(Record record) {
    print('Logging error: ${record.message}');

    developer.log(
      record.levelName,
      stackTrace: record.stackTrace ?? StackTrace.current,
      name: record.levelName,
      level: record.level,
    );

    return true;
  }

  @override
  void handleBatch(List<Record> records) {
    records.forEach((element) => handle(element));
  }

  @override
  bool handles(int level) => level >= Logger.ERROR;
}

void main(List<String> arguments) {
  final logger = Logger('default', handlers: [PrintHandler()]);

  logger.debug('debug');
  logger.info('info');
  logger.notice('notice');
  logger.warning('warning');
  logger.error('error');
  logger.critical('critical');
  logger.alert('alert');
  logger.emergency('emergency');

  LoggerRegistry.instance.put(logger, isDefault: true);

  debug('debug through helper');
  info('info through helper');
  notice('notice through helper');
  warning('warning through helper');
  error('error through helper');
  critical('critical through helper');
  alert('alert through helper');
  emergency('emergency through helper');

  final errorLogger = Logger('error', handlers: [_ErrorHandler()]);

  LoggerRegistry.instance.put(errorLogger);

  print(errorLogger.isHandling(Logger.INFO));
  print(errorLogger.isHandling(Logger.ERROR));
  print(errorLogger.isHandling(Logger.EMERGENCY));

  final loggerFromRegistry = LoggerRegistry.instance('error');

  loggerFromRegistry.info('should not be shown');
  loggerFromRegistry.error('is shown :>');
}
