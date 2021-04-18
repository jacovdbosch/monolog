class Record {
  final String message;
  final Map<String, dynamic> context;
  final int level;
  final String levelName;
  final String channel;
  final DateTime dateTime;
  final Map<String, dynamic> extra;
  final StackTrace stackTrace;

  Record({
    this.message,
    this.context,
    this.level,
    this.levelName,
    this.channel,
    this.dateTime,
    this.extra = const {},
    this.stackTrace,
  });
}
