import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker/app/data/models/location_history.dart';
import 'package:location_tracker/app/data/providers/db.dart';
import 'package:location_tracker/app/services/location_services.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  var list = <LocationHistory>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadHistory() async {
    final data = await DBProvider.getAllData();
    list.assignAll(data);
  }

  Future<void> debugPrintAll() async {
    final data = await DBProvider.getAllData();
    for (var d in data) {
      print("ID: ${d.id} | ${d.date} | ${d.latitude}, ${d.longitude}");
    }
  }

  Future<void> saveCurrentLocation() async {
  Position pos = await Geolocator.getCurrentPosition();

  final date = DateFormat("yyyy-MM-dd").format(DateTime.now());

  await DBProvider.insert(
    LocationHistory(
      date: date,
      latitude: pos.latitude,
      longitude: pos.longitude,
      address: await LocationServices.getAddressFromLatLng(pos.latitude, pos.longitude),
    ),
  );

  await loadHistory(); // refresh UI
}

}
