class ReminderModel implements Comparable<ReminderModel> {
  String? medicineName;
  String? medicineType;
  int? pillCount;
  String? medicinePower;
  DateTime dateTime;
  String? refID;

  ReminderModel(
      {this.medicineName,
      this.medicineType,
      this.pillCount,
      this.medicinePower,
      required this.dateTime,
      this.refID});

  Map<String, dynamic> toMap() {
    return {
      'medicineName': medicineName,
      'medicineType': medicineType,
      'pillCount': pillCount,
      'medicinePower': medicinePower,
      'dateTime': dateTime,
    };
  }

  factory ReminderModel.fromMap(map) {
    return ReminderModel(
      medicineName: map['medicineName'],
      medicineType: map['medicineType'],
      pillCount: map['pillCount'],
      medicinePower: map['medicinePower'],
      dateTime: map['dateTime'],
    );
  }

  @override
  int compareTo(ReminderModel dateTime) {
    if (this.dateTime.isBefore(dateTime.dateTime)) {
      return -1;
    } else if (this.dateTime.isAfter(dateTime.dateTime)) {
      return 1;
    }
    return 0;
  }
}
