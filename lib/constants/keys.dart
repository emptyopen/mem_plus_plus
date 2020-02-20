import 'package:flutter/material.dart';

// debug mode - FALSE for production
const bool debugModeEnabled = false;

const String usernameKey = 'Username';

// dark mode colors
Color backgroundColor = Colors.white;
Color backgroundSemiColor = Colors.grey[200];
Color backgroundHighlightColor = Colors.black;
Color backgroundSemiHighlightColor = Colors.grey[800];
const String darkModeKey = 'DarkMode';

// general
const String welcomeKey = 'Welcome';
const String homepageKey = 'Homepage';
const String firstTimeAppKey = 'FirstTimeApp';
const String activityStatesKey = 'ActivityStates';
const String customMemoriesKey = 'CustomMemories';

// notifications
const String dailyReminderKey = 'Daily Reminder';
const String dailyReminderIdKey = '1';
const String testReminderKey = 'Test Reminder';
const String testReminderIdKey = '2';

// faces
const String faceTimedTestPrepKey = 'FaceTimedTestPrep';
const String faceTimedTestKey = 'FaceTimedTest';
const String faceTestActiveKey = 'FaceTestActive';
const String faceTimedTestCompleteKey = 'FaceTimedTestComplete';

// Single Digit
const String singleDigitKey = 'SingleDigit';
const String singleDigitEditKey = 'SingleDigitEdit';
const String singleDigitPracticeKey = 'SingleDigitPractice';
const String singleDigitMultipleChoiceTestKey = 'SingleDigitMultipleChoice';
const String singleDigitTimedTestPrepKey = 'SingleDigitTimedTestPrep';
const String singleDigitTimedTestKey = 'SingleDigitTimedTest';
const String singleDigitEditCompleteKey = 'SingleDigitEditComplete';
const String singleDigitMultipleChoiceTestCompleteKey =
    'SingleDigitMultipleChoiceTestComplete';
const String singleDigitTestActiveKey = 'SingleDigitTimedTestActive';
const String singleDigitTimedTestCompleteKey = 'SingleDigitTimedTestComplete';

// Alphabet
const String alphabetKey = 'Alphabet';
const String alphabetEditKey = 'AlphabetEdit';
const String alphabetPracticeKey = 'AlphabetPractice';
const String alphabetWrittenTestKey = 'AlphabetWrittenTest';
const String alphabetTimedTestPrepKey = 'AlphabetTimedTestPrep';
const String alphabetTimedTestKey = 'AlphabetTimedTest';
const String alphabetEditCompleteKey = 'AlphabetEditComplete';
const String alphabetWrittenTestCompleteKey = 'AlphabetWrittenTestComplete';
const String alphabetTestActiveKey = 'AlphabetTestActive';
const String alphabetTimedTestCompleteKey = 'AlphabetTimedTestComplete';

// PAO
const String paoKey = 'PAO';
const String paoEditKey = 'PAOEdit';
const String paoPracticeKey = 'PAOPractice';
const String paoMultipleChoiceTestKey = 'PAOMultipleChoice';
const String paoTimedTestPrepKey = 'PAOTimedTestPrep';
const String paoTimedTestKey = 'PAOTimedTest';
const String paoEditCompleteKey = 'PAOEditComplete';
const String paoMultipleChoiceTestCompleteKey = 'PAOMultipleChoiceTestComplete';
const String paoTestActiveKey = 'PAOTestActive';

// custom memory
const String customMemoryManagerAvailableKey = 'CustomMemoryManagerAvailable';
const String shortTerm = 'short term (1d ~ 1w)';
const String mediumTerm = 'medium term (1w ~ 3m)';
const String longTerm = 'long term (3m ~ 1y)';
const String extraLongTerm = 'extra long term (1y ~ life)';
const String contactString = 'Contact';
const String idCardString = 'ID/Credit Card';
const String otherString = 'Other';

// first help
const String homepageFirstHelpKey = 'HomepageFirstHelp';
const String customMemoryManagerFirstHelpKey = 'CustomMemoryManagerFirstHelp';
const String customMemoryTestFirstHelpKey = 'CustomMemoryTestFirstHelp';
const String singleDigitEditFirstHelpKey = 'SingleDigitEditFirstHelp';
const String singleDigitPracticeFirstHelpKey = 'SingleDigitPracticeFirstHelp';
const String singleDigitMultipleChoiceTestFirstHelpKey =
    'SingleDigitMultipleChoiceTestFirstHelp';
const String singleDigitTimedTestPrepFirstHelpKey =
    'SingleDigitTimedTestPrepFirstHelp';
const String singleDigitTimedTestFirstHelpKey = 'SingleDigitTimedTestFirstHelp';
const String alphabetEditFirstHelpKey = 'AlphabetEditFirstHelp';
const String alphabetPracticeFirstHelpKey = 'AlphabetPracticeFirstHelp';
const String alphabetWrittenTestFirstHelpKey =
    'AlphabetMultipleChoiceTestFirstHelp';
const String alphabetTimedTestPrepFirstHelpKey =
    'AlphabetTimedTestPrepFirstHelp';
const String alphabetTimedTestFirstHelpKey = 'AlphabetTimedTestFirstHelp';
const String paoEditFirstHelpKey = 'PAOEditFirstHelp';
const String paoPracticeFirstHelpKey = 'PAOPracticeFirstHelp';
const String paoMultipleChoiceTestFirstHelpKey =
    'PAOMultipleChoiceTestFirstHelp';
const String paoTimedTestPrepFirstHelpKey = 'PAOTimedTestPrepFirstHelp';
const String paoTimedTestFirstHelpKey = 'PAOTimedTestFirstHelp';
const String faceTimedTestPrepFirstHelpKey = 'FaceTimedTestPrepFirstHelp';
const String faceTimedTestFirstHelpKey = 'FaceTimedTestFirstHelp';

List<String> menNames = [
  'Liam',
  'Noah',
  'William',
  'James',
  'Oliver',
  'Benjamin',
  'Elijah',
  'Lucas',
  'Mason',
  'Logan',
  'Alexander',
  'Ethan',
  'Jacob',
  'Michael',
  'Daniel',
  'Henry',
  'Jackson',
  'Sebastian',
  'Aiden',
  'Matthew',
  'Samuel',
  'David',
  'Joseph',
  'Carter',
  'Owen',
  'Wyatt',
  'John',
  'Jack',
  'Luke',
  'Jayden',
  'Dylan',
  'Grayson',
  'Levi',
  'Isaac',
  'Gabriel',
  'Julian',
  'Mateo',
  'Anthony',
  'Jaxon',
  'Lincoln',
  'Joshua',
  'Christopher',
  'Andrew',
  'Theodore',
  'Caleb',
  'Ryan',
  'Asher',
  'Nathan',
  'Thomas',
  'Leo',
  'Isaiah',
  'Charles',
  'Josiah',
  'Hudson',
  'Christian',
  'Hunter',
  'Connor',
  'Eli',
  'Ezra',
  'Aaron',
  'Landon',
  'Adrian',
  'Jonathan',
  'Nolan',
  'Jeremiah',
  'Easton',
  'Elias',
  'Colton',
  'Cameron',
  'Carson',
  'Robert',
  'Angel',
  'Maverick',
  'Nicholas',
  'Dominic',
  'Jaxson',
  'Greyson',
  'Adam',
  'Ian',
  'Austin',
  'Santiago',
  'Jordan',
  'Cooper',
  'Brayden',
  'Roman',
  'Evan',
  'Ezekiel',
  'Xavier',
  'Jose',
  'Jace',
  'Jameson',
  'Leonardo',
  'Bryson',
  'Axel',
  'Everett',
  'Parker',
  'Kayden',
  'Miles',
  'Sawyer',
  'Jason',
  'Declan',
  'Weston',
  'Micah',
  'Ayden',
  'Wesley',
  'Luca',
  'Vincent',
  'Damian',
  'Zachary',
  'Silas',
  'Gavin',
  'Chase',
  'Kai',
  'Emmett',
  'Harrison',
  'Nathaniel',
  'Kingston',
  'Cole',
  'Tyler',
  'Bennett',
  'Bentley',
  'Ryker',
  'Tristan',
  'Brandon',
  'Kevin',
  'Luis',
  'George',
  'Ashton',
  'Rowan',
  'Braxton',
  'Ryder',
  'Gael',
  'Ivan',
  'Diego',
  'Maxwell',
  'Max',
  'Carlos',
  'Kaiden',
  'Juan',
  'Maddox',
  'Justin',
  'Waylon',
  'Calvin',
  'Giovanni',
  'Jonah',
  'Abel',
  'Jayce',
  'Jesus',
  'Amir',
  'King',
  'Beau',
  'Camden',
  'Alex',
  'Jasper',
  'Malachi',
  'Brody',
  'Jude',
  'Blake',
  'Emmanuel',
  'Eric',
  'Brooks',
  'Elliot',
  'Antonio',
  'Abraham',
  'Timothy',
  'Finn',
  'Rhett',
  'Elliott',
  'Edward',
  'August',
  'Xander',
  'Alan',
  'Dean',
  'Lorenzo',
  'Bryce',
  'Karter',
  'Victor',
  'Milo',
  'Miguel',
  'Hayden',
  'Graham',
  'Grant',
  'Zion',
  'Tucker',
  'Jesse',
  'Zayden',
  'Joel',
  'Richard',
  'Patrick',
  'Emiliano',
  'Avery',
  'Nicolas',
  'Brantley',
  'Dawson',
  'Myles',
  'Matteo',
  'River',
  'Steven',
  'Thiago',
  'Zane',
  'Matias',
  'Judah',
  'Messiah',
  'Jeremy',
  'Preston',
  'Oscar',
  'Kaleb',
  'Alejandro',
  'Marcus',
  'Mark',
  'Peter',
  'Maximus',
  'Barrett',
  'Jax',
  'Andres',
  'Holden',
  'Legend',
  'Charlie',
  'Knox',
  'Kaden',
  'Paxton',
  'Kyrie',
  'Kyle',
  'Griffin',
  'Josue',
  'Kenneth',
  'Beckett',
  'Enzo',
  'Adriel',
  'Arthur',
  'Felix',
  'Bryan',
  'Lukas',
  'Paul',
  'Brian',
  'Colt',
  'Caden',
  'Leon',
  'Archer',
  'Omar',
  'Israel',
  'Aidan',
  'Theo',
  'Javier',
  'Remington',
  'Jaden',
  'Bradley',
  'Emilio',
  'Colin',
  'Riley',
  'Cayden',
  'Phoenix',
  'Clayton',
  'Simon',
  'Ace',
  'Nash',
  'Derek',
  'Rafael',
  'Zander',
  'Brady',
  'Jorge',
  'Jake',
  'Louis',
  'Damien',
  'Karson',
  'Walker',
  'Maximiliano',
  'Amari',
  'Sean',
  'Chance',
  'Walter',
  'Martin',
  'Finley',
  'Andre',
  'Tobias',
  'Cash',
  'Corbin',
  'Arlo',
  'Iker',
  'Erick',
  'Emerson',
  'Gunner',
  'Cody',
  'Stephen',
  'Francisco',
  'Killian',
  'Dallas',
  'Reid',
  'Manuel',
  'Lane',
  'Atlas',
  'Rylan',
  'Jensen',
  'Ronan',
  'Beckham',
  'Daxton',
  'Anderson',
  'Kameron',
  'Raymond',
  'Orion',
  'Cristian',
  'Tanner',
  'Kyler',
  'Jett',
  'Cohen',
  'Ricardo',
  'Spencer',
  'Gideon',
  'Ali',
  'Fernando',
  'Jaiden',
  'Titus',
  'Travis',
  'Bodhi',
  'Eduardo',
  'Dante',
  'Ellis',
  'Prince',
  'Kane',
  'Luka',
  'Kash',
  'Hendrix',
  'Desmond',
  'Donovan',
  'Mario',
  'Atticus',
  'Cruz',
  'Garrett',
  'Hector',
  'Angelo',
  'Jeffrey',
  'Edwin',
  'Cesar',
  'Zayn',
  'Devin',
  'Conor',
  'Warren',
  'Odin',
  'Jayceon',
  'Romeo',
  'Julius',
  'Jaylen',
  'Hayes',
  'Kayson',
  'Muhammad',
  'Jaxton',
  'Joaquin',
  'Caiden',
  'Dakota',
  'Major',
  'Keegan',
  'Sergio',
  'Marshall',
  'Johnny',
  'Kade',
  'Edgar',
  'Leonel',
  'Ismael',
  'Marco',
  'Tyson',
  'Wade',
  'Collin',
  'Troy',
  'Nasir',
  'Conner',
  'Adonis',
  'Jared',
  'Rory',
  'Andy',
  'Jase',
  'Lennox',
  'Shane',
  'Malik',
  'Ari',
  'Reed',
  'Seth',
  'Clark',
  'Erik',
  'Lawson',
  'Trevor',
  'Gage',
  'Nico',
  'Malakai',
  'Quinn',
  'Cade',
  'Johnathan',
  'Sullivan',
  'Solomon',
  'Cyrus',
  'Fabian',
  'Pedro',
  'Frank',
  'Shawn',
  'Malcolm',
  'Khalil',
  'Nehemiah',
  'Dalton',
  'Mathias',
  'Jay',
  'Ibrahim',
  'Peyton',
  'Winston',
  'Kason',
  'Zayne',
  'Noel',
  'Princeton',
  'Matthias',
  'Gregory',
  'Sterling',
  'Dominick',
  'Elian',
  'Grady',
  'Russell',
  'Finnegan',
  'Ruben',
  'Gianni',
  'Porter',
  'Kendrick',
  'Leland',
  'Pablo',
  'Allen',
  'Hugo',
  'Raiden',
  'Kolton',
  'Remy',
  'Ezequiel',
  'Damon',
  'Emanuel',
  'Zaiden',
  'Otto',
  'Bowen',
  'Marcos',
  'Abram',
  'Kasen',
  'Franklin',
  'Royce',
  'Jonas',
  'Sage',
  'Philip',
  'Esteban',
  'Drake',
  'Kashton',
  'Roberto',
  'Harvey',
  'Alexis',
  'Kian',
  'Jamison',
  'Maximilian',
  'Adan',
  'Milan',
  'Phillip',
  'Albert',
  'Dax',
  'Mohamed',
  'Ronin',
  'Kamden',
  'Hank',
  'Memphis',
  'Oakley',
  'Augustus',
  'Drew',
  'Moises',
  'Armani',
  'Rhys',
  'Benson',
  'Jayson',
  'Kyson',
  'Braylen',
  'Corey',
  'Gunnar',
  'Omari',
  'Alonzo',
  'Landen',
  'Armando',
  'Derrick',
  'Dexter',
  'Enrique',
  'Bruce',
  'Nikolai',
  'Francis',
  'Rocco',
  'Kairo',
  'Royal',
  'Zachariah',
  'Arjun',
  'Deacon',
  'Skyler',
  'Eden',
  'Alijah',
  'Rowen',
  'Pierce',
  'Uriel',
  'Ronald',
  'Luciano',
  'Tate',
  'Frederick',
  'Kieran',
  'Lawrence',
  'Moses',
  'Rodrigo'
];
List<String> womenNames = [
  'Emma',
  'Olivia',
  'Ava',
  'Isabella',
  'Sophia',
  'Charlotte',
  'Mia',
  'Amelia',
  'Harper',
  'Evelyn',
  'Abigail',
  'Emily',
  'Elizabeth',
  'Mila',
  'Ella',
  'Avery',
  'Sofia',
  'Camila',
  'Aria',
  'Scarlett',
  'Victoria',
  'Madison',
  'Luna',
  'Grace',
  'Chloe',
  'Penelope',
  'Layla',
  'Riley',
  'Zoey',
  'Nora',
  'Lily',
  'Eleanor',
  'Hannah',
  'Lillian',
  'Addison',
  'Aubrey',
  'Ellie',
  'Stella',
  'Natalie',
  'Zoe',
  'Leah',
  'Hazel',
  'Violet',
  'Aurora',
  'Savannah',
  'Audrey',
  'Brooklyn',
  'Bella',
  'Claire',
  'Skylar',
  'Lucy',
  'Paisley',
  'Everly',
  'Anna',
  'Caroline',
  'Nova',
  'Genesis',
  'Emilia',
  'Kennedy',
  'Samantha',
  'Maya',
  'Willow',
  'Kinsley',
  'Naomi',
  'Aaliyah',
  'Elena',
  'Sarah',
  'Ariana',
  'Allison',
  'Gabriella',
  'Alice',
  'Madelyn',
  'Cora',
  'Ruby',
  'Eva',
  'Serenity',
  'Autumn',
  'Adeline',
  'Hailey',
  'Gianna',
  'Valentina',
  'Isla',
  'Eliana',
  'Quinn',
  'Nevaeh',
  'Ivy',
  'Sadie',
  'Piper',
  'Lydia',
  'Alexa',
  'Josephine',
  'Emery',
  'Julia',
  'Delilah',
  'Arianna',
  'Vivian',
  'Kaylee',
  'Sophie',
  'Brielle',
  'Madeline',
  'Peyton',
  'Rylee',
  'Clara',
  'Hadley',
  'Melanie',
  'Mackenzie',
  'Reagan',
  'Adalynn',
  'Liliana',
  'Aubree',
  'Jade',
  'Katherine',
  'Isabelle',
  'Natalia',
  'Raelynn',
  'Maria',
  'Athena',
  'Ximena',
  'Arya',
  'Leilani',
  'Taylor',
  'Faith',
  'Rose',
  'Kylie',
  'Alexandra',
  'Mary',
  'Margaret',
  'Lyla',
  'Ashley',
  'Amaya',
  'Eliza',
  'Brianna',
  'Bailey',
  'Andrea',
  'Khloe',
  'Jasmine',
  'Melody',
  'Iris',
  'Isabel',
  'Norah',
  'Annabelle',
  'Valeria',
  'Emerson',
  'Adalyn',
  'Ryleigh',
  'Eden',
  'Emersyn',
  'Anastasia',
  'Kayla',
  'Alyssa',
  'Juliana',
  'Charlie',
  'Esther',
  'Ariel',
  'Cecilia',
  'Valerie',
  'Alina',
  'Molly',
  'Reese',
  'Aliyah',
  'Lilly',
  'Parker',
  'Finley',
  'Morgan',
  'Sydney',
  'Jordyn',
  'Eloise',
  'Trinity',
  'Daisy',
  'Kimberly',
  'Lauren',
  'Genevieve',
  'Sara',
  'Arabella',
  'Harmony',
  'Elise',
  'Remi',
  'Teagan',
  'Alexis',
  'London',
  'Sloane',
  'Laila',
  'Lucia',
  'Diana',
  'Juliette',
  'Sienna',
  'Elliana',
  'Londyn',
  'Ayla',
  'Callie',
  'Gracie',
  'Josie',
  'Amara',
  'Jocelyn',
  'Daniela',
  'Everleigh',
  'Mya',
  'Rachel',
  'Summer',
  'Alana',
  'Brooke',
  'Alaina',
  'Mckenzie',
  'Catherine',
  'Amy',
  'Presley',
  'Journee',
  'Rosalie',
  'Ember',
  'Brynlee',
  'Rowan',
  'Joanna',
  'Paige',
  'Rebecca',
  'Ana',
  'Sawyer',
  'Mariah',
  'Nicole',
  'Brooklynn',
  'Payton',
  'Marley',
  'Fiona',
  'Georgia',
  'Lila',
  'Harley',
  'Adelyn',
  'Alivia',
  'Noelle',
  'Gemma',
  'Vanessa',
  'Journey',
  'Makayla',
  'Angelina',
  'Adaline',
  'Catalina',
  'Alayna',
  'Julianna',
  'Leila',
  'Lola',
  'Adriana',
  'June',
  'Juliet',
  'Jayla',
  'River',
  'Tessa',
  'Lia',
  'Dakota',
  'Delaney',
  'Selena',
  'Blakely',
  'Ada',
  'Camille',
  'Zara',
  'Malia',
  'Hope',
  'Samara',
  'Vera',
  'Mckenna',
  'Briella',
  'Izabella',
  'Hayden',
  'Raegan',
  'Michelle',
  'Angela',
  'Ruth',
  'Freya',
  'Kamila',
  'Vivienne',
  'Aspen',
  'Olive',
  'Kendall',
  'Elaina',
  'Thea',
  'Kali',
  'Destiny',
  'Amiyah',
  'Evangeline',
  'Cali',
  'Blake',
  'Elsie',
  'Juniper',
  'Alexandria',
  'Myla',
  'Ariella',
  'Kate',
  'Mariana',
  'Lilah',
  'Charlee',
  'Daleyza',
  'Nyla',
  'Jane',
  'Maggie',
  'Zuri',
  'Aniyah',
  'Lucille',
  'Leia',
  'Melissa',
  'Adelaide',
  'Amina',
  'Giselle',
  'Lena',
  'Camilla',
  'Miriam',
  'Millie',
  'Brynn',
  'Gabrielle',
  'Sage',
  'Annie',
  'Logan',
  'Lilliana',
  'Haven',
  'Jessica',
  'Kaia',
  'Magnolia',
  'Amira',
  'Adelynn',
  'Makenzie',
  'Stephanie',
  'Nina',
  'Phoebe',
  'Arielle',
  'Evie',
  'Lyric',
  'Alessandra',
  'Gabriela',
  'Paislee',
  'Raelyn',
  'Madilyn',
  'Paris',
  'Makenna',
  'Kinley',
  'Gracelyn',
  'Talia',
  'Maeve',
  'Rylie',
  'Kiara',
  'Evelynn',
  'Brinley',
  'Jacqueline',
  'Laura',
  'Gracelynn',
  'Lexi',
  'Ariah',
  'Fatima',
  'Jennifer',
  'Kehlani',
  'Alani',
  'Ariyah',
  'Luciana',
  'Allie',
  'Heidi',
  'Maci',
  'Phoenix',
  'Felicity',
  'Joy',
  'Kenzie',
  'Veronica',
  'Margot',
  'Addilyn',
  'Lana',
  'Cassidy',
  'Remington',
  'Saylor',
  'Ryan',
  'Keira',
  'Harlow',
  'Miranda',
  'Angel',
  'Amanda',
  'Daniella',
  'Royalty',
  'Gwendolyn',
  'Ophelia',
  'Heaven',
  'Jordan',
  'Madeleine',
  'Esmeralda',
  'Kira',
  'Miracle',
  'Elle',
  'Amari',
  'Danielle',
  'Daphne',
  'Willa',
  'Haley',
  'Gia',
  'Kaitlyn',
  'Oakley',
  'Kailani',
  'Winter',
  'Alicia',
  'Serena',
  'Nadia',
  'Aviana',
  'Demi',
  'Jada',
  'Braelynn',
  'Dylan',
  'Ainsley',
  'Alison',
  'Camryn',
  'Avianna',
  'Bianca',
  'Skyler',
  'Scarlet',
  'Maddison',
  'Nylah',
  'Sarai',
  'Regina',
  'Dahlia',
  'Nayeli',
  'Raven',
  'Helen',
  'Adrianna',
  'Averie',
  'Skye',
  'Kelsey',
  'Tatum',
  'Kensley',
  'Maliyah',
  'Erin',
  'Viviana',
  'Jenna',
  'Anaya',
  'Carolina',
  'Shelby',
  'Sabrina',
  'Mikayla',
  'Annalise',
  'Octavia',
  'Lennon',
  'Blair',
  'Carmen',
  'Yaretzi',
  'Kennedi',
  'Mabel',
  'Zariah',
  'Kyla',
  'Christina',
  'Selah',
  'Celeste',
  'Eve',
  'Mckinley',
  'Milani',
  'Frances',
  'Jimena',
  'Kylee',
  'Leighton',
  'Katie',
  'Aitana',
  'Kayleigh',
  'Sierra',
  'Kathryn',
  'Rosemary',
  'Jolene',
  'Alondra',
  'Elisa',
  'Helena',
  'Charleigh',
  'Hallie',
  'Lainey',
  'Avah',
  'Jazlyn',
  'Kamryn',
  'Mira',
  'Cheyenne',
  'Francesca',
  'Antonella',
  'Wren',
  'Chelsea',
  'Amber',
  'Emory',
  'Lorelei',
  'Nia',
  'Abby',
  'April',
  'Emelia',
  'Carter',
  'Aylin',
  'Cataleya',
  'Bethany',
  'Marlee',
  'Carly',
  'Kaylani',
  'Emely',
  'Liana',
  'Madelynn',
  'Cadence',
  'Matilda',
  'Sylvia',
  'Myra',
  'Fernanda',
  'Oaklyn',
  'Elianna',
  'Hattie',
  'Dayana',
  'Kendra',
  'Maisie',
  'Malaysia',
  'Kara'
];

List<String> lastNames = [
  'SMITH',
  'JOHNSON',
  'WILLIAMS',
  'JONES',
  'BROWN',
  'DAVIS',
  'MILLER',
  'WILSON',
  'MOORE',
  'TAYLOR',
  'ANDERSON',
  'THOMAS',
  'JACKSON',
  'WHITE',
  'HARRIS',
  'MARTIN',
  'THOMPSON',
  'GARCIA',
  'MARTINEZ',
  'ROBINSON',
  'CLARK',
  'RODRIGUEZ',
  'LEWIS',
  'LEE',
  'WALKER',
  'HALL',
  'ALLEN',
  'YOUNG',
  'HERNANDEZ',
  'KING',
  'WRIGHT',
  'LOPEZ',
  'HILL',
  'SCOTT',
  'GREEN',
  'ADAMS',
  'BAKER',
  'GONZALEZ',
  'NELSON',
  'CARTER',
  'MITCHELL',
  'PEREZ',
  'ROBERTS',
  'TURNER',
  'PHILLIPS',
  'CAMPBELL',
  'PARKER',
  'EVANS',
  'EDWARDS',
  'COLLINS',
  'STEWART',
  'SANCHEZ',
  'MORRIS',
  'ROGERS',
  'REED',
  'COOK',
  'MORGAN',
  'BELL',
  'MURPHY',
  'BAILEY',
  'RIVERA',
  'COOPER',
  'RICHARDSON',
  'COX',
  'HOWARD',
  'WARD',
  'TORRES',
  'PETERSON',
  'GRAY',
  'RAMIREZ',
  'JAMES',
  'WATSON',
  'BROOKS',
  'KELLY',
  'SANDERS',
  'PRICE',
  'BENNETT',
  'WOOD',
  'BARNES',
  'ROSS',
  'HENDERSON',
  'COLEMAN',
  'JENKINS',
  'PERRY',
  'POWELL',
  'LONG',
  'PATTERSON',
  'HUGHES',
  'FLORES',
  'WASHINGTON',
  'BUTLER',
  'SIMMONS',
  'FOSTER',
  'GONZALES',
  'BRYANT',
  'ALEXANDER',
  'RUSSELL',
  'GRIFFIN',
  'DIAZ',
  'HAYES',
  'MYERS',
  'FORD',
  'HAMILTON',
  'GRAHAM',
  'SULLIVAN',
  'WALLACE',
  'WOODS',
  'COLE',
  'WEST',
  'JORDAN',
  'OWENS',
  'REYNOLDS',
  'FISHER',
  'ELLIS',
  'HARRISON',
  'GIBSON',
  'MCDONALD',
  'CRUZ',
  'MARSHALL',
  'ORTIZ',
  'GOMEZ',
  'MURRAY',
  'FREEMAN',
  'WELLS',
  'WEBB',
  'SIMPSON',
  'STEVENS',
  'TUCKER',
  'PORTER',
  'HUNTER',
  'HICKS',
  'CRAWFORD',
  'HENRY',
  'BOYD',
  'MASON',
  'MORALES',
  'KENNEDY',
  'WARREN',
  'DIXON',
  'RAMOS',
  'REYES',
  'BURNS',
  'GORDON',
  'SHAW',
  'HOLMES',
  'RICE',
  'ROBERTSON',
  'HUNT',
  'BLACK',
  'DANIELS',
  'PALMER',
  'MILLS',
  'NICHOLS',
  'GRANT',
  'KNIGHT',
  'FERGUSON',
  'ROSE',
  'STONE',
  'HAWKINS',
  'DUNN',
  'PERKINS',
  'HUDSON',
  'SPENCER',
  'GARDNER',
  'STEPHENS',
  'PAYNE',
  'PIERCE',
  'BERRY',
  'MATTHEWS',
  'ARNOLD',
  'WAGNER',
  'WILLIS',
  'RAY',
  'WATKINS',
  'OLSON',
  'CARROLL',
  'DUNCAN',
  'SNYDER',
  'HART',
  'CUNNINGHAM',
  'BRADLEY',
  'LANE',
  'ANDREWS',
  'RUIZ',
  'HARPER',
  'FOX',
  'RILEY',
  'ARMSTRONG',
  'CARPENTER',
  'WEAVER',
  'GREENE',
  'LAWRENCE',
  'ELLIOTT',
  'CHAVEZ',
  'SIMS',
  'AUSTIN',
  'PETERS',
  'KELLEY',
  'FRANKLIN',
  'LAWSON',
  'FIELDS',
  'GUTIERREZ',
  'RYAN',
  'SCHMIDT',
  'CARR',
  'VASQUEZ',
  'CASTILLO',
  'WHEELER',
  'CHAPMAN',
  'OLIVER',
  'MONTGOMERY',
  'RICHARDS',
  'WILLIAMSON',
  'JOHNSTON',
  'BANKS',
  'MEYER',
  'BISHOP',
  'MCCOY',
  'HOWELL',
  'ALVAREZ',
  'MORRISON',
  'HANSEN',
  'FERNANDEZ',
  'GARZA',
  'HARVEY',
  'LITTLE',
  'BURTON',
  'STANLEY',
  'NGUYEN',
  'GEORGE',
  'JACOBS',
  'REID',
  'KIM',
  'FULLER',
  'LYNCH',
  'DEAN',
  'GILBERT',
  'GARRETT',
  'ROMERO',
  'WELCH',
  'LARSON',
  'FRAZIER',
  'BURKE',
  'HANSON',
  'DAY',
  'MENDOZA',
  'MORENO',
  'BOWMAN',
  'MEDINA',
  'FOWLER',
  'BREWER',
  'HOFFMAN',
  'CARLSON',
  'SILVA',
  'PEARSON',
  'HOLLAND',
  'DOUGLAS',
  'FLEMING',
  'JENSEN',
  'VARGAS',
  'BYRD',
  'DAVIDSON',
  'HOPKINS',
  'MAY',
  'TERRY',
  'HERRERA',
  'WADE',
  'SOTO',
  'WALTERS',
  'CURTIS',
  'NEAL',
  'CALDWELL',
  'LOWE',
  'JENNINGS',
  'BARNETT',
  'GRAVES',
  'JIMENEZ',
  'HORTON',
  'SHELTON',
  'BARRETT',
  'OBRIEN',
  'CASTRO',
  'SUTTON',
  'GREGORY',
  'MCKINNEY',
  'LUCAS',
  'MILES',
  'CRAIG',
  'RODRIQUEZ',
  'CHAMBERS',
  'HOLT',
  'LAMBERT',
  'FLETCHER',
  'WATTS',
  'BATES',
  'HALE',
  'RHODES',
  'PENA',
  'BECK',
  'NEWMAN',
  'HAYNES',
  'MCDANIEL',
  'MENDEZ',
  'BUSH',
  'VAUGHN',
  'PARKS',
  'DAWSON',
  'SANTIAGO',
  'NORRIS',
  'HARDY',
  'LOVE',
  'STEELE',
  'CURRY',
  'POWERS',
  'SCHULTZ',
  'BARKER',
  'GUZMAN',
  'PAGE',
  'MUNOZ',
  'BALL',
  'KELLER',
  'CHANDLER',
  'WEBER',
  'LEONARD',
  'WALSH',
  'LYONS',
  'RAMSEY',
  'WOLFE',
  'SCHNEIDER',
  'MULLINS',
  'BENSON',
  'SHARP',
  'BOWEN',
  'DANIEL',
  'BARBER',
  'CUMMINGS',
  'HINES',
  'BALDWIN',
  'GRIFFITH',
  'VALDEZ',
  'HUBBARD',
  'SALAZAR',
  'REEVES',
  'WARNER',
  'STEVENSON',
  'BURGESS',
  'SANTOS',
  'TATE',
  'CROSS',
  'GARNER',
  'MANN',
  'MACK',
  'MOSS',
  'THORNTON',
  'DENNIS',
  'MCGEE',
  'FARMER',
  'DELGADO',
  'AGUILAR',
  'VEGA',
  'GLOVER',
  'MANNING',
  'COHEN',
  'HARMON',
  'RODGERS',
  'ROBBINS',
  'NEWTON',
  'TODD',
  'BLAIR',
  'HIGGINS',
  'INGRAM',
  'REESE',
  'CANNON',
  'STRICKLAND',
  'TOWNSEND',
  'POTTER',
  'GOODWIN',
  'WALTON',
  'ROWE',
  'HAMPTON',
  'ORTEGA',
  'PATTON',
  'SWANSON',
  'JOSEPH',
  'FRANCIS',
  'GOODMAN',
  'MALDONADO',
  'YATES',
  'BECKER',
  'ERICKSON',
  'HODGES',
  'RIOS',
  'CONNER',
  'ADKINS',
  'WEBSTER',
  'NORMAN',
  'MALONE',
  'HAMMOND',
  'FLOWERS',
  'COBB',
  'MOODY',
  'QUINN',
  'BLAKE',
  'MAXWELL',
  'POPE',
  'FLOYD',
  'OSBORNE',
  'PAUL',
  'MCCARTHY',
  'GUERRERO',
  'LINDSEY',
  'ESTRADA',
  'SANDOVAL',
  'GIBBS',
  'TYLER',
  'GROSS',
  'FITZGERALD',
  'STOKES',
  'DOYLE',
  'SHERMAN',
  'SAUNDERS',
  'WISE',
  'COLON',
  'GILL',
  'ALVARADO',
  'GREER',
  'PADILLA',
  'SIMON',
  'WATERS',
  'NUNEZ',
  'BALLARD',
  'SCHWARTZ',
  'MCBRIDE',
  'HOUSTON',
  'CHRISTENSEN',
  'KLEIN',
  'PRATT',
  'BRIGGS',
  'PARSONS',
  'MCLAUGHLIN',
  'ZIMMERMAN',
  'FRENCH',
  'BUCHANAN',
  'MORAN',
  'COPELAND',
  'ROY',
  'PITTMAN',
  'BRADY',
  'MCCORMICK',
  'HOLLOWAY',
  'BROCK',
  'POOLE',
  'FRANK',
  'LOGAN',
  'OWEN',
  'BASS',
  'MARSH',
  'DRAKE',
  'WONG',
  'JEFFERSON',
  'PARK',
  'MORTON',
  'ABBOTT',
  'SPARKS',
  'PATRICK',
  'NORTON',
  'HUFF',
  'CLAYTON',
  'MASSEY',
  'LLOYD',
  'FIGUEROA',
  'CARSON',
  'BOWERS',
  'ROBERSON',
  'BARTON',
  'TRAN',
  'LAMB',
  'HARRINGTON',
  'CASEY',
  'BOONE',
  'CORTEZ',
  'CLARKE',
  'MATHIS',
  'SINGLETON',
  'WILKINS',
  'CAIN',
  'BRYAN',
  'UNDERWOOD',
  'HOGAN',
  'MCKENZIE',
  'COLLIER',
  'LUNA',
  'PHELPS',
  'MCGUIRE',
  'ALLISON',
  'BRIDGES',
  'WILKERSON',
  'NASH',
  'SUMMERS',
  'ATKINS',
];
