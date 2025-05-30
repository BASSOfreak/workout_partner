import 'package:flutter/material.dart';
import 'package:workout_partner/widgets/workout_list_widget.dart';
import 'package:workout_partner/widgets/workout_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: "Workout List",
          ),
          NavigationDestination(
            icon: Icon(Icons.rocket_launch),
            label: "Workout",
          ),
        ],
      ),
      body: <Widget>[WorkoutListWidget(), WorkoutWidget()][currentPageIndex],
    );
  }
}
