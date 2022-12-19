import 'package:flutter/material.dart';

import 'layout/body.dart';

class OrderTrackingView extends StatelessWidget {
  const OrderTrackingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const CustomBackButton(),
        title: Text(
          'Order Details',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      ),
      body: const OrderTrackingViewBody(),
    );
  }
}
