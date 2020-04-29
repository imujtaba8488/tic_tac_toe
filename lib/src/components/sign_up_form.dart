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
            onSave: (String value) => email = value,
            validator: _validateEmail,
          ),
          _customizedFormField(
            label: 'Username',
            suffixIcon: Icon(Icons.person),
            onSave: (String value) => username = username,
            validator: _validateUsername,
          ),
          _customizedFormField(
              label: 'Password',
              suffixIcon: Icon(Icons.lock),
              obscureText: true,
              onSave: (String value) => password = value,
              validator: (String value) {}),
          Align(
            alignment: Alignment.centerRight,
            child: RaisedButton(
              onPressed: () => _onFormSave(),
              child: Text('Sign up!'),
            ),
          ),

          // When the form is submitted, display a progress bar.
          if (_isSubmitted) CircularProgressIndicator(),
        ],
      ),
    );
  }

  /// Returns 'null' if [email] is valid, else returns the corresponding error message.
  String _validateEmail(String email) {
    if (email.isEmpty) {
      return 'email is required';
    } else if (!email.contains('@gmail.com')) {
      return 'Invalid Email. You must have a valid gmail account.';
    } else if (email.contains(' ')) {
      return 'Invalid Email. Email cannot contain a space';
    } else {
      return null;
    }
  }

  /// Returns 'null' if [username] is valid, else returns the corresponding error message.
  String _validateUsername(String username) {
    if (username.isEmpty) {
      return 'Password is required.';
    } else if (username.length < 6) {
      return 'Password cannot be less than 6 characters.';
    } else {
      return null;
    }
  }

  /// Returns a customized form field.
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

  /// Action to be taken when the form is submitted.
  void _onFormSave() async {
    // ! You're generating a new Cloud instance everytime. Is that required?
    // ! Review: Also check for email already exists.

    bool usernameTaken = false;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // Post validation check. Show progress bar until the signup process is complete.
      setState(() {
        _isSubmitted = true;
      });

      // Check if username is available.
      //// var user = await Cloud().getUser(editController.value.text);

      if (await Cloud().isUsernameAvailable(username)) {
        usernameTaken = true;

        setState(() {
          _isSubmitted = false;
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
          _isSubmitted = true;
        });

        Cloud().addUser(email, username, password);

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
