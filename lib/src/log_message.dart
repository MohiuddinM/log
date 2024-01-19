import 'log_level.dart';
import 'logger.dart';

/// A message that gets logged
///
/// In addition to just the message, it also contains information of which class
/// or package has generated this message
class LogMessage {
  const LogMessage(
    this.level,
    this.message,
    this.timestamp,
    this.stackTrace,
    this.logger,
  );

  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final Logger logger;
  final String? stackTrace;

  @override
  int get hashCode => Object.hash(
        level,
        message,
        timestamp,
        logger,
        stackTrace,
      );

  @override
  bool operator ==(Object other) =>
      other is LogMessage &&
      other.level == level &&
      other.message == message &&
      other.timestamp == timestamp &&
      other.logger == logger &&
      other.stackTrace == stackTrace;
}
