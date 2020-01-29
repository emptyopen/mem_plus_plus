class AlphabetData {
  String digits;
  String object;
  int familiarity;

  AlphabetData(this.digits, this.object, this.familiarity);

  Map<String, dynamic> toJson() => {
        'digits': digits,
        'object': object,
        'familiarity': familiarity,
      };

  factory AlphabetData.fromJson(Map<String, dynamic> json) {
    return new AlphabetData(
        json['digits'], json['object'], json['familiarity']);
  }
}

var defaultAlphabetData = [
  AlphabetData('0', 'ball', 0),
  AlphabetData('1', 'stick', 0),
  AlphabetData('2', 'bird', 0),
  AlphabetData('3', 'bra', 0),
  AlphabetData('4', 'sailboat', 0),
  AlphabetData('5', 'snake', 0),
  AlphabetData('6', 'golf club', 0),
  AlphabetData('7', 'boomerang', 0),
  AlphabetData('8', 'snowman', 0),
  AlphabetData('9', 'balloon', 0),
];
