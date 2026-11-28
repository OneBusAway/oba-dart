import 'package:flutter/material.dart';

import 'app.dart';
import 'oba_setup.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final oba = await createObaApplication(map: await studentLifeMapConfig());
  runApp(StudentLifeApp(oba: oba, settings: StudentLifeSettings()));
}
