import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/game_model.dart';
import '../components/login_form.dart';
import 'sign_up_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<GameModel>(
      builder: (context, child, gameModel) {
        return Scaffold(
          body: DefaultTabController(
            length: 2,
            child: Scaffold(
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TabBar(
                        indicatorColor: Colors.black,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 5,
                            color: Colors.yellow,
                          ),
                          insets: EdgeInsets.all(5),
                        ),
                        tabs: <Widget>[
                          Text('Login'),
                          Text('Create Account'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          login(context),
                          SignUpPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget login(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: Image.asset('assets/images/tic_tac_toe.png'),
              backgroundColor: Colors.transparent,
              radius: MediaQuery.of(context).size.height / 15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Just T3',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LoginForm(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
          ),
          Text(
            'copyright @ IM8488 (2020). All rights reserved.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
