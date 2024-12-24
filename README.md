An easy to use and extendable logging package for Dart. Especially useful for use in libraries, as it allows application to control logging from the imported libraries.

![Console Printer Output](https://raw.githubusercontent.com/MohiuddinM/log/master/console.png)

## Features
* Ability to filter logs from imported libraries
* 100% configurable (print logs to console, write to file or send to backend all possible!)
* Similar to other logging packages, so nothing new to learn

## Usage

A simple usage example:

```dart
import 'package:quick_log/quick_log.dart';

void main() {
  const log = Logger('LogExample');

  log.debug('this is a debug message');
  log.info('this is an info message');
}
```

Configuring logger output:
```dart
import 'package:quick_log/quick_log.dart';

void main() {
  const log = Logger('LogExample');

  Logger.writer = ConsolePrinter(minLevel: LogLevel.info);

  log.d('this is a debug message');
  log.i('this is an info message');
}
```

Ignoring logs:
```dart
import 'package:quick_log/quick_log.dart';

class ExampleLogger extends Logger {
  const ExampleLogger(String name) : super(name, 'ExampleLogger');
}

void main() {
  const log = ExampleLogger('LogExample');

  Logger.writer = ConsolePrinter(onlyTags: []);
  // Or
  Logger.writer = ConsolePrinter(exceptTags: [log.name]);

  // These messages won't be printed
  log.d('this is a debug message');
  log.i('this is an info message');
}
```

Can be used in tests by using the LogStreamWriter:
```dart
import 'package:quick_log/quick_log.dart';

test('test', () {
  const log = Logger('LogExample');
  final writer = LogStreamWriter();
  Logger.writer = writer;

  log.i('this line was executed');
  
  expect(writer.pastMessages.length, 1);
  expect(writer.lastMessage.message, 'this is an info message');
});
```

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/MohiuddinM/log
