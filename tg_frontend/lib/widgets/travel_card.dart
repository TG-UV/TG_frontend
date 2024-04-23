import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/travel_details.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';

class TravelCard extends StatefulWidget {
  const TravelCard({
    super.key,
    required this.travel,
    this.pastTravel,
  });

  // final TextEditingController controller;

  final Travel travel;
  final bool? pastTravel;
  @override
  State<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard> {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  String startingPointTextDirection = "";
  String arrivalPointTextDirection = "";

  @override
  void initState() {
    _getTextDirections();
    super.initState();
  }

  void _getTextDirections() async {
    arrivalPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.arrivalPointLat,
        long: widget.travel.arrivalPointLong);
    startingPointTextDirection = await travelDatasourceImpl.getTextDirection(
        lat: widget.travel.startingPointLat,
        long: widget.travel.startingPointLong);
    setState(() {});
  }

  DateTime _parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(1, 1, 1, hour, minute);
  }

  void initializeDateFormat() {
    initializeDateFormatting('es_ES', null);
  }

  String _dayOfWeekFormated() {
    String dayOfWeekFormated = "";
    String dayOfWeek =
        DateFormat('EEEE', 'es_ES').format(DateTime.parse(widget.travel.date));
    dayOfWeekFormated =
        "${dayOfWeek.substring(0, 1).toUpperCase()}${dayOfWeek.substring(1)}";
    return dayOfWeekFormated;
  }

  Future<dynamic>? _onTapHandle() {
    print("llega a on tap");
    if (widget.pastTravel != null) {
      if (!widget.pastTravel!) {
        return Get.to(() => TravelDetails(
              selectedTravel: widget.travel,
              pastTravel: widget.pastTravel,
            ));
      }
    } else {
      return Get.to(() => TravelDetails(selectedTravel: widget.travel));
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormat();
    return InkWell(
        onTap: _onTapHandle,
        child: Card(
            //color: const Color.fromARGB(255, 252, 252, 252),
            elevation: 8,
            shadowColor: ColorManager.secondaryColor,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              _dayOfWeekFormated(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              DateFormat('hh:mm a')
                                  .format(_parseTimeString(widget.travel.hour)),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 22.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Image(
                            image: AssetImage(
                              'assets/side2side.png',
                            ),
                            width: 50,
                            height: 70,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Desde: $startingPointTextDirection',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 15.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Hacia: $arrivalPointTextDirection',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontSize: 15.0),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ]))));
  }
}
