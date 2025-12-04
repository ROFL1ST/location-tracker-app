import 'package:background_fetch/background_fetch.dart';
import 'package:location_tracker/app/services/location_services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker/app/data/providers/db.dart';
import 'package:location_tracker/app/data/models/location_history.dart';

// Android
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await trackLocationTask();
    return Future.value(true);
  });
}

// IOS
@pragma('vm:entry-point')
Future<void> backgroundFetchHeadlessTask(String taskId) async {
  await trackLocationTask();
  BackgroundFetch.finish(taskId);
}

Future<void> trackLocationTask() async {
  print("### CALLBACK STARTED at ${DateTime.now()} ###");

  try {
    Position pos = await Geolocator.getCurrentPosition();
    String address = await LocationServices.getAddressFromLatLng(pos.latitude, pos.longitude);
    print("### GOT LOCATION: ${pos.latitude}, ${pos.longitude} ###");

    final date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    await DBProvider.insert(
      LocationHistory(
        date: date,
        latitude: pos.latitude,
        longitude: pos.longitude,
        address: address,
      ),
    );

    print("### DATA SAVED ###");
  } catch (e) {
    print("### ERROR IN CALLBACK: $e ###");
  }
}
