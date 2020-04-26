import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
  GameModel gameModel;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        this.gameModel = gameModel;

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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Username is required.';
                    } else if (value.length < 4) {
                      return 'Username must not be less than 4 characters';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'password',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  onSaved: (value) => password = value,
                  onFieldSubmitted: (value) => _onFormSave(),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password is required.';
                    } else if (value.length < 6) {
                      return 'Password must be less than 6 characters.';
                    } else {
                      return null;
                    }
                  },
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
                      onPressed: () => _onFormSave(),
                      child: Text('login'),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _onFormSave() async {
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
