import 'package:equatable/equatable.dart';

import 'log_level.dart';
import 'log_message.dart';
import 'log_writer.dart';

/// Main class that provides Logging functionality
///
/// [tag] should be set to the name of the project
/// Can be used to ignore [LogMessage] from a particular tag
class Logger extends Equatable {
  final String name, tag;

  static LogWriter _writer;

  static LogWriter get writer =>
      _writer ?? const ConsolePrinter(minLevel: LogLevel.fine);

  static set writer(LogWriter writer) => _writer = writer;

  const Logger(this.name, [this.tag = 'none']);

  void log(LogMessage message) {
    writer.write(message);
  }

  void fine(String message) {
    log(LogMessage(LogLevel.fine, message, DateTime.now(), name, tag));
  }

  void debug(String message) {
    log(LogMessage(LogLevel.debug, message, DateTime.now(), name, tag));
  }

  void info(String message) {
    log(LogMessage(LogLevel.info, message, DateTime.now(), name, tag));
  }

  void warning(String message) {
    log(LogMessage(LogLevel.warning, message, DateTime.now(), name, tag));
  }

  void error(String message) {
    log(LogMessage(LogLevel.error, message, DateTime.now(), name, tag));
  }

  @override
  List<Object> get props => [name, tag];
}
