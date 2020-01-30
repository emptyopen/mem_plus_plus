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
  PAOData('00', 'Ozzy Osbourne', 'rocking out a concert', 'rock guitar', 100),
  PAOData('01', 'Prairie Johnson', 'dancing metaphorically', 'halo', 100),
  PAOData(
      '02', 'Orlando Bloom', 'walking the plank', 'pirate sword, eyepatch', 100),
  PAOData('03', 'Thomas Nguyenfa', 'jetskiing', 'jetski, pharmacy drugs', 100),
  PAOData('04', 'Oscar De La Hoya', 'boxing', 'boxing gloves', 100),
  PAOData('05', 'Asami-san', 'writing/reading test report', 'FADEC', 100),
  PAOData('06', 'Steve Jobs', 'typing on laptop', 'macbook / iphone', 100),
  PAOData('07', 'Oscar the grouch', 'complaining', 'trashcan', 100),
  PAOData('08', 'Spiderman', 'shooting a web', 'giant spiderweb', 100),
  PAOData(
      '09', 'Oliver Twist', 'begging for more food', 'wooden bowl/spoon', 100),
  PAOData('10', 'Ariel', 'singing underwater', 'mermaid fin', 100),
  PAOData(
      '11', 'Osama bin Laden', 'flying plane into building', 'twin towers', 100),
  PAOData('12', 'Antonio Banderas', 'fencing as Zorro', 'Zorros mask', 100),
  PAOData('13', 'Augustus Caesar', 'conquering Europe', 'leaf crown', 100),
  PAOData('14', 'Jesus', 'water into wine', 'cross', 100),
  PAOData('15', 'Albert Einstein', 'writing on blackboard', 'e=mc^2', 100),
  PAOData('16', 'Arnold Schw.', 'lifting weights', 'choppa', 100),
  PAOData('17', 'Andre the Giant', 'throwing boulder', 'boulder', 100),
  PAOData('18', 'Adolph Hitler', 'committing genocide', 'gas chamber', 100),
  PAOData('19', 'Alice in Wonderland', 'having a teaparty', 'teacup', 100),
  PAOData('20', 'Barack Obama', 'signing a bill', 'oval office', 100),
  PAOData('21', 'Aki', 'barking', 'dog collar, leash', 100),
  PAOData('22', 'Bugs Bunny', 'chewing a carrot', 'carrot', 100),
  PAOData('23', 'Caveman', 'lighting a campfire', 'stone club', 100),
  PAOData('24', 'Jack Bauer', 'defusing a bomb', 'C4 bomb', 100),
  PAOData('25', 'George Washington', 'flipping a coin', 'quarter', 100),
  PAOData('26', 'Britney Spears', 'singing pop concert', 'blonde ponytail', 100),
  PAOData('27', 'Tyler1', 'CSing minions', 'spinning axes', 100),
  PAOData('28', 'Woody Harrelson', 'killing zombies', 'shotgun', 100),
  PAOData('29', 'Bill Nighy', 'playing ping pong', 'ping pong paddle', 100),
  PAOData('30', 'Conan Obrien', 'pointing and laughing', 'orange hair', 100),
  PAOData('31', 'Cristina', 'surfing', 'surfboard', 100),
  PAOData('32', 'Christian Bale / Batman', 'driving batmobile', 'batarang', 100),
  PAOData('33', 'Christopher Columbus', 'sailing a giant wooden ship',
      'giant wooden ship', 100),
  PAOData('34', 'Count Dracula', 'sucking blood', 'vampire fangs', 100),
  PAOData('35', 'Clint Eastwood', 'shooting a pistol', 'western pistol', 100),
  PAOData('36', 'Pope', 'praying / reading scriptures', 'Bible', 100),
  PAOData(
      '37', 'Curios George', 'eating banana / swinging on vine', 'banana', 100),
  PAOData('38', 'Thor', 'calling lightning', 'Thor\'s hammer', 100),
  PAOData('39', 'Chuck Norris', 'karate kicking', 'blackbelt / jean jacket', 100),
  PAOData('40', 'Tim', 'bouldering', 'bouldering shoes / chalk', 100),
  PAOData('41', 'Putin', 'riding a bear', 'vodka', 100),
  PAOData('42', 'David Beckham', 'kicking soccer ball', 'goal', 100),
  PAOData(
      '43', 'Dave Chappelle', 'hitting leg with microphone', 'microphone', 100),
  PAOData('44', 'Danny Devito', 'naked in a couch', 'couch', 100),
  PAOData('45', 'Duke Elington', 'playing trumpet', 'trumpet', 100),
  PAOData('46', 'Lorax', 'cutting down a tree', 'weird tree', 100),
  PAOData('47', 'Dexter Morgan', 'cutting up a body', 'bloody knives', 100),
  PAOData('48', 'Dwight Howard', 'dunking basketball', 'basketball', 100),
  PAOData('49', 'Mazy', 'on conference call', 'stool', 100),
  PAOData('50', 'Elsa', 'shooting ice out of hands', 'ice castle', 100),
  PAOData('51', 'Jmac', 'playing videogames', 'videogame controller', 100),
  PAOData('52', 'Shin Lim', 'shuffling deck of cards', 'deck of cards', 100),
  PAOData('53', 'Emilia Clarke', 'riding dragon', 'dragon egg', 100),
  PAOData('54', 'Ed Halley', '3d printing', '3d printer', 100),
  PAOData('55', 'Justin White', 'riding longboard', 'longboard', 100),
  PAOData('56', 'Ellie Fung', 'sex on air mattress', 'air mattress', 100),
  PAOData(
      '57', 'Ellie Goulding', 'singing with bright lights', 'bright lights', 100),
  PAOData('58', 'Easter bunny', 'hopping around', 'easter egg', 100),
  PAOData('59', 'Edward Norton', 'punching himself', 'doppleganger', 100),
  PAOData('60', 'Andrew', 'playing MTG', 'MTG cards, charmander', 100),
  PAOData('61', 'Steve Aoki', 'throwing cake into crowd', 'cake', 100),
  PAOData('62', 'Sandra Bullock', 'driving exploding bus', 'bus', 100),
  PAOData('63', 'Janice', 'passing out stuff on plane', 'food cart', 100),
  PAOData('64', 'Lori', 'sex in field', 'field of grass', 100),
  PAOData('65', 'Penn & Teller', 'shooting a nailgun', 'nailgun', 100),
  PAOData('66', 'Satan', 'torturing in hell', 'trident', 100),
  PAOData('67', 'Steven Lee', 'painting', 'paintbrush', 100),
  PAOData('68', 'Steven Hawking', 'in a wheelchair', 'voice box', 100),
  PAOData('69', 'Mina', 'posting on Instagram', 'makeup / hair', 100),
  PAOData('70', 'Gary Oldman', 'sending batsignal', 'thick glasses', 100),
  PAOData('71', 'Giorgio Armani', 'making fancy pants', 'fancy pants', 100),
  PAOData('72', 'Grandma', 'knitting', 'wool yarn', 100),
  PAOData('73', 'George Clooney', 'running a heist', 'poker chips', 100),
  PAOData('74', 'Gabby Douglas', 'gymnastics', 'trapeze, trampoline', 100),
  PAOData('75', 'Mom', 'teaching little kids', 'arts & crafts', 100),
  PAOData('76', 'Gordon Ramsey', 'cooking', 'wok', 100),
  PAOData('77', 'Galileo', 'looking at stars', 'stars, telescope', 100),
  PAOData('78', 'George Harrison', 'in a submarine', 'yellow submarine', 100),
  PAOData('79', 'Gandalf', 'charging down hill with army', 'wizard staff', 100),
  PAOData('80', 'Santa', 'going down chimney', 'big bag of presents', 100),
  PAOData('81', 'Hawkeye', 'shooting bow & arrow', 'bow & arrow', 100),
  PAOData('82', 'Mike Cabot', 'in a C-17 cockpit', 'avionics equipment', 100),
  PAOData('83', 'Hillary Clinton', 'wiping a server', 'email server', 100),
  PAOData('84', 'Harley Davidson', 'riding motorcycle', 'motorcycle', 100),
  PAOData('85', 'Hulk', 'smashing cars', 'green and huge', 100),
  PAOData('86', 'Han Solo', 'deflecting laser shots', 'light saber', 100),
  PAOData(
      '87', 'Hermione Granger', 'casting Wingardium Leviosa', 'magic wand', 100),
  PAOData('88', 'Harry Houdini', 'escaping water tank', 'straightjacket', 100),
  PAOData('89', 'Akira', 'tripping on acid in Tokyo', 'sticker shop', 100),
  PAOData(
      '90', 'Ron Swanson', 'making a canoe out of a log', 'wooden canoe', 100),
  PAOData('91', 'Neil Armstrong', 'landing on the moon', 'American flag', 100),
  PAOData('92', 'Nightblue', 'ganking from jungle', 'Nocturne', 100),
  PAOData('93', 'Nikki', 'skydiving', 'stacks of money', 100),
  PAOData('94', 'Napolean Dynamite', 'standing in the corner', 'braces', 100),
  PAOData('95', 'Tom Brady', 'throwing touchdown', 'football', 100),
  PAOData('96', 'Tiger Woods', 'hitting golfball, putting', 'golf course', 100),
  PAOData('97', 'Uncle Doug', 'fishing', 'fishing rod', 100),
  PAOData('98', 'Neil Patrick Harris', 'haaave you met ___?',
      'nice suit, apartment', 100),
  PAOData('99', 'Jake Peralta', 'arresting criminal', 'detective badge', 100),
];


String sampleGoogleCSVText =
  'Ozzy Osbourne,rocking a concert,rock guitar\n'
  'Original Angel (Prairie Johnson),stopping a mass shooting,coordinated dance\n'
  'Orlando Bloom,walking the plank,pirate sword\n'
  'Thomas Ngyuyenfa (originally from Orange County CA),working at a pharmacy,prescription drugs\n'
  'Oscar De La Hoya,boxing,boxing gloves\n'
  'Asami-san (O-e location),reading a test plan,FADEC\n'
  'Steve Jobs,typing,laptop\n'
  'Oscar the Grouch,being grouchy,trashcan\n'
  'Spiderman (8 leg spiders),shooting web out of his hands,big web\n'
  'Oliver Twist,saying please sir can i have some more,empty bowl\n'
  'Ariel,singing underwater,mermaid fin\n'
  'Osama Bin Laden (American Airlines flight 11),hitting the world trade center,exploding plane\n'
  'Antonio Banderas (zorro),fencing,fencing sword\n'
  'Augustus Caesar,expanding Roman empire,chariot?\n'
  'Jesus (AD after birth),getting nailed to a cross,cross\n'
  'Albert Einstein,writing on chalkboard,chalkboard\n'
  'Arnold Schwarzennegar ,lifting (barbell),barbell\n'
  'Andre the Giant,throwing a boulder,giant boulder rock\n'
  'Adolph Hitler,committing genocide,concentration camp\n'
  'Alice iN wonderland ,having a psycho tea party,tea cups\n'
  'Barack Obama,sitting in the oval office,red nuclear button\n'
  'Banksy,Spray painting graffiti ,Graffiti\n'
  'Bugs Bunny,chewing on a carrot what\'s up doc,carrot\n'
  'Caveman (B.C.),Starting a campfire,wooden club\n'
  'Jack Bauer,defusing a bomb,C4 bomb\n'
  'George Washington (on the quarter),founding a nation,quarter\n'
  'Britney Spears,bending over oops I did it again,ponytail?\n'
  'Tyler1 bad game,Csing minions,Draven\n'
  'Woody Harrelson (28 days later -> zombies -> zombieland),fanning self with money,shotgun\n'
  'Bill Nighy (about time),traveling in time,ping pong paddle\n'
  'Aki,Barking,Dog collar\n'
  'Cristina original California,Designing a website logo,Paintbrush graphic pad\n'
  'Christian Bale (Charlie Brown?),killing someone with an axe,axe\n'
  'Christopher Columbus,discovering America,wooden ship\n'
  'Count Dracula,sweeping his cape,fangs\n'
  'Clint Eastwood,shooting a gun,cowboy hat\n'
  'Mary Baker Eddy,writing a book,Science & Health\n'
  'Curious George,swinging on a vine,banana / vine?\n'
  'Chris Hemsworth,calling a hammer,thor hammer\n'
  'Chuck Norris,karate kick,jean jacket\n'
  'Tim ,climbing a wall,bouldering shoes\n'
  'Bert Kreischer (the machine russian = DA),drinking vodka,bottle of vodka\n'
  'David Beckham,playing soccer,soccer ball\n'
  'Dave Chapelle,hitting a microphone on the leg,microphone\n'
  'Danny Devito,climbing out of a couch naked,couch\n'
  'Duke Ellington ,playing trumpet,trumpet\n'
  'Dr Seuss,writing a kids book,kids book\n'
  'Dexter MorGan,cutting up a body on a table,bloody knife set\n'
  'Dwight Howard,dunking,basketball\n'
  'Mazy,on a conference call,work laptop / work phone / skype\n'
  'Elsa,shooting ice out of hands,ice castle\n'
  'Justin McDonald (EA -> videogames),jumping over a baseball pit,baseball pit\n'
  'Shin Lim (52 cards in a deck),make a deck of cards disappear,deck of cards\n'
  'Emilia Clarke (daenareyesys),breathing fire on a city,dragon\n'
  'Ellen Degeneres,receiving a medal,sofa chairs on a TV set\n'
  'Justin White (Electrical Engineering),longboarding at night,longboard\n'
  'Ellie Fung,having sex on an air mattress,air mattress\n'
  'Ellie Goulding,yelling lights lights lights,flashing lights\n'
  'Easter bunny,hopping around like a bunny,colorful eggs\n'
  'Edward Norton,punching himself ,hallucinated alter ego\n'
  'Andrew,coding an app,Android Studio?\n'
  'Steve Aoki,throwing a cake,cake\n'
  'Sandra Bullock,driving a bus about to explode,(exploding) bus\n'
  'Janice (63 int code for Phillipines),handing out drinks on a plane,flight attendant uniform\n'
  'Lori (San Diego),sex in field,field of tall grass\n'
  'Penn & Teller (now you SEe it now you don\'t),shooting a nailgun into hand,nailgun\n'
  'Satan (66 = 666),torturing with fire,Evil pitchfork\n'
  'Steven Lee,driving a Mercedes,Mercedes\n'
  'Stephen Hawking,defining new physics,wheelchair with voice converter\n'
  'Mina,posting a photo to instagram,instagram account\n'
  'Gary Oldman,talking with Batman,batman spotlight in sky\n'
  'Giorgio Armani,making pants for a suit,nice pants\n'
  'Grandma,knitting a blanket,wool yarn\n'
  'George Clooney,running a heist,lock pick\n'
  'Gabby Douglas,doing gymnastics,balance beam\n'
  'Mom / (Gatsby),teaching preschool kids,Arts and crafts\n'
  'Dad / (Magnus Carlsen),cooking,wok\n'
  'Galileo Galilei,looking in a telescope,telescope\n'
  'George Harrison (Beatles),singing in a submarine,yellow submarine\n'
  'Gandalf,riding down a hill with an army,wizard staff\n'
  'Santa (HO HO HO),flying in a sled with reindeer,chimney\n'
  'HAwkeye,shooting a bow and arrow quickly,bow and arrow\n'
  'Halle Berry,whipping as catwoman,whip\n'
  'Hillary Clinton,losing an election,email server\n'
  'Harley Davidson,riding a motorcycle,motorcycle\n'
  'Hulk,smashing a bus,green skin\n'
  'Han Solo,deflecting laser shots,lightsaber\n'
  'Hermione Granger,casting wingardium leviosa,magic wand\n'
  'Harry Houdini,escaping a water tank,water tank magic trick\n'
  'Akira,tripping in Tokyo,colorful stickers\n'
  'Nick Offerman,building a canoe,tree trunk\n'
  'Neil Armstrong,landing on the moon,astronaut suit\n'
  'Nightblue,ganking from the jungle,Nocturne\n'
  'Nikki Chen,skydiving,parachute\n'
  'Napolean Dynomite,standing awkwardly at a dance,braces\n'
  'Tom Brady (new england),throwing a touchdown,football\n'
  'Tiger Woods,swinging a golf club,golf ball\n'
  'Uncle Doug (fishing when I was 7 in 1997),fishing off a boat,fishing rod\n'
  'Neil Patrick Harris,saying haaaaave you met ted,fancy apartment\n'
  'Jake Peralta (brooklyn 99),flashing a cop badge,handcuffs\n';
