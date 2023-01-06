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

  Action.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        order = json['order'],
        done = json['done'],
        isTemp = json['isTemp'],
        removalTime = json['removalTime'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'order': order,
    'done': done,
    'isTemp': isTemp,
    'removalTime': removalTime
  };
}