import '../../data/document_model.dart';

abstract class DocumentState {}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentsLoaded extends DocumentState {
  final List<DocumentModel> documents;
  DocumentsLoaded(this.documents);
}

class DocumentActionSuccess extends DocumentState {
  final String message;
  DocumentActionSuccess(this.message);
}

class DocumentError extends DocumentState {
  final String message;
  DocumentError(this.message);
}
