import 'package:flutter/material.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:get/get.dart';
import 'package:tg_frontend/widgets/driver_details_card.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    super.key,
    required this.travel,
    
  });

  final Travel travel;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}
class _NotificationCardState extends State<NotificationCard> {
  
  late VoidCallback onPressed;


  @override
  void initState() {
    _getOnPressed();
    super.initState();
  }

  _getOnPressed (){
    
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      color: const Color(0xFFDD3D32),
     
      child: InkWell(
        onTap: onPressed, 
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                  "Miercoles",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                
              const SizedBox(width: 10),
              Text(
                  widget.travel.hour,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 23.0),
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(width: 8),
            ],
          ),
          Text(
            " Alerta de pasajero",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
      
    )));
  }
}
