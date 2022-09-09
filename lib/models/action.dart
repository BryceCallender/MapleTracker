class Action {
  String name;
  int order;
  bool done;
  bool? isTemp;
  DateTime? removalTime;

  Action({required this.name, required this.order, required this.done, this.isTemp, this.removalTime});
}