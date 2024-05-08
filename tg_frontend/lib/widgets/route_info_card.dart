import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:logger/logger.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = Logger();

const mapboxAccessToken =
    'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

class RouteInfoCard extends StatefulWidget {
  const RouteInfoCard({
    super.key,
    required this.passengersList,
    required this.travel,
  });

  final List<Passenger> passengersList;
  final Travel travel;

  @override
  State<RouteInfoCard> createState() => _RouteInfoCardState();
}

class _RouteInfoCardState extends State<RouteInfoCard> {
  User user = Environment.sl.get<User>();
  late LatLng coordinates;
  bool _hasCallSupport = false;
  Future<void>? _launched;

  @override
  void initState() {
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    coordinates =
        LatLng(widget.travel.startingPointLat, widget.travel.startingPointLong);
    super.initState();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final List<Marker> markers = widget.passengersList.map((passenger) {
      final marker = Marker(
        width: 100,
        height: 100,
        point: LatLng(passenger.pickupPointLat, passenger.pickupPointLong),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                //color: Color.fromARGB(102, 244, 67, 54),
                width: 90,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: const Color.fromARGB(75, 20, 5, 5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '  ${passenger.firstName}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.phone_enabled,
                        size: 20,
                      ),
                      onPressed: _hasCallSupport
                          ? () => setState(() {
                                _launched =
                                    _makePhoneCall(passenger.phoneNumber);
                              })
                          : null,
                    ),
                  ],
                )),
            Icon(
              Icons.boy_rounded,
              color: ColorManager.primaryColor,
              size: 30,
            ),
          ],
        ),
      );
      // centerPoint ??= LatLng(passenger.latitude, passenger.longitude);
      return marker;
    }).toList();

    markers.add(
      Marker(
          point: coordinates,
          child: Icon(
            Icons.location_on_sharp,
            color: ColorManager.fourthColor,
            size: 40,
          )),
    );

    return AlertDialog(
      backgroundColor: ColorManager.staticColor,
      title: Text('Mira tus pasajeros',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 15, fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: double.maxFinite,
        height: 300.0,
        child: FlutterMap(
          options: MapOptions(
              initialCenter: coordinates,
              minZoom: 5,
              maxZoom: 25,
              initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
              additionalOptions: const {
                'accessToken': mapboxAccessToken,
                'id': 'mapbox/streets-v11',
              },
            ),
            MarkerLayer(markers: markers),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cerrar',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
