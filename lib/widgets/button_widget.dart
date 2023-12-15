import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final int? height;
  final Widget? child;
  final void Function()? onPressed;
  const ButtonWidget({super.key, this.height, this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height?.toDouble() ?? 50,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor),
        child: child ?? const Text('Mulai'),
      ),
    );
  }
}
