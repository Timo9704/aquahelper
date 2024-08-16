class RunInDayTaskModel{
  int runInDay;
  String runInDayDescription;
  String runInDayDetailedDescription;

  RunInDayTaskModel(
      this.runInDay,
      this.runInDayDescription,
      this.runInDayDetailedDescription
  );

  getTaskById(int runInDay, List<RunInDayTaskModel> dayTasksData) {
    for (var task in dayTasksData) {
      if (task.runInDay == runInDay) {
        return task;
      }
    }
    return null;
  }
}
