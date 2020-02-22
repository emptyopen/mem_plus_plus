import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeckData {
  int index;
  String digitSuit;
  String person;
  String action;
  String object;
  int familiarity;

  DeckData(this.index, this.digitSuit, this.person, this.action, this.object,
      this.familiarity);

  Map<String, dynamic> toJson() => {
        'index': index,
        'digitSuit': digitSuit,
        'person': person,
        'action': action,
        'object': object,
        'familiarity': familiarity,
      };

  factory DeckData.fromJson(Map<String, dynamic> json) {
    return new DeckData(json['index'], json['digitSuit'], json['person'],
        json['action'], json['object'], json['familiarity']);
  }
}

Widget getDeckCard(String digitSuit, String size) {
  String digit = digitSuit.substring(0, digitSuit.length - 1);
  String suit = digitSuit.substring(digitSuit.length - 1, digitSuit.length);
  double fontSize = 20;
  double cardHeight = 50;
  double cardWidth = 40;
  double left = 6;
  double top = 2;
  double right = 2;
  double bottom = 4;
  if (size == 'medium') {
    fontSize = 30;
    cardHeight = 75;
    cardWidth = 60;
    left = 8;
    top = 3;
    right = 16;
    bottom = 6;
  }
  if (size == 'big') {
    fontSize = 80;
    cardHeight = 200;
    cardWidth = 160;
    left = 24;
    top = 8;
    right = 8;
    bottom = 16;
  }
  var suitSymbol = Icon(
    MdiIcons.cardsDiamond,
    size: fontSize,
    color: Colors.red,
  );
  switch (suit) {
    case 'S':
      suitSymbol =
          Icon(MdiIcons.cardsSpade, size: fontSize, color: Colors.black);
      break;
    case 'H':
      suitSymbol = Icon(MdiIcons.cardsHeart, size: fontSize, color: Colors.red);
      break;
    case 'C':
      suitSymbol =
          Icon(MdiIcons.cardsClub, size: fontSize, color: Colors.black);
      break;
    default:
      suitSymbol =
          Icon(MdiIcons.cardsDiamond, size: fontSize, color: Colors.red);
  }
  return Container(
          height: cardHeight,
          width: cardWidth,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black)),
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Text(
                  digit,
                  style: TextStyle(fontSize: fontSize, color: Colors.black),
                ),
                left: left,
                top: top,
              ),
              Positioned(
                child: suitSymbol,
                right: right,
                bottom: bottom,
              ),
            ],
          ));
}

var defaultDeckData1 = [
  DeckData(0, 'AS', 'Ariel', 'singing underwater', 'mermaid fin', 100),
  DeckData(1, '2S', '', '', '', 100),
  DeckData(2, '3S', '', '', '', 100),
  DeckData(3, '4S', '', '', '', 100),
  DeckData(4, '5S', '', '', '', 100),
  DeckData(5, '6S', '', '', '', 100),
  DeckData(6, '7S', '', '', '', 100),
  DeckData(7, '8S', '', '', '', 100),
  DeckData(8, '9S', '', '', '', 100),
  DeckData(9, '10S', '', '', '', 100),
  DeckData(10, 'JS', '', '', '', 100),
  DeckData(11, 'QS', '', '', '', 100),
  DeckData(12, 'KS', '', '', '', 100),
  DeckData(13, 'AH', '', '', '', 100),
  DeckData(14, '2H', '', '', '', 100),
  DeckData(15, '3H', '', '', '', 100),
  DeckData(16, '4H', '', '', '', 100),
  DeckData(17, '5H', '', '', '', 100),
  DeckData(18, '6H', '', '', '', 100),
  DeckData(19, '7H', '', '', '', 100),
  DeckData(20, '8H', '', '', '', 100),
  DeckData(21, '9H', '', '', '', 100),
  DeckData(22, '10H', '', '', '', 100),
  DeckData(23, 'JH', '', '', '', 100),
  DeckData(24, 'QH', '', '', '', 100),
  DeckData(25, 'KH', '', '', '', 100),
  DeckData(26, 'AC', '', '', '', 100),
  DeckData(27, '2C', '', '', '', 100),
  DeckData(28, '3C', '', '', '', 100),
  DeckData(29, '4C', '', '', '', 100),
  DeckData(30, '5C', '', '', '', 100),
  DeckData(31, '6C', '', '', '', 100),
  DeckData(32, '7C', '', '', '', 100),
  DeckData(33, '8C', '', '', '', 100),
  DeckData(34, '9C', '', '', '', 100),
  DeckData(35, '10C', '', '', '', 100),
  DeckData(36, 'JC', '', '', '', 100),
  DeckData(37, 'QC', '', '', '', 100),
  DeckData(38, 'KC', '', '', '', 100),
  DeckData(39, 'AD', '', '', '', 100),
  DeckData(40, '2D', '', '', '', 100),
  DeckData(41, '3D', '', '', '', 100),
  DeckData(42, '4D', '', '', '', 100),
  DeckData(43, '5D', '', '', '', 100),
  DeckData(44, '6D', '', '', '', 100),
  DeckData(45, '7D', '', '', '', 100),
  DeckData(46, '8D', '', '', '', 100),
  DeckData(47, '9D', '', '', '', 100),
  DeckData(48, '10D', '', '', '', 100),
  DeckData(49, 'JD', '', '', '', 100),
  DeckData(50, 'QD', '', '', '', 100),
  DeckData(51, 'KD', '', '', '', 100),
];

var defaultDeckData2 = [
  DeckData(0, 'AS', 'Ariel', 'singing underwater', '', 100),
  DeckData(1, '2S', 'Bugs Bunny', 'chewing carrot', 'carrot', 100),
  DeckData(2, '3S', 'Curious George', 'swinging on vine', 'banana', 100),
  DeckData(3, '4S', 'Dexter Morgan', 'cutting body', 'bloody knives', 100),
  DeckData(4, '5S', 'Elsa', 'shooting ice out of hands', 'ice castle', 100),
  DeckData(5, '6S', 'Satan', 'torturing people', 'trident', 100),
  DeckData(6, '7S', 'Gandalf', 'charging down hill / shall not pass',
      'wizard staff', 100),
  DeckData(7, '8S', 'Hulk', 'smashing car', 'green and ripped', 100),
  DeckData(8, '9S', 'Ron Swanson', 'carving canoe', 'wooden canoe', 100),
  DeckData(9, '10S', 'Oliver Twist', 'begging', 'wooden bowl/spoon', 100),
  DeckData(10, 'JS', 'Jack Sparrow', 'stealing ship', 'eyepatch', 100),
  DeckData(
      11, 'QS', 'Hermione', 'casting wingardium leviosa', 'magic wand', 100),
  DeckData(
      12, 'KS', 'Superman', 'shooting lasers out of eyes', 'hero cape', 100),
  DeckData(13, 'AH', 'Aki', 'barking', 'leash/collar', 100),
  DeckData(14, '2H', 'Tiffany', 'mixing cocktail', 'cocktail', 100),
  DeckData(15, '3H', 'Thomas', 'jetskiing', 'jetski', 100),
  DeckData(16, '4H', 'Tim', 'climbing wall', 'bouldering shoes', 100),
  DeckData(17, '5H', 'Jmac', 'playing videogames', 'videogame controller', 100),
  DeckData(18, '6H', 'Andrew', 'playing MTG', 'MTG card / charmander', 100),
  DeckData(19, '7H', 'Steven', 'painting', 'paint brush', 100),
  DeckData(20, '8H', 'Mina', 'posting to Instagram', 'makeup', 100),
  DeckData(21, '9H', 'Nikki', 'sky diving', 'stacks of money', 100),
  DeckData(
      22, '10H', 'Mazy', 'on conference call', 'cookies / work laptop', 100),
  DeckData(23, 'JH', 'Akira', 'tripping on acid', 'sticker shop', 100),
  DeckData(24, 'QH', 'Mom', 'teaching kids', 'arts & crafts', 100),
  DeckData(25, 'KH', 'Dad', 'doing CPR', 'stethoscope', 100),
  DeckData(26, 'AC', 'Aisha', 'doing ballet', 'tutu / ballet shoes', 100),
  DeckData(27, '2C', 'David Beckham', 'kicking', 'soccer ball', 100),
  DeckData(28, '3C', 'Chuck Norris', 'doing karate', 'black belt / jean jacket',
      100),
  DeckData(29, '4C', 'Dwight Howard', 'dunking', 'basketball', 100),
  DeckData(30, '5C', 'Gordon Ramsey', 'cooking', 'wok', 100),
  DeckData(31, '6C', 'Penn & Teller', 'doing magic trick', 'nail gun', 100),
  DeckData(32, '7C', 'Gabby Douglas', 'doing gymnastics', 'trampoline', 100),
  DeckData(33, '8C', 'Harley Davidson', 'riding motorcycle', 'motorcycle', 100),
  DeckData(34, '9C', 'Ichiro', 'swinging a bat', 'baseball', 100),
  DeckData(35, '10C', 'Oscar de la Hoya', 'boxing', 'boxing gloves', 100),
  DeckData(36, 'JC', 'Magnus Carlsen', 'playing chess', 'chess piece', 100),
  DeckData(37, 'QC', 'Danica Patrick', 'driving car', 'racing car', 100),
  DeckData(38, 'KC', 'Tiger Woods', 'playing golf', 'golf club', 100),
  DeckData(39, 'AD', 'Andrew the Giant', 'throwing boulder', 'boulder', 100),
  DeckData(40, '2D', 'Barack Obama', 'signing a bill', 'Oval Office', 100),
  DeckData(41, '3D', 'Thor', 'calling lightning', 'Thor\'s hammer', 100),
  DeckData(
      42, '4D', 'Danny Devito', 'climbing out of couch naked', 'couch', 100),
  DeckData(43, '5D', 'Edward Norton', 'punching himself', 'doppleganger', 100),
  DeckData(44, '6D', 'Sandra Bullock', 'driving exploding bus', 'exploding bus',
      100),
  DeckData(45, '7D', 'Galileo', 'staring at stars', 'stars / telescope', 100),
  DeckData(46, '8D', 'Houdini', 'escaping water tank', 'straightjacket', 100),
  DeckData(47, '9D', 'Caesar', 'conquering Europe', 'chariot', 100),
  DeckData(48, '10D', 'Ozzy Osbourne', 'rocking concert', 'rock guitar', 100),
  DeckData(49, 'JD', 'Jeff Bezos', 'reading a book', 'stack of books', 100),
  DeckData(
      50, 'QD', 'Cleopatra', 'getting fanned with leaves', 'pyramids', 100),
  DeckData(51, 'KD', 'Elon Musk', 'on a rocket to Mars', 'space rocket', 100),
];

String sampleGoogleCSVText = 'Ozzy Osbourne,rocking a concert,rock guitar\n'
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
