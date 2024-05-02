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

class _NotificationCardState extends State<NotificationCard> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPressed,
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
                      "¡ Viaje en curso !",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                            opacity: _controller.value,
                            child: const Icon(Icons.arrow_forward_ios_rounded));
                      },
                    ),
                  ]),
            )));
  }
}
