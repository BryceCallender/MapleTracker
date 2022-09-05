class Action {
  final String name;
  final int order;
  final bool done;
  final bool? isTemp;
  final DateTime? removalTime;

  Action({required this.name, required this.order, required this.done, this.isTemp, this.removalTime});
}