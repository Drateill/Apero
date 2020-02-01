import 'package:Apero/screens/services/auth.dart';
import 'package:Apero/screens/services/shared/constants.dart';
import 'package:Apero/screens/services/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String confirmpassword = '';
  String pseudo='';

  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
                actions: <Widget>[
                  FlatButton.icon(
                    label: Text('SignIn'),
                    icon: Icon(Icons.person),
                    onPressed: () => widget.toggleView(),
                  )
                ],
                backgroundColor: Colors.brown[400],
                elevation: 0,
                title: Text('Sign up')),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Pseudo'),
                          validator: (val) =>
                              val.isEmpty ? 'Choisis un pseudo' : null,
                          onChanged: (val) {
                            setState(() => pseudo = val);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Enter a password 6+ chars long'),
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Confirm your password'),
                          validator: (val) => val.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => confirmpassword = val);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: Colors.pink[400],
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (password == confirmpassword) {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password,pseudo );
                                if (result == null) {
                                  setState(() =>
                                      error = 'please supply a valid email ');
                                  loading = false;
                                }
                              }
                            } else {
                              setState(() {
                                 error ='Your password doesn\'t match';
                              });
                             
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        )
                      ],
                    ))),
          );
  }
}
