import 'package:flutter/material.dart';

class PaymentTile extends StatelessWidget {
  String title;
  Icon icon;
  String? value;
  Function() onPress;
  PaymentTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onPress,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: icon,
      title: Text(value ?? title),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
