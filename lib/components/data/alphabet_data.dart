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

var defaultAlphabetData1 = [
  AlphabetData(0, 'A', 'apple', 0),
  AlphabetData(1, 'B', 'bicycle', 0),
  AlphabetData(2, 'C', '', 0),
  AlphabetData(3, 'D', '', 0),
  AlphabetData(4, 'E', '', 0),
  AlphabetData(5, 'F', '', 0),
  AlphabetData(6, 'G', '', 0),
  AlphabetData(7, 'H', '', 0),
  AlphabetData(8, 'I', '', 0),
  AlphabetData(9, 'J', '', 0),
  AlphabetData(10, 'K', '', 0),
  AlphabetData(11, 'L', '', 0),
  AlphabetData(12, 'M', '', 0),
  AlphabetData(13, 'N', '', 0),
  AlphabetData(14, 'O', '', 0),
  AlphabetData(15, 'P', '', 0),
  AlphabetData(16, 'Q', '', 0),
  AlphabetData(17, 'R', '', 0),
  AlphabetData(18, 'S', '', 0),
  AlphabetData(19, 'T', '', 0),
  AlphabetData(20, 'U', '', 0),
  AlphabetData(21, 'V', '', 0),
  AlphabetData(22, 'W', '', 0),
  AlphabetData(23, 'X', '', 0),
  AlphabetData(24, 'Y', '', 0),
  AlphabetData(25, 'Z', '', 0),
];

var defaultAlphabetData3 = [
  AlphabetData(0, 'A', '', 100),
  AlphabetData(1, 'B', 'bicycle', 100),
  AlphabetData(2, 'C', 'cat', 100),
  AlphabetData(3, 'D', 'dinosaur', 100),
  AlphabetData(4, 'E', 'elephant', 100),
  AlphabetData(5, 'F', 'flamingo', 100),
  AlphabetData(6, 'G', 'godzilla', 100),
  AlphabetData(7, 'H', 'honey', 100),
  AlphabetData(8, 'I', 'igloo', 100),
  AlphabetData(9, 'J', 'jar', 100),
  AlphabetData(10, 'K', 'kangaroo', 100),
  AlphabetData(11, 'L', 'lava', 100),
  AlphabetData(12, 'M', 'mountain', 100),
  AlphabetData(13, 'N', 'ninja', 100),
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

var defaultAlphabetData2 = [
  AlphabetData(0, 'A', 'apple', 100),
  AlphabetData(1, 'B', 'bicycle', 100),
  AlphabetData(2, 'C', 'cat', 100),
  AlphabetData(3, 'D', 'dinosaur', 100),
  AlphabetData(4, 'E', 'elephant', 100),
  AlphabetData(5, 'F', 'flamingo', 100),
  AlphabetData(6, 'G', 'godzilla  ', 100),
  AlphabetData(7, 'H', 'honey', 100),
  AlphabetData(8, 'I', 'igloo', 100),
  AlphabetData(9, 'J', 'jar', 100),
  AlphabetData(10, 'K', 'kangaroo', 100),
  AlphabetData(11, 'L', 'lava', 100),
  AlphabetData(12, 'M', 'mountain', 100),
  AlphabetData(13, 'N', 'ninja', 100),
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