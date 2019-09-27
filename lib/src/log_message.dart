import 'package:log/src/log_level.dart';

class LogMessage {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final String loggerName;
  final String loggerNamespace;

  const LogMessage(this.level, this.message, this.timestamp, this.loggerName, this.loggerNamespace);
}
