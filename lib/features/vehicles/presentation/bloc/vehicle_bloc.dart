import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/vehicle_repo/vehicle_repository.dart';

import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository _repository;

  VehicleBloc(this._repository) : super(VehicleInitial()) {
    on<FetchVehicles>((event, emit) async {
      emit(VehicleLoading());
      try {
        final vehicles = await _repository.getVehicles();
        emit(VehiclesLoaded(vehicles));
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<FetchVehicleDetails>((event, emit) async {
      emit(VehicleLoading());
      try {
        final vehicle = await _repository.getVehicleById(event.vehicleId);
        emit(VehicleDetailLoaded(vehicleDetail: vehicle));

        add(FetchVehicleChallans(event.vehicleId));
        add(FetchVehicleFastag(event.vehicleId));
        add(FetchVehicleGovernmentCharges(event.vehicleId));
        add(FetchVehicleDocuments(event.vehicleId));
      } catch (e) {
        emit(VehicleError(e.toString()));
      }
    });

    on<FetchVehicleChallans>((event, emit) async {
      if (state is VehicleDetailLoaded) {
        emit((state as VehicleDetailLoaded).copyWith(isChallansLoading: true));
        try {
          final challans = await _repository.getVehicleChallans(
            event.vehicleId,
          );
          if (state is VehicleDetailLoaded) {
            emit(
              (state as VehicleDetailLoaded).copyWith(
                challans: challans,
                isChallansLoading: false,
              ),
            );
          }
        } catch (e) {
          if (state is VehicleDetailLoaded) {
            emit(
              (state as VehicleDetailLoaded).copyWith(isChallansLoading: false),
            );
          }
        }
      }
    });

    on<FetchVehicleFastag>((event, emit) async {
      if (state is VehicleDetailLoaded) {
        // Read state directly inside emit to prevent race conditions
        emit((state as VehicleDetailLoaded).copyWith(isFastagLoading: true));
        try {
          final fastag = await _repository.getVehicleFastag(event.vehicleId);
          if (state is VehicleDetailLoaded) {
            emit(
              (state as VehicleDetailLoaded).copyWith(
                fastag: fastag,
                isFastagLoading: false,
              ),
            );
          }
        } catch (e) {
          if (state is VehicleDetailLoaded) {
            emit(
              (state as VehicleDetailLoaded).copyWith(isFastagLoading: false),
            );
          }
        }
      }
    });

    on<FetchVehicleGovernmentCharges>((event, emit) async {
      if (state is VehicleDetailLoaded) {
        emit(
          (state as VehicleDetailLoaded).copyWith(isGovChargesLoading: true),
        );
        try {
          final charges = await _repository.getVehicleGovernmentCharges(
            event.vehicleId,
          );
          if (state is VehicleDetailLoaded) {
            emit(
              (state as VehicleDetailLoaded).copyWith(
                governmentCharges: charges,
                isGovChargesLoading: false,
              ),
            );
          }
        } catch (e) {
          if (state is VehicleDetailLoaded) {
            emit(
              (state as VehicleDetailLoaded).copyWith(
                isGovChargesLoading: false,
              ),
            );
          }
        }
      }
    });

    on<FetchVehicleDocuments>((event, emit) async {
      if (state is VehicleDetailLoaded) {
        emit((state as VehicleDetailLoaded).copyWith(isDocumentsLoading: true));
        try {
          final docs = await _repository.getVehicleDocuments(event.vehicleId);
          if (state is VehicleDetailLoaded) {
            emit(
              (state as VehicleDetailLoaded).copyWith(
                documents: docs,
                isDocumentsLoading: false,
              ),
            );
          }
        } catch (e) {
          if (state is VehicleDetailLoaded) {
            emit(
              (state as VehicleDetailLoaded).copyWith(
                isDocumentsLoading: false,
              ),
            );
          }
        }
      }
    });
    on<UpdateVehicleFastag>((event, emit) async {
      if (state is VehicleDetailLoaded) {
        final currentState = state as VehicleDetailLoaded;
        emit(currentState.copyWith(isFastagUpdating: true));

        try {
          final updatedFastag = await _repository.updateVehicleFastag(
            event.vehicleId,
            event.updateData,
          );
          emit(
            currentState.copyWith(
              fastag: updatedFastag,
              isFastagUpdating: false,
            ),
          );
        } catch (e) {
          emit(currentState.copyWith(isFastagUpdating: false));
          // Optionally emit a side-effect error state here if needed
        }
      }
    });
  }
}
