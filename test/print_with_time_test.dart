import 'package:fake_async/fake_async.dart';
import 'package:quick_log/quick_log.dart';
import 'package:quick_log/src/log_writer.dart';
import 'package:test/test.dart';

void main() {
  group('ConsolePrinterWithTime', () {
    test('prints no time when TimeSetting.none', () {
      final printer = ConsolePrinterWithTime(timeSetting: TimeSetting.none);
      Logger.writer = printer;
      final log = Logger('ConsolePrinterWithTimeTest');

      log.fine('fine');
      log.debug('debug');
      log.info('info');
      log.warning('warning');
      log.error('error', includeStackTrace: false);
    });

    test('prints time from start when TimeSetting.fromStart', () {
      return fakeAsync((async) {
        final printer =
            ConsolePrinterWithTime(timeSetting: TimeSetting.fromStart);
        Logger.writer = printer;
        final log = Logger('ConsolePrinterWithTimeTest');

        async.elapse(Duration(microseconds: 100));
        log.fine('fine');
        async.elapse(Duration(milliseconds: 1000));
        log.debug('debug');
        async.elapse(Duration(seconds: 50));
        log.info('info');
        async.elapse(Duration(seconds: 100));
        log.warning('warning');
        async.elapse(Duration(seconds: 1000));
        log.error('error', includeStackTrace: false);
      });
    });

    test('prints time from last message when TimeSetting.fromLastMessage', () {
      return fakeAsync((async) {
        final printer = ConsolePrinterWithTime(
            timeSetting: TimeSetting.fromPreviousMessage);
        Logger.writer = printer;
        final log = Logger('ConsolePrinterWithTimeTest');

        async.elapse(Duration(seconds: 10));
        log.fine('fine');
        async.elapse(Duration(seconds: 10));
        log.debug('debug');
        async.elapse(Duration(seconds: 10));
        log.info('info');
        async.elapse(Duration(seconds: 10));
        log.warning('warning');
        async.elapse(Duration(seconds: 10));
        log.error('error', includeStackTrace: false);
      });
    });
  });
}
