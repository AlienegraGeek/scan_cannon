import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:scan_cannon/select_scanner_style_page.dart';
import 'package:scan_cannon/task_next_page.dart';

import 'creator_page.dart';
import 'custom_size_scanner_page.dart';
import 'full_screen_scanner_page.dart';
import 'index.dart';

Future<void> main() async {
  await GetStorage.init();
  // final box = GetStorage();
  runApp(GetMaterialApp(
    // initialRoute: box.hasData("token")?'/':'/login',
    initialRoute: '/',
    enableLog: false,
    debugShowCheckedModeBanner: false,
    locale: Locale('zh', 'CH'),
    localizationsDelegates: [
      GlobalCupertinoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('zh', 'CH'),
    ],
    getPages: [
      GetPage(name: '/', page: () => IndexPage()),
      GetPage(name: '/SelectScannerStylePage', page: () => SelectScannerStylePage()),
      GetPage(name: '/CustomSizeScannerPage', page: () => CustomSizeScannerPage()),
      GetPage(name: '/FullScreenScannerPage', page: () => FullScreenScannerPage()),
      GetPage(name: '/TaskNextPage', page: () => TaskNextPage()),
      GetPage(name: '/CreatorPage', page: () => CreatorPage()),
    ],
  ));
}
