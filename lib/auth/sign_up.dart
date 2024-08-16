import 'package:flutter/material.dart';
import 'package:project_app1/extensions/valid_email.dart';
import 'package:project_app1/screens/join_screen.dart';
import 'package:project_app1/services/auth.dart';
import 'package:project_app1/services/auth_exception.dart';
import 'package:project_app1/widgets/loading.dart';

class SignUpWrapper extends StatelessWidget {
  const SignUpWrapper({super.key, required this.toggleView});
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
                    child: SignUp(toggleView: toggleView),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: SignUp(toggleView: toggleView),
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

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.toggleView});
  final Function toggleView;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';
  String firstName = '';
  String lastName = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Create your Account',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: Text('Join The Fight - Let\'s End Trafficking',
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
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val != null && val.isValidEmail()
                            ? null
                            : "Check your email",
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
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
                        validator: (val) => val != null && val.length < 6
                            ? '6 or more characters'
                            : null,
                        onChanged: (val) {
                          password = val;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'First / Given Name',
                          fillColor: Colors.lightGreen.shade100,
                          filled: true,
                        ),
                        validator: (val) => val != null && val.length < 2
                            ? 'Please fill in your name'
                            : null,
                        onChanged: (val) {
                          firstName = val;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Last Name or Initial',
                          fillColor: Colors.lightGreen.shade100,
                          filled: true,
                        ),
                        validator: (val) => val != null && val.length < 2
                            ? 'We need this for your Reservations'
                            : null,
                        onChanged: (val) {
                          lastName = val;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: Text('Sign In instead',
                                style: TextStyle(
                                    color: Colors.lightGreen.shade900)),
                          ),
                          ElevatedButton(
                            child: Text(
                              'Continue',
                              style:
                                  TextStyle(color: Colors.lightGreen.shade900),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.lightGreen),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic status = await _auth.registerWithEmail(
                                  email: email,
                                  password: password,
                                  firstName: firstName,
                                  lastName: lastName,
                                  role: 'user',
                                );
                                if (status != AuthResultStatus.successful) {
                                  setState(() {
                                    loading = false;
                                  });
                                  final errorMsg = AuthExceptionHandler
                                      .generateExceptionMessage(status);
                                  _showAlertDialog(errorMsg);
                                } else {
                                  await Navigator.push(
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
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  // Future<void> _navigateBasedOnRole(BuildContext context) async {
  //   final role = await _auth.getUserRole();
  //   if (role == 'admin') {
  //     Navigator.pushReplacementNamed(context, '/admin');
  //   } else {
  //     Navigator.pushReplacementNamed(context, '/member');
  //   }
  // }

  void _showAlertDialog(String errorMsg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Registration Failed',
              style: TextStyle(color: Colors.black),
            ),
            content: Text(errorMsg),
          );
        });
  }
}
