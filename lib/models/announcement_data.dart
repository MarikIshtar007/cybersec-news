import 'package:cloud_firestore/cloud_firestore.dart';

enum AnnouncementType { EVENT, ANNOUNCEMENT }

class AnnouncementData {
  late final bool actionBtnDisplay;
  late final String actionBtnRedirect;
  late final String actionBtnText;
  late final String backdrop;
  late final String description;
  late final List<String> images;
  late final String name;
  late final Timestamp timestamp;
  late final String type;

  AnnouncementData(
      {required this.actionBtnDisplay,
      required this.actionBtnRedirect,
      required this.actionBtnText,
      required this.backdrop,
      required this.description,
      required this.images,
      required this.name,
      required this.type,
      required this.timestamp});

  factory AnnouncementData.fromDocumentSnapshot(DocumentSnapshot response) {
    final snapshot = response.data() as Map<String, dynamic>;

    return AnnouncementData(
      actionBtnText: snapshot['action_btn_text'] ?? "",
      actionBtnRedirect: snapshot['action_btn_redirect'] ?? "",
      actionBtnDisplay: snapshot['action_btn'] ?? "",
      backdrop: snapshot['backdrop'] ?? "",
      description: snapshot['description'] ?? "",
      images: (snapshot['images'] as List<dynamic>)
              .map((e) => e.toString())
              .toList() ??
          [],
      type: snapshot['type'] ?? "",
      name: snapshot['name'] ?? "",
      timestamp: snapshot['timestamp'],
    );
  }
}
