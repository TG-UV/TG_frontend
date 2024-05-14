import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:tg_frontend/screens/theme.dart';
import 'package:tg_frontend/screens/travelScreens/travel_details.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:provider/provider.dart';
import 'package:tg_frontend/services/travel_notification_provider.dart';
import 'package:tg_frontend/utils/date_Formatter.dart';

class TravelCard extends StatefulWidget {
  const TravelCard({
    super.key,
    required this.travel,
    this.pastTravel,
  });

  final Travel travel;
  final bool? pastTravel;
  @override
  State<TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<TravelCard> with TickerProviderStateMixin {
  TravelDatasourceMethods travelDatasourceImpl =
      Environment.sl.get<TravelDatasourceMethods>();
  String startingPointTextDirection = "";
  String arrivalPointTextDirection = "";
  late AnimationController _controller;

  @override
  void initState() {
    _getTextDirections();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
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

  Future<dynamic>? _onTapHandle() {
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //bool isTravelNotification = Provider.of<TravelNotificationProvider>(context).isNewPassengerNotification;
    return Consumer<TravelNotificationProvider>(
        builder: (context, notificationProvider, _) {
      return InkWell(
          onTap: _onTapHandle,
          child: Card(
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
                              if (notificationProvider.isTavelNotification &&
                                  notificationProvider.idTravelNotification ==
                                      widget.travel.id)
                                AnimatedBuilder(
                                  animation: _controller,
                                  builder: (context, child) {
                                    return Opacity(
                                        opacity: _controller.value,
                                        child: const Icon(
                                            Icons.mark_unread_chat_alt_sharp));
                                  },
                                ),
                              Text(
                                DateFormatter()
                                    .dayOfWeekFormated(widget.travel.date),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                DateFormatter().timeFormatedTextController(
                                    widget.travel.hour),
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
    });
  }
}
