import 'package:quick_log/quick_log.dart';
import 'package:quick_log/src/log_writer.dart';
import 'package:test/test.dart';

class TestLogger1 extends Logger {
  const TestLogger1(String name) : super(name, 'TestWriter1');
}

class TestLogger2 extends Logger {
  const TestLogger2(String name) : super(name, 'TestWriter2');
}

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('First Test', () async {
      const log1 = TestLogger1('Main');
      const log2 = TestLogger2('MainTest2');

      Logger.writer = ConsolePrinter(onlyTags: [log1.tag]);

      log1.fine('fine message');
      log1.debug('debug message');
      log1.info('info message');
      log1.warning('warning message');
      log1.error('error message');
      log1.fine('fine message');
      log1.debug('debug message');
      log1.info('info message');
      log1.warning('warning message');
      log1.error('error message');

      log2.fine('fine message');
      log2.debug('debug message');
      log2.info('info message');
      log2.warning('warning message');
      log2.error('error message');

      final allWriter = LogStreamWriter();
      final only1Writer = LogStreamWriter(onlyTags: ['TestWriter1']);
      final only2Writer = LogStreamWriter(onlyTags: ['TestWriter2']);
      final except1Writer = LogStreamWriter(exceptTags: ['TestWriter1']);
      final except2Writer = LogStreamWriter(exceptTags: ['TestWriter2']);

      Logger.writer = allWriter;
      log1.fine('f1');
      expect(allWriter.lastMessage.message, 'f1');
      log2.fine('f2');
      expect(allWriter.lastMessage.message, 'f2');

      Logger.writer = only1Writer;
      log1.fine('f1');
      log2.fine('f2');
      expect(only1Writer.lastMessage.message, 'f1');

      Logger.writer = only2Writer;
      log2.fine('f2');
      log1.fine('f1');
      expect(only2Writer.lastMessage.message, 'f2');

      Logger.writer = except1Writer;
      log2.fine('f2');
      log1.fine('f1');
      expect(except1Writer.lastMessage.message, 'f2');

      Logger.writer = except2Writer;
      log1.fine('f1');
      log2.fine('f2');
      expect(except2Writer.lastMessage.message, 'f1');
    });
  });
}
