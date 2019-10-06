import 'log_message.dart';
import 'log_writer.dart';
import 'log_level.dart';

class Logger {
  final String name, namespace;

  //static final Map<String, Map<String, Logger>> _instances = {};

  static LogWriter _writer;

  static LogWriter get writer => _writer ?? ConsolePrinter(minLevel: LogLevel.fine);

  static set writer(LogWriter writer) => _writer = writer;

  const Logger(this.name, [this.namespace = '']);

  void log(LogMessage message) {
    writer.write(message);
  }

  void fine(String message) {
    log(LogMessage(LogLevel.fine, message, DateTime.now(), name, namespace));
  }

  void debug(String message) {
    log(LogMessage(LogLevel.debug, message, DateTime.now(), name, namespace));
  }

  void info(String message) {
    log(LogMessage(LogLevel.info, message, DateTime.now(), name, namespace));
  }

  void warning(String message) {
    log(LogMessage(LogLevel.warning, message, DateTime.now(), name, namespace));
  }

  void error(String message) {
    log(LogMessage(LogLevel.error, message, DateTime.now(), name, namespace));
  }
}
