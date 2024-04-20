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
    this.pastTravel,
  });

  // final TextEditingController controller;

  final Travel travel;
  final bool? pastTravel;
  

  DateTime _parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    return DateTime(1, 1, 1, hour, minute);
  }

  void initializeDateFormat() {
    initializeDateFormatting('es_ES', null);
  }
  String _dayOfWeekFormated(){
    String dayOfWeekFormated = "";
     String dayOfWeek= DateFormat('EEEE', 'es_ES')
                                  .format(DateTime.parse(travel.date));
    dayOfWeekFormated = "${dayOfWeek.substring(0, 1).toUpperCase()}${dayOfWeek.substring(1)}";  
    return dayOfWeekFormated;
  }

   Future<dynamic>?_onTapHandle(){
    print("llega a on tap");
    if(pastTravel != null){
      if(!pastTravel!){
          return Get.to(() => TravelDetails(selectedTravel: travel, pastTravel: pastTravel,));
      }
    }
    else{
       return Get.to(() => TravelDetails(selectedTravel: travel));
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormat();
    return InkWell(
      onTap: _onTapHandle,
      child: Card(
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
                    Text(
                       _dayOfWeekFormated(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                          DateFormat('hh:mm a')
                              .format(_parseTimeString(travel.hour)),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 22.0),
                          overflow: TextOverflow.ellipsis,
                        ),
              ]),
                    const SizedBox(width: 8),
                  

                Text(
                  'Desde: ${travel.startingPoint}',
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,

                ),
                Text(
                  'Hacia: ${travel.arrivalPoint}',
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                ),])
              
            )));
    

  }
}
