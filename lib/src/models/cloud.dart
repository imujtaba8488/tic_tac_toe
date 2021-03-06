import 'package:cloud_firestore/cloud_firestore.dart';

class Cloud {
  final Firestore firestore = Firestore.instance;

  /// Updates a win or loss for the given username in the cloud.
  Future<void> sync(String username, bool win) async {
    int totalWins = 0; // total number of wins.
    int totalLost = 0; // total number of losses.

    String uname; // temp: username.
    String pwd; // temp: password.
    int wins; // temp: previous wins.
    int lost; // temp: previous lost.

    // Get previous stats / info.
    await firestore.collection('score').getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        uname = document.data['username'];
        pwd = document.data['password'];
        wins = document.data['wins'];
        lost = document.data['lost'];

        if (uname.contains(username)) {
          totalWins = wins;
          totalLost = lost;
        }
      });
    });

    // If win update wins else update lost.
    win ? totalWins++ : totalLost++;

    // Update on firestore.
    firestore.collection('score').document(username).setData({
      'username': username,
      'password': pwd,
      'wins': totalWins,
      'lost': totalLost,
    });
  }

  /// ! Caution: deletes the entire collection, including user credentials.
  void reset() async {
    // ? how to delete an entire collection?
  }

  /// Returns true if a user with the given [username] exists in the cloud.
  Future<bool> userExists(String username, String password) async {
    bool result = false;

    await firestore.collection('score').getDocuments().then((snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i].data['username'] == username &&
            snapshot.documents[i].data['password'] == password) result = true;
      }
    });

    return Future.value(result);
  }

  /// Adds the user with the given [username] to the cloud. Note: as of now duplicate usernames are not checked for //! Review:
  void addUser(String username, String password) async {
    await firestore.collection('score').document(username).setData({
      'username': username,
      'password': password,
      'wins': 0,
      'lost': 0,
    });
  }

  /// Gets a list of all the users in the cloud.
  Future<List<Map<String, dynamic>>> get allUsers async {
    List<Map<String, dynamic>> data = List();

    await firestore
        .collection('score')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((document) {
        String username = document.data['username'];
        String password = document.data['password'];
        int wins = document.data['wins'];
        int lost = document.data['lost'];

        data.add({
          'username': username,
          'password': password,
          'wins': wins,
          'lost': lost,
        });
      });
    });

    return Future.value(data);
  }

  /// Gets the user with the given [username].
  Future<Map<String, dynamic>> getUser(String username) async {
    List<Map<String, dynamic>> cloudUsers = await allUsers;

    Map<String, dynamic> user;

    for (int i = 0; i < cloudUsers.length; i++) {
      if (cloudUsers[i]['username'].contains(username)) {
        user = cloudUsers[i];
      }
    }

    return Future.value(user);
  }
}
