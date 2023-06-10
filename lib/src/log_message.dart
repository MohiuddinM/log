import 'log_level.dart';
import 'logger.dart';

/// A message that gets logged
///
/// In addition to just the message, it also contains information of which class
/// or package has generated this message
class LogMessage {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final Logger logger;
  final String? stackTrace;

  const LogMessage(
    this.level,
    this.message,
    this.timestamp,
    this.stackTrace,
    this.logger,
  );

  @override
  int get hashCode =>
      Object.hash(level, message, timestamp, logger, stackTrace);

  @override
  bool operator ==(Object o) =>
      o is LogMessage &&
      o.level == level &&
      o.message == message &&
      o.timestamp == timestamp &&
      o.logger == logger &&
      o.stackTrace == stackTrace;
}
