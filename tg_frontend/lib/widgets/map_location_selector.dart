import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/widgets/main_button.dart';

const mapboxAccessToken =
    'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

class MapSelectionScreen extends StatefulWidget {
  final void Function(LatLng) onLocationSelected;

  const MapSelectionScreen({super.key, required this.onLocationSelected});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng? _selectedLocation;
  LatLng myPosition = const LatLng(3.3765821, -76.5334617);

  Future<void> _getPositionCoordinates() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      myPosition = LatLng(position.latitude, position.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getPositionCoordinates();
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          options: MapOptions(
              initialCenter: myPosition,
              onTap: (tapPosition, latlng) {
                _handleTap(latlng);
              },
              minZoom: 5,
              maxZoom: 25,
              initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            
              fallbackUrl:
                  "https://www.openstreetmap.org/#map=15/${myPosition.latitude}/${myPosition.longitude}.png",
              additionalOptions: const {
                'accessToken': mapboxAccessToken,
                'id': 'mapbox/streets-v11',
              },
            ),
            MarkerLayer(
              markers: [
                if (_selectedLocation != null)
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _selectedLocation!,
                    child: Icon(
                      Icons.location_on_sharp,
                      color: ColorManager.fourthColor,
                      size: 40,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ]),
    );
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      _selectedLocation = latlng;
    });
    widget.onLocationSelected(latlng);
  }
}
