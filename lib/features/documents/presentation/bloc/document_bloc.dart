import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/doc_repo/document_repository.dart';

import 'document_event.dart';
import 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository _repository;

  DocumentBloc(this._repository) : super(DocumentInitial()) {
    on<FetchExpiringDocuments>((event, emit) async {
      emit(DocumentLoading());
      try {
        final documents = await _repository.getExpiringSoonDocuments(
          days: event.days,
        );
        emit(DocumentsLoaded(documents));
      } catch (e) {
        emit(DocumentError(e.toString()));
      }
    });

    on<FetchReuploadRequests>((event, emit) async {
      emit(DocumentLoading());
      try {
        final documents = await _repository.getReuploadRequests();
        emit(DocumentsLoaded(documents));
      } catch (e) {
        emit(DocumentError(e.toString()));
      }
    });

    on<AllowReuploadEvent>((event, emit) async {
      try {
        await _repository.allowReupload(event.documentId);
        emit(DocumentActionSuccess('Reupload request approved successfully'));
        // Automatically refresh the list
        add(FetchReuploadRequests());
      } catch (e) {
        emit(DocumentError(e.toString()));
      }
    });

    on<RejectReuploadEvent>((event, emit) async {
      try {
        await _repository.rejectReupload(event.documentId);
        emit(DocumentActionSuccess('Reupload request rejected successfully'));
        // Automatically refresh the list
        add(FetchReuploadRequests());
      } catch (e) {
        emit(DocumentError(e.toString()));
      }
    });
  }
}
