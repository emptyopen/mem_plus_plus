class PAOData {
  String digits;
  String person;
  String action;
  String object;
  int familiarity;

  PAOData(this.digits, this.person, this.action, this.object, this.familiarity);

  Map<String, dynamic> toJson() => {
    'digits': digits,
    'person': person,
    'action': action,
    'object': object,
    'familiarity': familiarity,
  };

  PAOData.fromJson(Map<String, dynamic> json)
      : digits = json['digits'],
        person = json['person'],
        action = json['action'],
        object = json['object'],
        familiarity = json['familiarity'];
}
