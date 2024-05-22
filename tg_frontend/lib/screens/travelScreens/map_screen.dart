import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/available_travels.dart';
import 'package:tg_frontend/screens/travelScreens/new_travel.dart';
import 'package:tg_frontend/screens/travelScreens/travel_details.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';
import 'package:tg_frontend/widgets/lateral_bar.dart';
import 'package:tg_frontend/widgets/main_button.dart';
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

  late LatLng myPosition;
  LatLng universityPosition = const LatLng(3.3765821, -76.5334617);
  LatLng defaultLocation = const LatLng(3.435878, -76.520330);

  late Travel travelNotification;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    //FirebaseService().initializeFirebaseMessaging(context);
    // FirebaseService().initializeFirebaseMessaging(
    //   onMessageReceived: (RemoteMessage message) {
    //     travelNotification = Travel.fromJson(message.data);
    //     setState(() {});
    //     Provider.of<MapScreenProvider>(context, listen: false)
    //         .setShowNotificationCard(true);
    //   },
    //   onNotificationTypeReceived: (String notificationType) {
    //     // Manejar el tipo de notificación recibida si es necesario
    //   },
    // );
  }

  Future<void> _requestLocationPermission() async {
    await Permission.locationWhenInUse.request();
    if (await Permission.locationWhenInUse.request().isGranted) {
      await _getLocation();
      setState(() {});
    } else {
      myPosition = defaultLocation;
      await EasyLoading.showInfo("permiso de ubicación denegado");
      setState(() {});
    }
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    myPosition = LatLng(position.latitude, position.longitude);
    //setState(() {});
  }

  Future<LatLng> _getCenterPosition() async {
    _getLocation();
    if (myPosition != defaultLocation) {
      return myPosition;
    } else {
      return universityPosition;
    }
    // return myPosition;
  }

  @override
  Widget build(BuildContext context) {
    // bool showNotificationCard = Provider.of<MapScreenProviderhttps://{s}.tile.openstreetmap.org/%7Bz%7D/%7Bx%7D/%7By%7D.png>(context).showNotificationCard;
    // bool showNotificationCard =
    //     Provider.of<TravelNotificationProvider>(context).isTavelNotification;
    bool showNotificationCard =
        TravelNotificationProvider().isTavelNotification;

    print("build Map $showNotificationCard");
    return Consumer<TravelNotificationProvider>(
        builder: (context, notificationProvider, _) {
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
                              // fallbackUrl:
                              //     "https://a.tile.openstreetmap.org/15/${myPosition.latitude}/${myPosition.longitude}.png",

                              fallbackUrl:
                                  "https://www.openstreetmap.org/#map=15/${universityPosition.latitude}/${universityPosition.longitude}.png",
                              additionalOptions: const {
                                'accessToken': mapboxAccessToken,
                                'id': 'mapbox/streets-v11',
                              },
                              //tileProvider: CachedNetworkTileProvider()
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
                          Positioned(
                            top: 200,
                            right: 0,
                            child: NotificationCard(
                              onPressed: () {
                                travelNotification =
                                    notificationProvider.currentTravel;
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
                                  ? Get.to(() => NewTravel(
                                        startingPoint: myPosition,
                                        arrivalPoint: universityPosition,
                                      ))
                                  : Get.to(() => AvailableTravels(
                                        startingPoint: myPosition,
                                        arrivalPoint: universityPosition,
                                      ));
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
                                  ? Get.to(() => NewTravel(
                                        startingPoint: universityPosition,
                                        arrivalPoint: myPosition,
                                      ))
                                  : Get.to(() => AvailableTravels(
                                      startingPoint: universityPosition,
                                      arrivalPoint: myPosition));
                            },
                            large: true,
                          ),
                        )
                      ]);
                    }
                  })));
    });
  }
}
