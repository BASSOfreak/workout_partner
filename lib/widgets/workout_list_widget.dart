import 'package:flutter/material.dart';

class WorkoutListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorkoutListWidgetState();
  }
}

class _WorkoutListWidgetState extends State<WorkoutListWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Workout List"));
  }
}
