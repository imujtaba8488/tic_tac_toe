import 'package:flutter/material.dart';

import '../scoped_models/game_model.dart';
import '../models/cloud.dart';
import '../pages/home_page.dart';

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'username',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.person),
              ),
              onSaved: (value) => username = value,
              onFieldSubmitted: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.lock)),
              obscureText: true,
              onSaved: (value) => password = value,
              onFieldSubmitted: (value) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Text('forgot password?'),
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text('login'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void onFormSave(GameModel gameModel) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await Cloud().userExists(username, password).then((bool exists) {
        if (exists) {
          gameModel.player1.name = username;
          gameModel.refreshScores();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ),
          );
        } else {
          print("user doens't exist. Please sign up!");
        }
      });
    }
  }
}
