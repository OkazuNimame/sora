class RestTime {
  final int id;
  final int subjectId; // 教科IDに関連付け
  final int minutes; // 休んだ時間（分）

  RestTime({required this.id, required this.subjectId, required this.minutes});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject_id': subjectId,
      'minutes': minutes,
    };
  }

  static RestTime fromMap(Map<String, dynamic> map) {
    return RestTime(
      id: map['id'],
      subjectId: map['subject_id'],
      minutes: map['minutes'],
    );
  }
}
