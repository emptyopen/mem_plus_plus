class SingleDigitData {
  int index;
  String digits;
  String object;
  int familiarity;

  SingleDigitData(this. index, this.digits, this.object, this.familiarity);

  Map<String, dynamic> toJson() => {
        'index': index,
        'digits': digits,
        'object': object,
        'familiarity': familiarity,
      };

  factory SingleDigitData.fromJson(Map<String, dynamic> json) {
    return new SingleDigitData(
        json['index'], json['digits'], json['object'], json['familiarity']);
  }
}

var defaultSingleDigitData = [
  SingleDigitData(0, '0', 'ball', 100),
  SingleDigitData(1, '1', 'stick', 100),
  SingleDigitData(2, '2', 'bird', 100),
  SingleDigitData(3, '3', 'bra', 100),
  SingleDigitData(4, '4', 'sailboat', 100),
  SingleDigitData(5, '5', 'snake', 100),
  SingleDigitData(6, '6', 'golf club', 100),
  SingleDigitData(7, '7', 'boomerang', 100),
  SingleDigitData(8, '8', 'snowman', 100),
  SingleDigitData(9, '9', 'balloon', 100),
];
