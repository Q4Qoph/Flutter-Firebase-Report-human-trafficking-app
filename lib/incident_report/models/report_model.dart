class IncidentReport {
  final String? id;
  final String? userId;
  final String? location;
  final DateTime? date;
  final String? time;
  final String? category;
  final String? description;
  final String? reporterType;
  final List<String>? mediaFiles;
  final String? status;
  final String? assignedBody;
  late final bool? isRead;

  IncidentReport({
    this.id,
    this.userId,
    this.location,
    this.date,
    this.time,
    this.category,
    this.description,
    this.reporterType,
    this.mediaFiles,
    this.status,
    this.assignedBody,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'location': location,
      'date': date?.toIso8601String(),
      'time': time,
      'category': category,
      'description': description,
      'reporterType': reporterType,
      'mediaFiles': mediaFiles,
      'status': status,
      'assignedBody': assignedBody,
      'isRead': isRead,
    };
  }

  IncidentReport copyWith({
    String? id,
    String? userId,
    String? location,
    DateTime? date,
    String? time,
    String? category,
    String? description,
    String? reporterType,
    List<String>? mediaFiles,
    String? status,
    String? assignedBody,
    bool? isRead,
  }) {
    return IncidentReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      category: category ?? this.category,
      description: description ?? this.description,
      reporterType: reporterType ?? this.reporterType,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      status: status ?? this.status,
      assignedBody: assignedBody ?? this.assignedBody,
      isRead: isRead ?? this.isRead,
    );
  }

  factory IncidentReport.fromMap(Map<String, dynamic> data, String id) {
    return IncidentReport(
      id: id,
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
  }
}
