import 'package:cloud_firestore/cloud_firestore.dart';

class Cloud {
  final Firestore firestore = Firestore.instance;

  void sync(String username, bool win) async {
    String passcode;

    int wins = 0;
    int lost = 0;

    await firestore.collection('score').getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        String uname = '';
        int w = 0;
        int l = 0;

        uname = document.data['username'];
        passcode = document.data['password'];
        w = document.data['wins'];
        l = document.data['lost'];

        if (uname.contains(username)) {
          wins = w;
          lost = l;
        }
      });
    });

    print('wins: $wins');
    print('lost: $lost');

    win ? wins++ : lost++;

    await firestore.collection('score').document(username).setData({
      'username': username,
      'password': passcode,
      'wins': wins,
      'lost': lost,
    });

    // firestore.runTransaction()
  }

  void reset() async {
    // await firestore.collection(username).document('score').delete();
  }

  Future<bool> userExists(String username, String password) async {
    bool result = false;

    await firestore.collection('score').getDocuments().then((snapshot) {
      for (int i = 0; i < snapshot.documents.length; i++) {
        if (snapshot.documents[i].data['username'] == username &&
            snapshot.documents[i].data['password'] == password) result = true;
      }
    });

    if (!result) {
      await firestore.collection('score').document(username).setData({
        'username': username,
        'password': password,
        'wins': 0,
        'lost': 0,
      });
    }

    return Future.value(result);
  }
}
