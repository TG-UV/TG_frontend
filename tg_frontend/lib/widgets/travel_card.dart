import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/travelScreens/travel_details.dart';
import 'package:get/get.dart';

class TravelCard extends StatelessWidget {
  const TravelCard({
    super.key,
    required this.travel,
  });

  // final TextEditingController controller;

  final Travel travel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0xFFDD3D32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  child: Text(
                    travel.dateFormatted,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  onPressed: () {
                    Get.to(() => TravelDetails(selectedTravel: travel));
                  },
                ),
                const SizedBox(width: 10),
                TextButton(
                  child: Text(
                    travel.hourFormatted,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 25.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () {
                    Get.to(() => TravelDetails(selectedTravel: travel));
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '    Desde: ${travel.startingPoint}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'Hacia: ${travel.arrivalPoint}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
