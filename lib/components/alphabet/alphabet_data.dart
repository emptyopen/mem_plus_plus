class AlphabetData {
  int index;
  String letter;
  String object;
  int familiarity;

  AlphabetData(this.index, this.letter, this.object, this.familiarity);

  Map<String, dynamic> toJson() => {
        'index': index,
        'letter': letter,
        'object': object,
        'familiarity': familiarity,
      };

  factory AlphabetData.fromJson(Map<String, dynamic> json) {
    return new AlphabetData(
        json['index'], json['letter'], json['object'], json['familiarity']);
  }
}

var defaultAlphabetData = [
  AlphabetData(0, 'A', 'apple', 0),
  AlphabetData(1, 'B', 'bicycle', 0),
  AlphabetData(2, 'C', 'chimp', 0),
  AlphabetData(3, 'D', 'dinosaur', 0),
  AlphabetData(4, 'E', 'elephant', 0),
  AlphabetData(5, 'F', 'fly', 0),
  AlphabetData(6, 'G', 'ghost', 0),
  AlphabetData(7, 'H', 'honey', 0),
  AlphabetData(8, 'I', 'igloo', 0),
  AlphabetData(9, 'J', 'jar', 0),
  AlphabetData(10, 'K', 'kangaroo', 0),
  AlphabetData(11, 'L', 'lava', 0),
  AlphabetData(12, 'M', 'mountain', 0),
  AlphabetData(13, 'N', 'nachos', 0),
  AlphabetData(14, 'O', 'ocarina', 0),
  AlphabetData(15, 'P', 'panda', 0),
  AlphabetData(16, 'Q', 'quicksand', 0),
  AlphabetData(17, 'R', 'root', 0),
  AlphabetData(18, 'S', 'skeleton', 0),
  AlphabetData(19, 'T', 'tattoo', 0),
  AlphabetData(20, 'U', 'umbrella', 0),
  AlphabetData(21, 'V', 'violin', 0),
  AlphabetData(22, 'W', 'wagon', 0),
  AlphabetData(23, 'X', 'xylophone', 0),
  AlphabetData(24, 'Y', 'yak', 0),
  AlphabetData(25, 'Z', 'zipper', 0),
];
