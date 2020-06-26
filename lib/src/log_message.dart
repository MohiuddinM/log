import 'log_level.dart';

class LogMessage {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final String loggerName;
  final String loggerTag;

  const LogMessage(this.level, this.message, this.timestamp, this.loggerName, this.loggerTag);
}
