class Action {
  String name;
  int? order;
  bool done;
  bool? isTemp;
  DateTime? removalTime;

  Action({required this.name,  required this.done, this.order, this.isTemp, this.removalTime});

  Action copy({String? name, int? order, bool? done, bool? isTemp, DateTime? removalTime}) {
    return Action(
      name: name ?? this.name,
      order: order ?? this.order,
      done: done ?? this.done,
      isTemp: isTemp ?? this.isTemp,
      removalTime: removalTime ?? this.removalTime
    );
  }
}