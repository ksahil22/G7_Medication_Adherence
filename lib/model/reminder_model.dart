class ReminderModel {
  String? medicineName;
  String? medicineType;
  int? pillCount;
  String? medicinePower;
  DateTime? dateTime;

  ReminderModel(
      {this.medicineName,
      this.medicineType,
      this.pillCount,
      this.medicinePower,
      this.dateTime});

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
}
