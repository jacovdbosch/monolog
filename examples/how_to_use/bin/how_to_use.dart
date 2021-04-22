import 'package:monolog/helpers.dart';
import 'package:monolog/monolog.dart';

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
}
