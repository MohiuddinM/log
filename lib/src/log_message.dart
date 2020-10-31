import 'package:equatable/equatable.dart';

import 'log_level.dart';

/// A message that gets logged
///
/// In addition to just the message, it also contains information of which class
/// or package has generated this message
class LogMessage extends Equatable {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final String loggerName;
  final String loggerTag;

  const LogMessage(
    this.level,
    this.message,
    this.timestamp,
    this.loggerName,
    this.loggerTag,
  );

  @override
  List<Object> get props => [level, message, timestamp, loggerName, loggerTag];
}
