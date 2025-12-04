import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/app/services/location_services.dart';
import 'package:workmanager/workmanager.dart' as workmanager;
import 'package:location_tracker/app/services/background_callback.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocationServices.checkLocationPermission();

  // ===== Android: WorkManager =====
  if (Platform.isAndroid) {
    await workmanager.Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    await workmanager.Workmanager().registerPeriodicTask(
      "dailyLocation",
      "trackLocation",
      frequency: const Duration(hours: 24),
      initialDelay: Duration.zero,
      constraints: workmanager.Constraints(
        networkType: workmanager.NetworkType.notRequired,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  // ===== iOS: BackgroundFetch =====
  if (Platform.isIOS) {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        startOnBoot: true,
        requiredNetworkType: NetworkType.NONE,
      ),
      (String taskId) async {
        print("[iOS] BackgroundFetch event received: $taskId");
        await trackLocationTask();
        BackgroundFetch.finish(taskId);
      },
      (String taskId) async {
        print("[iOS] BackgroundFetch timeout: $taskId");
        BackgroundFetch.finish(taskId);
      },
    );

    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
