class Action {
  final String? name;
  final int? order;
  final bool? done;
  final bool? isTemp;
  final DateTime? removalTime;

  Action({this.name, this.order, this.done, this.isTemp, this.removalTime});
}