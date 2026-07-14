import 'dart:io';

import 'package:wassaly/core/imports/packages_imports.dart';

/// Configures Dio to bypass SSL certificate validation.
/// WARNING: Only use for development testing!
void configureDioForDevelopment(Dio dio) {
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient()
        ..badCertificateCallback = (cert, host, port) => true;
      return client;
    },
  );
}
