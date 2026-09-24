import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import 'app.dart';
import 'config.dart';

void main() {
  final client = OneBusAwayClient(
    baseUrl: Uri.parse(AppConfig.baseUrl),
    apiKey: AppConfig.apiKey,
  );
  runApp(StudentLifeDemoApp(client: client));
}
