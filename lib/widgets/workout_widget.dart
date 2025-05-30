import 'dart:async';

import 'package:flutter/material.dart';

class WorkoutWidget extends StatefulWidget {
  const WorkoutWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WorkoutWidgetState();
  }
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  bool workoutPaused = true;
  bool workoutStarted = false;
  Timer? timer;
  String displayWorkout = '00:00:00';
  String displayRest = '00:00:00';
  int? startWorkout;
  int? startRest;
  int timeBeforePauseWorkout = 0;
  int timeBeforePauseRest = 0;
  String stopwatchButtonText = 'Start';

  List<Map<String, dynamic>> tableData = [
    {'col1': 'A1', 'col2': 'B1', 'col3': 'C1', 'col4': 'D1'},
    {'col1': 'A2', 'col2': 'B2', 'col3': 'C2', 'col4': 'D2'},
    {'col1': 'A3', 'col2': 'B3', 'col3': 'C3', 'col4': 'D3'},
  ];

  @override
  void initState() {
    print('init WorkoutWidgetState');
    super.initState();

    // load workout

    timer = Timer.periodic(Duration(seconds: 1), (_) => updateDisplays());
  }

  void updateDisplays() {
    final now = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      if (workoutStarted && !workoutPaused) {
        if (startWorkout != null) {
          displayWorkout = formatElapsed(
            now - startWorkout! + timeBeforePauseWorkout,
          );
        }
        if (startRest != null) {
          displayRest = formatElapsed(now - startRest! + timeBeforePauseRest);
        }
      }
      if (workoutStarted && workoutPaused) {
        displayWorkout = formatElapsed(timeBeforePauseWorkout);
        displayRest = formatElapsed(timeBeforePauseRest);
      }
    });
  }

  String formatElapsed(int millis) {
    final seconds = millis ~/ 1000;
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (handleWorkoutButton),
              child: Text(stopwatchButtonText),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: EdgeInsets.all(29), child: Text(displayWorkout)),
            Padding(padding: EdgeInsets.all(29), child: Text(displayRest)),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              setState(() {
                final item = tableData.removeAt(oldIndex);
                tableData.insert(newIndex, item);
              });
            },
            children: List.generate(tableData.length, (index) {
              final row = tableData[index];
              return Card(
                key: ValueKey(row),
                margin: EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Row(
                    children: [
                      _tableCell(row['col1']),
                      _tableCell(row['col2']),
                      _tableCell(row['col3']),
                      _tableCell(row['col4']),
                      _tableButton("Edit"),
                      _tableButton("Delete"),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  void handleWorkoutButton() {
    // get current time
    final now = DateTime.now().millisecondsSinceEpoch;

    if (!workoutStarted) {
      // start workout for first time
      print('starting workout');

      // start workout timer
      startWorkout = now;
      // start rest timer
      startRest = now;
      // set text to pause
      stopwatchButtonText = 'Pause';
      workoutPaused = false;
      workoutStarted = true;
    } else {
      if (workoutPaused) {
        // resume workout
        print('resuming workout');
        // set new start time
        startWorkout = now;
        startRest = now;
        // set text to "Pause"
        stopwatchButtonText = 'Pause';
        workoutPaused = false;
      } else if (!workoutPaused) {
        // pause workout
        print('pausing workout');
        // record pause time
        timeBeforePauseWorkout = timeBeforePauseWorkout + now - startWorkout!;
        timeBeforePauseRest = timeBeforePauseRest + now - startRest!;
        // set text to resume
        stopwatchButtonText = 'Resume';
        workoutPaused = true;
      }
    }
    setState(() {});
  }

  Widget _tableCell(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(text),
      ),
    );
  }

  Widget _tableButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(onPressed: () {}, child: Text(label)),
    );
  }
}
