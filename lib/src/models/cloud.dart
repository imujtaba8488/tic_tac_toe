import 'package:cloud_firestore/cloud_firestore.dart';

// todo: Perhaps rename this to CloudSync.
class Cloud {
  final Firestore firestore = Firestore.instance;

  void sync(bool win) async {
    int wins = 0;
    int lost = 0;

    await firestore.collection('players').getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        wins = document.data['wins'];
        lost = document.data['lost'];
      });
    });

    win ? wins++ : lost++;

    await firestore.collection('players').document('score').setData({
      'wins': wins,
      'lost': lost,
    });

    // firestore.runTransaction()
  }

  void reset() async {
    await firestore.collection('players').document('score').delete();
  }
}
