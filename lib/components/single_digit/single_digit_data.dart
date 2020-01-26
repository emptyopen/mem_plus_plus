class SingleDigitData {
  String digits;
  String object;
  int familiarity;

  SingleDigitData(this.digits, this.object, this.familiarity);

  Map<String, dynamic> toJson() => {
        'digits': digits,
        'object': object,
        'familiarity': familiarity,
      };

  factory SingleDigitData.fromJson(Map<String, dynamic> json) {
    return new SingleDigitData(
        json['digits'], json['object'], json['familiarity']);
  }
}

var defaultSingleDigitData = [
  SingleDigitData('0', 'ball', 0),
  SingleDigitData('1', 'stick', 0),
  SingleDigitData('2', 'bird', 0),
  SingleDigitData('3', 'bra', 0),
  SingleDigitData('4', 'sailboat', 0),
  SingleDigitData('5', 'snake', 0),
  SingleDigitData('6', 'golf club', 0),
  SingleDigitData('7', 'boomerang', 0),
  SingleDigitData('8', 'snowman', 0),
  SingleDigitData('9', 'balloon', 0),
];
