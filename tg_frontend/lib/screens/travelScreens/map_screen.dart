import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/available_travels.dart';
import 'package:tg_frontend/screens/travelScreens/new_travel.dart';
import 'package:tg_frontend/screens/travelScreens/travel_details.dart';
import 'package:tg_frontend/services/firebase.dart';
import 'package:tg_frontend/services/map_screen_provider.dart';
import 'package:tg_frontend/widgets/lateral_bar.dart';
import 'package:tg_frontend/widgets/main_button.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:tg_frontend/models/user_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:tg_frontend/widgets/notification_card.dart';

const mapboxAccessToken =
    'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late loc.LocationData currentLocation;
  User user = Environment.sl.get<User>();

  // LatLng? myPosition = const LatLng(3.3765821, -76.5334617);
  late LatLng myPosition;
  LatLng universityPosition = const LatLng(3.3765821, -76.5334617);
  late Travel travelNotification;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    FirebaseService().initializeFirebaseMessaging(
      onMessageReceived: (RemoteMessage message) {
        travelNotification = Travel.fromJson(message.data);
        setState(() {});
        Provider.of<MapScreenProvider>(context, listen: false)
            .setShowNotificationCard(true);
      },
      onNotificationTypeReceived: (String notificationType) {
        // Manejar el tipo de notificación recibida si es necesario
      },
    );
  }

  Future<void> _requestLocationPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      await _getLocation();
    } else {
      await EasyLoading.showInfo("permiso denegado");
    }
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    myPosition = LatLng(position.latitude, position.longitude);
    setState(() {});
  }

  Future<LatLng> _getCenterPosition() async {
    //_getLocation();
    if (myPosition != null) {
      return myPosition!;
    } else {
      return universityPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showNotificationCard =
        Provider.of<MapScreenProvider>(context).showNotificationCard;

    return PopScope(
        canPop: false,
        onPopInvoked: (bool isPopGesture) {
          SystemNavigator.pop();
        },
        child: Scaffold(
            drawer: LateralBar(),
            body: FutureBuilder<LatLng>(
                future: _getCenterPosition(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ));
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Ops :(  ha ocurrido un error'));
                  } else {
                    myPosition = snapshot.data!;
                    return Stack(children: [
                      FlutterMap(
                        options: MapOptions(
                            initialCenter: myPosition,
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
                          MarkerLayer(markers: [
                            Marker(
                              point: myPosition,
                              child: Icon(
                                Icons.location_on_sharp,
                                color: ColorManager.fourthColor,
                                size: 40,
                              ),
                            )
                          ]),
                        ],
                      ),
                      Positioned(
                          top: 100.0,
                          left: 50,
                          right: 50,
                          child: Text(
                            '¡Hola ${user.firstName.substring(0, 1).toUpperCase()}${user.firstName.substring(1)}!',
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                      Positioned(
                        top: 50.0,
                        left: MediaQuery.of(context).size.width / 1.2,
                        right: 50,
                        child: Builder(builder: (BuildContext context) {
                          return FloatingActionButton(
                            onPressed: () {
                              Scaffold.of(context)
                                  .openDrawer(); // Abre el menú lateral
                            },
                            backgroundColor: Colors.transparent,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.boy_rounded,
                              color: Colors.black,
                              size: 50,
                            ),
                          );
                        }),
                      ),
                      if (showNotificationCard)
                        Center(
                          child: NotificationCard(
                            onPressed: () {
                              Get.to(() => TravelDetails(
                                  selectedTravel: travelNotification));
                            },
                          ),
                        ),
                      Positioned(
                        top: MediaQuery.of(context).size.width / 0.8,
                        left: 50,
                        right: 50,
                        child: MainButton(
                          text: 'Voy para la U',
                          buttonColor: ColorManager.fourthColor,
                          onPressed: () {
                            user.type == 2
                                ? Get.to(() => const NewTravel())
                                : Get.to(() => const AvailableTravels());
                          },
                          large: true,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.width / 0.8 + 100,
                        left: 50,
                        right: 50,
                        child: MainButton(
                          text: 'Salgo de la U',
                          buttonColor: ColorManager.fourthColor,
                          onPressed: () {
                            user.type == 2
                                ? Get.to(() => const NewTravel())
                                : Get.to(() => const AvailableTravels());
                          },
                          large: true,
                        ),
                      )
                    ]);
                  }
                })));
  }
}
