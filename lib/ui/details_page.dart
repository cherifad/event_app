import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/poll.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required Center child, required this.poll});
  final Poll poll;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mq.size.width * 0.05, vertical: mq.size.height * 0.01),
        child: Column(
          children: [
            Text(
              widget.poll.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.poll.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.poll.eventDate.toString(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ]
        )
    );
  }
}
