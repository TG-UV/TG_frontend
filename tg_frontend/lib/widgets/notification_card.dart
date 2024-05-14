import 'package:flutter/material.dart';
import 'package:tg_frontend/screens/theme.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.6,
          height: 80,
          child: Card(

              //color: const Color.fromARGB(255, 252, 252, 252),
              elevation: 8,
              shadowColor: ColorManager.secondaryColor,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        " Viaje en curso ",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Opacity(
                              opacity: _controller.value,
                              child: IconButton(
                                onPressed: widget.onPressed,
                                icon: const Icon(Icons.double_arrow_sharp),
                                color: ColorManager.primaryColor,
                              ));
                        },
                      ),
                    ]),
              )),
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
