import 'package:flutter/foundation.dart';

class Quest {
  const Quest({
    required this.id,
    required this.title,
    required this.xp,
    required this.place,
    required this.mapsQuery,
  });

  final String id;
  final String title;
  final int xp;

  /// Short place name shown on the map pin.
  final String place;

  /// Search query used when opening the quest in Google Maps.
  final String mapsQuery;
}

class Player {
  const Player(this.name, this.xp);
  final String name;
  final int xp;
}

const quests = <Quest>[
  Quest(
    id: 'lions-head',
    title: 'Go on an exciting Hike up Lions Head with Zoe',
    xp: 1000,
    place: "Lion's Head",
    mapsQuery: "Lion's Head, Cape Town",
  ),
  Quest(
    id: 'table-mountain',
    title: 'Take a selfie on Table mountain with friends',
    xp: 950,
    place: 'Table Mountain',
    mapsQuery: 'Table Mountain, Cape Town',
  ),
  Quest(
    id: 'volleyball',
    title: 'Play a game of volley ball at the beach with friends.',
    xp: 930,
    place: 'Camps Bay Beach',
    mapsQuery: 'Camps Bay Beach, Cape Town',
  ),
  Quest(
    id: 'paintball',
    title: 'Gather the squad and go paint balling.',
    xp: 900,
    place: 'Paintball',
    mapsQuery: 'paintball near Cape Town',
  ),
  Quest(
    id: 'bowling',
    title: 'Gather a group of 5 friends and go bowling.',
    xp: 860,
    place: 'Bowling',
    mapsQuery: 'bowling near Cape Town',
  ),
];

const leaderboardPlayers = <Player>[
  Player('Neo', 5000),
  Player('Michael', 4890),
  Player('Jonan', 4889),
  Player('Xavier', 4700),
  Player('Buhle', 4600),
  Player('Naledi', 4600),
  Player('Lilike', 4600),
  Player('Zoe', 4210),
  Player('Thabo', 3980),
  Player('Amahle', 3650),
];

/// Everyone you can find on the "Add friends" screen.
final allUsers = leaderboardPlayers.map((p) => p.name).toList()
  ..addAll(['Sipho', 'Lerato', 'Kyle', 'Ayanda']);

const interestOptions = [
  'Hiking',
  'Reading',
  'Boardgames',
  'Bowling',
  'Shopping',
  'Eating out',
];

/// In-memory app state. Replace with a real backend later.
class AppState extends ChangeNotifier {
  String username = '';
  String email = '';
  int xp = 0;
  final Set<String> interests = {};
  final Set<String> friends = {};
  final Set<String> completedQuests = {};
  final Set<String> questsWithPhoto = {};
  final Map<String, Set<String>> questFriends = {};

  String get displayName =>
      username.isNotEmpty ? username : (email.contains('@') ? email.split('@').first : 'You');

  void signIn({required String email, String username = ''}) {
    this.email = email;
    if (username.isNotEmpty) this.username = username;
    notifyListeners();
  }

  void signOut() {
    username = '';
    email = '';
    xp = 0;
    interests.clear();
    friends.clear();
    completedQuests.clear();
    questsWithPhoto.clear();
    questFriends.clear();
    notifyListeners();
  }

  void setInterests(Iterable<String> values) {
    interests
      ..clear()
      ..addAll(values);
    notifyListeners();
  }

  void addFriends(Iterable<String> names) {
    friends.addAll(names);
    notifyListeners();
  }

  void setQuestFriends(String questId, Set<String> names) {
    questFriends[questId] = names;
    notifyListeners();
  }

  void uploadPhoto(String questId) {
    questsWithPhoto.add(questId);
    notifyListeners();
  }

  void completeQuest(Quest quest) {
    if (completedQuests.add(quest.id)) {
      xp += quest.xp;
      notifyListeners();
    }
  }

  void addXp(int amount) {
    xp += amount;
    notifyListeners();
  }
}

final appState = AppState();
