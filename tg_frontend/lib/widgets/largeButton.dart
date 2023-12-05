import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  const LargeButton({
    super.key,
    // required this.controller,
    required this.text,
    required this.large,
    required this.onPressed,
    //required this.child
  });

  // final TextEditingController controller;

  final VoidCallback? onPressed;
  final String text;
  final bool large;
  //final Widget child;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).colorScheme.error,
          minimumSize: large ? const Size(300, 55) : const Size(140, 40)),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'Jost,'),
      ),
    );
  }
}
