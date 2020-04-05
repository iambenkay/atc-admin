import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Auth/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>(), _scaffoldKey = GlobalKey<ScaffoldState>();
  Auth auth;

  TextEditingController _email, _password;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<Auth>(context);
    return Scaffold(
      key: _scaffoldKey,
          body: Stack(
        children: <Widget>[
          Container(
            color: Color(0xffe29464),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
              ),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('ADMIN',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        color: Color(0xffffffff),
                        child: TextFormField(
                          controller: _email,
                          validator: (value) =>
                              (value.isEmpty) ? "Please enter email" : null,
                          style: TextStyle(
                              color: Colors.black),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email address',
                              prefixIcon: Icon(Icons.person_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xffffffff),
                      child: TextFormField(
                        controller: _password,
                        validator: (value) =>
                            (value.isEmpty) ? "Please enter password" : null,
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.black),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffaa5577))),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: auth.status == Status.Authenticating
                          ? Center(child: CircularProgressIndicator())
                          : MaterialButton(
                              onPressed: () async {
                                _scaffoldKey.currentState.hideCurrentSnackBar();
                                if (_formKey.currentState.validate()) {
                                  try {
                                    await auth.signIn(
                                        _email.text, _password.text);
                                  } on PlatformException catch (err) {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                        backgroundColor: Color(0xffcc0000),
                                        content: Text(
                                          err.message,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15),
                                        )));
                                  }
                                }
                              }, //since this is only a UI app
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Color(0xffe29464),
                              elevation: 0,
                              minWidth: 400,
                              height: 50,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
