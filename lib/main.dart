import 'dart:io';

import 'package:auth_page/router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(900, 900));
    WindowManager.instance.setMaximumSize(const Size(900, 900));

    WindowOptions windowOptions = const WindowOptions(
      size: Size(900, 900),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          routerConfig: router,
        );
      },
    );
  }
}
