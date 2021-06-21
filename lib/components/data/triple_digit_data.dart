class TripleDigitData {
  int index;
  String digits;
  String person;
  String action;
  String object;
  int familiarity;

  TripleDigitData(this.index, this.digits, this.person, this.action,
      this.object, this.familiarity);

  Map<String, dynamic> toJson() => {
        'index': index,
        'digits': digits,
        'person': person,
        'action': action,
        'object': object,
        'familiarity': familiarity,
      };

  factory TripleDigitData.fromJson(Map<String, dynamic> json) {
    return new TripleDigitData(json['index'], json['digits'], json['person'],
        json['action'], json['object'], json['familiarity']);
  }
}
