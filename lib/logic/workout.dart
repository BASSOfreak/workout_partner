class Workout {
  String workoutId;
  Workout(this.workoutId);
  var exerciseList = List.empty(growable: true);
  void addExercise(Exercise ex) {
    exerciseList.add(ex);
  }

  Exercise getExerciseAtIndex(int index) {
    return exerciseList[index];
  }
}

class Exercise {
  String name;
  int sets;
  int reps;
  Exercise(this.name, this.sets, this.reps);
}
