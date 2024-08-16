import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app1/incident_report/models/report_model.dart';
import '../models/profile.dart';

class DatabaseService {
  final String? uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService({this.uid});

  final CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  final CollectionReference _incidentReportsCollection =
      FirebaseFirestore.instance.collection('incident_reports');

  final CollectionReference _updatesCollection =
      FirebaseFirestore.instance.collection('updates');

  Future<String> submitIncidentReport(IncidentReport report) async {
    String docId = _incidentReportsCollection.doc().id;
    IncidentReport reportWithId = report.copyWith(id: docId);
    await _incidentReportsCollection.doc(docId).set(reportWithId.toMap());
    return docId;
  }

  Stream<Profile> get profile {
    return _profileCollection.doc(uid).snapshots().map(_profileFromSnapshot);
  }

  Profile _profileFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    return Profile(
      uid: uid,
      email: data?['email'] ?? '',
      role: data?['role'] ?? 'user',
      firstName: data?['firstName'] ?? 'Valued',
      lastName: data?['lastName'] ?? 'Guest',
      photoUrl: data?['photoUrl'] ?? '',
    );
  }

  Future<Profile?> getProfile(String uid) async {
    final snapshot = await _profileCollection.doc(uid).get();
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      return Profile(
        uid: uid,
        email: data['email'] ?? '',
        role: data['role'] ?? 'user',
        firstName: data['firstName'] ?? 'Valued',
        lastName: data['lastName'] ?? 'Guest',
        photoUrl: data['photoUrl'] ?? '',
      );
    }
    return null;
  }

  Future<void> updateProfileName(
      String firstName, String lastName, String role) async {
    return await _profileCollection.doc(uid).set(
      {'firstName': firstName, 'lastName': lastName, 'role': role},
      SetOptions(merge: true),
    );
  }

  Stream<List<IncidentReport>> getIncidentReports() {
    return _db.collection('incident_reports').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return IncidentReport(
          id: doc.id,
          userId: data['userId'],
          location: data['location'],
          date: data['date'] != null ? DateTime.parse(data['date']) : null,
          time: data['time'],
          category: data['category'],
          description: data['description'],
          reporterType: data['reporterType'],
          mediaFiles: List<String>.from(data['mediaFiles'] ?? []),
          status: data['status'],
          assignedBody: data['assignedBody'],
          isRead: data['isRead'] ?? false,
        );
      }).toList();
    });
  }

  Stream<List<IncidentReport>> getUserIncidentReports(String userId) {
    return _incidentReportsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return IncidentReport(
                id: doc.id,
                userId: data['userId'],
                location: data['location'],
                date:
                    data['date'] != null ? DateTime.parse(data['date']) : null,
                time: data['time'],
                category: data['category'],
                description: data['description'],
                reporterType: data['reporterType'],
                mediaFiles: List<String>.from(data['mediaFiles'] ?? []),
                status: data['status'],
                assignedBody: data['assignedBody'],
                isRead: data['isRead'] ?? false,
              );
            }).toList());
  }

  Future<void> updateReportStatus(String reportId, String status) async {
    return await _incidentReportsCollection.doc(reportId).update({
      'status': status,
    });
  }

  Future<void> assignReportToBody(String reportId, String body) async {
    return await _incidentReportsCollection.doc(reportId).update({
      'assignedBody': body,
    });
  }

  Future<void> markReportAsRead(String reportId) async {
    return await _incidentReportsCollection.doc(reportId).update({
      'isRead': true,
    });
  }

  // New method to submit an update
  Future<String> submitUpdate(String title, String detail) async {
    String docId = _updatesCollection.doc().id;
    final profile = await getProfile(uid!);
    String name = profile != null
        ? '${profile.firstName} ${profile.lastName}'
        : 'Unknown';

    await _updatesCollection.doc(docId).set({
      'id': docId,
      'title': title,
      'detail': detail,
      'name': name,
      'timestamp': FieldValue.serverTimestamp(),
    });
    return docId;
  }

  // Method to delete an update
  Future<void> deleteUpdate(String id) async {
    return await _updatesCollection.doc(id).delete();
  }

  // Method to edit an update
  Future<void> editUpdate(String id, String title, String detail) async {
    return await _updatesCollection.doc(id).update({
      'title': title,
      'detail': detail,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  updateUpdate(String updateId, String title, String detail) {}
}
