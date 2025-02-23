import 'package:flutter/material.dart';

class PaymentTile extends StatelessWidget {
  String title;
  Icon icon;
  PaymentTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
