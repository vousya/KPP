import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AnalyticsWrapper {
  static final _analytics = FirebaseAnalytics.instance;

  static Future<T> wrap<T>(
    String event,
    Map<String, Object> params,
    Future<T> Function() call,
  ) async {
    String status = 'failed';
    String? error;

    try {
      final result = await call();
      status = 'success';
      return result;
    } on FirebaseAuthException catch (e, s) {
      error = e.message ?? e.code;
      await Sentry.captureException(e, stackTrace: s);
      rethrow;
    } catch (e, s) {
      error = e.toString();
      await Sentry.captureException(e, stackTrace: s);
      rethrow;
    } finally {
      await _analytics.logEvent(
        name: event,
        parameters: {
          ...params,
          'time': DateTime.now().toIso8601String(),
          'status': status,
          if (error != null) 'error': error,
        },
      );
    }
  }
}