import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/src/auth/auth.dart';
import 'package:flutter_todo/src/helpers/validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController;
  TextEditingController _passwordController;
  TextEditingController _confirmController;
  TextStyle _style = GoogleFonts.peddana(letterSpacing: 1.2);
  InputDecoration _decoration;

  bool _minLength;
  bool _inclNum;
  bool _inclSymb;
  bool _mixCase;
  bool _confirmPass;
  bool _usernameCheck;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();

    _decoration = InputDecoration(hintStyle: _style, errorStyle: _style);

    _minLength = false;
    _inclNum = false;
    _inclSymb = false;
    _mixCase = false;
    _confirmPass = false;
    _usernameCheck = false;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _minLength = _inclNum = _inclSymb = _mixCase = _confirmPass = null;
    super.dispose();
  }

  void _passwordOnChange(String str) {
    _minLength = checkMinLength(str);
    _inclNum = checkNumberInclusion(str);
    _inclSymb = checkSymbolInclusion(str);
    _mixCase = checkMixCase(str);

    setState(() {});
  }

  void _confirmCheck(String str) => setState(() {
        _confirmPass =
            checkBoth(_passwordController.text, _confirmController.text);
      });

  void _usernameValCheck(String str) => setState(() {
        _usernameCheck = str.isNotEmpty && str.length >= 8;
      });

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
              decoration: _decoration.copyWith(hintText: 'Username'),
              validator: (value) {
                if (value.isEmpty || value.length < 6)
                  return "Field is either empty or is less than 6 characters";
                return null;
              },
              onChanged: _usernameValCheck,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _passwordController,
              style: _style,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: _decoration.copyWith(hintText: 'Password'),
              validator: (value) {
                if (value.isEmpty || checkMinLength(value))
                  return "Field doesn't match password field";
                else if (_minLength && _inclNum && _inclSymb && _mixCase)
                  return "Integrity issues check below for 'red info icon'";
                return null;
              },
              onChanged: _passwordOnChange,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _confirmController,
              style: _style,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: _decoration.copyWith(hintText: 'Confirm Password'),
              validator: (value) {
                if (value.isEmpty || checkMinLength(value))
                  return "Field is either empty or is less than 8 characters";
                else if (!_confirmPass) return "Passwords don't match";
                return null;
              },
              onChanged: _confirmCheck,
            ),
          ),
          _buildIntegrityChecker(context),
          _buildSubmitButton(authProv),
        ],
      )),
    );
  }

  Widget _buildSubmitButton(Auth authProv) => authProv.authStatus ==
          AuthLoading.Authenticating
      ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()))
      : Padding(
          padding: const EdgeInsets.all(10.0),
          child: RaisedButton(
            color: Colors.deepPurple,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Create Account',
                  style: _style
                      .merge(TextStyle(fontSize: 20.0, color: Colors.white))),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate() &&
                  (_minLength &&
                      _inclSymb &&
                      _inclNum &&
                      _mixCase &&
                      _confirmPass &&
                      _usernameCheck)) {
                FocusScope.of(context).unfocus();
                String email = '${_usernameController.text}@todo.com';
                String hashed = Crypt.sha256(_passwordController.text).hash;

                bool logged =
                    await authProv.registerWithEmailandPassword(email, hashed);

                return (!logged)
                    ? showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                              title: Text('Login Error'),
                              content: Text('Could not create account'),
                              actions: [
                                FlatButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    _usernameController.clear();
                                    _passwordController.clear();

                                    if (Navigator.canPop(context))
                                      Navigator.pop(context);
                                    else
                                      print('Error in Navigator.pop(context)');
                                  },
                                )
                              ],
                            ))
                    : null;
              }
            },
          ),
        );

  Widget _buildIntegrityChecker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ExpansionTile(
        title: Text(
          'Integrity Check',
          style: _style.merge(TextStyle(fontSize: 15.0)),
        ),
        childrenPadding: EdgeInsets.all(10.0),
        leading: (_minLength &&
                _confirmPass &&
                _inclNum &&
                _inclSymb &&
                _mixCase &&
                _usernameCheck)
            ? Icon(Icons.check_box, color: Colors.green)
            : Icon(Icons.error, color: Colors.red),
        subtitle: (_minLength &&
                _confirmPass &&
                _inclNum &&
                _inclSymb &&
                _mixCase &&
                _usernameCheck)
            ? Text('All checks passed',
                style: _style.merge(
                  TextStyle(color: Colors.green),
                ))
            : Text('Integrity Issues',
                style: _style.merge(TextStyle(color: Colors.red))),
        children: _buildIntegrityExpanded(context),
      ),
    );
  }

  List<Widget> _buildIntegrityExpanded(BuildContext context) {
    return [
      _integrityRow(_usernameCheck, 'Username cannot be empty', _style),
      _integrityRow(_minLength, 'Minimum length 8 characters', _style),
      _integrityRow(_inclNum, 'Must include number', _style),
      _integrityRow(_inclSymb, 'Must include symbol', _style),
      _integrityRow(_mixCase, 'Mixed case required', _style),
      _integrityRow(_confirmPass, 'Passwords must match', _style),
    ];
  }

  Widget _integrityRow(bool toggle, String text, TextStyle style) =>
      Row(children: [
        toggle
            ? Icon(Icons.check_box_rounded, color: Colors.green)
            : Icon(Icons.error, color: Colors.red),
        Text(text, style: style),
      ]);
}
