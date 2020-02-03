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
  AlphabetData(0, 'A', 'apple', 100),
  AlphabetData(1, 'B', 'bicycle', 100),
  AlphabetData(2, 'C', 'chimp', 100),
  AlphabetData(3, 'D', 'dinosaur', 100),
  AlphabetData(4, 'E', 'elephant', 100),
  AlphabetData(5, 'F', 'flamingo', 100),
  AlphabetData(6, 'G', 'ghost', 100),
  AlphabetData(7, 'H', 'honey', 100),
  AlphabetData(8, 'I', 'igloo', 100),
  AlphabetData(9, 'J', 'jar', 100),
  AlphabetData(10, 'K', 'kangaroo', 100),
  AlphabetData(11, 'L', 'lava', 100),
  AlphabetData(12, 'M', 'mountain', 100),
  AlphabetData(13, 'N', 'nachos', 100),
  AlphabetData(14, 'O', 'ocarina', 100),
  AlphabetData(15, 'P', 'panda', 100),
  AlphabetData(16, 'Q', 'quicksand', 100),
  AlphabetData(17, 'R', 'root', 100),
  AlphabetData(18, 'S', 'skeleton', 100),
  AlphabetData(19, 'T', 'tattoo', 100),
  AlphabetData(20, 'U', 'umbrella', 100),
  AlphabetData(21, 'V', 'violin', 100),
  AlphabetData(22, 'W', 'wagon', 100),
  AlphabetData(23, 'X', 'xylophone', 100),
  AlphabetData(24, 'Y', 'yak', 100),
  AlphabetData(25, 'Z', 'zipper', 100),
];
