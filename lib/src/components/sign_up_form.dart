import 'package:flutter/material.dart';
import 'package:tic_tac_toe/src/models/cloud.dart';
import 'package:tic_tac_toe/src/pages/login_page.dart';

// Todo: An email must be in a a valid format such as name.example.com. It must not begin with any of the special character including space, period, and numbers etc. It must not contain any spaces or special characters except dot/underscore. You can send a verification link to verify the email.

// Todo: A username cannot begin with any special character including numbers. It must also not contain any space. It must all be in lowercase. It can't contain any space or special character except 'dot', 'underscore' or numbers.

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
  bool _isSubmitted = false;

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
            onSaved: (String value) => email = value,
            validator: _validateEmail,
          ),
          _customizedFormField(
            label: 'Username',
            suffixIcon: Icon(Icons.person),
            onSaved: (String value) => username = value,
            validator: _validateUsername,
          ),
          _customizedFormField(
            label: 'Password',
            suffixIcon: Icon(Icons.lock),
            obscureText: true,
            onSaved: (String value) => password = value,
            validator: _validatePassword,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: RaisedButton(
              onPressed: () => _onFormSave(),
              child: Text('Sign up!'),
            ),
          ),

          // When the form is submitted, display a progress bar.
          if (_isSubmitted)
            CircularProgressIndicator(),
        ],
      ),
    );
  }

  /// Returns 'null' if [value] is valid, else returns the corresponding error message.
  String _validateEmail(String value) {
    if (value.isEmpty) {
      return 'email is required';
    } else if (!value.contains('@gmail.com')) {
      return 'Invalid Email. You must have a valid gmail account.';
    } else if (value.contains(' ')) {
      return 'Invalid Email. Email cannot contain a space';
    } else {
      return null;
    }
  }

  /// Returns 'null' if [value] is valid, else returns the corresponding error message.
  String _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Username is required.';
    } else if (value.length < 4) {
      return 'Username cannot be less than 4 characters.';
    } else {
      return null;
    }
  }

  /// Returns 'null' if [value] is valid, else returns the corresponding error message.
  String _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required.';
    } else if (value.length < 6) {
      return 'Password cannot be less than 6 characters.';
    } else {
      return null;
    }
  }

  /// Returns a customized form field.
  Widget _customizedFormField({
    String label,
    Function validator,
    Function onSaved,
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
        onSaved: onSaved,
        // onChanged: (value) {
        //   _formKey.currentState.validate();
        // },
      ),
    );
  }

  /// Action to be taken when the form is submitted.
  void _onFormSave() async {
    // ! You're generating a new Cloud instance everytime. Is that required?
    // ! Review: Also check for email already exists.

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Post validation check. Show progress bar until the signup process is complete.
      setState(() {
        _isSubmitted = true;
      });

      if (await Cloud().isEmailTaken(email)) {
        if (await Cloud().isUsernameAvailable(username)) {
          bool success = await Cloud().addUser(email, username, password);

          success
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                )
              : print('Error: @SignUpForm @onFormSave, user not saved.');
        } else {
          _showAlert(
            'Username "$username" is not available. Choose a different one.',
          );
        }
      } else {
        _showAlert('Email "$email" is already taken. Specify a different one.');
      }
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        );
      },
    );
  }
}
