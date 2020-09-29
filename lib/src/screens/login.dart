import 'package:flutter/material.dart';
import 'package:flutter_todo/src/auth/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final registerCallback;
  Login({this.registerCallback});
  createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  final _style = GoogleFonts.peddana(letterSpacing: 1.2);

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [_buildForm(context)],
    );
  }

  Widget _buildForm(BuildContext context) {
    final authProv = Provider.of<Auth>(context);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: FlutterLogo(
              size: 128,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _usernameController,
              style: _style,
              decoration:
                  InputDecoration(hintText: 'Username', hintStyle: _style),
              validator: (value) {
                if (value.isEmpty || value.length < 6)
                  return "Field is either empty or is less than 6 characters";
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _passwordController,
              style: _style,
              obscureText: true,
              obscuringCharacter: '*',
              decoration:
                  InputDecoration(hintText: 'Password', hintStyle: _style),
              validator: (value) {
                if (value.isEmpty || value.length < 8)
                  return "Field is either empty or is less than 8 characters";
                return null;
              },
            ),
          ),
          authProv.authStatus == AuthLoading.Authenticating
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                      color: Colors.deepPurple,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          String email = '${_usernameController.text}@todo.com';
                          // String hashed =
                          //     Crypt.sha256(_passwordController.text).hash;
                          // print('Hashed in register $hashed');
                          String hashed = _passwordController.text;

                          bool logged = await authProv
                              .loginWithEmailandPassword(email, hashed);

                          return (!logged)
                              ? showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                        title: Text('Login Error'),
                                        content: Text(
                                            'Could not sign in. User not found or invalid credentials'),
                                        actions: [
                                          FlatButton(
                                            child: Text('Close'),
                                            onPressed: () {
                                              _usernameController.clear();
                                              _passwordController.clear();

                                              if (Navigator.canPop(context))
                                                Navigator.pop(context);
                                              else
                                                print(
                                                    'Error in Navigator.pop(context)');
                                            },
                                          )
                                        ],
                                      ))
                              : null;
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('Login',
                            style: _style.merge(TextStyle(
                                fontSize: 20.0, color: Colors.white))),
                      )),
                ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
                child: GestureDetector(
              onTap: widget.registerCallback,
              child: Text('Register for an account',
                  style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline)),
            )),
          ),
        ],
      )),
    );
  }
}
