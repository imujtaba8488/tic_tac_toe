import 'package:cloud_firestore/cloud_firestore.dart';

class Cloud {
  final Firestore firestore = Firestore.instance;

  /// Updates a win or loss for the given username in the cloud.
  Future<void> sync(String username, bool isAWin) async {
    int totalWins = 0; // total number of wins.
    int totalLost = 0; // total number of losses.

    // Temp place holders.
    String email;
    String uname;
    String pwd;
    int wins;
    int lost;

    // Get previous stats / info.
    await firestore.collection('score').getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        email = document.data['email'];
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
    isAWin ? totalWins++ : totalLost++;


    // Update on firestore.
    firestore.collection('score').document(username).setData({
      'email': email,
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

  /// Returns true if a user with the given [username] and [password] exists in the cloud.
  Future<bool> userExists(String username, String password) async {
    bool result = false;

    await firestore.collection('score').getDocuments().then((snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i].data['username'] == username &&
            snapshot.documents[i].data['password'] == password) result = true;
      }
    });

    // ? Should I use just first one or the commented one. What's the diff?
    return result;
    // return Future.value(result);
  }

  /// Returns 'true' if a user with the given credentials is added successfully, else returns 'false'.
  Future<bool> addUser(String email, String username, String password) async {
    // Only add user if it doesn't already exist in the cloud.
    if (!await userExists(username, password) &&
        email != null &&
        username != null &&
        password != null) {
      await firestore.collection('score').document(username).setData({
        'email': email,
        'username': username,
        'password': password,
        'wins': 0,
        'lost': 0,
      });

      return true;
    } else {
      print(
        '@Cloud @addUser(): Error: While signing up. Ensure username / email does not already exist, email / username / password is not null or empty.',
      );

      return false;
    }
  }

  /// Gets a list of all the users in the cloud.
  Future<List<Map<String, dynamic>>> get allUsers async {
    List<Map<String, dynamic>> data = List();

    await firestore
        .collection('score')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((document) {
        String email = document.data['email'];
        String username = document.data['username'];
        String password = document.data['password'];
        int wins = document.data['wins'];
        int lost = document.data['lost'];

        data.add({
          'email': email,
          'username': username,
          'password': password,
          'wins': wins,
          'lost': lost,
        });
      });
    });

    return Future.value(data);
  }

  /// Gets the user with the given [username], if one exists.
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

  /// Returns the user with the given [email], if one exists.
  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    List<Map<String, dynamic>> cloudUsers = await allUsers;

    Map<String, dynamic> user;

    for (int i = 0; i < cloudUsers.length; i++) {
      if (cloudUsers[i]['email'].contains(email)) {
        user = cloudUsers[i];
      }
    }

    return Future.value(user);
  }

  /// Returns 'true' if a user with the given [username] exists, else returns false.
  Future<bool> isUsernameAvailable(String username) async =>
      await getUser(username) == null;

  /// Returns 'true' if a user with the given [email] exists, else returns 'false'
  Future<bool> isEmailAvailable(String email) async =>
      await getUserByEmail(email) == null;
}
