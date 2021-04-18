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
}
