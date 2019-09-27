import 'package:log/log.dart';

class ExampleLogger extends Logger {
  const ExampleLogger(String name) : super(name, 'ExampleLogger');
}

void main() {
  const log = ExampleLogger('LogExample');

  Logger.writer = ConsolePrinter(minLevel: LogLevel.info);

  log.debug('this is a debug message');
  log.info('this is an info message');
}
