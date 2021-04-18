import 'handler.dart';
import 'logger.dart';
import 'record.dart';

const _RESET = '\u001b[0m';
const _RED = '\u001b[31m';
const _GREEN = '\u001b[32m';
const _YELLOW = '\u001b[33m';
const _BLUE = '\u001b[34m';
const _PURPLE = '\u001b[35m';
const _LIGHT_BLUE = '\u001b[36m';

class PrintHandler implements Handler {
  static const COLORS = {
    Logger.DEBUG: _GREEN,
    Logger.INFO: _LIGHT_BLUE,
    Logger.NOTICE: _BLUE,
    Logger.WARNING: _YELLOW,
    Logger.ERROR: _RED,
    Logger.CRITICAL: _RED,
    Logger.ALERT: _PURPLE,
    Logger.EMERGENCY: _PURPLE,
  };

  @override
  bool handle(Record record) {
    var message = '[${record.levelName}] ${record.message}';

    if (record.level >= Logger.ERROR) {
      message += (record.stackTrace ?? StackTrace.current).toString();
    }

    final color = COLORS[record.level];

    print('$color$message$_RESET');

    return true;
  }

  @override
  void handleBatch(List<Record> records) => records.forEach((e) => handle(e));

  @override
  bool handles(int level) => true;

  @override
  void dispose() {}
}
