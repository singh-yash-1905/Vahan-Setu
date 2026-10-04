abstract class DocumentEvent {}

class FetchExpiringDocuments extends DocumentEvent {
  final int days;
  FetchExpiringDocuments({this.days = 30});
}

class FetchReuploadRequests extends DocumentEvent {}

class AllowReuploadEvent extends DocumentEvent {
  final int documentId;
  AllowReuploadEvent(this.documentId);
}

class RejectReuploadEvent extends DocumentEvent {
  final int documentId;
  RejectReuploadEvent(this.documentId);
}
