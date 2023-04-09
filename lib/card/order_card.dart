import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            OrderCard(),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  'Order Number : ',
                ),
                Text(
                  '#ORD12344',
                ),
                Spacer(),
                Text('20-09-2022')
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashColor: Colors.grey,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text('Ace Hardwares'),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: const [
                Text('Total Amonut : '),
                Text('\$ 1600'),
                SizedBox(
                  width: 10,
                ),
                Text('Qty : '),
                Text('10'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.access_time_outlined,
                  color: Colors.blue,
                  size: 20,
                ),
                const Text(
                  'Procssing',
                  style: TextStyle(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
