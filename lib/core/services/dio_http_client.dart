import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Configures Dio to bypass SSL certificate validation.
/// WARNING: Only use for development testing!
void configureDioForDevelopment(Dio dio) {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    },
  );
}
