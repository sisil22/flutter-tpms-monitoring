import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/mqtt_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'tire_data_model.dart';

class DiTrackingMapPage extends StatefulWidget {
  const DiTrackingMapPage({Key? key}) : super(key: key);

  @override
  _DiTrackingMapPageState createState() => _DiTrackingMapPageState();
}

class _DiTrackingMapPageState extends State<DiTrackingMapPage> {
  GoogleMapController? _mapController;
  late StreamSubscription<loc.LocationData> _locationSubscription;
  late loc.LocationData _currentLocation;
  final Set<Marker> _markers = {};
  ValueNotifier<Map<String, dynamic>> tireDataNotifier = ValueNotifier({});
  Map<String, dynamic> tireData = {};
  int currentIndex = 0;
  List<Map<String, dynamic>> tireDataList = [];
  late MqttService _mqttService;
  double focusLatitude = 0.0;
  double focusLongitude = 0.0;

  
  

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _mqttService = MqttService();
    final tireDataModel = Provider.of<TireDataModel>(context, listen: false);
    _mqttService.connect(context, tireDataModel, _updateMarker);
  }

  void _initializeLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    late loc.PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == loc.PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != loc.PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = location.onLocationChanged.listen((locationData) {
      setState(() {
        _currentLocation = locationData;
        final LatLng newPoint =
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!);

        if (_mapController != null) {
          _mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: newPoint, zoom: 15.0),
          ));
        }
      });
    });
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    print('Icon loaded: ${byteData?.buffer.lengthInBytes} bytes');
    return byteData!.buffer.asUint8List();
  }

  void _updateMarker(LatLng location, Map<String, dynamic> tireData, String time) async {
    final markerIcon = await _getBytesFromAsset('images/mobil.png', 300);

    final List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    final Placemark placemark = placemarks.first;
    final String thoroughfare = placemark.thoroughfare ?? '';
    final String subLocality = placemark.subLocality ?? '';
    final String locality = placemark.locality ?? '';
    final String administrativeArea = placemark.administrativeArea ?? '';
    final String postalCode = placemark.postalCode ?? '';
    final String country = placemark.country ?? '';

    final String completeAddress =
        '$thoroughfare, $subLocality, $locality, $administrativeArea $postalCode, $country';

    setState(() {
       focusLatitude = location.latitude;
       focusLongitude = location.longitude;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: location,
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Informasi Lokasi'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('ID TPMS: 12345'),
                      const SizedBox(height: 10),
                      Text('Front Right:'),
                      Text(' - Temp: ${tireData['frontRight']['temp']}°C'),
                      Text(' - Pressure: ${tireData['frontRight']['pressure']} Psi'),
                      Text('Front Left:'),
                      Text(' - Temp: ${tireData['frontLeft']['temp']}°C'),
                      Text(' - Pressure: ${tireData['frontLeft']['pressure']} Psi'),
                      Text('Back Left:'),
                      Text(' - Temp: ${tireData['backLeft']['temp']}°C'),
                      Text(' - Pressure: ${tireData['backLeft']['pressure']} Psi'),
                      Text('Back Right:'),
                      Text(' - Temp: ${tireData['backRight']['temp']}°C'),
                      Text(' - Pressure: ${tireData['backRight']['pressure']} Psi'),
                      const SizedBox(height: 10),
                      Text('Alamat: $completeAddress'),
                      Text('Waktu: $time'),
                    ],
                  ),

                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Tutup'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    });
    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(focusLatitude, focusLongitude)));
  }

@override
Widget build(BuildContext context) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<TireDataModel>(
        create: (_) => TireDataModel(),
      ),
      Provider<ValueNotifier<Map<String, dynamic>>>(
          create: (_) => ValueNotifier<Map<String, dynamic>>({}),
      ),
    ],
    child: Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Map'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(0, 0),
          zoom: 50.0,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    ),
  );
}

  @override
  void dispose() {
    _mapController?.dispose();
    _mqttService.disconnect();
    _locationSubscription.cancel();
    super.dispose();
  }
}

