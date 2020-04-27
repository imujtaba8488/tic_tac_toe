import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/models/cloud.dart';
import 'package:tic_tac_toe/src/pages/login_page.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String username;
  String password;

  /// 'True' if the form was submitted and 'false' otherwise.
  bool submitted = false;

  TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _customizedFormField(
              label: 'Gmail',
              suffixIcon: Icon(Icons.email),
              onSave: (String value) => email = value,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'email is required';
                } else if (!value.contains('@gmail.com')) {
                  return 'Invalid Email. You must have a gmail account.';
                } else {
                  return null;
                }
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: editController,
              decoration: InputDecoration(
                labelText: 'username',
                suffixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              onSaved: (String value) => username = value,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'username is required.';
                } else if (value.length < 4) {
                  return 'username cannot be less than 4 characters.';
                } else {
                  return null;
                }
              },
            ),
          ),
          _customizedFormField(
              label: 'Password',
              suffixIcon: Icon(Icons.lock),
              obscureText: true,
              onSave: (String value) => password = value,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Password is required.';
                } else if (value.length < 6) {
                  return 'Password cannot be less than 6 characters.';
                } else {
                  return null;
                }
              }),
          Align(
            alignment: Alignment.centerRight,
            child: RaisedButton(
              onPressed: () => _onFormSave(),
              child: Text('Sign up!'),
            ),
          ),
          if (submitted) CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _customizedFormField({
    String label,
    Function validator,
    Function onSave,
    bool obscureText = false,
    Icon suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(),
        ),
        validator: validator,
        obscureText: obscureText,
        onSaved: onSave,
        // onChanged: (value) {
        //   _formKey.currentState.validate();
        // },
      ),
    );
  }

  void _onFormSave() async {
    // ! Review: Also check for email already exists.

    bool usernameTaken = false;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // User has pressed the signup button.
      setState(() {
        submitted = true;
      });

      // Check if username is available.
      var user = await Cloud().getUser(editController.value.text);

      if (user != null) {
        usernameTaken = true;

        setState(() {
          submitted = false;
        });

        showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              'username "${editController.value.text}" is already taken.',
            ),
            content: Text('Please choose a different username!'),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              )
            ],
          ),
        );
      }

      if (!usernameTaken) {
        setState(() {
          submitted = true;
        });

        Cloud().addUser(username, password);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    }
  }
}
