import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/travel_details.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TravelCard extends StatelessWidget {
  const TravelCard({
    super.key,
    required this.travel,
    required this.pastTravel,
  });

  // final TextEditingController controller;

  final Travel travel;
  final bool pastTravel;

  DateTime _parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(1, 1, 1, hour, minute);
  }

  void initializeDateFormat() {
    initializeDateFormatting('es_ES', null);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormat();
    return Card(
        color: const Color.fromARGB(255, 252, 252, 252),
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
                    TextButton(
                      child: Text(
                        DateFormat('EEEE', 'es_ES')
                            .format(DateTime.parse(travel.date)),
                        //travel.date,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      onPressed: () {
                        Get.to(() => TravelDetails(
                            selectedTravel: travel, pastTravel: pastTravel));
                      },
                    ),
                    TextButton(
                      child: Text(
                        DateFormat('hh:mm a')
                            .format(_parseTimeString(travel.hour)),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 22.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        Get.to(() => TravelDetails(
                              selectedTravel: travel,
                              pastTravel: pastTravel,
                            ));
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                // Align(
                //     alignment: Alignment.centerLeft,
                //  child:

                Text(
                  'Desde: ${travel.startingPoint}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Hacia: ${travel.arrivalPoint}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            )));
  }
}
