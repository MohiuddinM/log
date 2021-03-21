import 'log_level.dart';

/// A message that gets logged
///
/// In addition to just the message, it also contains information of which class
/// or package has generated this message
class LogMessage {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final String loggerName;
  final String loggerTag;
  final String? stackTrace;

  const LogMessage(
    this.level,
    this.message,
    this.timestamp,
    this.loggerName,
    this.loggerTag,
    this.stackTrace,
  );

  @override
  int get hashCode =>
      level.hashCode +
      message.hashCode +
      timestamp.hashCode +
      loggerName.hashCode +
      loggerName.hashCode +
      stackTrace.hashCode;

  @override
  bool operator ==(Object o) =>
      o is LogMessage &&
      o.level == level &&
      o.message == message &&
      o.timestamp == timestamp &&
      o.loggerName == loggerName &&
      o.loggerTag == loggerTag &&
      o.stackTrace == stackTrace;
}
