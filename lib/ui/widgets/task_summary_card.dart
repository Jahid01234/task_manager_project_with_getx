import 'package:flutter/material.dart';

class TaskSummaryCard extends StatelessWidget {
  final String title;
  final String count;

  const TaskSummaryCard({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(count,style: Theme.of(context).textTheme.titleLarge,),
            Text(title,style: Theme.of(context).textTheme.titleSmall,),
          ],
        ),
      ),
    );
  }
}