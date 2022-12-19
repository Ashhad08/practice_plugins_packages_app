import 'package:flutter/material.dart';

class OrderTrackingViewBody extends StatelessWidget {
  const OrderTrackingViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Order Number',
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                'OR# 67393',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
            child: Stepper(
              margin: EdgeInsets.zero,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return const SizedBox();
              },
              steps: [
                _buildStep(context, 'Order Placed',
                    'We have received your order', true),
                _buildStep(context, 'Order Confirmed',
                    'Your order has been confirmed', false),
                _buildStep(context, 'Order Processed',
                    'We are preparing your order', false),
                _buildStep(context, 'Ready to pickup',
                    'Your order is ready to pickup', false),
                _buildStep(context, 'Order on the way',
                    'Your order on the way for delivery', false),
                _buildStep(
                    context, 'Order delivered', 'Enjoy your meat!!', false),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Step _buildStep(
    BuildContext context, String title, String subtitle, bool isActive) {
  return Step(
    title: ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.caption,
      ),
    ),
    isActive: isActive,
    content: const SizedBox(),

    // state: StepState.complete
    //TODO: work on step state, if a step is completed etc.
  );
}
