import 'package:flutter/material.dart';
import 'package:tg_frontend/widgets/notification_card.dart';
import 'package:tg_frontend/models/travel_model.dart';

class ListedNotifications extends StatefulWidget {
  const ListedNotifications({
    super.key,
  });

  // final TextEditingController controller;

  @override
  State<ListedNotifications> createState() => _ListedNotificationsState();
}

class _ListedNotificationsState extends State<ListedNotifications> {
  List<Travel> travelsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            alignment: Alignment.topCenter,
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Notificaciones",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 30),
                  //const TravelCard(),

                  Expanded(
                      child: ListView.builder(
                          itemCount: travelsList.length,
                          itemBuilder: (context, index) {
                            return NotificationCard(travel: travelsList[index]);
                          }))
                ])));
  }
}
