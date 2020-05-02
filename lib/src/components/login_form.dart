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
  String _username;
  String _password;
  GameModel _gameModel;
  bool loginAttempt = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        this._gameModel = gameModel;

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
                  onSaved: (value) => _username = value,
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
                  onSaved: (value) => _password = value,
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
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 24,
                      child: RaisedButton(
                        onPressed: (){},
                        child: Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
              if (loginAttempt) CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  // Action to be taken when user tries to login either by pressing login button or hitting the submit key on the keyboard.
  void _onFormSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        loginAttempt = true;
      });

      await Cloud().userExists(_username, _password).then(
        (bool exists) {
          if (exists) {
            _gameModel.player1.name = _username;


            _gameModel.player1.username = _username;
            _gameModel.refreshScores();
            _gameModel.updatePlayerRank();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomePage();
                },
              ),
            );

            setState(() {
              loginAttempt = false;
            });
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error: No such user exists.'),
                  content: Text('Please sign Up!'),
                  actions: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        loginAttempt = false;
                      },
                      child: Text('OK'),
                    )
                  ],
                );
              },
            );
          }
        },
      );
    }
  }
}
