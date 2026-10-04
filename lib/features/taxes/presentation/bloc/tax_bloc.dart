import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/tax_repo/tax_repository.dart';

import 'tax_event.dart';
import 'tax_state.dart';

class TaxBloc extends Bloc<TaxEvent, TaxState> {
  final TaxRepository _repository;

  TaxBloc(this._repository) : super(TaxInitial()) {
    on<FetchFleetTaxes>((event, emit) async {
      emit(TaxLoading());
      try {
        final taxes = await _repository.getFleetTaxes(
          vehicleId: event.vehicleId,
          taxType: event.taxType,
          state: event.state,
          status: event.status,
        );
        emit(TaxListLoaded(taxes));
      } catch (e) {
        emit(TaxError(e.toString()));
      }
    });

    on<FetchDueSoonTaxes>((event, emit) async {
      emit(TaxLoading());
      try {
        final taxes = await _repository.getDueSoonTaxes();
        emit(TaxListLoaded(taxes));
      } catch (e) {
        emit(TaxError(e.toString()));
      }
    });

    on<FetchOverdueTaxes>((event, emit) async {
      emit(TaxLoading());
      try {
        final taxes = await _repository.getOverdueTaxes();
        emit(TaxListLoaded(taxes));
      } catch (e) {
        emit(TaxError(e.toString()));
      }
    });

    on<FetchExpiredTaxes>((event, emit) async {
      emit(TaxLoading());
      try {
        final taxes = await _repository.getExpiredTaxes();
        emit(TaxListLoaded(taxes));
      } catch (e) {
        emit(TaxError(e.toString()));
      }
    });

    on<ExportTaxesEvent>((event, emit) async {
      // Typically you don't want to wipe the list state entirely for an export,
      // but for standard BLoC flow without state combination, this represents the action.
      emit(TaxLoading());
      try {
        final exportUrl = await _repository.exportTaxes(
          vehicleId: event.vehicleId,
          taxType: event.taxType,
          state: event.state,
          status: event.status,
        );
        emit(TaxExportSuccess(exportUrl));
      } catch (e) {
        emit(TaxError(e.toString()));
      }
    });
  }
}
