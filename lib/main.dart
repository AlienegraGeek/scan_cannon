import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:scan_cannon/scan/custom_scan/custom_scan_view.dart';
import 'package:scan_cannon/scan/select_scanner_style_page.dart';
import 'package:scan_cannon/scan/task_next_page.dart';
import 'package:scan_cannon/usb/usb_quick.dart';
import 'package:scan_cannon/usb/usb_serial_view.dart';

import 'scan/creator_page.dart';
import 'scan/full_screen_scanner_page.dart';
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
      GetPage(name: '/CustomSizeScannerPage', page: () => CustomScanPage()),
      GetPage(name: '/FullScreenScannerPage', page: () => FullScreenScannerPage()),
      GetPage(name: '/TaskNextPage', page: () => TaskNextPage()),
      GetPage(name: '/CreatorPage', page: () => CreatorPage()),
      GetPage(name: '/UsbSerialPage', page: () => UsbSerialView()),
      GetPage(name: '/UsbQuickPage', page: () => UsbQuick()),
    ],
  ));
}
