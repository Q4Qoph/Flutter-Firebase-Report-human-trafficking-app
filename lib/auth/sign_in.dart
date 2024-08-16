import 'package:flutter/material.dart';
import 'package:project_app1/extensions/valid_email.dart';
import 'package:project_app1/screens/join_screen.dart';
import 'package:project_app1/services/auth.dart';
import 'package:project_app1/services/auth_exception.dart';
import 'package:project_app1/widgets/loading.dart';

class SignInWrapper extends StatelessWidget {
  const SignInWrapper({super.key, required this.toggleView});
  final Function toggleView;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(20), child: Container()),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: (size.width > 600 && size.height > 520)
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 480,
                    height: 380,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: SignIn(toggleView: toggleView),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: SignIn(toggleView: toggleView),
            ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        elevation: 0.0,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.lightGreen.shade50,
            Colors.lightGreen,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ),
      ),
    );
  }
}

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.toggleView});
  final Function toggleView;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Sign In',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text('Use your Email Address',
                      style: TextStyle(color: Colors.lightGreen.shade800)),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Colors.lightGreen.shade100,
                          filled: true,
                        ),
                        validator: (val) {
                          val != null && val.isValidEmail()
                              ? null
                              : "Check your email";
                        },
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          fillColor: Colors.lightGreen.shade100,
                          filled: true,
                        ),
                        obscureText: true,
                        validator: (val) {
                          val != null && val.length < 6
                              ? '6 or more characters'
                              : null;
                        },
                        onChanged: (val) {
                          password = val;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Text('Forgot password',
                                style: TextStyle(
                                    color: Colors.lightGreen.shade900)),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text('Sign In',
                                style: TextStyle(
                                    color: Colors.lightGreen.shade900,
                                    fontWeight: FontWeight.bold)),
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.lightGreen),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                dynamic status =
                                    await _auth.signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                if (status != AuthResultStatus.successful) {
                                  setState(() {
                                    loading = false;
                                  });
                                  final errorMsg = AuthExceptionHandler
                                      .generateExceptionMessage(status);
                                  _showAlertDialog(errorMsg);
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const JoinScreen()),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      Text(error),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Don\'t have an account?',
                          style: TextStyle(color: Colors.lightGreen.shade800)),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: Text(
                          'Join Us',
                          style: TextStyle(color: Colors.lightGreen.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  void _showAlertDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Sign In Failed',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(errorMsg),
        );
      },
    );
  }
}
