import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginState();
}

enum FormType {
  login,
  register
}

class _LoginState extends State<Login> {

  final formKey  = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    } 
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()){
      try {
        if (_formType == FormType.login){
          User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
          print('Signed in: ${user.uid}');
        } else {
          User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)).user;
          print('Registered user: ${user.uid}');
        }
      }
      catch (e) {
        print('Error:$e');
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin () {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text ('Firebase Authentication'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        )
        )
    );
  }
  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email is required' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password is required' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }
  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text('Login'),
          onPressed: validateAndSubmit,
       ),
        new FlatButton(
          child: new Text('Create new Account'),
          onPressed: moveToRegister,
       )
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text('Create an Account'),
          onPressed: validateAndSubmit,
       ),
        new FlatButton(
          child: new Text('Already registered? Login'),
          onPressed: moveToLogin,
       )
      ];
    }
  }
}