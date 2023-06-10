import 'dart:async';

import 'package:quick_log/quick_log.dart';
import 'package:test/test.dart';

void main() {
  test(
    'message is logged only if it is the onlyLevel',
    () async {
      for (final level in LogLevel.values) {
        final logWriter = LogStreamWriter(onlyLevel: level);
        Logger.writer = logWriter;
        final log = Logger('logger');
        final messages = <LogMessage>[];
        unawaited(logWriter.messages.forEach(messages.add));

        log.fine('fine');
        log.debug('debug');
        log.info('info');
        log.warning('warning');
        log.error('error');

        await logWriter.dispose();

        expect(messages.length, 1);
        expect(messages.last.level, level);
      }
    },
  );

  test(
    'message is logged only if it is above the minLevel',
    () async {
      for (final level in LogLevel.values) {
        final logWriter = LogStreamWriter(minLevel: level);
        Logger.writer = logWriter;
        final log = Logger('logger');
        final messages = <LogMessage>[];
        unawaited(logWriter.messages.forEach(messages.add));

        log.fine('fine');
        log.debug('debug');
        log.info('info');
        log.warning('warning');
        log.error('error');

        await logWriter.dispose();

        expect(messages.every((e) => e.level >= level), isTrue);
      }
    },
  );
}
