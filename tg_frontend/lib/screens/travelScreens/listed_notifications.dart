import 'package:flutter/material.dart';
import 'package:tg_frontend/widgets/notification_card.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';

class ListedNotifications extends StatefulWidget {
  const ListedNotifications({
    super.key,
  });

  // final TextEditingController controller;

  @override
  State<ListedNotifications> createState() => _ListedNotificationsState();
}

class _ListedNotificationsState extends State<ListedNotifications> {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  User user = Environment.sl.get<User>();

  late List<Travel> travelsList;

  _fetchTravelsStream() async* {
    final value = await travelDatasourceImpl.getTravelsRemote();
    yield value;
  }
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
                  Expanded(
                      child: StreamBuilder<List<Travel>>(
                          stream:
                              _fetchTravelsStream(), 
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              travelsList = snapshot.data ?? [];
                              return ListView.builder(
                                  itemCount: travelsList.length,
                                  itemBuilder: (context, index) {
                                    return ListView.builder(
                                        itemCount: travelsList.length,
                                        itemBuilder: (context, index) {
                                          return NotificationCard(
                                              travel: travelsList[index]);
                                        });
                                  });
                            }
                          }))
                ])
            // Expanded(
            //     child: ListView.builder(
            //         itemCount: travelsList.length,
            //         itemBuilder: (context, index) {
            //           return NotificationCard(travel: travelsList[index]);
            //         }))
            ));
  }
}
