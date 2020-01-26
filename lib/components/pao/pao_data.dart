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

  factory PAOData.fromJson(Map<String, dynamic> json) {
    return new PAOData(json['digits'], json['person'], json['action'],
        json['object'], json['familiarity']);
  }
}

var defaultPAOData = [
  PAOData('00', 'Ozzy Osbourne', 'rocking out a concert', 'rock guitar', 0),
  PAOData('01', 'Prairie Johnson', 'dancing metaphorically', 'halo', 0),
  PAOData(
      '02', 'Orlando Bloom', 'walking the plank', 'pirate sword, eyepatch', 0),
  PAOData('03', 'Thomas Nguyenfa', 'jetskiing', 'jetski, pharmacy drugs', 0),
  PAOData('04', 'Oscar De La Hoya', 'boxing', 'boxing gloves', 0),
  PAOData('05', 'Asami-san', 'writing/reading test report', 'FADEC', 0),
  PAOData('06', 'Steve Jobs', 'typing on laptop', 'macbook / iphone', 0),
  PAOData('07', 'Oscar the grouch', 'complaining', 'trashcan', 0),
  PAOData('08', 'Spiderman', 'shooting a web', 'giant spiderweb', 0),
  PAOData(
      '09', 'Oliver Twist', 'begging for more food', 'wooden bowl/spoon', 0),
  PAOData('10', 'Ariel', 'singing underwater', 'mermaid fin', 0),
  PAOData(
      '11', 'Osama bin Laden', 'flying plane into building', 'twin towers', 0),
  PAOData('12', 'Antonio Banderas', 'fencing as Zorro', 'Zorros mask', 0),
  PAOData('13', 'Augustus Caesar', 'conquering Europe', 'leaf crown', 0),
  PAOData('14', 'Jesus', 'water into wine', 'cross', 0),
  PAOData('15', 'Albert Einstein', 'writing on blackboard', 'e=mc^2', 0),
  PAOData('16', 'Arnold Schw.', 'lifting weights', 'choppa', 0),
  PAOData('17', 'Andre the Giant', 'throwing boulder', 'boulder', 0),
  PAOData('18', 'Adolph Hitler', 'committing genocide', 'gas chamber', 0),
  PAOData('19', 'Alice in Wonderland', 'having a teaparty', 'teacup', 0),
  PAOData('20', 'Barack Obama', 'signing a bill', 'oval office', 0),
  PAOData('21', 'Aki', 'barking', 'dog collar, leash', 0),
  PAOData('22', 'Bugs Bunny', 'chewing a carrot', 'carrot', 0),
  PAOData('23', 'Caveman', 'lighting a campfire', 'stone club', 0),
  PAOData('24', 'Jack Bauer', 'defusing a bomb', 'C4 bomb', 0),
  PAOData('25', 'George Washington', 'flipping a coin', 'quarter', 0),
  PAOData('26', 'Britney Spears', 'singing pop concert', 'blonde ponytail', 0),
  PAOData('27', 'Tyler1', 'CSing minions', 'spinning axes', 0),
  PAOData('28', 'Woody Harrelson', 'killing zombies', 'shotgun', 0),
  PAOData('29', 'Bill Nighy', 'playing ping pong', 'ping pong paddle', 0),
  PAOData('30', 'Conan Obrien', 'pointing and laughing', 'orange hair', 0),
  PAOData('31', 'Cristina', 'surfing', 'surfboard', 0),
  PAOData('32', 'Christian Bale / Batman', 'driving batmobile', 'batarang', 0),
  PAOData('33', 'Christopher Columbus', 'sailing a giant wooden ship',
      'giant wooden ship', 0),
  PAOData('34', 'Count Dracula', 'sucking blood', 'vampire fangs', 0),
  PAOData('35', 'Clint Eastwood', 'shooting a pistol', 'western pistol', 0),
  PAOData('36', 'Pope', 'praying / reading scriptures', 'Bible', 0),
  PAOData(
      '37', 'Curios George', 'eating banana / swinging on vine', 'banana', 0),
  PAOData('38', 'Thor', 'calling lightning', 'Thor\'s hammer', 0),
  PAOData('39', 'Chuck Norris', 'karate kicking', 'blackbelt / jean jacket', 0),
  PAOData('40', 'Tim', 'bouldering', 'bouldering shoes / chalk', 0),
  PAOData('41', 'Putin', 'riding a bear', 'vodka', 0),
  PAOData('42', 'David Beckham', 'kicking soccer ball', 'goal', 0),
  PAOData(
      '43', 'Dave Chappelle', 'hitting leg with microphone', 'microphone', 0),
  PAOData('44', 'Danny Devito', 'naked in a couch', 'couch', 0),
  PAOData('45', 'Duke Elington', 'playing trumpet', 'trumpet', 0),
  PAOData('46', 'Lorax', 'cutting down a tree', 'weird tree', 0),
  PAOData('47', 'Dexter Morgan', 'cutting up a body', 'bloody knives', 0),
  PAOData('48', 'Dwight Howard', 'dunking basketball', 'basketball', 0),
  PAOData('49', 'Mazy', 'on conference call', 'stool', 0),
  PAOData('50', 'Elsa', 'shooting ice out of hands', 'ice castle', 0),
  PAOData('51', 'Jmac', 'playing videogames', 'videogame controller', 0),
  PAOData('52', 'Shin Lim', 'shuffling deck of cards', 'deck of cards', 0),
  PAOData('53', 'Emilia Clarke', 'riding dragon', 'dragon egg', 0),
  PAOData('54', 'Ed Halley', '3d printing', '3d printer', 0),
  PAOData('55', 'Justin White', 'riding longboard', 'longboard', 0),
  PAOData('56', 'Ellie Fung', 'sex on air mattress', 'air mattress', 0),
  PAOData(
      '57', 'Ellie Goulding', 'singing with bright lights', 'bright lights', 0),
  PAOData('58', 'Easter bunny', 'hopping around', 'easter egg', 0),
  PAOData('59', 'Edward Norton', 'punching himself', 'doppleganger', 0),
  PAOData('60', 'Andrew', 'playing MTG', 'MTG cards, charmander', 0),
  PAOData('61', 'Steve Aoki', 'throwing cake into crowd', 'cake', 0),
  PAOData('62', 'Sandra Bullock', 'driving exploding bus', 'bus', 0),
  PAOData('63', 'Janice', 'passing out stuff on plane', 'food cart', 0),
  PAOData('64', 'Lori', 'sex in field', 'field of grass', 0),
  PAOData('65', 'Penn & Teller', 'shooting a nailgun', 'nailgun', 0),
  PAOData('66', 'Satan', 'torturing in hell', 'trident', 0),
  PAOData('67', 'Steven Lee', 'painting', 'paintbrush', 0),
  PAOData('68', 'Steven Hawking', 'in a wheelchair', 'voice box', 0),
  PAOData('69', 'Mina', 'posting on Instagram', 'makeup / hair', 0),
  PAOData('70', 'Gary Oldman', 'sending batsignal', 'thick glasses', 0),
  PAOData('71', 'Giorgio Armani', 'making fancy pants', 'fancy pants', 0),
  PAOData('72', 'Grandma', 'knitting', 'wool yarn', 0),
  PAOData('73', 'George Clooney', 'running a heist', 'poker chips', 0),
  PAOData('74', 'Gabby Douglas', 'gymnastics', 'trapeze, trampoline', 0),
  PAOData('75', 'Mom', 'teaching little kids', 'arts & crafts', 0),
  PAOData('76', 'Gordon Ramsey', 'cooking', 'wok', 0),
  PAOData('77', 'Galileo', 'looking at stars', 'stars, telescope', 0),
  PAOData('78', 'George Harrison', 'in a submarine', 'yellow submarine', 0),
  PAOData('79', 'Gandalf', 'charging down hill with army', 'wizard staff', 0),
  PAOData('80', 'Santa', 'going down chimney', 'big bag of presents', 0),
  PAOData('81', 'Hawkeye', 'shooting bow & arrow', 'bow & arrow', 0),
  PAOData('82', 'Mike Cabot', 'in a C-17 cockpit', 'avionics equipment', 0),
  PAOData('83', 'Hillary Clinton', 'wiping a server', 'email server', 0),
  PAOData('84', 'Harley Davidson', 'riding motorcycle', 'motorcycle', 0),
  PAOData('85', 'Hulk', 'smashing cars', 'green and huge', 0),
  PAOData('86', 'Han Solo', 'deflecting laser shots', 'light saber', 0),
  PAOData(
      '87', 'Hermione Granger', 'casting Wingardium Leviosa', 'magic wand', 0),
  PAOData('88', 'Harry Houdini', 'escaping water tank', 'straightjacket', 0),
  PAOData('89', 'Akira', 'tripping on acid in Tokyo', 'sticker shop', 0),
  PAOData(
      '90', 'Ron Swanson', 'making a canoe out of a log', 'wooden canoe', 0),
  PAOData('91', 'Neil Armstrong', 'landing on the moon', 'American flag', 0),
  PAOData('92', 'Nightblue', 'ganking from jungle', 'Nocturne', 0),
  PAOData('93', 'Nikki', 'skydiving', 'stacks of money', 0),
  PAOData('94', 'Napolean Dynamite', 'standing in the corner', 'braces', 0),
  PAOData('95', 'Tom Brady', 'throwing touchdown', 'football', 0),
  PAOData('96', 'Tiger Woods', 'hitting golfball, putting', 'golf course', 0),
  PAOData('97', 'Uncle Doug', 'fishing', 'fishing rod', 0),
  PAOData('98', 'Neil Patrick Harris', 'haaave you met ___?',
      'nice suit, apartment', 0),
  PAOData('99', 'Jake Peralta', 'arresting criminal', 'detective badge', 0),
];
