import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_app1/models/profile.dart';
import 'package:project_app1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:project_app1/accounts/admin.dart';
import 'package:project_app1/accounts/user.dart';
import 'package:project_app1/auth/toggle_auth.dart';
import 'package:project_app1/models/app_user.dart';
import 'package:project_app1/services/auth.dart';

class JoinScreen extends StatelessWidget {
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return ToggleAuth();
    } else {
      return const BaseWrapper();
    }
  }
}

class BaseWrapper extends StatefulWidget {
  const BaseWrapper({super.key});

  @override
  State<BaseWrapper> createState() => _BaseWrapperState();
}

class _BaseWrapperState extends State<BaseWrapper> {
  Future<String> _getRole(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(user.uid)
        .get();
    if (snap.exists) {
      final role = snap['role'] ?? 'user';
      print('Fetched role: $role'); // Debug print
      return role;
    } else {
      throw Exception('User document not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return FutureBuilder<String>(
      future: _getRole(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          print('Error loading role: ${snapshot.error}');
          return Scaffold(
            appBar: AppBar(title: Text('error'), actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await _auth.signOut();
                },
              )
            ]),
            body: Center(
              child: Text('Error loading role'),
            ),
          );
        }
        if (snapshot.hasData) {
          print('User role: ${snapshot.data}'); // Debug print
          switch (snapshot.data) {
            case 'admin':
              return AdminScreen();
            case 'user':
            default:
              return UserScreen();
          }
        }
        return Scaffold(
          body: Center(
            child: Text('Unexpected state'),
          ),
        );
      },
    );
  }
}

// class BaseWrapper extends StatelessWidget {
//   const BaseWrapper({super.key});

//   // Future<String> _getRole(BuildContext context) async {
//   //   final auth = Provider.of<AuthService>(context, listen: false);
//   //   final token = await auth.claims;
//   //   final String? roleClaim = token?['role'] as String?;
//   //   print('Fetched role: $roleClaim');  // Debug print
//   //   return roleClaim ?? 'user';
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: _getRole(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//         if (snapshot.hasError) {
//           print('Error loading role: ${snapshot.error}'); 
//           return const Scaffold(
//             body: Center(
//               child: Text('Error loading role'),
//             ),
//           );
//         }
//         if (snapshot.hasData) {
//           print('User role: ${snapshot.data}');  // Debug print
//           switch (snapshot.data) {
//             case 'admin':
//               return AdminScreen();
//             case 'user':
//             default:
//               return UserScreen();
//           }
//         }
//         return const Scaffold(
//           body: Center(
//             child: Text('Unexpected state'),
//           ),
//         );
//       },
//     );
//   }
// }



// class BaseWrapper extends StatefulWidget {
//   const BaseWrapper({super.key});

//   @override
//   State<BaseWrapper> createState() => _BaseWrapperState();
// }

// class _BaseWrapperState extends State<BaseWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('User not logged in');
//     }

//     return StreamBuilder<Profile>(
//       stream: DatabaseService(uid: user.uid).profile,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//         if (snapshot.hasError) {
//           print('Error loading profile: ${snapshot.error}');
//           return Scaffold(
//             body: Center(
//               child: Text('Error loading profile'),
//             ),
//           );
//         }
//         if (snapshot.hasData) {
//           final profile = snapshot.data!;

//           // Assuming 'role' is stored in the profile document
//           switch (profile.role) {
//             case 'admin':
//               return AdminScreen();
//             case 'user':
//             default:
//               return UserScreen();
//           }
//         }
//         return Scaffold(
//           body: Center(
//             child: Text('Unexpected state'),
//           ),
//         );
//       },
//     );
//   }
// }
