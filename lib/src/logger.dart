import 'log_level.dart';
import 'log_message.dart';
import 'log_writer.dart';

/// Main class that provides Logging functionality
///
/// [tag] should be set to the name of the project
/// Can be used to ignore [LogMessage] from a particular tag
class Logger {
  final String name, tag;

  static LogWriter writer = const ConsolePrinter(minLevel: LogLevel.fine);

  const Logger(this.name, [this.tag = 'none']);

  /// Generic function which sends message to [LogWriter]
  ///
  /// This can either be used directly, but is more helpful to use level specific functions like [info], [warning] etc
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
  int get hashCode => name.hashCode + tag.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Logger && other.name == name && other.tag == tag;
}
